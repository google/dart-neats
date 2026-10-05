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
import 'package:checks_ext/src/typed_data/bytedata.dart';
import '../util.dart';

void main() {
  group('ByteDataChecks', () {
    test('properties extract correct values', () {
      final data = ByteData(10);
      check(data).lengthInBytes.equals(10);
    });

    test('float32At extracts correct value', () {
      final data = ByteData(4);
      data.setFloat32(0, 1.5, Endian.little);
      check(data).float32At(0).equals(1.5);

      data.setFloat32(0, 1.5, Endian.big);
      check(data).float32At(0, Endian.big).equals(1.5);
    });

    test('uint32At extracts correct value', () {
      final data = ByteData(4);
      data.setUint32(0, 42, Endian.little);
      check(data).uint32At(0).equals(42);
    });

    test('uint16At extracts correct value', () {
      final data = ByteData(2);
      data.setUint16(0, 42, Endian.little);
      check(data).uint16At(0).equals(42);
    });

    test('uint8At extracts correct value', () {
      final data = ByteData(1);
      data.setUint8(0, 42);
      check(data).uint8At(0).equals(42);
    });

    test('respects offsetInBytes', () {
      final buffer = Uint8List(10).buffer;
      final data = ByteData.view(buffer, 2, 4); // Offset 2, length 4
      data.setUint8(0, 42); // Sets byte at index 2 in buffer

      check(data).uint8At(0).equals(42);
    });
  });
}
