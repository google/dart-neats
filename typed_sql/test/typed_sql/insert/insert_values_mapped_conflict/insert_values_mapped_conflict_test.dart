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

part 'insert_values_mapped_conflict_test.g.dart';

abstract final class ConflictMappedDatabase extends Schema {
  Table<ConflictMappedItem> get conflictMappedItems;
}

@PrimaryKey(['id'])
abstract final class ConflictMappedItem extends Row {
  int get id;

  @Unique.field()
  @SqlOverride(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String get name;

  int get value;
}

void main() {
  final r = TestRunner<ConflictMappedDatabase>(
    setup: (db) async {
      await db.createTables();
    },
  );

  r.addTest(
    'insertValuesMapped with .onConflict().doNothing()',
    (db) async {
      await db.conflictMappedItems
          .insertValue(id: 1, name: 'A', value: 10)
          .execute();

      final data = [
        (id: 1, name: 'A', value: 20), // Conflict on PK and Name
        (id: 2, name: 'B', value: 20), // New row
      ];

      await db.conflictMappedItems
          .insertValuesMapped(
            data,
            id: (r) => r.id,
            name: (r) => r.name,
            value: (r) => r.value,
          )
          .onConflict(ConflictMappedItemConflict.primaryKey)
          .doNothing()
          .execute();

      final items = await db.conflictMappedItems
          .orderBy((i) => [(i.id, .ascending)])
          .fetch();
      check(items).length.equals(2);
      check(items[0]).name.equals('A');
      check(items[0]).value.equals(10); // Unchanged
      check(items[1]).name.equals('B');
    },
    skipMysql: 'mysql does not support ON CONFLICT clauses',
  );

  r.addTest(
    'insertValuesMapped with .onConflict().update()',
    (db) async {
      await db.conflictMappedItems
          .insertValue(id: 1, name: 'A', value: 10)
          .execute();

      final data = [
        (id: 1, name: 'A', value: 20), // Conflict on PK
        (id: 2, name: 'B', value: 20), // New row
      ];

      await db.conflictMappedItems
          .insertValuesMapped(
            data,
            id: (r) => r.id,
            name: (r) => r.name,
            value: (r) => r.value,
          )
          .onConflict(ConflictMappedItemConflict.primaryKey)
          .update((item, excluded, set) => set(value: excluded.value))
          .execute();

      final items = await db.conflictMappedItems
          .orderBy((i) => [(i.id, .ascending)])
          .fetch();
      check(items).length.equals(2);
      check(items[0]).name.equals('A');
      check(items[0]).value.equals(20); // Updated!
      check(items[1]).name.equals('B');
    },
    skipMysql: 'mysql does not support ON CONFLICT clauses',
  );

  r.run();
}
