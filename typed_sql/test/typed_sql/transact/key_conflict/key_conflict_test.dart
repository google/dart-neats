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

import 'package:typed_sql/adaptor.dart';
import 'package:typed_sql/typed_sql.dart';

import '../../testrunner.dart';

part 'key_conflict_test.g.dart';

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

  r.addTest('.insert()', (db) async {
    await db.items.insertLiteral(id: 1, value: 'a').execute();
    await db.items.insertLiteral(id: 2, value: 'b').execute();
  });

  r.addTest('.insert() conflicting keys', (db) async {
    await db.items.insertLiteral(id: 1, value: 'a').execute();
    await check(
      db.items.insertLiteral(id: 1, value: 'b').execute(),
    ).throws((e) => e.isA<DatabaseQueryException>());

    final item = await db.items.byKey(id: 1).fetch();
    check(item).isNotNull().value.equals('a');
  });

  r.addTest('.insert() recover from conflict', (db) async {
    await db.transact(() async {
      await db.items.insertLiteral(id: 1, value: 'a').execute();
      await check(
        db.transact(() async {
          await db.items.insertLiteral(id: 1, value: 'b').execute();
        }),
      ).throws((e) => e.isA<DatabaseQueryException>());
    });

    final item = await db.items.byKey(id: 1).fetch();
    check(item).isNotNull().value.equals('a');
  });

  // TODO: Test racing transactions and other fun stuff!

  r.run();
}
