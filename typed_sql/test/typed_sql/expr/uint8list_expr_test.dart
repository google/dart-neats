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
  // Tests for .equals
  (
    name: '[].equals([])',
    expr: toExpr(Uint8List.fromList([])).equals(toExpr(Uint8List.fromList([]))),
    expected: true,
  ),
  (
    name: '[1,2,3].equals([1,2,3])',
    expr: toExpr(Uint8List.fromList([1, 2, 3]))
        .equals(toExpr(Uint8List.fromList([1, 2, 3]))),
    expected: true,
  ),
  (
    name: '[1,2,3].equals([1,2])',
    expr: toExpr(Uint8List.fromList([1, 2, 3]))
        .equals(toExpr(Uint8List.fromList([1, 2]))),
    expected: false,
  ),
  (
    name: '[1,2,3].equals([])',
    expr: toExpr(Uint8List.fromList([1, 2, 3]))
        .equals(toExpr(Uint8List.fromList([]))),
    expected: false,
  ),
  (
    name: '[].equals([1,2,3])',
    expr: toExpr(Uint8List.fromList([]))
        .equals(toExpr(Uint8List.fromList([1, 2, 3]))),
    expected: false,
  ),
  (
    name: 'null.equals([1,2,3])',
    expr: toExpr(null as Uint8List?)
        .equals(toExpr(Uint8List.fromList([1, 2, 3]))),
    expected: false,
  ),
  (
    name: '[1,2,3].equals(null)',
    expr: toExpr(Uint8List.fromList([1, 2, 3]))
        .equals(toExpr(null as Uint8List?)),
    expected: false,
  ),

  // Tests for .equalsValue
  (
    name: '[].equalsValue([])',
    expr: toExpr(Uint8List.fromList([])).equalsValue(Uint8List.fromList([])),
    expected: true,
  ),
  (
    name: '[1,2,3].equalsValue([1,2,3])',
    expr: toExpr(Uint8List.fromList([1, 2, 3]))
        .equalsValue(Uint8List.fromList([1, 2, 3])),
    expected: true,
  ),
  (
    name: '[1,2,3].equalsValue([1,2])',
    expr: toExpr(Uint8List.fromList([1, 2, 3]))
        .equalsValue(Uint8List.fromList([1, 2])),
    expected: false,
  ),
  (
    name: '[1,2,3].equalsValue([])',
    expr: toExpr(Uint8List.fromList([1, 2, 3]))
        .equalsValue(Uint8List.fromList([])),
    expected: false,
  ),
  (
    name: '[].equalsValue([1,2,3])',
    expr: toExpr(Uint8List.fromList([]))
        .equalsValue(Uint8List.fromList([1, 2, 3])),
    expected: false,
  ),
  (
    name: 'null.equalsValue([1,2,3])',
    expr: toExpr(null as Uint8List?).equalsValue(Uint8List.fromList([1, 2, 3])),
    expected: false,
  ),
  (
    name: '[1,2,3].equalsValue(null)',
    expr: toExpr(Uint8List.fromList([1, 2, 3])).equalsValue(null),
    expected: false,
  ),

  // Tests for .notEquals
  (
    name: '[].notEquals([])',
    expr: toExpr(Uint8List.fromList([]))
        .notEquals(toExpr(Uint8List.fromList([]))),
    expected: false,
  ),
  (
    name: '[1,2,3].notEquals([1,2,3])',
    expr: toExpr(Uint8List.fromList([1, 2, 3]))
        .notEquals(toExpr(Uint8List.fromList([1, 2, 3]))),
    expected: false,
  ),
  (
    name: '[1,2,3].notEquals([1,2])',
    expr: toExpr(Uint8List.fromList([1, 2, 3]))
        .notEquals(toExpr(Uint8List.fromList([1, 2]))),
    expected: true,
  ),
  (
    name: '[1,2,3].notEquals([])',
    expr: toExpr(Uint8List.fromList([1, 2, 3]))
        .notEquals(toExpr(Uint8List.fromList([]))),
    expected: true,
  ),
  (
    name: '[].notEquals([1,2,3])',
    expr: toExpr(Uint8List.fromList([]))
        .notEquals(toExpr(Uint8List.fromList([1, 2, 3]))),
    expected: true,
  ),
  (
    name: 'null.notEquals([1,2,3])',
    expr: toExpr(null as Uint8List?)
        .notEquals(toExpr(Uint8List.fromList([1, 2, 3]))),
    expected: true,
  ),
  (
    name: '[1,2,3].notEquals(null)',
    expr: toExpr(Uint8List.fromList([1, 2, 3]))
        .notEquals(toExpr(null as Uint8List?)),
    expected: true,
  ),

  // Tests for .notEqualsValue
  (
    name: '[].notEqualsValue([])',
    expr: toExpr(Uint8List.fromList([])).notEqualsValue(Uint8List.fromList([])),
    expected: false,
  ),
  (
    name: '[1,2,3].notEqualsValue([1,2,3])',
    expr: toExpr(Uint8List.fromList([1, 2, 3]))
        .notEqualsValue(Uint8List.fromList([1, 2, 3])),
    expected: false,
  ),
  (
    name: '[1,2,3].notEqualsValue([1,2])',
    expr: toExpr(Uint8List.fromList([1, 2, 3]))
        .notEqualsValue(Uint8List.fromList([1, 2])),
    expected: true,
  ),
  (
    name: '[1,2,3].notEqualsValue([])',
    expr: toExpr(Uint8List.fromList([1, 2, 3]))
        .notEqualsValue(Uint8List.fromList([])),
    expected: true,
  ),
  (
    name: '[].notEqualsValue([1,2,3])',
    expr: toExpr(Uint8List.fromList([]))
        .notEqualsValue(Uint8List.fromList([1, 2, 3])),
    expected: true,
  ),
  (
    name: 'null.notEqualsValue([1,2,3])',
    expr: toExpr(null as Uint8List?)
        .notEqualsValue(Uint8List.fromList([1, 2, 3])),
    expected: true,
  ),
  (
    name: '[1,2,3].notEqualsValue(null)',
    expr: toExpr(Uint8List.fromList([1, 2, 3])).notEqualsValue(null),
    expected: true,
  ),

  // Tests for .length
  (
    name: '[].length',
    expr: toExpr(Uint8List.fromList([])).length,
    expected: 0,
  ),
  (
    name: '[1,2,3].length',
    expr: toExpr(Uint8List.fromList([1, 2, 3])).length,
    expected: 3,
  ),
  // Tests for .toHex()
  (
    name: '[].toHex()',
    expr: toExpr(Uint8List.fromList([])).toHex(),
    expected: '',
  ),
  (
    name: '[1,2,3].toHex()',
    expr: toExpr(Uint8List.fromList([1, 2, 3])).toHex(),
    expected: '010203',
  ),
  (
    name: '[255].toHex()',
    expr: toExpr(Uint8List.fromList([255])).toHex(),
    expected: 'FF',
  ),

  // Tests for .concat(...)
  (
    name: '[].concat([])',
    expr: toExpr(Uint8List.fromList([])).concat(toExpr(Uint8List.fromList([]))),
    expected: Uint8List.fromList([]),
  ),
  (
    name: '[1,2].concat([3,4])',
    expr: toExpr(Uint8List.fromList([1, 2]))
        .concat(toExpr(Uint8List.fromList([3, 4]))),
    expected: Uint8List.fromList([1, 2, 3, 4]),
  ),
  (
    name: '[1,2].concat([])',
    expr: toExpr(Uint8List.fromList([1, 2]))
        .concat(toExpr(Uint8List.fromList([]))),
    expected: Uint8List.fromList([1, 2]),
  ),
  (
    name: '[].concat([3,4])',
    expr: toExpr(Uint8List.fromList([]))
        .concat(toExpr(Uint8List.fromList([3, 4]))),
    expected: Uint8List.fromList([3, 4]),
  ),

  // Tests for .operator+
  (
    name: '[].operator+([])',
    expr: toExpr(Uint8List.fromList([])) + toExpr(Uint8List.fromList([])),
    expected: Uint8List.fromList([]),
  ),
  (
    name: '[1,2].operator+([3,4])',
    expr:
        toExpr(Uint8List.fromList([1, 2])) + toExpr(Uint8List.fromList([3, 4])),
    expected: Uint8List.fromList([1, 2, 3, 4]),
  ),
  (
    name: '[1,2].operator+([])',
    expr: toExpr(Uint8List.fromList([1, 2])) + toExpr(Uint8List.fromList([])),
    expected: Uint8List.fromList([1, 2]),
  ),
  (
    name: '[].operator+([3,4])',
    expr: toExpr(Uint8List.fromList([])) + toExpr(Uint8List.fromList([3, 4])),
    expected: Uint8List.fromList([3, 4]),
  ),

  // Tests for .subList(start)
  (
    name: '[1,2,3,4].subList(0)',
    expr: toExpr(Uint8List.fromList([1, 2, 3, 4])).subList(toExpr(0)),
    expected: Uint8List.fromList([1, 2, 3, 4]),
  ),
  (
    name: '[1,2,3,4].subList(1)',
    expr: toExpr(Uint8List.fromList([1, 2, 3, 4])).subList(toExpr(1)),
    expected: Uint8List.fromList([2, 3, 4]),
  ),
  (
    name: '[1,2,3,4].subList(3)',
    expr: toExpr(Uint8List.fromList([1, 2, 3, 4])).subList(toExpr(3)),
    expected: Uint8List.fromList([4]),
  ),
  (
    name: '[1,2,3,4].subList(4)',
    expr: toExpr(Uint8List.fromList([1, 2, 3, 4])).subList(toExpr(4)),
    expected: Uint8List.fromList([]),
  ),
  (
    name: '[1,2,3,4].subList(5)',
    expr: toExpr(Uint8List.fromList([1, 2, 3, 4])).subList(toExpr(5)),
    expected: Uint8List.fromList([]),
  ),
  (
    name: '[1, 2, 3].subList(0) (Full list)',
    expr: toExpr(Uint8List.fromList([1, 2, 3])).subList(toExpr(0)),
    expected: Uint8List.fromList([1, 2, 3]),
  ),
  (
    name: '[1, 2, 3].subList(1) (Skip first)',
    expr: toExpr(Uint8List.fromList([1, 2, 3])).subList(toExpr(1)),
    expected: Uint8List.fromList([2, 3]),
  ),
  (
    name: '[1, 2, 3].subList(2, length: 1) (Last item)',
    expr: toExpr(Uint8List.fromList([1, 2, 3]))
        .subList(toExpr(2), length: toExpr(1)),
    expected: Uint8List.fromList([3]),
  ),
  (
    name: '[1, 2, 3].subList(10) (Out of bounds start)',
    // SQL behavior for out-of-bounds varies (usually empty string/blob),
    // ensuring it doesn't crash is valuable.
    expr: toExpr(Uint8List.fromList([1, 2, 3])).subList(toExpr(10)),
    expected: Uint8List.fromList([]),
  ),

  // Tests for .subList(start, length: length)
  (
    name: '[1,2,3,4].subList(0, length: 2)',
    expr: toExpr(Uint8List.fromList([1, 2, 3, 4]))
        .subList(toExpr(0), length: toExpr(2)),
    expected: Uint8List.fromList([1, 2]),
  ),
  (
    name: '[1,2,3,4].subList(1, length: 2)',
    expr: toExpr(Uint8List.fromList([1, 2, 3, 4]))
        .subList(toExpr(1), length: toExpr(2)),
    expected: Uint8List.fromList([2, 3]),
  ),
  (
    name: '[1,2,3,4].subList(2, length: 2)',
    expr: toExpr(Uint8List.fromList([1, 2, 3, 4]))
        .subList(toExpr(2), length: toExpr(2)),
    expected: Uint8List.fromList([3, 4]),
  ),
  (
    name: '[1,2,3,4].subList(3, length: 2)',
    expr: toExpr(Uint8List.fromList([1, 2, 3, 4]))
        .subList(toExpr(3), length: toExpr(2)),
    expected: Uint8List.fromList([4]),
  ),
  (
    name: '[1,2,3,4].subList(4, length: 2)',
    expr: toExpr(Uint8List.fromList([1, 2, 3, 4]))
        .subList(toExpr(4), length: toExpr(2)),
    expected: Uint8List.fromList([]),
  ),
  (
    name: '[1,2,3,4].subList(0, length: 0)',
    expr: toExpr(Uint8List.fromList([1, 2, 3, 4]))
        .subList(toExpr(0), length: toExpr(0)),
    expected: Uint8List.fromList([]),
  ),

  // Tests for .decodeUtf8()
  (
    name: 'Uint8List.fromList([72, 101, 108, 108, 111]).decodeUtf8()',
    expr: toExpr(Uint8List.fromList([72, 101, 108, 108, 111])).decodeUtf8(),
    expected: 'Hello',
  ),
  (
    name: 'Uint8List.fromList([]).decodeUtf8()',
    expr: toExpr(Uint8List.fromList([])).decodeUtf8(),
    expected: '',
  ),
];

final _casesToSkipMysql = <({
  String name,
  Expr expr,
  Object? expected,
})>[
  // Complex concat tests, covering cases where databases casting to text
  // might have issues.
  (
    name: '[0xFF] + [0xFF] (Invalid UTF-8 preservation)',
    expr:
        toExpr(Uint8List.fromList([0xFF])) + toExpr(Uint8List.fromList([0xFF])),
    expected: Uint8List.fromList([0xFF, 0xFF]),
  ),
  (
    name: 'Invalid UTF-8 sequence [0xC3] (lonely start byte) + [0x28]',
    expr:
        toExpr(Uint8List.fromList([0xC3])) + toExpr(Uint8List.fromList([0x28])),
    expected: Uint8List.fromList([0xC3, 0x28]),
  ),
  (
    name: 'Null byte check [0] + [0]',
    expr: toExpr(Uint8List.fromList([0])) + toExpr(Uint8List.fromList([0])),
    expected: Uint8List.fromList([0, 0]),
  ),
  (
    name: 'Simple concat equality: [A] + [B] == [AB]',
    expr: (toExpr(Uint8List.fromList([0x41])) +
            toExpr(Uint8List.fromList([0x42])))
        .equals(toExpr(Uint8List.fromList([0x41, 0x42]))),
    expected: true,
  ),
  (
    name: 'Binary safe equality: [255] + [255] == [255, 255]',
    // If "latin1_bin" collation was missing, or if string conversion happened,
    // this would likely fail or error.
    expr: (toExpr(Uint8List.fromList([0xFF])) +
            toExpr(Uint8List.fromList([0xFF])))
        .equals(toExpr(Uint8List.fromList([0xFF, 0xFF]))),
    expected: true,
  ),
  (
    name: 'Nested: ([1,2] + [3,4]).sublist(1, 2) == [2, 3]',
    // SQL: SUBSTR(CONCAT(?, ?), 2, 2)
    // This tests that the inner CONCAT result (which is cast/collated)
    // is correctly accepted by the outer SUBSTR function.
    expr: (toExpr(Uint8List.fromList([1, 2])) +
            toExpr(Uint8List.fromList([3, 4])))
        .subList(toExpr(1), length: toExpr(2))
        .equals(toExpr(Uint8List.fromList([2, 3]))),
    expected: true,
  ),
  (
    name: 'Precedence: ([A] + [B]) == ([A] + [B])',
    expr: (toExpr(Uint8List.fromList([0xAA])) +
            toExpr(Uint8List.fromList([0xBB])))
        .equals(toExpr(Uint8List.fromList([0xAA])) +
            toExpr(Uint8List.fromList([0xBB]))),
    expected: true,
  ),
  (
    name: 'Precedence Negative: ([A] + [B]) != ([A] + [C])',
    expr: (toExpr(Uint8List.fromList([0xAA])) +
            toExpr(Uint8List.fromList([0xBB])))
        .notEquals(toExpr(Uint8List.fromList([0xAA])) +
            toExpr(Uint8List.fromList([0xCC]))),
    expected: true,
  ),
  (
    name: 'Mixed UTF-8: [Valid] + [Invalid] Preservation',
    // 0x61 ('a') is valid. 0xFF is invalid.
    // If the driver treats this as a generic string, it might preserve 'a'
    // but mangle 0xFF. We need both back intact.
    expr: (toExpr(Uint8List.fromList([0x61])) +
            toExpr(Uint8List.fromList([0xFF])))
        .equals(toExpr(Uint8List.fromList([0x61, 0xFF]))),
    expected: true,
  ),
  (
    name: 'Case Sensitivity: [a] + [b] != [A] + [B]',
    expr: (toExpr(Uint8List.fromList([0x61])) +
            toExpr(Uint8List.fromList([0x62])))
        .equals(toExpr(Uint8List.fromList([0x41, 0x42]))),
    expected: false,
  ),

  // Complex subList tests splitting on charaters that could cause issues for
  // databases treating blobs as text
  (
    name: 'Slice Emoji: First byte of \u{1F600} [0xF0]',
    expr: toExpr(Uint8List.fromList([0xF0, 0x9F, 0x98, 0x80]))
        .subList(toExpr(0), length: toExpr(1)),
    expected: Uint8List.fromList([0xF0]),
  ),
  (
    name: 'Slice Emoji: Middle bytes of \u{1F600} [0x9F, 0x98]',
    expr: toExpr(Uint8List.fromList([0xF0, 0x9F, 0x98, 0x80]))
        .subList(toExpr(1), length: toExpr(2)),
    expected: Uint8List.fromList([0x9F, 0x98]),
  ),
  (
    name: 'Slice Emoji: Last byte of \u{1F600} [0x80]',
    expr: toExpr(Uint8List.fromList([0xF0, 0x9F, 0x98, 0x80]))
        .subList(toExpr(3), length: toExpr(1)),
    expected: Uint8List.fromList([0x80]),
  ),
  (
    name: 'Slice Invalid: Extract [0xFF] from [0x61, 0xFF, 0x62]',
    expr: toExpr(Uint8List.fromList([0x61, 0xFF, 0x62]))
        .subList(toExpr(1), length: toExpr(1)),
    expected: Uint8List.fromList([0xFF]),
  ),
  (
    name: 'Slice Null: Extract [0] from [1, 0, 2]',
    expr: toExpr(Uint8List.fromList([1, 0, 2]))
        .subList(toExpr(1), length: toExpr(1)),
    expected: Uint8List.fromList([0]),
  ),
  (
    name: 'Slice Empty: [1,2,3].subList(0, 0)',
    expr: toExpr(Uint8List.fromList([1, 2, 3]))
        .subList(toExpr(0), length: toExpr(0)),
    expected: Uint8List.fromList([]),
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

  for (final c in _casesToSkipMysql) {
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
    },
        skipMysql:
            'TODO: Fix binary handling in MySQL adapter, try new driver!');
  }

  r.run();
}
