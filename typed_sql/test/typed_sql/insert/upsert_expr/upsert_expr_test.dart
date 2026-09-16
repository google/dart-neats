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

part 'upsert_expr_test.g.dart';

abstract final class UpsertExprDatabase extends Schema {
  Table<UpsertExprItem> get items;

  Table<UpsertExprLink> get links;
}

@PrimaryKey(['id'])
abstract final class UpsertExprItem extends Row {
  @AutoIncrement()
  int get id;

  String get name;

  int get value;

  @DefaultValue('none')
  String get note;
}

@PrimaryKey(['a', 'b'])
abstract final class UpsertExprLink extends Row {
  int get a;
  int get b;
}

void main() {
  final r = TestRunner<UpsertExprDatabase>(
    setup: (db) async {
      await db.createTables();
    },
  );

  r.addTest(
    '.upsert() inserts when no conflict exists',
    (db) async {
      await db.items
          .upsert(
            id: toExpr(1),
            name: toExpr('A'),
            value: toExpr(10),
            note: toExpr('first'),
          )
          .execute();

      final item = await db.items.byKey(1).fetch();
      check(item).isNotNull().name.equals('A');
      check(item).isNotNull().value.equals(10);
      check(item).isNotNull().note.equals('first');
    },
    skipMysql: 'mysql does not support ON CONFLICT clauses',
  );

  r.addTest(
    '.upsert() updates non-primary-key fields on primary key conflict',
    (db) async {
      await db.items
          .upsert(
            id: toExpr(1),
            name: toExpr('A'),
            value: toExpr(10),
            note: toExpr('first'),
          )
          .execute();
      await db.items
          .upsert(
            id: toExpr(1),
            name: toExpr('B'),
            value: toExpr(20),
            note: toExpr('second'),
          )
          .execute();

      final item = await db.items.byKey(1).fetch();
      check(item).isNotNull().name.equals('B');
      check(item).isNotNull().value.equals(20);
      check(item).isNotNull().note.equals('second');

      final count = await db.items.count().fetch();
      check(count).equals(1);
    },
    skipMysql: 'mysql does not support ON CONFLICT clauses',
  );

  r.addTest(
    '.upsert() inserts the _default value_ for omitted fields',
    (db) async {
      await db.items
          .upsert(id: toExpr(1), name: toExpr('A'), value: toExpr(10))
          .execute();

      final item = await db.items.byKey(1).fetch();
      check(item).isNotNull().note.equals('none');
    },
    skipMysql: 'mysql does not support ON CONFLICT clauses',
  );

  r.addTest(
    '.upsert() supports arbitrary expressions',
    (db) async {
      await db.items
          .upsert(
            id: toExpr(1),
            name: toExpr('A'),
            value: toExpr(10),
            note: toExpr('first'),
          )
          .execute();
      await db.items
          .upsert(
            id: toExpr(1),
            name: toExpr('B'),
            value: toExpr(20) + toExpr(2),
            note: toExpr('first'),
          )
          .execute();

      final item = await db.items.byKey(1).fetch();
      check(item).isNotNull().name.equals('B');
      check(item).isNotNull().value.equals(22);
    },
    skipMysql: 'mysql does not support ON CONFLICT clauses',
  );

  r.addTest(
    '.upsert() on all-primary-key row is a no-op update on conflict',
    (db) async {
      await db.links.upsert(a: toExpr(1), b: toExpr(2)).execute();
      // Should not throw, even though there is nothing to update.
      await db.links.upsert(a: toExpr(1), b: toExpr(2)).execute();

      final count = await db.links.count().fetch();
      check(count).equals(1);
    },
    skipMysql: 'mysql does not support ON CONFLICT clauses',
  );

  r.run();
}
