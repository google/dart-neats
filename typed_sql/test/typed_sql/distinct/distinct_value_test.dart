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

final epoch = DateTime.fromMicrosecondsSinceEpoch(0).toUtc();
final yesterday = DateTime.parse('2025-03-09T11:34:36.000000Z');
final today = DateTime.parse('2025-03-10T11:34:36.000000Z');

/// Test cases with a single value in each column.
final _cases = [
  // Test with single character strings
  (
    name: 'A, B, C',
    values: [toExpr('A'), toExpr('B'), toExpr('C')],
    distinct: {'A', 'B', 'C'},
  ),
  (
    name: 'A, B, C, A',
    values: [toExpr('A'), toExpr('B'), toExpr('C'), toExpr('A')],
    distinct: {'A', 'B', 'C'},
  ),
  // Test with simple numbers
  (
    name: '1, 2, 3',
    values: [toExpr(1), toExpr(2), toExpr(3)],
    distinct: {1, 2, 3},
  ),
  (
    name: '1, 2, 3, 1, 2',
    values: [toExpr(1), toExpr(2), toExpr(3), toExpr(1), toExpr(2)],
    distinct: {1, 2, 3},
  ),
  // Test with double
  (
    name: '3.14, 2.71, 1.61',
    values: [toExpr(3.14), toExpr(2.71), toExpr(1.61)],
    distinct: {3.14, 2.71, 1.61},
  ),
  (
    name: '3.14, 2.71, 1.61, 2.71,',
    values: [toExpr(3.14), toExpr(2.71), toExpr(1.61), toExpr(2.71)],
    distinct: {3.14, 2.71, 1.61},
  ),
  // Test with longer strings
  (
    name: 'hello, world, dart',
    values: [toExpr('hello'), toExpr('world'), toExpr('dart')],
    distinct: {'hello', 'world', 'dart'},
  ),
  (
    name: 'hello, world, dart, dart, dart',
    values: [
      toExpr('hello'),
      toExpr('world'),
      toExpr('dart'),
      toExpr('dart'),
      toExpr('dart')
    ],
    distinct: {'hello', 'world', 'dart'},
  ),
  // Test with DateTime
  (
    name: 'epoch, yesterday, today',
    values: [toExpr(epoch), toExpr(yesterday), toExpr(today)],
    distinct: {epoch, yesterday, today},
  ),
  (
    name: 'epoch, yesterday, today, today, today',
    values: [
      toExpr(epoch),
      toExpr(yesterday),
      toExpr(today),
      toExpr(today),
      toExpr(today)
    ],
    distinct: {epoch, yesterday, today},
  ),
  // Test with bool
  (
    name: 'true, false, true',
    values: [toExpr(true), toExpr(false), toExpr(true)],
    distinct: {true, false},
  ),
  (
    name: 'true, true',
    values: [toExpr(true), toExpr(true)],
    distinct: {true},
  ),
  (
    name: 'false, false',
    values: [toExpr(false), toExpr(false)],
    distinct: {false},
  ),
];

void main() {
  final r = TestRunner<Schema>(resetDatabaseForEachTest: false);

  for (final c in _cases) {
    r.addTest('(${c.name}).distinct()', (db) async {
      final q = c.values
          .map((v) => db.select((v,)).asQuery)
          .reduce((q1, q2) => q1.unionAll(q2));

      final result = await q.distinct().fetch();
      check(result).unorderedEquals(c.distinct);
    });
  }

  r.run();
}
