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

part 'autoincrement_test.g.dart';

abstract final class TestDatabase extends Schema {
  Table<Item> get items;
}

@PrimaryKey(['id'])
abstract final class Item extends Model {
  @AutoIncrement()
  int get id;

  String get value;
}

void main() {
  final r = TestRunner<TestDatabase>(
    setup: (db) async {
      await db.createTables();
    },
  );

  r.addTest('.insert() with explicit ID', (db) async {
    await db.items
        .insert(
          id: literal(1),
          value: literal('hello'),
        )
        .execute();

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.equals('hello');

    // Check that we can find it by value
    final items = await db.items
        .where((item) => item.value.equals(literal('hello')))
        .fetch();
    check(items).length.equals(1);
    check(items).first
      ..id.equals(1)
      ..value.equals('hello');
  });

  r.addTest('.insertLiteral() with explicit ID', (db) async {
    await db.items
        .insertLiteral(
          id: 1,
          value: 'hello',
        )
        .execute();

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.equals('hello');

    // Check that we can find it by value
    final items = await db.items
        .where((item) => item.value.equals(literal('hello')))
        .fetch();
    check(items).length.equals(1);
    check(items).first
      ..id.equals(1)
      ..value.equals('hello');
  });

  r.addTest('.insert() auto-incremented IDs', (db) async {
    await db.items
        .insert(
          value: literal('hello'),
        )
        .execute();

    await db.items
        .insert(
          value: literal('world'),
        )
        .execute();

    final items = await db.items.fetch();
    check(items).length.equals(2);
    // Note: Auto-increment won't necessarily start from 1 or 0, and may skip
    //       values, in practice it probably won't but let's not rely on such
    //       behavior in our tests.
    check(items.map((i) => i.id).toSet()).length.equals(2);
  });

  r.addTest('.insertLiteral() auto-incremented IDs', (db) async {
    await db.items
        .insertLiteral(
          value: 'hello',
        )
        .execute();

    await db.items
        .insertLiteral(
          value: 'world',
        )
        .execute();

    final items = await db.items.fetch();
    check(items).length.equals(2);
    // Note: Auto-increment won't necessarily start from 1 or 0, and may skip
    //       values, in practice it probably won't but let's not rely on such
    //       behavior in our tests.
    check(items.map((i) => i.id).toSet()).length.equals(2);
  });

  r.run();
}
