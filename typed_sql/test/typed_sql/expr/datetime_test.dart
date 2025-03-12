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
final today = DateTime.parse('2025-03-10T11:34:36.164006Z');

final _cases = [
  // Test for .equals
  (
    name: 'DateTime(2025).equals(DateTime(2025))',
    expr: literal(DateTime(2025)).equals(literal(DateTime(2025))),
    expected: true,
  ),
  (
    name: 'DateTime(2025).toUtc().equals(DateTime(2025).toUtc())',
    expr:
        literal(DateTime(2025).toUtc()).equals(literal(DateTime(2025).toUtc())),
    expected: true,
  ),
  (
    name: 'DateTime(2024).equals(DateTime(2025))',
    expr: literal(DateTime(2024)).equals(literal(DateTime(2025))),
    expected: false,
  ),
  (
    name: 'epoch.equals(epoch)',
    expr: literal(epoch).equals(literal(epoch)),
    expected: true,
  ),
  (
    name: 'epoch.equals(DateTime(2025))',
    expr: literal(epoch).equals(literal(DateTime(2025))),
    expected: false,
  ),
  (
    name: 'epoch.equals(today)',
    expr: literal(epoch).equals(literal(today)),
    expected: false,
  ),

  // Test for .equalsLiteral
  (
    name: 'DateTime(2025).equalsLiteral(DateTime(2025))',
    expr: literal(DateTime(2025)).equalsLiteral(DateTime(2025)),
    expected: true,
  ),
  (
    name: 'DateTime(2025).toUtc().equalsLiteral(DateTime(2025).toUtc())',
    expr: literal(DateTime(2025).toUtc()).equalsLiteral(DateTime(2025).toUtc()),
    expected: true,
  ),
  (
    name: 'DateTime(2024).equalsLiteral(DateTime(2025))',
    expr: literal(DateTime(2024)).equalsLiteral(DateTime(2025)),
    expected: false,
  ),
  (
    name: 'epoch.equalsLiteral(epoch)',
    expr: literal(epoch).equalsLiteral(epoch),
    expected: true,
  ),
  (
    name: 'epoch.equalsLiteral(DateTime(2025))',
    expr: literal(epoch).equalsLiteral(DateTime(2025)),
    expected: false,
  ),
  (
    name: 'epoch.equalsLiteral(today)',
    expr: literal(epoch).equalsLiteral(today),
    expected: false,
  ),

  // Test for .notEquals
  (
    name: 'DateTime(2025).notEquals(DateTime(2025))',
    expr: literal(DateTime(2025)).notEquals(literal(DateTime(2025))),
    expected: false,
  ),
  (
    name: 'DateTime(2025).toUtc().notEquals(DateTime(2025).toUtc())',
    expr: literal(DateTime(2025).toUtc())
        .notEquals(literal(DateTime(2025).toUtc())),
    expected: false,
  ),
  (
    name: 'DateTime(2024).notEquals(DateTime(2025))',
    expr: literal(DateTime(2024)).notEquals(literal(DateTime(2025))),
    expected: true,
  ),
  (
    name: 'epoch.notEquals(epoch)',
    expr: literal(epoch).notEquals(literal(epoch)),
    expected: false,
  ),
  (
    name: 'epoch.notEquals(DateTime(2025))',
    expr: literal(epoch).notEquals(literal(DateTime(2025))),
    expected: true,
  ),
  (
    name: 'epoch.notEquals(today)',
    expr: literal(epoch).notEquals(literal(today)),
    expected: true,
  ),

  // Test for .notEqualsLiteral
  (
    name: 'DateTime(2025).notEqualsLiteral(DateTime(2025))',
    expr: literal(DateTime(2025)).notEqualsLiteral(DateTime(2025)),
    expected: false,
  ),
  (
    name: 'DateTime(2025).toUtc().notEqualsLiteral(DateTime(2025).toUtc())',
    expr: literal(DateTime(2025).toUtc())
        .notEqualsLiteral(DateTime(2025).toUtc()),
    expected: false,
  ),
  (
    name: 'DateTime(2024).notEqualsLiteral(DateTime(2025))',
    expr: literal(DateTime(2024)).notEqualsLiteral(DateTime(2025)),
    expected: true,
  ),
  (
    name: 'epoch.notEqualsLiteral(epoch)',
    expr: literal(epoch).notEqualsLiteral(epoch),
    expected: false,
  ),
  (
    name: 'epoch.notEqualsLiteral(DateTime(2025))',
    expr: literal(epoch).notEqualsLiteral(DateTime(2025)),
    expected: true,
  ),
  (
    name: 'epoch.notEqualsLiteral(today)',
    expr: literal(epoch).notEqualsLiteral(today),
    expected: true,
  ),

  // Test for .isBefore
  (
    name: 'DateTime(2024).isBefore(DateTime(2025))',
    expr: literal(DateTime(2024)).isBefore(literal(DateTime(2025))),
    expected: true,
  ),
  (
    name: 'DateTime(2025).isBefore(DateTime(2024))',
    expr: literal(DateTime(2025)).isBefore(literal(DateTime(2024))),
    expected: false,
  ),
  (
    name: 'DateTime(2025).isBefore(DateTime(2025))',
    expr: literal(DateTime(2025)).isBefore(literal(DateTime(2025))),
    expected: false,
  ),
  (
    name: 'epoch.isBefore(today)',
    expr: literal(epoch).isBefore(literal(today)),
    expected: true,
  ),
  (
    name: 'today.isBefore(epoch)',
    expr: literal(today).isBefore(literal(epoch)),
    expected: false,
  ),
  (
    name: 'epoch.isBefore(epoch)',
    expr: literal(epoch).isBefore(literal(epoch)),
    expected: false,
  ),

  // Test for .isBeforeLiteral
  (
    name: 'DateTime(2024).isBeforeLiteral(DateTime(2025))',
    expr: literal(DateTime(2024)).isBeforeLiteral(DateTime(2025)),
    expected: true,
  ),
  (
    name: 'DateTime(2025).isBeforeLiteral(DateTime(2024))',
    expr: literal(DateTime(2025)).isBeforeLiteral(DateTime(2024)),
    expected: false,
  ),
  (
    name: 'DateTime(2025).isBeforeLiteral(DateTime(2025))',
    expr: literal(DateTime(2025)).isBeforeLiteral(DateTime(2025)),
    expected: false,
  ),
  (
    name: 'epoch.isBeforeLiteral(today)',
    expr: literal(epoch).isBeforeLiteral(today),
    expected: true,
  ),
  (
    name: 'today.isBeforeLiteral(epoch)',
    expr: literal(today).isBeforeLiteral(epoch),
    expected: false,
  ),
  (
    name: 'epoch.isBeforeLiteral(epoch)',
    expr: literal(epoch).isBeforeLiteral(epoch),
    expected: false,
  ),

  // Test for <
  (
    name: 'DateTime(2024) < DateTime(2025)',
    expr: literal(DateTime(2024)) < literal(DateTime(2025)),
    expected: true,
  ),
  (
    name: 'DateTime(2025) < DateTime(2024)',
    expr: literal(DateTime(2025)) < literal(DateTime(2024)),
    expected: false,
  ),
  (
    name: 'DateTime(2025) < DateTime(2025)',
    expr: literal(DateTime(2025)) < literal(DateTime(2025)),
    expected: false,
  ),
  (
    name: 'epoch < today',
    expr: literal(epoch) < literal(today),
    expected: true,
  ),
  (
    name: 'today < epoch',
    expr: literal(today) < literal(epoch),
    expected: false,
  ),
  (
    name: 'epoch < epoch',
    expr: literal(epoch) < literal(epoch),
    expected: false,
  ),

  // Test for .isAfter
  (
    name: 'DateTime(2024).isAfter(DateTime(2025))',
    expr: literal(DateTime(2024)).isAfter(literal(DateTime(2025))),
    expected: false,
  ),
  (
    name: 'DateTime(2025).isAfter(DateTime(2024))',
    expr: literal(DateTime(2025)).isAfter(literal(DateTime(2024))),
    expected: true,
  ),
  (
    name: 'DateTime(2025).isAfter(DateTime(2025))',
    expr: literal(DateTime(2025)).isAfter(literal(DateTime(2025))),
    expected: false,
  ),
  (
    name: 'epoch.isAfter(today)',
    expr: literal(epoch).isAfter(literal(today)),
    expected: false,
  ),
  (
    name: 'today.isAfter(epoch)',
    expr: literal(today).isAfter(literal(epoch)),
    expected: true,
  ),
  (
    name: 'epoch.isAfter(epoch)',
    expr: literal(epoch).isAfter(literal(epoch)),
    expected: false,
  ),

  // Test for .isAfterLiteral
  (
    name: 'DateTime(2024).isAfterLiteral(DateTime(2025))',
    expr: literal(DateTime(2024)).isAfterLiteral(DateTime(2025)),
    expected: false,
  ),
  (
    name: 'DateTime(2025).isAfterLiteral(DateTime(2024))',
    expr: literal(DateTime(2025)).isAfterLiteral(DateTime(2024)),
    expected: true,
  ),
  (
    name: 'DateTime(2025).isAfterLiteral(DateTime(2025))',
    expr: literal(DateTime(2025)).isAfterLiteral(DateTime(2025)),
    expected: false,
  ),
  (
    name: 'epoch.isAfterLiteral(today)',
    expr: literal(epoch).isAfterLiteral(today),
    expected: false,
  ),
  (
    name: 'today.isAfterLiteral(epoch)',
    expr: literal(today).isAfterLiteral(epoch),
    expected: true,
  ),
  (
    name: 'epoch.isAfterLiteral(epoch)',
    expr: literal(epoch).isAfterLiteral(epoch),
    expected: false,
  ),

  // Test for >
  (
    name: 'DateTime(2024) > DateTime(2025)',
    expr: literal(DateTime(2024)) > literal(DateTime(2025)),
    expected: false,
  ),
  (
    name: 'DateTime(2025) > DateTime(2024)',
    expr: literal(DateTime(2025)) > literal(DateTime(2024)),
    expected: true,
  ),
  (
    name: 'DateTime(2025) > DateTime(2025)',
    expr: literal(DateTime(2025)) > literal(DateTime(2025)),
    expected: false,
  ),
  (
    name: 'epoch > today',
    expr: literal(epoch) > literal(today),
    expected: false,
  ),
  (
    name: 'today > epoch',
    expr: literal(today) > literal(epoch),
    expected: true,
  ),
  (
    name: 'epoch > epoch',
    expr: literal(epoch) > literal(epoch),
    expected: false,
  ),

  // Test for <=
  (
    name: 'DateTime(2024) <= DateTime(2025)',
    expr: literal(DateTime(2024)) <= literal(DateTime(2025)),
    expected: true,
  ),
  (
    name: 'DateTime(2025) <= DateTime(2024)',
    expr: literal(DateTime(2025)) <= literal(DateTime(2024)),
    expected: false,
  ),
  (
    name: 'DateTime(2025) <= DateTime(2025)',
    expr: literal(DateTime(2025)) <= literal(DateTime(2025)),
    expected: true,
  ),
  (
    name: 'epoch <= today',
    expr: literal(epoch) <= literal(today),
    expected: true,
  ),
  (
    name: 'today <= epoch',
    expr: literal(today) <= literal(epoch),
    expected: false,
  ),
  (
    name: 'epoch <= epoch',
    expr: literal(epoch) <= literal(epoch),
    expected: true,
  ),

  // Test for >=
  (
    name: 'DateTime(2024) >= DateTime(2025)',
    expr: literal(DateTime(2024)) >= literal(DateTime(2025)),
    expected: false,
  ),
  (
    name: 'DateTime(2025) >= DateTime(2024)',
    expr: literal(DateTime(2025)) >= literal(DateTime(2024)),
    expected: true,
  ),
  (
    name: 'DateTime(2025) >= DateTime(2025)',
    expr: literal(DateTime(2025)) >= literal(DateTime(2025)),
    expected: true,
  ),
  (
    name: 'epoch >= today',
    expr: literal(epoch) >= literal(today),
    expected: false,
  ),
  (
    name: 'today >= epoch',
    expr: literal(today) >= literal(epoch),
    expected: true,
  ),
  (
    name: 'epoch >= epoch',
    expr: literal(epoch) >= literal(epoch),
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
