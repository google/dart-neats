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

import 'package:checks_ext/src/core/stringbuffer.dart';
import '../util.dart';

void main() {
  group('StringBufferChecks', () {
    test('properties extract correct values', () {
      final buffer = StringBuffer('hello');
      check(buffer)
        ..asString.equals('hello')
        ..length.equals(5)
        ..isNotEmpty();
    });

    test('isEmpty succeeds when empty', () {
      final buffer = StringBuffer();
      check(buffer).isEmpty();
    });

    test('isNotEmpty succeeds when not empty', () {
      final buffer = StringBuffer('hello');
      check(buffer).isNotEmpty();
    });

    testCheckGolden(
      () {
        final buffer = StringBuffer('hello');
        check(buffer).isEmpty();
      },
      '''
# isEmpty failure message golden
Expected: a StringBuffer that:
  is empty
Actual: <hello>
Which: is not empty''',
    );

    testCheckGolden(
      () {
        final buffer = StringBuffer();
        check(buffer).isNotEmpty();
      },
      '''
# isNotEmpty failure message golden
Expected: a StringBuffer that:
  is not empty
Which: is empty''',
    );
  });
}
