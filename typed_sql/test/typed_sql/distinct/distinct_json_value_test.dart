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

import 'package:collection/collection.dart';
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
    distinct: {'A', 'B', 'C'},
  ),

  // Check that duplicate strings are not distinct
  (
    name: '"A", "B", "A"',
    values: [
      JsonValue('A'),
      JsonValue('B'),
      JsonValue('A'),
    ],
    distinct: {'A', 'B'},
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
    distinct: {1, 2, 3.0},
  ),

  // Check with booleans
  (
    name: 'true, false, true',
    values: [
      JsonValue(true),
      JsonValue(false),
      JsonValue(true),
    ],
    distinct: {true, false},
  ),

  // Check with null
  (
    name: 'null, null',
    values: [
      JsonValue(null),
      JsonValue(null),
    ],
    distinct: {null},
  ),

  // Check with empty string
  (
    name: '"" and ""',
    values: [
      JsonValue(''),
      JsonValue(''),
    ],
    distinct: {''},
  ),

  // Check with simple lists
  (
    name: '[1, 2], [1, 2], [2, 1]',
    values: [
      JsonValue([1, 2]),
      JsonValue([1, 2]),
      JsonValue([2, 1]),
    ],
    distinct: {
      [1, 2],
      [2, 1]
    },
  ),

  // Check with simple maps
  (
    name: '{"a": 1}, {"a": 1}, {"b": 2}',
    values: [
      JsonValue({'a': 1}),
      JsonValue({'a': 1}),
      JsonValue({'b': 2}),
    ],
    distinct: {
      {'a': 1},
      {'b': 2}
    },
  ),

  // Check with maps with different key order
  (
    name: '{"a": 1, "b": 2}, {"b": 2, "a": 1}',
    values: [
      JsonValue({'a': 1, 'b': 2}),
      JsonValue({'b': 2, 'a': 1}),
    ],
    distinct: {
      {'a': 1, 'b': 2}
    },
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
    distinct: {
      {
        'a': [1, 2],
        'b': {'c': 'hello'}
      }
    },
  ),
];

void main() {
  final r = TestRunner<Schema>(resetDatabaseForEachTest: false);

  for (final c in _cases) {
    r.addTest('(${c.name}).distinct()', (db) async {
      final q = c.values
          .map((v) => db.select((toExpr(v),)).asQuery)
          .reduce((q1, q2) => q1.unionAll(q2));

      final result = await q.distinct().fetch();
      final values = result.map((e) => e.value).toSet();

      check(values).length.equals(c.distinct.length);

      // Check distinct contains all values v
      for (final v in values) {
        var hasV = false;
        for (final d in c.distinct) {
          hasV |= const DeepCollectionEquality().equals(v, d);
        }
        if (!hasV) {
          fail('Expected ${c.distinct} to contain $v (from database)');
        }
      }

      // Check that values contain all distinct values d
      for (final d in c.distinct) {
        var hasD = false;
        for (final v in values) {
          hasD |= const DeepCollectionEquality().equals(v, d);
        }
        if (!hasD) {
          fail('Expected $values (from database) to contain $d');
        }
      }
    }, skipPostgres: 'JSON output from postgres driver is not decoded JSONB');
  }

  r.run();
}
