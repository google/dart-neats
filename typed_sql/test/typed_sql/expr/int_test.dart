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
    expr: toExpr(0).equals(toExpr(0)),
    expected: true,
  ),
  (
    name: '0.equals(1)',
    expr: toExpr(0).equals(toExpr(1)),
    expected: false,
  ),
  (
    name: '1.equals(0)',
    expr: toExpr(1).equals(toExpr(0)),
    expected: false,
  ),
  (
    name: '1.equals(1)',
    expr: toExpr(1).equals(toExpr(1)),
    expected: true,
  ),
  (
    name: '-1.equals(-1)',
    expr: toExpr(-1).equals(toExpr(-1)),
    expected: true,
  ),
  (
    name: '42.equals(42)',
    expr: toExpr(42).equals(toExpr(42)),
    expected: true,
  ),
  (
    name: '0.equals(null)',
    expr: toExpr(0).equals(toExpr(null)),
    expected: false,
  ),
  (
    name: '42.equals(null)',
    expr: toExpr(42).equals(toExpr(null)),
    expected: false,
  ),

  // Test for .equalsValue
  (
    name: '0.equalsValue(0)',
    expr: toExpr(0).equalsValue(0),
    expected: true,
  ),
  (
    name: '0.equalsValue(1)',
    expr: toExpr(0).equalsValue(1),
    expected: false,
  ),
  (
    name: '1.equalsValue(0)',
    expr: toExpr(1).equalsValue(0),
    expected: false,
  ),
  (
    name: '1.equalsValue(1)',
    expr: toExpr(1).equalsValue(1),
    expected: true,
  ),
  (
    name: '-1.equalsValue(-1)',
    expr: toExpr(-1).equalsValue(-1),
    expected: true,
  ),
  (
    name: '42.equalsValue(42)',
    expr: toExpr(42).equalsValue(42),
    expected: true,
  ),
  (
    name: '0.equalsValue(null)',
    expr: toExpr(0).equalsValue(null),
    expected: false,
  ),
  (
    name: '42.equalsValue(null)',
    expr: toExpr(42).equalsValue(null),
    expected: false,
  ),

  // Test for .notEquals
  (
    name: '0.notEquals(0)',
    expr: toExpr(0).notEquals(toExpr(0)),
    expected: false,
  ),
  (
    name: '0.notEquals(1)',
    expr: toExpr(0).notEquals(toExpr(1)),
    expected: true,
  ),
  (
    name: '1.notEquals(0)',
    expr: toExpr(1).notEquals(toExpr(0)),
    expected: true,
  ),
  (
    name: '1.notEquals(1)',
    expr: toExpr(1).notEquals(toExpr(1)),
    expected: false,
  ),
  (
    name: '-1.notEquals(-1)',
    expr: toExpr(-1).notEquals(toExpr(-1)),
    expected: false,
  ),
  (
    name: '42.notEquals(42)',
    expr: toExpr(42).notEquals(toExpr(42)),
    expected: false,
  ),
  (
    name: '0.notEquals(null)',
    expr: toExpr(0).notEquals(toExpr(null)),
    expected: true,
  ),
  (
    name: '42.notEquals(null)',
    expr: toExpr(42).notEquals(toExpr(null)),
    expected: true,
  ),

  // Test for .notEqualsValue
  (
    name: '0.notEqualsValue(0)',
    expr: toExpr(0).notEqualsValue(0),
    expected: false,
  ),
  (
    name: '0.notEqualsValue(1)',
    expr: toExpr(0).notEqualsValue(1),
    expected: true,
  ),
  (
    name: '1.notEqualsValue(0)',
    expr: toExpr(1).notEqualsValue(0),
    expected: true,
  ),
  (
    name: '1.notEqualsValue(1)',
    expr: toExpr(1).notEqualsValue(1),
    expected: false,
  ),
  (
    name: '-1.notEqualsValue(-1)',
    expr: toExpr(-1).notEqualsValue(-1),
    expected: false,
  ),
  (
    name: '42.notEqualsValue(42)',
    expr: toExpr(42).notEqualsValue(42),
    expected: false,
  ),
  (
    name: '0.notEqualsValue(null)',
    expr: toExpr(0).notEqualsValue(null),
    expected: true,
  ),
  (
    name: '42.notEqualsValue(null)',
    expr: toExpr(42).notEqualsValue(null),
    expected: true,
  ),

  // Test for +
  (
    name: '0 + 0',
    expr: toExpr(0) + toExpr(0),
    expected: 0,
  ),
  (
    name: '0 + 1',
    expr: toExpr(0) + toExpr(1),
    expected: 1,
  ),
  (
    name: '1 + 0',
    expr: toExpr(1) + toExpr(0),
    expected: 1,
  ),
  (
    name: '1 + 1',
    expr: toExpr(1) + toExpr(1),
    expected: 2,
  ),
  (
    name: '-1 + -1',
    expr: toExpr(-1) + toExpr(-1),
    expected: -2,
  ),
  (
    name: '42 + 42',
    expr: toExpr(42) + toExpr(42),
    expected: 84,
  ),

  // Test for -
  (
    name: '0 - 0',
    expr: toExpr(0) - toExpr(0),
    expected: 0,
  ),
  (
    name: '0 - 1',
    expr: toExpr(0) - toExpr(1),
    expected: -1,
  ),
  (
    name: '1 - 0',
    expr: toExpr(1) - toExpr(0),
    expected: 1,
  ),
  (
    name: '1 - 1',
    expr: toExpr(1) - toExpr(1),
    expected: 0,
  ),
  (
    name: '-1 - -1',
    expr: toExpr(-1) - toExpr(-1),
    expected: 0,
  ),
  (
    name: '42 - 42',
    expr: toExpr(42) - toExpr(42),
    expected: 0,
  ),

  // Test for *
  (
    name: '0 * 0',
    expr: toExpr(0) * toExpr(0),
    expected: 0,
  ),
  (
    name: '0 * 1',
    expr: toExpr(0) * toExpr(1),
    expected: 0,
  ),
  (
    name: '1 * 0',
    expr: toExpr(1) * toExpr(0),
    expected: 0,
  ),
  (
    name: '1 * 1',
    expr: toExpr(1) * toExpr(1),
    expected: 1,
  ),
  (
    name: '-1 * -1',
    expr: toExpr(-1) * toExpr(-1),
    expected: 1,
  ),
  (
    name: '42 * 42',
    expr: toExpr(42) * toExpr(42),
    expected: 1764,
  ),

  // Test for /
  (
    name: '0 / 1',
    expr: toExpr(0) / toExpr(1),
    expected: 0,
  ),
  (
    name: '1 / 1',
    expr: toExpr(1) / toExpr(1),
    expected: 1,
  ),
  (
    name: '-1 / -1',
    expr: toExpr(-1) / toExpr(-1),
    expected: 1,
  ),
  (
    name: '42 / 42',
    expr: toExpr(42) / toExpr(42),
    expected: 1,
  ),
  (
    name: '42 / 2',
    expr: toExpr(42) / toExpr(2),
    expected: 21,
  ),
  (
    name: '41 / 2',
    expr: toExpr(41) / toExpr(2),
    expected: 20.5,
  ),

  // Tests for .add
  (
    name: '0.add(0)',
    expr: toExpr(0).add(toExpr(0)),
    expected: 0,
  ),
  (
    name: '0.add(1)',
    expr: toExpr(0).add(toExpr(1)),
    expected: 1,
  ),
  (
    name: '1.add(0)',
    expr: toExpr(1).add(toExpr(0)),
    expected: 1,
  ),
  (
    name: '1.add(1)',
    expr: toExpr(1).add(toExpr(1)),
    expected: 2,
  ),
  (
    name: '-1.add(-1)',
    expr: toExpr(-1).add(toExpr(-1)),
    expected: -2,
  ),
  (
    name: '42.add(42)',
    expr: toExpr(42).add(toExpr(42)),
    expected: 84,
  ),

  // Tests for .addValue
  (
    name: '0.addValue(0)',
    expr: toExpr(0).addValue(0),
    expected: 0,
  ),
  (
    name: '0.addValue(1)',
    expr: toExpr(0).addValue(1),
    expected: 1,
  ),
  (
    name: '1.addValue(0)',
    expr: toExpr(1).addValue(0),
    expected: 1,
  ),
  (
    name: '1.addValue(1)',
    expr: toExpr(1).addValue(1),
    expected: 2,
  ),
  (
    name: '-1.addValue(-1)',
    expr: toExpr(-1).addValue(-1),
    expected: -2,
  ),
  (
    name: '42.addValue(42)',
    expr: toExpr(42).addValue(42),
    expected: 84,
  ),

  // Tests for .subtract
  (
    name: '0.subtract(0)',
    expr: toExpr(0).subtract(toExpr(0)),
    expected: 0,
  ),
  (
    name: '0.subtract(1)',
    expr: toExpr(0).subtract(toExpr(1)),
    expected: -1,
  ),
  (
    name: '1.subtract(0)',
    expr: toExpr(1).subtract(toExpr(0)),
    expected: 1,
  ),
  (
    name: '1.subtract(1)',
    expr: toExpr(1).subtract(toExpr(1)),
    expected: 0,
  ),
  (
    name: '-1.subtract(-1)',
    expr: toExpr(-1).subtract(toExpr(-1)),
    expected: 0,
  ),
  (
    name: '42.subtract(42)',
    expr: toExpr(42).subtract(toExpr(42)),
    expected: 0,
  ),

  // Tests for .subtractValue
  (
    name: '0.subtractValue(0)',
    expr: toExpr(0).subtractValue(0),
    expected: 0,
  ),
  (
    name: '0.subtractValue(1)',
    expr: toExpr(0).subtractValue(1),
    expected: -1,
  ),
  (
    name: '1.subtractValue(0)',
    expr: toExpr(1).subtractValue(0),
    expected: 1,
  ),
  (
    name: '1.subtractValue(1)',
    expr: toExpr(1).subtractValue(1),
    expected: 0,
  ),
  (
    name: '-1.subtractValue(-1)',
    expr: toExpr(-1).subtractValue(-1),
    expected: 0,
  ),
  (
    name: '42.subtractValue(42)',
    expr: toExpr(42).subtractValue(42),
    expected: 0,
  ),

  // Tests for .multiply
  (
    name: '0.multiply(0)',
    expr: toExpr(0).multiply(toExpr(0)),
    expected: 0,
  ),
  (
    name: '0.multiply(1)',
    expr: toExpr(0).multiply(toExpr(1)),
    expected: 0,
  ),
  (
    name: '1.multiply(0)',
    expr: toExpr(1).multiply(toExpr(0)),
    expected: 0,
  ),
  (
    name: '1.multiply(1)',
    expr: toExpr(1).multiply(toExpr(1)),
    expected: 1,
  ),
  (
    name: '-1.multiply(-1)',
    expr: toExpr(-1).multiply(toExpr(-1)),
    expected: 1,
  ),
  (
    name: '42.multiply(42)',
    expr: toExpr(42).multiply(toExpr(42)),
    expected: 1764,
  ),

  // Tests for .multiplyValue
  (
    name: '0.multiplyValue(0)',
    expr: toExpr(0).multiplyValue(0),
    expected: 0,
  ),
  (
    name: '0.multiplyValue(1)',
    expr: toExpr(0).multiplyValue(1),
    expected: 0,
  ),
  (
    name: '1.multiplyValue(0)',
    expr: toExpr(1).multiplyValue(0),
    expected: 0,
  ),
  (
    name: '1.multiplyValue(1)',
    expr: toExpr(1).multiplyValue(1),
    expected: 1,
  ),
  (
    name: '-1.multiplyValue(-1)',
    expr: toExpr(-1).multiplyValue(-1),
    expected: 1,
  ),
  (
    name: '42.multiplyValue(42)',
    expr: toExpr(42).multiplyValue(42),
    expected: 1764,
  ),

  // Tests for .divide
  (
    name: '0.divide(1)',
    expr: toExpr(0).divide(toExpr(1)),
    expected: 0,
  ),
  (
    name: '1.divide(1)',
    expr: toExpr(1).divide(toExpr(1)),
    expected: 1,
  ),
  (
    name: '-1.divide(-1)',
    expr: toExpr(-1).divide(toExpr(-1)),
    expected: 1,
  ),
  (
    name: '42.divide(42)',
    expr: toExpr(42).divide(toExpr(42)),
    expected: 1,
  ),
  (
    name: '42.divide(2)',
    expr: toExpr(42).divide(toExpr(2)),
    expected: 21,
  ),
  (
    name: '41.divide(2)',
    expr: toExpr(41).divide(toExpr(2)),
    expected: 20.5,
  ),

  // Tests for .divideValue
  (
    name: '0.divideValue(1)',
    expr: toExpr(0).divideValue(1),
    expected: 0,
  ),
  (
    name: '1.divideValue(1)',
    expr: toExpr(1).divideValue(1),
    expected: 1,
  ),
  (
    name: '-1.divideValue(-1)',
    expr: toExpr(-1).divideValue(-1),
    expected: 1,
  ),
  (
    name: '42.divideValue(42)',
    expr: toExpr(42).divideValue(42),
    expected: 1,
  ),
  (
    name: '42.divideValue(2)',
    expr: toExpr(42).divideValue(2),
    expected: 21,
  ),
  (
    name: '41.divideValue(2)',
    expr: toExpr(41).divideValue(2),
    expected: 20.5,
  ),

  // Test for .lessThan
  (
    name: '0.lessThan(0)',
    expr: toExpr(0).lessThan(toExpr(0)),
    expected: false,
  ),
  (
    name: '0.lessThan(1)',
    expr: toExpr(0).lessThan(toExpr(1)),
    expected: true,
  ),
  (
    name: '1.lessThan(0)',
    expr: toExpr(1).lessThan(toExpr(0)),
    expected: false,
  ),
  (
    name: '1.lessThan(1)',
    expr: toExpr(1).lessThan(toExpr(1)),
    expected: false,
  ),
  (
    name: '-1.lessThan(-1)',
    expr: toExpr(-1).lessThan(toExpr(-1)),
    expected: false,
  ),
  (
    name: '-1.lessThan(0)',
    expr: toExpr(-1).lessThan(toExpr(0)),
    expected: true,
  ),
  (
    name: '0.lessThan(-1)',
    expr: toExpr(0).lessThan(toExpr(-1)),
    expected: false,
  ),
  (
    name: '42.lessThan(42)',
    expr: toExpr(42).lessThan(toExpr(42)),
    expected: false,
  ),

  // Tests for .lessThanValue
  (
    name: '0.lessThanValue(0)',
    expr: toExpr(0).lessThanValue(0),
    expected: false,
  ),
  (
    name: '0.lessThanValue(1)',
    expr: toExpr(0).lessThanValue(1),
    expected: true,
  ),
  (
    name: '1.lessThanValue(0)',
    expr: toExpr(1).lessThanValue(0),
    expected: false,
  ),
  (
    name: '1.lessThanValue(1)',
    expr: toExpr(1).lessThanValue(1),
    expected: false,
  ),
  (
    name: '-1.lessThanValue(-1)',
    expr: toExpr(-1).lessThanValue(-1),
    expected: false,
  ),
  (
    name: '-1.lessThanValue(0)',
    expr: toExpr(-1).lessThanValue(0),
    expected: true,
  ),
  (
    name: '0.lessThanValue(-1)',
    expr: toExpr(0).lessThanValue(-1),
    expected: false,
  ),
  (
    name: '42.lessThanValue(42)',
    expr: toExpr(42).lessThanValue(42),
    expected: false,
  ),

  // Test for <
  (
    name: '0 < 0',
    expr: toExpr(0) < toExpr(0),
    expected: false,
  ),
  (
    name: '0 < 1',
    expr: toExpr(0) < toExpr(1),
    expected: true,
  ),
  (
    name: '1 < 0',
    expr: toExpr(1) < toExpr(0),
    expected: false,
  ),
  (
    name: '1 < 1',
    expr: toExpr(1) < toExpr(1),
    expected: false,
  ),
  (
    name: '-1 < -1',
    expr: toExpr(-1) < toExpr(-1),
    expected: false,
  ),
  (
    name: '-1 < 0',
    expr: toExpr(-1) < toExpr(0),
    expected: true,
  ),
  (
    name: '0 < -1',
    expr: toExpr(0) < toExpr(-1),
    expected: false,
  ),
  (
    name: '42 < 42',
    expr: toExpr(42) < toExpr(42),
    expected: false,
  ),

  // Test for .lessThanOrEqual
  (
    name: '0.lessThanOrEqual(0)',
    expr: toExpr(0).lessThanOrEqual(toExpr(0)),
    expected: true,
  ),
  (
    name: '0.lessThanOrEqual(1)',
    expr: toExpr(0).lessThanOrEqual(toExpr(1)),
    expected: true,
  ),
  (
    name: '1.lessThanOrEqual(0)',
    expr: toExpr(1).lessThanOrEqual(toExpr(0)),
    expected: false,
  ),
  (
    name: '1.lessThanOrEqual(1)',
    expr: toExpr(1).lessThanOrEqual(toExpr(1)),
    expected: true,
  ),
  (
    name: '-1.lessThanOrEqual(-1)',
    expr: toExpr(-1).lessThanOrEqual(toExpr(-1)),
    expected: true,
  ),
  (
    name: '-1.lessThanOrEqual(0)',
    expr: toExpr(-1).lessThanOrEqual(toExpr(0)),
    expected: true,
  ),
  (
    name: '0.lessThanOrEqual(-1)',
    expr: toExpr(0).lessThanOrEqual(toExpr(-1)),
    expected: false,
  ),
  (
    name: '42.lessThanOrEqual(42)',
    expr: toExpr(42).lessThanOrEqual(toExpr(42)),
    expected: true,
  ),

  // Tests for .lessThanOrEqualValue
  (
    name: '0.lessThanOrEqualValue(0)',
    expr: toExpr(0).lessThanOrEqualValue(0),
    expected: true,
  ),
  (
    name: '0.lessThanOrEqualValue(1)',
    expr: toExpr(0).lessThanOrEqualValue(1),
    expected: true,
  ),
  (
    name: '1.lessThanOrEqualValue(0)',
    expr: toExpr(1).lessThanOrEqualValue(0),
    expected: false,
  ),
  (
    name: '1.lessThanOrEqualValue(1)',
    expr: toExpr(1).lessThanOrEqualValue(1),
    expected: true,
  ),
  (
    name: '-1.lessThanOrEqualValue(-1)',
    expr: toExpr(-1).lessThanOrEqualValue(-1),
    expected: true,
  ),
  (
    name: '-1.lessThanOrEqualValue(0)',
    expr: toExpr(-1).lessThanOrEqualValue(0),
    expected: true,
  ),
  (
    name: '0.lessThanOrEqualValue(-1)',
    expr: toExpr(0).lessThanOrEqualValue(-1),
    expected: false,
  ),
  (
    name: '42.lessThanOrEqualValue(42)',
    expr: toExpr(42).lessThanOrEqualValue(42),
    expected: true,
  ),

  // Test for <=
  (
    name: '0 <= 0',
    expr: toExpr(0) <= toExpr(0),
    expected: true,
  ),
  (
    name: '0 <= 1',
    expr: toExpr(0) <= toExpr(1),
    expected: true,
  ),
  (
    name: '1 <= 0',
    expr: toExpr(1) <= toExpr(0),
    expected: false,
  ),
  (
    name: '1 <= 1',
    expr: toExpr(1) <= toExpr(1),
    expected: true,
  ),
  (
    name: '-1 <= -1',
    expr: toExpr(-1) <= toExpr(-1),
    expected: true,
  ),
  (
    name: '-1 <= 0',
    expr: toExpr(-1) <= toExpr(0),
    expected: true,
  ),
  (
    name: '0 <= -1',
    expr: toExpr(0) <= toExpr(-1),
    expected: false,
  ),
  (
    name: '42 <= 42',
    expr: toExpr(42) <= toExpr(42),
    expected: true,
  ),

  // Test for .greaterThan
  (
    name: '0.greaterThan(0)',
    expr: toExpr(0).greaterThan(toExpr(0)),
    expected: false,
  ),
  (
    name: '0.greaterThan(1)',
    expr: toExpr(0).greaterThan(toExpr(1)),
    expected: false,
  ),
  (
    name: '1.greaterThan(0)',
    expr: toExpr(1).greaterThan(toExpr(0)),
    expected: true,
  ),
  (
    name: '1.greaterThan(1)',
    expr: toExpr(1).greaterThan(toExpr(1)),
    expected: false,
  ),
  (
    name: '-1.greaterThan(-1)',
    expr: toExpr(-1).greaterThan(toExpr(-1)),
    expected: false,
  ),
  (
    name: '-1.greaterThan(0)',
    expr: toExpr(-1).greaterThan(toExpr(0)),
    expected: false,
  ),
  (
    name: '0.greaterThan(-1)',
    expr: toExpr(0).greaterThan(toExpr(-1)),
    expected: true,
  ),
  (
    name: '42.greaterThan(42)',
    expr: toExpr(42).greaterThan(toExpr(42)),
    expected: false,
  ),

  // Tests for .greaterThanValue
  (
    name: '0.greaterThanValue(0)',
    expr: toExpr(0).greaterThanValue(0),
    expected: false,
  ),
  (
    name: '0.greaterThanValue(1)',
    expr: toExpr(0).greaterThanValue(1),
    expected: false,
  ),
  (
    name: '1.greaterThanValue(0)',
    expr: toExpr(1).greaterThanValue(0),
    expected: true,
  ),
  (
    name: '1.greaterThanValue(1)',
    expr: toExpr(1).greaterThanValue(1),
    expected: false,
  ),
  (
    name: '-1.greaterThanValue(-1)',
    expr: toExpr(-1).greaterThanValue(-1),
    expected: false,
  ),
  (
    name: '-1.greaterThanValue(0)',
    expr: toExpr(-1).greaterThanValue(0),
    expected: false,
  ),
  (
    name: '0.greaterThanValue(-1)',
    expr: toExpr(0).greaterThanValue(-1),
    expected: true,
  ),
  (
    name: '42.greaterThanValue(42)',
    expr: toExpr(42).greaterThanValue(42),
    expected: false,
  ),

  // Test for >
  (
    name: '0 > 0',
    expr: toExpr(0) > toExpr(0),
    expected: false,
  ),
  (
    name: '0 > 1',
    expr: toExpr(0) > toExpr(1),
    expected: false,
  ),
  (
    name: '1 > 0',
    expr: toExpr(1) > toExpr(0),
    expected: true,
  ),
  (
    name: '1 > 1',
    expr: toExpr(1) > toExpr(1),
    expected: false,
  ),
  (
    name: '-1 > -1',
    expr: toExpr(-1) > toExpr(-1),
    expected: false,
  ),
  (
    name: '-1 > 0',
    expr: toExpr(-1) > toExpr(0),
    expected: false,
  ),
  (
    name: '0 > -1',
    expr: toExpr(0) > toExpr(-1),
    expected: true,
  ),
  (
    name: '42 > 42',
    expr: toExpr(42) > toExpr(42),
    expected: false,
  ),

  // Test for .greaterThanOrEqual
  (
    name: '0.greaterThanOrEqual(0)',
    expr: toExpr(0).greaterThanOrEqual(toExpr(0)),
    expected: true,
  ),
  (
    name: '0.greaterThanOrEqual(1)',
    expr: toExpr(0).greaterThanOrEqual(toExpr(1)),
    expected: false,
  ),
  (
    name: '1.greaterThanOrEqual(0)',
    expr: toExpr(1).greaterThanOrEqual(toExpr(0)),
    expected: true,
  ),
  (
    name: '1.greaterThanOrEqual(1)',
    expr: toExpr(1).greaterThanOrEqual(toExpr(1)),
    expected: true,
  ),
  (
    name: '-1.greaterThanOrEqual(-1)',
    expr: toExpr(-1).greaterThanOrEqual(toExpr(-1)),
    expected: true,
  ),
  (
    name: '-1.greaterThanOrEqual(0)',
    expr: toExpr(-1).greaterThanOrEqual(toExpr(0)),
    expected: false,
  ),
  (
    name: '0.greaterThanOrEqual(-1)',
    expr: toExpr(0).greaterThanOrEqual(toExpr(-1)),
    expected: true,
  ),
  (
    name: '42.greaterThanOrEqual(42)',
    expr: toExpr(42).greaterThanOrEqual(toExpr(42)),
    expected: true,
  ),

  // Tests for .greaterThanOrEqualValue
  (
    name: '0.greaterThanOrEqualValue(0)',
    expr: toExpr(0).greaterThanOrEqualValue(0),
    expected: true,
  ),
  (
    name: '0.greaterThanOrEqualValue(1)',
    expr: toExpr(0).greaterThanOrEqualValue(1),
    expected: false,
  ),
  (
    name: '1.greaterThanOrEqualValue(0)',
    expr: toExpr(1).greaterThanOrEqualValue(0),
    expected: true,
  ),
  (
    name: '1.greaterThanOrEqualValue(1)',
    expr: toExpr(1).greaterThanOrEqualValue(1),
    expected: true,
  ),
  (
    name: '-1.greaterThanOrEqualValue(-1)',
    expr: toExpr(-1).greaterThanOrEqualValue(-1),
    expected: true,
  ),
  (
    name: '-1.greaterThanOrEqualValue(0)',
    expr: toExpr(-1).greaterThanOrEqualValue(0),
    expected: false,
  ),
  (
    name: '0.greaterThanOrEqualValue(-1)',
    expr: toExpr(0).greaterThanOrEqualValue(-1),
    expected: true,
  ),
  (
    name: '42.greaterThanOrEqualValue(42)',
    expr: toExpr(42).greaterThanOrEqualValue(42),
    expected: true,
  ),

  // Test for >=
  (
    name: '0 >= 0',
    expr: toExpr(0) >= toExpr(0),
    expected: true,
  ),
  (
    name: '0 >= 1',
    expr: toExpr(0) >= toExpr(1),
    expected: false,
  ),
  (
    name: '1 >= 0',
    expr: toExpr(1) >= toExpr(0),
    expected: true,
  ),
  (
    name: '1 >= 1',
    expr: toExpr(1) >= toExpr(1),
    expected: true,
  ),
  (
    name: '-1 >= -1',
    expr: toExpr(-1) >= toExpr(-1),
    expected: true,
  ),
  (
    name: '-1 >= 0',
    expr: toExpr(-1) >= toExpr(0),
    expected: false,
  ),
  (
    name: '0 >= -1',
    expr: toExpr(0) >= toExpr(-1),
    expected: true,
  ),
  (
    name: '42 >= 42',
    expr: toExpr(42) >= toExpr(42),
    expected: true,
  ),

  // Test for asString()
  (
    name: '42.asString()',
    expr: toExpr(42).asString(),
    expected: '42',
  ),
  (
    name: '0.asString()',
    expr: toExpr(0).asString(),
    expected: '0',
  ),
  (
    name: '-1.asString()',
    expr: toExpr(-1).asString(),
    expected: '-1',
  ),

  // Test for asDouble()
  (
    name: '42.asDouble()',
    expr: toExpr(42).asDouble(),
    expected: 42.0,
  ),
  (
    name: '0.asDouble()',
    expr: toExpr(0).asDouble(),
    expected: 0.0,
  ),
  (
    name: '-1.asDouble()',
    expr: toExpr(-1).asDouble(),
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
