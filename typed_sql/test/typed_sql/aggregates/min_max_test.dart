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
    max: 2,
    min: 2,
  ),
  (
    name: '1, 2, 3',
    values: [toExpr(1), toExpr(2), toExpr(3)],
    max: 3,
    min: 1,
  ),
  (
    name: '42',
    values: [toExpr(42)],
    max: 42,
    min: 42,
  ),
  (
    name: '0, 0, 0',
    values: [toExpr(0), toExpr(0), toExpr(0)],
    max: 0,
    min: 0,
  ),
  (
    name: '-1, 0, 1',
    values: [toExpr(-1), toExpr(0), toExpr(1)],
    max: 1,
    min: -1,
  ),
  (
    name: '-1, -2, -3',
    values: [toExpr(-1), toExpr(-2), toExpr(-3)],
    max: -1,
    min: -3,
  ),
  (
    name: '2, 1',
    values: [toExpr(2), toExpr(1)],
    max: 2,
    min: 1,
  ),
  // Important to test that nulls are ignored when computing MAX / MIN
  (
    name: '2, null',
    values: [toExpr(2), toExpr(null)],
    max: 2,
    min: 2,
  ),
  (
    name: '2, null, null',
    values: [toExpr(2), toExpr(null), toExpr(null)],
    max: 2,
    min: 2,
  ),
  (
    name: '2, null, 1',
    values: [toExpr(2), toExpr(null), toExpr(1)],
    max: 2,
    min: 1,
  ),
  (
    name: 'null, null, null',
    // cast here is necessary for the first expression
    values: [toExpr(null).asInt(), toExpr(null), toExpr(null)],
    max: null,
    min: null,
  ),
];

final _doubleCases = [
  (
    name: '2.0, 2.0, 2.0',
    values: [toExpr(2.0), toExpr(2.0), toExpr(2.0)],
    max: 2.0,
    min: 2.0,
  ),
  (
    name: '1.0, 2.0, 3.0',
    values: [toExpr(1.0), toExpr(2.0), toExpr(3.0)],
    max: 3.0,
    min: 1.0,
  ),
  (
    name: '42.0',
    values: [toExpr(42.0)],
    max: 42.0,
    min: 42.0,
  ),
  (
    name: '0.0, 0.0, 0.0',
    values: [toExpr(0.0), toExpr(0.0), toExpr(0.0)],
    max: 0.0,
    min: 0.0,
  ),
  (
    name: '-1.0, 0.0, 1.0',
    values: [toExpr(-1.0), toExpr(0.0), toExpr(1.0)],
    max: 1.0,
    min: -1.0,
  ),
  (
    name: '-1.0, -2.0, -3.0',
    values: [toExpr(-1.0), toExpr(-2.0), toExpr(-3.0)],
    max: -1.0,
    min: -3.0,
  ),
  (
    name: '2.0, 1.0',
    values: [toExpr(2.0), toExpr(1.0)],
    max: 2.0,
    min: 1.0,
  ),
  (
    name: '3.14, 3.14, 3.14',
    values: [toExpr(3.14), toExpr(3.14), toExpr(3.14)],
    max: 3.14,
    min: 3.14,
  ),
  (
    name: '3.14, 6.28, 9.42',
    values: [toExpr(3.14), toExpr(6.28), toExpr(9.42)],
    max: 9.42,
    min: 3.14,
  ),
  (
    name: '3.14',
    values: [toExpr(3.14)],
    max: 3.14,
    min: 3.14,
  ),
  (
    name: '0.0, 3.14, 6.28',
    values: [toExpr(0.0), toExpr(3.14), toExpr(6.28)],
    max: 6.28,
    min: 0.0,
  ),
  (
    name: '-3.14, 0.0, 3.14',
    values: [toExpr(-3.14), toExpr(0.0), toExpr(3.14)],
    max: 3.14,
    min: -3.14,
  ),
  (
    name: '-3.14, -6.28, -9.42',
    values: [toExpr(-3.14), toExpr(-6.28), toExpr(-9.42)],
    max: -3.14,
    min: -9.42,
  ),
  (
    name: '3.14, 6.28',
    values: [toExpr(3.14), toExpr(6.28)],
    max: 6.28,
    min: 3.14,
  ),
  // Important to test that nulls are ignored when computing MAX / MIN
  (
    name: '3.14, null',
    values: [toExpr(3.14), toExpr(null)],
    max: 3.14,
    min: 3.14,
  ),
  (
    name: '3.14, null, null',
    values: [toExpr(3.14), toExpr(null), toExpr(null)],
    max: 3.14,
    min: 3.14,
  ),
  (
    name: '2.0, null, 1.0',
    values: [toExpr(2.0), toExpr(null), toExpr(1.0)],
    max: 2.0,
    min: 1.0,
  ),
  (
    name: 'null, null, null',
    // cast here is necessary for the first expression
    values: [toExpr(null).asDouble(), toExpr(null), toExpr(null)],
    max: null,
    min: null,
  ),
];

final _stringCases = [
  (
    name: 'a, a, a',
    values: [toExpr('a'), toExpr('a'), toExpr('a')],
    max: 'a',
    min: 'a',
  ),
  (
    name: 'a, b, c',
    values: [toExpr('a'), toExpr('b'), toExpr('c')],
    max: 'c',
    min: 'a',
  ),
  (
    name: 'abc',
    values: [toExpr('abc')],
    max: 'abc',
    min: 'abc',
  ),
  (
    name: '',
    values: [toExpr(''), toExpr(''), toExpr('')],
    max: '',
    min: '',
  ),
  (
    name: 'a, , b',
    values: [toExpr('a'), toExpr(''), toExpr('b')],
    max: 'b',
    min: '',
  ),
  (
    name: 'c, b, a',
    values: [toExpr('c'), toExpr('b'), toExpr('a')],
    max: 'c',
    min: 'a',
  ),
  (
    name: 'b, a',
    values: [toExpr('b'), toExpr('a')],
    max: 'b',
    min: 'a',
  ),
  // Important to test that nulls are ignored when computing MAX / MIN
  (
    name: 'b, null',
    values: [toExpr('b'), toExpr(null)],
    max: 'b',
    min: 'b',
  ),
  (
    name: 'b, null, null',
    values: [toExpr('b'), toExpr(null), toExpr(null)],
    max: 'b',
    min: 'b',
  ),
  (
    name: 'b, null, a',
    values: [toExpr('b'), toExpr(null), toExpr('a')],
    max: 'b',
    min: 'a',
  ),
  (
    name: 'null, null, null',
    // cast here is necessary for the first expression
    values: [toExpr(null).asString(), toExpr(null), toExpr(null)],
    max: null,
    min: null,
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
    max: epoch,
    min: epoch,
  ),
  (
    name: 'yesterday, today, tomorrow',
    values: [toExpr(yesterday), toExpr(today), toExpr(tomorrow)],
    max: tomorrow,
    min: yesterday,
  ),
  (
    name: 'today',
    values: [toExpr(today)],
    max: today,
    min: today,
  ),
  (
    name: 'epoch, epoch, today',
    values: [toExpr(epoch), toExpr(epoch), toExpr(today)],
    max: today,
    min: epoch,
  ),
  (
    name: 'tomorrow, today, yesterday',
    values: [toExpr(tomorrow), toExpr(today), toExpr(yesterday)],
    max: tomorrow,
    min: yesterday,
  ),
  (
    name: 'today, yesterday',
    values: [toExpr(today), toExpr(yesterday)],
    max: today,
    min: yesterday,
  ),
  // Important to test that nulls are ignored when computing MAX / MIN
  (
    name: 'today, null',
    values: [toExpr(today), toExpr(null)],
    max: today,
    min: today,
  ),
  (
    name: 'today, null, null',
    values: [toExpr(today), toExpr(null), toExpr(null)],
    max: today,
    min: today,
  ),
  (
    name: 'today, null, yesterday',
    values: [toExpr(today), toExpr(null), toExpr(yesterday)],
    max: today,
    min: yesterday,
  ),
  (
    name: 'null, null, null',
    // cast here is necessary for the first expression
    values: [toExpr(null).asDateTime(), toExpr(null), toExpr(null)],
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
        .select((toExpr(42.0),))
        .asQuery
        .where((v) => v.equalsValue(3.0))
        .min()
        .fetch();
    check(result).isNull();
  });

  r.addTest('{null}.min()', (db) async {
    final result = await db
        .select(
          (toExpr(null).asDouble(),),
        )
        .asQuery
        .min()
        .fetch();
    check(result).isNull();
  });

  r.addTest('{}.max() (emptyset)', (db) async {
    final result = await db
        .select((toExpr(42.0),))
        .asQuery
        .where((v) => v.equalsValue(3.0))
        .max()
        .fetch();
    check(result).isNull();
  });

  r.addTest('{null}.max()', (db) async {
    final result = await db
        .select(
          (toExpr(null).asDouble(),),
        )
        .asQuery
        .max()
        .fetch();
    check(result).isNull();
  });

  r.run();
}
