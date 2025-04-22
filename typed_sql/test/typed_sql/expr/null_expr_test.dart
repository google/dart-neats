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

import 'dart:typed_data';

import 'package:typed_sql/typed_sql.dart';

import '../testrunner.dart';

final epoch = DateTime.fromMicrosecondsSinceEpoch(0).toUtc();
final today = DateTime.parse('2025-03-10T11:34:36.000000Z');

final _cases = <({
  String name,
  Expr expr,
  Object? expected,
})>[
  // Tests for null and bool
  (
    name: 'true as bool?',
    expr: toExpr(true as bool?),
    expected: true,
  ),
  (
    name: 'null as bool?',
    expr: toExpr(null as bool?),
    expected: null,
  ),
  (
    name: '(null as bool?).orElse(true)',
    expr: toExpr(null as bool?).orElse(toExpr(true)),
    expected: true,
  ),
  (
    name: '(null as bool?).orElseValue(true)',
    expr: toExpr(null as bool?).orElseValue(true),
    expected: true,
  ),
  (
    name: '(false as bool?).orElse(true)',
    expr: toExpr(false as bool?).orElse(toExpr(true)),
    expected: false,
  ),
  (
    name: '(false as bool?).orElseValue(true)',
    expr: toExpr(false as bool?).orElseValue(true),
    expected: false,
  ),
  (
    name: 'null.asBool()',
    expr: toExpr(null).asBool(),
    expected: null,
  ),
  (
    name: 'null.asBool().orElse(true)',
    expr: toExpr(null).asBool().orElse(toExpr(true)),
    expected: true,
  ),
  (
    name: 'null.asBool().orElseValue(true)',
    expr: toExpr(null).asBool().orElseValue(true),
    expected: true,
  ),
];

final _deepEqualsCases = <({
  String name,
  Expr expr,
  List<Object?>? expected,
})>[
  // test null and blob
  (
    name: 'Uint8List.fromList([1, 2, 3]) as Uint8List?',
    expr: toExpr(Uint8List.fromList([1, 2, 3]) as Uint8List?),
    expected: Uint8List.fromList([1, 2, 3]),
  ),
  (
    name: 'null as Uint8List?',
    expr: toExpr(null as Uint8List?),
    expected: null,
  ),
  (
    name: 'null.asBlob()',
    expr: toExpr(null).asBlob(),
    expected: null,
  ),
];

void main() {
  final r = TestRunner<Schema>(resetDatabaseForEachTest: false);

  for (final c in _cases) {
    r.addTest(c.name, (db) async {
      final result = await db.select(
        (c.expr,),
      ).fetch();
      check(result).equals(c.expected);
    });
  }

  for (final c in _deepEqualsCases) {
    r.addTest(c.name, (db) async {
      final result = await db.select(
        (c.expr,),
      ).fetch();
      final expected = c.expected;
      if (expected == null) {
        check(result).isNull();
      } else {
        check(result as List<Object?>).deepEquals(expected);
      }
    });
  }

  r.run();
}
