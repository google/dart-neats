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
    count: 3,
  ),
  (
    name: '1, 2, 3',
    values: [toExpr(1), toExpr(2), toExpr(3)],
    count: 3,
  ),
  (
    name: '42',
    values: [toExpr(42)],
    count: 1,
  ),
  (
    name: '0, 0, 0',
    values: [toExpr(0), toExpr(0), toExpr(0)],
    count: 3,
  ),
  (
    name: '-1, 0, 1',
    values: [toExpr(-1), toExpr(0), toExpr(1)],
    count: 3,
  ),
  (
    name: '-1, -2, -3',
    values: [toExpr(-1), toExpr(-2), toExpr(-3)],
    count: 3,
  ),
  (
    name: '2, 1',
    values: [toExpr(2), toExpr(1)],
    count: 2,
  ),
  // Important to test that nulls are counted!
  (
    name: '2, null',
    values: [toExpr(2), toExpr(null)],
    count: 2,
  ),
  (
    name: '2, null, null',
    values: [toExpr(2), toExpr(null), toExpr(null)],
    count: 3,
  ),
  (
    name: '2, null, 1',
    values: [toExpr(2), toExpr(null), toExpr(1)],
    count: 3,
  ),
  (
    name: 'null, null, null',
    // cast here is necessary for the first expression
    values: [toExpr(null).asInt(), toExpr(null), toExpr(null)],
    count: 3,
  ),
];

final _doubleCases = [
  (
    name: '2.0, 2.0, 2.0',
    values: [toExpr(2.0), toExpr(2.0), toExpr(2.0)],
    count: 3,
  ),
  (
    name: '1.0, 2.0, 3.0',
    values: [toExpr(1.0), toExpr(2.0), toExpr(3.0)],
    count: 3,
  ),
  (
    name: '42.0',
    values: [toExpr(42.0)],
    count: 1,
  ),
  (
    name: '0.0, 0.0, 0.0',
    values: [toExpr(0.0), toExpr(0.0), toExpr(0.0)],
    count: 3,
  ),
  (
    name: '-1.0, 0.0, 1.0',
    values: [toExpr(-1.0), toExpr(0.0), toExpr(1.0)],
    count: 3,
  ),
  (
    name: '-1.0, -2.0, -3.0',
    values: [toExpr(-1.0), toExpr(-2.0), toExpr(-3.0)],
    count: 3,
  ),
  (
    name: '2.0, 1.0',
    values: [toExpr(2.0), toExpr(1.0)],
    count: 2,
  ),
  (
    name: '3.14, 3.14, 3.14',
    values: [toExpr(3.14), toExpr(3.14), toExpr(3.14)],
    count: 3,
  ),
  (
    name: '3.14, 6.28, 9.42',
    values: [toExpr(3.14), toExpr(6.28), toExpr(9.42)],
    count: 3,
  ),
  (
    name: '3.14',
    values: [toExpr(3.14)],
    count: 1,
  ),
  (
    name: '0.0, 3.14, 6.28',
    values: [toExpr(0.0), toExpr(3.14), toExpr(6.28)],
    count: 3,
  ),
  (
    name: '-3.14, 0.0, 3.14',
    values: [toExpr(-3.14), toExpr(0.0), toExpr(3.14)],
    count: 3,
  ),
  (
    name: '-3.14, -6.28, -9.42',
    values: [toExpr(-3.14), toExpr(-6.28), toExpr(-9.42)],
    count: 3,
  ),
  (
    name: '3.14, 6.28',
    values: [toExpr(3.14), toExpr(6.28)],
    count: 2,
  ),
  // Important to test that nulls are counted!
  (
    name: '3.14, null',
    values: [toExpr(3.14), toExpr(null)],
    count: 2,
  ),
  (
    name: '3.14, null, null',
    values: [toExpr(3.14), toExpr(null), toExpr(null)],
    count: 3,
  ),
  (
    name: '2.0, null, 1.0',
    values: [toExpr(2.0), toExpr(null), toExpr(1.0)],
    count: 3,
  ),
  (
    name: 'null, null, null',
    // cast here is necessary for the first expression
    values: [toExpr(null).asDouble(), toExpr(null), toExpr(null)],
    count: 3,
  ),
];

final _stringCases = [
  (
    name: 'a, a, a',
    values: [toExpr('a'), toExpr('a'), toExpr('a')],
    count: 3,
  ),
  (
    name: 'a, b, c',
    values: [toExpr('a'), toExpr('b'), toExpr('c')],
    count: 3,
  ),
  (
    name: 'abc',
    values: [toExpr('abc')],
    count: 1,
  ),
  (
    name: '',
    values: [toExpr(''), toExpr(''), toExpr('')],
    count: 3,
  ),
  (
    name: 'a, , b',
    values: [toExpr('a'), toExpr(''), toExpr('b')],
    count: 3,
  ),
  (
    name: 'c, b, a',
    values: [toExpr('c'), toExpr('b'), toExpr('a')],
    count: 3,
  ),
  (
    name: 'b, a',
    values: [toExpr('b'), toExpr('a')],
    count: 2,
  ),
  // Important to test that nulls are counted
  (
    name: 'b, null',
    values: [toExpr('b'), toExpr(null)],
    count: 2,
  ),
  (
    name: 'b, null, null',
    values: [toExpr('b'), toExpr(null), toExpr(null)],
    count: 3,
  ),
  (
    name: 'b, null, a',
    values: [toExpr('b'), toExpr(null), toExpr('a')],
    count: 3,
  ),
  (
    name: 'null, null, null',
    // cast here is necessary for the first expression
    values: [toExpr(null).asString(), toExpr(null), toExpr(null)],
    count: 3,
  ),
];

final epoch = DateTime.fromMicrosecondsSinceEpoch(0).toUtc();
final yesterday = DateTime.parse('2025-03-09T11:34:36.000000Z');
final today = DateTime.parse('2025-03-10T11:34:36.000000Z');
final tomorrow = DateTime.parse('2025-03-11T11:34:36.000000Z');

final _dateTimeCases = [
  (
    name: 'epoch, epoch, epoch',
    values: [toExpr(epoch), toExpr(epoch), toExpr(epoch)],
    count: 3,
  ),
  (
    name: 'yesterday, today, tomorrow',
    values: [toExpr(yesterday), toExpr(today), toExpr(tomorrow)],
    count: 3,
  ),
  (
    name: 'today',
    values: [toExpr(today)],
    count: 1,
  ),
  (
    name: 'epoch, epoch, today',
    values: [toExpr(epoch), toExpr(epoch), toExpr(today)],
    count: 3,
  ),
  (
    name: 'tomorrow, today, yesterday',
    values: [toExpr(tomorrow), toExpr(today), toExpr(yesterday)],
    count: 3,
  ),
  (
    name: 'today, yesterday',
    values: [toExpr(today), toExpr(yesterday)],
    count: 2,
  ),
  // Important to test that nulls are ignored when computing MAX / MIN
  (
    name: 'today, null',
    values: [toExpr(today), toExpr(null)],
    count: 2,
  ),
  (
    name: 'today, null, null',
    values: [toExpr(today), toExpr(null), toExpr(null)],
    count: 3,
  ),
  (
    name: 'today, null, yesterday',
    values: [toExpr(today), toExpr(null), toExpr(yesterday)],
    count: 3,
  ),
  (
    name: 'null, null, null',
    // cast here is necessary for the first expression
    values: [toExpr(null).asDateTime(), toExpr(null), toExpr(null)],
    count: 3,
  ),
];

void main() {
  final r = TestRunner<Schema>(resetDatabaseForEachTest: false);

  for (final c in _integerCases) {
    r.addTest('{${c.name}}.count()', (db) async {
      final result = await c.values
          .map((v) => db.select((v,)).asQuery)
          .reduce((q1, q2) => q1.unionAll(q2))
          .count()
          .fetch();

      check(result).equals(c.count);
    });
  }

  for (final c in _doubleCases) {
    r.addTest('{${c.name}}.count()', (db) async {
      final result = await c.values
          .map((v) => db.select((v,)).asQuery)
          .reduce((q1, q2) => q1.unionAll(q2))
          .count()
          .fetch();

      check(result).equals(c.count);
    });
  }

  for (final c in _stringCases) {
    r.addTest('{${c.name}}.count()', (db) async {
      final result = await c.values
          .map((v) => db.select((v,)).asQuery)
          .reduce((q1, q2) => q1.unionAll(q2))
          .count()
          .fetch();

      check(result).equals(c.count);
    });
  }

  for (final c in _dateTimeCases) {
    r.addTest('{${c.name}}.count()', (db) async {
      final result = await c.values
          .map((v) => db.select((v,)).asQuery)
          .reduce((q1, q2) => q1.unionAll(q2))
          .count()
          .fetch();

      check(result).equals(c.count);
    });
  }

  r.addTest('{}.count() (emptyset)', (db) async {
    final result = await db
        .select((toExpr(42.0),))
        .asQuery
        .where((v) => v.equalsLiteral(3.0))
        .count()
        .fetch();
    check(result).isNotNull().equals(0);
  });

  r.addTest('{null}.count()', (db) async {
    final result = await db
        .select(
          (toExpr(null).asDouble(),),
        )
        .asQuery
        .count()
        .fetch();
    check(result).isNotNull().equals(1);
  });

  r.run();
}
