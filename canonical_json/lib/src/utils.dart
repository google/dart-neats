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

import 'dart:convert' show utf8;
import 'dart:math' as math;
import 'dart:typed_data' show Uint8List;

import 'fast_unorm.dart' show fastNfc;

/// Convert ascii [character] to integer.
///
/// This function requires that [character] is a single ascii character.
int char(String character) {
  assert(character.length == 1, 'expected string with a length of 1');
  assert(character.codeUnitAt(0) <= 128, 'expected an ascii character');
  return character.codeUnitAt(0);
}

class RawMapEntry {
  final Uint8List key;
  final Object? value;
  RawMapEntry(this.key, this.value);

  static Iterable<RawMapEntry> fromMap(Map<String, Object?> map) sync* {
    for (final e in map.entries) {
      final s = fastNfc(e.key).replaceAll(r'\', r'\\').replaceAll('"', r'\"');
      final b = utf8.encode(s);
      final k = Uint8List(b.length + 2)
        ..first = char('"')
        ..setAll(1, b)
        ..last = char('"');
      yield RawMapEntry(k, e.value);
    }
  }

  static int compare(RawMapEntry a, RawMapEntry b) {
    final N = math.min(a.key.length, b.key.length);
    for (var i = 0; i < N; i++) {
      final r = a.key[i].compareTo(b.key[i]);
      if (r != 0) {
        return r;
      }
    }
    if (a.key.length < b.key.length) {
      return -1;
    }
    if (b.key.length < a.key.length) {
      return 1;
    }
    return 0;
  }
}

/// Return [data] as [Uint8List] or return a [Uint8List] copy of [data].
///
/// This won't make a clone of [data] if [data] is already a [Uint8List].
Uint8List ensureUint8List(List<int> data) {
  if (data is Uint8List) {
    return data;
  }
  return Uint8List.fromList(data);
}
