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

part 'insert_value_test.g.dart';

abstract final class ValueDatabase extends Schema {
  Table<ValueItem> get valueItems;
}

@PrimaryKey(['id'])
abstract final class ValueItem extends Row {
  @AutoIncrement()
  int get id;

  String get value;
}

void main() {
  final r = TestRunner<ValueDatabase>(
    setup: (db) async {
      await db.createTables();
    },
  );

  r.addTest('.insert()', (db) async {
    await db.valueItems
        .insert(
          id: toExpr(1),
          value: toExpr('hello'),
        )
        .execute();

    final item = await db.valueItems.first.fetch();
    check(item).isNotNull().value.equals('hello');
  });

  r.addTest('.insertValue()', (db) async {
    await db.valueItems
        .insertValue(
          id: 1,
          value: 'world',
        )
        .execute();

    final item = await db.valueItems.first.fetch();
    check(item).isNotNull().value.equals('world');
  });

  r.addTest('.insert().returnInserted()', (db) async {
    final item = await db.valueItems
        .insert(
          id: toExpr(1),
          value: toExpr('hello'),
        )
        .returnInserted()
        .executeAndFetch();
    check(item).isNotNull().value.equals('hello');
  });

  r.run();
}
