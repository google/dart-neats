// Copyright 2022 Google LLC
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

import 'package:test/test.dart';
import 'package:vendor/src/utils/iterable_ext.dart';

void testStartsWith<T>(
  List<T> value, {
  List<T>? match,
  List<T>? mismatch,
}) {
  if (match != null) {
    test('List<$T>($value).startsWith($match) == true', () {
      expect(
        value.startsWith(match),
        isTrue,
        reason: 'Expected $match to be a prefix of $value',
      );
    });
  }
  if (mismatch != null) {
    test('List<$T>($value).startsWith($mismatch) == false', () {
      expect(
        value.startsWith(mismatch),
        isFalse,
        reason: 'Expected $mismatch to not be a prefix of $value',
      );
    });
  }
}

void main() {
  testStartsWith([1, 2, 3], match: []);
  testStartsWith([1, 2, 3], match: <int>[]);
  testStartsWith([1, 2, 3], match: [1]);
  testStartsWith([1, 2, 3], match: [1, 2]);
  testStartsWith([1, 2, 3], match: [1, 2, 3]);
  testStartsWith([1, 2, 3], mismatch: [1, 2, 3, 4]);
  testStartsWith([1, 2, 3], mismatch: [2, 3, 4]);
  testStartsWith([1, 2, 3], mismatch: [4]);
  testStartsWith([1, 2, 3], mismatch: <String>['a']);

  testStartsWith(['a', 'b', 'c'], match: []);
  testStartsWith(['a', 'b', 'c'], match: <String>[]);
  testStartsWith(['a', 'b', 'c'], match: ['a']);
  testStartsWith(['a', 'b', 'c'], match: ['a', 'b']);
  testStartsWith(['a', 'b', 'c'], match: ['a', 'b', 'c']);
  testStartsWith(['a', 'b', 'c'], mismatch: ['a', 'b', 'c', 'd']);
  testStartsWith(['a', 'b', 'c'], mismatch: ['b', 'c', 'd']);
  testStartsWith(['a', 'b', 'c'], mismatch: ['d']);

  // Mixed types
  testStartsWith([1, 2, 3], match: <String>[]);
  testStartsWith(['a', 'b', 'c'], match: <int>[]);
  testStartsWith(['a', 'b', 'c'], mismatch: <int>[1]);
  testStartsWith(['a', 'b', 'c'], mismatch: <String>['1']);
}
