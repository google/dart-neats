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

  // Test for .equalsLiteral
  (
    name: 'DateTime(2025).equalsLiteral(DateTime(2025))',
    expr: toExpr(DateTime(2025)).equalsLiteral(DateTime(2025)),
    expected: true,
  ),
  (
    name: 'DateTime(2025).toUtc().equalsLiteral(DateTime(2025).toUtc())',
    expr: toExpr(DateTime(2025).toUtc()).equalsLiteral(DateTime(2025).toUtc()),
    expected: true,
  ),
  (
    name: 'DateTime(2024).equalsLiteral(DateTime(2025))',
    expr: toExpr(DateTime(2024)).equalsLiteral(DateTime(2025)),
    expected: false,
  ),
  (
    name: 'epoch.equalsLiteral(epoch)',
    expr: toExpr(epoch).equalsLiteral(epoch),
    expected: true,
  ),
  (
    name: 'epoch.equalsLiteral(DateTime(2025))',
    expr: toExpr(epoch).equalsLiteral(DateTime(2025)),
    expected: false,
  ),
  (
    name: 'epoch.equalsLiteral(today)',
    expr: toExpr(epoch).equalsLiteral(today),
    expected: false,
  ),
  (
    name: 'epoch.equalsLiteral(null)',
    expr: toExpr(epoch).equalsLiteral(null),
    expected: false,
  ),
  (
    name: 'today.equalsLiteral(null)',
    expr: toExpr(today).equalsLiteral(null),
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

  // Test for .notEqualsLiteral
  (
    name: 'DateTime(2025).notEqualsLiteral(DateTime(2025))',
    expr: toExpr(DateTime(2025)).notEqualsLiteral(DateTime(2025)),
    expected: false,
  ),
  (
    name: 'DateTime(2025).toUtc().notEqualsLiteral(DateTime(2025).toUtc())',
    expr:
        toExpr(DateTime(2025).toUtc()).notEqualsLiteral(DateTime(2025).toUtc()),
    expected: false,
  ),
  (
    name: 'DateTime(2024).notEqualsLiteral(DateTime(2025))',
    expr: toExpr(DateTime(2024)).notEqualsLiteral(DateTime(2025)),
    expected: true,
  ),
  (
    name: 'epoch.notEqualsLiteral(epoch)',
    expr: toExpr(epoch).notEqualsLiteral(epoch),
    expected: false,
  ),
  (
    name: 'epoch.notEqualsLiteral(DateTime(2025))',
    expr: toExpr(epoch).notEqualsLiteral(DateTime(2025)),
    expected: true,
  ),
  (
    name: 'epoch.notEqualsLiteral(today)',
    expr: toExpr(epoch).notEqualsLiteral(today),
    expected: true,
  ),
  (
    name: 'epoch.notEqualsLiteral(null)',
    expr: toExpr(epoch).notEqualsLiteral(null),
    expected: true,
  ),
  (
    name: 'today.notEqualsLiteral(null)',
    expr: toExpr(today).notEqualsLiteral(null),
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

  // Test for .isBeforeLiteral
  (
    name: 'DateTime(2024).isBeforeLiteral(DateTime(2025))',
    expr: toExpr(DateTime(2024)).isBeforeLiteral(DateTime(2025)),
    expected: true,
  ),
  (
    name: 'DateTime(2025).isBeforeLiteral(DateTime(2024))',
    expr: toExpr(DateTime(2025)).isBeforeLiteral(DateTime(2024)),
    expected: false,
  ),
  (
    name: 'DateTime(2025).isBeforeLiteral(DateTime(2025))',
    expr: toExpr(DateTime(2025)).isBeforeLiteral(DateTime(2025)),
    expected: false,
  ),
  (
    name: 'epoch.isBeforeLiteral(today)',
    expr: toExpr(epoch).isBeforeLiteral(today),
    expected: true,
  ),
  (
    name: 'today.isBeforeLiteral(epoch)',
    expr: toExpr(today).isBeforeLiteral(epoch),
    expected: false,
  ),
  (
    name: 'epoch.isBeforeLiteral(epoch)',
    expr: toExpr(epoch).isBeforeLiteral(epoch),
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

  // Test for .isAfterLiteral
  (
    name: 'DateTime(2024).isAfterLiteral(DateTime(2025))',
    expr: toExpr(DateTime(2024)).isAfterLiteral(DateTime(2025)),
    expected: false,
  ),
  (
    name: 'DateTime(2025).isAfterLiteral(DateTime(2024))',
    expr: toExpr(DateTime(2025)).isAfterLiteral(DateTime(2024)),
    expected: true,
  ),
  (
    name: 'DateTime(2025).isAfterLiteral(DateTime(2025))',
    expr: toExpr(DateTime(2025)).isAfterLiteral(DateTime(2025)),
    expected: false,
  ),
  (
    name: 'epoch.isAfterLiteral(today)',
    expr: toExpr(epoch).isAfterLiteral(today),
    expected: false,
  ),
  (
    name: 'today.isAfterLiteral(epoch)',
    expr: toExpr(today).isAfterLiteral(epoch),
    expected: true,
  ),
  (
    name: 'epoch.isAfterLiteral(epoch)',
    expr: toExpr(epoch).isAfterLiteral(epoch),
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
