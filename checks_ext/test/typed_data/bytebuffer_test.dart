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
import 'package:checks_ext/src/typed_data/bytebuffer.dart';
import '../util.dart';

void main() {
  group('ByteBufferChecks', () {
    test('properties extract correct values', () {
      final list = Uint8List.fromList([1, 2, 3, 4]);
      final buffer = list.buffer;

      check(buffer)
        ..lengthInBytes.equals(4)
        ..asUint8List().deepEquals([1, 2, 3, 4]);
    });

    test('asUint8List with offset and length', () {
      final list = Uint8List.fromList([1, 2, 3, 4]);
      final buffer = list.buffer;

      check(buffer).asUint8List(1, 2).deepEquals([2, 3]);
    });

    test('asInt8List extracts correct values', () {
      final list = Int8List.fromList([-1, -2, 3, 4]);
      final buffer = list.buffer;

      check(buffer).asInt8List().deepEquals([-1, -2, 3, 4]);
    });
  });
}
