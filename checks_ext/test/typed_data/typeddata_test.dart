// Copyright 2026 Google LLC
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

import 'dart:typed_data';
import 'package:checks_ext/src/typed_data/typeddata.dart';
import '../util.dart';

void main() {
  group('TypedDataChecks', () {
    test('asUint8List extracts correct view respecting offset', () {
      final buffer = Uint8List.fromList([0, 0, 1, 2, 3, 4, 0, 0]).buffer;
      final data = ByteData.view(buffer, 2, 4); // Offset 2, length 4

      check(data).asUint8List.deepEquals([1, 2, 3, 4]);
    });

    test('asInt8List extracts correct view respecting offset', () {
      final buffer = Uint8List.fromList([0, 0, 1, 2, 3, 4, 0, 0]).buffer;
      final data = ByteData.view(buffer, 2, 4); // Offset 2, length 4

      check(data).asInt8List.deepEquals([1, 2, 3, 4]);
    });

    test('asUint16List extracts correct view respecting offset', () {
      final buffer = Uint8List(10).buffer;
      final data = ByteData.view(
        buffer,
        2,
        4,
      ); // Offset 2, length 4 (2 uint16s)

      check(data).asUint16List.has((l) => l.length, 'length').equals(2);
    });

    test('asInt16List extracts correct view respecting offset', () {
      final buffer = Uint8List(10).buffer;
      final data = ByteData.view(buffer, 2, 4);

      check(data).asInt16List.has((l) => l.length, 'length').equals(2);
    });

    test('asUint32List extracts correct view respecting offset', () {
      final buffer = Uint8List(20).buffer;
      final data = ByteData.view(
        buffer,
        4,
        12,
      ); // Offset 4, length 12 (3 uint32s)

      check(data).asUint32List.has((l) => l.length, 'length').equals(3);
    });

    test('asInt32List extracts correct view respecting offset', () {
      final buffer = Uint8List(20).buffer;
      final data = ByteData.view(buffer, 4, 12);

      check(data).asInt32List.has((l) => l.length, 'length').equals(3);
    });

    test('asFloat32List extracts correct view respecting offset', () {
      final buffer = Uint8List(20).buffer;
      final data = ByteData.view(buffer, 4, 12);

      check(data).asFloat32List.has((l) => l.length, 'length').equals(3);
    });

    test('asFloat64List extracts correct view respecting offset', () {
      final buffer = Uint8List(24).buffer;
      final data = ByteData.view(
        buffer,
        8,
        16,
      ); // Offset 8, length 16 (2 float64s)

      check(data).asFloat64List.has((l) => l.length, 'length').equals(2);
    });
  });
}
