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

// ignore_for_file: prefer_const_constructors

import 'package:typed_sql/typed_sql.dart';

import '../testrunner.dart';

final _cases = <({
  String name,
  Expr expr,
  Object? expected,
})>[
  // Tests for null and JsonValue
  (
    name: 'JsonValue(42) as JsonValue?',
    expr: toExpr(JsonValue(42) as JsonValue?),
    expected: JsonValue(42),
  ),
  (
    name: 'null as JsonValue?',
    expr: toExpr(null as JsonValue?),
    expected: null,
  ),
  (
    name: '(null as JsonValue?).orElse(JsonValue(42))',
    expr: toExpr(null as JsonValue?).orElse(toExpr(JsonValue(42))),
    expected: JsonValue(42),
  ),
  (
    name: '(null as JsonValue?).orElseValue(JsonValue(42))',
    expr: toExpr(null as JsonValue?).orElseValue(JsonValue(42)),
    expected: JsonValue(42),
  ),
  (
    name: '(JsonValue(21) as JsonValue?).orElse(JsonValue(42))',
    expr: toExpr(JsonValue(21) as JsonValue?).orElse(toExpr(JsonValue(42))),
    expected: JsonValue(21),
  ),
  (
    name: '(JsonValue(21) as JsonValue?).orElseValue(JsonValue(42))',
    expr: toExpr(JsonValue(21) as JsonValue?).orElseValue(JsonValue(42)),
    expected: JsonValue(21),
  ),
  (
    name: 'null.asJsonValue()',
    expr: toExpr(null).asJsonValue(),
    expected: null,
  ),
  (
    name: 'null.asJsonValue().orElse(JsonValue(42))',
    expr: toExpr(null).asJsonValue().orElse(toExpr(JsonValue(42))),
    expected: JsonValue(42),
  ),
  (
    name: 'null.asJsonValue().orElseValue(JsonValue(42))',
    expr: toExpr(null).asJsonValue().orElseValue(JsonValue(42)),
    expected: JsonValue(42),
  ),

  // Expr<JsonValue?>.isNull()
  (
    name: 'null.asJsonValue().isNull()',
    expr: toExpr(null).asJsonValue().isNull(),
    expected: true,
  ),
  (
    name: 'JsonValue(42).isNull()',
    expr: toExpr(JsonValue(42) as JsonValue?).isNull(),
    expected: false,
  ),
  (
    name: 'JsonValue(0).isNull()',
    expr: toExpr(JsonValue(0) as JsonValue?).isNull(),
    expected: false,
  ),
  (
    name: 'JsonValue(null).isNull()',
    expr: toExpr(JsonValue(null) as JsonValue?).isNull(),
    expected: false,
  ),
  // Expr<JsonValue?>.isNotNull()
  (
    name: 'null.asJsonValue().isNotNull()',
    expr: toExpr(null).asJsonValue().isNotNull(),
    expected: false,
  ),
  (
    name: 'JsonValue(42).isNotNull()',
    expr: toExpr(JsonValue(42) as JsonValue?).isNotNull(),
    expected: true,
  ),
  (
    name: 'JsonValue(0).isNotNull()',
    expr: toExpr(JsonValue(0) as JsonValue?).isNotNull(),
    expected: true,
  ),
  (
    name: 'JsonValue(null).isNotNull()',
    expr: toExpr(JsonValue(null) as JsonValue?).isNotNull(),
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
      } else if (expected is JsonValue) {
        check(result).isA<JsonValue>().deepEquals(expected);
      } else {
        check(result).equals(expected);
      }
    });
  }

  r.run();
}
