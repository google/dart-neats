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

import 'package:checks_ext/src/core/duration.dart';
import '../util.dart';

void main() {
  group('DurationChecks', () {
    test('isGreaterThan succeeds', () {
      check(Duration(seconds: 10)).isGreaterThan(Duration(seconds: 5));
    });

    test('isGreaterThan fails', () {
      check(Duration(seconds: 5)).isRejectedBy(
        (it) => it.isGreaterThan(Duration(seconds: 10)),
        which: ['was not greater than 10s', 'actual was 5s'],
      );
    });

    test('isLessThan succeeds', () {
      check(Duration(seconds: 5)).isLessThan(Duration(seconds: 10));
    });

    test('isLessThan fails', () {
      check(Duration(seconds: 10)).isRejectedBy(
        (it) => it.isLessThan(Duration(seconds: 5)),
        which: ['was not less than 5s', 'actual was 10s'],
      );
    });

    test('isGreaterOrEqual succeeds', () {
      check(Duration(seconds: 10)).isGreaterOrEqual(Duration(seconds: 5));
      check(Duration(seconds: 5)).isGreaterOrEqual(Duration(seconds: 5));
    });

    test('isGreaterOrEqual fails', () {
      check(Duration(seconds: 5)).isRejectedBy(
        (it) => it.isGreaterOrEqual(Duration(seconds: 10)),
        which: ['was not greater than or equal to 10s', 'actual was 5s'],
      );
    });

    test('isLessOrEqual succeeds', () {
      check(Duration(seconds: 5)).isLessOrEqual(Duration(seconds: 10));
      check(Duration(seconds: 5)).isLessOrEqual(Duration(seconds: 5));
    });

    test('isLessOrEqual fails', () {
      check(Duration(seconds: 10)).isRejectedBy(
        (it) => it.isLessOrEqual(Duration(seconds: 5)),
        which: ['was not less than or equal to 5s', 'actual was 10s'],
      );
    });

    test('isCloseTo succeeds', () {
      check(
        Duration(seconds: 12),
      ).isCloseTo(Duration(seconds: 10), within: Duration(seconds: 5));
    });

    test('isCloseTo fails', () {
      check(Duration(seconds: 20)).isRejectedBy(
        (it) =>
            it.isCloseTo(Duration(seconds: 10), within: Duration(seconds: 5)),
        which: ['differs by 10s', 'which is more than 5s'],
      );
    });

    test('isZero succeeds', () {
      check(Duration.zero).isZero();
    });

    test('isZero fails', () {
      check(
        Duration(seconds: 1),
      ).isRejectedBy((it) => it.isZero(), which: ['is not zero']);
    });

    testCheckGolden(
      () {
        check(Duration(seconds: 5)).isGreaterThan(Duration(seconds: 10));
      },
      '''
# isGreaterThan failure message golden
Expected: a Duration that:
  is greater than 10s
Actual: <0:00:05.000000>
Which: was not greater than 10s
actual was 5s''',
    );

    test('inDays extracts total days', () {
      check(Duration(hours: 48)).inDays.equals(2);
    });

    test('inHours extracts total hours', () {
      check(Duration(days: 2)).inHours.equals(48);
    });

    test('inMinutes extracts total minutes', () {
      check(Duration(hours: 2)).inMinutes.equals(120);
    });

    test('inSeconds extracts total seconds', () {
      check(Duration(minutes: 2)).inSeconds.equals(120);
    });

    test('inMilliseconds extracts total milliseconds', () {
      check(Duration(seconds: 2)).inMilliseconds.equals(2000);
    });

    test('inMicroseconds extracts total microseconds', () {
      check(Duration(milliseconds: 2)).inMicroseconds.equals(2000);
    });

    testCheckGolden(
      () {
        check(Duration(hours: 24)).inDays.equals(2);
      },
      '''
# inDays failure message golden
Expected: a Duration that:
  in days that:
    equals <2>
Actual: a Duration that:
  in days that:
  Actual: <1>
  Which: are not equal''',
    );

    testCheckGolden(
      () {
        check(
          Duration(seconds: 20),
        ).isCloseTo(Duration(seconds: 10), within: Duration(seconds: 5));
      },
      '''
# isCloseTo failure message golden
Expected: a Duration that:
  is close to 10s within 5s
Actual: <0:00:20.000000>
Which: differs by 10s
which is more than 5s''',
    );
  });
}
