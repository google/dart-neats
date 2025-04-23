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
    name: '(null as String?).orElseValue(\'hello\')',
    expr: toExpr(null as String?).orElseValue('hello'),
    expected: 'hello',
  ),
  (
    name: '(\'world\' as String?).orElse(\'hello\')',
    expr: toExpr('world' as String?).orElse(toExpr('hello')),
    expected: 'world',
  ),
  (
    name: '(\'world\' as String?).orElseValue(\'hello\')',
    expr: toExpr('world' as String?).orElseValue('hello'),
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
    name: 'null.asString().orElseValue(\'hello\')',
    expr: toExpr(null).asString().orElseValue('hello'),
    expected: 'hello',
  ),
  // Expr<String?>.equals
  (
    name: 'null.asString().equals("hello")',
    expr: toExpr(null).asString().equals(toExpr('hello')),
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
    name: '"".equals("")',
    expr: toExpr('' as String?).equals(toExpr('')),
    expected: true,
  ),
  // Expr<String?>.isNotDistinctFrom
  (
    name: 'null.asString().isNotDistinctFrom(null)',
    expr: toExpr(null).asString().isNotDistinctFrom(toExpr(null)),
    expected: true,
  ),
  (
    name: 'null.asString().isNotDistinctFrom("hello")',
    expr: toExpr(null).asString().isNotDistinctFrom(toExpr('hello')),
    expected: false,
  ),
  (
    name: '"hello".isNotDistinctFrom(null)',
    expr: toExpr('hello' as String?).isNotDistinctFrom(toExpr(null)),
    expected: false,
  ),
  (
    name: '"hello".isNotDistinctFrom("hello")',
    expr: toExpr('hello' as String?).isNotDistinctFrom(toExpr('hello')),
    expected: true,
  ),
  (
    name: 'null.asString().isNotDistinctFrom("")',
    expr: toExpr(null).asString().isNotDistinctFrom(toExpr('')),
    expected: false,
  ),
  (
    name: '"".isNotDistinctFrom(null)',
    expr: toExpr('' as String?).isNotDistinctFrom(toExpr(null)),
    expected: false,
  ),
  (
    name: '"".isNotDistinctFrom("")',
    expr: toExpr('' as String?).isNotDistinctFrom(toExpr('')),
    expected: true,
  ),
  // Expr<String?>.equalsUnlessNull
  (
    name: 'null.asString().equalsUnlessNull(null)',
    expr: toExpr(null).asString().equalsUnlessNull(toExpr(null)),
    expected: null,
  ),
  (
    name: 'null.asString().equalsUnlessNull("hello")',
    expr: toExpr(null).asString().equalsUnlessNull(toExpr('hello')),
    expected: null,
  ),
  (
    name: '"hello".equalsUnlessNull(null)',
    expr: toExpr('hello' as String?).equalsUnlessNull(toExpr(null)),
    expected: null,
  ),
  (
    name: '"hello".equalsUnlessNull("hello")',
    expr: toExpr('hello' as String?).equalsUnlessNull(toExpr('hello')),
    expected: true,
  ),
  (
    name: 'null.asString().equalsUnlessNull("")',
    expr: toExpr(null).asString().equalsUnlessNull(toExpr('')),
    expected: null,
  ),
  (
    name: '"".equalsUnlessNull(null)',
    expr: toExpr('' as String?).equalsUnlessNull(toExpr(null)),
    expected: null,
  ),
  (
    name: '"".equalsUnlessNull("")',
    expr: toExpr('' as String?).equalsUnlessNull(toExpr('')),
    expected: true,
  ),
  // Expr<String?>.notEquals
  (
    name: 'null.asString().notEquals("hello")',
    expr: toExpr(null).asString().notEquals(toExpr('hello')),
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
    name: '"".notEquals("")',
    expr: toExpr('' as String?).notEquals(toExpr('')),
    expected: false,
  ),

  // Expr<String?>.equalsValue
  (
    name: 'null.asString().equalsValue("hello")',
    expr: toExpr(null).asString().equalsValue('hello'),
    expected: false,
  ),
  (
    name: '"hello".equalsValue("hello")',
    expr: toExpr('hello' as String?).equalsValue('hello'),
    expected: true,
  ),
  (
    name: 'null.asString().equalsValue("")',
    expr: toExpr(null).asString().equalsValue(''),
    expected: false,
  ),
  (
    name: '"".equalsValue("")',
    expr: toExpr('' as String?).equalsValue(''),
    expected: true,
  ),
  // Expr<String?>.notEqualsValue
  (
    name: 'null.asString().notEqualsValue("hello")',
    expr: toExpr(null).asString().notEqualsValue('hello'),
    expected: true,
  ),
  (
    name: '"hello".notEqualsValue("hello")',
    expr: toExpr('hello' as String?).notEqualsValue('hello'),
    expected: false,
  ),
  (
    name: 'null.asString().notEqualsValue("")',
    expr: toExpr(null).asString().notEqualsValue(''),
    expected: true,
  ),
  (
    name: '"".notEqualsValue("")',
    expr: toExpr('' as String?).notEqualsValue(''),
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
