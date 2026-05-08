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

part 'complex_constraints_test.g.dart';

abstract final class ComplexConstraintsDatabase extends Schema {
  Table<CompositePkItem> get compositePkItems;
  Table<MultiUniqueItem> get multiUniqueItems;
  Table<ForeignKeyItem> get foreignKeyItems;
}

@PrimaryKey(['pkA', 'pkB'])
abstract final class CompositePkItem extends Row {
  int get pkA;

  @SqlOverride(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String get pkB;

  String get data;
}

@PrimaryKey(['id'])
@Unique(name: 'multiUnique', fields: ['fieldA', 'fieldB'])
abstract final class MultiUniqueItem extends Row {
  @AutoIncrement()
  int get id;

  @SqlOverride(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String get fieldA;

  int get fieldB;
  String get data;
}

@PrimaryKey(['id'])
@ForeignKey(
  ['refPkA', 'refPkB'],
  table: 'compositePkItems',
  fields: ['pkA', 'pkB'],
  name: 'compositeRef',
)
abstract final class ForeignKeyItem extends Row {
  @AutoIncrement()
  int get id;

  int get refPkA;

  @SqlOverride(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String get refPkB;

  String get data;
}

void main() {
  final r = TestRunner<ComplexConstraintsDatabase>(
    setup: (db) async {
      await db.createTables();
    },
  );

  r.addTest('Insert into CompositePkItem', (db) async {
    await db.compositePkItems
        .insertValue(pkA: 1, pkB: 'X', data: 'd1')
        .execute();

    final item = await db.compositePkItems
        .where((i) => i.pkA.equalsValue(1) & i.pkB.equalsValue('X'))
        .first
        .fetch();
    check(item).isNotNull().data.equals('d1');
  });

  r.addTest(
    'Upsert on Composite PK',
    (db) async {
      await db.compositePkItems
          .insertValue(pkA: 1, pkB: 'X', data: 'd1')
          .execute();

      await db.compositePkItems
          .insertValue(pkA: 1, pkB: 'X', data: 'd2')
          .onConflict(CompositePkItemConflict.primaryKey)
          .update((item, excluded, set) => set(data: excluded.data))
          .execute();

      final item = await db.compositePkItems
          .where((i) => i.pkA.equalsValue(1) & i.pkB.equalsValue('X'))
          .first
          .fetch();
      check(item).isNotNull().data.equals('d2');
    },
    skipMysql: 'mysql does not support ON CONFLICT clauses',
  );

  r.addTest(
    'Upsert on Composite Unique',
    (db) async {
      await db.multiUniqueItems
          .insertValue(fieldA: 'A', fieldB: 1, data: 'd1')
          .execute();

      await db.multiUniqueItems
          .insertValue(fieldA: 'A', fieldB: 1, data: 'd2')
          .onConflict(MultiUniqueItemConflict.multiUnique)
          .update((item, excluded, set) => set(data: excluded.data))
          .execute();

      final item = await db.multiUniqueItems
          .where((i) => i.fieldA.equalsValue('A') & i.fieldB.equalsValue(1))
          .first
          .fetch();
      check(item).isNotNull().data.equals('d2');
    },
    skipMysql: 'mysql does not support ON CONFLICT clauses',
  );

  r.addTest('Insert with Composite FK', (db) async {
    await db.compositePkItems
        .insertValue(pkA: 1, pkB: 'X', data: 'd1')
        .execute();

    await db.foreignKeyItems
        .insertValue(refPkA: 1, refPkB: 'X', data: 'fd1')
        .execute();

    final item = await db.foreignKeyItems.first.fetch();
    check(item).isNotNull().data.equals('fd1');
  });

  r.run();
}
