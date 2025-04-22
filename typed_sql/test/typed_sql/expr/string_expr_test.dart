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

import 'package:typed_sql/typed_sql.dart';

import '../testrunner.dart';

// TODO: Consider tests with special characters!
// TODO: Consider tests with *, ? and _ which will cause issue for sqlite
//       given how we've currently implemented .endsWith and .startsWith

final _cases = [
  // Test for .length
  (
    name: '"".length',
    expr: toExpr('').length,
    expected: 0,
  ),
  (
    name: '"hello".length',
    expr: toExpr('hello').length,
    expected: 5,
  ),

  // Tests for .toLowerCase() case
  (
    name: '"".toLowerCase()',
    expr: toExpr('').toLowerCase(),
    expected: '',
  ),
  (
    name: '"hello".toLowerCase()',
    expr: toExpr('hello').toLowerCase(),
    expected: 'hello',
  ),
  (
    name: '"HELLO".toLowerCase()',
    expr: toExpr('HELLO').toLowerCase(),
    expected: 'hello',
  ),
  (
    name: '"Hello".toLowerCase()',
    expr: toExpr('Hello').toLowerCase(),
    expected: 'hello',
  ),

  // Tests for .toUpperCase() case
  (
    name: '"".toUpperCase()',
    expr: toExpr('').toUpperCase(),
    expected: '',
  ),
  (
    name: '"hello".toUpperCase()',
    expr: toExpr('hello').toUpperCase(),
    expected: 'HELLO',
  ),
  (
    name: '"HELLO".toUpperCase()',
    expr: toExpr('HELLO').toUpperCase(),
    expected: 'HELLO',
  ),
  (
    name: '"Hello".toUpperCase()',
    expr: toExpr('Hello').toUpperCase(),
    expected: 'HELLO',
  ),

  // Tests for .equals
  (
    name: '"".equals("")',
    expr: toExpr('').equals(toExpr('')),
    expected: true,
  ),
  (
    name: '"".equals("hello")',
    expr: toExpr('').equals(toExpr('hello')),
    expected: false,
  ),
  (
    name: '"hello".equals("")',
    expr: toExpr('hello').equals(toExpr('')),
    expected: false,
  ),
  (
    name: '"hello".equals("hello")',
    expr: toExpr('hello').equals(toExpr('hello')),
    expected: true,
  ),
  (
    name: '"hello".equals("hello world")',
    expr: toExpr('hello').equals(toExpr('hello world')),
    expected: false,
  ),
  (
    name: '"".equals(null)',
    expr: toExpr('').equals(toExpr(null)),
    expected: false,
  ),
  (
    name: '"hello".equals(null)',
    expr: toExpr('hello').equals(toExpr(null)),
    expected: false,
  ),

  // Tests for .equalsLiteral
  (
    name: '"".equalsLiteral("")',
    expr: toExpr('').equalsValue(''),
    expected: true,
  ),
  (
    name: '"".equalsLiteral("hello")',
    expr: toExpr('').equalsValue('hello'),
    expected: false,
  ),
  (
    name: '"hello".equalsLiteral("")',
    expr: toExpr('hello').equalsValue(''),
    expected: false,
  ),
  (
    name: '"hello".equalsLiteral("hello")',
    expr: toExpr('hello').equalsValue('hello'),
    expected: true,
  ),
  (
    name: '"hello".equalsLiteral("hello world")',
    expr: toExpr('hello').equalsValue('hello world'),
    expected: false,
  ),
  (
    name: '"".equalsLiteral(null)',
    expr: toExpr('').equalsValue(null),
    expected: false,
  ),
  (
    name: '"hello".equalsLiteral(null)',
    expr: toExpr('hello').equalsValue(null),
    expected: false,
  ),

  // Tests for .notEquals
  (
    name: '"".notEquals("")',
    expr: toExpr('').notEquals(toExpr('')),
    expected: false,
  ),
  (
    name: '"".notEquals("hello")',
    expr: toExpr('').notEquals(toExpr('hello')),
    expected: true,
  ),
  (
    name: '"hello".notEquals("")',
    expr: toExpr('hello').notEquals(toExpr('')),
    expected: true,
  ),
  (
    name: '"hello".notEquals("hello")',
    expr: toExpr('hello').notEquals(toExpr('hello')),
    expected: false,
  ),
  (
    name: '"hello".notEquals("hello world")',
    expr: toExpr('hello').notEquals(toExpr('hello world')),
    expected: true,
  ),
  (
    name: '"".notEquals(null)',
    expr: toExpr('').notEquals(toExpr(null)),
    expected: true,
  ),
  (
    name: '"hello".notEquals(null)',
    expr: toExpr('hello').notEquals(toExpr(null)),
    expected: true,
  ),

  // Tests for .notEqualsLiteral
  (
    name: '"".notEqualsLiteral("")',
    expr: toExpr('').notEqualsValue(''),
    expected: false,
  ),
  (
    name: '"".notEqualsLiteral("hello")',
    expr: toExpr('').notEqualsValue('hello'),
    expected: true,
  ),
  (
    name: '"hello".notEqualsLiteral("")',
    expr: toExpr('hello').notEqualsValue(''),
    expected: true,
  ),
  (
    name: '"hello".notEqualsLiteral("hello")',
    expr: toExpr('hello').notEqualsValue('hello'),
    expected: false,
  ),
  (
    name: '"hello".notEqualsLiteral("hello world")',
    expr: toExpr('hello').notEqualsValue('hello world'),
    expected: true,
  ),
  (
    name: '"".notEqualsLiteral(null)',
    expr: toExpr('').notEqualsValue(null),
    expected: true,
  ),
  (
    name: '"hello".notEqualsLiteral(null)',
    expr: toExpr('hello').notEqualsValue(null),
    expected: true,
  ),

  // Tests for .isEmpty
  (
    name: '"".isEmpty',
    expr: toExpr('').isEmpty,
    expected: true,
  ),
  (
    name: '"hello".isEmpty',
    expr: toExpr('hello').isEmpty,
    expected: false,
  ),

  // Tests for .isNotEmpty
  (
    name: '"".isNotEmpty',
    expr: toExpr('').isNotEmpty,
    expected: false,
  ),
  (
    name: '"hello".isNotEmpty',
    expr: toExpr('hello').isNotEmpty,
    expected: true,
  ),

  // Tests for .startsWith
  (
    name: '"".startsWith("")',
    expr: toExpr('').startsWith(toExpr('')),
    expected: true,
  ),
  (
    name: '"".startsWith("hello")',
    expr: toExpr('').startsWith(toExpr('hello')),
    expected: false,
  ),
  (
    name: '"hello".startsWith("")',
    expr: toExpr('hello').startsWith(toExpr('')),
    expected: true,
  ),
  (
    name: '"hello".startsWith("hello")',
    expr: toExpr('hello').startsWith(toExpr('hello')),
    expected: true,
  ),
  (
    name: '"hello".startsWith("hell")',
    expr: toExpr('hello').startsWith(toExpr('hell')),
    expected: true,
  ),
  (
    name: '"hello".startsWith("world")',
    expr: toExpr('hello').startsWith(toExpr('world')),
    expected: false,
  ),

  // Tests for .startsWithLiteral
  (
    name: '"".startsWithLiteral("")',
    expr: toExpr('').startsWithValue(''),
    expected: true,
  ),
  (
    name: '"".startsWithLiteral("hello")',
    expr: toExpr('').startsWithValue('hello'),
    expected: false,
  ),
  (
    name: '"hello".startsWithLiteral("")',
    expr: toExpr('hello').startsWithValue(''),
    expected: true,
  ),
  (
    name: '"hello".startsWithLiteral("hello")',
    expr: toExpr('hello').startsWithValue('hello'),
    expected: true,
  ),
  (
    name: '"hello".startsWithLiteral("hell")',
    expr: toExpr('hello').startsWithValue('hell'),
    expected: true,
  ),
  (
    name: '"hello".startsWithLiteral("world")',
    expr: toExpr('hello').startsWithValue('world'),
    expected: false,
  ),

  // Tests for .endsWith
  (
    name: '"".endsWith("")',
    expr: toExpr('').endsWith(toExpr('')),
    expected: true,
  ),
  (
    name: '"".endsWith("hello")',
    expr: toExpr('').endsWith(toExpr('hello')),
    expected: false,
  ),
  (
    name: '"hello".endsWith("")',
    expr: toExpr('hello').endsWith(toExpr('')),
    expected: true,
  ),
  (
    name: '"hello".endsWith("hello")',
    expr: toExpr('hello').endsWith(toExpr('hello')),
    expected: true,
  ),
  (
    name: '"hello".endsWith("llo")',
    expr: toExpr('hello').endsWith(toExpr('llo')),
    expected: true,
  ),
  (
    name: '"hello".endsWith("world")',
    expr: toExpr('hello').endsWith(toExpr('world')),
    expected: false,
  ),

  // Tests for .endsWithLiteral
  (
    name: '"".endsWithLiteral("")',
    expr: toExpr('').endsWithValue(''),
    expected: true,
  ),
  (
    name: '"".endsWithLiteral("hello")',
    expr: toExpr('').endsWithValue('hello'),
    expected: false,
  ),
  (
    name: '"hello".endsWithLiteral("")',
    expr: toExpr('hello').endsWithValue(''),
    expected: true,
  ),
  (
    name: '"hello".endsWithLiteral("hello")',
    expr: toExpr('hello').endsWithValue('hello'),
    expected: true,
  ),
  (
    name: '"hello".endsWithLiteral("llo")',
    expr: toExpr('hello').endsWithValue('llo'),
    expected: true,
  ),
  (
    name: '"hello".endsWithLiteral("world")',
    expr: toExpr('hello').endsWithValue('world'),
    expected: false,
  ),

  // Tests for .like
  (
    name: '"".like("")',
    expr: toExpr('').like(''),
    expected: true,
  ),
  (
    name: '"".like("hello")',
    expr: toExpr('').like('hello'),
    expected: false,
  ),
  (
    name: '"hello".like("")',
    expr: toExpr('hello').like(''),
    expected: false,
  ),
  (
    name: '"hello".like("hello")',
    expr: toExpr('hello').like('hello'),
    expected: true,
  ),
  (
    name: '"hello".like("hell")',
    expr: toExpr('hello').like('hell'),
    expected: false,
  ),
  (
    name: '"hello".like("world")',
    expr: toExpr('hello').like('world'),
    expected: false,
  ),
  (
    name: '"hello".like("%")',
    expr: toExpr('hello').like('%'),
    expected: true,
  ),
  (
    name: '"hello".like("h%")',
    expr: toExpr('hello').like('h%'),
    expected: true,
  ),
  (
    name: '"hello".like("%o")',
    expr: toExpr('hello').like('%o'),
    expected: true,
  ),
  (
    name: '"hello".like("h%o")',
    expr: toExpr('hello').like('h%o'),
    expected: true,
  ),
  (
    name: '"hello".like("_ello")',
    expr: toExpr('hello').like('_ello'),
    expected: true,
  ),
  (
    name: '"hello".like("h_llo")',
    expr: toExpr('hello').like('h_llo'),
    expected: true,
  ),
  (
    name: '"hello".like("he__o")',
    expr: toExpr('hello').like('he__o'),
    expected: true,
  ),
  (
    name: '"hello".like("hell_")',
    expr: toExpr('hello').like('hell_'),
    expected: true,
  ),

  // Tests for .contains
  (
    name: '"".contains("")',
    expr: toExpr('').contains(toExpr('')),
    expected: true,
  ),
  (
    name: '"".contains("hello")',
    expr: toExpr('').contains(toExpr('hello')),
    expected: false,
  ),
  (
    name: '"hello".contains("")',
    expr: toExpr('hello').contains(toExpr('')),
    expected: true,
  ),
  (
    name: '"hello".contains("hello")',
    expr: toExpr('hello').contains(toExpr('hello')),
    expected: true,
  ),
  (
    name: '"hello".contains("hell")',
    expr: toExpr('hello').contains(toExpr('hell')),
    expected: true,
  ),
  (
    name: '"hello".contains("world")',
    expr: toExpr('hello').contains(toExpr('world')),
    expected: false,
  ),
  (
    name: '"hello world".contains("world")',
    expr: toExpr('hello world').contains(toExpr('world')),
    expected: true,
  ),
  (
    name: '"hello world".contains("hello")',
    expr: toExpr('hello world').contains(toExpr('hello')),
    expected: true,
  ),
  (
    name: '"hello world".contains("llo")',
    expr: toExpr('hello world').contains(toExpr('llo')),
    expected: true,
  ),

  // Tests for .containsLiteral
  (
    name: '"".containsLiteral("")',
    expr: toExpr('').containsValue(''),
    expected: true,
  ),
  (
    name: '"".containsLiteral("hello")',
    expr: toExpr('').containsValue('hello'),
    expected: false,
  ),
  (
    name: '"hello".containsLiteral("")',
    expr: toExpr('hello').containsValue(''),
    expected: true,
  ),
  (
    name: '"hello".containsLiteral("hello")',
    expr: toExpr('hello').containsValue('hello'),
    expected: true,
  ),
  (
    name: '"hello".containsLiteral("hell")',
    expr: toExpr('hello').containsValue('hell'),
    expected: true,
  ),
  (
    name: '"hello".containsLiteral("world")',
    expr: toExpr('hello').containsValue('world'),
    expected: false,
  ),
  (
    name: '"hello world".containsLiteral("world")',
    expr: toExpr('hello world').containsValue('world'),
    expected: true,
  ),
  (
    name: '"hello world".containsLiteral("hello")',
    expr: toExpr('hello world').containsValue('hello'),
    expected: true,
  ),
  (
    name: '"hello world".containsLiteral("llo")',
    expr: toExpr('hello world').containsValue('llo'),
    expected: true,
  ),

  // Tests for .lessThan
  (
    name: '"".lessThan("")',
    expr: toExpr('').lessThan(toExpr('')),
    expected: false,
  ),
  (
    name: '"".lessThan("A")',
    expr: toExpr('').lessThan(toExpr('A')),
    expected: true,
  ),
  (
    name: '"A".lessThan("")',
    expr: toExpr('A').lessThan(toExpr('')),
    expected: false,
  ),
  (
    name: '"A".lessThan("A")',
    expr: toExpr('A').lessThan(toExpr('A')),
    expected: false,
  ),
  (
    name: '"A".lessThan("B")',
    expr: toExpr('A').lessThan(toExpr('B')),
    expected: true,
  ),

  // Tests for .lessThanLiteral
  (
    name: '"".lessThanLiteral("")',
    expr: toExpr('').lessThanValue(''),
    expected: false,
  ),
  (
    name: '"".lessThanLiteral("A")',
    expr: toExpr('').lessThanValue('A'),
    expected: true,
  ),
  (
    name: '"A".lessThanLiteral("")',
    expr: toExpr('A').lessThanValue(''),
    expected: false,
  ),
  (
    name: '"A".lessThanLiteral("A")',
    expr: toExpr('A').lessThanValue('A'),
    expected: false,
  ),
  (
    name: '"A".lessThanLiteral("B")',
    expr: toExpr('A').lessThanValue('B'),
    expected: true,
  ),

  // Tests for <
  (
    name: '"" < ""',
    expr: toExpr('') < toExpr(''),
    expected: false,
  ),
  (
    name: '"" < "A"',
    expr: toExpr('') < toExpr('A'),
    expected: true,
  ),
  (
    name: '"A" < ""',
    expr: toExpr('A') < toExpr(''),
    expected: false,
  ),
  (
    name: '"A" < "A"',
    expr: toExpr('A') < toExpr('A'),
    expected: false,
  ),
  (
    name: '"A" < "B"',
    expr: toExpr('A') < toExpr('B'),
    expected: true,
  ),

  // Tests for .greaterThan
  (
    name: '"".greaterThan("")',
    expr: toExpr('').greaterThan(toExpr('')),
    expected: false,
  ),
  (
    name: '"".greaterThan("A")',
    expr: toExpr('').greaterThan(toExpr('A')),
    expected: false,
  ),
  (
    name: '"A".greaterThan("")',
    expr: toExpr('A').greaterThan(toExpr('')),
    expected: true,
  ),
  (
    name: '"A".greaterThan("A")',
    expr: toExpr('A').greaterThan(toExpr('A')),
    expected: false,
  ),
  (
    name: '"A".greaterThan("B")',
    expr: toExpr('A').greaterThan(toExpr('B')),
    expected: false,
  ),

  // Tests for .greaterThanLiteral
  (
    name: '"".greaterThanLiteral("")',
    expr: toExpr('').greaterThanValue(''),
    expected: false,
  ),
  (
    name: '"".greaterThanLiteral("A")',
    expr: toExpr('').greaterThanValue('A'),
    expected: false,
  ),
  (
    name: '"A".greaterThanLiteral("")',
    expr: toExpr('A').greaterThanValue(''),
    expected: true,
  ),
  (
    name: '"A".greaterThanLiteral("A")',
    expr: toExpr('A').greaterThanValue('A'),
    expected: false,
  ),
  (
    name: '"A".greaterThanLiteral("B")',
    expr: toExpr('A').greaterThanValue('B'),
    expected: false,
  ),

  // Tests for >
  (
    name: '"" > ""',
    expr: toExpr('') > toExpr(''),
    expected: false,
  ),
  (
    name: '"" > "A"',
    expr: toExpr('') > toExpr('A'),
    expected: false,
  ),
  (
    name: '"A" > ""',
    expr: toExpr('A') > toExpr(''),
    expected: true,
  ),
  (
    name: '"A" > "A"',
    expr: toExpr('A') > toExpr('A'),
    expected: false,
  ),
  (
    name: '"A" > "B"',
    expr: toExpr('A') > toExpr('B'),
    expected: false,
  ),

  // Tests for .lessThanOrEqual
  (
    name: '"".lessThanOrEqual("")',
    expr: toExpr('').lessThanOrEqual(toExpr('')),
    expected: true,
  ),
  (
    name: '"".lessThanOrEqual("A")',
    expr: toExpr('').lessThanOrEqual(toExpr('A')),
    expected: true,
  ),
  (
    name: '"A".lessThanOrEqual("")',
    expr: toExpr('A').lessThanOrEqual(toExpr('')),
    expected: false,
  ),
  (
    name: '"A".lessThanOrEqual("A")',
    expr: toExpr('A').lessThanOrEqual(toExpr('A')),
    expected: true,
  ),
  (
    name: '"A".lessThanOrEqual("B")',
    expr: toExpr('A').lessThanOrEqual(toExpr('B')),
    expected: true,
  ),

  // Tests for .lessThanOrEqualLiteral
  (
    name: '"".lessThanOrEqualLiteral("")',
    expr: toExpr('').lessThanOrEqualValue(''),
    expected: true,
  ),
  (
    name: '"".lessThanOrEqualLiteral("A")',
    expr: toExpr('').lessThanOrEqualValue('A'),
    expected: true,
  ),
  (
    name: '"A".lessThanOrEqualLiteral("")',
    expr: toExpr('A').lessThanOrEqualValue(''),
    expected: false,
  ),
  (
    name: '"A".lessThanOrEqualLiteral("A")',
    expr: toExpr('A').lessThanOrEqualValue('A'),
    expected: true,
  ),
  (
    name: '"A".lessThanOrEqualLiteral("B")',
    expr: toExpr('A').lessThanOrEqualValue('B'),
    expected: true,
  ),

  // Tests for <=
  (
    name: '"" <= ""',
    expr: toExpr('') <= toExpr(''),
    expected: true,
  ),
  (
    name: '"" <= "A"',
    expr: toExpr('') <= toExpr('A'),
    expected: true,
  ),
  (
    name: '"A" <= ""',
    expr: toExpr('A') <= toExpr(''),
    expected: false,
  ),
  (
    name: '"A" <= "A"',
    expr: toExpr('A') <= toExpr('A'),
    expected: true,
  ),
  (
    name: '"A" <= "B"',
    expr: toExpr('A') <= toExpr('B'),
    expected: true,
  ),

  // Tests for .greaterThanOrEqual
  (
    name: '"".greaterThanOrEqual("")',
    expr: toExpr('').greaterThanOrEqual(toExpr('')),
    expected: true,
  ),
  (
    name: '"".greaterThanOrEqual("A")',
    expr: toExpr('').greaterThanOrEqual(toExpr('A')),
    expected: false,
  ),
  (
    name: '"A".greaterThanOrEqual("")',
    expr: toExpr('A').greaterThanOrEqual(toExpr('')),
    expected: true,
  ),
  (
    name: '"A".greaterThanOrEqual("A")',
    expr: toExpr('A').greaterThanOrEqual(toExpr('A')),
    expected: true,
  ),
  (
    name: '"A".greaterThanOrEqual("B")',
    expr: toExpr('A').greaterThanOrEqual(toExpr('B')),
    expected: false,
  ),

  // Tests for .greaterThanOrEqualLiteral
  (
    name: '"".greaterThanOrEqualLiteral("")',
    expr: toExpr('').greaterThanOrEqualValue(''),
    expected: true,
  ),
  (
    name: '"".greaterThanOrEqualLiteral("A")',
    expr: toExpr('').greaterThanOrEqualValue('A'),
    expected: false,
  ),
  (
    name: '"A".greaterThanOrEqualLiteral("")',
    expr: toExpr('A').greaterThanOrEqualValue(''),
    expected: true,
  ),
  (
    name: '"A".greaterThanOrEqualLiteral("A")',
    expr: toExpr('A').greaterThanOrEqualValue('A'),
    expected: true,
  ),
  (
    name: '"A".greaterThanOrEqualLiteral("B")',
    expr: toExpr('A').greaterThanOrEqualValue('B'),
    expected: false,
  ),

  // Tests for >=
  (
    name: '"" >= ""',
    expr: toExpr('') >= toExpr(''),
    expected: true,
  ),
  (
    name: '"" >= "A"',
    expr: toExpr('') >= toExpr('A'),
    expected: false,
  ),
  (
    name: '"A" >= ""',
    expr: toExpr('A') >= toExpr(''),
    expected: true,
  ),
  (
    name: '"A" >= "A"',
    expr: toExpr('A') >= toExpr('A'),
    expected: true,
  ),
  (
    name: '"A" >= "B"',
    expr: toExpr('A') >= toExpr('B'),
    expected: false,
  ),

  // Tests for asInt()
  (
    name: '"42".asInt()',
    expr: toExpr('42').asInt(),
    expected: 42,
  ),
  (
    name: '"0".asInt()',
    expr: toExpr('0').asInt(),
    expected: 0,
  ),
  (
    name: '"-1".asInt()',
    expr: toExpr('-1').asInt(),
    expected: -1,
  ),

  // Tests for asDouble()
  (
    name: '"42.0".asDouble()',
    expr: toExpr('42.0').asDouble(),
    expected: 42.0,
  ),
  (
    name: '"0.0".asDouble()',
    expr: toExpr('0.0').asDouble(),
    expected: 0.0,
  ),
  (
    name: '"-1.0".asDouble()',
    expr: toExpr('-1.0').asDouble(),
    expected: -1.0,
  ),
];

void main() {
  final r = TestRunner<Schema>(resetDatabaseForEachTest: false);
  for (final c in _cases) {
    r.addTest(c.name, (db) async {
      final result = await db.select(
        (c.expr,),
      ).fetch();
      check(result).isNotNull().equals(c.expected);
    });
  }

  r.run();
}
