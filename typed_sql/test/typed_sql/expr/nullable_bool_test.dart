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
  (
    name: 'true',
    expr: toExpr(true as bool?),
    expected: true,
  ),
  (
    name: 'false',
    expr: toExpr(false as bool?),
    expected: false,
  ),
  (
    name: 'null',
    expr: toExpr(null as bool?),
    expected: null,
  ),
  (
    name: 'null.asBool()',
    expr: toExpr(null).asBool(),
    expected: null,
  ),
  // Test for .orElse
  (
    name: 'null.orElse(true)',
    expr: toExpr(null as bool?).orElse(toExpr(true)),
    expected: true,
  ),
  (
    name: 'null.orElse(false)',
    expr: toExpr(null as bool?).orElse(toExpr(false)),
    expected: false,
  ),
  (
    name: 'true.orElse(false)',
    expr: toExpr(true as bool?).orElse(toExpr(false)),
    expected: true,
  ),
  (
    name: 'false.orElse(true)',
    expr: toExpr(false as bool?).orElse(toExpr(true)),
    expected: false,
  ),
  (
    name: 'null.asBool().orElse(true)',
    expr: toExpr(null).asBool().orElse(toExpr(true)),
    expected: true,
  ),
  (
    name: 'null.asBool().orElse(false)',
    expr: toExpr(null).asBool().orElse(toExpr(false)),
    expected: false,
  ),
  // Test for .orElseValue
  (
    name: 'null.orElseValue(true)',
    expr: toExpr(null as bool?).orElseValue(true),
    expected: true,
  ),
  (
    name: 'null.orElseValue(false)',
    expr: toExpr(null as bool?).orElseValue(false),
    expected: false,
  ),
  (
    name: 'true.orElseValue(false)',
    expr: toExpr(true as bool?).orElseValue(false),
    expected: true,
  ),
  (
    name: 'false.orElseValue(true)',
    expr: toExpr(false as bool?).orElseValue(true),
    expected: false,
  ),
  (
    name: 'null.asBool().orElseValue(true)',
    expr: toExpr(null).asBool().orElseValue(true),
    expected: true,
  ),
  (
    name: 'null.asBool().orElseValue(false)',
    expr: toExpr(null).asBool().orElseValue(false),
    expected: false,
  ),

  // Test for .equals
  (
    name: 'null.equals(true)',
    expr: toExpr(null as bool?).equals(toExpr(true)),
    expected: false,
  ),
  (
    name: 'null.equals(false)',
    expr: toExpr(null as bool?).equals(toExpr(false)),
    expected: false,
  ),
  (
    name: 'true.equals(true)',
    expr: toExpr(true as bool?).equals(toExpr(true)),
    expected: true,
  ),
  (
    name: 'true.equals(false)',
    expr: toExpr(true as bool?).equals(toExpr(false)),
    expected: false,
  ),
  (
    name: 'false.equals(true)',
    expr: toExpr(false as bool?).equals(toExpr(true)),
    expected: false,
  ),
  (
    name: 'false.equals(false)',
    expr: toExpr(false as bool?).equals(toExpr(false)),
    expected: true,
  ),

  // Test for .equalsValue
  (
    name: 'null.equalsValue(true)',
    expr: toExpr(null as bool?).equalsValue(true),
    expected: false,
  ),
  (
    name: 'null.equalsValue(false)',
    expr: toExpr(null as bool?).equalsValue(false),
    expected: false,
  ),
  (
    name: 'true.equalsValue(true)',
    expr: toExpr(true as bool?).equalsValue(true),
    expected: true,
  ),
  (
    name: 'true.equalsValue(false)',
    expr: toExpr(true as bool?).equalsValue(false),
    expected: false,
  ),
  (
    name: 'false.equalsValue(true)',
    expr: toExpr(false as bool?).equalsValue(true),
    expected: false,
  ),
  (
    name: 'false.equalsValue(false)',
    expr: toExpr(false as bool?).equalsValue(false),
    expected: true,
  ),

  // Test for .notEquals
  (
    name: 'null.notEquals(true)',
    expr: toExpr(null as bool?).notEquals(toExpr(true)),
    expected: true,
  ),
  (
    name: 'null.notEquals(false)',
    expr: toExpr(null as bool?).notEquals(toExpr(false)),
    expected: true,
  ),
  (
    name: 'true.notEquals(true)',
    expr: toExpr(true as bool?).notEquals(toExpr(true)),
    expected: false,
  ),
  (
    name: 'true.notEquals(false)',
    expr: toExpr(true as bool?).notEquals(toExpr(false)),
    expected: true,
  ),
  (
    name: 'false.notEquals(true)',
    expr: toExpr(false as bool?).notEquals(toExpr(true)),
    expected: true,
  ),
  (
    name: 'false.notEquals(false)',
    expr: toExpr(false as bool?).notEquals(toExpr(false)),
    expected: false,
  ),

  // Test for .notEqualsValue
  (
    name: 'null.notEqualsValue(true)',
    expr: toExpr(null as bool?).notEqualsValue(true),
    expected: true,
  ),
  (
    name: 'null.notEqualsValue(false)',
    expr: toExpr(null as bool?).notEqualsValue(false),
    expected: true,
  ),
  (
    name: 'true.notEqualsValue(true)',
    expr: toExpr(true as bool?).notEqualsValue(true),
    expected: false,
  ),
  (
    name: 'true.notEqualsValue(false)',
    expr: toExpr(true as bool?).notEqualsValue(false),
    expected: true,
  ),
  (
    name: 'false.notEqualsValue(true)',
    expr: toExpr(false as bool?).notEqualsValue(true),
    expected: true,
  ),
  (
    name: 'false.notEqualsValue(false)',
    expr: toExpr(false as bool?).notEqualsValue(false),
    expected: false,
  ),

  // Tests for .isNotDistinctFrom
  (
    name: 'null.isNotDistinctFrom(true)',
    expr: toExpr(null as bool?).isNotDistinctFrom(toExpr(true)),
    expected: false,
  ),
  (
    name: 'null.isNotDistinctFrom(false)',
    expr: toExpr(null as bool?).isNotDistinctFrom(toExpr(false)),
    expected: false,
  ),
  (
    name: 'null.isNotDistinctFrom(null)',
    expr: toExpr(null as bool?).isNotDistinctFrom(toExpr(null)),
    expected: true,
  ),
  (
    name: 'true.isNotDistinctFrom(true)',
    expr: toExpr(true as bool?).isNotDistinctFrom(toExpr(true)),
    expected: true,
  ),
  (
    name: 'true.isNotDistinctFrom(false)',
    expr: toExpr(true as bool?).isNotDistinctFrom(toExpr(false)),
    expected: false,
  ),
  (
    name: 'true.isNotDistinctFrom(null)',
    expr: toExpr(true as bool?).isNotDistinctFrom(toExpr(null)),
    expected: false,
  ),
  (
    name: 'false.isNotDistinctFrom(true)',
    expr: toExpr(false as bool?).isNotDistinctFrom(toExpr(true)),
    expected: false,
  ),
  (
    name: 'false.isNotDistinctFrom(false)',
    expr: toExpr(false as bool?).isNotDistinctFrom(toExpr(false)),
    expected: true,
  ),
  (
    name: 'false.isNotDistinctFrom(null)',
    expr: toExpr(false as bool?).isNotDistinctFrom(toExpr(null)),
    expected: false,
  ),

  // Tests for .equalsUnlessNull
  (
    name: 'null.equalsUnlessNull(true)',
    expr: toExpr(null as bool?).equalsUnlessNull(toExpr(true)),
    expected: null,
  ),
  (
    name: 'null.equalsUnlessNull(false)',
    expr: toExpr(null as bool?).equalsUnlessNull(toExpr(false)),
    expected: null,
  ),
  (
    name: 'null.equalsUnlessNull(null)',
    expr: toExpr(null as bool?).equalsUnlessNull(toExpr(null)),
    expected: null,
  ),
  (
    name: 'true.equalsUnlessNull(true)',
    expr: toExpr(true as bool?).equalsUnlessNull(toExpr(true)),
    expected: true,
  ),
  (
    name: 'true.equalsUnlessNull(false)',
    expr: toExpr(true as bool?).equalsUnlessNull(toExpr(false)),
    expected: false,
  ),
  (
    name: 'true.equalsUnlessNull(null)',
    expr: toExpr(true as bool?).equalsUnlessNull(toExpr(null)),
    expected: null,
  ),
  (
    name: 'false.equalsUnlessNull(true)',
    expr: toExpr(false as bool?).equalsUnlessNull(toExpr(true)),
    expected: false,
  ),
  (
    name: 'false.equalsUnlessNull(false)',
    expr: toExpr(false as bool?).equalsUnlessNull(toExpr(false)),
    expected: true,
  ),
  (
    name: 'false.equalsUnlessNull(null)',
    expr: toExpr(false as bool?).equalsUnlessNull(toExpr(null)),
    expected: null,
  ),

  // Tests for .isTrue
  (
    name: 'null.isTrue()',
    expr: toExpr(null as bool?).isTrue(),
    expected: false,
  ),
  (
    name: 'true.isTrue()',
    expr: toExpr(true as bool?).isTrue(),
    expected: true,
  ),
  (
    name: 'false.isTrue()',
    expr: toExpr(false as bool?).isTrue(),
    expected: false,
  ),

  // Tests for .isFalse
  (
    name: 'null.isFalse()',
    expr: toExpr(null as bool?).isFalse(),
    expected: false,
  ),
  (
    name: 'true.isFalse()',
    expr: toExpr(true as bool?).isFalse(),
    expected: false,
  ),
  (
    name: 'false.isFalse()',
    expr: toExpr(false as bool?).isFalse(),
    expected: true,
  ),

  // Tests for .isNull
  (
    name: 'null.isNull()',
    expr: toExpr(null as bool?).isNull(),
    expected: true,
  ),
  (
    name: 'true.isNull()',
    expr: toExpr(true as bool?).isNull(),
    expected: false,
  ),
  (
    name: 'false.isNull()',
    expr: toExpr(false as bool?).isNull(),
    expected: false,
  ),

  // Tests for .isNotNull
  (
    name: 'null.isNotNull()',
    expr: toExpr(null as bool?).isNotNull(),
    expected: false,
  ),
  (
    name: 'true.isNotNull()',
    expr: toExpr(true as bool?).isNotNull(),
    expected: true,
  ),
  (
    name: 'false.isNotNull()',
    expr: toExpr(false as bool?).isNotNull(),
    expected: true,
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

  r.run();
}
