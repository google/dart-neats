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
import 'package:checks_ext/src/typed_data/simd.dart';
import '../util.dart';

void main() {
  group('Float32x4Checks', () {
    test('properties extract correct values', () {
      final v = Float32x4(1.0, 2.0, 3.0, 4.0);
      check(v)
        ..x.equals(1.0)
        ..y.equals(2.0)
        ..z.equals(3.0)
        ..w.equals(4.0);
    });
  });

  group('Float64x2Checks', () {
    test('properties extract correct values', () {
      final v = Float64x2(1.0, 2.0);
      check(v)
        ..x.equals(1.0)
        ..y.equals(2.0);
    });
  });

  group('Int32x4Checks', () {
    test('properties extract correct values', () {
      final v = Int32x4(1, 2, 3, 4);
      check(v)
        ..x.equals(1)
        ..y.equals(2)
        ..z.equals(3)
        ..w.equals(4);
    });
  });
}
