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

import 'package:checks_ext/src/core/datetime.dart';
import '../util.dart';

void main() {
  group('DateTimeChecks', () {
    final now = DateTime.utc(2020, 1, 2);
    final past = DateTime.utc(2020, 1, 1);
    final future = DateTime.utc(2020, 1, 3);

    test('isAfter succeeds', () {
      check(future).isAfter(now);
    });

    test('isAfter fails', () {
      check(past).isRejectedBy(
        (it) => it.isAfter(now),
        which: ['was not after <2020-01-02 00:00:00.000Z>'],
      );
    });

    test('isBefore succeeds', () {
      check(past).isBefore(now);
    });

    test('isBefore fails', () {
      check(future).isRejectedBy(
        (it) => it.isBefore(now),
        which: ['was not before <2020-01-02 00:00:00.000Z>'],
      );
    });

    test('isAtSameMomentAs succeeds', () {
      check(now).isAtSameMomentAs(now);
    });

    test('isAtSameMomentAs fails', () {
      check(past).isRejectedBy(
        (it) => it.isAtSameMomentAs(now),
        which: ['was not at same moment as <2020-01-02 00:00:00.000Z>'],
      );
    });

    test('isUtc succeeds', () {
      check(DateTime.utc(2020)).isUtc();
    });

    test('isUtc fails', () {
      check(
        DateTime(2020),
      ).isRejectedBy((it) => it.isUtc(), which: ['is not in UTC']);
    });

    test('isNotUtc succeeds', () {
      check(DateTime(2020)).isNotUtc();
    });

    test('isNotUtc fails', () {
      check(
        DateTime.utc(2020),
      ).isRejectedBy((it) => it.isNotUtc(), which: ['is UTC']);
    });

    test('year extracts year', () {
      check(DateTime(2020)).year.equals(2020);
    });

    test('weekday extracts weekday', () {
      // 2020-01-01 was Wednesday (3)
      check(DateTime.utc(2020, 1, 1)).weekday.equals(3);
    });

    test('difference calculates duration', () {
      check(future).difference(now).equals(Duration(days: 1));
    });

    test('isCloseTo succeeds', () {
      final d1 = DateTime.utc(2020, 1, 1, 10, 0, 0);
      final d2 = DateTime.utc(2020, 1, 1, 10, 0, 5);
      check(d2).isCloseTo(d1, within: Duration(seconds: 10));
    });

    testCheckGolden(
      () {
        final d1 = DateTime.utc(2020, 1, 1, 10, 0, 0);
        final d2 = DateTime.utc(2020, 1, 1, 10, 0, 15);
        check(d2).isCloseTo(d1, within: Duration(seconds: 10));
      },
      '''
# isCloseTo failure message golden
Expected: a DateTime that:
  is close to <2020-01-01 10:00:00.000Z> within 10s
Actual: <2020-01-01 10:00:15.000Z>
Which: differs by 15s
which is more than 10s''',
    );

    test('isBetween succeeds (inclusive)', () {
      final start = DateTime.utc(2020, 1, 1);
      final end = DateTime.utc(2020, 1, 3);
      check(DateTime.utc(2020, 1, 2)).isBetween(start, end);
      check(start).isBetween(start, end);
      check(end).isBetween(start, end);
    });

    test('isBetween succeeds (exclusive)', () {
      final start = DateTime.utc(2020, 1, 1);
      final end = DateTime.utc(2020, 1, 3);
      check(DateTime.utc(2020, 1, 2)).isBetween(start, end, inclusive: false);
    });

    testCheckGolden(
      () {
        final start = DateTime.utc(2020, 1, 1);
        final end = DateTime.utc(2020, 1, 3);
        check(start).isBetween(start, end, inclusive: false);
      },
      '''
# isBetween failure message golden
Expected: a DateTime that:
  is between <2020-01-01 00:00:00.000Z>
  and <2020-01-03 00:00:00.000Z>
   (exclusive)
Actual: <2020-01-01 00:00:00.000Z>
Which: was not between <2020-01-01 00:00:00.000Z>
and <2020-01-03 00:00:00.000Z>
 (exclusive)''',
    );

    testCheckGolden(
      () {
        check(past).isAfter(now);
      },
      '''
# isAfter failure message golden
Expected: a DateTime that:
  is after <2020-01-02 00:00:00.000Z>
Actual: <2020-01-01 00:00:00.000Z>
Which: was not after <2020-01-02 00:00:00.000Z>''',
    );
  });
}
