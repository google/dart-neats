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

// A complex JSON object to run tests against
final _complexJson = JsonValue({
  'i': 123,
  'i_zero': 0,
  'f': 12.34,
  's': 'hello',
  's_num': '123',
  'b_true': true,
  'b_false': false,
  'arr': [10, 20, 30],
  'obj': {
    'x': 99,
    'nested': {'y': 'deep'},
  },
  'n': null,
  'special': {
    ' with spaces ': 1,
    'with.dots': 2,
    "with'quotes": 3,
    'with"double"quotes': 4,
    r'with$sign': 5,
  }
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

  // Fundamentals (Happy Paths)
  (
    name: 'Extract int',
    expr: toExpr(_complexJson)['i'].asInt(),
    expected: 123,
  ),
  (
    name: 'Extract double',
    expr: toExpr(_complexJson)['f'].asDouble(),
    expected: 12.34,
  ),
  (
    name: 'Extract string',
    expr: toExpr(_complexJson)['s'].asString(),
    expected: 'hello',
  ),
  (
    name: 'Extract bool (true)',
    expr: toExpr(_complexJson)['b_true'].asBool(),
    expected: true,
  ),
  (
    name: 'Extract bool (false)',
    expr: toExpr(_complexJson)['b_false'].asBool(),
    expected: false,
  ),
  (
    name: 'Extract array index 0',
    expr: toExpr(_complexJson)['arr'][0].asInt(),
    expected: 10,
  ),
  (
    name: 'Extract nested object property',
    expr: toExpr(_complexJson)['obj']['x'].asInt(),
    expected: 99,
  ),
  (
    name: 'Extract deep nested property',
    expr: toExpr(_complexJson)['obj']['nested']['y'].asString(),
    expected: 'deep',
  ),

  // Type Mismatches (Strict Typing)
  // Int vs String
  (
    name: 'Int as String (should be null)',
    expr: toExpr(_complexJson)['i'].asString(),
    expected: null,
  ),
  (
    name: 'String as Int (should be null)',
    expr: toExpr(_complexJson)['s'].asInt(),
    expected: null,
  ),
  (
    name: 'Numeric String as Int (should be null - no implicit parsing)',
    expr: toExpr(_complexJson)['s_num'].asInt(),
    expected: null,
  ),

  // Bool vs Numbers
  (
    name: 'Int (123) as Bool (should be null)',
    expr: toExpr(_complexJson)['i'].asBool(),
    expected: null,
  ),
  (
    name: 'Int (0) as Bool (should be null)',
    expr: toExpr(_complexJson)['i_zero'].asBool(),
    expected: null,
  ),
  (
    name: 'Bool (true) as Int (should be null)',
    expr: toExpr(_complexJson)['b_true'].asInt(),
    expected: null,
  ),

  // Object/Array vs Scalar
  (
    name: 'Object as Int (should be null)',
    expr: toExpr(_complexJson)['obj'].asInt(),
    expected: null,
  ),
  (
    name: 'Array as String (should be null)',
    expr: toExpr(_complexJson)['arr'].asString(),
    expected: null,
  ),

  // Null Checks & Missing Data
  (
    name: 'Access on SQL NULL is SQL NULL',
    expr: toExpr(null as JsonValue?)['i'].asInt(),
    expected: null,
  ),
  (
    name: 'isNull() on SQL NULL',
    expr: toExpr(null as JsonValue?)['i'].isNull(),
    expected: true,
  ),

  // Missing Keys (Result in SQL NULL)
  (
    name: 'Missing key as Int',
    expr: toExpr(_complexJson)['missing'].asInt(),
    expected: null,
  ),
  (
    name: 'Missing key isNull()',
    expr: toExpr(_complexJson)['missing'].isNull(),
    expected: true,
  ),
  (
    name: 'Missing index as Int',
    expr: toExpr(_complexJson)['arr'][99].asInt(),
    expected: null,
  ),

  // Explicit JSON null
  (
    name: 'Explicit JSON null as Int',
    expr: toExpr(_complexJson)['n'].asInt(),
    expected: null,
  ),
  (
    name: 'Explicit JSON null isNull() (Scalar context)',
    expr: toExpr(_complexJson)['n'].asInt().isNull(),
    expected: true,
  ),
  (
    name: 'Explicit JSON null as JsonValue',
    expr: toExpr(_complexJson)['n'],
    expected: JsonValue(null),
  ),
  (
    name: 'Explicit JSON null isNull() (JsonValue context)',
    expr: toExpr(_complexJson)['n'].isNull(),
    expected: false,
  ),

  // Special Characters & Escaping
  (
    name: 'Key with spaces',
    expr: toExpr(_complexJson)['special'][' with spaces '].asInt(),
    expected: 1,
  ),
  (
    name: 'Key with dots',
    expr: toExpr(_complexJson)['special']['with.dots'].asInt(),
    expected: 2,
  ),
  (
    name: 'Key with single quotes',
    expr: toExpr(_complexJson)['special']["with'quotes"].asInt(),
    expected: 3,
  ),
  (
    name: 'Key with double quotes',
    expr: toExpr(_complexJson)['special']['with"double"quotes'].asInt(),
    expected: 4,
  ),
  (
    name: 'Key with \$ sign',
    expr: toExpr(_complexJson)['special'][r'with$sign'].asInt(),
    expected: 5,
  ),

  // Array & Indexing Edge Cases
  (
    name: 'Array index out of bounds',
    expr: toExpr(_complexJson)['arr'][100].asInt(),
    expected: null,
  ),
  (
    name: 'Index on non-array (Object)',
    expr: toExpr(_complexJson)['obj'][0].asInt(),
    expected: null,
  ),
  (
    name: 'Index on non-array (Scalar)',
    expr: toExpr(_complexJson)['i'][0].asInt(),
    expected: null,
  ),

  // Strict Type Enforcement (No Implicit Casting)
  (
    name: 'String "123" as Int (should be null)',
    expr: toExpr(_complexJson)['s_num'].asInt(),
    expected: null,
  ),
  (
    name: 'String "12.34" as Double (should be null)',
    expr: toExpr(JsonValue({'v': '12.34'}))['v'].asDouble(),
    expected: null,
  ),
  (
    name: 'String "true" as Bool (should be null)',
    expr: toExpr(JsonValue({'v': 'true'}))['v'].asBool(),
    expected: null,
  ),

  // Value Escaping
  (
    name: 'Value with single quote',
    expr: toExpr(JsonValue({'v': "O'Reilly"}))['v'].asString(),
    expected: "O'Reilly",
  ),
  (
    name: 'Value with double quote',
    expr: toExpr(JsonValue({'v': 'Sf"u'}))['v'].asString(),
    expected: 'Sf"u',
  ),
  (
    name: 'Value with backslash',
    expr: toExpr(JsonValue({'v': r'C:\Windows'}))['v'].asString(),
    expected: r'C:\Windows',
  ),

  // Logic on Extracted Values
  (
    name: 'isNull on valid extraction',
    expr: toExpr(_complexJson)['i'].asInt().isNull(),
    expected: false,
  ),
  (
    name: 'isNotNull on missing key',
    expr: toExpr(_complexJson)['missing'].asInt().isNotNull(),
    expected: false,
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
