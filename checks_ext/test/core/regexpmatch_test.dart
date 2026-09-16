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

import 'package:checks_ext/src/core/regexpmatch.dart';
import '../util.dart';

void main() {
  group('RegExpMatchChecks', () {
    final regExp = RegExp(r'(?<word>\w+) (?<num>\d+)');
    const input = 'hello 42';
    final match = regExp.firstMatch(input)!;

    test('namedGroup extracts named group', () {
      check(match)
        ..namedGroup('word').equals('hello')
        ..namedGroup('num').equals('42');
    });

    test('groupNames returns names', () {
      check(match).groupNames.deepEquals(['word', 'num']);
    });

    testCheckGolden(
      () {
        check(match).namedGroup('word').equals('world');
      },
      '''
# namedGroup failure message golden
Expected: a RegExpMatch that:
  has namedGroup(word) that:
    equals 'world'
Actual: a RegExpMatch that:
  has namedGroup(word) that:
  Actual: 'hello'
  Which: are not equal''',
    );
  });
}
