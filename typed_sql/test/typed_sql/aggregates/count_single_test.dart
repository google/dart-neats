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
    count: 3,
  ),
  (
    name: '1, 2, 3',
    values: [literal(1), literal(2), literal(3)],
    count: 3,
  ),
  (
    name: '42',
    values: [literal(42)],
    count: 1,
  ),
  (
    name: '0, 0, 0',
    values: [literal(0), literal(0), literal(0)],
    count: 3,
  ),
  (
    name: '-1, 0, 1',
    values: [literal(-1), literal(0), literal(1)],
    count: 3,
  ),
  (
    name: '-1, -2, -3',
    values: [literal(-1), literal(-2), literal(-3)],
    count: 3,
  ),
  (
    name: '2, 1',
    values: [literal(2), literal(1)],
    count: 2,
  ),
  // Important to test that nulls are counted!
  (
    name: '2, null',
    values: [literal(2), literal(null)],
    count: 2,
  ),
  (
    name: '2, null, null',
    values: [literal(2), literal(null), literal(null)],
    count: 3,
  ),
  (
    name: '2, null, 1',
    values: [literal(2), literal(null), literal(1)],
    count: 3,
  ),
  (
    name: 'null, null, null',
    // cast here is necessary for the first expression
    values: [literal(null).asInt(), literal(null), literal(null)],
    count: 3,
  ),
];

final _doubleCases = [
  (
    name: '2.0, 2.0, 2.0',
    values: [literal(2.0), literal(2.0), literal(2.0)],
    count: 3,
  ),
  (
    name: '1.0, 2.0, 3.0',
    values: [literal(1.0), literal(2.0), literal(3.0)],
    count: 3,
  ),
  (
    name: '42.0',
    values: [literal(42.0)],
    count: 1,
  ),
  (
    name: '0.0, 0.0, 0.0',
    values: [literal(0.0), literal(0.0), literal(0.0)],
    count: 3,
  ),
  (
    name: '-1.0, 0.0, 1.0',
    values: [literal(-1.0), literal(0.0), literal(1.0)],
    count: 3,
  ),
  (
    name: '-1.0, -2.0, -3.0',
    values: [literal(-1.0), literal(-2.0), literal(-3.0)],
    count: 3,
  ),
  (
    name: '2.0, 1.0',
    values: [literal(2.0), literal(1.0)],
    count: 2,
  ),
  (
    name: '3.14, 3.14, 3.14',
    values: [literal(3.14), literal(3.14), literal(3.14)],
    count: 3,
  ),
  (
    name: '3.14, 6.28, 9.42',
    values: [literal(3.14), literal(6.28), literal(9.42)],
    count: 3,
  ),
  (
    name: '3.14',
    values: [literal(3.14)],
    count: 1,
  ),
  (
    name: '0.0, 3.14, 6.28',
    values: [literal(0.0), literal(3.14), literal(6.28)],
    count: 3,
  ),
  (
    name: '-3.14, 0.0, 3.14',
    values: [literal(-3.14), literal(0.0), literal(3.14)],
    count: 3,
  ),
  (
    name: '-3.14, -6.28, -9.42',
    values: [literal(-3.14), literal(-6.28), literal(-9.42)],
    count: 3,
  ),
  (
    name: '3.14, 6.28',
    values: [literal(3.14), literal(6.28)],
    count: 2,
  ),
  // Important to test that nulls are counted!
  (
    name: '3.14, null',
    values: [literal(3.14), literal(null)],
    count: 2,
  ),
  (
    name: '3.14, null, null',
    values: [literal(3.14), literal(null), literal(null)],
    count: 3,
  ),
  (
    name: '2.0, null, 1.0',
    values: [literal(2.0), literal(null), literal(1.0)],
    count: 3,
  ),
  (
    name: 'null, null, null',
    // cast here is necessary for the first expression
    values: [literal(null).asDouble(), literal(null), literal(null)],
    count: 3,
  ),
];

final _stringCases = [
  (
    name: 'a, a, a',
    values: [literal('a'), literal('a'), literal('a')],
    count: 3,
  ),
  (
    name: 'a, b, c',
    values: [literal('a'), literal('b'), literal('c')],
    count: 3,
  ),
  (
    name: 'abc',
    values: [literal('abc')],
    count: 1,
  ),
  (
    name: '',
    values: [literal(''), literal(''), literal('')],
    count: 3,
  ),
  (
    name: 'a, , b',
    values: [literal('a'), literal(''), literal('b')],
    count: 3,
  ),
  (
    name: 'c, b, a',
    values: [literal('c'), literal('b'), literal('a')],
    count: 3,
  ),
  (
    name: 'b, a',
    values: [literal('b'), literal('a')],
    count: 2,
  ),
  // Important to test that nulls are counted
  (
    name: 'b, null',
    values: [literal('b'), literal(null)],
    count: 2,
  ),
  (
    name: 'b, null, null',
    values: [literal('b'), literal(null), literal(null)],
    count: 3,
  ),
  (
    name: 'b, null, a',
    values: [literal('b'), literal(null), literal('a')],
    count: 3,
  ),
  (
    name: 'null, null, null',
    // cast here is necessary for the first expression
    values: [literal(null).asString(), literal(null), literal(null)],
    count: 3,
  ),
];

final epoch = DateTime.fromMicrosecondsSinceEpoch(0).toUtc();
final yesterday = DateTime.parse('2025-03-09T11:34:36.164006Z');
final today = DateTime.parse('2025-03-10T11:34:36.164006Z');
final tomorrow = DateTime.parse('2025-03-11T11:34:36.164006Z');

final _dateTimeCases = [
  (
    name: 'epoch, epoch, epoch',
    values: [literal(epoch), literal(epoch), literal(epoch)],
    count: 3,
  ),
  (
    name: 'yesterday, today, tomorrow',
    values: [literal(yesterday), literal(today), literal(tomorrow)],
    count: 3,
  ),
  (
    name: 'today',
    values: [literal(today)],
    count: 1,
  ),
  (
    name: 'epoch, epoch, today',
    values: [literal(epoch), literal(epoch), literal(today)],
    count: 3,
  ),
  (
    name: 'tomorrow, today, yesterday',
    values: [literal(tomorrow), literal(today), literal(yesterday)],
    count: 3,
  ),
  (
    name: 'today, yesterday',
    values: [literal(today), literal(yesterday)],
    count: 2,
  ),
  // Important to test that nulls are ignored when computing MAX / MIN
  (
    name: 'today, null',
    values: [literal(today), literal(null)],
    count: 2,
  ),
  (
    name: 'today, null, null',
    values: [literal(today), literal(null), literal(null)],
    count: 3,
  ),
  (
    name: 'today, null, yesterday',
    values: [literal(today), literal(null), literal(yesterday)],
    count: 3,
  ),
  (
    name: 'null, null, null',
    // cast here is necessary for the first expression
    values: [literal(null).asDateTime(), literal(null), literal(null)],
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
        .select((literal(42.0),))
        .asQuery
        .where((v) => v.equalsLiteral(3.0))
        .count()
        .fetch();
    check(result).isNotNull().equals(0);
  });

  r.addTest('{null}.count()', (db) async {
    final result = await db
        .select(
          (literal(null).asDouble(),),
        )
        .asQuery
        .count()
        .fetch();
    check(result).isNotNull().equals(1);
  });

  r.run();
}
