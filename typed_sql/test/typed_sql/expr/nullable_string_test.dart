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

final _cases = <({
  String name,
  Expr expr,
  Object? expected,
})>[
  // Tests for null and String
  (
    name: 'hello as String?',
    expr: toExpr('hello' as String?),
    expected: 'hello',
  ),
  (
    name: 'null as String?',
    expr: toExpr(null as String?),
    expected: null,
  ),
  (
    name: '(null as String?).orElse(\'hello\')',
    expr: toExpr(null as String?).orElse(toExpr('hello')),
    expected: 'hello',
  ),
  (
    name: '(null as String?).orElseLiteral(\'hello\')',
    expr: toExpr(null as String?).orElseLiteral('hello'),
    expected: 'hello',
  ),
  (
    name: '(\'world\' as String?).orElse(\'hello\')',
    expr: toExpr('world' as String?).orElse(toExpr('hello')),
    expected: 'world',
  ),
  (
    name: '(\'world\' as String?).orElseLiteral(\'hello\')',
    expr: toExpr('world' as String?).orElseLiteral('hello'),
    expected: 'world',
  ),
  (
    name: 'null.asString()',
    expr: toExpr(null).asString(),
    expected: null,
  ),
  (
    name: 'null.asString().orElse(\'hello\')',
    expr: toExpr(null).asString().orElse(toExpr('hello')),
    expected: 'hello',
  ),
  (
    name: 'null.asString().orElseLiteral(\'hello\')',
    expr: toExpr(null).asString().orElseLiteral('hello'),
    expected: 'hello',
  ),
  // Expr<String?>.equals
  (
    name: 'null.asString().equals(null)',
    expr: toExpr(null).asString().equals(toExpr(null)),
    expected: true,
  ),
  (
    name: 'null.asString().equals("hello")',
    expr: toExpr(null).asString().equals(toExpr('hello')),
    expected: false,
  ),
  (
    name: '"hello".equals(null)',
    expr: toExpr('hello' as String?).equals(toExpr(null)),
    expected: false,
  ),
  (
    name: '"hello".equals("hello")',
    expr: toExpr('hello' as String?).equals(toExpr('hello')),
    expected: true,
  ),
  (
    name: 'null.asString().equals("")',
    expr: toExpr(null).asString().equals(toExpr('')),
    expected: false,
  ),
  (
    name: '"".equals(null)',
    expr: toExpr('' as String?).equals(toExpr(null)),
    expected: false,
  ),
  (
    name: '"".equals("")',
    expr: toExpr('' as String?).equals(toExpr('')),
    expected: true,
  ),
  // Expr<String?>.notEquals
  (
    name: 'null.asString().notEquals(null)',
    expr: toExpr(null).asString().notEquals(toExpr(null)),
    expected: false,
  ),
  (
    name: 'null.asString().notEquals("hello")',
    expr: toExpr(null).asString().notEquals(toExpr('hello')),
    expected: true,
  ),
  (
    name: '"hello".notEquals(null)',
    expr: toExpr('hello' as String?).notEquals(toExpr(null)),
    expected: true,
  ),
  (
    name: '"hello".notEquals("hello")',
    expr: toExpr('hello' as String?).notEquals(toExpr('hello')),
    expected: false,
  ),
  (
    name: 'null.asString().notEquals("")',
    expr: toExpr(null).asString().notEquals(toExpr('')),
    expected: true,
  ),
  (
    name: '"".notEquals(null)',
    expr: toExpr('' as String?).notEquals(toExpr(null)),
    expected: true,
  ),
  (
    name: '"".notEquals("")',
    expr: toExpr('' as String?).notEquals(toExpr('')),
    expected: false,
  ),

  // Expr<String?>.equalsLiteral
  (
    name: 'null.asString().equalsLiteral(null)',
    expr: toExpr(null).asString().equalsLiteral(null),
    expected: true,
  ),
  (
    name: 'null.asString().equalsLiteral("hello")',
    expr: toExpr(null).asString().equalsLiteral('hello'),
    expected: false,
  ),
  (
    name: '"hello".equalsLiteral(null)',
    expr: toExpr('hello' as String?).equalsLiteral(null),
    expected: false,
  ),
  (
    name: '"hello".equalsLiteral("hello")',
    expr: toExpr('hello' as String?).equalsLiteral('hello'),
    expected: true,
  ),
  (
    name: 'null.asString().equalsLiteral("")',
    expr: toExpr(null).asString().equalsLiteral(''),
    expected: false,
  ),
  (
    name: '"".equalsLiteral(null)',
    expr: toExpr('' as String?).equalsLiteral(null),
    expected: false,
  ),
  (
    name: '"".equalsLiteral("")',
    expr: toExpr('' as String?).equalsLiteral(''),
    expected: true,
  ),
  // Expr<String?>.notEqualsLiteral
  (
    name: 'null.asString().notEqualsLiteral(null)',
    expr: toExpr(null).asString().notEqualsLiteral(null),
    expected: false,
  ),
  (
    name: 'null.asString().notEqualsLiteral("hello")',
    expr: toExpr(null).asString().notEqualsLiteral('hello'),
    expected: true,
  ),
  (
    name: '"hello".notEqualsLiteral(null)',
    expr: toExpr('hello' as String?).notEqualsLiteral(null),
    expected: true,
  ),
  (
    name: '"hello".notEqualsLiteral("hello")',
    expr: toExpr('hello' as String?).notEqualsLiteral('hello'),
    expected: false,
  ),
  (
    name: 'null.asString().notEqualsLiteral("")',
    expr: toExpr(null).asString().notEqualsLiteral(''),
    expected: true,
  ),
  (
    name: '"".notEqualsLiteral(null)',
    expr: toExpr('' as String?).notEqualsLiteral(null),
    expected: true,
  ),
  (
    name: '"".notEqualsLiteral("")',
    expr: toExpr('' as String?).notEqualsLiteral(''),
    expected: false,
  ),
  // Expr<String?>.isNull()
  (
    name: 'null.asString().isNull()',
    expr: toExpr(null).asString().isNull(),
    expected: true,
  ),
  (
    name: '"hello".isNull()',
    expr: toExpr('hello' as String?).isNull(),
    expected: false,
  ),
  (
    name: '"".isNull()',
    expr: toExpr('' as String?).isNull(),
    expected: false,
  ),
  // Expr<String?>.isNotNull()
  (
    name: 'null.asString().isNotNull()',
    expr: toExpr(null).asString().isNotNull(),
    expected: false,
  ),
  (
    name: '"hello".isNotNull()',
    expr: toExpr('hello' as String?).isNotNull(),
    expected: true,
  ),
  (
    name: '"".isNotNull()',
    expr: toExpr('' as String?).isNotNull(),
    expected: true,
  ),
];

void main() {
  final r = TestRunner<Schema>(resetDatabaseForEachTest: false);

  for (final c in _cases) {
    r.addTest(c.name, (db) async {
      final result = await db.select(
        (c.expr,),
      ).fetch();
      check(result).equals(c.expected);
    });
  }

  r.run();
}
