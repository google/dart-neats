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

import 'package:checks_ext/src/core/num.dart';
import '../util.dart';

void main() {
  group('NumChecks', () {
    test('isStrictlyPositive succeeds for positive numbers', () {
      check(1).isStrictlyPositive();
      check(0.5).isStrictlyPositive();
    });

    test('isStrictlyPositive fails for zero and negative numbers', () {
      check(0).isRejectedBy(
        (it) => it.isStrictlyPositive(),
        which: ['is not strictly positive'],
      );
      check(-1).isRejectedBy(
        (it) => it.isStrictlyPositive(),
        which: ['is not strictly positive'],
      );
    });

    test('isStrictlyNegative succeeds for negative numbers', () {
      check(-1).isStrictlyNegative();
      check(-0.5).isStrictlyNegative();
    });

    test('isStrictlyNegative fails for zero and positive numbers', () {
      check(0).isRejectedBy(
        (it) => it.isStrictlyNegative(),
        which: ['is not strictly negative'],
      );
      check(1).isRejectedBy(
        (it) => it.isStrictlyNegative(),
        which: ['is not strictly negative'],
      );
    });

    test('isBetween succeeds within range', () {
      check(1).isBetween(0, 2);
      check(0).isBetween(0, 2, inclusive: true);
      check(2).isBetween(0, 2, inclusive: true);
    });

    test('isBetween fails outside range', () {
      check(3).isRejectedBy(
        (it) => it.isBetween(0, 2),
        which: ['is not between <0>', 'and <2>', ' (inclusive)'],
      );
      check(0).isRejectedBy(
        (it) => it.isBetween(0, 2, inclusive: false),
        which: ['is not between <0>', 'and <2>', ' (exclusive)'],
      );
    });
  });

  group('IntChecks', () {
    test('isEven succeeds for even numbers', () {
      check(2).isEven();
      check(0).isEven();
      check(-2).isEven();
    });

    test('isEven fails for odd numbers', () {
      check(1).isRejectedBy((it) => it.isEven(), which: ['is odd']);
    });

    test('isOdd succeeds for odd numbers', () {
      check(1).isOdd();
      check(-1).isOdd();
    });

    test('isOdd fails for even numbers', () {
      check(2).isRejectedBy((it) => it.isOdd(), which: ['is even']);
    });

    test('isMultipleOf succeeds when divisible', () {
      check(4).isMultipleOf(2);
      check(0).isMultipleOf(5);
    });

    test('isMultipleOf fails when not divisible', () {
      check(3).isRejectedBy(
        (it) => it.isMultipleOf(2),
        which: ['is not a multiple of <2>'],
      );
    });

    test('isDivisibleBy is alias for isMultipleOf', () {
      check(4).isDivisibleBy(2);
      check(3).isRejectedBy(
        (it) => it.isDivisibleBy(2),
        which: ['is not a multiple of <2>'],
      );
    });
  });
}
