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
    expr: literal(3.14 as double?),
    expected: 3.14,
  ),
  (
    name: 'null as double?',
    expr: literal(null as double?),
    expected: null,
  ),
  (
    name: '(null as double?).orElse(3.14)',
    expr: literal(null as double?).orElse(literal(3.14)),
    expected: 3.14,
  ),
  (
    name: '(null as double?).orElseLiteral(3.14)',
    expr: literal(null as double?).orElseLiteral(3.14),
    expected: 3.14,
  ),
  (
    name: '(2.71 as double?).orElse(3.14)',
    expr: literal(2.71 as double?).orElse(literal(3.14)),
    expected: 2.71,
  ),
  (
    name: '(2.71 as double?).orElseLiteral(3.14)',
    expr: literal(2.71 as double?).orElseLiteral(3.14),
    expected: 2.71,
  ),
  (
    name: 'null.asDouble()',
    expr: literal(null).asDouble(),
    expected: null,
  ),
  (
    name: 'null.asDouble().orElse(3.14)',
    expr: literal(null).asDouble().orElse(literal(3.14)),
    expected: 3.14,
  ),
  (
    name: 'null.asDouble().orElseLiteral(3.14)',
    expr: literal(null).asDouble().orElseLiteral(3.14),
    expected: 3.14,
  ),
  // Expr<double?>.equals
  (
    name: 'null.asDouble().equals(null)',
    expr: literal(null).asDouble().equals(literal(null)),
    expected: true,
  ),
  (
    name: 'null.asDouble().equals(3.14)',
    expr: literal(null).asDouble().equals(literal(3.14)),
    expected: false,
  ),
  (
    name: '3.14.equals(null)',
    expr: literal(3.14 as double?).equals(literal(null)),
    expected: false,
  ),
  (
    name: '3.14.equals(3.14)',
    expr: literal(3.14 as double?).equals(literal(3.14)),
    expected: true,
  ),
  (
    name: 'null.asDouble().equals(0.0)',
    expr: literal(null).asDouble().equals(literal(0.0)),
    expected: false,
  ),
  (
    name: '0.0.equals(null)',
    expr: literal(0.0 as double?).equals(literal(null)),
    expected: false,
  ),
  (
    name: '0.0.equals(0.0)',
    expr: literal(0.0 as double?).equals(literal(0.0)),
    expected: true,
  ),
  // Expr<double?>.notEquals
  (
    name: 'null.asDouble().notEquals(null)',
    expr: literal(null).asDouble().notEquals(literal(null)),
    expected: false,
  ),
  (
    name: 'null.asDouble().notEquals(3.14)',
    expr: literal(null).asDouble().notEquals(literal(3.14)),
    expected: true,
  ),
  (
    name: '3.14.notEquals(null)',
    expr: literal(3.14 as double?).notEquals(literal(null)),
    expected: true,
  ),
  (
    name: '3.14.notEquals(3.14)',
    expr: literal(3.14 as double?).notEquals(literal(3.14)),
    expected: false,
  ),
  (
    name: 'null.asDouble().notEquals(0.0)',
    expr: literal(null).asDouble().notEquals(literal(0.0)),
    expected: true,
  ),
  (
    name: '0.0.notEquals(null)',
    expr: literal(0.0 as double?).notEquals(literal(null)),
    expected: true,
  ),
  (
    name: '0.0.notEquals(0.0)',
    expr: literal(0.0 as double?).notEquals(literal(0.0)),
    expected: false,
  ),
  // Expr<double?>.equalsLiteral
  (
    name: 'null.asDouble().equalsLiteral(null)',
    expr: literal(null).asDouble().equalsLiteral(null),
    expected: true,
  ),
  (
    name: 'null.asDouble().equalsLiteral(3.14)',
    expr: literal(null).asDouble().equalsLiteral(3.14),
    expected: false,
  ),
  (
    name: '3.14.equalsLiteral(null)',
    expr: literal(3.14 as double?).equalsLiteral(null),
    expected: false,
  ),
  (
    name: '3.14.equalsLiteral(3.14)',
    expr: literal(3.14 as double?).equalsLiteral(3.14),
    expected: true,
  ),
  (
    name: 'null.asDouble().equalsLiteral(0.0)',
    expr: literal(null).asDouble().equalsLiteral(0.0),
    expected: false,
  ),
  (
    name: '0.0.equalsLiteral(null)',
    expr: literal(0.0 as double?).equalsLiteral(null),
    expected: false,
  ),
  (
    name: '0.0.equalsLiteral(0.0)',
    expr: literal(0.0 as double?).equalsLiteral(0.0),
    expected: true,
  ),
  // Expr<double?>.notEqualsLiteral
  (
    name: 'null.asDouble().notEqualsLiteral(null)',
    expr: literal(null).asDouble().notEqualsLiteral(null),
    expected: false,
  ),
  (
    name: 'null.asDouble().notEqualsLiteral(3.14)',
    expr: literal(null).asDouble().notEqualsLiteral(3.14),
    expected: true,
  ),
  (
    name: '3.14.notEqualsLiteral(null)',
    expr: literal(3.14 as double?).notEqualsLiteral(null),
    expected: true,
  ),
  (
    name: '3.14.notEqualsLiteral(3.14)',
    expr: literal(3.14 as double?).notEqualsLiteral(3.14),
    expected: false,
  ),
  (
    name: 'null.asDouble().notEqualsLiteral(0.0)',
    expr: literal(null).asDouble().notEqualsLiteral(0.0),
    expected: true,
  ),
  (
    name: '0.0.notEqualsLiteral(null)',
    expr: literal(0.0 as double?).notEqualsLiteral(null),
    expected: true,
  ),
  (
    name: '0.0.notEqualsLiteral(0.0)',
    expr: literal(0.0 as double?).notEqualsLiteral(0.0),
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
