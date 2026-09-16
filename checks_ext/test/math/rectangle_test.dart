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
import 'package:checks_ext/src/math/rectangle.dart';
import '../util.dart';

void main() {
  group('RectangleChecks', () {
    test('properties extract correct values', () {
      final rectangle = Rectangle(0, 0, 10, 20);
      check(rectangle)
        ..left.equals(0)
        ..top.equals(0)
        ..width.equals(10)
        ..height.equals(20)
        ..right.equals(10)
        ..bottom.equals(20);
    });

    test('containsPoint succeeds when inside', () {
      final rectangle = Rectangle(0, 0, 10, 20);
      check(rectangle).containsPoint(Point(5, 5));
    });

    testCheckGolden(
      () {
        final rectangle = Rectangle(0, 0, 10, 20);
        check(rectangle).containsPoint(Point(15, 5));
      },
      '''
# containsPoint failure message golden
Expected: a Rectangle<int> that:
  contains point <Point(15, 5)>
Actual: <Rectangle (0, 0) 10 x 20>
Which: does not contain point <Point(15, 5)>''',
    );
    test('containsRectangle succeeds when inside', () {
      final rectangle = Rectangle(0, 0, 10, 20);
      check(rectangle).containsRectangle(Rectangle(2, 2, 5, 5));
    });

    testCheckGolden(
      () {
        final rectangle = Rectangle(0, 0, 10, 20);
        check(rectangle).containsRectangle(Rectangle(5, 5, 10, 10));
      },
      '''
# containsRectangle failure message golden
Expected: a Rectangle<int> that:
  contains rectangle <Rectangle (5, 5) 10 x 10>
Actual: <Rectangle (0, 0) 10 x 20>
Which: does not contain rectangle <Rectangle (5, 5) 10 x 10>''',
    );
  });
}
