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
  // Tests for null and int
  (
    name: '42 as int?',
    expr: toExpr(42 as int?),
    expected: 42,
  ),
  (
    name: 'null as int?',
    expr: toExpr(null as int?),
    expected: null,
  ),
  (
    name: '(null as int?).orElse(42)',
    expr: toExpr(null as int?).orElse(toExpr(42)),
    expected: 42,
  ),
  (
    name: '(null as int?).orElseValue(42)',
    expr: toExpr(null as int?).orElseValue(42),
    expected: 42,
  ),
  (
    name: '(21 as int?).orElse(42)',
    expr: toExpr(21 as int?).orElse(toExpr(42)),
    expected: 21,
  ),
  (
    name: '(21 as int?).orElseValue(42)',
    expr: toExpr(21 as int?).orElseValue(42),
    expected: 21,
  ),
  (
    name: 'null.asInt()',
    expr: toExpr(null).asInt(),
    expected: null,
  ),
  (
    name: 'null.asInt().orElse(42)',
    expr: toExpr(null).asInt().orElse(toExpr(42)),
    expected: 42,
  ),
  (
    name: 'null.asInt().orElseValue(42)',
    expr: toExpr(null).asInt().orElseValue(42),
    expected: 42,
  ),
  // Expr<int?>.equals
  (
    name: 'null.asInt().equals(42)',
    expr: toExpr(null).asInt().equals(toExpr(42)),
    expected: false,
  ),
  (
    name: '42.equals(42)',
    expr: toExpr(42 as int?).equals(toExpr(42)),
    expected: true,
  ),
  (
    name: 'null.asInt().equals(0)',
    expr: toExpr(null).asInt().equals(toExpr(0)),
    expected: false,
  ),
  (
    name: '0.equals(0)',
    expr: toExpr(0 as int?).equals(toExpr(0)),
    expected: true,
  ),
  // Expr<int?>.isNotDistinctFrom
  (
    name: 'null.asInt().isNotDistinctFrom(null)',
    expr: toExpr(null).asInt().isNotDistinctFrom(toExpr(null)),
    expected: true,
  ),
  (
    name: 'null.asInt().isNotDistinctFrom(42)',
    expr: toExpr(null).asInt().isNotDistinctFrom(toExpr(42)),
    expected: false,
  ),
  (
    name: '42.isNotDistinctFrom(null)',
    expr: toExpr(42 as int?).isNotDistinctFrom(toExpr(null)),
    expected: false,
  ),
  (
    name: '42.isNotDistinctFrom(42)',
    expr: toExpr(42 as int?).isNotDistinctFrom(toExpr(42)),
    expected: true,
  ),
  (
    name: 'null.asInt().isNotDistinctFrom(0)',
    expr: toExpr(null).asInt().isNotDistinctFrom(toExpr(0)),
    expected: false,
  ),
  (
    name: '0.isNotDistinctFrom(null)',
    expr: toExpr(0 as int?).isNotDistinctFrom(toExpr(null)),
    expected: false,
  ),
  (
    name: '0.isNotDistinctFrom(0)',
    expr: toExpr(0 as int?).isNotDistinctFrom(toExpr(0)),
    expected: true,
  ),
  // Expr<int?>.equalsUnlessNull
  (
    name: 'null.asInt().equalsUnlessNull(null)',
    expr: toExpr(null).asInt().equalsUnlessNull(toExpr(null)),
    expected: null,
  ),
  (
    name: 'null.asInt().equalsUnlessNull(42)',
    expr: toExpr(null).asInt().equalsUnlessNull(toExpr(42)),
    expected: null,
  ),
  (
    name: '42.equalsUnlessNull(null)',
    expr: toExpr(42 as int?).equalsUnlessNull(toExpr(null)),
    expected: null,
  ),
  (
    name: '42.equalsUnlessNull(42)',
    expr: toExpr(42 as int?).equalsUnlessNull(toExpr(42)),
    expected: true,
  ),
  (
    name: 'null.asInt().equalsUnlessNull(0)',
    expr: toExpr(null).asInt().equalsUnlessNull(toExpr(0)),
    expected: null,
  ),
  (
    name: '0.equalsUnlessNull(null)',
    expr: toExpr(0 as int?).equalsUnlessNull(toExpr(null)),
    expected: null,
  ),
  (
    name: '0.equalsUnlessNull(0)',
    expr: toExpr(0 as int?).equalsUnlessNull(toExpr(0)),
    expected: true,
  ),
  // Expr<int?>.notEquals
  (
    name: 'null.asInt().notEquals(42)',
    expr: toExpr(null).asInt().notEquals(toExpr(42)),
    expected: true,
  ),
  (
    name: '42.notEquals(42)',
    expr: toExpr(42 as int?).notEquals(toExpr(42)),
    expected: false,
  ),
  (
    name: 'null.asInt().notEquals(0)',
    expr: toExpr(null).asInt().notEquals(toExpr(0)),
    expected: true,
  ),
  (
    name: '0.notEquals(0)',
    expr: toExpr(0 as int?).notEquals(toExpr(0)),
    expected: false,
  ),
  // Expr<int?>.equalsValue
  (
    name: 'null.asInt().equalsValue(42)',
    expr: toExpr(null).asInt().equalsValue(42),
    expected: false,
  ),
  (
    name: '42.equalsValue(42)',
    expr: toExpr(42 as int?).equalsValue(42),
    expected: true,
  ),
  (
    name: 'null.asInt().equalsValue(0)',
    expr: toExpr(null).asInt().equalsValue(0),
    expected: false,
  ),
  (
    name: '0.equalsValue(0)',
    expr: toExpr(0 as int?).equalsValue(0),
    expected: true,
  ),
  // Expr<int?>.notEqualsValue
  (
    name: 'null.asInt().notEqualsValue(42)',
    expr: toExpr(null).asInt().notEqualsValue(42),
    expected: true,
  ),
  (
    name: '42.notEqualsValue(42)',
    expr: toExpr(42 as int?).notEqualsValue(42),
    expected: false,
  ),
  (
    name: 'null.asInt().notEqualsValue(0)',
    expr: toExpr(null).asInt().notEqualsValue(0),
    expected: true,
  ),
  (
    name: '0.notEqualsValue(0)',
    expr: toExpr(0 as int?).notEqualsValue(0),
    expected: false,
  ),
  // Expr<int?>.isNull()
  (
    name: 'null.asInt().isNull()',
    expr: toExpr(null).asInt().isNull(),
    expected: true,
  ),
  (
    name: '42.isNull()',
    expr: toExpr(42 as int?).isNull(),
    expected: false,
  ),
  (
    name: '0.isNull()',
    expr: toExpr(0 as int?).isNull(),
    expected: false,
  ),
  // Expr<int?>.isNotNull()
  (
    name: 'null.asInt().isNotNull()',
    expr: toExpr(null).asInt().isNotNull(),
    expected: false,
  ),
  (
    name: '42.isNotNull()',
    expr: toExpr(42 as int?).isNotNull(),
    expected: true,
  ),
  (
    name: '0.isNotNull()',
    expr: toExpr(0 as int?).isNotNull(),
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
