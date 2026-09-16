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

import 'package:checks_ext/src/core/string.dart';
import '../util.dart';

void main() {
  group('StringChecks', () {
    test('isBlank succeeds when empty or whitespace', () {
      check('').isBlank();
      check('   ').isBlank();
    });

    test('isBlank fails when not blank', () {
      check(
        '  a  ',
      ).isRejectedBy((it) => it.isBlank(), which: ['was not blank']);
    });

    test('isNotBlank succeeds when not blank', () {
      check('  a  ').isNotBlank();
    });

    test('isNotBlank fails when blank', () {
      check('   ').isRejectedBy((it) => it.isNotBlank(), which: ['was blank']);
    });

    test('lines extracts lines', () {
      check('a\nb\nc').lines.deepEquals(['a', 'b', 'c']);
    });

    test('isLowerCase succeeds when all lower case', () {
      check('abc').isLowerCase();
      check('abc1').isLowerCase();
    });

    test('isLowerCase fails when contains upper case', () {
      check(
        'Abc',
      ).isRejectedBy((it) => it.isLowerCase(), which: ['was not lower case']);
    });

    test('isUpperCase succeeds when all upper case', () {
      check('ABC').isUpperCase();
      check('ABC1').isUpperCase();
    });

    test('isUpperCase fails when contains lower case', () {
      check(
        'Abc',
      ).isRejectedBy((it) => it.isUpperCase(), which: ['was not upper case']);
    });

    test('isCapitalized succeeds when starts with upper case', () {
      check('Abc').isCapitalized();
      check('A').isCapitalized();
    });

    test('isCapitalized fails when starts with lower case or empty', () {
      check('abc').isRejectedBy(
        (it) => it.isCapitalized(),
        which: ['first character was not upper case'],
      );
      check('').isRejectedBy((it) => it.isCapitalized(), which: ['is empty']);
    });

    test('isNumeric succeeds when only digits', () {
      check('123').isNumeric();
    });

    test('isNumeric fails when contains non-digits', () {
      check('12a').isRejectedBy(
        (it) => it.isNumeric(),
        which: ['contains non-numeric characters'],
      );
    });

    test('isAlpha succeeds when only letters', () {
      check('abc').isAlpha();
      check('ABC').isAlpha();
    });

    test('isAlpha fails when contains non-letters', () {
      check('abc1').isRejectedBy(
        (it) => it.isAlpha(),
        which: ['contains non-alphabetic characters'],
      );
    });

    test('isAlphanumeric succeeds when only letters and digits', () {
      check('abc1').isAlphanumeric();
      check('ABC123').isAlphanumeric();
    });

    test('isAlphanumeric fails when contains other characters', () {
      check('abc_1').isRejectedBy(
        (it) => it.isAlphanumeric(),
        which: ['contains characters that are not letters or digits'],
      );
    });

    test('containsIgnoringCase succeeds', () {
      check('Hello World').containsIgnoringCase('world');
      check('Hello World').containsIgnoringCase('WORLD');
      check('Hello World').containsIgnoringCase('hello');
    });

    test('containsIgnoringCase fails', () {
      check('Hello World').isRejectedBy(
        (it) => it.containsIgnoringCase('foo'),
        which: ["does not contain 'foo' (case-insensitive)"],
      );
    });
  });
}
