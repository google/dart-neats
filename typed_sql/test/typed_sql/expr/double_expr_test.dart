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

final _cases = [
  // Test for .equals
  (
    name: '0.0.equals(0.0)',
    expr: toExpr(0.0).equals(toExpr(0.0)),
    expected: true,
  ),
  (
    name: '1.2.equals(1.5)',
    expr: toExpr(1.2).equals(toExpr(1.5)),
    expected: false,
  ),
  (
    name: '1.5.equals(1.2)',
    expr: toExpr(1.5).equals(toExpr(1.2)),
    expected: false,
  ),
  (
    name: '1.5.equals(1.5)',
    expr: toExpr(1.5).equals(toExpr(1.5)),
    expected: true,
  ),
  (
    name: '-1.5.equals(-1.5)',
    expr: toExpr(-1.5).equals(toExpr(-1.5)),
    expected: true,
  ),
  (
    name: '3.14.equals(3.14)',
    expr: toExpr(3.14).equals(toExpr(3.14)),
    expected: true,
  ),
  (
    name: '0.0.equals(null)',
    expr: toExpr(0.0).equals(toExpr(null)),
    expected: false,
  ),
  (
    name: '3.14.equals(null)',
    expr: toExpr(3.14).equals(toExpr(null)),
    expected: false,
  ),

  // Test for .equalsLiteral
  (
    name: '0.0.equalsLiteral(0.0)',
    expr: toExpr(0.0).equalsValue(0.0),
    expected: true,
  ),
  (
    name: '1.2.equalsLiteral(1.5)',
    expr: toExpr(1.2).equalsValue(1.5),
    expected: false,
  ),
  (
    name: '1.5.equalsLiteral(1.2)',
    expr: toExpr(1.5).equalsValue(1.2),
    expected: false,
  ),
  (
    name: '1.5.equalsLiteral(1.5)',
    expr: toExpr(1.5).equalsValue(1.5),
    expected: true,
  ),
  (
    name: '-1.5.equalsLiteral(-1.5)',
    expr: toExpr(-1.5).equalsValue(-1.5),
    expected: true,
  ),
  (
    name: '3.14.equalsLiteral(3.14)',
    expr: toExpr(3.14).equalsValue(3.14),
    expected: true,
  ),
  (
    name: '0.0.equalsLiteral(null)',
    expr: toExpr(0.0).equalsValue(null),
    expected: false,
  ),
  (
    name: '3.14.equalsLiteral(null)',
    expr: toExpr(3.14).equalsValue(null),
    expected: false,
  ),

  // Test for .notEquals
  (
    name: '0.0.notEquals(0.0)',
    expr: toExpr(0.0).notEquals(toExpr(0.0)),
    expected: false,
  ),
  (
    name: '1.2.notEquals(1.5)',
    expr: toExpr(1.2).notEquals(toExpr(1.5)),
    expected: true,
  ),
  (
    name: '1.5.notEquals(1.2)',
    expr: toExpr(1.5).notEquals(toExpr(1.2)),
    expected: true,
  ),
  (
    name: '1.5.notEquals(1.5)',
    expr: toExpr(1.5).notEquals(toExpr(1.5)),
    expected: false,
  ),
  (
    name: '-1.5.notEquals(-1.5)',
    expr: toExpr(-1.5).notEquals(toExpr(-1.5)),
    expected: false,
  ),
  (
    name: '3.14.notEquals(3.14)',
    expr: toExpr(3.14).notEquals(toExpr(3.14)),
    expected: false,
  ),
  (
    name: '0.0.notEquals(null)',
    expr: toExpr(0.0).notEquals(toExpr(null)),
    expected: true,
  ),
  (
    name: '3.14.notEquals(null)',
    expr: toExpr(3.14).notEquals(toExpr(null)),
    expected: true,
  ),

  // Test for .notEqualsLiteral
  (
    name: '0.0.notEqualsLiteral(0.0)',
    expr: toExpr(0.0).notEqualsValue(0.0),
    expected: false,
  ),
  (
    name: '1.2.notEqualsLiteral(1.5)',
    expr: toExpr(1.2).notEqualsValue(1.5),
    expected: true,
  ),
  (
    name: '1.5.notEqualsLiteral(1.2)',
    expr: toExpr(1.5).notEqualsValue(1.2),
    expected: true,
  ),
  (
    name: '1.5.notEqualsLiteral(1.5)',
    expr: toExpr(1.5).notEqualsValue(1.5),
    expected: false,
  ),
  (
    name: '-1.5.notEqualsLiteral(-1.5)',
    expr: toExpr(-1.5).notEqualsValue(-1.5),
    expected: false,
  ),
  (
    name: '3.14.notEqualsLiteral(3.14)',
    expr: toExpr(3.14).notEqualsValue(3.14),
    expected: false,
  ),
  (
    name: '0.0.notEqualsLiteral(null)',
    expr: toExpr(0.0).notEqualsValue(null),
    expected: true,
  ),
  (
    name: '3.14.notEqualsLiteral(null)',
    expr: toExpr(3.14).notEqualsValue(null),
    expected: true,
  ),

  // Test for .lessThan
  (
    name: '0.0.lessThan(0.0)',
    expr: toExpr(0.0).lessThan(toExpr(0.0)),
    expected: false,
  ),
  (
    name: '1.2.lessThan(1.5)',
    expr: toExpr(1.2).lessThan(toExpr(1.5)),
    expected: true,
  ),
  (
    name: '1.5.lessThan(1.2)',
    expr: toExpr(1.5).lessThan(toExpr(1.2)),
    expected: false,
  ),
  (
    name: '1.5.lessThan(1.5)',
    expr: toExpr(1.5).lessThan(toExpr(1.5)),
    expected: false,
  ),
  (
    name: '-1.5.lessThan(3.14)',
    expr: toExpr(-1.5).lessThan(toExpr(3.14)),
    expected: true,
  ),
  (
    name: '3.14.lessThan(3.14)',
    expr: toExpr(3.14).lessThan(toExpr(3.14)),
    expected: false,
  ),

  // Tests for .lessThanLiteral
  (
    name: '0.0.lessThanLiteral(0.0)',
    expr: toExpr(0.0).lessThanValue(0.0),
    expected: false,
  ),
  (
    name: '1.2.lessThanLiteral(1.5)',
    expr: toExpr(1.2).lessThanValue(1.5),
    expected: true,
  ),
  (
    name: '1.5.lessThanLiteral(1.2)',
    expr: toExpr(1.5).lessThanValue(1.2),
    expected: false,
  ),
  (
    name: '1.5.lessThanLiteral(1.5)',
    expr: toExpr(1.5).lessThanValue(1.5),
    expected: false,
  ),
  (
    name: '-1.5.lessThanLiteral(3.14)',
    expr: toExpr(-1.5).lessThanValue(3.14),
    expected: true,
  ),
  (
    name: '3.14.lessThanLiteral(3.14)',
    expr: toExpr(3.14).lessThanValue(3.14),
    expected: false,
  ),

  // Test for <
  (
    name: '0.0 < 0.0',
    expr: toExpr(0.0) < toExpr(0.0),
    expected: false,
  ),
  (
    name: '1.2 < 1.5',
    expr: toExpr(1.2) < toExpr(1.5),
    expected: true,
  ),
  (
    name: '1.5 < 1.2',
    expr: toExpr(1.5) < toExpr(1.2),
    expected: false,
  ),
  (
    name: '1.5 < 1.5',
    expr: toExpr(1.5) < toExpr(1.5),
    expected: false,
  ),
  (
    name: '-1.5 < 3.14',
    expr: toExpr(-1.5) < toExpr(3.14),
    expected: true,
  ),
  (
    name: '3.14 < 3.14',
    expr: toExpr(3.14) < toExpr(3.14),
    expected: false,
  ),

  // Test for .lessThanOrEqual
  (
    name: '0.0.lessThanOrEqual(0.0)',
    expr: toExpr(0.0).lessThanOrEqual(toExpr(0.0)),
    expected: true,
  ),
  (
    name: '1.2.lessThanOrEqual(1.5)',
    expr: toExpr(1.2).lessThanOrEqual(toExpr(1.5)),
    expected: true,
  ),
  (
    name: '1.5.lessThanOrEqual(1.2)',
    expr: toExpr(1.5).lessThanOrEqual(toExpr(1.2)),
    expected: false,
  ),
  (
    name: '1.5.lessThanOrEqual(1.5)',
    expr: toExpr(1.5).lessThanOrEqual(toExpr(1.5)),
    expected: true,
  ),
  (
    name: '-1.5.lessThanOrEqual(3.14)',
    expr: toExpr(-1.5).lessThanOrEqual(toExpr(3.14)),
    expected: true,
  ),
  (
    name: '3.14.lessThanOrEqual(3.14)',
    expr: toExpr(3.14).lessThanOrEqual(toExpr(3.14)),
    expected: true,
  ),

  // Tests for .lessThanOrEqualLiteral
  (
    name: '0.0.lessThanOrEqualLiteral(0.0)',
    expr: toExpr(0.0).lessThanOrEqualValue(0.0),
    expected: true,
  ),
  (
    name: '1.2.lessThanOrEqualLiteral(1.5)',
    expr: toExpr(1.2).lessThanOrEqualValue(1.5),
    expected: true,
  ),
  (
    name: '1.5.lessThanOrEqualLiteral(1.2)',
    expr: toExpr(1.5).lessThanOrEqualValue(1.2),
    expected: false,
  ),
  (
    name: '1.5.lessThanOrEqualLiteral(1.5)',
    expr: toExpr(1.5).lessThanOrEqualValue(1.5),
    expected: true,
  ),
  (
    name: '-1.5.lessThanOrEqualLiteral(3.14)',
    expr: toExpr(-1.5).lessThanOrEqualValue(3.14),
    expected: true,
  ),
  (
    name: '3.14.lessThanOrEqualLiteral(3.14)',
    expr: toExpr(3.14).lessThanOrEqualValue(3.14),
    expected: true,
  ),

  // Test for <=
  (
    name: '0.0 <= 0.0',
    expr: toExpr(0.0) <= toExpr(0.0),
    expected: true,
  ),
  (
    name: '1.2 <= 1.5',
    expr: toExpr(1.2) <= toExpr(1.5),
    expected: true,
  ),
  (
    name: '1.5 <= 1.2',
    expr: toExpr(1.5) <= toExpr(1.2),
    expected: false,
  ),
  (
    name: '1.5 <= 1.5',
    expr: toExpr(1.5) <= toExpr(1.5),
    expected: true,
  ),
  (
    name: '-1.5 <= 3.14',
    expr: toExpr(-1.5) <= toExpr(3.14),
    expected: true,
  ),
  (
    name: '3.14 <= 3.14',
    expr: toExpr(3.14) <= toExpr(3.14),
    expected: true,
  ),

  // Test for .greaterThan
  (
    name: '0.0.greaterThan(0.0)',
    expr: toExpr(0.0).greaterThan(toExpr(0.0)),
    expected: false,
  ),
  (
    name: '1.2.greaterThan(1.5)',
    expr: toExpr(1.2).greaterThan(toExpr(1.5)),
    expected: false,
  ),
  (
    name: '1.5.greaterThan(1.2)',
    expr: toExpr(1.5).greaterThan(toExpr(1.2)),
    expected: true,
  ),
  (
    name: '1.5.greaterThan(1.5)',
    expr: toExpr(1.5).greaterThan(toExpr(1.5)),
    expected: false,
  ),
  (
    name: '-1.5.greaterThan(3.14)',
    expr: toExpr(-1.5).greaterThan(toExpr(3.14)),
    expected: false,
  ),
  (
    name: '3.14.greaterThan(3.14)',
    expr: toExpr(3.14).greaterThan(toExpr(3.14)),
    expected: false,
  ),

  // Tests for .greaterThanLiteral
  (
    name: '0.0.greaterThanLiteral(0.0)',
    expr: toExpr(0.0).greaterThanValue(0.0),
    expected: false,
  ),
  (
    name: '1.2.greaterThanLiteral(1.5)',
    expr: toExpr(1.2).greaterThanValue(1.5),
    expected: false,
  ),
  (
    name: '1.5.greaterThanLiteral(1.2)',
    expr: toExpr(1.5).greaterThanValue(1.2),
    expected: true,
  ),
  (
    name: '1.5.greaterThanLiteral(1.5)',
    expr: toExpr(1.5).greaterThanValue(1.5),
    expected: false,
  ),
  (
    name: '-1.5.greaterThanLiteral(3.14)',
    expr: toExpr(-1.5).greaterThanValue(3.14),
    expected: false,
  ),
  (
    name: '3.14.greaterThanLiteral(3.14)',
    expr: toExpr(3.14).greaterThanValue(3.14),
    expected: false,
  ),

  // Test for >
  (
    name: '0.0 > 0.0',
    expr: toExpr(0.0) > toExpr(0.0),
    expected: false,
  ),
  (
    name: '1.2 > 1.5',
    expr: toExpr(1.2) > toExpr(1.5),
    expected: false,
  ),
  (
    name: '1.5 > 1.2',
    expr: toExpr(1.5) > toExpr(1.2),
    expected: true,
  ),
  (
    name: '1.5 > 1.5',
    expr: toExpr(1.5) > toExpr(1.5),
    expected: false,
  ),
  (
    name: '-1.5 > 3.14',
    expr: toExpr(-1.5) > toExpr(3.14),
    expected: false,
  ),
  (
    name: '3.14 > 3.14',
    expr: toExpr(3.14) > toExpr(3.14),
    expected: false,
  ),

  // Test for .greaterThanOrEqual
  (
    name: '0.0.greaterThanOrEqual(0.0)',
    expr: toExpr(0.0).greaterThanOrEqual(toExpr(0.0)),
    expected: true,
  ),
  (
    name: '1.2.greaterThanOrEqual(1.5)',
    expr: toExpr(1.2).greaterThanOrEqual(toExpr(1.5)),
    expected: false,
  ),
  (
    name: '1.5.greaterThanOrEqual(1.2)',
    expr: toExpr(1.5).greaterThanOrEqual(toExpr(1.2)),
    expected: true,
  ),
  (
    name: '1.5.greaterThanOrEqual(1.5)',
    expr: toExpr(1.5).greaterThanOrEqual(toExpr(1.5)),
    expected: true,
  ),
  (
    name: '-1.5.greaterThanOrEqual(3.14)',
    expr: toExpr(-1.5).greaterThanOrEqual(toExpr(3.14)),
    expected: false,
  ),
  (
    name: '3.14.greaterThanOrEqual(3.14)',
    expr: toExpr(3.14).greaterThanOrEqual(toExpr(3.14)),
    expected: true,
  ),

  // Tests for .greaterThanOrEqualLiteral
  (
    name: '0.0.greaterThanOrEqualLiteral(0.0)',
    expr: toExpr(0.0).greaterThanOrEqualValue(0.0),
    expected: true,
  ),
  (
    name: '1.2.greaterThanOrEqualLiteral(1.5)',
    expr: toExpr(1.2).greaterThanOrEqualValue(1.5),
    expected: false,
  ),
  (
    name: '1.5.greaterThanOrEqualLiteral(1.2)',
    expr: toExpr(1.5).greaterThanOrEqualValue(1.2),
    expected: true,
  ),
  (
    name: '1.5.greaterThanOrEqualLiteral(1.5)',
    expr: toExpr(1.5).greaterThanOrEqualValue(1.5),
    expected: true,
  ),
  (
    name: '-1.5.greaterThanOrEqualLiteral(3.14)',
    expr: toExpr(-1.5).greaterThanOrEqualValue(3.14),
    expected: false,
  ),
  (
    name: '3.14.greaterThanOrEqualLiteral(3.14)',
    expr: toExpr(3.14).greaterThanOrEqualValue(3.14),
    expected: true,
  ),

  // Test for >=
  (
    name: '0.0 >= 0.0',
    expr: toExpr(0.0) >= toExpr(0.0),
    expected: true,
  ),
  (
    name: '1.2 >= 1.5',
    expr: toExpr(1.2) >= toExpr(1.5),
    expected: false,
  ),
  (
    name: '1.5 >= 1.2',
    expr: toExpr(1.5) >= toExpr(1.2),
    expected: true,
  ),
  (
    name: '1.5 >= 1.5',
    expr: toExpr(1.5) >= toExpr(1.5),
    expected: true,
  ),
  (
    name: '-1.5 >= 3.14',
    expr: toExpr(-1.5) >= toExpr(3.14),
    expected: false,
  ),
  (
    name: '3.14 >= 3.14',
    expr: toExpr(3.14) >= toExpr(3.14),
    expected: true,
  ),
];

final _closeCases = [
  // Test for +
  (
    name: '0.0 + 0.0',
    expr: toExpr(0.0) + toExpr(0.0),
    expected: 0.0,
  ),
  (
    name: '0.0 + 1.0',
    expr: toExpr(0.0) + toExpr(1.0),
    expected: 1.0,
  ),
  (
    name: '1.0 + 0.0',
    expr: toExpr(1.0) + toExpr(0.0),
    expected: 1.0,
  ),
  (
    name: '1.5 + 1.2',
    expr: toExpr(1.5) + toExpr(1.2),
    expected: 2.7,
  ),
  (
    name: '-1.0 + -1.0',
    expr: toExpr(-1.0) + toExpr(-1.0),
    expected: -2.0,
  ),
  (
    name: '3.14 + 3.14',
    expr: toExpr(3.14) + toExpr(3.14),
    expected: 6.28,
  ),

  // Test for -
  (
    name: '0.0 - 0.0',
    expr: toExpr(0.0) - toExpr(0.0),
    expected: 0.0,
  ),
  (
    name: '0.0 - 1.0',
    expr: toExpr(0.0) - toExpr(1.0),
    expected: -1.0,
  ),
  (
    name: '1.0 - 0.0',
    expr: toExpr(1.0) - toExpr(0.0),
    expected: 1.0,
  ),
  (
    name: '1.5 - 1.2',
    expr: toExpr(1.5) - toExpr(1.2),
    expected: 0.3,
  ),
  (
    name: '-1.0 - -1.0',
    expr: toExpr(-1.0) - toExpr(-1.0),
    expected: 0.0,
  ),
  (
    name: '3.14 - 3.14',
    expr: toExpr(3.14) - toExpr(3.14),
    expected: 0.0,
  ),

  // Test for *
  (
    name: '0.0 * 0.0',
    expr: toExpr(0.0) * toExpr(0.0),
    expected: 0.0,
  ),
  (
    name: '0.0 * 1.0',
    expr: toExpr(0.0) * toExpr(1.0),
    expected: 0.0,
  ),
  (
    name: '1.0 * 0.0',
    expr: toExpr(1.0) * toExpr(0.0),
    expected: 0.0,
  ),
  (
    name: '1.5 * 1.2',
    expr: toExpr(1.5) * toExpr(1.2),
    expected: 1.8,
  ),
  (
    name: '-1.0 * -1.0',
    expr: toExpr(-1.0) * toExpr(-1.0),
    expected: 1.0,
  ),
  (
    name: '3.14 * 3.14',
    expr: toExpr(3.14) * toExpr(3.14),
    expected: 9.8596,
  ),

  // Test for /
  (
    name: '0.0 / 1.0',
    expr: toExpr(0.0) / toExpr(1.0),
    expected: 0.0,
  ),
  (
    name: '1.0 / 1.0',
    expr: toExpr(1.0) / toExpr(1.0),
    expected: 1.0,
  ),
  (
    name: '-1.0 / -1.0',
    expr: toExpr(-1.0) / toExpr(-1.0),
    expected: 1.0,
  ),
  (
    name: '3.14 / 3.14',
    expr: toExpr(3.14) / toExpr(3.14),
    expected: 1.0,
  ),
  (
    name: '3.14 / 2.0',
    expr: toExpr(3.14) / toExpr(2.0),
    expected: 1.57,
  ),
  (
    name: '3.15 / 2.0',
    expr: toExpr(3.15) / toExpr(2.0),
    expected: 1.575,
  ),

  // Tests for .add
  (
    name: '0.0.add(0.0)',
    expr: toExpr(0.0).add(toExpr(0.0)),
    expected: 0.0,
  ),
  (
    name: '0.0.add(1.0)',
    expr: toExpr(0.0).add(toExpr(1.0)),
    expected: 1.0,
  ),
  (
    name: '1.0.add(0.0)',
    expr: toExpr(1.0).add(toExpr(0.0)),
    expected: 1.0,
  ),
  (
    name: '1.5.add(1.2)',
    expr: toExpr(1.5).add(toExpr(1.2)),
    expected: 2.7,
  ),
  (
    name: '-1.0.add(-1.0)',
    expr: toExpr(-1.0).add(toExpr(-1.0)),
    expected: -2.0,
  ),
  (
    name: '3.14.add(3.14)',
    expr: toExpr(3.14).add(toExpr(3.14)),
    expected: 6.28,
  ),

  // Tests for .addLiteral
  (
    name: '0.0.addLiteral(0.0)',
    expr: toExpr(0.0).addValue(0.0),
    expected: 0.0,
  ),
  (
    name: '0.0.addLiteral(1.0)',
    expr: toExpr(0.0).addValue(1.0),
    expected: 1.0,
  ),
  (
    name: '1.0.addLiteral(0.0)',
    expr: toExpr(1.0).addValue(0.0),
    expected: 1.0,
  ),
  (
    name: '1.5.addLiteral(1.2)',
    expr: toExpr(1.5).addValue(1.2),
    expected: 2.7,
  ),
  (
    name: '-1.0.addLiteral(-1.0)',
    expr: toExpr(-1.0).addValue(-1.0),
    expected: -2.0,
  ),
  (
    name: '3.14.addLiteral(3.14)',
    expr: toExpr(3.14).addValue(3.14),
    expected: 6.28,
  ),

  // Tests for .subtract
  (
    name: '0.0.subtract(0.0)',
    expr: toExpr(0.0).subtract(toExpr(0.0)),
    expected: 0.0,
  ),
  (
    name: '0.0.subtract(1.0)',
    expr: toExpr(0.0).subtract(toExpr(1.0)),
    expected: -1.0,
  ),
  (
    name: '1.0.subtract(0.0)',
    expr: toExpr(1.0).subtract(toExpr(0.0)),
    expected: 1.0,
  ),
  (
    name: '1.5.subtract(1.2)',
    expr: toExpr(1.5).subtract(toExpr(1.2)),
    expected: 0.3,
  ),
  (
    name: '-1.0.subtract(-1.0)',
    expr: toExpr(-1.0).subtract(toExpr(-1.0)),
    expected: 0.0,
  ),
  (
    name: '3.14.subtract(3.14)',
    expr: toExpr(3.14).subtract(toExpr(3.14)),
    expected: 0.0,
  ),

  // Tests for .subtractLiteral
  (
    name: '0.0.subtractLiteral(0.0)',
    expr: toExpr(0.0).subtractValue(0.0),
    expected: 0.0,
  ),
  (
    name: '0.0.subtractLiteral(1.0)',
    expr: toExpr(0.0).subtractValue(1.0),
    expected: -1.0,
  ),
  (
    name: '1.0.subtractLiteral(0.0)',
    expr: toExpr(1.0).subtractValue(0.0),
    expected: 1.0,
  ),
  (
    name: '1.5.subtractLiteral(1.2)',
    expr: toExpr(1.5).subtractValue(1.2),
    expected: 0.3,
  ),
  (
    name: '-1.0.subtractLiteral(-1.0)',
    expr: toExpr(-1.0).subtractValue(-1.0),
    expected: 0.0,
  ),
  (
    name: '3.14.subtractLiteral(3.14)',
    expr: toExpr(3.14).subtractValue(3.14),
    expected: 0.0,
  ),

  // Tests for .multiply
  (
    name: '0.0.multiply(0.0)',
    expr: toExpr(0.0).multiply(toExpr(0.0)),
    expected: 0.0,
  ),
  (
    name: '0.0.multiply(1.0)',
    expr: toExpr(0.0).multiply(toExpr(1.0)),
    expected: 0.0,
  ),
  (
    name: '1.0.multiply(0.0)',
    expr: toExpr(1.0).multiply(toExpr(0.0)),
    expected: 0.0,
  ),
  (
    name: '1.5.multiply(1.2)',
    expr: toExpr(1.5).multiply(toExpr(1.2)),
    expected: 1.8,
  ),
  (
    name: '-1.0.multiply(-1.0)',
    expr: toExpr(-1.0).multiply(toExpr(-1.0)),
    expected: 1.0,
  ),
  (
    name: '3.14.multiply(3.14)',
    expr: toExpr(3.14).multiply(toExpr(3.14)),
    expected: 9.8596,
  ),

  // Tests for .multiplyLiteral
  (
    name: '0.0.multiplyLiteral(0.0)',
    expr: toExpr(0.0).multiplyValue(0.0),
    expected: 0.0,
  ),
  (
    name: '0.0.multiplyLiteral(1.0)',
    expr: toExpr(0.0).multiplyValue(1.0),
    expected: 0.0,
  ),
  (
    name: '1.0.multiplyLiteral(0.0)',
    expr: toExpr(1.0).multiplyValue(0.0),
    expected: 0.0,
  ),
  (
    name: '1.5.multiplyLiteral(1.2)',
    expr: toExpr(1.5).multiplyValue(1.2),
    expected: 1.8,
  ),
  (
    name: '-1.0.multiplyLiteral(-1.0)',
    expr: toExpr(-1.0).multiplyValue(-1.0),
    expected: 1.0,
  ),
  (
    name: '3.14.multiplyLiteral(3.14)',
    expr: toExpr(3.14).multiplyValue(3.14),
    expected: 9.8596,
  ),

  // Tests for .divide
  (
    name: '0.0.divide(1.0)',
    expr: toExpr(0.0).divide(toExpr(1.0)),
    expected: 0.0,
  ),
  (
    name: '1.0.divide(1.0)',
    expr: toExpr(1.0).divide(toExpr(1.0)),
    expected: 1.0,
  ),
  (
    name: '-1.0.divide(-1.0)',
    expr: toExpr(-1.0).divide(toExpr(-1.0)),
    expected: 1.0,
  ),
  (
    name: '3.14.divide(3.14)',
    expr: toExpr(3.14).divide(toExpr(3.14)),
    expected: 1.0,
  ),
  (
    name: '3.14.divide(2.0)',
    expr: toExpr(3.14).divide(toExpr(2.0)),
    expected: 1.57,
  ),
  (
    name: '3.15.divide(2.0)',
    expr: toExpr(3.15).divide(toExpr(2.0)),
    expected: 1.575,
  ),

  // Tests for .divideLiteral
  (
    name: '0.0.divideLiteral(1.0)',
    expr: toExpr(0.0).divideValue(1.0),
    expected: 0.0,
  ),
  (
    name: '1.0.divideLiteral(1.0)',
    expr: toExpr(1.0).divideValue(1.0),
    expected: 1.0,
  ),
  (
    name: '-1.0.divideLiteral(-1.0)',
    expr: toExpr(-1.0).divideValue(-1.0),
    expected: 1.0,
  ),
  (
    name: '3.14.divideLiteral(3.14)',
    expr: toExpr(3.14).divideValue(3.14),
    expected: 1.0,
  ),
  (
    name: '3.14.divideLiteral(2.0)',
    expr: toExpr(3.14).divideValue(2.0),
    expected: 1.57,
  ),
  (
    name: '3.15.divideLiteral(2.0)',
    expr: toExpr(3.15).divideValue(2.0),
    expected: 1.575,
  ),
];

final _oneOfCases = [
  // Tests for asString()
  (
    name: '3.14.asString()',
    expr: toExpr(3.14).asString(),
    expected: ['3.14'],
  ),
  (
    name: '0.0.asString()',
    expr: toExpr(0.0).asString(),
    expected: ['0', '0.0'],
  ),
  (
    name: '-1.5.asString()',
    expr: toExpr(-1.5).asString(),
    expected: ['-1.5'],
  ),
  (
    name: '1.0.asString()',
    expr: toExpr(1.0).asString(),
    expected: ['1', '1.0'],
  ),
  (
    name: '1.5.asString()',
    expr: toExpr(1.5).asString(),
    expected: ['1.5'],
  ),
  (
    name: '-1.0.asString()',
    expr: toExpr(-1.0).asString(),
    expected: ['-1', '-1.0'],
  ),

  // Tests for asInt()
  (
    name: '3.14.asInt()',
    expr: toExpr(3.14).asInt(),
    expected: [3],
  ),
  (
    name: '0.0.asInt()',
    expr: toExpr(0.0).asInt(),
    expected: [0],
  ),
  (
    name: '-1.5.asInt()',
    expr: toExpr(-1.5).asInt(),
    expected: [-1, -2],
  ),
  (
    name: '1.0.asInt()',
    expr: toExpr(1.0).asInt(),
    expected: [1],
  ),
  (
    name: '1.5.asInt()',
    expr: toExpr(1.5).asInt(),
    expected: [1, 2],
  ),
  (
    name: '-1.0.asInt()',
    expr: toExpr(-1.0).asInt(),
    expected: [-1],
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

  for (final c in _closeCases) {
    r.addTest(c.name, (db) async {
      final result = await db.select(
        (c.expr,),
      ).fetch();
      check(result).isNotNull().isCloseTo(c.expected, 0.00000000000001);
    });
  }

  for (final c in _oneOfCases) {
    r.addTest(c.name, (db) async {
      final result = await db.select(
        (c.expr,),
      ).fetch();
      check(result)
          .isNotNull()
          .anyOf(c.expected.map((v) => (l) => l.equals(v)));
    });
  }

  r.run();
}
