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

part 'defaults_test.g.dart';

abstract final class DefaultsDatabase extends Schema {
  Table<DefaultsItem> get defaultsItems;
}

@PrimaryKey(['id'])
abstract final class DefaultsItem extends Row {
  @AutoIncrement()
  int get id;

  @DefaultValue(true)
  bool get b;

  @DefaultValue(42)
  int get i;

  @DefaultValue(3.14)
  double get d;

  @DefaultValue('default')
  String get s;

  @DefaultValue.now
  DateTime get dtNow;

  @DefaultValue.epoch
  DateTime get dtEpoch;

  @DefaultValue(JsonValue({'key': 'value'}))
  JsonValue get json;
}

void main() {
  final r = TestRunner<DefaultsDatabase>(
    setup: (db) async {
      await db.createTables();
    },
  );

  r.addTest('Insert with defaults (omitted fields)', (db) async {
    await db.defaultsItems
        .insert()
        .execute(); // All fields omitted except ID which is auto-increment

    final item = await db.defaultsItems.first.fetch();
    check(item).isNotNull();
    check(item!.b).isTrue();
    check(item.i).equals(42);
    check(item.d).equals(3.14);
    check(item.s).equals('default');
    check(item.dtNow.difference(DateTime.now()).inMinutes).isLessThan(1);
    check(item.dtEpoch.millisecondsSinceEpoch).equals(0);
    check(
      item.json.value,
    ).isA<Map>().has((m) => m['key'], 'key').equals('value');
  });

  r.addTest('InsertValue with defaults', (db) async {
    await db.defaultsItems.insertValue().execute();

    final item = await db.defaultsItems.first.fetch();
    check(item).isNotNull();
    check(item!.b).isTrue();
    check(item.i).equals(42);
  });

  r.addTest('insertValuesMapped with defaults (omitted fields)', (db) async {
    final data = [
      (id: 1),
      (id: 2),
    ];

    await db.defaultsItems
        .insertValuesMapped(
          data,
          id: (r) => r.id,
          // All other fields omitted!
        )
        .execute();

    final items = await db.defaultsItems
        .orderBy((i) => [(i.id, .ascending)])
        .fetch();
    check(items).length.equals(2);

    for (final item in items) {
      check(item.b).isTrue();
      check(item.i).equals(42);
      check(item.d).equals(3.14);
      check(item.s).equals('default');
      check(item.dtNow.difference(DateTime.now()).inMinutes).isLessThan(1);
      check(item.dtEpoch.millisecondsSinceEpoch).equals(0);
      check(
        item.json.value,
      ).isA<Map>().has((m) => m['key'], 'key').equals('value');
    }
  });

  r.run();
}
