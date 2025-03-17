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

final epoch = DateTime.fromMicrosecondsSinceEpoch(0).toUtc();
final today = DateTime.parse('2025-03-10T11:34:36.164006Z');

final _cases = [
  // Test for .length
  (
    name: '"".length',
    expr: literal('').length,
    expected: 0,
  ),
  (
    name: '"hello".length',
    expr: literal('hello').length,
    expected: 5,
  ),

  // Tests for .toLowerCase() case
  (
    name: '"".toLowerCase()',
    expr: literal('').toLowerCase(),
    expected: '',
  ),
  (
    name: '"hello".toLowerCase()',
    expr: literal('hello').toLowerCase(),
    expected: 'hello',
  ),
  (
    name: '"HELLO".toLowerCase()',
    expr: literal('HELLO').toLowerCase(),
    expected: 'hello',
  ),
  (
    name: '"Hello".toLowerCase()',
    expr: literal('Hello').toLowerCase(),
    expected: 'hello',
  ),

  // Tests for .toUpperCase() case
  (
    name: '"".toUpperCase()',
    expr: literal('').toUpperCase(),
    expected: '',
  ),
  (
    name: '"hello".toUpperCase()',
    expr: literal('hello').toUpperCase(),
    expected: 'HELLO',
  ),
  (
    name: '"HELLO".toUpperCase()',
    expr: literal('HELLO').toUpperCase(),
    expected: 'HELLO',
  ),
  (
    name: '"Hello".toUpperCase()',
    expr: literal('Hello').toUpperCase(),
    expected: 'HELLO',
  ),

  // Tests for .equals
  (
    name: '"".equals("")',
    expr: literal('').equals(literal('')),
    expected: true,
  ),
  (
    name: '"".equals("hello")',
    expr: literal('').equals(literal('hello')),
    expected: false,
  ),
  (
    name: '"hello".equals("")',
    expr: literal('hello').equals(literal('')),
    expected: false,
  ),
  (
    name: '"hello".equals("hello")',
    expr: literal('hello').equals(literal('hello')),
    expected: true,
  ),
  (
    name: '"hello".equals("hello world")',
    expr: literal('hello').equals(literal('hello world')),
    expected: false,
  ),

  // Tests for .equalsLiteral
  (
    name: '"".equalsLiteral("")',
    expr: literal('').equalsLiteral(''),
    expected: true,
  ),
  (
    name: '"".equalsLiteral("hello")',
    expr: literal('').equalsLiteral('hello'),
    expected: false,
  ),
  (
    name: '"hello".equalsLiteral("")',
    expr: literal('hello').equalsLiteral(''),
    expected: false,
  ),
  (
    name: '"hello".equalsLiteral("hello")',
    expr: literal('hello').equalsLiteral('hello'),
    expected: true,
  ),
  (
    name: '"hello".equalsLiteral("hello world")',
    expr: literal('hello').equalsLiteral('hello world'),
    expected: false,
  ),

  // Tests for .notEquals
  (
    name: '"".notEquals("")',
    expr: literal('').notEquals(literal('')),
    expected: false,
  ),
  (
    name: '"".notEquals("hello")',
    expr: literal('').notEquals(literal('hello')),
    expected: true,
  ),
  (
    name: '"hello".notEquals("")',
    expr: literal('hello').notEquals(literal('')),
    expected: true,
  ),
  (
    name: '"hello".notEquals("hello")',
    expr: literal('hello').notEquals(literal('hello')),
    expected: false,
  ),
  (
    name: '"hello".notEquals("hello world")',
    expr: literal('hello').notEquals(literal('hello world')),
    expected: true,
  ),

  // Tests for .notEqualsLiteral
  (
    name: '"".notEqualsLiteral("")',
    expr: literal('').notEqualsLiteral(''),
    expected: false,
  ),
  (
    name: '"".notEqualsLiteral("hello")',
    expr: literal('').notEqualsLiteral('hello'),
    expected: true,
  ),
  (
    name: '"hello".notEqualsLiteral("")',
    expr: literal('hello').notEqualsLiteral(''),
    expected: true,
  ),
  (
    name: '"hello".notEqualsLiteral("hello")',
    expr: literal('hello').notEqualsLiteral('hello'),
    expected: false,
  ),
  (
    name: '"hello".notEqualsLiteral("hello world")',
    expr: literal('hello').notEqualsLiteral('hello world'),
    expected: true,
  ),

  // Tests for .isEmpty
  (
    name: '"".isEmpty',
    expr: literal('').isEmpty,
    expected: true,
  ),
  (
    name: '"hello".isEmpty',
    expr: literal('hello').isEmpty,
    expected: false,
  ),

  // Tests for .isNotEmpty
  (
    name: '"".isNotEmpty',
    expr: literal('').isNotEmpty,
    expected: false,
  ),
  (
    name: '"hello".isNotEmpty',
    expr: literal('hello').isNotEmpty,
    expected: true,
  ),

  // Tests for .startsWith
  (
    name: '"".startsWith("")',
    expr: literal('').startsWith(literal('')),
    expected: true,
  ),
  (
    name: '"".startsWith("hello")',
    expr: literal('').startsWith(literal('hello')),
    expected: false,
  ),
  (
    name: '"hello".startsWith("")',
    expr: literal('hello').startsWith(literal('')),
    expected: true,
  ),
  (
    name: '"hello".startsWith("hello")',
    expr: literal('hello').startsWith(literal('hello')),
    expected: true,
  ),
  (
    name: '"hello".startsWith("hell")',
    expr: literal('hello').startsWith(literal('hell')),
    expected: true,
  ),
  (
    name: '"hello".startsWith("world")',
    expr: literal('hello').startsWith(literal('world')),
    expected: false,
  ),

  // Tests for .startsWithLiteral
  (
    name: '"".startsWithLiteral("")',
    expr: literal('').startsWithLiteral(''),
    expected: true,
  ),
  (
    name: '"".startsWithLiteral("hello")',
    expr: literal('').startsWithLiteral('hello'),
    expected: false,
  ),
  (
    name: '"hello".startsWithLiteral("")',
    expr: literal('hello').startsWithLiteral(''),
    expected: true,
  ),
  (
    name: '"hello".startsWithLiteral("hello")',
    expr: literal('hello').startsWithLiteral('hello'),
    expected: true,
  ),
  (
    name: '"hello".startsWithLiteral("hell")',
    expr: literal('hello').startsWithLiteral('hell'),
    expected: true,
  ),
  (
    name: '"hello".startsWithLiteral("world")',
    expr: literal('hello').startsWithLiteral('world'),
    expected: false,
  ),

  // Tests for .endsWith
  (
    name: '"".endsWith("")',
    expr: literal('').endsWith(literal('')),
    expected: true,
  ),
  (
    name: '"".endsWith("hello")',
    expr: literal('').endsWith(literal('hello')),
    expected: false,
  ),
  (
    name: '"hello".endsWith("")',
    expr: literal('hello').endsWith(literal('')),
    expected: true,
  ),
  (
    name: '"hello".endsWith("hello")',
    expr: literal('hello').endsWith(literal('hello')),
    expected: true,
  ),
  (
    name: '"hello".endsWith("llo")',
    expr: literal('hello').endsWith(literal('llo')),
    expected: true,
  ),
  (
    name: '"hello".endsWith("world")',
    expr: literal('hello').endsWith(literal('world')),
    expected: false,
  ),

  // Tests for .endsWithLiteral
  (
    name: '"".endsWithLiteral("")',
    expr: literal('').endsWithLiteral(''),
    expected: true,
  ),
  (
    name: '"".endsWithLiteral("hello")',
    expr: literal('').endsWithLiteral('hello'),
    expected: false,
  ),
  (
    name: '"hello".endsWithLiteral("")',
    expr: literal('hello').endsWithLiteral(''),
    expected: true,
  ),
  (
    name: '"hello".endsWithLiteral("hello")',
    expr: literal('hello').endsWithLiteral('hello'),
    expected: true,
  ),
  (
    name: '"hello".endsWithLiteral("llo")',
    expr: literal('hello').endsWithLiteral('llo'),
    expected: true,
  ),
  (
    name: '"hello".endsWithLiteral("world")',
    expr: literal('hello').endsWithLiteral('world'),
    expected: false,
  ),

  // Tests for .like
  (
    name: '"".like("")',
    expr: literal('').like(''),
    expected: true,
  ),
  (
    name: '"".like("hello")',
    expr: literal('').like('hello'),
    expected: false,
  ),
  (
    name: '"hello".like("")',
    expr: literal('hello').like(''),
    expected: false,
  ),
  (
    name: '"hello".like("hello")',
    expr: literal('hello').like('hello'),
    expected: true,
  ),
  (
    name: '"hello".like("hell")',
    expr: literal('hello').like('hell'),
    expected: false,
  ),
  (
    name: '"hello".like("world")',
    expr: literal('hello').like('world'),
    expected: false,
  ),
  (
    name: '"hello".like("%")',
    expr: literal('hello').like('%'),
    expected: true,
  ),
  (
    name: '"hello".like("h%")',
    expr: literal('hello').like('h%'),
    expected: true,
  ),
  (
    name: '"hello".like("%o")',
    expr: literal('hello').like('%o'),
    expected: true,
  ),
  (
    name: '"hello".like("h%o")',
    expr: literal('hello').like('h%o'),
    expected: true,
  ),
  (
    name: '"hello".like("_ello")',
    expr: literal('hello').like('_ello'),
    expected: true,
  ),
  (
    name: '"hello".like("h_llo")',
    expr: literal('hello').like('h_llo'),
    expected: true,
  ),
  (
    name: '"hello".like("he__o")',
    expr: literal('hello').like('he__o'),
    expected: true,
  ),
  (
    name: '"hello".like("hell_")',
    expr: literal('hello').like('hell_'),
    expected: true,
  ),

  // Tests for .contains
  (
    name: '"".contains("")',
    expr: literal('').contains(literal('')),
    expected: true,
  ),
  (
    name: '"".contains("hello")',
    expr: literal('').contains(literal('hello')),
    expected: false,
  ),
  (
    name: '"hello".contains("")',
    expr: literal('hello').contains(literal('')),
    expected: true,
  ),
  (
    name: '"hello".contains("hello")',
    expr: literal('hello').contains(literal('hello')),
    expected: true,
  ),
  (
    name: '"hello".contains("hell")',
    expr: literal('hello').contains(literal('hell')),
    expected: true,
  ),
  (
    name: '"hello".contains("world")',
    expr: literal('hello').contains(literal('world')),
    expected: false,
  ),
  (
    name: '"hello world".contains("world")',
    expr: literal('hello world').contains(literal('world')),
    expected: true,
  ),
  (
    name: '"hello world".contains("hello")',
    expr: literal('hello world').contains(literal('hello')),
    expected: true,
  ),
  (
    name: '"hello world".contains("llo")',
    expr: literal('hello world').contains(literal('llo')),
    expected: true,
  ),

  // Tests for .containsLiteral
  (
    name: '"".containsLiteral("")',
    expr: literal('').containsLiteral(''),
    expected: true,
  ),
  (
    name: '"".containsLiteral("hello")',
    expr: literal('').containsLiteral('hello'),
    expected: false,
  ),
  (
    name: '"hello".containsLiteral("")',
    expr: literal('hello').containsLiteral(''),
    expected: true,
  ),
  (
    name: '"hello".containsLiteral("hello")',
    expr: literal('hello').containsLiteral('hello'),
    expected: true,
  ),
  (
    name: '"hello".containsLiteral("hell")',
    expr: literal('hello').containsLiteral('hell'),
    expected: true,
  ),
  (
    name: '"hello".containsLiteral("world")',
    expr: literal('hello').containsLiteral('world'),
    expected: false,
  ),
  (
    name: '"hello world".containsLiteral("world")',
    expr: literal('hello world').containsLiteral('world'),
    expected: true,
  ),
  (
    name: '"hello world".containsLiteral("hello")',
    expr: literal('hello world').containsLiteral('hello'),
    expected: true,
  ),
  (
    name: '"hello world".containsLiteral("llo")',
    expr: literal('hello world').containsLiteral('llo'),
    expected: true,
  ),

  // Tests for .lessThan
  (
    name: '"".lessThan("")',
    expr: literal('').lessThan(literal('')),
    expected: false,
  ),
  (
    name: '"".lessThan("A")',
    expr: literal('').lessThan(literal('A')),
    expected: true,
  ),
  (
    name: '"A".lessThan("")',
    expr: literal('A').lessThan(literal('')),
    expected: false,
  ),
  (
    name: '"A".lessThan("A")',
    expr: literal('A').lessThan(literal('A')),
    expected: false,
  ),
  (
    name: '"A".lessThan("B")',
    expr: literal('A').lessThan(literal('B')),
    expected: true,
  ),

  // Tests for .lessThanLiteral
  (
    name: '"".lessThanLiteral("")',
    expr: literal('').lessThanLiteral(''),
    expected: false,
  ),
  (
    name: '"".lessThanLiteral("A")',
    expr: literal('').lessThanLiteral('A'),
    expected: true,
  ),
  (
    name: '"A".lessThanLiteral("")',
    expr: literal('A').lessThanLiteral(''),
    expected: false,
  ),
  (
    name: '"A".lessThanLiteral("A")',
    expr: literal('A').lessThanLiteral('A'),
    expected: false,
  ),
  (
    name: '"A".lessThanLiteral("B")',
    expr: literal('A').lessThanLiteral('B'),
    expected: true,
  ),

  // Tests for <
  (
    name: '"" < ""',
    expr: literal('') < literal(''),
    expected: false,
  ),
  (
    name: '"" < "A"',
    expr: literal('') < literal('A'),
    expected: true,
  ),
  (
    name: '"A" < ""',
    expr: literal('A') < literal(''),
    expected: false,
  ),
  (
    name: '"A" < "A"',
    expr: literal('A') < literal('A'),
    expected: false,
  ),
  (
    name: '"A" < "B"',
    expr: literal('A') < literal('B'),
    expected: true,
  ),

  // Tests for .greaterThan
  (
    name: '"".greaterThan("")',
    expr: literal('').greaterThan(literal('')),
    expected: false,
  ),
  (
    name: '"".greaterThan("A")',
    expr: literal('').greaterThan(literal('A')),
    expected: false,
  ),
  (
    name: '"A".greaterThan("")',
    expr: literal('A').greaterThan(literal('')),
    expected: true,
  ),
  (
    name: '"A".greaterThan("A")',
    expr: literal('A').greaterThan(literal('A')),
    expected: false,
  ),
  (
    name: '"A".greaterThan("B")',
    expr: literal('A').greaterThan(literal('B')),
    expected: false,
  ),

  // Tests for .greaterThanLiteral
  (
    name: '"".greaterThanLiteral("")',
    expr: literal('').greaterThanLiteral(''),
    expected: false,
  ),
  (
    name: '"".greaterThanLiteral("A")',
    expr: literal('').greaterThanLiteral('A'),
    expected: false,
  ),
  (
    name: '"A".greaterThanLiteral("")',
    expr: literal('A').greaterThanLiteral(''),
    expected: true,
  ),
  (
    name: '"A".greaterThanLiteral("A")',
    expr: literal('A').greaterThanLiteral('A'),
    expected: false,
  ),
  (
    name: '"A".greaterThanLiteral("B")',
    expr: literal('A').greaterThanLiteral('B'),
    expected: false,
  ),

  // Tests for >
  (
    name: '"" > ""',
    expr: literal('') > literal(''),
    expected: false,
  ),
  (
    name: '"" > "A"',
    expr: literal('') > literal('A'),
    expected: false,
  ),
  (
    name: '"A" > ""',
    expr: literal('A') > literal(''),
    expected: true,
  ),
  (
    name: '"A" > "A"',
    expr: literal('A') > literal('A'),
    expected: false,
  ),
  (
    name: '"A" > "B"',
    expr: literal('A') > literal('B'),
    expected: false,
  ),

  // Tests for .lessThanOrEqual
  (
    name: '"".lessThanOrEqual("")',
    expr: literal('').lessThanOrEqual(literal('')),
    expected: true,
  ),
  (
    name: '"".lessThanOrEqual("A")',
    expr: literal('').lessThanOrEqual(literal('A')),
    expected: true,
  ),
  (
    name: '"A".lessThanOrEqual("")',
    expr: literal('A').lessThanOrEqual(literal('')),
    expected: false,
  ),
  (
    name: '"A".lessThanOrEqual("A")',
    expr: literal('A').lessThanOrEqual(literal('A')),
    expected: true,
  ),
  (
    name: '"A".lessThanOrEqual("B")',
    expr: literal('A').lessThanOrEqual(literal('B')),
    expected: true,
  ),

  // Tests for .lessThanOrEqualLiteral
  (
    name: '"".lessThanOrEqualLiteral("")',
    expr: literal('').lessThanOrEqualLiteral(''),
    expected: true,
  ),
  (
    name: '"".lessThanOrEqualLiteral("A")',
    expr: literal('').lessThanOrEqualLiteral('A'),
    expected: true,
  ),
  (
    name: '"A".lessThanOrEqualLiteral("")',
    expr: literal('A').lessThanOrEqualLiteral(''),
    expected: false,
  ),
  (
    name: '"A".lessThanOrEqualLiteral("A")',
    expr: literal('A').lessThanOrEqualLiteral('A'),
    expected: true,
  ),
  (
    name: '"A".lessThanOrEqualLiteral("B")',
    expr: literal('A').lessThanOrEqualLiteral('B'),
    expected: true,
  ),

  // Tests for <=
  (
    name: '"" <= ""',
    expr: literal('') <= literal(''),
    expected: true,
  ),
  (
    name: '"" <= "A"',
    expr: literal('') <= literal('A'),
    expected: true,
  ),
  (
    name: '"A" <= ""',
    expr: literal('A') <= literal(''),
    expected: false,
  ),
  (
    name: '"A" <= "A"',
    expr: literal('A') <= literal('A'),
    expected: true,
  ),
  (
    name: '"A" <= "B"',
    expr: literal('A') <= literal('B'),
    expected: true,
  ),

  // Tests for .greaterThanOrEqual
  (
    name: '"".greaterThanOrEqual("")',
    expr: literal('').greaterThanOrEqual(literal('')),
    expected: true,
  ),
  (
    name: '"".greaterThanOrEqual("A")',
    expr: literal('').greaterThanOrEqual(literal('A')),
    expected: false,
  ),
  (
    name: '"A".greaterThanOrEqual("")',
    expr: literal('A').greaterThanOrEqual(literal('')),
    expected: true,
  ),
  (
    name: '"A".greaterThanOrEqual("A")',
    expr: literal('A').greaterThanOrEqual(literal('A')),
    expected: true,
  ),
  (
    name: '"A".greaterThanOrEqual("B")',
    expr: literal('A').greaterThanOrEqual(literal('B')),
    expected: false,
  ),

  // Tests for .greaterThanOrEqualLiteral
  (
    name: '"".greaterThanOrEqualLiteral("")',
    expr: literal('').greaterThanOrEqualLiteral(''),
    expected: true,
  ),
  (
    name: '"".greaterThanOrEqualLiteral("A")',
    expr: literal('').greaterThanOrEqualLiteral('A'),
    expected: false,
  ),
  (
    name: '"A".greaterThanOrEqualLiteral("")',
    expr: literal('A').greaterThanOrEqualLiteral(''),
    expected: true,
  ),
  (
    name: '"A".greaterThanOrEqualLiteral("A")',
    expr: literal('A').greaterThanOrEqualLiteral('A'),
    expected: true,
  ),
  (
    name: '"A".greaterThanOrEqualLiteral("B")',
    expr: literal('A').greaterThanOrEqualLiteral('B'),
    expected: false,
  ),

  // Tests for >=
  (
    name: '"" >= ""',
    expr: literal('') >= literal(''),
    expected: true,
  ),
  (
    name: '"" >= "A"',
    expr: literal('') >= literal('A'),
    expected: false,
  ),
  (
    name: '"A" >= ""',
    expr: literal('A') >= literal(''),
    expected: true,
  ),
  (
    name: '"A" >= "A"',
    expr: literal('A') >= literal('A'),
    expected: true,
  ),
  (
    name: '"A" >= "B"',
    expr: literal('A') >= literal('B'),
    expected: false,
  ),

  // Tests for asInt()
  (
    name: '"42".asInt()',
    expr: literal('42').asInt(),
    expected: 42,
  ),
  (
    name: '"0".asInt()',
    expr: literal('0').asInt(),
    expected: 0,
  ),
  (
    name: '"-1".asInt()',
    expr: literal('-1').asInt(),
    expected: -1,
  ),

  // Tests for asDouble()
  (
    name: '"42.0".asDouble()',
    expr: literal('42.0').asDouble(),
    expected: 42.0,
  ),
  (
    name: '"0.0".asDouble()',
    expr: literal('0.0').asDouble(),
    expected: 0.0,
  ),
  (
    name: '"-1.0".asDouble()',
    expr: literal('-1.0').asDouble(),
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
