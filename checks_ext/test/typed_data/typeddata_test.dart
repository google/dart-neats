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


    test('asByteData extracts correct view respecting offset', () {
      final buffer = Uint8List.fromList([0, 0, 1, 2, 3, 4, 0, 0]).buffer;
      final data = ByteData.view(buffer, 2, 4); // Offset 2, length 4

      check(data).asByteData.has((b) => b.lengthInBytes, 'lengthInBytes').equals(4);
      check(data).asByteData.has((b) => b.getUint8(0), 'first byte').equals(1);
    });
  });
}
