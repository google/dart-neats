// Copyright 2026 Google LLC
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

part 'nullable_bool_where_test.g.dart';

abstract final class TestDatabase extends Schema {
  Table<Item> get items;
}

@PrimaryKey(['id'])
abstract final class Item extends Row {
  int get id;
  bool? get value;
}

final _cases =
    <
      ({
        String name,
        Expr<bool?> Function(Expr<Item> item) where,
        List<int> expected,
      })
    >[
      // use column value as-is
      (
        name: '.where(.value)',
        where: (item) => item.value,
        expected: [1],
      ),

      // AND expression is evaluated
      (
        name: '.where(.value.and(true))',
        where: (item) => item.value.and(toExpr(true)),
        expected: [1],
      ),
      (
        name: '.where(.value.and(false))',
        where: (item) => item.value.and(toExpr(false)),
        expected: <int>[],
      ),
      (
        name: '.where(.value.and(null))',
        where: (item) => item.value.and(toExpr(null as bool?)),
        expected: <int>[],
      ),

      // OR expression is evaluated
      (
        name: '.where(.value.or(true))',
        where: (item) => item.value.or(toExpr(true)),
        expected: [1, 2, 3],
      ),
      (
        name: '.where(.value.or(false))',
        where: (item) => item.value.or(toExpr(false)),
        expected: [1],
      ),
      (
        name: '.where(.value.or(null))',
        where: (item) => item.value.or(toExpr(null as bool?)),
        expected: [1],
      ),

      // combined evaluations
      (
        name: '.where(.value & .value)',
        where: (item) => item.value & item.value,
        expected: [1],
      ),
      (
        name: '.where(.id.equalsValue(1) & .value)',
        where: (item) => item.id.equalsValue(1).and(item.value),
        expected: [1],
      ),
    ];

void main() {
  // Insert a row for each possible value of a nullable boolean: TRUE, FALSE and NULL.
  // Using the `id` for easier sanity checks.
  final r = TestRunner<TestDatabase>(
    setup: (db) async {
      await db.createTables();
      await db.items.insert(id: toExpr(1), value: toExpr(true)).execute();
      await db.items.insert(id: toExpr(2), value: toExpr(false)).execute();
      await db.items.insert(id: toExpr(3), value: toExpr(null)).execute();
    },
  );

  Future<List<int>> idsWhere(
    Database<TestDatabase> db,
    Expr<bool?> Function(Expr<Item> item) conditionBuilder,
  ) async {
    final ids = await db.items
        .where(conditionBuilder)
        .select((item) => (item.id,))
        .fetch();
    return ids.toList()..sort();
  }

  for (final c in _cases) {
    r.addTest(c.name, (db) async {
      check(await idsWhere(db, c.where)).deepEquals(c.expected);
    });
  }

  r.run();
}
