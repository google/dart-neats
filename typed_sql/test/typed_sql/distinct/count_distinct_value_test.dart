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
    values: ['A', 'B', 'C'],
    count: 3,
  ),
  (
    name: 'A, B, C, A',
    values: ['A', 'B', 'C', 'A'],
    count: 3,
  ),
  // Test with simple numbers
  (
    name: '1, 2, 3',
    values: [1, 2, 3],
    count: 3,
  ),
  (
    name: '1, 2, 3, 1, 2',
    values: [1, 2, 3, 1, 2],
    count: 3,
  ),
  // Test with double
  (
    name: '3.14, 2.71, 1.61',
    values: [3.14, 2.71, 1.61],
    count: 3,
  ),
  (
    name: '3.14, 2.71, 1.61, 2.71,',
    values: [3.14, 2.71, 1.61, 2.71],
    count: 3,
  ),
  // Test with longer strings
  (
    name: 'hello, world, dart',
    values: ['hello', 'world', 'dart'],
    count: 3,
  ),
  (
    name: 'hello, world, dart, dart, dart',
    values: ['hello', 'world', 'dart', 'dart', 'dart'],
    count: 3,
  ),
  // Test with DateTime
  (
    name: 'epoch, yesterday, today',
    values: [epoch, yesterday, today],
    count: 3,
  ),
  (
    name: 'epoch, yesterday, today, today, today',
    values: [epoch, yesterday, today, today, today],
    count: 3,
  ),
  // Test with bool
  (
    name: 'true, false, true',
    values: [true, false, true],
    count: 2,
  ),
  (
    name: 'true, true',
    values: [true, true],
    count: 1,
  ),
  (
    name: 'false, false',
    values: [false, false],
    count: 1,
  ),
];

void main() {
  final r = TestRunner<Schema>(resetDatabaseForEachTest: false);

  for (final c in _cases) {
    r.addTest('(${c.name}).distinct()', (db) async {
      final q = c.values
          .map((v) => db.select((toExpr(v),)).asQuery)
          .reduce((q1, q2) => q1.unionAll(q2));

      final result = await q.distinct().count().fetch();
      check(result).isNotNull().equals(c.count);
    });
  }

  r.run();
}
