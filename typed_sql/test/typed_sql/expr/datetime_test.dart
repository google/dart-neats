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

final _cases = [
  // Test for .equals
  (
    name: 'DateTime(2025).equals(DateTime(2025))',
    expr: toExpr(DateTime(2025)).equals(toExpr(DateTime(2025))),
    expected: true,
  ),
  (
    name: 'DateTime(2025).toUtc().equals(DateTime(2025).toUtc())',
    expr: toExpr(DateTime(2025).toUtc()).equals(toExpr(DateTime(2025).toUtc())),
    expected: true,
  ),
  (
    name: 'DateTime(2024).equals(DateTime(2025))',
    expr: toExpr(DateTime(2024)).equals(toExpr(DateTime(2025))),
    expected: false,
  ),
  (
    name: 'epoch.equals(epoch)',
    expr: toExpr(epoch).equals(toExpr(epoch)),
    expected: true,
  ),
  (
    name: 'epoch.equals(DateTime(2025))',
    expr: toExpr(epoch).equals(toExpr(DateTime(2025))),
    expected: false,
  ),
  (
    name: 'epoch.equals(today)',
    expr: toExpr(epoch).equals(toExpr(today)),
    expected: false,
  ),
  (
    name: 'epoch.equals(null)',
    expr: toExpr(epoch).equals(toExpr(null)),
    expected: false,
  ),
  (
    name: 'today.equals(null)',
    expr: toExpr(today).equals(toExpr(null)),
    expected: false,
  ),

  // Test for .equalsValue
  (
    name: 'DateTime(2025).equalsValue(DateTime(2025))',
    expr: toExpr(DateTime(2025)).equalsValue(DateTime(2025)),
    expected: true,
  ),
  (
    name: 'DateTime(2025).toUtc().equalsValue(DateTime(2025).toUtc())',
    expr: toExpr(DateTime(2025).toUtc()).equalsValue(DateTime(2025).toUtc()),
    expected: true,
  ),
  (
    name: 'DateTime(2024).equalsValue(DateTime(2025))',
    expr: toExpr(DateTime(2024)).equalsValue(DateTime(2025)),
    expected: false,
  ),
  (
    name: 'epoch.equalsValue(epoch)',
    expr: toExpr(epoch).equalsValue(epoch),
    expected: true,
  ),
  (
    name: 'epoch.equalsValue(DateTime(2025))',
    expr: toExpr(epoch).equalsValue(DateTime(2025)),
    expected: false,
  ),
  (
    name: 'epoch.equalsValue(today)',
    expr: toExpr(epoch).equalsValue(today),
    expected: false,
  ),
  (
    name: 'epoch.equalsValue(null)',
    expr: toExpr(epoch).equalsValue(null),
    expected: false,
  ),
  (
    name: 'today.equalsValue(null)',
    expr: toExpr(today).equalsValue(null),
    expected: false,
  ),

  // Test for .notEquals
  (
    name: 'DateTime(2025).notEquals(DateTime(2025))',
    expr: toExpr(DateTime(2025)).notEquals(toExpr(DateTime(2025))),
    expected: false,
  ),
  (
    name: 'DateTime(2025).toUtc().notEquals(DateTime(2025).toUtc())',
    expr: toExpr(DateTime(2025).toUtc())
        .notEquals(toExpr(DateTime(2025).toUtc())),
    expected: false,
  ),
  (
    name: 'DateTime(2024).notEquals(DateTime(2025))',
    expr: toExpr(DateTime(2024)).notEquals(toExpr(DateTime(2025))),
    expected: true,
  ),
  (
    name: 'epoch.notEquals(epoch)',
    expr: toExpr(epoch).notEquals(toExpr(epoch)),
    expected: false,
  ),
  (
    name: 'epoch.notEquals(DateTime(2025))',
    expr: toExpr(epoch).notEquals(toExpr(DateTime(2025))),
    expected: true,
  ),
  (
    name: 'epoch.notEquals(today)',
    expr: toExpr(epoch).notEquals(toExpr(today)),
    expected: true,
  ),
  (
    name: 'epoch.notEquals(null)',
    expr: toExpr(epoch).notEquals(toExpr(null)),
    expected: true,
  ),
  (
    name: 'today.notEquals(null)',
    expr: toExpr(today).notEquals(toExpr(null)),
    expected: true,
  ),

  // Test for .notEqualsValue
  (
    name: 'DateTime(2025).notEqualsValue(DateTime(2025))',
    expr: toExpr(DateTime(2025)).notEqualsValue(DateTime(2025)),
    expected: false,
  ),
  (
    name: 'DateTime(2025).toUtc().notEqualsValue(DateTime(2025).toUtc())',
    expr: toExpr(DateTime(2025).toUtc()).notEqualsValue(DateTime(2025).toUtc()),
    expected: false,
  ),
  (
    name: 'DateTime(2024).notEqualsValue(DateTime(2025))',
    expr: toExpr(DateTime(2024)).notEqualsValue(DateTime(2025)),
    expected: true,
  ),
  (
    name: 'epoch.notEqualsValue(epoch)',
    expr: toExpr(epoch).notEqualsValue(epoch),
    expected: false,
  ),
  (
    name: 'epoch.notEqualsValue(DateTime(2025))',
    expr: toExpr(epoch).notEqualsValue(DateTime(2025)),
    expected: true,
  ),
  (
    name: 'epoch.notEqualsValue(today)',
    expr: toExpr(epoch).notEqualsValue(today),
    expected: true,
  ),
  (
    name: 'epoch.notEqualsValue(null)',
    expr: toExpr(epoch).notEqualsValue(null),
    expected: true,
  ),
  (
    name: 'today.notEqualsValue(null)',
    expr: toExpr(today).notEqualsValue(null),
    expected: true,
  ),

  // Test for .isBefore
  (
    name: 'DateTime(2024).isBefore(DateTime(2025))',
    expr: toExpr(DateTime(2024)).isBefore(toExpr(DateTime(2025))),
    expected: true,
  ),
  (
    name: 'DateTime(2025).isBefore(DateTime(2024))',
    expr: toExpr(DateTime(2025)).isBefore(toExpr(DateTime(2024))),
    expected: false,
  ),
  (
    name: 'DateTime(2025).isBefore(DateTime(2025))',
    expr: toExpr(DateTime(2025)).isBefore(toExpr(DateTime(2025))),
    expected: false,
  ),
  (
    name: 'epoch.isBefore(today)',
    expr: toExpr(epoch).isBefore(toExpr(today)),
    expected: true,
  ),
  (
    name: 'today.isBefore(epoch)',
    expr: toExpr(today).isBefore(toExpr(epoch)),
    expected: false,
  ),
  (
    name: 'epoch.isBefore(epoch)',
    expr: toExpr(epoch).isBefore(toExpr(epoch)),
    expected: false,
  ),

  // Test for .isBeforeValue
  (
    name: 'DateTime(2024).isBeforeValue(DateTime(2025))',
    expr: toExpr(DateTime(2024)).isBeforeValue(DateTime(2025)),
    expected: true,
  ),
  (
    name: 'DateTime(2025).isBeforeValue(DateTime(2024))',
    expr: toExpr(DateTime(2025)).isBeforeValue(DateTime(2024)),
    expected: false,
  ),
  (
    name: 'DateTime(2025).isBeforeValue(DateTime(2025))',
    expr: toExpr(DateTime(2025)).isBeforeValue(DateTime(2025)),
    expected: false,
  ),
  (
    name: 'epoch.isBeforeValue(today)',
    expr: toExpr(epoch).isBeforeValue(today),
    expected: true,
  ),
  (
    name: 'today.isBeforeValue(epoch)',
    expr: toExpr(today).isBeforeValue(epoch),
    expected: false,
  ),
  (
    name: 'epoch.isBeforeValue(epoch)',
    expr: toExpr(epoch).isBeforeValue(epoch),
    expected: false,
  ),

  // Test for <
  (
    name: 'DateTime(2024) < DateTime(2025)',
    expr: toExpr(DateTime(2024)) < toExpr(DateTime(2025)),
    expected: true,
  ),
  (
    name: 'DateTime(2025) < DateTime(2024)',
    expr: toExpr(DateTime(2025)) < toExpr(DateTime(2024)),
    expected: false,
  ),
  (
    name: 'DateTime(2025) < DateTime(2025)',
    expr: toExpr(DateTime(2025)) < toExpr(DateTime(2025)),
    expected: false,
  ),
  (
    name: 'epoch < today',
    expr: toExpr(epoch) < toExpr(today),
    expected: true,
  ),
  (
    name: 'today < epoch',
    expr: toExpr(today) < toExpr(epoch),
    expected: false,
  ),
  (
    name: 'epoch < epoch',
    expr: toExpr(epoch) < toExpr(epoch),
    expected: false,
  ),

  // Test for .isAfter
  (
    name: 'DateTime(2024).isAfter(DateTime(2025))',
    expr: toExpr(DateTime(2024)).isAfter(toExpr(DateTime(2025))),
    expected: false,
  ),
  (
    name: 'DateTime(2025).isAfter(DateTime(2024))',
    expr: toExpr(DateTime(2025)).isAfter(toExpr(DateTime(2024))),
    expected: true,
  ),
  (
    name: 'DateTime(2025).isAfter(DateTime(2025))',
    expr: toExpr(DateTime(2025)).isAfter(toExpr(DateTime(2025))),
    expected: false,
  ),
  (
    name: 'epoch.isAfter(today)',
    expr: toExpr(epoch).isAfter(toExpr(today)),
    expected: false,
  ),
  (
    name: 'today.isAfter(epoch)',
    expr: toExpr(today).isAfter(toExpr(epoch)),
    expected: true,
  ),
  (
    name: 'epoch.isAfter(epoch)',
    expr: toExpr(epoch).isAfter(toExpr(epoch)),
    expected: false,
  ),

  // Test for .isAfterValue
  (
    name: 'DateTime(2024).isAfterValue(DateTime(2025))',
    expr: toExpr(DateTime(2024)).isAfterValue(DateTime(2025)),
    expected: false,
  ),
  (
    name: 'DateTime(2025).isAfterValue(DateTime(2024))',
    expr: toExpr(DateTime(2025)).isAfterValue(DateTime(2024)),
    expected: true,
  ),
  (
    name: 'DateTime(2025).isAfterValue(DateTime(2025))',
    expr: toExpr(DateTime(2025)).isAfterValue(DateTime(2025)),
    expected: false,
  ),
  (
    name: 'epoch.isAfterValue(today)',
    expr: toExpr(epoch).isAfterValue(today),
    expected: false,
  ),
  (
    name: 'today.isAfterValue(epoch)',
    expr: toExpr(today).isAfterValue(epoch),
    expected: true,
  ),
  (
    name: 'epoch.isAfterValue(epoch)',
    expr: toExpr(epoch).isAfterValue(epoch),
    expected: false,
  ),

  // Test for >
  (
    name: 'DateTime(2024) > DateTime(2025)',
    expr: toExpr(DateTime(2024)) > toExpr(DateTime(2025)),
    expected: false,
  ),
  (
    name: 'DateTime(2025) > DateTime(2024)',
    expr: toExpr(DateTime(2025)) > toExpr(DateTime(2024)),
    expected: true,
  ),
  (
    name: 'DateTime(2025) > DateTime(2025)',
    expr: toExpr(DateTime(2025)) > toExpr(DateTime(2025)),
    expected: false,
  ),
  (
    name: 'epoch > today',
    expr: toExpr(epoch) > toExpr(today),
    expected: false,
  ),
  (
    name: 'today > epoch',
    expr: toExpr(today) > toExpr(epoch),
    expected: true,
  ),
  (
    name: 'epoch > epoch',
    expr: toExpr(epoch) > toExpr(epoch),
    expected: false,
  ),

  // Test for <=
  (
    name: 'DateTime(2024) <= DateTime(2025)',
    expr: toExpr(DateTime(2024)) <= toExpr(DateTime(2025)),
    expected: true,
  ),
  (
    name: 'DateTime(2025) <= DateTime(2024)',
    expr: toExpr(DateTime(2025)) <= toExpr(DateTime(2024)),
    expected: false,
  ),
  (
    name: 'DateTime(2025) <= DateTime(2025)',
    expr: toExpr(DateTime(2025)) <= toExpr(DateTime(2025)),
    expected: true,
  ),
  (
    name: 'epoch <= today',
    expr: toExpr(epoch) <= toExpr(today),
    expected: true,
  ),
  (
    name: 'today <= epoch',
    expr: toExpr(today) <= toExpr(epoch),
    expected: false,
  ),
  (
    name: 'epoch <= epoch',
    expr: toExpr(epoch) <= toExpr(epoch),
    expected: true,
  ),

  // Test for >=
  (
    name: 'DateTime(2024) >= DateTime(2025)',
    expr: toExpr(DateTime(2024)) >= toExpr(DateTime(2025)),
    expected: false,
  ),
  (
    name: 'DateTime(2025) >= DateTime(2024)',
    expr: toExpr(DateTime(2025)) >= toExpr(DateTime(2024)),
    expected: true,
  ),
  (
    name: 'DateTime(2025) >= DateTime(2025)',
    expr: toExpr(DateTime(2025)) >= toExpr(DateTime(2025)),
    expected: true,
  ),
  (
    name: 'epoch >= today',
    expr: toExpr(epoch) >= toExpr(today),
    expected: false,
  ),
  (
    name: 'today >= epoch',
    expr: toExpr(today) >= toExpr(epoch),
    expected: true,
  ),
  (
    name: 'epoch >= epoch',
    expr: toExpr(epoch) >= toExpr(epoch),
    expected: true,
  ),

  // Test for Expr.currentTimestamp
  (
    name: 'Expr.currentTimestamp.isAfter(epoch)',
    expr: Expr.currentTimestamp.isAfter(toExpr(epoch)),
    expected: true,
  ),
  (
    name: 'Expr.currentTimestamp.isBefore(3000)',
    expr: Expr.currentTimestamp.isBefore(toExpr(DateTime.utc(3000))),
    expected: true,
  ),
  (
    name: 'Expr.currentTimestamp.isAfter(today - 1 day)',
    expr: Expr.currentTimestamp.isAfter(
      toExpr(DateTime.now().toUtc().subtract(const Duration(days: 1))),
    ),
    expected: true,
  ),
  (
    name: 'Expr.currentTimestamp.isBefore(today + 1 day)',
    expr: Expr.currentTimestamp.isBefore(
      toExpr(DateTime.now().toUtc().add(const Duration(days: 1))),
    ),
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
      check(result).isNotNull().equals(c.expected);
    });
  }

  r.run();
}
