// Copyright 2025 Google LLC
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

part 'datetime_test.g.dart';

abstract final class TestDatabase extends Schema {
  Table<Item> get items;
}

@PrimaryKey(['id'])
abstract final class Item extends Row {
  @AutoIncrement()
  int get id;

  DateTime get value;
}

void main() {
  final r = TestRunner<TestDatabase>(
    setup: (db) async {
      await db.createTables();
    },
  );

  // It's important to test year zero and BC dates because postgres encodes
  // these differently.

  r.addTest('.insert(year zero)', (db) async {
    await db.items
        .insert(
          id: toExpr(1),
          value: toExpr(DateTime.utc(0)),
        )
        .execute();

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.equals(DateTime.utc(0));
  });

  r.addTest('.insert(5 BC)', (db) async {
    await db.items
        .insert(
          id: toExpr(1),
          value: toExpr(DateTime.utc(-5)),
        )
        .execute();

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.equals(DateTime.utc(-5));
  }, skipMysql: 'MySQL does not support datetime before 1000 AD');

  r.run();
}
