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
    expr: toExpr(true),
    expected: true,
  ),
  (
    name: 'false',
    expr: toExpr(false),
    expected: false,
  ),
  (
    name: 'false.and(false)',
    expr: toExpr(false).and(toExpr(false)),
    expected: false,
  ),
  (
    name: 'true.and(false)',
    expr: toExpr(true).and(toExpr(false)),
    expected: false,
  ),
  (
    name: 'false.and(true)',
    expr: toExpr(false).and(toExpr(true)),
    expected: false,
  ),
  (
    name: 'true.and(true)',
    expr: toExpr(true).and(toExpr(true)),
    expected: true,
  ),
  (
    name: 'false & false',
    expr: toExpr(false) & toExpr(false),
    expected: false,
  ),
  (
    name: 'true & false',
    expr: toExpr(true) & toExpr(false),
    expected: false,
  ),
  (
    name: 'false & true',
    expr: toExpr(false) & toExpr(true),
    expected: false,
  ),
  (
    name: 'true & true',
    expr: toExpr(true) & toExpr(true),
    expected: true,
  ),
  (
    name: 'false.or(false)',
    expr: toExpr(false).or(toExpr(false)),
    expected: false,
  ),
  (
    name: 'true.or(false)',
    expr: toExpr(true).or(toExpr(false)),
    expected: true,
  ),
  (
    name: 'false.or(true)',
    expr: toExpr(false).or(toExpr(true)),
    expected: true,
  ),
  (
    name: 'true.or(true)',
    expr: toExpr(true).or(toExpr(true)),
    expected: true,
  ),
  (
    name: 'false | false',
    expr: toExpr(false) | toExpr(false),
    expected: false,
  ),
  (
    name: 'true | false',
    expr: toExpr(true) | toExpr(false),
    expected: true,
  ),
  (
    name: 'false | true',
    expr: toExpr(false) | toExpr(true),
    expected: true,
  ),
  (
    name: 'true | true',
    expr: toExpr(true) | toExpr(true),
    expected: true,
  ),
  (
    name: 'true.not()',
    expr: toExpr(true).not(),
    expected: false,
  ),
  (
    name: 'false.not()',
    expr: toExpr(false).not(),
    expected: true,
  ),
  (
    name: '~true',
    expr: ~toExpr(true),
    expected: false,
  ),
  (
    name: '~false',
    expr: ~toExpr(false),
    expected: true,
  ),
  (
    name: 'true.asInt()',
    expr: toExpr(true).asInt(),
    expected: 1,
  ),
  (
    name: 'false.asInt()',
    expr: toExpr(false).asInt(),
    expected: 0,
  ),
];

void main() {
  final r = TestRunner<Schema>(resetDatabaseForEachTest: false);

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
