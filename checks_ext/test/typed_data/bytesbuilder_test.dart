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
import 'package:checks_ext/src/typed_data/bytesbuilder.dart';
import '../util.dart';

void main() {
  group('BytesBuilderChecks', () {
    test('properties extract correct values', () {
      final builder = BytesBuilder()
        ..add([1, 2])
        ..addByte(3);

      check(builder)
        ..length.equals(3)
        ..bytes.deepEquals([1, 2, 3])
        ..isNotEmpty();
    });

    test('isEmpty succeeds when empty', () {
      final builder = BytesBuilder();
      check(builder).isEmpty();
    });

    test('isNotEmpty fails when empty', () {
      final builder = BytesBuilder();
      check(builder).isRejectedBy((it) => it.isNotEmpty(), which: ['is empty']);
    });

    test('isEmpty fails when not empty', () {
      final builder = BytesBuilder()..addByte(1);
      check(
        builder,
      ).isRejectedBy((it) => it.isEmpty(), which: ['is not empty']);
    });
  });
}
