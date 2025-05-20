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

part 'composite_key_test.g.dart';

abstract final class TestDatabase extends Schema {
  Table<Item> get items;
}

@PrimaryKey(['id', 'name'])
abstract final class Item extends Row {
  int get id;

  String get name;

  String? get value;
}

void main() {
  final r = TestRunner<TestDatabase>(
    setup: (db) async {
      await db.createTables();
    },
  );

  r.addTest('.insert() two with same ID, differnet name', (db) async {
    await db.items
        .insert(
          id: toExpr(1),
          name: toExpr('foo'),
        )
        .execute();
    await db.items
        .insert(
          id: toExpr(1),
          name: toExpr('bar'),
        )
        .execute();

    final items = await db.items.fetch();
    check(items).length.equals(2);
  });

  r.addTest('.insert() two with different ID, same name', (db) async {
    await db.items
        .insert(
          id: toExpr(1),
          name: toExpr('foo'),
        )
        .execute();
    await db.items
        .insert(
          id: toExpr(2),
          name: toExpr('foo'),
        )
        .execute();

    final items = await db.items.fetch();
    check(items).length.equals(2);
  });

  r.addTest('.byKey()', (db) async {
    await db.items
        .insert(
          id: toExpr(1),
          name: toExpr('foo'),
        )
        .execute();

    final item = await db.items.byKey(1, 'foo').fetch();
    check(item).isNotNull().name.equals('foo');
  });

  r.addTest('.update()', (db) async {
    await db.items
        .insert(
          id: toExpr(1),
          name: toExpr('foo'),
          value: toExpr('old-value'),
        )
        .execute();

    await db.items
        .byKey(1, 'foo')
        .update((item, set) => set(value: toExpr('new-value')))
        .execute();

    final item = await db.items.byKey(1, 'foo').fetch();
    check(item).isNotNull().value.equals('new-value');
  });

  r.addTest('.delete()', (db) async {
    await db.items
        .insert(
          id: toExpr(1),
          name: toExpr('foo'),
          value: toExpr('old-value'),
        )
        .execute();

    await db.items.byKey(1, 'foo').delete().execute();

    final item = await db.items.byKey(1, 'foo').fetch();
    check(item).isNull();
  });

  r.run();
}
