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

import 'package:checks_ext/src/util.dart';
import 'util.dart';

void main() {
  group('ExpectExtension', () {
    const desc = (positive: 'is positive', negative: 'is negative');

    group('expectTrue', () {
      test('succeeds when predicate returns true', () {
        check(1).expectTrue(desc, (x) => x > 0);
      });

      test('fails when predicate returns false', () {
        check(-1).isRejectedBy(
          (it) => it.expectTrue(desc, (x) => x > 0),
          which: ['is negative'],
        );
      });
    });

    group('expectFalse', () {
      test('succeeds when predicate returns false', () {
        check(-1).expectFalse(desc, (x) => x > 0);
      });

      test('fails when predicate returns true', () {
        check(1).isRejectedBy(
          (it) => it.expectFalse(desc, (x) => x > 0),
          which: ['is positive'],
        );
      });

      testCheckGolden(
        () {
          check(1).expectFalse(desc, (x) => x > 0);
        },
        '''
# expectFalse failure message golden
Expected: a int that:
  is negative
Actual: <1>
Which: is positive''',
      );
    });
  });

  group('prettyPrintDuration', () {
    test('formats zero', () {
      check(prettyPrintDuration(Duration.zero)).equals('0s');
    });

    test('formats days and hours', () {
      check(
        prettyPrintDuration(Duration(days: 3, hours: 5)),
      ).equals('3 days 5 hours');
    });

    test('formats minutes and seconds', () {
      check(
        prettyPrintDuration(Duration(minutes: 5, seconds: 30)),
      ).equals('5m 30s');
    });

    test('formats milliseconds and microseconds', () {
      check(
        prettyPrintDuration(Duration(milliseconds: 500, microseconds: 500)),
      ).equals('500ms 500us');
    });

    test('formats negative duration', () {
      check(prettyPrintDuration(Duration(seconds: -30))).equals('-30s');
    });

    test('omits zero components', () {
      check(
        prettyPrintDuration(Duration(days: 1, seconds: 30)),
      ).equals('1 day 30s');
    });
  });
}
