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

extension DurationChecksExt on Subject<Duration> {
  /// Expects that this duration is greater than [other].
  ///
  /// {@example /example/core/duration/is_greater_than.dart}
  void isGreaterThan(Duration other) => context.expect(
    () => ['is greater than ${prettyPrintDuration(other)}'],
    (actual) {
      if (actual <= other) {
        return Rejection(
          which: [
            'was not greater than ${prettyPrintDuration(other)}',
            'actual was ${prettyPrintDuration(actual)}',
          ],
        );
      }
      return null;
    },
  );

  /// Expects that this duration is less than [other].
  ///
  /// {@example /example/core/duration/is_less_than.dart}
  void isLessThan(Duration other) => context.expect(
    () => ['is less than ${prettyPrintDuration(other)}'],
    (actual) {
      if (actual >= other) {
        return Rejection(
          which: [
            'was not less than ${prettyPrintDuration(other)}',
            'actual was ${prettyPrintDuration(actual)}',
          ],
        );
      }
      return null;
    },
  );

  /// Expects that this duration is greater than or equal to [other].
  void isGreaterOrEqual(Duration other) => context.expect(
    () => ['is greater than or equal to ${prettyPrintDuration(other)}'],
    (actual) {
      if (actual < other) {
        return Rejection(
          which: [
            'was not greater than or equal to ${prettyPrintDuration(other)}',
            'actual was ${prettyPrintDuration(actual)}',
          ],
        );
      }
      return null;
    },
  );

  /// Expects that this duration is less than or equal to [other].
  void isLessOrEqual(Duration other) => context.expect(
    () => ['is less than or equal to ${prettyPrintDuration(other)}'],
    (actual) {
      if (actual > other) {
        return Rejection(
          which: [
            'was not less than or equal to ${prettyPrintDuration(other)}',
            'actual was ${prettyPrintDuration(actual)}',
          ],
        );
      }
      return null;
    },
  );

  /// Expects that this duration is close to [other] within [within].
  ///
  /// {@example /example/core/duration/is_close_to.dart}
  void isCloseTo(Duration other, {required Duration within}) => context.expect(
    () => [
      'is close to ${prettyPrintDuration(other)} within ${prettyPrintDuration(within)}',
    ],
    (actual) {
      final diff = (actual - other).abs();
      if (diff > within) {
        return Rejection(
          which: [
            'differs by ${prettyPrintDuration(diff)}',
            'which is more than ${prettyPrintDuration(within)}',
          ],
        );
      }
      return null;
    },
  );

  static const _negative = (
    positive: 'is negative',
    negative: 'is not negative',
  );

  /// Expects that this duration is negative.
  ///
  /// {@example /example/core/duration/is_negative.dart}
  void isNegative() => expectTrue(_negative, (d) => d.isNegative);

  /// Expects that this duration is not negative.
  void isNotNegative() => expectFalse(_negative, (d) => d.isNegative);

  static const _zero = (positive: 'is zero', negative: 'is not zero');

  /// Expects that this duration is zero.
  ///
  /// {@example /example/core/duration/is_zero.dart}
  void isZero() => expectTrue(_zero, (d) => d == Duration.zero);

  /// Expects that this duration is not zero.
  void isNotZero() => expectFalse(_zero, (d) => d == Duration.zero);

  /// The number of whole days spanned by this duration.
  Subject<int> get inDays =>
      context.nest(() => ['in days'], (d) => Extracted.value(d.inDays));

  /// The number of whole hours spanned by this duration.
  Subject<int> get inHours =>
      context.nest(() => ['in hours'], (d) => Extracted.value(d.inHours));

  /// The number of whole minutes spanned by this duration.
  Subject<int> get inMinutes =>
      context.nest(() => ['in minutes'], (d) => Extracted.value(d.inMinutes));

  /// The number of whole seconds spanned by this duration.
  Subject<int> get inSeconds =>
      context.nest(() => ['in seconds'], (d) => Extracted.value(d.inSeconds));

  /// The number of whole milliseconds spanned by this duration.
  Subject<int> get inMilliseconds => context.nest(
    () => ['in milliseconds'],
    (d) => Extracted.value(d.inMilliseconds),
  );

  /// The number of whole microseconds spanned by this duration.
  Subject<int> get inMicroseconds => context.nest(
    () => ['in microseconds'],
    (d) => Extracted.value(d.inMicroseconds),
  );
}
