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
final today = DateTime.parse('2025-03-10T11:34:36.164006Z');

final _cases = <({
  String name,
  Expr expr,
  Object? expected,
})>[
  // Tests for null and bool
  (
    name: 'true as bool?',
    expr: literal(true as bool?),
    expected: true,
  ),
  (
    name: 'null as bool?',
    expr: literal(null as bool?),
    expected: null,
  ),
  (
    name: '(null as bool?).orElse(true)',
    expr: literal(null as bool?).orElse(literal(true)),
    expected: true,
  ),
  (
    name: '(null as bool?).orElseLiteral(true)',
    expr: literal(null as bool?).orElseLiteral(true),
    expected: true,
  ),
  (
    name: '(false as bool?).orElse(true)',
    expr: literal(false as bool?).orElse(literal(true)),
    expected: false,
  ),
  (
    name: '(false as bool?).orElseLiteral(true)',
    expr: literal(false as bool?).orElseLiteral(true),
    expected: false,
  ),
  (
    name: 'null.asBool()',
    expr: literal(null).asBool(),
    expected: null,
  ),
  (
    name: 'null.asBool().orElse(true)',
    expr: literal(null).asBool().orElse(literal(true)),
    expected: true,
  ),
  (
    name: 'null.asBool().orElseLiteral(true)',
    expr: literal(null).asBool().orElseLiteral(true),
    expected: true,
  ),
  // Tests for null and String
  (
    name: 'hello as String?',
    expr: literal('hello' as String?),
    expected: 'hello',
  ),
  (
    name: 'null as String?',
    expr: literal(null as String?),
    expected: null,
  ),
  (
    name: '(null as String?).orElse(\'hello\')',
    expr: literal(null as String?).orElse(literal('hello')),
    expected: 'hello',
  ),
  (
    name: '(null as String?).orElseLiteral(\'hello\')',
    expr: literal(null as String?).orElseLiteral('hello'),
    expected: 'hello',
  ),
  (
    name: '(\'world\' as String?).orElse(\'hello\')',
    expr: literal('world' as String?).orElse(literal('hello')),
    expected: 'world',
  ),
  (
    name: '(\'world\' as String?).orElseLiteral(\'hello\')',
    expr: literal('world' as String?).orElseLiteral('hello'),
    expected: 'world',
  ),
  (
    name: 'null.asString()',
    expr: literal(null).asString(),
    expected: null,
  ),
  (
    name: 'null.asString().orElse(\'hello\')',
    expr: literal(null).asString().orElse(literal('hello')),
    expected: 'hello',
  ),
  (
    name: 'null.asString().orElseLiteral(\'hello\')',
    expr: literal(null).asString().orElseLiteral('hello'),
    expected: 'hello',
  ),
  // Tests for null and int
  (
    name: '42 as int?',
    expr: literal(42 as int?),
    expected: 42,
  ),
  (
    name: 'null as int?',
    expr: literal(null as int?),
    expected: null,
  ),
  (
    name: '(null as int?).orElse(42)',
    expr: literal(null as int?).orElse(literal(42)),
    expected: 42,
  ),
  (
    name: '(null as int?).orElseLiteral(42)',
    expr: literal(null as int?).orElseLiteral(42),
    expected: 42,
  ),
  (
    name: '(21 as int?).orElse(42)',
    expr: literal(21 as int?).orElse(literal(42)),
    expected: 21,
  ),
  (
    name: '(21 as int?).orElseLiteral(42)',
    expr: literal(21 as int?).orElseLiteral(42),
    expected: 21,
  ),
  (
    name: 'null.asInt()',
    expr: literal(null).asInt(),
    expected: null,
  ),
  (
    name: 'null.asInt().orElse(42)',
    expr: literal(null).asInt().orElse(literal(42)),
    expected: 42,
  ),
  (
    name: 'null.asInt().orElseLiteral(42)',
    expr: literal(null).asInt().orElseLiteral(42),
    expected: 42,
  ),
  // Tests for null and double
  (
    name: '3.14 as double?',
    expr: literal(3.14 as double?),
    expected: 3.14,
  ),
  (
    name: 'null as double?',
    expr: literal(null as double?),
    expected: null,
  ),
  (
    name: '(null as double?).orElse(3.14)',
    expr: literal(null as double?).orElse(literal(3.14)),
    expected: 3.14,
  ),
  (
    name: '(null as double?).orElseLiteral(3.14)',
    expr: literal(null as double?).orElseLiteral(3.14),
    expected: 3.14,
  ),
  (
    name: '(2.71 as double?).orElse(3.14)',
    expr: literal(2.71 as double?).orElse(literal(3.14)),
    expected: 2.71,
  ),
  (
    name: '(2.71 as double?).orElseLiteral(3.14)',
    expr: literal(2.71 as double?).orElseLiteral(3.14),
    expected: 2.71,
  ),
  (
    name: 'null.asDouble()',
    expr: literal(null).asDouble(),
    expected: null,
  ),
  (
    name: 'null.asDouble().orElse(3.14)',
    expr: literal(null).asDouble().orElse(literal(3.14)),
    expected: 3.14,
  ),
  (
    name: 'null.asDouble().orElseLiteral(3.14)',
    expr: literal(null).asDouble().orElseLiteral(3.14),
    expected: 3.14,
  ),
  // Tests for null and DateTime
  (
    name: 'epoch as DateTime?',
    expr: literal(epoch as DateTime?),
    expected: epoch,
  ),
  (
    name: 'null as DateTime?',
    expr: literal(null as DateTime?),
    expected: null,
  ),
  (
    name: '(null as DateTime?).orElse(epoch)',
    expr: literal(null as DateTime?).orElse(literal(epoch)),
    expected: epoch,
  ),
  (
    name: '(null as DateTime?).orElseLiteral(epoch)',
    expr: literal(null as DateTime?).orElseLiteral(epoch),
    expected: epoch,
  ),
  (
    name: '(today as DateTime?).orElse(epoch)',
    expr: literal(today as DateTime?).orElse(literal(epoch)),
    expected: today,
  ),
  (
    name: '(today as DateTime?).orElseLiteral(epoch)',
    expr: literal(today as DateTime?).orElseLiteral(epoch),
    expected: today,
  ),
  (
    name: 'null.asDateTime()',
    expr: literal(null).asDateTime(),
    expected: null,
  ),
  (
    name: 'null.asDateTime().orElse(epoch)',
    expr: literal(null).asDateTime().orElse(literal(epoch)),
    expected: epoch,
  ),
  (
    name: 'null.asDateTime().orElseLiteral(epoch)',
    expr: literal(null).asDateTime().orElseLiteral(epoch),
    expected: epoch,
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
    expr: literal(Uint8List.fromList([1, 2, 3]) as Uint8List?),
    expected: Uint8List.fromList([1, 2, 3]),
  ),
  (
    name: 'null as Uint8List?',
    expr: literal(null as Uint8List?),
    expected: null,
  ),
  (
    name: 'null.asBlob()',
    expr: literal(null).asBlob(),
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
