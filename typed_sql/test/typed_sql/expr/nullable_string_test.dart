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
    expr: literal('hello' as String?),
    expected: 'hello',
  ),
  (
    name: 'null as String?',
    expr: literal(null as String?),
    expected: null,
  ),
  (
    name: '(null as String?).orElse(\'hello\')',
    expr: literal(null as String?).orElse(literal('hello')),
    expected: 'hello',
  ),
  (
    name: '(null as String?).orElseLiteral(\'hello\')',
    expr: literal(null as String?).orElseLiteral('hello'),
    expected: 'hello',
  ),
  (
    name: '(\'world\' as String?).orElse(\'hello\')',
    expr: literal('world' as String?).orElse(literal('hello')),
    expected: 'world',
  ),
  (
    name: '(\'world\' as String?).orElseLiteral(\'hello\')',
    expr: literal('world' as String?).orElseLiteral('hello'),
    expected: 'world',
  ),
  (
    name: 'null.asString()',
    expr: literal(null).asString(),
    expected: null,
  ),
  (
    name: 'null.asString().orElse(\'hello\')',
    expr: literal(null).asString().orElse(literal('hello')),
    expected: 'hello',
  ),
  (
    name: 'null.asString().orElseLiteral(\'hello\')',
    expr: literal(null).asString().orElseLiteral('hello'),
    expected: 'hello',
  ),
  // Expr<String?>.equals
  (
    name: 'null.asString().equals(null)',
    expr: literal(null).asString().equals(literal(null)),
    expected: true,
  ),
  (
    name: 'null.asString().equals("hello")',
    expr: literal(null).asString().equals(literal('hello')),
    expected: false,
  ),
  (
    name: '"hello".equals(null)',
    expr: literal('hello' as String?).equals(literal(null)),
    expected: false,
  ),
  (
    name: '"hello".equals("hello")',
    expr: literal('hello' as String?).equals(literal('hello')),
    expected: true,
  ),
  (
    name: 'null.asString().equals("")',
    expr: literal(null).asString().equals(literal('')),
    expected: false,
  ),
  (
    name: '"".equals(null)',
    expr: literal('' as String?).equals(literal(null)),
    expected: false,
  ),
  (
    name: '"".equals("")',
    expr: literal('' as String?).equals(literal('')),
    expected: true,
  ),
  // Expr<String?>.notEquals
  (
    name: 'null.asString().notEquals(null)',
    expr: literal(null).asString().notEquals(literal(null)),
    expected: false,
  ),
  (
    name: 'null.asString().notEquals("hello")',
    expr: literal(null).asString().notEquals(literal('hello')),
    expected: true,
  ),
  (
    name: '"hello".notEquals(null)',
    expr: literal('hello' as String?).notEquals(literal(null)),
    expected: true,
  ),
  (
    name: '"hello".notEquals("hello")',
    expr: literal('hello' as String?).notEquals(literal('hello')),
    expected: false,
  ),
  (
    name: 'null.asString().notEquals("")',
    expr: literal(null).asString().notEquals(literal('')),
    expected: true,
  ),
  (
    name: '"".notEquals(null)',
    expr: literal('' as String?).notEquals(literal(null)),
    expected: true,
  ),
  (
    name: '"".notEquals("")',
    expr: literal('' as String?).notEquals(literal('')),
    expected: false,
  ),

  // Expr<String?>.equalsLiteral
  (
    name: 'null.asString().equalsLiteral(null)',
    expr: literal(null).asString().equalsLiteral(null),
    expected: true,
  ),
  (
    name: 'null.asString().equalsLiteral("hello")',
    expr: literal(null).asString().equalsLiteral('hello'),
    expected: false,
  ),
  (
    name: '"hello".equalsLiteral(null)',
    expr: literal('hello' as String?).equalsLiteral(null),
    expected: false,
  ),
  (
    name: '"hello".equalsLiteral("hello")',
    expr: literal('hello' as String?).equalsLiteral('hello'),
    expected: true,
  ),
  (
    name: 'null.asString().equalsLiteral("")',
    expr: literal(null).asString().equalsLiteral(''),
    expected: false,
  ),
  (
    name: '"".equalsLiteral(null)',
    expr: literal('' as String?).equalsLiteral(null),
    expected: false,
  ),
  (
    name: '"".equalsLiteral("")',
    expr: literal('' as String?).equalsLiteral(''),
    expected: true,
  ),
  // Expr<String?>.notEqualsLiteral
  (
    name: 'null.asString().notEqualsLiteral(null)',
    expr: literal(null).asString().notEqualsLiteral(null),
    expected: false,
  ),
  (
    name: 'null.asString().notEqualsLiteral("hello")',
    expr: literal(null).asString().notEqualsLiteral('hello'),
    expected: true,
  ),
  (
    name: '"hello".notEqualsLiteral(null)',
    expr: literal('hello' as String?).notEqualsLiteral(null),
    expected: true,
  ),
  (
    name: '"hello".notEqualsLiteral("hello")',
    expr: literal('hello' as String?).notEqualsLiteral('hello'),
    expected: false,
  ),
  (
    name: 'null.asString().notEqualsLiteral("")',
    expr: literal(null).asString().notEqualsLiteral(''),
    expected: true,
  ),
  (
    name: '"".notEqualsLiteral(null)',
    expr: literal('' as String?).notEqualsLiteral(null),
    expected: true,
  ),
  (
    name: '"".notEqualsLiteral("")',
    expr: literal('' as String?).notEqualsLiteral(''),
    expected: false,
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
