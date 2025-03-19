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
    max: 2,
    min: 2,
  ),
  (
    name: '1, 2, 3',
    values: [literal(1), literal(2), literal(3)],
    max: 3,
    min: 1,
  ),
  (
    name: '42',
    values: [literal(42)],
    max: 42,
    min: 42,
  ),
  (
    name: '0, 0, 0',
    values: [literal(0), literal(0), literal(0)],
    max: 0,
    min: 0,
  ),
  (
    name: '-1, 0, 1',
    values: [literal(-1), literal(0), literal(1)],
    max: 1,
    min: -1,
  ),
  (
    name: '-1, -2, -3',
    values: [literal(-1), literal(-2), literal(-3)],
    max: -1,
    min: -3,
  ),
  (
    name: '2, 1',
    values: [literal(2), literal(1)],
    max: 2,
    min: 1,
  ),
  // Important to test that nulls are ignored when computing MAX / MIN
  (
    name: '2, null',
    values: [literal(2), literal(null)],
    max: 2,
    min: 2,
  ),
  (
    name: '2, null, null',
    values: [literal(2), literal(null), literal(null)],
    max: 2,
    min: 2,
  ),
  (
    name: '2, null, 1',
    values: [literal(2), literal(null), literal(1)],
    max: 2,
    min: 1,
  ),
  (
    name: 'null, null, null',
    // cast here is necessary for the first expression
    values: [literal(null).asInt(), literal(null), literal(null)],
    max: null,
    min: null,
  ),
];

final _doubleCases = [
  (
    name: '2.0, 2.0, 2.0',
    values: [literal(2.0), literal(2.0), literal(2.0)],
    max: 2.0,
    min: 2.0,
  ),
  (
    name: '1.0, 2.0, 3.0',
    values: [literal(1.0), literal(2.0), literal(3.0)],
    max: 3.0,
    min: 1.0,
  ),
  (
    name: '42.0',
    values: [literal(42.0)],
    max: 42.0,
    min: 42.0,
  ),
  (
    name: '0.0, 0.0, 0.0',
    values: [literal(0.0), literal(0.0), literal(0.0)],
    max: 0.0,
    min: 0.0,
  ),
  (
    name: '-1.0, 0.0, 1.0',
    values: [literal(-1.0), literal(0.0), literal(1.0)],
    max: 1.0,
    min: -1.0,
  ),
  (
    name: '-1.0, -2.0, -3.0',
    values: [literal(-1.0), literal(-2.0), literal(-3.0)],
    max: -1.0,
    min: -3.0,
  ),
  (
    name: '2.0, 1.0',
    values: [literal(2.0), literal(1.0)],
    max: 2.0,
    min: 1.0,
  ),
  (
    name: '3.14, 3.14, 3.14',
    values: [literal(3.14), literal(3.14), literal(3.14)],
    max: 3.14,
    min: 3.14,
  ),
  (
    name: '3.14, 6.28, 9.42',
    values: [literal(3.14), literal(6.28), literal(9.42)],
    max: 9.42,
    min: 3.14,
  ),
  (
    name: '3.14',
    values: [literal(3.14)],
    max: 3.14,
    min: 3.14,
  ),
  (
    name: '0.0, 3.14, 6.28',
    values: [literal(0.0), literal(3.14), literal(6.28)],
    max: 6.28,
    min: 0.0,
  ),
  (
    name: '-3.14, 0.0, 3.14',
    values: [literal(-3.14), literal(0.0), literal(3.14)],
    max: 3.14,
    min: -3.14,
  ),
  (
    name: '-3.14, -6.28, -9.42',
    values: [literal(-3.14), literal(-6.28), literal(-9.42)],
    max: -3.14,
    min: -9.42,
  ),
  (
    name: '3.14, 6.28',
    values: [literal(3.14), literal(6.28)],
    max: 6.28,
    min: 3.14,
  ),
  // Important to test that nulls are ignored when computing MAX / MIN
  (
    name: '3.14, null',
    values: [literal(3.14), literal(null)],
    max: 3.14,
    min: 3.14,
  ),
  (
    name: '3.14, null, null',
    values: [literal(3.14), literal(null), literal(null)],
    max: 3.14,
    min: 3.14,
  ),
  (
    name: '2.0, null, 1.0',
    values: [literal(2.0), literal(null), literal(1.0)],
    max: 2.0,
    min: 1.0,
  ),
  (
    name: 'null, null, null',
    // cast here is necessary for the first expression
    values: [literal(null).asDouble(), literal(null), literal(null)],
    max: null,
    min: null,
  ),
];

final _stringCases = [
  (
    name: 'a, a, a',
    values: [literal('a'), literal('a'), literal('a')],
    max: 'a',
    min: 'a',
  ),
  (
    name: 'a, b, c',
    values: [literal('a'), literal('b'), literal('c')],
    max: 'c',
    min: 'a',
  ),
  (
    name: 'abc',
    values: [literal('abc')],
    max: 'abc',
    min: 'abc',
  ),
  (
    name: '',
    values: [literal(''), literal(''), literal('')],
    max: '',
    min: '',
  ),
  (
    name: 'a, , b',
    values: [literal('a'), literal(''), literal('b')],
    max: 'b',
    min: '',
  ),
  (
    name: 'c, b, a',
    values: [literal('c'), literal('b'), literal('a')],
    max: 'c',
    min: 'a',
  ),
  (
    name: 'b, a',
    values: [literal('b'), literal('a')],
    max: 'b',
    min: 'a',
  ),
  // Important to test that nulls are ignored when computing MAX / MIN
  (
    name: 'b, null',
    values: [literal('b'), literal(null)],
    max: 'b',
    min: 'b',
  ),
  (
    name: 'b, null, null',
    values: [literal('b'), literal(null), literal(null)],
    max: 'b',
    min: 'b',
  ),
  (
    name: 'b, null, a',
    values: [literal('b'), literal(null), literal('a')],
    max: 'b',
    min: 'a',
  ),
  (
    name: 'null, null, null',
    // cast here is necessary for the first expression
    values: [literal(null).asString(), literal(null), literal(null)],
    max: null,
    min: null,
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
    max: epoch,
    min: epoch,
  ),
  (
    name: 'yesterday, today, tomorrow',
    values: [literal(yesterday), literal(today), literal(tomorrow)],
    max: tomorrow,
    min: yesterday,
  ),
  (
    name: 'today',
    values: [literal(today)],
    max: today,
    min: today,
  ),
  (
    name: 'epoch, epoch, today',
    values: [literal(epoch), literal(epoch), literal(today)],
    max: today,
    min: epoch,
  ),
  (
    name: 'tomorrow, today, yesterday',
    values: [literal(tomorrow), literal(today), literal(yesterday)],
    max: tomorrow,
    min: yesterday,
  ),
  (
    name: 'today, yesterday',
    values: [literal(today), literal(yesterday)],
    max: today,
    min: yesterday,
  ),
  // Important to test that nulls are ignored when computing MAX / MIN
  (
    name: 'today, null',
    values: [literal(today), literal(null)],
    max: today,
    min: today,
  ),
  (
    name: 'today, null, null',
    values: [literal(today), literal(null), literal(null)],
    max: today,
    min: today,
  ),
  (
    name: 'today, null, yesterday',
    values: [literal(today), literal(null), literal(yesterday)],
    max: today,
    min: yesterday,
  ),
  (
    name: 'null, null, null',
    // cast here is necessary for the first expression
    values: [literal(null).asDateTime(), literal(null), literal(null)],
    max: null,
    min: null,
  ),
];

void main() {
  final r = TestRunner<Schema>(resetDatabaseForEachTest: false);

  for (final c in _integerCases) {
    r.addTest('{${c.name}}.min()', (db) async {
      final result = await c.values
          .map((v) => db.select((v,)).asQuery)
          .reduce((q1, q2) => q1.unionAll(q2))
          .min()
          .fetch();

      check(result).equals(c.min);
    });

    r.addTest('{${c.name}}.max()', (db) async {
      final result = await c.values
          .map((v) => db.select((v,)).asQuery)
          .reduce((q1, q2) => q1.unionAll(q2))
          .max()
          .fetch();

      check(result).equals(c.max);
    });
  }

  for (final c in _doubleCases) {
    r.addTest('{${c.name}}.min()', (db) async {
      final result = await c.values
          .map((v) => db.select((v,)).asQuery)
          .reduce((q1, q2) => q1.unionAll(q2))
          .min()
          .fetch();

      check(result).equals(c.min);
    });

    r.addTest('{${c.name}}.max()', (db) async {
      final result = await c.values
          .map((v) => db.select((v,)).asQuery)
          .reduce((q1, q2) => q1.unionAll(q2))
          .max()
          .fetch();

      check(result).equals(c.max);
    });
  }

  for (final c in _stringCases) {
    r.addTest('{${c.name}}.min()', (db) async {
      final result = await c.values
          .map((v) => db.select((v,)).asQuery)
          .reduce((q1, q2) => q1.unionAll(q2))
          .min()
          .fetch();

      check(result).equals(c.min);
    });

    r.addTest('{${c.name}}.max()', (db) async {
      final result = await c.values
          .map((v) => db.select((v,)).asQuery)
          .reduce((q1, q2) => q1.unionAll(q2))
          .max()
          .fetch();

      check(result).equals(c.max);
    });
  }

  for (final c in _dateTimeCases) {
    r.addTest('{${c.name}}.min()', (db) async {
      final result = await c.values
          .map((v) => db.select((v,)).asQuery)
          .reduce((q1, q2) => q1.unionAll(q2))
          .min()
          .fetch();

      check(result).equals(c.min);
    });

    r.addTest('{${c.name}}.max()', (db) async {
      final result = await c.values
          .map((v) => db.select((v,)).asQuery)
          .reduce((q1, q2) => q1.unionAll(q2))
          .max()
          .fetch();

      check(result).equals(c.max);
    });
  }

  r.addTest('{}.min() (emptyset)', (db) async {
    final result = await db
        .select((literal(42.0),))
        .asQuery
        .where((v) => v.equalsLiteral(3.0))
        .min()
        .fetch();
    check(result).isNull();
  });

  r.addTest('{null}.min()', (db) async {
    final result = await db
        .select(
          (literal(null).asDouble(),),
        )
        .asQuery
        .min()
        .fetch();
    check(result).isNull();
  });

  r.addTest('{}.max() (emptyset)', (db) async {
    final result = await db
        .select((literal(42.0),))
        .asQuery
        .where((v) => v.equalsLiteral(3.0))
        .max()
        .fetch();
    check(result).isNull();
  });

  r.addTest('{null}.max()', (db) async {
    final result = await db
        .select(
          (literal(null).asDouble(),),
        )
        .asQuery
        .max()
        .fetch();
    check(result).isNull();
  });

  r.run();
}
