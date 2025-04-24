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
  // Tests for null and double
  (
    name: '3.14 as double?',
    expr: toExpr(3.14 as double?),
    expected: 3.14,
  ),
  (
    name: 'null as double?',
    expr: toExpr(null as double?),
    expected: null,
  ),
  (
    name: '(null as double?).orElse(3.14)',
    expr: toExpr(null as double?).orElse(toExpr(3.14)),
    expected: 3.14,
  ),
  (
    name: '(null as double?).orElseValue(3.14)',
    expr: toExpr(null as double?).orElseValue(3.14),
    expected: 3.14,
  ),
  (
    name: '(2.71 as double?).orElse(3.14)',
    expr: toExpr(2.71 as double?).orElse(toExpr(3.14)),
    expected: 2.71,
  ),
  (
    name: '(2.71 as double?).orElseValue(3.14)',
    expr: toExpr(2.71 as double?).orElseValue(3.14),
    expected: 2.71,
  ),
  (
    name: 'null.asDouble()',
    expr: toExpr(null).asDouble(),
    expected: null,
  ),
  (
    name: 'null.asDouble().orElse(3.14)',
    expr: toExpr(null).asDouble().orElse(toExpr(3.14)),
    expected: 3.14,
  ),
  (
    name: 'null.asDouble().orElseValue(3.14)',
    expr: toExpr(null).asDouble().orElseValue(3.14),
    expected: 3.14,
  ),
  // Expr<double?>.equals
  (
    name: 'null.asDouble().equals(3.14)',
    expr: toExpr(null).asDouble().equals(toExpr(3.14)),
    expected: false,
  ),
  (
    name: '3.14.equals(3.14)',
    expr: toExpr(3.14 as double?).equals(toExpr(3.14)),
    expected: true,
  ),
  (
    name: 'null.asDouble().equals(0.0)',
    expr: toExpr(null).asDouble().equals(toExpr(0.0)),
    expected: false,
  ),
  (
    name: '0.0.equals(0.0)',
    expr: toExpr(0.0 as double?).equals(toExpr(0.0)),
    expected: true,
  ),
  // Expr<double?>.isNotDistinctFrom
  (
    name: 'null.asDouble().isNotDistinctFrom(null)',
    expr: toExpr(null).asDouble().isNotDistinctFrom(toExpr(null)),
    expected: true,
  ),
  (
    name: 'null.asDouble().isNotDistinctFrom(3.14)',
    expr: toExpr(null).asDouble().isNotDistinctFrom(toExpr(3.14)),
    expected: false,
  ),
  (
    name: '3.14.isNotDistinctFrom(null)',
    expr: toExpr(3.14 as double?).isNotDistinctFrom(toExpr(null)),
    expected: false,
  ),
  (
    name: '3.14.isNotDistinctFrom(3.14)',
    expr: toExpr(3.14 as double?).isNotDistinctFrom(toExpr(3.14)),
    expected: true,
  ),
  (
    name: 'null.asDouble().isNotDistinctFrom(0.0)',
    expr: toExpr(null).asDouble().isNotDistinctFrom(toExpr(0.0)),
    expected: false,
  ),
  (
    name: '0.0.isNotDistinctFrom(null)',
    expr: toExpr(0.0 as double?).isNotDistinctFrom(toExpr(null)),
    expected: false,
  ),
  (
    name: '0.0.isNotDistinctFrom(0.0)',
    expr: toExpr(0.0 as double?).isNotDistinctFrom(toExpr(0.0)),
    expected: true,
  ),
  // Expr<double?>.equalsUnlessNull
  (
    name: 'null.asDouble().equalsUnlessNull(null)',
    expr: toExpr(null).asDouble().equalsUnlessNull(toExpr(null)),
    expected: null,
  ),
  (
    name: 'null.asDouble().equalsUnlessNull(3.14)',
    expr: toExpr(null).asDouble().equalsUnlessNull(toExpr(3.14)),
    expected: null,
  ),
  (
    name: '3.14.equalsUnlessNull(null)',
    expr: toExpr(3.14 as double?).equalsUnlessNull(toExpr(null)),
    expected: null,
  ),
  (
    name: '3.14.equalsUnlessNull(3.14)',
    expr: toExpr(3.14 as double?).equalsUnlessNull(toExpr(3.14)),
    expected: true,
  ),
  (
    name: 'null.asDouble().equalsUnlessNull(0.0)',
    expr: toExpr(null).asDouble().equalsUnlessNull(toExpr(0.0)),
    expected: null,
  ),
  (
    name: '0.0.equalsUnlessNull(null)',
    expr: toExpr(0.0 as double?).equalsUnlessNull(toExpr(null)),
    expected: null,
  ),
  (
    name: '0.0.equalsUnlessNull(0.0)',
    expr: toExpr(0.0 as double?).equalsUnlessNull(toExpr(0.0)),
    expected: true,
  ),
  // Expr<double?>.notEquals
  (
    name: 'null.asDouble().notEquals(3.14)',
    expr: toExpr(null).asDouble().notEquals(toExpr(3.14)),
    expected: true,
  ),
  (
    name: '3.14.notEquals(3.14)',
    expr: toExpr(3.14 as double?).notEquals(toExpr(3.14)),
    expected: false,
  ),
  (
    name: 'null.asDouble().notEquals(0.0)',
    expr: toExpr(null).asDouble().notEquals(toExpr(0.0)),
    expected: true,
  ),
  (
    name: '0.0.notEquals(0.0)',
    expr: toExpr(0.0 as double?).notEquals(toExpr(0.0)),
    expected: false,
  ),
  // Expr<double?>.equalsValue
  (
    name: 'null.asDouble().equalsValue(3.14)',
    expr: toExpr(null).asDouble().equalsValue(3.14),
    expected: false,
  ),
  (
    name: '3.14.equalsValue(3.14)',
    expr: toExpr(3.14 as double?).equalsValue(3.14),
    expected: true,
  ),
  (
    name: 'null.asDouble().equalsValue(0.0)',
    expr: toExpr(null).asDouble().equalsValue(0.0),
    expected: false,
  ),
  (
    name: '0.0.equalsValue(0.0)',
    expr: toExpr(0.0 as double?).equalsValue(0.0),
    expected: true,
  ),
  // Expr<double?>.notEqualsValue
  (
    name: 'null.asDouble().notEqualsValue(3.14)',
    expr: toExpr(null).asDouble().notEqualsValue(3.14),
    expected: true,
  ),
  (
    name: '3.14.notEqualsValue(3.14)',
    expr: toExpr(3.14 as double?).notEqualsValue(3.14),
    expected: false,
  ),
  (
    name: 'null.asDouble().notEqualsValue(0.0)',
    expr: toExpr(null).asDouble().notEqualsValue(0.0),
    expected: true,
  ),
  (
    name: '0.0.notEqualsValue(0.0)',
    expr: toExpr(0.0 as double?).notEqualsValue(0.0),
    expected: false,
  ),
  // Expr<double?>.isNull()

  (
    name: 'null.asDouble().isNull()',
    expr: toExpr(null).asDouble().isNull(),
    expected: true,
  ),
  (
    name: '3.14.isNull()',
    expr: toExpr(3.14 as double?).isNull(),
    expected: false,
  ),
  (
    name: '0.0.isNull()',
    expr: toExpr(0.0 as double?).isNull(),
    expected: false,
  ),
  // Expr<double?>.isNotNull()
  (
    name: 'null.asDouble().isNotNull()',
    expr: toExpr(null).asDouble().isNotNull(),
    expected: false,
  ),
  (
    name: '3.14.isNotNull()',
    expr: toExpr(3.14 as double?).isNotNull(),
    expected: true,
  ),
  (
    name: '0.0.isNotNull()',
    expr: toExpr(0.0 as double?).isNotNull(),
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
