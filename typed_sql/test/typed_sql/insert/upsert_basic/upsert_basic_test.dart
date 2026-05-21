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

part 'upsert_basic_test.g.dart';

abstract final class BasicDatabase extends Schema {
  Table<BasicItem> get basicItems;
}

@PrimaryKey(['id'])
abstract final class BasicItem extends Row {
  @AutoIncrement()
  int get id;

  @Unique.field()
  @SqlOverride.field(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String get name;

  int get value;
}

void main() {
  final r = TestRunner<BasicDatabase>(
    setup: (db) async {
      await db.createTables();
    },
  );

  r.addTest(
    '.insertValue() with .onConflict().doNothing()',
    (db) async {
      await db.basicItems.insertValue(id: 1, name: 'A', value: 10).execute();
      await db.basicItems
          .insertValue(id: 1, name: 'B', value: 20)
          .onConflict(BasicItemConflict.primaryKey)
          .doNothing()
          .execute();
      final item = await db.basicItems.byKey(1).fetch();
      check(item).isNotNull().name.equals('A');
      check(item).isNotNull().value.equals(10);
    },
    skipMysql: 'mysql does not support ON CONFLICT clauses',
  );

  r.addTest(
    '.insert() with .onConflict().doNothing()',
    (db) async {
      await db.basicItems.insertValue(id: 1, name: 'A', value: 10).execute();
      await db.basicItems
          .insert(id: toExpr(1), name: toExpr('B'), value: toExpr(20))
          .onConflict(BasicItemConflict.primaryKey)
          .doNothing()
          .execute();
      final item = await db.basicItems.byKey(1).fetch();
      check(item).isNotNull().name.equals('A');
      check(item).isNotNull().value.equals(10);
    },
    skipMysql: 'mysql does not support ON CONFLICT clauses',
  );

  r.addTest(
    '.insertValue() with .onConflict().update()',
    (db) async {
      await db.basicItems.insertValue(id: 1, name: 'A', value: 10).execute();
      await db.basicItems
          .insertValue(id: 1, name: 'B', value: 20)
          .onConflict(BasicItemConflict.primaryKey)
          .update((item, excluded, set) => set(value: excluded.value))
          .execute();
      final item = await db.basicItems.byKey(1).fetch();
      check(item).isNotNull().value.equals(20);
    },
    skipMysql: 'mysql does not support ON CONFLICT clauses',
  );

  r.addTest(
    '.insert() with .onConflict().update()',
    (db) async {
      await db.basicItems.insertValue(id: 1, name: 'A', value: 10).execute();
      await db.basicItems
          .insert(id: toExpr(1), name: toExpr('B'), value: toExpr(20))
          .onConflict(BasicItemConflict.primaryKey)
          .update((item, excluded, set) => set(value: excluded.value))
          .execute();
      final item = await db.basicItems.byKey(1).fetch();
      check(item).isNotNull().value.equals(20);
    },
    skipMysql: 'mysql does not support ON CONFLICT clauses',
  );

  r.run();
}
