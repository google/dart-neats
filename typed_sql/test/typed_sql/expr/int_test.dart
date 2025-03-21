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
    name: '0.equals(0)',
    expr: literal(0).equals(literal(0)),
    expected: true,
  ),
  (
    name: '0.equals(1)',
    expr: literal(0).equals(literal(1)),
    expected: false,
  ),
  (
    name: '1.equals(0)',
    expr: literal(1).equals(literal(0)),
    expected: false,
  ),
  (
    name: '1.equals(1)',
    expr: literal(1).equals(literal(1)),
    expected: true,
  ),
  (
    name: '-1.equals(-1)',
    expr: literal(-1).equals(literal(-1)),
    expected: true,
  ),
  (
    name: '42.equals(42)',
    expr: literal(42).equals(literal(42)),
    expected: true,
  ),
  (
    name: '0.equals(null)',
    expr: literal(0).equals(literal(null)),
    expected: false,
  ),
  (
    name: '42.equals(null)',
    expr: literal(42).equals(literal(null)),
    expected: false,
  ),

  // Test for .equalsLiteral
  (
    name: '0.equalsLiteral(0)',
    expr: literal(0).equalsLiteral(0),
    expected: true,
  ),
  (
    name: '0.equalsLiteral(1)',
    expr: literal(0).equalsLiteral(1),
    expected: false,
  ),
  (
    name: '1.equalsLiteral(0)',
    expr: literal(1).equalsLiteral(0),
    expected: false,
  ),
  (
    name: '1.equalsLiteral(1)',
    expr: literal(1).equalsLiteral(1),
    expected: true,
  ),
  (
    name: '-1.equalsLiteral(-1)',
    expr: literal(-1).equalsLiteral(-1),
    expected: true,
  ),
  (
    name: '42.equalsLiteral(42)',
    expr: literal(42).equalsLiteral(42),
    expected: true,
  ),
  (
    name: '0.equalsLiteral(null)',
    expr: literal(0).equalsLiteral(null),
    expected: false,
  ),
  (
    name: '42.equalsLiteral(null)',
    expr: literal(42).equalsLiteral(null),
    expected: false,
  ),

  // Test for .notEquals
  (
    name: '0.notEquals(0)',
    expr: literal(0).notEquals(literal(0)),
    expected: false,
  ),
  (
    name: '0.notEquals(1)',
    expr: literal(0).notEquals(literal(1)),
    expected: true,
  ),
  (
    name: '1.notEquals(0)',
    expr: literal(1).notEquals(literal(0)),
    expected: true,
  ),
  (
    name: '1.notEquals(1)',
    expr: literal(1).notEquals(literal(1)),
    expected: false,
  ),
  (
    name: '-1.notEquals(-1)',
    expr: literal(-1).notEquals(literal(-1)),
    expected: false,
  ),
  (
    name: '42.notEquals(42)',
    expr: literal(42).notEquals(literal(42)),
    expected: false,
  ),
  (
    name: '0.notEquals(null)',
    expr: literal(0).notEquals(literal(null)),
    expected: true,
  ),
  (
    name: '42.notEquals(null)',
    expr: literal(42).notEquals(literal(null)),
    expected: true,
  ),

  // Test for .notEqualsLiteral
  (
    name: '0.notEqualsLiteral(0)',
    expr: literal(0).notEqualsLiteral(0),
    expected: false,
  ),
  (
    name: '0.notEqualsLiteral(1)',
    expr: literal(0).notEqualsLiteral(1),
    expected: true,
  ),
  (
    name: '1.notEqualsLiteral(0)',
    expr: literal(1).notEqualsLiteral(0),
    expected: true,
  ),
  (
    name: '1.notEqualsLiteral(1)',
    expr: literal(1).notEqualsLiteral(1),
    expected: false,
  ),
  (
    name: '-1.notEqualsLiteral(-1)',
    expr: literal(-1).notEqualsLiteral(-1),
    expected: false,
  ),
  (
    name: '42.notEqualsLiteral(42)',
    expr: literal(42).notEqualsLiteral(42),
    expected: false,
  ),
  (
    name: '0.notEqualsLiteral(null)',
    expr: literal(0).notEqualsLiteral(null),
    expected: true,
  ),
  (
    name: '42.notEqualsLiteral(null)',
    expr: literal(42).notEqualsLiteral(null),
    expected: true,
  ),

  // Test for +
  (
    name: '0 + 0',
    expr: literal(0) + literal(0),
    expected: 0,
  ),
  (
    name: '0 + 1',
    expr: literal(0) + literal(1),
    expected: 1,
  ),
  (
    name: '1 + 0',
    expr: literal(1) + literal(0),
    expected: 1,
  ),
  (
    name: '1 + 1',
    expr: literal(1) + literal(1),
    expected: 2,
  ),
  (
    name: '-1 + -1',
    expr: literal(-1) + literal(-1),
    expected: -2,
  ),
  (
    name: '42 + 42',
    expr: literal(42) + literal(42),
    expected: 84,
  ),

  // Test for -
  (
    name: '0 - 0',
    expr: literal(0) - literal(0),
    expected: 0,
  ),
  (
    name: '0 - 1',
    expr: literal(0) - literal(1),
    expected: -1,
  ),
  (
    name: '1 - 0',
    expr: literal(1) - literal(0),
    expected: 1,
  ),
  (
    name: '1 - 1',
    expr: literal(1) - literal(1),
    expected: 0,
  ),
  (
    name: '-1 - -1',
    expr: literal(-1) - literal(-1),
    expected: 0,
  ),
  (
    name: '42 - 42',
    expr: literal(42) - literal(42),
    expected: 0,
  ),

  // Test for *
  (
    name: '0 * 0',
    expr: literal(0) * literal(0),
    expected: 0,
  ),
  (
    name: '0 * 1',
    expr: literal(0) * literal(1),
    expected: 0,
  ),
  (
    name: '1 * 0',
    expr: literal(1) * literal(0),
    expected: 0,
  ),
  (
    name: '1 * 1',
    expr: literal(1) * literal(1),
    expected: 1,
  ),
  (
    name: '-1 * -1',
    expr: literal(-1) * literal(-1),
    expected: 1,
  ),
  (
    name: '42 * 42',
    expr: literal(42) * literal(42),
    expected: 1764,
  ),

  // Test for /
  (
    name: '0 / 1',
    expr: literal(0) / literal(1),
    expected: 0,
  ),
  (
    name: '1 / 1',
    expr: literal(1) / literal(1),
    expected: 1,
  ),
  (
    name: '-1 / -1',
    expr: literal(-1) / literal(-1),
    expected: 1,
  ),
  (
    name: '42 / 42',
    expr: literal(42) / literal(42),
    expected: 1,
  ),
  (
    name: '42 / 2',
    expr: literal(42) / literal(2),
    expected: 21,
  ),
  (
    name: '41 / 2',
    expr: literal(41) / literal(2),
    expected: 20.5,
  ),

  // Tests for .add
  (
    name: '0.add(0)',
    expr: literal(0).add(literal(0)),
    expected: 0,
  ),
  (
    name: '0.add(1)',
    expr: literal(0).add(literal(1)),
    expected: 1,
  ),
  (
    name: '1.add(0)',
    expr: literal(1).add(literal(0)),
    expected: 1,
  ),
  (
    name: '1.add(1)',
    expr: literal(1).add(literal(1)),
    expected: 2,
  ),
  (
    name: '-1.add(-1)',
    expr: literal(-1).add(literal(-1)),
    expected: -2,
  ),
  (
    name: '42.add(42)',
    expr: literal(42).add(literal(42)),
    expected: 84,
  ),

  // Tests for .addLiteral
  (
    name: '0.addLiteral(0)',
    expr: literal(0).addLiteral(0),
    expected: 0,
  ),
  (
    name: '0.addLiteral(1)',
    expr: literal(0).addLiteral(1),
    expected: 1,
  ),
  (
    name: '1.addLiteral(0)',
    expr: literal(1).addLiteral(0),
    expected: 1,
  ),
  (
    name: '1.addLiteral(1)',
    expr: literal(1).addLiteral(1),
    expected: 2,
  ),
  (
    name: '-1.addLiteral(-1)',
    expr: literal(-1).addLiteral(-1),
    expected: -2,
  ),
  (
    name: '42.addLiteral(42)',
    expr: literal(42).addLiteral(42),
    expected: 84,
  ),

  // Tests for .subtract
  (
    name: '0.subtract(0)',
    expr: literal(0).subtract(literal(0)),
    expected: 0,
  ),
  (
    name: '0.subtract(1)',
    expr: literal(0).subtract(literal(1)),
    expected: -1,
  ),
  (
    name: '1.subtract(0)',
    expr: literal(1).subtract(literal(0)),
    expected: 1,
  ),
  (
    name: '1.subtract(1)',
    expr: literal(1).subtract(literal(1)),
    expected: 0,
  ),
  (
    name: '-1.subtract(-1)',
    expr: literal(-1).subtract(literal(-1)),
    expected: 0,
  ),
  (
    name: '42.subtract(42)',
    expr: literal(42).subtract(literal(42)),
    expected: 0,
  ),

  // Tests for .subtractLiteral
  (
    name: '0.subtractLiteral(0)',
    expr: literal(0).subtractLiteral(0),
    expected: 0,
  ),
  (
    name: '0.subtractLiteral(1)',
    expr: literal(0).subtractLiteral(1),
    expected: -1,
  ),
  (
    name: '1.subtractLiteral(0)',
    expr: literal(1).subtractLiteral(0),
    expected: 1,
  ),
  (
    name: '1.subtractLiteral(1)',
    expr: literal(1).subtractLiteral(1),
    expected: 0,
  ),
  (
    name: '-1.subtractLiteral(-1)',
    expr: literal(-1).subtractLiteral(-1),
    expected: 0,
  ),
  (
    name: '42.subtractLiteral(42)',
    expr: literal(42).subtractLiteral(42),
    expected: 0,
  ),

  // Tests for .multiply
  (
    name: '0.multiply(0)',
    expr: literal(0).multiply(literal(0)),
    expected: 0,
  ),
  (
    name: '0.multiply(1)',
    expr: literal(0).multiply(literal(1)),
    expected: 0,
  ),
  (
    name: '1.multiply(0)',
    expr: literal(1).multiply(literal(0)),
    expected: 0,
  ),
  (
    name: '1.multiply(1)',
    expr: literal(1).multiply(literal(1)),
    expected: 1,
  ),
  (
    name: '-1.multiply(-1)',
    expr: literal(-1).multiply(literal(-1)),
    expected: 1,
  ),
  (
    name: '42.multiply(42)',
    expr: literal(42).multiply(literal(42)),
    expected: 1764,
  ),

  // Tests for .multiplyLiteral
  (
    name: '0.multiplyLiteral(0)',
    expr: literal(0).multiplyLiteral(0),
    expected: 0,
  ),
  (
    name: '0.multiplyLiteral(1)',
    expr: literal(0).multiplyLiteral(1),
    expected: 0,
  ),
  (
    name: '1.multiplyLiteral(0)',
    expr: literal(1).multiplyLiteral(0),
    expected: 0,
  ),
  (
    name: '1.multiplyLiteral(1)',
    expr: literal(1).multiplyLiteral(1),
    expected: 1,
  ),
  (
    name: '-1.multiplyLiteral(-1)',
    expr: literal(-1).multiplyLiteral(-1),
    expected: 1,
  ),
  (
    name: '42.multiplyLiteral(42)',
    expr: literal(42).multiplyLiteral(42),
    expected: 1764,
  ),

  // Tests for .divide
  (
    name: '0.divide(1)',
    expr: literal(0).divide(literal(1)),
    expected: 0,
  ),
  (
    name: '1.divide(1)',
    expr: literal(1).divide(literal(1)),
    expected: 1,
  ),
  (
    name: '-1.divide(-1)',
    expr: literal(-1).divide(literal(-1)),
    expected: 1,
  ),
  (
    name: '42.divide(42)',
    expr: literal(42).divide(literal(42)),
    expected: 1,
  ),
  (
    name: '42.divide(2)',
    expr: literal(42).divide(literal(2)),
    expected: 21,
  ),
  (
    name: '41.divide(2)',
    expr: literal(41).divide(literal(2)),
    expected: 20.5,
  ),

  // Tests for .divideLiteral
  (
    name: '0.divideLiteral(1)',
    expr: literal(0).divideLiteral(1),
    expected: 0,
  ),
  (
    name: '1.divideLiteral(1)',
    expr: literal(1).divideLiteral(1),
    expected: 1,
  ),
  (
    name: '-1.divideLiteral(-1)',
    expr: literal(-1).divideLiteral(-1),
    expected: 1,
  ),
  (
    name: '42.divideLiteral(42)',
    expr: literal(42).divideLiteral(42),
    expected: 1,
  ),
  (
    name: '42.divideLiteral(2)',
    expr: literal(42).divideLiteral(2),
    expected: 21,
  ),
  (
    name: '41.divideLiteral(2)',
    expr: literal(41).divideLiteral(2),
    expected: 20.5,
  ),

  // Test for .lessThan
  (
    name: '0.lessThan(0)',
    expr: literal(0).lessThan(literal(0)),
    expected: false,
  ),
  (
    name: '0.lessThan(1)',
    expr: literal(0).lessThan(literal(1)),
    expected: true,
  ),
  (
    name: '1.lessThan(0)',
    expr: literal(1).lessThan(literal(0)),
    expected: false,
  ),
  (
    name: '1.lessThan(1)',
    expr: literal(1).lessThan(literal(1)),
    expected: false,
  ),
  (
    name: '-1.lessThan(-1)',
    expr: literal(-1).lessThan(literal(-1)),
    expected: false,
  ),
  (
    name: '-1.lessThan(0)',
    expr: literal(-1).lessThan(literal(0)),
    expected: true,
  ),
  (
    name: '0.lessThan(-1)',
    expr: literal(0).lessThan(literal(-1)),
    expected: false,
  ),
  (
    name: '42.lessThan(42)',
    expr: literal(42).lessThan(literal(42)),
    expected: false,
  ),

  // Tests for .lessThanLiteral
  (
    name: '0.lessThanLiteral(0)',
    expr: literal(0).lessThanLiteral(0),
    expected: false,
  ),
  (
    name: '0.lessThanLiteral(1)',
    expr: literal(0).lessThanLiteral(1),
    expected: true,
  ),
  (
    name: '1.lessThanLiteral(0)',
    expr: literal(1).lessThanLiteral(0),
    expected: false,
  ),
  (
    name: '1.lessThanLiteral(1)',
    expr: literal(1).lessThanLiteral(1),
    expected: false,
  ),
  (
    name: '-1.lessThanLiteral(-1)',
    expr: literal(-1).lessThanLiteral(-1),
    expected: false,
  ),
  (
    name: '-1.lessThanLiteral(0)',
    expr: literal(-1).lessThanLiteral(0),
    expected: true,
  ),
  (
    name: '0.lessThanLiteral(-1)',
    expr: literal(0).lessThanLiteral(-1),
    expected: false,
  ),
  (
    name: '42.lessThanLiteral(42)',
    expr: literal(42).lessThanLiteral(42),
    expected: false,
  ),

  // Test for <
  (
    name: '0 < 0',
    expr: literal(0) < literal(0),
    expected: false,
  ),
  (
    name: '0 < 1',
    expr: literal(0) < literal(1),
    expected: true,
  ),
  (
    name: '1 < 0',
    expr: literal(1) < literal(0),
    expected: false,
  ),
  (
    name: '1 < 1',
    expr: literal(1) < literal(1),
    expected: false,
  ),
  (
    name: '-1 < -1',
    expr: literal(-1) < literal(-1),
    expected: false,
  ),
  (
    name: '-1 < 0',
    expr: literal(-1) < literal(0),
    expected: true,
  ),
  (
    name: '0 < -1',
    expr: literal(0) < literal(-1),
    expected: false,
  ),
  (
    name: '42 < 42',
    expr: literal(42) < literal(42),
    expected: false,
  ),

  // Test for .lessThanOrEqual
  (
    name: '0.lessThanOrEqual(0)',
    expr: literal(0).lessThanOrEqual(literal(0)),
    expected: true,
  ),
  (
    name: '0.lessThanOrEqual(1)',
    expr: literal(0).lessThanOrEqual(literal(1)),
    expected: true,
  ),
  (
    name: '1.lessThanOrEqual(0)',
    expr: literal(1).lessThanOrEqual(literal(0)),
    expected: false,
  ),
  (
    name: '1.lessThanOrEqual(1)',
    expr: literal(1).lessThanOrEqual(literal(1)),
    expected: true,
  ),
  (
    name: '-1.lessThanOrEqual(-1)',
    expr: literal(-1).lessThanOrEqual(literal(-1)),
    expected: true,
  ),
  (
    name: '-1.lessThanOrEqual(0)',
    expr: literal(-1).lessThanOrEqual(literal(0)),
    expected: true,
  ),
  (
    name: '0.lessThanOrEqual(-1)',
    expr: literal(0).lessThanOrEqual(literal(-1)),
    expected: false,
  ),
  (
    name: '42.lessThanOrEqual(42)',
    expr: literal(42).lessThanOrEqual(literal(42)),
    expected: true,
  ),

  // Tests for .lessThanOrEqualLiteral
  (
    name: '0.lessThanOrEqualLiteral(0)',
    expr: literal(0).lessThanOrEqualLiteral(0),
    expected: true,
  ),
  (
    name: '0.lessThanOrEqualLiteral(1)',
    expr: literal(0).lessThanOrEqualLiteral(1),
    expected: true,
  ),
  (
    name: '1.lessThanOrEqualLiteral(0)',
    expr: literal(1).lessThanOrEqualLiteral(0),
    expected: false,
  ),
  (
    name: '1.lessThanOrEqualLiteral(1)',
    expr: literal(1).lessThanOrEqualLiteral(1),
    expected: true,
  ),
  (
    name: '-1.lessThanOrEqualLiteral(-1)',
    expr: literal(-1).lessThanOrEqualLiteral(-1),
    expected: true,
  ),
  (
    name: '-1.lessThanOrEqualLiteral(0)',
    expr: literal(-1).lessThanOrEqualLiteral(0),
    expected: true,
  ),
  (
    name: '0.lessThanOrEqualLiteral(-1)',
    expr: literal(0).lessThanOrEqualLiteral(-1),
    expected: false,
  ),
  (
    name: '42.lessThanOrEqualLiteral(42)',
    expr: literal(42).lessThanOrEqualLiteral(42),
    expected: true,
  ),

  // Test for <=
  (
    name: '0 <= 0',
    expr: literal(0) <= literal(0),
    expected: true,
  ),
  (
    name: '0 <= 1',
    expr: literal(0) <= literal(1),
    expected: true,
  ),
  (
    name: '1 <= 0',
    expr: literal(1) <= literal(0),
    expected: false,
  ),
  (
    name: '1 <= 1',
    expr: literal(1) <= literal(1),
    expected: true,
  ),
  (
    name: '-1 <= -1',
    expr: literal(-1) <= literal(-1),
    expected: true,
  ),
  (
    name: '-1 <= 0',
    expr: literal(-1) <= literal(0),
    expected: true,
  ),
  (
    name: '0 <= -1',
    expr: literal(0) <= literal(-1),
    expected: false,
  ),
  (
    name: '42 <= 42',
    expr: literal(42) <= literal(42),
    expected: true,
  ),

  // Test for .greaterThan
  (
    name: '0.greaterThan(0)',
    expr: literal(0).greaterThan(literal(0)),
    expected: false,
  ),
  (
    name: '0.greaterThan(1)',
    expr: literal(0).greaterThan(literal(1)),
    expected: false,
  ),
  (
    name: '1.greaterThan(0)',
    expr: literal(1).greaterThan(literal(0)),
    expected: true,
  ),
  (
    name: '1.greaterThan(1)',
    expr: literal(1).greaterThan(literal(1)),
    expected: false,
  ),
  (
    name: '-1.greaterThan(-1)',
    expr: literal(-1).greaterThan(literal(-1)),
    expected: false,
  ),
  (
    name: '-1.greaterThan(0)',
    expr: literal(-1).greaterThan(literal(0)),
    expected: false,
  ),
  (
    name: '0.greaterThan(-1)',
    expr: literal(0).greaterThan(literal(-1)),
    expected: true,
  ),
  (
    name: '42.greaterThan(42)',
    expr: literal(42).greaterThan(literal(42)),
    expected: false,
  ),

  // Tests for .greaterThanLiteral
  (
    name: '0.greaterThanLiteral(0)',
    expr: literal(0).greaterThanLiteral(0),
    expected: false,
  ),
  (
    name: '0.greaterThanLiteral(1)',
    expr: literal(0).greaterThanLiteral(1),
    expected: false,
  ),
  (
    name: '1.greaterThanLiteral(0)',
    expr: literal(1).greaterThanLiteral(0),
    expected: true,
  ),
  (
    name: '1.greaterThanLiteral(1)',
    expr: literal(1).greaterThanLiteral(1),
    expected: false,
  ),
  (
    name: '-1.greaterThanLiteral(-1)',
    expr: literal(-1).greaterThanLiteral(-1),
    expected: false,
  ),
  (
    name: '-1.greaterThanLiteral(0)',
    expr: literal(-1).greaterThanLiteral(0),
    expected: false,
  ),
  (
    name: '0.greaterThanLiteral(-1)',
    expr: literal(0).greaterThanLiteral(-1),
    expected: true,
  ),
  (
    name: '42.greaterThanLiteral(42)',
    expr: literal(42).greaterThanLiteral(42),
    expected: false,
  ),

  // Test for >
  (
    name: '0 > 0',
    expr: literal(0) > literal(0),
    expected: false,
  ),
  (
    name: '0 > 1',
    expr: literal(0) > literal(1),
    expected: false,
  ),
  (
    name: '1 > 0',
    expr: literal(1) > literal(0),
    expected: true,
  ),
  (
    name: '1 > 1',
    expr: literal(1) > literal(1),
    expected: false,
  ),
  (
    name: '-1 > -1',
    expr: literal(-1) > literal(-1),
    expected: false,
  ),
  (
    name: '-1 > 0',
    expr: literal(-1) > literal(0),
    expected: false,
  ),
  (
    name: '0 > -1',
    expr: literal(0) > literal(-1),
    expected: true,
  ),
  (
    name: '42 > 42',
    expr: literal(42) > literal(42),
    expected: false,
  ),

  // Test for .greaterThanOrEqual
  (
    name: '0.greaterThanOrEqual(0)',
    expr: literal(0).greaterThanOrEqual(literal(0)),
    expected: true,
  ),
  (
    name: '0.greaterThanOrEqual(1)',
    expr: literal(0).greaterThanOrEqual(literal(1)),
    expected: false,
  ),
  (
    name: '1.greaterThanOrEqual(0)',
    expr: literal(1).greaterThanOrEqual(literal(0)),
    expected: true,
  ),
  (
    name: '1.greaterThanOrEqual(1)',
    expr: literal(1).greaterThanOrEqual(literal(1)),
    expected: true,
  ),
  (
    name: '-1.greaterThanOrEqual(-1)',
    expr: literal(-1).greaterThanOrEqual(literal(-1)),
    expected: true,
  ),
  (
    name: '-1.greaterThanOrEqual(0)',
    expr: literal(-1).greaterThanOrEqual(literal(0)),
    expected: false,
  ),
  (
    name: '0.greaterThanOrEqual(-1)',
    expr: literal(0).greaterThanOrEqual(literal(-1)),
    expected: true,
  ),
  (
    name: '42.greaterThanOrEqual(42)',
    expr: literal(42).greaterThanOrEqual(literal(42)),
    expected: true,
  ),

  // Tests for .greaterThanOrEqualLiteral
  (
    name: '0.greaterThanOrEqualLiteral(0)',
    expr: literal(0).greaterThanOrEqualLiteral(0),
    expected: true,
  ),
  (
    name: '0.greaterThanOrEqualLiteral(1)',
    expr: literal(0).greaterThanOrEqualLiteral(1),
    expected: false,
  ),
  (
    name: '1.greaterThanOrEqualLiteral(0)',
    expr: literal(1).greaterThanOrEqualLiteral(0),
    expected: true,
  ),
  (
    name: '1.greaterThanOrEqualLiteral(1)',
    expr: literal(1).greaterThanOrEqualLiteral(1),
    expected: true,
  ),
  (
    name: '-1.greaterThanOrEqualLiteral(-1)',
    expr: literal(-1).greaterThanOrEqualLiteral(-1),
    expected: true,
  ),
  (
    name: '-1.greaterThanOrEqualLiteral(0)',
    expr: literal(-1).greaterThanOrEqualLiteral(0),
    expected: false,
  ),
  (
    name: '0.greaterThanOrEqualLiteral(-1)',
    expr: literal(0).greaterThanOrEqualLiteral(-1),
    expected: true,
  ),
  (
    name: '42.greaterThanOrEqualLiteral(42)',
    expr: literal(42).greaterThanOrEqualLiteral(42),
    expected: true,
  ),

  // Test for >=
  (
    name: '0 >= 0',
    expr: literal(0) >= literal(0),
    expected: true,
  ),
  (
    name: '0 >= 1',
    expr: literal(0) >= literal(1),
    expected: false,
  ),
  (
    name: '1 >= 0',
    expr: literal(1) >= literal(0),
    expected: true,
  ),
  (
    name: '1 >= 1',
    expr: literal(1) >= literal(1),
    expected: true,
  ),
  (
    name: '-1 >= -1',
    expr: literal(-1) >= literal(-1),
    expected: true,
  ),
  (
    name: '-1 >= 0',
    expr: literal(-1) >= literal(0),
    expected: false,
  ),
  (
    name: '0 >= -1',
    expr: literal(0) >= literal(-1),
    expected: true,
  ),
  (
    name: '42 >= 42',
    expr: literal(42) >= literal(42),
    expected: true,
  ),

  // Test for asString()
  (
    name: '42.asString()',
    expr: literal(42).asString(),
    expected: '42',
  ),
  (
    name: '0.asString()',
    expr: literal(0).asString(),
    expected: '0',
  ),
  (
    name: '-1.asString()',
    expr: literal(-1).asString(),
    expected: '-1',
  ),

  // Test for asDouble()
  (
    name: '42.asDouble()',
    expr: literal(42).asDouble(),
    expected: 42.0,
  ),
  (
    name: '0.asDouble()',
    expr: literal(0).asDouble(),
    expected: 0.0,
  ),
  (
    name: '-1.asDouble()',
    expr: literal(-1).asDouble(),
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
