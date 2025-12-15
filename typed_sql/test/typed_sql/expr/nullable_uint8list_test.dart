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
  // Tests for null and Uint8List
  (
    name: '[1,2,3] as Uint8List?',
    expr: toExpr(Uint8List.fromList([1, 2, 3]) as Uint8List?),
    expected: Uint8List.fromList([1, 2, 3]),
  ),
  (
    name: 'null as Uint8List?',
    expr: toExpr(null as Uint8List?),
    expected: null,
  ),
  (
    name: '(null as Uint8List?).orElse([1,2,3])',
    expr: toExpr(null as Uint8List?)
        .orElse(toExpr(Uint8List.fromList([1, 2, 3]))),
    expected: Uint8List.fromList([1, 2, 3]),
  ),
  (
    name: '(null as Uint8List?).orElseValue([1,2,3])',
    expr: toExpr(null as Uint8List?).orElseValue(Uint8List.fromList([1, 2, 3])),
    expected: Uint8List.fromList([1, 2, 3]),
  ),
  (
    name: '([4,5,6] as Uint8List?).orElse([1,2,3])',
    expr: toExpr(Uint8List.fromList([4, 5, 6]) as Uint8List?)
        .orElse(toExpr(Uint8List.fromList([1, 2, 3]))),
    expected: Uint8List.fromList([4, 5, 6]),
  ),
  (
    name: '([4,5,6] as Uint8List?).orElseValue([1,2,3])',
    expr: toExpr(Uint8List.fromList([4, 5, 6]) as Uint8List?)
        .orElseValue(Uint8List.fromList([1, 2, 3])),
    expected: Uint8List.fromList([4, 5, 6]),
  ),
  (
    name: 'null.asBlob()',
    expr: toExpr(null).asBlob(),
    expected: null,
  ),
  (
    name: 'null.asBlob().orElse([1,2,3])',
    expr: toExpr(null).asBlob().orElse(toExpr(Uint8List.fromList([1, 2, 3]))),
    expected: Uint8List.fromList([1, 2, 3]),
  ),
  (
    name: 'null.asBlob().orElseValue([1,2,3])',
    expr: toExpr(null).asBlob().orElseValue(Uint8List.fromList([1, 2, 3])),
    expected: Uint8List.fromList([1, 2, 3]),
  ),

  // Expr<Uint8List?>.equals
  (
    name: 'null.asBlob().equals([1,2,3])',
    expr: toExpr(null).asBlob().equals(toExpr(Uint8List.fromList([1, 2, 3]))),
    expected: false,
  ),
  (
    name: '[1,2,3].equals([1,2,3])',
    expr: toExpr(Uint8List.fromList([1, 2, 3]) as Uint8List?)
        .equals(toExpr(Uint8List.fromList([1, 2, 3]))),
    expected: true,
  ),
  (
    name: '[1,2,3].equals([3,2,1])',
    expr: toExpr(Uint8List.fromList([1, 2, 3]) as Uint8List?)
        .equals(toExpr(Uint8List.fromList([3, 2, 1]))),
    expected: false,
  ),
  (
    name: 'null.asBlob().equals([])',
    expr: toExpr(null).asBlob().equals(toExpr(Uint8List.fromList([]))),
    expected: false,
  ),
  (
    name: '[].equals([])',
    expr: toExpr(Uint8List.fromList([]) as Uint8List?)
        .equals(toExpr(Uint8List.fromList([]))),
    expected: true,
  ),

  // Expr<Uint8List?>.isNotDistinctFrom
  (
    name: 'null.asBlob().isNotDistinctFrom(null)',
    expr: toExpr(null).asBlob().isNotDistinctFrom(toExpr(null)),
    expected: true,
  ),
  (
    name: 'null.asBlob().isNotDistinctFrom([1,2,3])',
    expr: toExpr(null)
        .asBlob()
        .isNotDistinctFrom(toExpr(Uint8List.fromList([1, 2, 3]))),
    expected: false,
  ),
  (
    name: '[1,2,3].isNotDistinctFrom(null)',
    expr: toExpr(Uint8List.fromList([1, 2, 3]) as Uint8List?)
        .isNotDistinctFrom(toExpr(null)),
    expected: false,
  ),
  (
    name: '[1,2,3].isNotDistinctFrom([1,2,3])',
    expr: toExpr(Uint8List.fromList([1, 2, 3]) as Uint8List?)
        .isNotDistinctFrom(toExpr(Uint8List.fromList([1, 2, 3]))),
    expected: true,
  ),
  (
    name: 'null.asBlob().isNotDistinctFrom([])',
    expr:
        toExpr(null).asBlob().isNotDistinctFrom(toExpr(Uint8List.fromList([]))),
    expected: false,
  ),
  (
    name: '[].isNotDistinctFrom(null)',
    expr: toExpr(Uint8List.fromList([]) as Uint8List?)
        .isNotDistinctFrom(toExpr(null)),
    expected: false,
  ),
  (
    name: '[].isNotDistinctFrom([])',
    expr: toExpr(Uint8List.fromList([]) as Uint8List?)
        .isNotDistinctFrom(toExpr(Uint8List.fromList([]))),
    expected: true,
  ),

  // Expr<Uint8List?>.equalsUnlessNull
  (
    name: 'null.asBlob().equalsUnlessNull(null)',
    expr: toExpr(null).asBlob().equalsUnlessNull(toExpr(null)),
    expected: null,
  ),
  (
    name: 'null.asBlob().equalsUnlessNull([1,2,3])',
    expr: toExpr(null)
        .asBlob()
        .equalsUnlessNull(toExpr(Uint8List.fromList([1, 2, 3]))),
    expected: null,
  ),
  (
    name: '[1,2,3].equalsUnlessNull(null)',
    expr: toExpr(Uint8List.fromList([1, 2, 3]) as Uint8List?)
        .equalsUnlessNull(toExpr(null)),
    expected: null,
  ),
  (
    name: '[1,2,3].equalsUnlessNull([1,2,3])',
    expr: toExpr(Uint8List.fromList([1, 2, 3]) as Uint8List?)
        .equalsUnlessNull(toExpr(Uint8List.fromList([1, 2, 3]))),
    expected: true,
  ),
  (
    name: 'null.asBlob().equalsUnlessNull([])',
    expr:
        toExpr(null).asBlob().equalsUnlessNull(toExpr(Uint8List.fromList([]))),
    expected: null,
  ),
  (
    name: '[].equalsUnlessNull(null)',
    expr: toExpr(Uint8List.fromList([]) as Uint8List?)
        .equalsUnlessNull(toExpr(null)),
    expected: null,
  ),
  (
    name: '[].equalsUnlessNull([])',
    expr: toExpr(Uint8List.fromList([]) as Uint8List?)
        .equalsUnlessNull(toExpr(Uint8List.fromList([]))),
    expected: true,
  ),

  // Expr<Uint8List?>.notEquals
  (
    name: 'null.asBlob().notEquals([1,2,3])',
    expr:
        toExpr(null).asBlob().notEquals(toExpr(Uint8List.fromList([1, 2, 3]))),
    expected: true,
  ),
  (
    name: '[1,2,3].notEquals([1,2,3])',
    expr: toExpr(Uint8List.fromList([1, 2, 3]) as Uint8List?)
        .notEquals(toExpr(Uint8List.fromList([1, 2, 3]))),
    expected: false,
  ),
  (
    name: '[1,2,3].notEquals([3,2,1])',
    expr: toExpr(Uint8List.fromList([1, 2, 3]) as Uint8List?)
        .notEquals(toExpr(Uint8List.fromList([3, 2, 1]))),
    expected: true,
  ),
  (
    name: 'null.asBlob().notEquals([])',
    expr: toExpr(null).asBlob().notEquals(toExpr(Uint8List.fromList([]))),
    expected: true,
  ),
  (
    name: '[].notEquals([])',
    expr: toExpr(Uint8List.fromList([]) as Uint8List?)
        .notEquals(toExpr(Uint8List.fromList([]))),
    expected: false,
  ),

  // Expr<Uint8List?>.equalsValue
  (
    name: 'null.asBlob().equalsValue([1,2,3])',
    expr: toExpr(null).asBlob().equalsValue(Uint8List.fromList([1, 2, 3])),
    expected: false,
  ),
  (
    name: '[1,2,3].equalsValue([1,2,3])',
    expr: toExpr(Uint8List.fromList([1, 2, 3]) as Uint8List?)
        .equalsValue(Uint8List.fromList([1, 2, 3])),
    expected: true,
  ),
  (
    name: '[1,2,3].equalsValue([3,2,1])',
    expr: toExpr(Uint8List.fromList([1, 2, 3]) as Uint8List?)
        .equalsValue(Uint8List.fromList([3, 2, 1])),
    expected: false,
  ),
  (
    name: 'null.asBlob().equalsValue([])',
    expr: toExpr(null).asBlob().equalsValue(Uint8List.fromList([])),
    expected: false,
  ),
  (
    name: '[].equalsValue([])',
    expr: toExpr(Uint8List.fromList([]) as Uint8List?)
        .equalsValue(Uint8List.fromList([])),
    expected: true,
  ),

  // Expr<Uint8List?>.notEqualsValue
  (
    name: 'null.asBlob().notEqualsValue([1,2,3])',
    expr: toExpr(null).asBlob().notEqualsValue(Uint8List.fromList([1, 2, 3])),
    expected: true,
  ),
  (
    name: '[1,2,3].notEqualsValue([1,2,3])',
    expr: toExpr(Uint8List.fromList([1, 2, 3]) as Uint8List?)
        .notEqualsValue(Uint8List.fromList([1, 2, 3])),
    expected: false,
  ),
  (
    name: '[1,2,3].notEqualsValue([3,2,1])',
    expr: toExpr(Uint8List.fromList([1, 2, 3]) as Uint8List?)
        .notEqualsValue(Uint8List.fromList([3, 2, 1])),
    expected: true,
  ),
  (
    name: 'null.asBlob().notEqualsValue([])',
    expr: toExpr(null).asBlob().notEqualsValue(Uint8List.fromList([])),
    expected: true,
  ),
  (
    name: '[].notEqualsValue([])',
    expr: toExpr(Uint8List.fromList([]) as Uint8List?)
        .notEqualsValue(Uint8List.fromList([])),
    expected: false,
  ),

  // Expr<Uint8List?>.isNull()
  (
    name: 'null.asBlob().isNull()',
    expr: toExpr(null).asBlob().isNull(),
    expected: true,
  ),
  (
    name: '[1,2,3].isNull()',
    expr: toExpr(Uint8List.fromList([1, 2, 3]) as Uint8List?).isNull(),
    expected: false,
  ),
  (
    name: '[].isNull()',
    expr: toExpr(Uint8List.fromList([]) as Uint8List?).isNull(),
    expected: false,
  ),

  // Expr<Uint8List?>.isNotNull()
  (
    name: 'null.asBlob().isNotNull()',
    expr: toExpr(null).asBlob().isNotNull(),
    expected: false,
  ),
  (
    name: '[1,2,3].isNotNull()',
    expr: toExpr(Uint8List.fromList([1, 2, 3]) as Uint8List?).isNotNull(),
    expected: true,
  ),
  (
    name: '[].isNotNull()',
    expr: toExpr(Uint8List.fromList([]) as Uint8List?).isNotNull(),
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
