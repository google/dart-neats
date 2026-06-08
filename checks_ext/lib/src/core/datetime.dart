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

extension DateTimeChecksExt on Subject<DateTime> {
  /// Expects that this date is after [other].
  ///
  /// {@example /example/core/datetime/is_after.dart}
  void isAfter(DateTime other) =>
      context.expect(() => prefixFirst('is after ', literal(other)), (actual) {
        if (!actual.isAfter(other)) {
          return Rejection(
            which: [...prefixFirst('was not after ', literal(other))],
          );
        }
        return null;
      });

  /// Expects that this date is before [other].
  ///
  /// {@example /example/core/datetime/is_before.dart}
  void isBefore(DateTime other) =>
      context.expect(() => prefixFirst('is before ', literal(other)), (actual) {
        if (!actual.isBefore(other)) {
          return Rejection(
            which: [...prefixFirst('was not before ', literal(other))],
          );
        }
        return null;
      });

  /// Expects that this date is at the same moment as [other].
  ///
  /// {@example /example/core/datetime/is_at_same_moment_as.dart}
  void isAtSameMomentAs(DateTime other) => context.expect(
    () => prefixFirst('is at same moment as ', literal(other)),
    (actual) {
      if (!actual.isAtSameMomentAs(other)) {
        return Rejection(
          which: [...prefixFirst('was not at same moment as ', literal(other))],
        );
      }
      return null;
    },
  );

  /// Expects that this date is in UTC.
  ///
  /// {@example /example/core/datetime/is_utc.dart}
  void isUtc() => expectTrue(_utc, (d) => d.isUtc);

  /// Expects that this date is not in UTC.
  ///
  /// {@example /example/core/datetime/is_not_utc.dart}
  void isNotUtc() => expectFalse(_utc, (d) => d.isUtc);

  static const _utc = (positive: 'is UTC', negative: 'is not in UTC');

  /// The year component of this date.
  ///
  /// {@example /example/core/datetime/year.dart}
  Subject<int> get year => has((d) => d.year, 'year');

  /// The month component of this date.
  ///
  /// {@example /example/core/datetime/month.dart}
  Subject<int> get month => has((d) => d.month, 'month');

  /// The day component of this date.
  ///
  /// {@example /example/core/datetime/day.dart}
  Subject<int> get day => has((d) => d.day, 'day');

  /// The weekday component of this date.
  ///
  /// {@example /example/core/datetime/weekday.dart}
  Subject<int> get weekday => has((d) => d.weekday, 'weekday');

  /// The hour component of this date.
  ///
  /// {@example /example/core/datetime/hour.dart}
  Subject<int> get hour => has((d) => d.hour, 'hour');

  /// The minute component of this date.
  ///
  /// {@example /example/core/datetime/minute.dart}
  Subject<int> get minute => has((d) => d.minute, 'minute');

  /// The second component of this date.
  ///
  /// {@example /example/core/datetime/second.dart}
  Subject<int> get second => has((d) => d.second, 'second');

  /// The microseconds since epoch of this date.
  ///
  /// {@example /example/core/datetime/microseconds_since_epoch.dart}
  Subject<int> get microsecondsSinceEpoch =>
      has((d) => d.microsecondsSinceEpoch, 'microsecondsSinceEpoch');

  /// Extracts the difference between this date and [other].
  ///
  /// {@example /example/core/datetime/difference.dart}
  Subject<Duration> difference(DateTime other) => context.nest(
    () => prefixFirst('difference from ', literal(other)),
    (d) => Extracted.value(d.difference(other)),
  );

  /// Expects that this date is close to [other] within [within].
  ///
  /// {@example /example/core/datetime/is_close_to.dart}
  void isCloseTo(DateTime other, {required Duration within}) => context.expect(
    () => prefixFirst(
      'is close to ',
      postfixLast(' within ${prettyPrintDuration(within)}', literal(other)),
    ),
    (actual) {
      final diff = actual.difference(other).abs();
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

  /// Expects that this date is between [start] and [end].
  ///
  /// {@example /example/core/datetime/is_between.dart}
  void isBetween(DateTime start, DateTime end, {bool inclusive = true}) =>
      context.expect(
        () => [
          ...prefixFirst('is between ', literal(start)),
          ...prefixFirst('and ', literal(end)),
          inclusive ? ' (inclusive)' : ' (exclusive)',
        ],
        (actual) {
          if (inclusive) {
            if (actual.isBefore(start) || actual.isAfter(end)) {
              return Rejection(
                which: [
                  ...prefixFirst('was not between ', literal(start)),
                  ...prefixFirst('and ', literal(end)),
                  ' (inclusive)',
                ],
              );
            }
          } else {
            if (!actual.isAfter(start) || !actual.isBefore(end)) {
              return Rejection(
                which: [
                  ...prefixFirst('was not between ', literal(start)),
                  ...prefixFirst('and ', literal(end)),
                  ' (exclusive)',
                ],
              );
            }
          }
          return null;
        },
      );
}
