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

part 'json_insert_test.g.dart';

abstract final class JsonInsertDatabase extends Schema {
  Table<JsonItem> get jsonItems;
}

@PrimaryKey(['id'])
abstract final class JsonItem extends Row {
  @AutoIncrement()
  int get id;

  JsonValue get data;
}

void main() {
  final r = TestRunner<JsonInsertDatabase>(
    setup: (db) async {
      await db.createTables();
    },
  );

  r.addTest('Insert JSON map', (db) async {
    await db.jsonItems
        .insertValue(
          data: const JsonValue({'key': 'value'}),
        )
        .execute();

    final item = await db.jsonItems.first.fetch();
    check(item).isNotNull();
    check(
      item!.data.value,
    ).isA<Map>().has((m) => m['key'], 'key').equals('value');
  });

  r.addTest('Insert JSON list', (db) async {
    await db.jsonItems
        .insertValue(
          data: const JsonValue([1, 2, 3]),
        )
        .execute();

    final item = await db.jsonItems.first.fetch();
    check(item).isNotNull();
    check(item!.data.value).isA<List>().deepEquals([1, 2, 3]);
  });

  r.run();
}
