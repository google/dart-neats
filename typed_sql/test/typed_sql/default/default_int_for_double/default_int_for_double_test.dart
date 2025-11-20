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

import '../../testrunner.dart';

part 'default_int_for_double_test.g.dart';

abstract final class TestDatabase extends Schema {
  Table<Item> get items;
}

@PrimaryKey(['id'])
abstract final class Item extends Row {
  @AutoIncrement()
  int get id;

  @DefaultValue(0)
  double get value;
}

void main() {
  final r = TestRunner<TestDatabase>(
    setup: (db) async {
      await db.createTables();
    },
  );

  r.addTest('.insert() without default', (db) async {
    await db.items
        .insert(
          id: toExpr(1),
          value: toExpr(3.14),
        )
        .execute();

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.equals(3.14);
  });

  r.addTest('.insert() with default', (db) async {
    await db.items
        .insert(
          id: toExpr(1),
        )
        .execute();

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.equals(0.0);
  });

  r.addTest('.update() default value', (db) async {
    await db.items
        .insert(
          id: toExpr(1),
        )
        .execute();

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.equals(0.0);

    await db.items
        .byKey(1)
        .update((item, set) => set(
              value: toExpr(3.14),
            ))
        .execute();

    final updateItem = await db.items.first.fetch();
    check(updateItem).isNotNull().value.equals(3.14);
  });

  r.run();
}
