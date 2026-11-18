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

import 'package:checks_ext/src/core/enum.dart';
import '../util.dart';

enum TestEnum { foo, bar }

void main() {
  group('EnumChecks', () {
    test('index extracts zero-based position', () {
      check(TestEnum.foo).index.equals(0);
      check(TestEnum.bar).index.equals(1);
    });

    test('name extracts name of enum constant', () {
      check(TestEnum.foo).name.equals('foo');
      check(TestEnum.bar).name.equals('bar');
    });

    test('index fails for wrong expectation', () {
      check(TestEnum.foo).isRejectedBy(
        (it) => it.index.equals(1),
        actual: ['<0>'],
        which: ['are not equal'],
      );
    });

    test('name fails for wrong expectation', () {
      check(TestEnum.foo).isRejectedBy(
        (it) => it.name.equals('bar'),
        actual: ["'foo'"],
        which: ['differs at offset 0:', 'bar', 'foo', '^'],
      );
    });

    testCheckGolden(
      () {
        check(TestEnum.foo).name.equals('bar');
      },
      '''
# Enum name failure message golden
Expected: a TestEnum that:
  has name that:
    equals 'bar'
Actual: a TestEnum that:
  has name that:
  Actual: 'foo'
  Which: differs at offset 0:
  bar
  foo
  ^''',
    );
  });
}
