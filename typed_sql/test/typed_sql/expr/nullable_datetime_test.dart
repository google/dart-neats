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

final epoch = DateTime.fromMicrosecondsSinceEpoch(0).toUtc();
final today = DateTime.parse('2025-03-10T11:34:36.000000Z');

final _cases = <({
  String name,
  Expr expr,
  Object? expected,
})>[
  // Tests for null and DateTime
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
  // Expr<DateTime?>.equals
  (
    name: 'null.asDateTime().equals(epoch)',
    expr: toExpr(null).asDateTime().equals(toExpr(epoch)),
    expected: false,
  ),
  (
    name: 'epoch.equals(epoch)',
    expr: toExpr(epoch as DateTime?).equals(toExpr(epoch)),
    expected: true,
  ),
  (
    name: 'null.asDateTime().equals(today)',
    expr: toExpr(null).asDateTime().equals(toExpr(today)),
    expected: false,
  ),
  (
    name: 'today.equals(today)',
    expr: toExpr(today as DateTime?).equals(toExpr(today)),
    expected: true,
  ),
  // Expr<DateTime?>.isNotDistinctFrom
  (
    name: 'null.asDateTime().isNotDistinctFrom(null)',
    expr: toExpr(null).asDateTime().isNotDistinctFrom(toExpr(null)),
    expected: true,
  ),
  (
    name: 'null.asDateTime().isNotDistinctFrom(epoch)',
    expr: toExpr(null).asDateTime().isNotDistinctFrom(toExpr(epoch)),
    expected: false,
  ),
  (
    name: 'epoch.isNotDistinctFrom(null)',
    expr: toExpr(epoch as DateTime?).isNotDistinctFrom(toExpr(null)),
    expected: false,
  ),
  (
    name: 'epoch.isNotDistinctFrom(epoch)',
    expr: toExpr(epoch as DateTime?).isNotDistinctFrom(toExpr(epoch)),
    expected: true,
  ),
  (
    name: 'null.asDateTime().isNotDistinctFrom(today)',
    expr: toExpr(null).asDateTime().isNotDistinctFrom(toExpr(today)),
    expected: false,
  ),
  (
    name: 'today.isNotDistinctFrom(null)',
    expr: toExpr(today as DateTime?).isNotDistinctFrom(toExpr(null)),
    expected: false,
  ),
  (
    name: 'today.isNotDistinctFrom(today)',
    expr: toExpr(today as DateTime?).isNotDistinctFrom(toExpr(today)),
    expected: true,
  ),
  // Expr<DateTime?>.equalsUnlessNull
  (
    name: 'null.asDateTime().equalsUnlessNull(null)',
    expr: toExpr(null).asDateTime().equalsUnlessNull(toExpr(null)),
    expected: null,
  ),
  (
    name: 'null.asDateTime().equalsUnlessNull(epoch)',
    expr: toExpr(null).asDateTime().equalsUnlessNull(toExpr(epoch)),
    expected: null,
  ),
  (
    name: 'epoch.equalsUnlessNull(null)',
    expr: toExpr(epoch as DateTime?).equalsUnlessNull(toExpr(null)),
    expected: null,
  ),
  (
    name: 'epoch.equalsUnlessNull(epoch)',
    expr: toExpr(epoch as DateTime?).equalsUnlessNull(toExpr(epoch)),
    expected: true,
  ),
  (
    name: 'null.asDateTime().equalsUnlessNull(today)',
    expr: toExpr(null).asDateTime().equalsUnlessNull(toExpr(today)),
    expected: null,
  ),
  (
    name: 'today.equalsUnlessNull(null)',
    expr: toExpr(today as DateTime?).equalsUnlessNull(toExpr(null)),
    expected: null,
  ),
  (
    name: 'today.equalsUnlessNull(today)',
    expr: toExpr(today as DateTime?).equalsUnlessNull(toExpr(today)),
    expected: true,
  ),
  // Expr<DateTime?>.notEquals
  (
    name: 'null.asDateTime().notEquals(epoch)',
    expr: toExpr(null).asDateTime().notEquals(toExpr(epoch)),
    expected: true,
  ),
  (
    name: 'epoch.notEquals(epoch)',
    expr: toExpr(epoch as DateTime?).notEquals(toExpr(epoch)),
    expected: false,
  ),
  (
    name: 'null.asDateTime().notEquals(today)',
    expr: toExpr(null).asDateTime().notEquals(toExpr(today)),
    expected: true,
  ),
  (
    name: 'today.notEquals(today)',
    expr: toExpr(today as DateTime?).notEquals(toExpr(today)),
    expected: false,
  ),
  // Expr<DateTime?>.equalsValue
  (
    name: 'null.asDateTime().equalsValue(epoch)',
    expr: toExpr(null).asDateTime().equalsValue(epoch),
    expected: false,
  ),
  (
    name: 'epoch.equalsValue(epoch)',
    expr: toExpr(epoch as DateTime?).equalsValue(epoch),
    expected: true,
  ),
  (
    name: 'null.asDateTime().equalsValue(today)',
    expr: toExpr(null).asDateTime().equalsValue(today),
    expected: false,
  ),
  (
    name: 'today.equalsValue(today)',
    expr: toExpr(today as DateTime?).equalsValue(today),
    expected: true,
  ),
  // Expr<DateTime?>.notEqualsValue
  (
    name: 'null.asDateTime().notEqualsValue(epoch)',
    expr: toExpr(null).asDateTime().notEqualsValue(epoch),
    expected: true,
  ),
  (
    name: 'epoch.notEqualsValue(epoch)',
    expr: toExpr(epoch as DateTime?).notEqualsValue(epoch),
    expected: false,
  ),
  (
    name: 'null.asDateTime().notEqualsValue(today)',
    expr: toExpr(null).asDateTime().notEqualsValue(today),
    expected: true,
  ),
  (
    name: 'today.notEqualsValue(today)',
    expr: toExpr(today as DateTime?).notEqualsValue(today),
    expected: false,
  ),
  // Expr<DateTime?>.isNull()
  (
    name: 'null.asDateTime().isNull()',
    expr: toExpr(null).asDateTime().isNull(),
    expected: true,
  ),
  (
    name: 'epoch.isNull()',
    expr: toExpr(epoch as DateTime?).isNull(),
    expected: false,
  ),
  (
    name: 'today.isNull()',
    expr: toExpr(today as DateTime?).isNull(),
    expected: false,
  ),
  // Expr<DateTime?>.isNotNull()
  (
    name: 'null.asDateTime().isNotNull()',
    expr: toExpr(null).asDateTime().isNotNull(),
    expected: false,
  ),
  (
    name: 'epoch.isNotNull()',
    expr: toExpr(epoch as DateTime?).isNotNull(),
    expected: true,
  ),
  (
    name: 'today.isNotNull()',
    expr: toExpr(today as DateTime?).isNotNull(),
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
