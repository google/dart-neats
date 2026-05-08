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

part 'insert_values_mapped_test.g.dart';

abstract final class MappedDatabase extends Schema {
  Table<MappedItem> get mappedItems;
}

@PrimaryKey(['id'])
abstract final class MappedItem extends Row {
  @AutoIncrement()
  int get id;

  String get value;

  @DefaultValue(0)
  int get count;

  String? get nullableValue;
}

void main() {
  final r = TestRunner<MappedDatabase>(
    setup: (db) async {
      await db.createTables();
    },
  );

  r.addTest('Basic insertValuesMapped', (db) async {
    final data = [
      (id: 1, value: 'A', count: 10),
      (id: 2, value: 'B', count: 20),
    ];

    await db.mappedItems
        .insertValuesMapped(
          data,
          id: (r) => r.id,
          value: (r) => r.value,
          count: (r) => r.count,
        )
        .execute();

    final items = await db.mappedItems
        .orderBy((i) => [(i.id, .ascending)])
        .fetch();
    check(items).length.equals(2);
    check(items[0]).value.equals('A');
    check(items[1]).value.equals('B');
  });

  r.addTest('insertValuesMapped with defaults', (db) async {
    final data = [
      (id: 1, value: 'A'),
      (id: 2, value: 'B'),
    ];

    await db.mappedItems
        .insertValuesMapped(
          data,
          id: (r) => r.id,
          value: (r) => r.value,
          // count is omitted, should use default 0
        )
        .execute();

    final items = await db.mappedItems
        .orderBy((i) => [(i.id, .ascending)])
        .fetch();
    check(items).length.equals(2);
    check(items[0]).count.equals(0);
    check(items[1]).count.equals(0);
  });

  r.addTest('insertValuesMapped with (row) => null for nullable field', (
    db,
  ) async {
    final data = [
      (id: 1, value: 'A', nullableValue: null),
    ];

    await db.mappedItems
        .insertValuesMapped(
          data,
          id: (r) => r.id,
          value: (r) => r.value,
          nullableValue: (r) => r.nullableValue,
        )
        .execute();

    final item = await db.mappedItems.first.fetch();
    check(item).isNotNull();
    check(item!.nullableValue).isNull();
  });

  r.addTest('insertValuesMapped omitting mapping for auto-increment ID', (
    db,
  ) async {
    final data = [
      (value: 'A'),
      (value: 'B'),
    ];

    await db.mappedItems
        .insertValuesMapped(
          data,
          value: (r) => r.value,
          // id is omitted
        )
        .execute();

    final items = await db.mappedItems
        .orderBy((i) => [(i.id, .ascending)])
        .fetch();
    check(items).length.equals(2);
    check(items[0].id).equals(1);
    check(items[1].id).equals(2);
  });

  r.run();
}
