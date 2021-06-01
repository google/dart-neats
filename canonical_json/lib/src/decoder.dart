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

import 'dart:convert' show Converter, utf8;
import 'dart:typed_data' show Uint8List;
import 'utils.dart' show char, RawMapEntry, ensureUint8List;
import 'exceptions.dart' show InvalidCanonicalJsonException;
import 'fast_unorm.dart' show fastNfc;

class CanonicalJsonDecoder extends Converter<List<int>, Object?> {
  @override
  Object? convert(List<int> input) {
    ArgumentError.checkNotNull(input, 'input');
    final data = ensureUint8List(input);
    return Decoder(data).decode();
  }
}

class _InvalidCanonicalJsonException extends InvalidCanonicalJsonException {
  @override
  final List<int> input;
  @override
  final int offset;
  @override
  final String message;

  _InvalidCanonicalJsonException(this.input, this.offset, this.message);
}

bool _isAscii(String s) => s.split('').every((c) => char(c) < 128);

class _RawMapEntry extends RawMapEntry {
  final int offset;
  _RawMapEntry(Uint8List key, Object? value, this.offset) : super(key, value);
}

class Decoder {
  final Uint8List _data;
  int _offset = 0;
  Decoder(this._data);

  bool _try(String constant) {
    assert(_isAscii(constant), 'constant must be ascii');
    if (_data.length < _offset + constant.length) {
      return false;
    }
    for (var i = 0; i < constant.length; i++) {
      if (_data[_offset + i] != constant.codeUnitAt(i)) {
        return false;
      }
    }
    _offset += constant.length;
    return true;
  }

  void _require(String constant, String message) {
    if (!_try(constant)) {
      throw _fail(message);
    }
  }

  InvalidCanonicalJsonException _fail(String message, [int? offset]) =>
      _InvalidCanonicalJsonException(_data, offset ?? _offset, message);

  int get _value => _offset < _data.length ? _data[_offset] : -1;
  int get _peak => _offset + 1 < _data.length ? _data[_offset + 1] : -1;

  Object? decode() {
    final result = _readValue();
    if (_data.length != _offset) {
      throw _fail('expected end of input');
    }
    return result;
  }

  Object? _readValue() {
    // 1-9, leading zeros are not allowed
    if (char('1') <= _value && _value <= char('9')) {
      return _readInt();
    }
    // Handle negative numbers
    if (_try('-')) {
      if (char('1') <= _value && _value <= char('9')) {
        return -_readInt();
      }
      throw _fail('expected number following minus "-"');
    }

    // string, list, map
    if (_value == char('"')) return _readString();
    if (_value == char('[')) return _readList();
    if (_value == char('{')) return _readMap();

    // null, true, false
    if (_try('null')) return null;
    if (_try('true')) return true;
    if (_try('false')) return false;

    if (_value == -1) {
      throw _fail('unexpected end of input');
    }
    throw _fail('unexpected character');
  }

  /// Read an integer, assumes _value is in the range 0-9.
  int _readInt() {
    assert(char('1') <= _value && _value <= char('9'));
    var result = 0;
    do {
      result = result * 10 + _value.toUnsigned(8) - char('0');
      _offset++;
    } while (char('0') <= _value && _value <= char('9'));
    return result;
  }

  /// Read a string as raw bytes (with escaping), assumes _value is `"`.
  Uint8List _readRawString() {
    final start = _offset;
    assert(_value == char('"'));
    _offset++;
    while (_value != char('"') && _value != -1) {
      if (_value == char(r'\')) {
        if (_peak != char('"') && _peak != char(r'\')) {
          throw _fail('backslashes must be escaped in strings');
        }
        _offset++;
      }
      _offset++;
    }
    _require('"', 'string is missing terminating quote "');
    // View of the byte string
    return Uint8List.view(
      _data.buffer,
      _data.offsetInBytes + start + 1,
      (_offset - 1) - (start + 1),
    );
  }

  String _decodeString(Uint8List value, int offset) {
    try {
      final s = utf8
          .decode(value, allowMalformed: false)
          .replaceAll(r'\"', '"')
          .replaceAll(r'\\', r'\');
      if (s != fastNfc(s)) {
        throw _fail('strings must be in unicode normalization form C', offset);
      }
      return s;
    } on FormatException {
      throw _fail('malformed utf-8 encoded string', offset);
    }
  }

  String _readString() {
    final offset = _offset;
    return _decodeString(_readRawString(), offset);
  }

  /// Read a list, assumes _value is `[`.
  List<Object?> _readList() {
    final result = <Object?>[];
    assert(_value == char('['));
    _offset++;
    if (_try(']')) {
      return result;
    }
    do {
      result.add(_readValue());
    } while (_try(','));
    _require(']', 'expected "," or "]" in list');
    return result;
  }

  /// Read a map, assumes value is `{`.
  Map<String, Object?> _readMap() {
    assert(_value == char('{'));
    _offset++;
    if (_try('}')) {
      return <String, Object>{};
    }
    final entries = <_RawMapEntry>[];
    do {
      if (_value != char('"')) {
        throw _fail('expected key in map');
      }
      final key_start = _offset;
      final key = _readRawString();
      _require(':', 'expected ":" separate key and value in map');
      entries.add(_RawMapEntry(key, _readValue(), key_start));
    } while (_try(','));
    _require('}', 'expected "," or "}" in map');
    // Validate that keys are sorted
    for (var i = 1; i < entries.length; i++) {
      if (RawMapEntry.compare(entries[i - 1], entries[i]) > 0) {
        throw _fail('keys in map must be sorted', entries[i].offset);
      }
    }
    // Create object from entries and validate utf-8 encoding of keys.
    final result = <String, Object?>{};
    for (final entry in entries) {
      result[_decodeString(entry.key, entry.offset)] = entry.value;
    }
    return result;
  }
}
