// Copyright 2019 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:async';
import 'dart:math';

/// Auxiliary class for iterating over the items in a chunked stream.
///
/// A _chunked stream_ is a stream in which items arrives in chunks with each
/// event from the stream. A common example is a byte stream with the type
/// `Stream<List<int>>`. In such a byte stream bytes arrives in chunks
/// `List<int>` for each event.
///
/// Note. methods on this class may not be called concurrently.
class ChunkedStreamIterator<T> {
  StreamSubscription<List<T>> _subscription;
  bool _isDone = false;
  List<T> _lastChunk;
  Object _error;
  StackTrace _stackTrace;
  void Function() _wakeup;

  List<T> _buffered = [];

  ChunkedStreamIterator._(Stream<List<T>> stream) {
    ArgumentError.checkNotNull(stream, 'stream');

    _subscription = stream.listen((data) {
      _lastChunk = data;
      _wakeup();
    }, onDone: () {
      _isDone = true;
      _wakeup();
    }, onError: (e, st) {
      _error = e;
      _stackTrace = st;
      _wakeup();
    });
    _subscription.pause();
  }

  /// Create a [ChunkedStreamIterator] over [stream].
  factory ChunkedStreamIterator(Stream<List<T>> stream) =>
      ChunkedStreamIterator._(stream);

  void _reset() {
    _wakeup = null;
    if (!_subscription.isPaused) {
      _subscription.pause();
    }
  }

  /// Read a series of chunks from the stream until we have [size] number of
  /// items, then return these items.
  ///
  /// This returns less than [size], if end of stream occurs before [size]
  /// number of items have been received.
  ///
  /// If an error occurs before receiving [size] items, the error will be thrown
  /// and next call to [read] will with data already buffered from before the
  /// error occurred.
  ///
  /// This method may not be called concurrently.
  Future<List<T>> read(int size) async {
    ArgumentError.checkNotNull(size, 'size');
    if (size <= 0) {
      throw ArgumentError.value(size, 'size', 'size must be greater than zero');
    }
    if (_wakeup != null) {
      throw StateError('Concurrent invocations not supported');
    }

    final c = Completer<List<T>>();
    _wakeup = () {
      if (_lastChunk != null) {
        _buffered.addAll(_lastChunk);
        _lastChunk = null;
      }
      if (_buffered.length >= size) {
        c.complete(_buffered.sublist(0, size));
        _buffered = _buffered.sublist(size);
        _reset();
        return;
      }
      if (_error != null) {
        c.completeError(_error, _stackTrace);
        _error = null;
        _stackTrace = null;
        _reset();
        return;
      }
      if (_isDone) {
        c.complete(_buffered);
        _buffered = [];
        _reset();
        return;
      }
    };
    _wakeup();
    if (!c.isCompleted) {
      _subscription.resume();
    }

    return c.future;
  }

  /// Create a sub-[Stream] with the next [size] items.
  ///
  /// The resulting [Stream] must be consumed or canceled before [read] or
  /// [substream] is called again.
  Stream<List<T>> substream(int size) {
    ArgumentError.checkNotNull(size, 'size');
    if (size <= 0) {
      throw ArgumentError.value(size, 'size', 'size must be greater than zero');
    }
    if (_wakeup != null) {
      throw StateError('Concurrent invocations not supported');
    }

    final c = StreamController<List<T>>(
      onListen: _subscription.resume,
      onPause: _subscription.pause,
      onResume: _subscription.resume,
      onCancel: () async {
        // Read the rest of size bytes
        final c = Completer<void>();
        _wakeup = () {
          if (_lastChunk != null) {
            if (_lastChunk.length < size) {
              size -= _lastChunk.length;
            } else {
              _buffered.addAll(_lastChunk.sublist(size));
              size = 0;
            }
            _lastChunk = null;
          }
          if (size <= 0) {
            _reset();
            c.complete();
            return;
          }
          if (_error != null) {
            // Ignore errors, as we're skipping in the stream
            _error = null;
            _stackTrace = null;
          }
          if (_isDone) {
            _reset();
            c.complete();
            return;
          }
        };
        _wakeup();
        await c.future;
      },
    );
    if (_buffered.isNotEmpty) {
      int n = min(size, _buffered.length);
      c.add(_buffered.sublist(0, n));
      _buffered = _buffered.sublist(n);
      size -= n;
    }
    _wakeup = () {
      if (_lastChunk != null) {
        if (_lastChunk.length < size) {
          c.add(_lastChunk);
          size -= _lastChunk.length;
        } else {
          c.add(_lastChunk.sublist(0, size));
          _buffered.addAll(_lastChunk.sublist(size));
          size = 0;
        }
        _lastChunk = null;
      }
      assert(size >= 0, 'size should always be positive');
      if (size == 0) {
        _reset();
        c.close();
        return;
      }
      if (_error != null) {
        c.addError(_error, _stackTrace);
        _error = null;
        _stackTrace = null;
        return;
      }
      if (_isDone) {
        _reset();
        c.close();
        return;
      }
    };
    _wakeup();

    return c.stream;
  }

  /// Cancel reading the stream.
  ///
  /// This may not be called concurrently with [read] or [substream].
  Future<void> cancel() async {
    if (_wakeup != null) {
      throw StateError('Concurrent invocations not supported');
    }

    await _subscription.cancel();
  }
}
