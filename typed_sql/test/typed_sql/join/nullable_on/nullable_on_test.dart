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

import '../../testrunner.dart';

part 'nullable_on_test.g.dart';

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
        Expr<bool?> Function(Expr<Item> a, Expr<Item> b) on,
        List<(int, int)> expected,
      })
    >[
      // Use the first part's a nullable column directly as the ON condition.
      (
        name: '.on(a.value)',
        on: (a, b) => a.value,
        expected: [(1, 1), (1, 2), (1, 3)],
      ),

      // AND follows SQL three-valued logic in the ON clause.
      (
        name: '.on(a.value.and(b.value))',
        on: (a, b) => a.value.and(b.value),
        expected: [(1, 1)],
      ),

      // OR follows SQL three-valued logic in the ON clause.
      (
        name: '.on(a.value.or(b.value))',
        on: (a, b) => a.value.or(b.value),
        expected: [(1, 1), (1, 2), (1, 3), (2, 1), (3, 1)],
      ),

      // combined condition
      (
        name: '.on(a.id.equals(b.id).and(a.value))',
        on: (a, b) => a.id.equals(b.id).and(a.value),
        expected: [(1, 1)],
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

  Future<List<(int, int)>> joinOn(
    Database<TestDatabase> db,
    Expr<bool?> Function(Expr<Item> a, Expr<Item> b) conditionBuilder,
  ) async {
    final pairs = await db.items
        .join(db.items)
        .on(conditionBuilder)
        .select((a, b) => (a.id, b.id))
        .fetch();
    return pairs.toList()..sort((x, y) {
      final c = x.$1.compareTo(y.$1);
      return c != 0 ? c : x.$2.compareTo(y.$2);
    });
  }

  for (final c in _cases) {
    r.addTest(c.name, (db) async {
      check(await joinOn(db, c.on)).deepEquals(c.expected);
    });
  }

  r.run();
}
