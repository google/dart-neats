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

/// Test cases with a single value in each column.
final _integerCases = [
  (
    name: '2, 2, 2',
    values: [toExpr(2), toExpr(2), toExpr(2)],
    sum: 6,
  ),
  (
    name: '1, 2, 3',
    values: [toExpr(1), toExpr(2), toExpr(3)],
    sum: 6,
  ),
  (
    name: '42',
    values: [toExpr(42)],
    sum: 42,
  ),
  (
    name: '0, 0, 0',
    values: [toExpr(0), toExpr(0), toExpr(0)],
    sum: 0,
  ),
  (
    name: '-1, 0, 1',
    values: [toExpr(-1), toExpr(0), toExpr(1)],
    sum: 0,
  ),
  (
    name: '-1, -2, -3',
    values: [toExpr(-1), toExpr(-2), toExpr(-3)],
    sum: -6,
  ),
  (
    name: '2, 1',
    values: [toExpr(2), toExpr(1)],
    sum: 3,
  ),
  // Important to test that nulls are ignored when computing SUM
  (
    name: '2, null',
    values: [toExpr(2), toExpr(null)],
    sum: 2,
  ),
  (
    name: '2, null, null',
    values: [toExpr(2), toExpr(null), toExpr(null)],
    sum: 2,
  ),
  (
    name: '2, null, 1',
    values: [toExpr(2), toExpr(null), toExpr(1)],
    sum: 3,
  ),
  (
    name: 'null, null, null',
    // cast here is necessary for the first expression
    values: [toExpr(null).asInt(), toExpr(null), toExpr(null)],
    sum: 0,
  ),
];

final _doubleCases = [
  (
    name: '2.0, 2.0, 2.0',
    values: [toExpr(2.0), toExpr(2.0), toExpr(2.0)],
    sum: 6.0,
  ),
  (
    name: '1.0, 2.0, 3.0',
    values: [toExpr(1.0), toExpr(2.0), toExpr(3.0)],
    sum: 6.0,
  ),
  (
    name: '42.0',
    values: [toExpr(42.0)],
    sum: 42.0,
  ),
  (
    name: '0.0, 0.0, 0.0',
    values: [toExpr(0.0), toExpr(0.0), toExpr(0.0)],
    sum: 0.0,
  ),
  (
    name: '-1.0, 0.0, 1.0',
    values: [toExpr(-1.0), toExpr(0.0), toExpr(1.0)],
    sum: 0.0,
  ),
  (
    name: '-1.0, -2.0, -3.0',
    values: [toExpr(-1.0), toExpr(-2.0), toExpr(-3.0)],
    sum: -6.0,
  ),
  (
    name: '2.0, 1.0',
    values: [toExpr(2.0), toExpr(1.0)],
    sum: 3.0,
  ),
  (
    name: '3.14, 3.14, 3.14',
    values: [toExpr(3.14), toExpr(3.14), toExpr(3.14)],
    sum: 3.14 * 3,
  ),
  (
    name: '3.14, 6.28, 9.42',
    values: [toExpr(3.14), toExpr(6.28), toExpr(9.42)],
    sum: 3.14 + 6.28 + 9.42,
  ),
  (
    name: '3.14',
    values: [toExpr(3.14)],
    sum: 3.14,
  ),
  (
    name: '0.0, 3.14, 6.28',
    values: [toExpr(0.0), toExpr(3.14), toExpr(6.28)],
    sum: 3.14 + 6.28,
  ),
  (
    name: '-3.14, 0.0, 3.14',
    values: [toExpr(-3.14), toExpr(0.0), toExpr(3.14)],
    sum: 0.0,
  ),
  (
    name: '-3.14, -6.28, -9.42',
    values: [toExpr(-3.14), toExpr(-6.28), toExpr(-9.42)],
    sum: -3.14 - 6.28 - 9.42,
  ),
  (
    name: '3.14, 6.28',
    values: [toExpr(3.14), toExpr(6.28)],
    sum: 3.14 + 6.28,
  ),
  // Important to test that nulls are ignored when computing SUM
  (
    name: '3.14, null',
    values: [toExpr(3.14), toExpr(null)],
    sum: 3.14,
  ),
  (
    name: '3.14, null, null',
    values: [toExpr(3.14), toExpr(null), toExpr(null)],
    sum: 3.14,
  ),
  (
    name: '2.0, null, 1.0',
    values: [toExpr(2.0), toExpr(null), toExpr(1.0)],
    sum: 3.0,
  ),
  (
    name: 'null, null, null',
    // cast here is necessary for the first expression
    values: [toExpr(null).asDouble(), toExpr(null), toExpr(null)],
    sum: 0.0,
  ),
];

void main() {
  final r = TestRunner<Schema>(resetDatabaseForEachTest: false);

  for (final c in _integerCases) {
    r.addTest('{${c.name}}.sum()', (db) async {
      final sum = await c.values
          .map((v) => db.select((v,)).asQuery)
          .reduce((q1, q2) => q1.unionAll(q2))
          .sum()
          .fetch();

      check(sum).isNotNull().isCloseTo(c.sum, 0.000001);
    });
  }

  for (final c in _doubleCases) {
    r.addTest('{${c.name}}.sum()', (db) async {
      final sum = await c.values
          .map((v) => db.select((v,)).asQuery)
          .reduce((q1, q2) => q1.unionAll(q2))
          .sum()
          .fetch();

      check(sum).isNotNull().isCloseTo(c.sum, 0.000001);
    });
  }

  r.addTest('{}.sum() (emptyset)', (db) async {
    final sum = await db
        .select((toExpr(42.0),))
        .asQuery
        .where((v) => v.equalsValue(3.0))
        .sum()
        .fetch();
    check(sum).equals(0);
  });

  r.addTest('{null}.sum()', (db) async {
    final sum = await db
        .select(
          (toExpr(null).asDouble(),),
        )
        .asQuery
        .sum()
        .fetch();
    check(sum).equals(0);
  });

  r.run();
}
