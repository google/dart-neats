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

part 'upsert_subquery_test.g.dart';

abstract final class SubQueryDatabase extends Schema {
  Table<SourceItem> get sourceItems;
  Table<SubQueryItem> get subQueryItems;
}

@PrimaryKey(['id'])
abstract final class SourceItem extends Row {
  @AutoIncrement()
  int get id;

  String get value;
}

@PrimaryKey(['id'])
abstract final class SubQueryItem extends Row {
  @AutoIncrement()
  int get id;

  @Unique.field()
  @SqlOverride.field(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String get tag;

  @References(table: 'sourceItems', field: 'id')
  int get refId;

  int get count;
}

void main() {
  final r = TestRunner<SubQueryDatabase>(
    setup: (db) async {
      await db.createTables();
    },
  );

  r.addTest('Subquery in update', (db) async {
    await db.sourceItems.insertValue(id: 1, value: '100').execute();
    await db.subQueryItems.insertValue(tag: 'T1', refId: 1, count: 1).execute();

    await db.subQueryItems
        .insertValue(tag: 'T1', refId: 1, count: 2)
        .onConflict(SubQueryItemConflict.tag)
        .update(
          (item, excluded, set) => set(
            count: db.sourceItems
                .where((s) => s.id.equals(item.refId))
                .select((s) => (s.value.asInt(),))
                .first
                .asExpr
                .asNotNull(),
          ),
        )
        .execute();

    final item = await db.subQueryItems
        .where((i) => i.tag.equalsValue('T1'))
        .first
        .fetch();
    check(item).isNotNull().count.equals(100);
  }, skipMysql: 'mysql does not support ON CONFLICT clauses');

  r.addTest(
    'Subquery in where condition',
    (db) async {
      await db.sourceItems.insertValue(id: 1, value: '100').execute();
      await db.subQueryItems
          .insertValue(tag: 'T1', refId: 1, count: 1)
          .execute();

      await db.subQueryItems
          .insertValue(tag: 'T1', refId: 1, count: 2)
          .onConflict(SubQueryItemConflict.tag)
          .update((item, excluded, set) => set(count: toExpr(200)))
          .where(
            (item, excluded) =>
                db.sourceItems
                    .where((s) => s.id.equals(item.refId))
                    .select((s) => (s.value.asInt(),))
                    .first
                    .asExpr
                    .asNotNull() >
                toExpr(50),
          )
          .execute();

      final item = await db.subQueryItems
          .where((i) => i.tag.equalsValue('T1'))
          .first
          .fetch();
      check(item).isNotNull().count.equals(200);
    },
    skipMysql: 'mysql does not support ON CONFLICT clauses',
  );

  r.run();
}
