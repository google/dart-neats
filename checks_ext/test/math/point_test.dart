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

import 'dart:math';
import 'package:checks_ext/src/math/point.dart';
import '../util.dart';

void main() {
  group('PointChecks', () {
    test('properties extract correct values', () {
      final point = Point(3, 4);
      check(point)
        ..x.equals(3)
        ..y.equals(4)
        ..magnitude.equals(5.0);
    });
  });
}
