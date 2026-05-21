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

part 'upsert_complex_test.g.dart';

abstract final class ComplexDatabase extends Schema {
  Table<ComplexItem> get complexItems;
}

@PrimaryKey(['id', 'createdAt'])
@Unique(name: 'complexUnique', fields: ['name', 'doubleValue', 'boolValue'])
abstract final class ComplexItem extends Row {
  int get id;

  @DefaultValue.now
  DateTime get createdAt;

  @SqlOverride.field(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String get name;

  @DefaultValue(0.0)
  double get doubleValue;

  @DefaultValue(false)
  bool get boolValue;

  int get value;
}

void main() {
  final r = TestRunner<ComplexDatabase>(
    setup: (db) async {
      await db.createTables();
    },
  );

  r.addTest(
    'Conflict on composite PK with DateTime',
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
    'Conflict on composite unique (String, Double, Bool)',
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

  r.run();
}
