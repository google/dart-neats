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

part 'text_key_test.g.dart';

abstract final class TestDatabase extends Schema {
  Table<Item> get items;
}

@PrimaryKey(['key'])
abstract final class Item extends Model {
  String get key;

  String get value;
}

void main() {
  final r = TestRunner<TestDatabase>(
    setup: (db) async {
      await db.createTables();
    },
  );

  r.addTest('.insert() two with differnet keys', (db) async {
    await db.items
        .insert(
          key: literal('A'),
          value: literal('hello'),
        )
        .execute();
    await db.items
        .insert(
          key: literal('B'),
          value: literal('world'),
        )
        .execute();

    final items = await db.items.fetch();
    check(items).length.equals(2);
  });

  r.addTest('.insert() two same keys (conflict)', (db) async {
    await db.items
        .insert(
          key: literal('A'),
          value: literal('hello'),
        )
        .execute();

    try {
      await db.items
          .insert(
            key: literal('A'),
            value: literal('world'),
          )
          .execute();
    } on Exception {
      return;
    }
    check(false, because: 'must be unreachable').isTrue();
  });

  r.addTest('.byKey()', (db) async {
    await db.items
        .insert(
          key: literal('A'),
          value: literal('hello'),
        )
        .execute();

    final item = await db.items.byKey(key: 'A').fetch();
    check(item).isNotNull().value.equals('hello');
  });

  r.run();
}
