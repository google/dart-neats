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

final _cases = <({
  String name,
  Expr expr,
  Object? expected,
})>[
  // Tests for null and DateTime
  (
    name: 'epoch as DateTime?',
    expr: literal(epoch as DateTime?),
    expected: epoch,
  ),
  (
    name: 'null as DateTime?',
    expr: literal(null as DateTime?),
    expected: null,
  ),
  (
    name: '(null as DateTime?).orElse(epoch)',
    expr: literal(null as DateTime?).orElse(literal(epoch)),
    expected: epoch,
  ),
  (
    name: '(null as DateTime?).orElseLiteral(epoch)',
    expr: literal(null as DateTime?).orElseLiteral(epoch),
    expected: epoch,
  ),
  (
    name: '(today as DateTime?).orElse(epoch)',
    expr: literal(today as DateTime?).orElse(literal(epoch)),
    expected: today,
  ),
  (
    name: '(today as DateTime?).orElseLiteral(epoch)',
    expr: literal(today as DateTime?).orElseLiteral(epoch),
    expected: today,
  ),
  (
    name: 'null.asDateTime()',
    expr: literal(null).asDateTime(),
    expected: null,
  ),
  (
    name: 'null.asDateTime().orElse(epoch)',
    expr: literal(null).asDateTime().orElse(literal(epoch)),
    expected: epoch,
  ),
  (
    name: 'null.asDateTime().orElseLiteral(epoch)',
    expr: literal(null).asDateTime().orElseLiteral(epoch),
    expected: epoch,
  ),
  // Expr<DateTime?>.equals
  (
    name: 'null.asDateTime().equals(null)',
    expr: literal(null).asDateTime().equals(literal(null)),
    expected: true,
  ),
  (
    name: 'null.asDateTime().equals(epoch)',
    expr: literal(null).asDateTime().equals(literal(epoch)),
    expected: false,
  ),
  (
    name: 'epoch.equals(null)',
    expr: literal(epoch as DateTime?).equals(literal(null)),
    expected: false,
  ),
  (
    name: 'epoch.equals(epoch)',
    expr: literal(epoch as DateTime?).equals(literal(epoch)),
    expected: true,
  ),
  (
    name: 'null.asDateTime().equals(today)',
    expr: literal(null).asDateTime().equals(literal(today)),
    expected: false,
  ),
  (
    name: 'today.equals(null)',
    expr: literal(today as DateTime?).equals(literal(null)),
    expected: false,
  ),
  (
    name: 'today.equals(today)',
    expr: literal(today as DateTime?).equals(literal(today)),
    expected: true,
  ),

  // Expr<DateTime?>.notEquals
  (
    name: 'null.asDateTime().notEquals(null)',
    expr: literal(null).asDateTime().notEquals(literal(null)),
    expected: false,
  ),
  (
    name: 'null.asDateTime().notEquals(epoch)',
    expr: literal(null).asDateTime().notEquals(literal(epoch)),
    expected: true,
  ),
  (
    name: 'epoch.notEquals(null)',
    expr: literal(epoch as DateTime?).notEquals(literal(null)),
    expected: true,
  ),
  (
    name: 'epoch.notEquals(epoch)',
    expr: literal(epoch as DateTime?).notEquals(literal(epoch)),
    expected: false,
  ),
  (
    name: 'null.asDateTime().notEquals(today)',
    expr: literal(null).asDateTime().notEquals(literal(today)),
    expected: true,
  ),
  (
    name: 'today.notEquals(null)',
    expr: literal(today as DateTime?).notEquals(literal(null)),
    expected: true,
  ),
  (
    name: 'today.notEquals(today)',
    expr: literal(today as DateTime?).notEquals(literal(today)),
    expected: false,
  ),
  // Expr<DateTime?>.equalsLiteral
  (
    name: 'null.asDateTime().equalsLiteral(null)',
    expr: literal(null).asDateTime().equalsLiteral(null),
    expected: true,
  ),
  (
    name: 'null.asDateTime().equalsLiteral(epoch)',
    expr: literal(null).asDateTime().equalsLiteral(epoch),
    expected: false,
  ),
  (
    name: 'epoch.equalsLiteral(null)',
    expr: literal(epoch as DateTime?).equalsLiteral(null),
    expected: false,
  ),
  (
    name: 'epoch.equalsLiteral(epoch)',
    expr: literal(epoch as DateTime?).equalsLiteral(epoch),
    expected: true,
  ),
  (
    name: 'null.asDateTime().equalsLiteral(today)',
    expr: literal(null).asDateTime().equalsLiteral(today),
    expected: false,
  ),
  (
    name: 'today.equalsLiteral(null)',
    expr: literal(today as DateTime?).equalsLiteral(null),
    expected: false,
  ),
  (
    name: 'today.equalsLiteral(today)',
    expr: literal(today as DateTime?).equalsLiteral(today),
    expected: true,
  ),
  // Expr<DateTime?>.notEqualsLiteral
  (
    name: 'null.asDateTime().notEqualsLiteral(null)',
    expr: literal(null).asDateTime().notEqualsLiteral(null),
    expected: false,
  ),
  (
    name: 'null.asDateTime().notEqualsLiteral(epoch)',
    expr: literal(null).asDateTime().notEqualsLiteral(epoch),
    expected: true,
  ),
  (
    name: 'epoch.notEqualsLiteral(null)',
    expr: literal(epoch as DateTime?).notEqualsLiteral(null),
    expected: true,
  ),
  (
    name: 'epoch.notEqualsLiteral(epoch)',
    expr: literal(epoch as DateTime?).notEqualsLiteral(epoch),
    expected: false,
  ),
  (
    name: 'null.asDateTime().notEqualsLiteral(today)',
    expr: literal(null).asDateTime().notEqualsLiteral(today),
    expected: true,
  ),
  (
    name: 'today.notEqualsLiteral(null)',
    expr: literal(today as DateTime?).notEqualsLiteral(null),
    expected: true,
  ),
  (
    name: 'today.notEqualsLiteral(today)',
    expr: literal(today as DateTime?).notEqualsLiteral(today),
    expected: false,
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
