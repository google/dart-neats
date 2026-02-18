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

// Complex JSON object for traversal tests
final testData = JsonValue({
  'int': 42,
  'float': 3.14,
  'string': 'hello',
  'bool_true': true,
  'bool_false': false,
  'obj': {
    'nested': 'world',
    'id': 100,
  },
  'arr': [1, 2, 3],
  'complex_arr': [
    {'x': 10},
    {'x': 20}
  ],
  'null_val': null,
});

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

  // Expr<JsonValue?>[]
  (
    name: "data['int'] -> JsonValue(42)",
    expr: toExpr(testData)['int'],
    expected: JsonValue(42),
  ),
  (
    name: "data['string'] -> JsonValue('hello')",
    expr: toExpr(testData)['string'],
    expected: JsonValue('hello'),
  ),
  (
    name: "data['obj'] -> JsonValue({...})",
    expr: toExpr(testData)['obj'],
    expected: JsonValue({
      'nested': 'world',
      'id': 100,
    }),
  ),
  (
    name: "data['obj']['nested'] -> JsonValue('world')",
    expr: toExpr(testData)['obj']['nested'],
    expected: JsonValue('world'),
  ),
  (
    name: "data['arr'][1] -> JsonValue(2)",
    expr: toExpr(testData)['arr'][1],
    expected: JsonValue(2),
  ),
  (
    name: "data['complex_arr'][0]['x'] -> JsonValue(10)",
    expr: toExpr(testData)['complex_arr'][0]['x'],
    expected: JsonValue(10),
  ),
  (
    name: "data['complex_arr'][1]['x'] -> JsonValue(20)",
    expr: toExpr(testData)['complex_arr'][1]['x'],
    expected: JsonValue(20),
  ),
  (
    name: "data['missing'] -> NULL",
    expr: toExpr(testData)['missing'],
    expected: null,
  ),
  (
    name: "data['complex_arr'][3] -> NULL",
    expr: toExpr(testData)['complex_arr'][3],
    expected: null,
  ),
  (
    name: "data['obj']['missing'] -> NULL",
    expr: toExpr(testData)['obj']['missing'],
    expected: null,
  ),
  (
    name: "data['null_val'] -> JsonValue(null)",
    expr: toExpr(testData)['null_val'],
    expected: JsonValue(null),
  ),

  // Expr<JsonValue?>.asInt()
  (
    name: "data['int'].asInt()",
    expr: toExpr(testData)['int'].asInt(),
    expected: 42,
  ),
  (
    name: "data['obj']['id'].asInt()",
    expr: toExpr(testData)['obj']['id'].asInt(),
    expected: 100,
  ),
  (
    name: "data['missing'].asInt() -> NULL",
    expr: toExpr(testData)['missing'].asInt(),
    expected: null,
  ),

  // Expr<JsonValue?>.asDouble()
  (
    name: "data['float'].asDouble()",
    expr: toExpr(testData)['float'].asDouble(),
    expected: 3.14,
  ),
  (
    name: "data['int'].asDouble()",
    // Ints usually cast to double fine in SQL
    expr: toExpr(testData)['int'].asDouble(),
    expected: 42.0,
  ),
  (
    name: "data['missing'].asDouble() -> NULL",
    expr: toExpr(testData)['missing'].asDouble(),
    expected: null,
  ),

  // Expr<JsonValue?>.asString()
  (
    name: "data['string'].asString()",
    expr: toExpr(testData)['string'].asString(),
    expected: 'hello',
  ),
  (
    name: "data['int'].asString()",
    // Numbers should be castable to string "42"
    expr: toExpr(testData)['int'].asString(),
    expected: '42',
  ),
  (
    name: "data['missing'].asString() -> NULL",
    expr: toExpr(testData)['missing'].asString(),
    expected: null,
  ),

  // Expr<JsonValue?>.asBool()
  (
    name: "data['bool_true'].asBool()",
    expr: toExpr(testData)['bool_true'].asBool(),
    expected: true,
  ),
  (
    name: "data['bool_false'].asBool()",
    expr: toExpr(testData)['bool_false'].asBool(),
    expected: false,
  ),
  (
    name: "data['missing'].asBool() -> NULL",
    expr: toExpr(testData)['missing'].asBool(),
    expected: null,
  ),

  // JsonValue(null) vs JsonValue('null') asString()
  (
    name: 'JsonValue(null).asString() -> NULL',
    expr: toExpr(JsonValue(null)).asString(),
    expected: null,
  ),
  (
    name: "JsonValue('null').asString() -> 'null'",
    expr: toExpr(JsonValue('null')).asString(),
    expected: 'null',
  ),

  // JsonValue(null).asInt() -> NULL
  (
    name: 'JsonValue(null).asInt() -> NULL',
    expr: toExpr(JsonValue(null)).asInt(),
    expected: null,
  ),

  // JsonValue(null).asDouble() -> NULL
  (
    name: 'JsonValue(null).asDouble() -> NULL',
    expr: toExpr(JsonValue(null)).asDouble(),
    expected: null,
  ),

  // JsonValue(null).asBool() -> NULL
  (
    name: 'JsonValue(null).asBool() -> NULL',
    expr: toExpr(JsonValue(null)).asBool(),
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
