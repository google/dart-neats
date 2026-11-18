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

import '../util.dart';

extension NumChecksExt on Subject<num> {
  /// Expects that the number is strictly greater than 0.
  ///
  /// {@example /example/core/num/is_strictly_positive.dart}
  void isStrictlyPositive() {
    context.expect(() => ['is strictly positive'], (actual) {
      if (actual <= 0) {
        return Rejection(which: ['is not strictly positive']);
      }
      return null;
    });
  }

  /// Expects that the number is strictly less than 0.
  void isStrictlyNegative() {
    context.expect(() => ['is strictly negative'], (actual) {
      if (actual >= 0) {
        return Rejection(which: ['is not strictly negative']);
      }
      return null;
    });
  }

  /// Expects that the number is between [min] and [max].
  ///
  /// {@example /example/core/num/is_between.dart}
  void isBetween(num min, num max, {bool inclusive = true}) {
    context.expect(
      () => [
        ...prefixFirst('is between ', literal(min)),
        ...prefixFirst('and ', literal(max)),
        inclusive ? ' (inclusive)' : ' (exclusive)',
      ],
      (actual) {
        if (inclusive) {
          if (actual < min || actual > max) {
            return Rejection(
              which: [
                ...prefixFirst('is not between ', literal(min)),
                ...prefixFirst('and ', literal(max)),
                ' (inclusive)',
              ],
            );
          }
        } else {
          if (actual <= min || actual >= max) {
            return Rejection(
              which: [
                ...prefixFirst('is not between ', literal(min)),
                ...prefixFirst('and ', literal(max)),
                ' (exclusive)',
              ],
            );
          }
        }
        return null;
      },
    );
  }
}

extension IntChecksExt on Subject<int> {
  /// Expects that the integer is even.
  ///
  /// {@example /example/core/num/is_even.dart}
  void isEven() {
    context.expect(() => ['is even'], (actual) {
      if (actual % 2 != 0) {
        return Rejection(which: ['is odd']);
      }
      return null;
    });
  }

  /// Expects that the integer is odd.
  void isOdd() {
    context.expect(() => ['is odd'], (actual) {
      if (actual % 2 == 0) {
        return Rejection(which: ['is even']);
      }
      return null;
    });
  }

  /// Expects that the integer is a multiple of [factor].
  ///
  /// {@example /example/core/num/is_multiple_of.dart}
  void isMultipleOf(int factor) {
    context.expect(() => prefixFirst('is multiple of ', literal(factor)), (
      actual,
    ) {
      if (actual % factor != 0) {
        return Rejection(
          which: [...prefixFirst('is not a multiple of ', literal(factor))],
        );
      }
      return null;
    });
  }

  /// Expects that the integer is divisible by [factor].
  ///
  /// {@example /example/core/num/is_multiple_of.dart}
  void isDivisibleBy(int factor) => isMultipleOf(factor);
}
