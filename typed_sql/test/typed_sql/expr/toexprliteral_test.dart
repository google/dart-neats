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

import 'dart:typed_data';

import 'package:typed_sql/typed_sql.dart';

import '../testrunner.dart';

final _values = <Object?>[
  'hello world',
  'æøå',
  'hello\nworld',
  '\\',
  '',
  42,
  -1,
  0,
  true,
  false,
  null,
  3.14,
  -3.14,
  0.0,
  DateTime(2025).toUtc(),
];

final epoch = DateTime.fromMicrosecondsSinceEpoch(0).toUtc();
final today = DateTime.parse('2025-03-10T11:34:36.000000Z');
final yearNoUtc = DateTime(2025);

final _cases = [
  // Expr<bool?>.isNull()
  (
    name: '(null as bool?).isNull()',
    expr: toExprLiteral(null as bool?).isNull(),
    expected: true,
  ),
  (
    name: 'null.asBool().isNull()',
    expr: toExprLiteral(null).asBool().isNull(),
    expected: true,
  ),
  (
    name: 'true.isNull()',
    expr: toExprLiteral(true as bool?).isNull(),
    expected: false,
  ),
  (
    name: 'false.isNull()',
    expr: toExprLiteral(false as bool?).isNull(),
    expected: false,
  ),

  // Expr<bool?>.isNotNull()
  (
    name: '(null as bool?).isNotNull()',
    expr: toExprLiteral(null as bool?).isNotNull(),
    expected: false,
  ),
  (
    name: 'null.asBool().isNotNull()',
    expr: toExprLiteral(null).asBool().isNotNull(),
    expected: false,
  ),
  (
    name: 'true.isNotNull()',
    expr: toExprLiteral(true as bool?).isNotNull(),
    expected: true,
  ),
  (
    name: 'false.isNotNull()',
    expr: toExprLiteral(false as bool?).isNotNull(),
    expected: true,
  ),

  // Expr<DateTime?>.isNull()
  (
    name: '(null as DateTime?).isNull()',
    expr: toExprLiteral(null as DateTime?).isNull(),
    expected: true,
  ),
  (
    name: 'null.asDateTime().isNull()',
    expr: toExprLiteral(null).asDateTime().isNull(),
    expected: true,
  ),
  (
    name: 'epoch.isNull()',
    expr: toExprLiteral(epoch as DateTime?).isNull(),
    expected: false,
  ),
  (
    name: 'today.isNull()',
    expr: toExprLiteral(today as DateTime?).isNull(),
    expected: false,
  ),

  // Expr<DateTime?>.isNotNull()
  (
    name: '(null as DateTime?).isNotNull()',
    expr: toExprLiteral(null as DateTime?).isNotNull(),
    expected: false,
  ),
  (
    name: 'null.asDateTime().isNotNull()',
    expr: toExprLiteral(null).asDateTime().isNotNull(),
    expected: false,
  ),
  (
    name: 'epoch.isNotNull()',
    expr: toExprLiteral(epoch as DateTime?).isNotNull(),
    expected: true,
  ),
  (
    name: 'today.isNotNull()',
    expr: toExprLiteral(today as DateTime?).isNotNull(),
    expected: true,
  ),

  // Expr<double?>.isNull()
  (
    name: '(null as double?).isNull()',
    expr: toExprLiteral(null as double?).isNull(),
    expected: true,
  ),
  (
    name: 'null.asDouble().isNull()',
    expr: toExprLiteral(null).asDouble().isNull(),
    expected: true,
  ),
  (
    name: '3.14.isNull()',
    expr: toExprLiteral(3.14 as double?).isNull(),
    expected: false,
  ),
  (
    name: '0.0.isNull()',
    expr: toExprLiteral(0.0 as double?).isNull(),
    expected: false,
  ),

  // Expr<double?>.isNotNull()
  (
    name: '(null as double?).isNotNull()',
    expr: toExprLiteral(null as double?).isNotNull(),
    expected: false,
  ),
  (
    name: 'null.asDouble().isNotNull()',
    expr: toExprLiteral(null).asDouble().isNotNull(),
    expected: false,
  ),
  (
    name: '3.14.isNotNull()',
    expr: toExprLiteral(3.14 as double?).isNotNull(),
    expected: true,
  ),
  (
    name: '0.0.isNotNull()',
    expr: toExprLiteral(0.0 as double?).isNotNull(),
    expected: true,
  ),

  // Expr<int?>.isNull()
  (
    name: '(null as int?).isNull()',
    expr: toExprLiteral(null as int?).isNull(),
    expected: true,
  ),
  (
    name: 'null.asInt().isNull()',
    expr: toExprLiteral(null).asInt().isNull(),
    expected: true,
  ),
  (
    name: '42.isNull()',
    expr: toExprLiteral(42 as int?).isNull(),
    expected: false,
  ),
  (
    name: '0.isNull()',
    expr: toExprLiteral(0 as int?).isNull(),
    expected: false,
  ),

  // Expr<int?>.isNotNull()
  (
    name: '(null as int?).isNotNull()',
    expr: toExprLiteral(null as int?).isNotNull(),
    expected: false,
  ),
  (
    name: 'null.asInt().isNotNull()',
    expr: toExprLiteral(null).asInt().isNotNull(),
    expected: false,
  ),
  (
    name: '42.isNotNull()',
    expr: toExprLiteral(42 as int?).isNotNull(),
    expected: true,
  ),
  (
    name: '0.isNotNull()',
    expr: toExprLiteral(0 as int?).isNotNull(),
    expected: true,
  ),

  // Expr<JsonValue?>.isNull()
  (
    name: '(null as JsonValue?).isNull()',
    expr: toExprLiteral(null as JsonValue?).isNull(),
    expected: true,
  ),
  (
    name: 'null.asJsonValue().isNull()',
    expr: toExprLiteral(null).asJsonValue().isNull(),
    expected: true,
  ),
  (
    name: 'JsonValue(42).isNull()',
    expr: toExprLiteral(JsonValue(42) as JsonValue?).isNull(),
    expected: false,
  ),
  (
    name: 'JsonValue(0).isNull()',
    expr: toExprLiteral(JsonValue(0) as JsonValue?).isNull(),
    expected: false,
  ),
  (
    name: 'JsonValue(null).isNull()',
    expr: toExprLiteral(JsonValue(null) as JsonValue?).isNull(),
    expected: false,
  ),

  // Expr<JsonValue?>.isNotNull()
  (
    name: '(null as JsonValue?).isNotNull()',
    expr: toExprLiteral(null as JsonValue?).isNotNull(),
    expected: false,
  ),
  (
    name: 'null.asJsonValue().isNotNull()',
    expr: toExprLiteral(null).asJsonValue().isNotNull(),
    expected: false,
  ),
  (
    name: 'JsonValue(42).isNotNull()',
    expr: toExprLiteral(JsonValue(42) as JsonValue?).isNotNull(),
    expected: true,
  ),
  (
    name: 'JsonValue(0).isNotNull()',
    expr: toExprLiteral(JsonValue(0) as JsonValue?).isNotNull(),
    expected: true,
  ),
  (
    name: 'JsonValue(null).isNotNull()',
    expr: toExprLiteral(JsonValue(null) as JsonValue?).isNotNull(),
    expected: true,
  ),

  // Expr<String?>.isNull()
  (
    name: '(null as String?).isNull()',
    expr: toExprLiteral(null as String?).isNull(),
    expected: true,
  ),
  (
    name: 'null.asString().isNull()',
    expr: toExprLiteral(null).asString().isNull(),
    expected: true,
  ),
  (
    name: '"hello".isNull()',
    expr: toExprLiteral('hello' as String?).isNull(),
    expected: false,
  ),
  (
    name: '"".isNull()',
    expr: toExprLiteral('' as String?).isNull(),
    expected: false,
  ),

  // Expr<String?>.isNotNull()
  (
    name: '(null as String?).isNotNull()',
    expr: toExprLiteral(null as String?).isNotNull(),
    expected: false,
  ),
  (
    name: 'null.asString().isNotNull()',
    expr: toExprLiteral(null).asString().isNotNull(),
    expected: false,
  ),
  (
    name: '"hello".isNotNull()',
    expr: toExprLiteral('hello' as String?).isNotNull(),
    expected: true,
  ),
  (
    name: '"".isNotNull()',
    expr: toExprLiteral('' as String?).isNotNull(),
    expected: true,
  ),

  // Expr<Uint8List?>.isNull()
  (
    name: '(null as Uint8List?).isNull()',
    expr: toExprLiteral(null as Uint8List?).isNull(),
    expected: true,
  ),
  (
    name: 'null.asBlob().isNull()',
    expr: toExprLiteral(null).asBlob().isNull(),
    expected: true,
  ),
  (
    name: '[1,2,3].isNull()',
    expr: toExprLiteral(
      Uint8List.fromList([1, 2, 3]) as Uint8List?,
    ).isNull(),
    expected: false,
  ),
  (
    name: '[].isNull()',
    expr: toExprLiteral(Uint8List.fromList([]) as Uint8List?).isNull(),
    expected: false,
  ),

  // Expr<Uint8List?>.isNotNull()
  (
    name: '(null as Uint8List?).isNotNull()',
    expr: toExprLiteral(null as Uint8List?).isNotNull(),
    expected: false,
  ),
  (
    name: 'null.asBlob().isNotNull()',
    expr: toExprLiteral(null).asBlob().isNotNull(),
    expected: false,
  ),
  (
    name: '[1,2,3].isNotNull()',
    expr: toExprLiteral(
      Uint8List.fromList([1, 2, 3]) as Uint8List?,
    ).isNotNull(),
    expected: true,
  ),
  (
    name: '[].isNotNull()',
    expr: toExprLiteral(Uint8List.fromList([]) as Uint8List?).isNotNull(),
    expected: true,
  ),
];

void main() {
  final r = TestRunner<Schema>(resetDatabaseForEachTest: false);

  for (final value in _values) {
    r.addTest('toExprLiteral(${'$value'.replaceAll('\n', '\\n')})', (db) async {
      final result = await db.select((toExprLiteral(value),)).fetch();
      check(result).equals(value);
    });
  }

  for (final c in _cases) {
    r.addTest(c.name, (db) async {
      final result = await db.select(
        (c.expr,),
      ).fetch();
      check(result).equals(c.expected);
    });
  }

  r.addTest('toExprLiteral(epoch)', (db) async {
    final result = await db.select((toExprLiteral(epoch),)).fetch();
    check(result).equals(epoch);
  });

  r.addTest('toExprLiteral(today)', (db) async {
    final result = await db.select((toExprLiteral(today),)).fetch();
    check(result).equals(today);
  });

  r.addTest(
    'toExprLiteral(today) with microseconds',
    (db) async {
      final today = DateTime.parse('2025-03-10T11:34:36.164006Z');
      final result = await db.select((toExprLiteral(today),)).fetch();
      check(result).equals(today);
    },
    skipMysql: 'MySQL driver does not support microseconds',
  );

  r.addTest('toExprLiteral(yearNoUtc) normalizes to UTC', (db) async {
    final result = await db.select((toExprLiteral(yearNoUtc),)).fetch();
    check(result).isNotNull();
    check(result!.isUtc).isTrue();
    check(result.isAtSameMomentAs(yearNoUtc.toUtc())).isTrue();
  });

  r.addTest('toExprLiteral(UintList)', (db) async {
    final result = await db.select(
      (toExprLiteral(Uint8List.fromList([1, 2, 3])),),
    ).fetch();
    check(result).isNotNull().deepEquals(Uint8List.fromList([1, 2, 3]));
  });

  r.addTest('toExprLiteral(JsonValue)', (db) async {
    final result = await db.select(
      (toExprLiteral(const JsonValue([1, 2, 3])),),
    ).fetch();
    check(result).isNotNull().deepEquals(const JsonValue([1, 2, 3]));
  });

  r.run();
}
