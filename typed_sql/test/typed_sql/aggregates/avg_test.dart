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
    values: [literal(2), literal(2), literal(2)],
    avg: 2,
  ),
  (
    name: '1, 2, 3',
    values: [literal(1), literal(2), literal(3)],
    avg: 2,
  ),
  (
    name: '42',
    values: [literal(42)],
    avg: 42,
  ),
  (
    name: '0, 0, 0',
    values: [literal(0), literal(0), literal(0)],
    avg: 0,
  ),
  (
    name: '-1, 0, 1',
    values: [literal(-1), literal(0), literal(1)],
    avg: 0,
  ),
  (
    name: '-1, -2, -3',
    values: [literal(-1), literal(-2), literal(-3)],
    avg: -2,
  ),
  (
    name: '2, 1',
    values: [literal(2), literal(1)],
    avg: 1.5,
  ),
  // Important to test that nulls are ignored when computing AVG
  (
    name: '2, null',
    values: [literal(2), literal(null)],
    avg: 2,
  ),
  (
    name: '2, null, null',
    values: [literal(2), literal(null), literal(null)],
    avg: 2,
  ),
  (
    name: '2, null, 1',
    values: [literal(2), literal(null), literal(1)],
    avg: 1.5,
  ),
  (
    name: 'null, null, null',
    // cast here is necessary for the first expression
    values: [literal(null).asInt(), literal(null), literal(null)],
    avg: null,
  ),
];

final _doubleCases = [
  (
    name: '2.0, 2.0, 2.0',
    values: [literal(2.0), literal(2.0), literal(2.0)],
    avg: 2.0,
  ),
  (
    name: '1.0, 2.0, 3.0',
    values: [literal(1.0), literal(2.0), literal(3.0)],
    avg: 2.0,
  ),
  (
    name: '42.0',
    values: [literal(42.0)],
    avg: 42.0,
  ),
  (
    name: '0.0, 0.0, 0.0',
    values: [literal(0.0), literal(0.0), literal(0.0)],
    avg: 0.0,
  ),
  (
    name: '-1.0, 0.0, 1.0',
    values: [literal(-1.0), literal(0.0), literal(1.0)],
    avg: 0.0,
  ),
  (
    name: '-1.0, -2.0, -3.0',
    values: [literal(-1.0), literal(-2.0), literal(-3.0)],
    avg: -2.0,
  ),
  (
    name: '2.0, 1.0',
    values: [literal(2.0), literal(1.0)],
    avg: 1.5,
  ),
  (
    name: '3.14, 3.14, 3.14',
    values: [literal(3.14), literal(3.14), literal(3.14)],
    avg: 3.14,
  ),
  (
    name: '3.14, 6.28, 9.42',
    values: [literal(3.14), literal(6.28), literal(9.42)],
    avg: 6.28,
  ),
  (
    name: '3.14',
    values: [literal(3.14)],
    avg: 3.14,
  ),
  (
    name: '0.0, 3.14, 6.28',
    values: [literal(0.0), literal(3.14), literal(6.28)],
    avg: 3.14,
  ),
  (
    name: '-3.14, 0.0, 3.14',
    values: [literal(-3.14), literal(0.0), literal(3.14)],
    avg: 0.0,
  ),
  (
    name: '-3.14, -6.28, -9.42',
    values: [literal(-3.14), literal(-6.28), literal(-9.42)],
    avg: -6.28,
  ),
  (
    name: '3.14, 6.28',
    values: [literal(3.14), literal(6.28)],
    avg: 4.71,
  ),
  // Important to test that nulls are ignored when computing AVG
  (
    name: '3.14, null',
    values: [literal(3.14), literal(null)],
    avg: 3.14,
  ),
  (
    name: '3.14, null, null',
    values: [literal(3.14), literal(null), literal(null)],
    avg: 3.14,
  ),
  (
    name: '2.0, null, 1.0',
    values: [literal(2.0), literal(null), literal(1.0)],
    avg: 1.5,
  ),
  (
    name: 'null, null, null',
    // cast here is necessary for the first expression
    values: [literal(null).asDouble(), literal(null), literal(null)],
    avg: null,
  ),
];

void main() {
  final r = TestRunner<Schema>(resetDatabaseForEachTest: false);

  for (final c in _integerCases) {
    r.addTest('{${c.name}}.avg()', (db) async {
      final avg = await c.values
          .map((v) => db.select((v,)).asQuery)
          .reduce((q1, q2) => q1.unionAll(q2))
          .avg()
          .fetch();

      if (c.avg == null) {
        check(avg).isNull();
      } else {
        check(avg).isNotNull().isCloseTo(c.avg!, 0.000001);
      }
    });
  }

  for (final c in _doubleCases) {
    r.addTest('{${c.name}}.avg()', (db) async {
      final avg = await c.values
          .map((v) => db.select((v,)).asQuery)
          .reduce((q1, q2) => q1.unionAll(q2))
          .avg()
          .fetch();

      if (c.avg == null) {
        check(avg).isNull();
      } else {
        check(avg).isNotNull().isCloseTo(c.avg!, 0.000001);
      }
    });
  }

  r.addTest('{}.avg() (emptyset)', (db) async {
    final avg = await db
        .select((literal(42.0),))
        .asQuery
        .where((v) => v.equalsLiteral(3.0))
        .avg()
        .fetch();
    check(avg).isNull();
  });

  r.addTest('{null}.avg()', (db) async {
    final avg = await db
        .select(
          (literal(null).asDouble(),),
        )
        .asQuery
        .avg()
        .fetch();
    check(avg).isNull();
  });

  r.run();
}
