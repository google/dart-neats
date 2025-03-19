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
final yesterday = DateTime.parse('2025-03-09T11:34:36.164006Z');
final today = DateTime.parse('2025-03-10T11:34:36.164006Z');

/// Test cases with a single value in each column.
final _cases = [
  // Test with single character strings
  (
    name: 'A, B, C',
    values: [literal('A'), literal('B'), literal('C')],
    distinct: {'A', 'B', 'C'},
  ),
  (
    name: 'A, B, C, A',
    values: [literal('A'), literal('B'), literal('C'), literal('A')],
    distinct: {'A', 'B', 'C'},
  ),
  // Test with simple numbers
  (
    name: '1, 2, 3',
    values: [literal(1), literal(2), literal(3)],
    distinct: {1, 2, 3},
  ),
  (
    name: '1, 2, 3, 1, 2',
    values: [literal(1), literal(2), literal(3), literal(1), literal(2)],
    distinct: {1, 2, 3},
  ),
  // Test with double
  (
    name: '3.14, 2.71, 1.61',
    values: [literal(3.14), literal(2.71), literal(1.61)],
    distinct: {3.14, 2.71, 1.61},
  ),
  (
    name: '3.14, 2.71, 1.61, 2.71,',
    values: [literal(3.14), literal(2.71), literal(1.61), literal(2.71)],
    distinct: {3.14, 2.71, 1.61},
  ),
  // Test with longer strings
  (
    name: 'hello, world, dart',
    values: [literal('hello'), literal('world'), literal('dart')],
    distinct: {'hello', 'world', 'dart'},
  ),
  (
    name: 'hello, world, dart, dart, dart',
    values: [
      literal('hello'),
      literal('world'),
      literal('dart'),
      literal('dart'),
      literal('dart')
    ],
    distinct: {'hello', 'world', 'dart'},
  ),
  // Test with DateTime
  (
    name: 'epoch, yesterday, today',
    values: [literal(epoch), literal(yesterday), literal(today)],
    distinct: {epoch, yesterday, today},
  ),
  (
    name: 'epoch, yesterday, today, today, today',
    values: [
      literal(epoch),
      literal(yesterday),
      literal(today),
      literal(today),
      literal(today)
    ],
    distinct: {epoch, yesterday, today},
  ),
  // Test with bool
  (
    name: 'true, false, true',
    values: [literal(true), literal(false), literal(true)],
    distinct: {true, false},
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
