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

part 'upsert_test.g.dart';

abstract final class UpsertDatabase extends Schema {
  Table<SimpleItem> get simpleItems;
  Table<CompositeItem> get compositeItems;
  Table<NullableUniqueItem> get nullableUniqueItems;
  Table<SubQueryItem> get subQueryItems;
  Table<ComplexItem> get complexItems;
  Table<CustomTypeItem> get customTypeItems;
}

@PrimaryKey(['id'])
abstract final class SimpleItem extends Row {
  @AutoIncrement()
  int get id;

  @Unique.field()
  @SqlOverride(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String get name;

  int get value;
}

@PrimaryKey(['partA', 'partB'])
@Unique(name: 'fullname', fields: ['firstName', 'lastName'])
abstract final class CompositeItem extends Row {
  @SqlOverride(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String get partA;
  int get partB;

  @SqlOverride(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String get firstName;

  @SqlOverride(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String get lastName;

  String get data;
}

@PrimaryKey(['id'])
abstract final class NullableUniqueItem extends Row {
  @AutoIncrement()
  int get id;

  @Unique.field()
  @SqlOverride(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String? get code;

  String get description;
}

@PrimaryKey(['id'])
abstract final class SubQueryItem extends Row {
  @AutoIncrement()
  int get id;

  @Unique.field()
  @SqlOverride(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String get tag;

  @References(table: 'simpleItems', field: 'id')
  int get refId;

  int get count;
}

@PrimaryKey(['id', 'createdAt'])
@Unique(name: 'complexUnique', fields: ['name', 'doubleValue', 'boolValue'])
abstract final class ComplexItem extends Row {
  int get id;

  @DefaultValue.now
  DateTime get createdAt;

  @SqlOverride(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String get name;

  @DefaultValue(0.0)
  double get doubleValue;

  @DefaultValue(false)
  bool get boolValue;

  int get value;
}

final class MyCustomType implements CustomDataType<int> {
  final int value;
  MyCustomType(this.value);
  factory MyCustomType.fromDatabase(int value) => MyCustomType(value);
  @override
  int toDatabase() => value;
}

@PrimaryKey(['id'])
abstract final class CustomTypeItem extends Row {
  @AutoIncrement()
  int get id;

  @Unique.field()
  MyCustomType get value;
}

void main() {
  final r = TestRunner<UpsertDatabase>(
    setup: (db) async {
      await db.createTables();
    },
  );

  // SimpleItem Tests
  r.addTest(
    'Simple: .onConflict().doNothing()',
    (db) async {
      await db.simpleItems.insertValue(id: 1, name: 'A', value: 10).execute();
      await db.simpleItems
          .insertValue(id: 1, name: 'B', value: 20)
          .onConflict(SimpleItemConflict.primaryKey)
          .doNothing()
          .execute();
      final item = await db.simpleItems.byKey(1).fetch();
      check(item).isNotNull().name.equals('A');
      check(item).isNotNull().value.equals(10);
    },
    skipMysql: 'mysql does not support ON CONFLICT clauses',
  );

  r.addTest(
    'Simple: .onConflict().update()',
    (db) async {
      await db.simpleItems.insertValue(id: 1, name: 'A', value: 10).execute();
      await db.simpleItems
          .insertValue(id: 1, name: 'B', value: 20)
          .onConflict(SimpleItemConflict.primaryKey)
          .update((item, excluded, set) => set(value: excluded.value))
          .execute();
      final item = await db.simpleItems.byKey(1).fetch();
      check(item).isNotNull().name.equals('A');
      check(item).isNotNull().value.equals(20);
    },
    skipMysql: 'mysql does not support ON CONFLICT clauses',
  );

  r.addTest(
    'Simple: .onConflict(name).update()',
    (db) async {
      await db.simpleItems.insertValue(id: 1, name: 'A', value: 10).execute();
      await db.simpleItems
          .insertValue(id: 2, name: 'A', value: 20)
          .onConflict(SimpleItemConflict.name)
          .update((item, excluded, set) => set(value: excluded.value))
          .execute();
      final item = await db.simpleItems
          .where((i) => i.name.equalsValue('A'))
          .first
          .fetch();
      check(item).isNotNull().id.equals(1);
      check(item).isNotNull().value.equals(20);
    },
    skipMysql: 'mysql does not support ON CONFLICT clauses',
  );

  r.addTest(
    'Simple: .onConflict().update().where(true)',
    (db) async {
      await db.simpleItems.insertValue(id: 1, name: 'A', value: 10).execute();
      await db.simpleItems
          .insertValue(id: 1, name: 'B', value: 20)
          .onConflict(SimpleItemConflict.primaryKey)
          .update((item, excluded, set) => set(value: excluded.value))
          .where((item, excluded) => toExpr(true))
          .execute();
      final item = await db.simpleItems.byKey(1).fetch();
      check(item).isNotNull().value.equals(20);
    },
    skipMysql: 'mysql does not support ON CONFLICT clauses',
  );

  r.addTest(
    'Simple: .onConflict().update().where(false)',
    (db) async {
      await db.simpleItems.insertValue(id: 1, name: 'A', value: 10).execute();
      await db.simpleItems
          .insertValue(id: 1, name: 'B', value: 20)
          .onConflict(SimpleItemConflict.primaryKey)
          .update((item, excluded, set) => set(value: excluded.value))
          .where((item, excluded) => toExpr(false))
          .execute();
      final item = await db.simpleItems.byKey(1).fetch();
      check(item).isNotNull().value.equals(10);
    },
    skipMysql: 'mysql does not support ON CONFLICT clauses',
  );

  // CompositeItem Tests
  r.addTest(
    'Composite: PK conflict',
    (db) async {
      await db.compositeItems
          .insertValue(
            partA: 'X',
            partB: 1,
            firstName: 'A',
            lastName: 'B',
            data: 'd1',
          )
          .execute();
      await db.compositeItems
          .insertValue(
            partA: 'X',
            partB: 1,
            firstName: 'C',
            lastName: 'D',
            data: 'd2',
          )
          .onConflict(CompositeItemConflict.primaryKey)
          .update((item, excluded, set) => set(data: excluded.data))
          .execute();
      final item = await db.compositeItems
          .where((i) => i.partA.equalsValue('X') & i.partB.equalsValue(1))
          .first
          .fetch();
      check(item).isNotNull().data.equals('d2');
    },
    skipMysql: 'mysql does not support ON CONFLICT clauses',
  );

  r.addTest(
    'Composite: Unique conflict',
    (db) async {
      await db.compositeItems
          .insertValue(
            partA: 'X',
            partB: 1,
            firstName: 'A',
            lastName: 'B',
            data: 'd1',
          )
          .execute();
      await db.compositeItems
          .insertValue(
            partA: 'Y',
            partB: 2,
            firstName: 'A',
            lastName: 'B',
            data: 'd2',
          )
          .onConflict(CompositeItemConflict.fullname)
          .update((item, excluded, set) => set(data: excluded.data))
          .execute();
      final item = await db.compositeItems
          .where(
            (i) => i.firstName.equalsValue('A') & i.lastName.equalsValue('B'),
          )
          .first
          .fetch();
      check(item).isNotNull().partA.equals('X');
      check(item).isNotNull().data.equals('d2');
    },
    skipMysql: 'mysql does not support ON CONFLICT clauses',
  );

  // NullableUniqueItem Tests
  r.addTest('Nullable: nulls distinct', (db) async {
    await db.nullableUniqueItems
        .insertValue(code: null, description: 'desc1')
        .execute();
    await db.nullableUniqueItems
        .insertValue(code: null, description: 'desc2')
        .execute();
    final count = await db.nullableUniqueItems.count().fetch();
    check(count).equals(2);
  });

  // SubQueryItem Tests
  r.addTest('Subquery: update', (db) async {
    await db.simpleItems.insertValue(id: 1, name: 'A', value: 100).execute();
    await db.subQueryItems.insertValue(tag: 'T1', refId: 1, count: 1).execute();
    await db.subQueryItems
        .insertValue(tag: 'T1', refId: 1, count: 2)
        .onConflict(SubQueryItemConflict.tag)
        .update(
          (item, excluded, set) => set(
            count: db.simpleItems
                .where((s) => s.id.equals(item.refId))
                .select((s) => (s.value,))
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

  // ComplexItem Tests
  r.addTest(
    'Complex: conflict on composite PK with DateTime',
    (db) async {
      final now = DateTime.now().toUtc();
      await db.complexItems
          .insertValue(id: 1, createdAt: now, name: 'A', value: 10)
          .execute();

      await db.complexItems
          .insertValue(id: 1, createdAt: now, name: 'B', value: 20)
          .onConflict(ComplexItemConflict.primaryKey)
          .update((item, excluded, set) => set(value: excluded.value))
          .execute();

      final item = await db.complexItems
          .where((i) => i.id.equalsValue(1))
          .first
          .fetch();
      check(item).isNotNull().value.equals(20);
    },
    skipMysql: 'mysql does not support ON CONFLICT clauses',
    skipSqlite: 'SQLite datetime comparison issues in keys',
  );

  r.addTest(
    'Complex: conflict on composite unique (String, Double, Bool)',
    (db) async {
      final now = DateTime.now().toUtc();
      await db.complexItems
          .insertValue(
            id: 1,
            createdAt: now,
            name: 'A',
            doubleValue: 1.0,
            boolValue: true,
            value: 10,
          )
          .execute();

      await db.complexItems
          .insertValue(
            id: 2,
            createdAt: now,
            name: 'A',
            doubleValue: 1.0,
            boolValue: true,
            value: 20,
          )
          .onConflict(ComplexItemConflict.complexUnique)
          .update((item, excluded, set) => set(value: excluded.value))
          .execute();

      final item = await db.complexItems
          .where((i) => i.id.equalsValue(1))
          .first
          .fetch();
      check(item).isNotNull().value.equals(20);
    },
    skipMysql: 'mysql does not support ON CONFLICT clauses',
  );

  // CustomTypeItem Tests
  r.addTest(
    'CustomType: conflict on custom type',
    (db) async {
      final val1 = MyCustomType(42);
      final val2 = MyCustomType(21);

      await db.customTypeItems.insertValue(id: 1, value: val1).execute();

      await db.customTypeItems
          .insertValue(id: 2, value: val1) // Conflict on 'value'
          .onConflict(CustomTypeItemConflict.value)
          .update((item, excluded, set) => set(value: val2.asExpr))
          .execute();

      final item = await db.customTypeItems
          .where((i) => i.id.equalsValue(1))
          .first
          .fetch();
      check(item).isNotNull().value.has((v) => v.value, 'value').equals(21);
    },
    skipMysql: 'mysql does not support ON CONFLICT clauses',
  );

  // Returning Clauses
  r.addTest('.returnInserted()', (db) async {
    final item = await db.simpleItems
        .insertValue(id: 1, name: 'A', value: 10)
        .returnInserted()
        .executeAndFetch();
    check(item).isNotNull().name.equals('A');
  });

  r.addTest('.returnUpserted()', (db) async {
    await db.simpleItems.insertValue(id: 1, name: 'A', value: 10).execute();
    final item = await db.simpleItems
        .insertValue(id: 1, name: 'B', value: 20)
        .onConflict(SimpleItemConflict.primaryKey)
        .update((item, excluded, set) => set(value: excluded.value))
        .returnUpserted()
        .executeAndFetch();
    check(item).isNotNull().value.equals(20);
  }, skipMysql: 'mysql does not support ON CONFLICT clauses');

  r.run();
}
