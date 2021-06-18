/// Minimalistic [RESP[1] protocol implementation in Dart.
///
/// [1]: https://redis.io/topics/protocol
library resp;

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:logging/logging.dart';

final _log = Logger('neat_cache:redis');

class RedisErrorException implements Exception {
  final String type;
  final String message;

  RedisErrorException._(this.type, this.message);

  @override
  String toString() => 'RedisErrorException: $type $message';
}

// If this or IOException occurs, then consider the connection closed and retry it
class RedisConnectionException implements Exception {
  final String message;

  RedisConnectionException._(this.message);

  @override
  String toString() => 'RedisConnectionException: $message';
}

class RespClient {
  static final _newLine = ascii.encode('\r\n');

  /// No value in redis can be more than [512 MB][1].
  ///
  /// [1]: https://redis.io/topics/data-types
  static const _maxValueSize = 512 * 1024 * 1024;

  final _ByteStreamScanner _input;
  final StreamSink<List<int>> _output;

  final _pending = Queue<Completer<Object?>>();

  bool _closing = false;
  final _closed = Completer<void>();

  RespClient(
    Stream<Uint8List> input,
    StreamSink<List<int>> output,
  )   : _input = _ByteStreamScanner(input),
        _output = output {
    scheduleMicrotask(_readInput);
    scheduleMicrotask(() async {
      try {
        await _output.done;
      } catch (e, st) {
        if (!_closing) {
          return await _abort(e, st);
        }
      }
      if (!_closing) {
        await _abort(
          RedisConnectionException._('outgoing connection closed'),
          StackTrace.current,
        );
      }
    });
  }

  Future<void> get closed => _closed.future;

  Future<Object?> command(List<Object> args) {
    if (_closing) {
      throw StateError('redis connection is closed');
    }

    final out = BytesBuilder(copy: false);
    out.addByte('*'.codeUnitAt(0));
    out.add(ascii.encode(args.length.toString()));
    out.add(_newLine);
    for (final arg in args) {
      List<int> bytes;
      if (arg is String) {
        bytes = utf8.encode(arg);
      } else if (arg is List<int>) {
        bytes = arg;
      } else if (arg is int) {
        bytes = ascii.encode(arg.toString());
      } else {
        throw ArgumentError.value(
          args,
          'args',
          'arguments for redis must be String, List<int>, int',
        );
      }

      out.addByte(r'$'.codeUnitAt(0));
      out.add(ascii.encode(bytes.length.toString()));
      out.add(_newLine);
      out.add(bytes);
      out.add(_newLine);
    }

    _output.add(out.toBytes());
    final c = Completer<Object?>();
    _pending.addLast(c);
    return c.future;
  }

  Future<void> close({bool force = false}) async {
    _closing = true;

    if (!force) {
      scheduleMicrotask(() async {
        await _output.close().catchError((_) {/* ignore */});
      });
      await _closed.future;
    } else {
      await _output.close().catchError((_) {/* ignore */});

      // Resolve all outstanding requests
      final pending = _pending.toList(growable: false);
      _pending.clear();
      final e = RedisConnectionException._('redis client forcibly closed');
      final st = StackTrace.current;
      pending.forEach((c) => c.completeError(e, st));
    }
    await _input.cancel();

    assert(_pending.isEmpty, 'new pending requests added after close()');
  }

  /// Abort due to internal error
  Future<void> _abort(Object e, StackTrace st) async {
    if (!_closing) {
      _log.warning('redis connection broken:', e, st);
    }

    _closing = true;

    // Resolve all outstanding requests
    final pending = _pending.toList(growable: false);
    _pending.clear();
    pending.forEach((c) => c.completeError(e, st));

    _closed.complete();
    await _input.cancel();

    assert(_pending.isEmpty, 'new pending requests added after aborting');
  }

  void _readInput() async {
    try {
      while (true) {
        Object? value;
        try {
          value = await _readValue();
        } on IOException catch (e, st) {
          return await _abort(e, st);
        } on RedisConnectionException catch (e, st) {
          return await _abort(e, st);
        }
        if (_pending.isEmpty) {
          return await _abort(
            RedisConnectionException._('unexpected value from server'),
            StackTrace.current,
          );
        }
        final c = _pending.removeFirst();
        if (value is RedisErrorException) {
          // This is an error code returned by the server, it doesn't have a
          // stack-trace!
          c.completeError(value, StackTrace.empty);
        } else {
          c.complete(value);
        }

        if (_closing && _pending.isEmpty) {
          return _closed.complete();
        }
      }
    } catch (e, st) {
      _log.shout('internal redis client error:', e, st);
      await _abort(
        RedisConnectionException._('internal redis client error: $e'),
        st,
      );
    }
  }

  Future<Object?> _readValue() async {
    final line = await _input.readLine(maxSize: _maxValueSize);
    if (line.isEmpty) {
      throw RedisConnectionException._('Incoming stream from server closed');
    }
    print('GOT LINE: ${ascii.decode(line)}');
    if (!_endsWithNewLine(line)) {
      throw RedisConnectionException._(
        'Invalid server message: missing newline',
      );
    }
    final type = line[0];
    final rest = Uint8List.sublistView(line, 1, line.length - 2);

    // Handle simple strings
    if (type == '+'.codeUnitAt(0)) {
      try {
        return utf8.decode(rest);
      } on FormatException catch (e) {
        throw RedisConnectionException._(
          'Invalid simple string from server: $e',
        );
      }
    }

    // Handle errors
    if (type == '-'.codeUnitAt(0)) {
      final message = utf8.decode(
        rest,
        allowMalformed: true,
      );
      final i = message.indexOf(RegExp(r'\s'));
      if (i != -1 && i + 1 < message.length) {
        return RedisErrorException._(
          message.substring(0, i),
          message.substring(i + 1),
        );
      }
      return RedisErrorException._('ERR', message);
    }

    // Handle integers
    if (type == ':'.codeUnitAt(0)) {
      int value;
      try {
        value = int.parse(ascii.decode(rest));
      } on FormatException catch (e) {
        throw RedisConnectionException._(
          'Invalid integer from server: $e',
        );
      }
      if (value < 0) {
        throw RedisConnectionException._(
          'Invalid integer from server: value < 0',
        );
      }
      return value;
    }

    // Handle bulk strings (binary blobs)
    if (type == r'$'.codeUnitAt(0)) {
      int length;
      try {
        length = int.parse(ascii.decode(rest));
      } on FormatException catch (e) {
        throw RedisConnectionException._(
          'Invalid bulk string length from server: $e',
        );
      }
      if (length == -1) {
        return null; // Special case for nil value
      }
      if (length < 0 || length > _maxValueSize) {
        throw RedisConnectionException._(
          'Invalid bulk string length from server: $length',
        );
      }
      final bytes = await _input.readBytes(length + 2);
      if (bytes.length != length + 2) {
        throw RedisConnectionException._('Incoming stream from server closed');
      }
      if (!_endsWithNewLine(bytes)) {
        throw RedisConnectionException._('Invalid bulk string from server');
      }
      return Uint8List.sublistView(bytes, 0, length - 2);
    }

    // Handle arrays
    if (type == '*'.codeUnitAt(0)) {
      int length;
      try {
        length = int.parse(ascii.decode(rest));
      } on FormatException catch (e) {
        throw RedisConnectionException._(
          'Invalid array length from server: $e',
        );
      }
      if (length == -1) {
        return null; // Special case for nil value
      }
      if (length < 0) {
        throw RedisConnectionException._(
          'Invalid array length from server: $length',
        );
      }
      final values = <Object?>[];
      for (var i = 0; i < length; i++) {
        values.add(await _readValue());
      }
      return values;
    }

    throw RedisConnectionException._(
      'Unknown type from server: ${String.fromCharCode(type)}',
    );
  }
}

bool _endsWithNewLine(Uint8List line) {
  final N = line.length;
  return (N >= 2 &&
      line[N - 2] == '\r'.codeUnitAt(0) &&
      line[N - 1] == '\n'.codeUnitAt(0));
}

/// An stream wrapper for reading line-by-line or reading N bytes.
class _ByteStreamScanner {
  static final _emptyList = Uint8List.fromList([]);

  final StreamIterator<Uint8List> _input;
  Uint8List _buffer = _emptyList;

  _ByteStreamScanner(Stream<Uint8List> stream)
      : _input = StreamIterator(stream);

  /// Read a single byte, return zero if stream has ended.
  Future<int?> readByte() async {
    final bytes = await readBytes(1);
    if (bytes.isEmpty) {
      return null;
    }
    return bytes[0];
  }

  /// Read up to [size] bytes from stream, returns less than [size] bytes if
  /// stream ends before [size] bytes are read.
  Future<Uint8List> readBytes(int size) async {
    RangeError.checkNotNegative(size, 'size');

    final out = BytesBuilder(copy: false);
    while (size > 0) {
      if (_buffer.isEmpty) {
        if (!(await _input.moveNext())) {
          // Don't attempt to read more data, as there is no more data.
          break;
        }
        _buffer = _input.current;
      }

      if (_buffer.isNotEmpty) {
        if (size < _buffer.length) {
          out.add(Uint8List.sublistView(_buffer, 0, size));
          _buffer = Uint8List.sublistView(_buffer, size);
          break;
        }

        out.add(_buffer);
        size -= _buffer.length;
        _buffer = _emptyList;
      }
    }

    return out.toBytes();
  }

  /// Read until the next `\n` inclusive.
  ///
  /// Throws [RedisConnectionException] if [maxSize] is exceeded.
  Future<Uint8List> readLine({int? maxSize}) async {
    if (maxSize != null) {
      RangeError.checkNotNegative(maxSize, 'maxSize');
    }

    final out = BytesBuilder(copy: false);
    while (true) {
      if (_buffer.isEmpty) {
        if (!(await _input.moveNext())) {
          print('NO MORE DATA!');
          // Don't attempt to read more data, as there is no more data.
          break;
        }
        _buffer = _input.current;
      }

      if (_buffer.isNotEmpty) {
        final i = _buffer.indexOf('\n'.codeUnitAt(0));
        if (i != -1) {
          out.add(Uint8List.sublistView(_buffer, 0, i + 1));
          _buffer = Uint8List.sublistView(_buffer, i + 1);
          break;
        }

        out.add(_buffer);
        _buffer = _emptyList;
      }

      if (maxSize != null && out.length > maxSize) {
        throw RedisConnectionException._('Line exceeds maxSize: $maxSize');
      }
    }

    return out.toBytes();
  }

  /// Cancel underlying stream, ending it prematurely.
  Future<void> cancel() async => await _input.cancel();
}
