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

import 'dart:typed_data' show Uint8List;

import 'package:typed_sql/typed_sql.dart';

import '../testrunner.dart';

final _cases = <({
  String name,
  Expr expr,
  Object? expected,
})>[
  // Tests for .equals
  (
    name: '[].equals([])',
    expr: toExpr(Uint8List.fromList([])).equals(toExpr(Uint8List.fromList([]))),
    expected: true,
  ),
  (
    name: '[1,2,3].equals([1,2,3])',
    expr: toExpr(Uint8List.fromList([1, 2, 3]))
        .equals(toExpr(Uint8List.fromList([1, 2, 3]))),
    expected: true,
  ),
  (
    name: '[1,2,3].equals([1,2])',
    expr: toExpr(Uint8List.fromList([1, 2, 3]))
        .equals(toExpr(Uint8List.fromList([1, 2]))),
    expected: false,
  ),
  (
    name: '[1,2,3].equals([])',
    expr: toExpr(Uint8List.fromList([1, 2, 3]))
        .equals(toExpr(Uint8List.fromList([]))),
    expected: false,
  ),
  (
    name: '[].equals([1,2,3])',
    expr: toExpr(Uint8List.fromList([]))
        .equals(toExpr(Uint8List.fromList([1, 2, 3]))),
    expected: false,
  ),
  (
    name: 'null.equals([1,2,3])',
    expr: toExpr(null as Uint8List?)
        .equals(toExpr(Uint8List.fromList([1, 2, 3]))),
    expected: false,
  ),
  (
    name: '[1,2,3].equals(null)',
    expr: toExpr(Uint8List.fromList([1, 2, 3]))
        .equals(toExpr(null as Uint8List?)),
    expected: false,
  ),

  // Tests for .equalsValue
  (
    name: '[].equalsValue([])',
    expr: toExpr(Uint8List.fromList([])).equalsValue(Uint8List.fromList([])),
    expected: true,
  ),
  (
    name: '[1,2,3].equalsValue([1,2,3])',
    expr: toExpr(Uint8List.fromList([1, 2, 3]))
        .equalsValue(Uint8List.fromList([1, 2, 3])),
    expected: true,
  ),
  (
    name: '[1,2,3].equalsValue([1,2])',
    expr: toExpr(Uint8List.fromList([1, 2, 3]))
        .equalsValue(Uint8List.fromList([1, 2])),
    expected: false,
  ),
  (
    name: '[1,2,3].equalsValue([])',
    expr: toExpr(Uint8List.fromList([1, 2, 3]))
        .equalsValue(Uint8List.fromList([])),
    expected: false,
  ),
  (
    name: '[].equalsValue([1,2,3])',
    expr: toExpr(Uint8List.fromList([]))
        .equalsValue(Uint8List.fromList([1, 2, 3])),
    expected: false,
  ),
  (
    name: 'null.equalsValue([1,2,3])',
    expr: toExpr(null as Uint8List?).equalsValue(Uint8List.fromList([1, 2, 3])),
    expected: false,
  ),
  (
    name: '[1,2,3].equalsValue(null)',
    expr: toExpr(Uint8List.fromList([1, 2, 3])).equalsValue(null),
    expected: false,
  ),

  // Tests for .notEquals
  (
    name: '[].notEquals([])',
    expr: toExpr(Uint8List.fromList([]))
        .notEquals(toExpr(Uint8List.fromList([]))),
    expected: false,
  ),
  (
    name: '[1,2,3].notEquals([1,2,3])',
    expr: toExpr(Uint8List.fromList([1, 2, 3]))
        .notEquals(toExpr(Uint8List.fromList([1, 2, 3]))),
    expected: false,
  ),
  (
    name: '[1,2,3].notEquals([1,2])',
    expr: toExpr(Uint8List.fromList([1, 2, 3]))
        .notEquals(toExpr(Uint8List.fromList([1, 2]))),
    expected: true,
  ),
  (
    name: '[1,2,3].notEquals([])',
    expr: toExpr(Uint8List.fromList([1, 2, 3]))
        .notEquals(toExpr(Uint8List.fromList([]))),
    expected: true,
  ),
  (
    name: '[].notEquals([1,2,3])',
    expr: toExpr(Uint8List.fromList([]))
        .notEquals(toExpr(Uint8List.fromList([1, 2, 3]))),
    expected: true,
  ),
  (
    name: 'null.notEquals([1,2,3])',
    expr: toExpr(null as Uint8List?)
        .notEquals(toExpr(Uint8List.fromList([1, 2, 3]))),
    expected: true,
  ),
  (
    name: '[1,2,3].notEquals(null)',
    expr: toExpr(Uint8List.fromList([1, 2, 3]))
        .notEquals(toExpr(null as Uint8List?)),
    expected: true,
  ),

  // Tests for .notEqualsValue
  (
    name: '[].notEqualsValue([])',
    expr: toExpr(Uint8List.fromList([])).notEqualsValue(Uint8List.fromList([])),
    expected: false,
  ),
  (
    name: '[1,2,3].notEqualsValue([1,2,3])',
    expr: toExpr(Uint8List.fromList([1, 2, 3]))
        .notEqualsValue(Uint8List.fromList([1, 2, 3])),
    expected: false,
  ),
  (
    name: '[1,2,3].notEqualsValue([1,2])',
    expr: toExpr(Uint8List.fromList([1, 2, 3]))
        .notEqualsValue(Uint8List.fromList([1, 2])),
    expected: true,
  ),
  (
    name: '[1,2,3].notEqualsValue([])',
    expr: toExpr(Uint8List.fromList([1, 2, 3]))
        .notEqualsValue(Uint8List.fromList([])),
    expected: true,
  ),
  (
    name: '[].notEqualsValue([1,2,3])',
    expr: toExpr(Uint8List.fromList([]))
        .notEqualsValue(Uint8List.fromList([1, 2, 3])),
    expected: true,
  ),
  (
    name: 'null.notEqualsValue([1,2,3])',
    expr: toExpr(null as Uint8List?)
        .notEqualsValue(Uint8List.fromList([1, 2, 3])),
    expected: true,
  ),
  (
    name: '[1,2,3].notEqualsValue(null)',
    expr: toExpr(Uint8List.fromList([1, 2, 3])).notEqualsValue(null),
    expected: true,
  ),
];

void main() {
  final r = TestRunner<Schema>(resetDatabaseForEachTest: false);
  for (final c in _cases) {
    r.addTest(c.name, (db) async {
      final result = await db.select(
        (c.expr,),
      ).fetch();

      final expected = c.expected;
      if (expected == null) {
        check(result).isNull();
      } else if (expected is List) {
        check(result).isA<List>().deepEquals(expected);
      } else {
        check(result).equals(expected);
      }
    });
  }

  r.run();
}
