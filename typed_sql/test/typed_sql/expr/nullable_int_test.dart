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
    expr: literal(42 as int?),
    expected: 42,
  ),
  (
    name: 'null as int?',
    expr: literal(null as int?),
    expected: null,
  ),
  (
    name: '(null as int?).orElse(42)',
    expr: literal(null as int?).orElse(literal(42)),
    expected: 42,
  ),
  (
    name: '(null as int?).orElseLiteral(42)',
    expr: literal(null as int?).orElseLiteral(42),
    expected: 42,
  ),
  (
    name: '(21 as int?).orElse(42)',
    expr: literal(21 as int?).orElse(literal(42)),
    expected: 21,
  ),
  (
    name: '(21 as int?).orElseLiteral(42)',
    expr: literal(21 as int?).orElseLiteral(42),
    expected: 21,
  ),
  (
    name: 'null.asInt()',
    expr: literal(null).asInt(),
    expected: null,
  ),
  (
    name: 'null.asInt().orElse(42)',
    expr: literal(null).asInt().orElse(literal(42)),
    expected: 42,
  ),
  (
    name: 'null.asInt().orElseLiteral(42)',
    expr: literal(null).asInt().orElseLiteral(42),
    expected: 42,
  ),
  // Expr<int?>.equals
  (
    name: 'null.asInt().equals(null)',
    expr: literal(null).asInt().equals(literal(null)),
    expected: true,
  ),
  (
    name: 'null.asInt().equals(42)',
    expr: literal(null).asInt().equals(literal(42)),
    expected: false,
  ),
  (
    name: '42.equals(null)',
    expr: literal(42 as int?).equals(literal(null)),
    expected: false,
  ),
  (
    name: '42.equals(42)',
    expr: literal(42 as int?).equals(literal(42)),
    expected: true,
  ),
  (
    name: 'null.asInt().equals(0)',
    expr: literal(null).asInt().equals(literal(0)),
    expected: false,
  ),
  (
    name: '0.equals(null)',
    expr: literal(0 as int?).equals(literal(null)),
    expected: false,
  ),
  (
    name: '0.equals(0)',
    expr: literal(0 as int?).equals(literal(0)),
    expected: true,
  ),
  // Expr<int?>.notEquals
  (
    name: 'null.asInt().notEquals(null)',
    expr: literal(null).asInt().notEquals(literal(null)),
    expected: false,
  ),
  (
    name: 'null.asInt().notEquals(42)',
    expr: literal(null).asInt().notEquals(literal(42)),
    expected: true,
  ),
  (
    name: '42.notEquals(null)',
    expr: literal(42 as int?).notEquals(literal(null)),
    expected: true,
  ),
  (
    name: '42.notEquals(42)',
    expr: literal(42 as int?).notEquals(literal(42)),
    expected: false,
  ),
  (
    name: 'null.asInt().notEquals(0)',
    expr: literal(null).asInt().notEquals(literal(0)),
    expected: true,
  ),
  (
    name: '0.notEquals(null)',
    expr: literal(0 as int?).notEquals(literal(null)),
    expected: true,
  ),
  (
    name: '0.notEquals(0)',
    expr: literal(0 as int?).notEquals(literal(0)),
    expected: false,
  ),
  // Expr<int?>.equalsLiteral
  (
    name: 'null.asInt().equalsLiteral(null)',
    expr: literal(null).asInt().equalsLiteral(null),
    expected: true,
  ),
  (
    name: 'null.asInt().equalsLiteral(42)',
    expr: literal(null).asInt().equalsLiteral(42),
    expected: false,
  ),
  (
    name: '42.equalsLiteral(null)',
    expr: literal(42 as int?).equalsLiteral(null),
    expected: false,
  ),
  (
    name: '42.equalsLiteral(42)',
    expr: literal(42 as int?).equalsLiteral(42),
    expected: true,
  ),
  (
    name: 'null.asInt().equalsLiteral(0)',
    expr: literal(null).asInt().equalsLiteral(0),
    expected: false,
  ),
  (
    name: '0.equalsLiteral(null)',
    expr: literal(0 as int?).equalsLiteral(null),
    expected: false,
  ),
  (
    name: '0.equalsLiteral(0)',
    expr: literal(0 as int?).equalsLiteral(0),
    expected: true,
  ),
  // Expr<int?>.notEqualsLiteral
  (
    name: 'null.asInt().notEqualsLiteral(null)',
    expr: literal(null).asInt().notEqualsLiteral(null),
    expected: false,
  ),
  (
    name: 'null.asInt().notEqualsLiteral(42)',
    expr: literal(null).asInt().notEqualsLiteral(42),
    expected: true,
  ),
  (
    name: '42.notEqualsLiteral(null)',
    expr: literal(42 as int?).notEqualsLiteral(null),
    expected: true,
  ),
  (
    name: '42.notEqualsLiteral(42)',
    expr: literal(42 as int?).notEqualsLiteral(42),
    expected: false,
  ),
  (
    name: 'null.asInt().notEqualsLiteral(0)',
    expr: literal(null).asInt().notEqualsLiteral(0),
    expected: true,
  ),
  (
    name: '0.notEqualsLiteral(null)',
    expr: literal(0 as int?).notEqualsLiteral(null),
    expected: true,
  ),
  (
    name: '0.notEqualsLiteral(0)',
    expr: literal(0 as int?).notEqualsLiteral(0),
    expected: false,
  ),
  // Expr<int?>.isNull()
  (
    name: 'null.asInt().isNull()',
    expr: literal(null).asInt().isNull(),
    expected: true,
  ),
  (
    name: '42.isNull()',
    expr: literal(42 as int?).isNull(),
    expected: false,
  ),
  (
    name: '0.isNull()',
    expr: literal(0 as int?).isNull(),
    expected: false,
  ),
  // Expr<int?>.isNotNull()
  (
    name: 'null.asInt().isNotNull()',
    expr: literal(null).asInt().isNotNull(),
    expected: false,
  ),
  (
    name: '42.isNotNull()',
    expr: literal(42 as int?).isNotNull(),
    expected: true,
  ),
  (
    name: '0.isNotNull()',
    expr: literal(0 as int?).isNotNull(),
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
