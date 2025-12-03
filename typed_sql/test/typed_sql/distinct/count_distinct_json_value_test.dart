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
final _cases = [
  // Check that 3 distinct strings are distinct
  (
    name: '"A", "B", "C"',
    values: [
      JsonValue('A'),
      JsonValue('B'),
      JsonValue('C'),
    ],
    count: 3,
  ),
  // Check that duplicate strings are not distinct
  (
    name: '"A", "B", "A"',
    values: [
      JsonValue('A'),
      JsonValue('B'),
      JsonValue('A'),
    ],
    count: 2,
  ),
  // Check with numbers
  (
    name: '1, 2, 1, 3.0, 3.0',
    values: [
      JsonValue(1),
      JsonValue(2),
      JsonValue(1),
      JsonValue(3.0),
      JsonValue(3.0),
    ],
    count: 3,
  ),
  // Check with int vs double
  (
    name: '1, 1.0, 2, 2.0',
    values: [
      JsonValue(1),
      JsonValue(1.0),
      JsonValue(2),
      JsonValue(2.0),
    ],
    count: 2,
  ),
  // Check with negative int vs double
  (
    name: '-1, -1.0, -2, -2.0',
    values: [
      JsonValue(-1),
      JsonValue(-1.0),
      JsonValue(-2),
      JsonValue(-2.0),
    ],
    count: 2,
  ),
  // Check with booleans
  (
    name: 'true, false, true',
    values: [
      JsonValue(true),
      JsonValue(false),
      JsonValue(true),
    ],
    count: 2,
  ),
  // Check with null
  (
    name: 'null, null',
    values: [
      JsonValue(null),
      JsonValue(null),
    ],
    count: 1,
  ),
  // Check with empty string
  (
    name: '"" and ""',
    values: [
      JsonValue(''),
      JsonValue(''),
    ],
    count: 1,
  ),
  // Check with simple lists
  (
    name: '[1, 2], [1, 2], [2, 1]',
    values: [
      JsonValue([1, 2]),
      JsonValue([1, 2]),
      JsonValue([2, 1]),
    ],
    count: 2,
  ),
  // Check with simple maps
  (
    name: '{"a": 1}, {"a": 1}, {"b": 2}',
    values: [
      JsonValue({'a': 1}),
      JsonValue({'a': 1}),
      JsonValue({'b': 2}),
    ],
    count: 2,
  ),
  // Check with maps with different key order
  (
    name: '{"a": 1, "b": 2}, {"b": 2, "a": 1}',
    values: [
      JsonValue({'a': 1, 'b': 2}),
      JsonValue({'b': 2, 'a': 1}),
    ],
    count: 1,
  ),
  // Check with complex nested objects
  (
    name: 'complex nested objects',
    values: [
      JsonValue({
        'a': [1, 2],
        'b': {'c': 'hello'}
      }),
      JsonValue({
        'b': {'c': 'hello'},
        'a': [1, 2]
      }),
    ],
    count: 1,
  ),
  // Check with empty list
  (
    name: '[], []',
    values: [
      JsonValue([]),
      JsonValue([]),
    ],
    count: 1,
  ),
  // Check with empty map
  (
    name: '{}, {}',
    values: [
      JsonValue({}),
      JsonValue({}),
    ],
    count: 1,
  ),
  // Check empty list and empty map
  (
    name: '[], {}',
    values: [
      JsonValue([]),
      JsonValue({}),
    ],
    count: 2,
  ),
  // Check with a mix of many different things
  (
    name: 'mixed values',
    values: [
      JsonValue(null),
      JsonValue(1),
      JsonValue('A'),
      JsonValue(true),
      JsonValue([1, 'A']),
      JsonValue({'a': 1}),
      JsonValue(null),
      JsonValue([1, 'A']),
    ],
    count: 6,
  ),
  // Check with int vs double
  (
    name: '1, 1.0',
    values: [
      JsonValue(1),
      JsonValue(1.0),
    ],
    count: 1,
  ),
  // Check with map with null value
  (
    name: '{"a": null}, {"a": null}',
    values: [
      JsonValue({'a': null}),
      JsonValue({'a': null}),
    ],
    count: 1,
  ),
  // Check with list with null value
  (
    name: '[null], [null]',
    values: [
      JsonValue([null]),
      JsonValue([null]),
    ],
    count: 1,
  ),
  // Check with lists of maps
  (
    name: 'list of maps with different order',
    values: [
      JsonValue([
        {'a': 1},
        {'b': 2}
      ]),
      JsonValue([
        {'b': 2},
        {'a': 1}
      ]),
    ],
    count: 2,
  ),
  // Check with maps of lists
  (
    name: 'map of lists with different order',
    values: [
      JsonValue({
        'key': [1, 2]
      }),
      JsonValue({
        'key': [2, 1]
      }),
    ],
    count: 2,
  ),
  // Check JSON string vs native type
  (
    name: 'string "true" vs boolean true',
    values: [JsonValue('true'), JsonValue(true)],
    count: 2,
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
