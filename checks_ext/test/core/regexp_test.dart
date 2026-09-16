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

import 'package:checks_ext/src/core/regexp.dart';
import '../util.dart';

void main() {
  group('RegExpChecks', () {
    test('properties extract correct values', () {
      final regExp = RegExp(r'a', caseSensitive: false, multiLine: true);
      check(regExp)
        ..pattern.equals('a')
        ..isCaseSensitive.isFalse()
        ..isMultiLine.isTrue();
    });

    test('firstMatch extracts first match', () {
      final regExp = RegExp(r'a');
      check(
        regExp,
      ).firstMatch('banana').isNotNull().has((m) => m.start, 'start').equals(1);
    });

    test('allMatches extracts all matches', () {
      final regExp = RegExp(r'a');
      check(
        regExp,
      ).allMatches('banana').has((it) => it.length, 'length').equals(3);
    });

    test('hasMatch succeeds when matching', () {
      final regExp = RegExp(r'a');
      check(regExp).hasMatch('banana');
    });

    test('hasMatch fails when not matching', () {
      final regExp = RegExp(r'z');
      check(regExp).isRejectedBy(
        (it) => it.hasMatch('banana'),
        which: ["does not match 'banana'"],
      );
    });

    test('hasNoMatch succeeds when not matching', () {
      final regExp = RegExp(r'z');
      check(regExp).hasNoMatch('banana');
    });

    testCheckGolden(
      () {
        final regExp = RegExp(r'a');
        check(regExp).hasNoMatch('banana');
      },
      '''
# hasNoMatch failure message golden
Expected: a RegExp that:
  does not match 'banana'
Actual: <RegExp: pattern=a flags=>
Which: matched 'a' at index 1:
banana
 ^''',
    );

    testCheckGolden(
      () {
        final regExp = RegExp(r'a');
        check(regExp).hasNoMatch('line1\nline2 with a\nline3');
      },
      '''
# hasNoMatch failure message golden with multiline
Expected: a RegExp that:
  does not match 'line1
  line2 with a
  line3'
Actual: <RegExp: pattern=a flags=>
Which: matched 'a' at index 17:
line2 with a
           ^''',
    );
  });
}
