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

part 'upsert_customtype_test.g.dart';

abstract final class CustomTypeDatabase extends Schema {
  Table<CustomTypeItem> get customTypeItems;
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
  final r = TestRunner<CustomTypeDatabase>(
    setup: (db) async {
      await db.createTables();
    },
  );

  r.addTest(
    '.insertValue() with .onConflict() on custom type',
    (db) async {
      final val1 = MyCustomType(42);
      final val2 = MyCustomType(21);

      await db.customTypeItems.insertValue(id: 1, value: val1).execute();

      await db.customTypeItems
          .insertValue(id: 2, value: val1)
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

  r.addTest(
    '.insert() with .onConflict() on custom type',
    (db) async {
      final val1 = MyCustomType(42);
      final val2 = MyCustomType(21);

      await db.customTypeItems.insertValue(id: 1, value: val1).execute();

      await db.customTypeItems
          .insert(id: toExpr(2), value: val1.asExpr)
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

  r.run();
}
