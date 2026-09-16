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

part 'upsert_value_test.g.dart';

abstract final class UpsertValueDatabase extends Schema {
  Table<UpsertValueItem> get items;

  Table<UpsertValueLink> get links;
}

@PrimaryKey(['id'])
abstract final class UpsertValueItem extends Row {
  @AutoIncrement()
  int get id;

  String get name;

  int get value;

  String? get note;
}

@PrimaryKey(['a', 'b'])
abstract final class UpsertValueLink extends Row {
  int get a;
  int get b;
}

void main() {
  final r = TestRunner<UpsertValueDatabase>(
    setup: (db) async {
      await db.createTables();
    },
  );

  r.addTest(
    '.upsertValue() inserts when no conflict exists',
    (db) async {
      await db.items
          .upsertValue(id: 1, name: 'A', value: 10, note: null)
          .execute();
      final item = await db.items.byKey(1).fetch();
      check(item).isNotNull().name.equals('A');
      check(item).isNotNull().value.equals(10);
    },
    skipMysql: 'mysql does not support ON CONFLICT clauses',
  );

  r.addTest(
    '.upsertValue() updates non-primary-key fields on primary key conflict',
    (db) async {
      await db.items
          .upsertValue(id: 1, name: 'A', value: 10, note: 'first')
          .execute();
      await db.items
          .upsertValue(id: 1, name: 'B', value: 20, note: 'second')
          .execute();

      final item = await db.items.byKey(1).fetch();
      check(item).isNotNull().name.equals('B');
      check(item).isNotNull().value.equals(20);
      check(item).isNotNull().note.equals('second');
    },
    skipMysql: 'mysql does not support ON CONFLICT clauses',
  );

  r.addTest(
    '.upsertValue() leaves the primary key untouched',
    (db) async {
      await db.items
          .upsertValue(id: 1, name: 'A', value: 10, note: null)
          .execute();
      await db.items
          .upsertValue(id: 1, name: 'B', value: 20, note: null)
          .execute();

      final count = await db.items.count().fetch();
      check(count).equals(1);
    },
    skipMysql: 'mysql does not support ON CONFLICT clauses',
  );

  r.addTest(
    '.upsertValue() on all-primary-key row is a no-op update on conflict',
    (db) async {
      await db.links.upsertValue(a: 1, b: 2).execute();
      // Should not throw, even though there is nothing to update.
      await db.links.upsertValue(a: 1, b: 2).execute();

      final count = await db.links.count().fetch();
      check(count).equals(1);
    },
    skipMysql: 'mysql does not support ON CONFLICT clauses',
  );

  r.run();
}
