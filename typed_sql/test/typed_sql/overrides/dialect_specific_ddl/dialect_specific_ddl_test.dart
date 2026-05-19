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
// limitations under the License.

import 'package:meta/meta.dart';
import 'package:typed_sql/typed_sql.dart';

import '../../testrunner.dart';

part 'dialect_specific_ddl_test.g.dart';

@immutable
final class Color implements CustomDataType<int> {
  final int value;
  const Color(this.value);
  factory Color.fromDatabase(int value) => Color(value);
  @override
  int toDatabase() => value;
}

abstract final class DialectDatabase extends Schema {
  Table<DialectItem> get dialectItems;
  Table<DialectLog> get dialectLogs;
}

@PrimaryKey(['itemId'])
@Unique(fields: ['name', 'category'])
abstract final class DialectItem extends Row {
  @AutoIncrement()
  int get itemId;

  @SqlOverride.field(dialect: 'sqlite', collation: 'NOCASE')
  @SqlOverride.field(dialect: 'postgres', columnType: 'VARCHAR(255)')
  @SqlOverride.field(dialect: 'sqlite', columnType: 'TEXT')
  @SqlOverride.field(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String get name;

  @SqlOverride.field(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String get category;

  @Unique.field()
  @SqlOverride.field(dialect: 'postgres', defaultValue: "'unknown'")
  @SqlOverride.field(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String get status;

  Color get itemColor;
}

@PrimaryKey(['logId'])
@ForeignKey(['refItemId'], table: 'dialectItems', fields: ['itemId'])
abstract final class DialectLog extends Row {
  @AutoIncrement()
  int get logId;

  int get refItemId;
}

void main() {
  final r = TestRunner<DialectDatabase>(
    setup: (db) async {
      await db.createTables();
    },
  );

  r.addTest('insert and query with dialect overrides', (db) async {
    final itemId = await db.dialectItems
        .insert(
          name: toExpr('Apple'),
          category: toExpr('Fruit'),
          status: toExpr('active'),
          itemColor: const Color(0xFF0000).asExpr,
        )
        .returning((i) => (i.itemId,))
        .executeAndFetch();

    await db.dialectLogs.insert(refItemId: toExpr(itemId)).execute();

    final items = await db.dialectItems
        .where((i) => i.name.equals(toExpr('Apple')))
        .select((i) => (i.name, i.status))
        .fetch();

    check(items).unorderedEquals([('Apple', 'active')]);
  });

  r.run();
}
