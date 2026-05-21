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

part 'upsert_multi_conflict_test.g.dart';

abstract final class MultiConflictDatabase extends Schema {
  Table<MultiItem> get multiItems;
}

@PrimaryKey(['id'])
abstract final class MultiItem extends Row {
  @AutoIncrement()
  int get id;

  @Unique.field()
  @SqlOverride.field(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String get name;

  @Unique.field()
  @SqlOverride.field(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String get email;

  int get value;
}

void main() {
  final r = TestRunner<MultiConflictDatabase>(
    setup: (db) async {
      await db.createTables();
    },
  );

  r.addTest(
    'Conflict on name, target name -> update',
    (db) async {
      await db.multiItems
          .insertValue(id: 1, name: 'A', email: 'a@e.com', value: 10)
          .execute();

      await db.multiItems
          .insertValue(id: 2, name: 'A', email: 'b@e.com', value: 20)
          .onConflict(MultiItemConflict.name)
          .update((item, excluded, set) => set(value: excluded.value))
          .execute();

      final item = await db.multiItems
          .where((i) => i.name.equalsValue('A'))
          .first
          .fetch();
      check(item).isNotNull().id.equals(1);
      check(item).isNotNull().value.equals(20);
    },
    skipMysql: 'mysql does not support ON CONFLICT clauses',
  );

  r.addTest(
    'Conflict on email, target email -> update',
    (db) async {
      await db.multiItems
          .insertValue(id: 1, name: 'A', email: 'a@e.com', value: 10)
          .execute();

      await db.multiItems
          .insertValue(id: 2, name: 'B', email: 'a@e.com', value: 20)
          .onConflict(MultiItemConflict.email)
          .update((item, excluded, set) => set(value: excluded.value))
          .execute();

      final item = await db.multiItems
          .where((i) => i.email.equalsValue('a@e.com'))
          .first
          .fetch();
      check(item).isNotNull().id.equals(1);
      check(item).isNotNull().value.equals(20);
    },
    skipMysql: 'mysql does not support ON CONFLICT clauses',
  );

  r.addTest(
    'Conflict on both, target name, update causes email conflict -> fail',
    (db) async {
      await db.multiItems
          .insertValue(id: 1, name: 'A', email: 'a@e.com', value: 10)
          .execute();
      await db.multiItems
          .insertValue(id: 2, name: 'B', email: 'b@e.com', value: 10)
          .execute();

      try {
        await db.multiItems
            .insertValue(
              id: 3,
              name: 'A',
              email: 'b@e.com',
              value: 20,
            ) // Conflicts on name with row 1
            .onConflict(MultiItemConflict.name)
            .update(
              (item, excluded, set) =>
                  set(value: excluded.value, email: excluded.email),
            ) // Update causes email conflict with row 2
            .execute();
        fail('Expected OperationException due to email conflict on update');
      } on OperationException {
        // Expected
      }
    },
    skipMysql: 'mysql does not support ON CONFLICT clauses',
  );

  r.run();
}
