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
  // Test for null and int
  (
    name: '42 as int?',
    expr: toExpr(42 as int?),
    expected: 42,
  ),
  (
    name: 'null as int?',
    expr: toExpr(null as int?),
    expected: null,
  ),
  (
    name: '(null as int?).orElse(42)',
    expr: toExpr(null as int?).orElse(toExpr(42)),
    expected: 42,
  ),
  (
    name: '(null as int?).orElseValue(42)',
    expr: toExpr(null as int?).orElseValue(42),
    expected: 42,
  ),
  (
    name: '(21 as int?).orElse(42)',
    expr: toExpr(21 as int?).orElse(toExpr(42)),
    expected: 21,
  ),
  (
    name: '(21 as int?).orElseValue(42)',
    expr: toExpr(21 as int?).orElseValue(42),
    expected: 21,
  ),
  (
    name: 'null.asInt()',
    expr: toExpr(null).asInt(),
    expected: null,
  ),
  (
    name: 'null.asInt().orElse(42)',
    expr: toExpr(null).asInt().orElse(toExpr(42)),
    expected: 42,
  ),
  (
    name: 'null.asInt().orElseValue(42)',
    expr: toExpr(null).asInt().orElseValue(42),
    expected: 42,
  ),
  // Test for null and double
  (
    name: '3.14 as double?',
    expr: toExpr(3.14 as double?),
    expected: 3.14,
  ),
  (
    name: 'null as double?',
    expr: toExpr(null as double?),
    expected: null,
  ),
  (
    name: '(null as double?).orElse(3.14)',
    expr: toExpr(null as double?).orElse(toExpr(3.14)),
    expected: 3.14,
  ),
  (
    name: '(null as double?).orElseValue(3.14)',
    expr: toExpr(null as double?).orElseValue(3.14),
    expected: 3.14,
  ),
  (
    name: '(1.23 as double?).orElse(3.14)',
    expr: toExpr(1.23 as double?).orElse(toExpr(3.14)),
    expected: 1.23,
  ),
  (
    name: '(1.23 as double?).orElseValue(3.14)',
    expr: toExpr(1.23 as double?).orElseValue(3.14),
    expected: 1.23,
  ),
  (
    name: 'null.asDouble()',
    expr: toExpr(null).asDouble(),
    expected: null,
  ),
  (
    name: 'null.asDouble().orElse(3.14)',
    expr: toExpr(null).asDouble().orElse(toExpr(3.14)),
    expected: 3.14,
  ),
  (
    name: 'null.asDouble().orElseValue(3.14)',
    expr: toExpr(null).asDouble().orElseValue(3.14),
    expected: 3.14,
  ),
  // Test for null and String
  (
    name: "'hello world' as String?",
    expr: toExpr('hello world' as String?),
    expected: 'hello world',
  ),
  (
    name: 'null as String?',
    expr: toExpr(null as String?),
    expected: null,
  ),
  (
    name: "(null as String?).orElse('hello world')",
    expr: toExpr(null as String?).orElse(toExpr('hello world')),
    expected: 'hello world',
  ),
  (
    name: "(null as String?).orElseValue('hello world')",
    expr: toExpr(null as String?).orElseValue('hello world'),
    expected: 'hello world',
  ),
  (
    name: "('foo' as String?).orElse('hello world')",
    expr: toExpr('foo' as String?).orElse(toExpr('hello world')),
    expected: 'foo',
  ),
  (
    name: "('foo' as String?).orElseValue('hello world')",
    expr: toExpr('foo' as String?).orElseValue('hello world'),
    expected: 'foo',
  ),
  (
    name: 'null.asString()',
    expr: toExpr(null).asString(),
    expected: null,
  ),
  (
    name: "null.asString().orElse('hello world')",
    expr: toExpr(null).asString().orElse(toExpr('hello world')),
    expected: 'hello world',
  ),
  (
    name: "null.asString().orElseValue('hello world')",
    expr: toExpr(null).asString().orElseValue('hello world'),
    expected: 'hello world',
  ),
  // Test for null and DateTime
  (
    name: 'epoch as DateTime?',
    expr: toExpr(epoch as DateTime?),
    expected: epoch,
  ),
  (
    name: 'null as DateTime?',
    expr: toExpr(null as DateTime?),
    expected: null,
  ),
  (
    name: '(null as DateTime?).orElse(epoch)',
    expr: toExpr(null as DateTime?).orElse(toExpr(epoch)),
    expected: epoch,
  ),
  (
    name: '(null as DateTime?).orElseValue(epoch)',
    expr: toExpr(null as DateTime?).orElseValue(epoch),
    expected: epoch,
  ),
  (
    name: '(today as DateTime?).orElse(epoch)',
    expr: toExpr(today as DateTime?).orElse(toExpr(epoch)),
    expected: today,
  ),
  (
    name: '(today as DateTime?).orElseValue(epoch)',
    expr: toExpr(today as DateTime?).orElseValue(epoch),
    expected: today,
  ),
  (
    name: 'null.asDateTime()',
    expr: toExpr(null).asDateTime(),
    expected: null,
  ),
  (
    name: 'null.asDateTime().orElse(epoch)',
    expr: toExpr(null).asDateTime().orElse(toExpr(epoch)),
    expected: epoch,
  ),
  (
    name: 'null.asDateTime().orElseValue(epoch)',
    expr: toExpr(null).asDateTime().orElseValue(epoch),
    expected: epoch,
  ),
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
  // Test for null and JsonValue
  (
    name: 'JsonValue("hello") as JsonValue?',
    expr: toExpr(const JsonValue('hello') as JsonValue?),
    expected: const JsonValue('hello'),
  ),
  (
    name: 'null as JsonValue?',
    expr: toExpr(null as JsonValue?),
    expected: null,
  ),
  (
    name: '(null as JsonValue?).orElse(JsonValue("hello"))',
    expr: toExpr(null as JsonValue?).orElse(toExpr(const JsonValue('hello'))),
    expected: const JsonValue('hello'),
  ),
  (
    name: '(null as JsonValue?).orElseValue(JsonValue("hello"))',
    expr: toExpr(null as JsonValue?).orElseValue(const JsonValue('hello')),
    expected: const JsonValue('hello'),
  ),
  (
    name: '(JsonValue("world") as JsonValue?).orElse(JsonValue("hello"))',
    expr: toExpr(const JsonValue('world') as JsonValue?)
        .orElse(toExpr(const JsonValue('hello'))),
    expected: const JsonValue('world'),
  ),
  (
    name: '(JsonValue("world") as JsonValue?).orElseValue(JsonValue("hello"))',
    expr: toExpr(const JsonValue('world') as JsonValue?)
        .orElseValue(const JsonValue('hello')),
    expected: const JsonValue('world'),
  ),
  (
    name: 'null.asJsonValue()',
    expr: toExpr(null).asJsonValue(),
    expected: null,
  ),
  (
    name: 'null.asJsonValue().orElse(JsonValue("hello"))',
    expr: toExpr(null).asJsonValue().orElse(toExpr(const JsonValue('hello'))),
    expected: const JsonValue('hello'),
  ),
  (
    name: 'null.asJsonValue().orElseValue(JsonValue("hello"))',
    expr: toExpr(null).asJsonValue().orElseValue(const JsonValue('hello')),
    expected: const JsonValue('hello'),
  ),
];

void main() {
  final r = TestRunner<Schema>(resetDatabaseForEachTest: false);

  for (final c in _cases) {
    r.addTest(c.name, (db) async {
      final result = await db.select(
        (c.expr,),
      ).fetch();

      switch (c.expected) {
        case null:
          check(result).isNull();

        case Uint8List expected:
          check(result).isA<List>().deepEquals(expected);

        case JsonValue expected:
          check(result).isA<JsonValue>().deepEquals(expected);

        default:
          check(result).equals(c.expected);
      }
    });
  }

  r.run();
}
