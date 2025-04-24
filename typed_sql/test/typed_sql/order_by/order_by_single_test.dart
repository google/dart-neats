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
    ascending: [2, 2, 2],
    descending: [2, 2, 2],
  ),
  (
    name: '1, 2, 3',
    values: [toExpr(1), toExpr(2), toExpr(3)],
    ascending: [1, 2, 3],
    descending: [3, 2, 1],
  ),
  (
    name: '42',
    values: [toExpr(42)],
    ascending: [42],
    descending: [42],
  ),
  (
    name: '0, 0, 0',
    values: [toExpr(0), toExpr(0), toExpr(0)],
    ascending: [0, 0, 0],
    descending: [0, 0, 0],
  ),
  (
    name: '-1, 0, 1',
    values: [toExpr(-1), toExpr(0), toExpr(1)],
    ascending: [-1, 0, 1],
    descending: [1, 0, -1],
  ),
  (
    name: '-1, -2, -3',
    values: [toExpr(-1), toExpr(-2), toExpr(-3)],
    ascending: [-3, -2, -1],
    descending: [-1, -2, -3],
  ),
  (
    name: '2, 1',
    values: [toExpr(2), toExpr(1)],
    ascending: [1, 2],
    descending: [2, 1],
  ),
  // Important to test that nulls are ignored when computing MAX / MIN
  (
    name: '2, null',
    values: [toExpr(2), toExpr(null)],
    ascending: [2, null],
    descending: [2, null],
  ),
  (
    name: '2, null, null',
    values: [toExpr(2), toExpr(null), toExpr(null)],
    ascending: [2, null, null],
    descending: [2, null, null],
  ),
  (
    name: '2, null, 1',
    values: [toExpr(2), toExpr(null), toExpr(1)],
    ascending: [1, 2, null],
    descending: [2, 1, null],
  ),
  (
    name: 'null, null, null',
    // cast here is necessary for the first expression
    values: [toExpr(null).asInt(), toExpr(null), toExpr(null)],
    ascending: [null, null, null],
    descending: [null, null, null],
  ),
];

final _doubleCases = [
  (
    name: '2.0, 2.0, 2.0',
    values: [toExpr(2.0), toExpr(2.0), toExpr(2.0)],
    ascending: [2.0, 2.0, 2.0],
    descending: [2.0, 2.0, 2.0],
  ),
  (
    name: '1.0, 2.0, 3.0',
    values: [toExpr(1.0), toExpr(2.0), toExpr(3.0)],
    ascending: [1.0, 2.0, 3.0],
    descending: [3.0, 2.0, 1.0],
  ),
  (
    name: '42.0',
    values: [toExpr(42.0)],
    ascending: [42.0],
    descending: [42.0],
  ),
  (
    name: '0.0, 0.0, 0.0',
    values: [toExpr(0.0), toExpr(0.0), toExpr(0.0)],
    ascending: [0.0, 0.0, 0.0],
    descending: [0.0, 0.0, 0.0],
  ),
  (
    name: '-1.0, 0.0, 1.0',
    values: [toExpr(-1.0), toExpr(0.0), toExpr(1.0)],
    ascending: [-1.0, 0.0, 1.0],
    descending: [1.0, 0.0, -1.0],
  ),
  (
    name: '-1.0, -2.0, -3.0',
    values: [toExpr(-1.0), toExpr(-2.0), toExpr(-3.0)],
    ascending: [-3.0, -2.0, -1.0],
    descending: [-1.0, -2.0, -3.0],
  ),
  (
    name: '2.0, 1.0',
    values: [toExpr(2.0), toExpr(1.0)],
    ascending: [1.0, 2.0],
    descending: [2.0, 1.0],
  ),
  (
    name: '3.14, 3.14, 3.14',
    values: [toExpr(3.14), toExpr(3.14), toExpr(3.14)],
    ascending: [3.14, 3.14, 3.14],
    descending: [3.14, 3.14, 3.14],
  ),
  (
    name: '3.14, 6.28, 9.42',
    values: [toExpr(3.14), toExpr(6.28), toExpr(9.42)],
    ascending: [3.14, 6.28, 9.42],
    descending: [9.42, 6.28, 3.14],
  ),
  (
    name: '3.14',
    values: [toExpr(3.14)],
    ascending: [3.14],
    descending: [3.14],
  ),
  (
    name: '0.0, 3.14, 6.28',
    values: [toExpr(0.0), toExpr(3.14), toExpr(6.28)],
    ascending: [0.0, 3.14, 6.28],
    descending: [6.28, 3.14, 0.0],
  ),
  (
    name: '-3.14, 0.0, 3.14',
    values: [toExpr(-3.14), toExpr(0.0), toExpr(3.14)],
    ascending: [-3.14, 0.0, 3.14],
    descending: [3.14, 0.0, -3.14],
  ),
  (
    name: '-3.14, -6.28, -9.42',
    values: [toExpr(-3.14), toExpr(-6.28), toExpr(-9.42)],
    ascending: [-9.42, -6.28, -3.14],
    descending: [-3.14, -6.28, -9.42],
  ),
  (
    name: '3.14, 6.28',
    values: [toExpr(3.14), toExpr(6.28)],
    ascending: [3.14, 6.28],
    descending: [6.28, 3.14],
  ),
  // Important to test that nulls are ignored when computing MAX / MIN
  (
    name: '3.14, null',
    values: [toExpr(3.14), toExpr(null)],
    ascending: [3.14, null],
    descending: [3.14, null],
  ),
  (
    name: '3.14, null, null',
    values: [toExpr(3.14), toExpr(null), toExpr(null)],
    ascending: [3.14, null, null],
    descending: [3.14, null, null],
  ),
  (
    name: '2.0, null, 1.0',
    values: [toExpr(2.0), toExpr(null), toExpr(1.0)],
    ascending: [1.0, 2.0, null],
    descending: [2.0, 1.0, null],
  ),
  (
    name: 'null, null, null',
    // cast here is necessary for the first expression
    values: [toExpr(null).asDouble(), toExpr(null), toExpr(null)],
    ascending: [null, null, null],
    descending: [null, null, null],
  ),
];

final _stringCases = [
  (
    name: 'a, a, a',
    values: [toExpr('a'), toExpr('a'), toExpr('a')],
    ascending: ['a', 'a', 'a'],
    descending: ['a', 'a', 'a'],
  ),
  (
    name: 'a, b, c',
    values: [toExpr('a'), toExpr('b'), toExpr('c')],
    ascending: ['a', 'b', 'c'],
    descending: ['c', 'b', 'a'],
  ),
  (
    name: 'abc',
    values: [toExpr('abc')],
    ascending: ['abc'],
    descending: ['abc'],
  ),
  (
    name: '',
    values: [toExpr(''), toExpr(''), toExpr('')],
    ascending: ['', '', ''],
    descending: ['', '', ''],
  ),
  (
    name: 'a, , b',
    values: [toExpr('a'), toExpr(''), toExpr('b')],
    ascending: ['', 'a', 'b'],
    descending: ['b', 'a', ''],
  ),
  (
    name: 'c, b, a',
    values: [toExpr('c'), toExpr('b'), toExpr('a')],
    ascending: ['a', 'b', 'c'],
    descending: ['c', 'b', 'a'],
  ),
  (
    name: 'b, a',
    values: [toExpr('b'), toExpr('a')],
    ascending: ['a', 'b'],
    descending: ['b', 'a'],
  ),
  // Important to test that nulls are ignored when computing MAX / MIN
  (
    name: 'b, null',
    values: [toExpr('b'), toExpr(null)],
    ascending: ['b', null],
    descending: ['b', null],
  ),
  (
    name: 'b, null, null',
    values: [toExpr('b'), toExpr(null), toExpr(null)],
    ascending: ['b', null, null],
    descending: ['b', null, null],
  ),
  (
    name: 'b, null, a',
    values: [toExpr('b'), toExpr(null), toExpr('a')],
    ascending: ['a', 'b', null],
    descending: ['b', 'a', null],
  ),
  (
    name: 'null, null, null',
    // cast here is necessary for the first expression
    values: [toExpr(null).asString(), toExpr(null), toExpr(null)],
    ascending: [null, null, null],
    descending: [null, null, null],
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
    ascending: [epoch, epoch, epoch],
    descending: [epoch, epoch, epoch],
  ),
  (
    name: 'yesterday, today, tomorrow',
    values: [toExpr(yesterday), toExpr(today), toExpr(tomorrow)],
    ascending: [yesterday, today, tomorrow],
    descending: [tomorrow, today, yesterday],
  ),
  (
    name: 'today',
    values: [toExpr(today)],
    ascending: [today],
    descending: [today],
  ),
  (
    name: 'epoch, epoch, today',
    values: [toExpr(epoch), toExpr(epoch), toExpr(today)],
    ascending: [epoch, epoch, today],
    descending: [today, epoch, epoch],
  ),
  (
    name: 'tomorrow, today, yesterday',
    values: [toExpr(tomorrow), toExpr(today), toExpr(yesterday)],
    ascending: [yesterday, today, tomorrow],
    descending: [tomorrow, today, yesterday],
  ),
  (
    name: 'today, yesterday',
    values: [toExpr(today), toExpr(yesterday)],
    ascending: [yesterday, today],
    descending: [today, yesterday],
  ),
  // Important to test that nulls are ignored when computing MAX / MIN
  (
    name: 'today, null',
    values: [toExpr(today), toExpr(null)],
    ascending: [today, null],
    descending: [today, null],
  ),
  (
    name: 'today, null, null',
    values: [toExpr(today), toExpr(null), toExpr(null)],
    ascending: [today, null, null],
    descending: [today, null, null],
  ),
  (
    name: 'today, null, yesterday',
    values: [toExpr(today), toExpr(null), toExpr(yesterday)],
    ascending: [yesterday, today, null],
    descending: [today, yesterday, null],
  ),
  (
    name: 'null, null, null',
    // cast here is necessary for the first expression
    values: [toExpr(null).asDateTime(), toExpr(null), toExpr(null)],
    ascending: [null, null, null],
    descending: [null, null, null],
  ),
];

void main() {
  final r = TestRunner<Schema>(resetDatabaseForEachTest: false);

  for (final c in _integerCases) {
    r.addTest('{${c.name}}.orderBy(.ascending)', (db) async {
      final result = await c.values
          .map((v) => db.select((v,)).asQuery)
          .reduce((q1, q2) => q1.unionAll(q2))
          .orderBy((v) => [(v, Order.ascending)])
          .fetch();

      check(result).deepEquals(c.ascending);
    });

    r.addTest('{${c.name}}.orderBy(.descending)', (db) async {
      final result = await c.values
          .map((v) => db.select((v,)).asQuery)
          .reduce((q1, q2) => q1.unionAll(q2))
          .orderBy((v) => [(v, Order.descending)])
          .fetch();

      check(result).deepEquals(c.descending);
    });
  }

  for (final c in _doubleCases) {
    r.addTest('{${c.name}}.orderBy(.ascending)', (db) async {
      final result = await c.values
          .map((v) => db.select((v,)).asQuery)
          .reduce((q1, q2) => q1.unionAll(q2))
          .orderBy((v) => [(v, Order.ascending)])
          .fetch();

      check(result).deepEquals(c.ascending);
    });

    r.addTest('{${c.name}}.orderBy(.descending)', (db) async {
      final result = await c.values
          .map((v) => db.select((v,)).asQuery)
          .reduce((q1, q2) => q1.unionAll(q2))
          .orderBy((v) => [(v, Order.descending)])
          .fetch();

      check(result).deepEquals(c.descending);
    });
  }

  for (final c in _stringCases) {
    r.addTest('{${c.name}}.orderBy(.ascending)', (db) async {
      final result = await c.values
          .map((v) => db.select((v,)).asQuery)
          .reduce((q1, q2) => q1.unionAll(q2))
          .orderBy((v) => [(v, Order.ascending)])
          .fetch();

      check(result).deepEquals(c.ascending);
    });

    r.addTest('{${c.name}}.orderBy(.descending)', (db) async {
      final result = await c.values
          .map((v) => db.select((v,)).asQuery)
          .reduce((q1, q2) => q1.unionAll(q2))
          .orderBy((v) => [(v, Order.descending)])
          .fetch();

      check(result).deepEquals(c.descending);
    });
  }

  for (final c in _dateTimeCases) {
    r.addTest('{${c.name}}.orderBy(.ascending)', (db) async {
      final result = await c.values
          .map((v) => db.select((v,)).asQuery)
          .reduce((q1, q2) => q1.unionAll(q2))
          .orderBy((v) => [(v, Order.ascending)])
          .fetch();

      check(result).deepEquals(c.ascending);
    });

    r.addTest('{${c.name}}.orderBy(.descending)', (db) async {
      final result = await c.values
          .map((v) => db.select((v,)).asQuery)
          .reduce((q1, q2) => q1.unionAll(q2))
          .orderBy((v) => [(v, Order.descending)])
          .fetch();

      check(result).deepEquals(c.descending);
    });
  }

  r.addTest('{}.orderBy(.ascending).first (emptyset)', (db) async {
    final result = await db
        .select((toExpr(42.0),))
        .asQuery
        .where((v) => v.equalsValue(3.0))
        .orderBy((v) => [(v, Order.ascending)])
        .first
        .fetch();
    check(result).isNull();
  });

  r.addTest('{null}.orderBy(.ascending).first', (db) async {
    final result = await db
        .select(
          (toExpr(null).asDouble(),),
        )
        .asQuery
        .orderBy((v) => [(v, Order.ascending)])
        .first
        .fetch();
    check(result).isNull();
  });

  r.addTest('{}.orderBy(.descending).first (emptyset)', (db) async {
    final result = await db
        .select((toExpr(42.0),))
        .asQuery
        .where((v) => v.equalsValue(3.0))
        .orderBy((v) => [(v, Order.descending)])
        .first
        .fetch();
    check(result).isNull();
  });

  r.addTest('{null}.orderBy(.descending).first', (db) async {
    final result = await db
        .select(
          (toExpr(null).asDouble(),),
        )
        .asQuery
        .orderBy((v) => [(v, Order.descending)])
        .first
        .fetch();
    check(result).isNull();
  });

  r.run();
}
