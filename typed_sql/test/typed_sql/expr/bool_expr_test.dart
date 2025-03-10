// Copyright 2025 Google LLC
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

import 'package:typed_sql/typed_sql.dart';

import '../testrunner.dart';

final _cases = [
  (
    name: 'true',
    expr: literal(true),
    expected: true,
  ),
  (
    name: 'false',
    expr: literal(false),
    expected: false,
  ),
  (
    name: 'false.and(false)',
    expr: literal(false).and(literal(false)),
    expected: false,
  ),
  (
    name: 'true.and(false)',
    expr: literal(true).and(literal(false)),
    expected: false,
  ),
  (
    name: 'false.and(true)',
    expr: literal(false).and(literal(true)),
    expected: false,
  ),
  (
    name: 'true.and(true)',
    expr: literal(true).and(literal(true)),
    expected: true,
  ),
  (
    name: 'false & false',
    expr: literal(false) & literal(false),
    expected: false,
  ),
  (
    name: 'true & false',
    expr: literal(true) & literal(false),
    expected: false,
  ),
  (
    name: 'false & true',
    expr: literal(false) & literal(true),
    expected: false,
  ),
  (
    name: 'true & true',
    expr: literal(true) & literal(true),
    expected: true,
  ),
  (
    name: 'false.or(false)',
    expr: literal(false).or(literal(false)),
    expected: false,
  ),
  (
    name: 'true.or(false)',
    expr: literal(true).or(literal(false)),
    expected: true,
  ),
  (
    name: 'false.or(true)',
    expr: literal(false).or(literal(true)),
    expected: true,
  ),
  (
    name: 'true.or(true)',
    expr: literal(true).or(literal(true)),
    expected: true,
  ),
  (
    name: 'false | false',
    expr: literal(false) | literal(false),
    expected: false,
  ),
  (
    name: 'true | false',
    expr: literal(true) | literal(false),
    expected: true,
  ),
  (
    name: 'false | true',
    expr: literal(false) | literal(true),
    expected: true,
  ),
  (
    name: 'true | true',
    expr: literal(true) | literal(true),
    expected: true,
  ),
  (
    name: 'true.not()',
    expr: literal(true).not(),
    expected: false,
  ),
  (
    name: 'false.not()',
    expr: literal(false).not(),
    expected: true,
  ),
  (
    name: '~true',
    expr: ~literal(true),
    expected: false,
  ),
  (
    name: '~false',
    expr: ~literal(false),
    expected: true,
  ),
];

void main() {
  final r = TestRunner<Schema>();

  for (final c in _cases) {
    r.addTest(c.name, (db) async {
      final result = await db.select(
        (c.expr,),
      ).fetch();
      check(result).isNotNull().equals(c.expected);
    });
  }

  r.run();
}
