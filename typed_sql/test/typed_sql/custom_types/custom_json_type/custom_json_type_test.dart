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

import 'dart:convert';
import 'dart:typed_data';

import 'package:typed_sql/typed_sql.dart';

import '../../testrunner.dart';

part 'custom_json_type_test.g.dart';

abstract final class TestDatabase extends Schema {
  Table<Item> get items;
}

@PrimaryKey(['id'])
abstract final class Item extends Row {
  @AutoIncrement()
  int get id;

  JsonValue get value;
}

final class JsonValue implements CustomDataType<Uint8List> {
  final Object? jsonValue;

  JsonValue(this.jsonValue);

  factory JsonValue.fromDatabase(Uint8List bytes) =>
      JsonValue(json.fuse(utf8).decode(bytes));

  @override
  Uint8List toDatabase() => json.fuse(utf8).encode(jsonValue) as Uint8List;
}

extension on Subject<JsonValue> {
  void equals(JsonValue other) =>
      has((e) => json.encode(e.jsonValue), 'jsonValue')
          .equals(json.encode(other.jsonValue));
}

void main() {
  final r = TestRunner<TestDatabase>(
    setup: (db) async {
      await db.createTables();
    },
  );

  final initialValue = JsonValue(['a', 'b', 'c']);
  final updatedValue = JsonValue(['a', 'b', 'c', 'd']);

  r.addTest('insert', (db) async {
    await db.items
        .insert(
          id: toExpr(1),
          value: initialValue.asExpr,
        )
        .execute();

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.equals(initialValue);
  });

  r.addTest('update', (db) async {
    await db.items
        .insert(
          id: toExpr(1),
          value: initialValue.asExpr,
        )
        .execute();

    await db.items
        .update((item, set) => set(
              value: updatedValue.asExpr,
            ))
        .execute();

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.equals(updatedValue);
  });

  r.addTest('delete', (db) async {
    await db.items
        .insert(
          id: toExpr(1),
          value: initialValue.asExpr,
        )
        .execute();

    final item1 = await db.items.first.fetch();
    check(item1).isNotNull();

    await db.items.where((i) => i.id.equalsValue(1)).delete().execute();

    final item2 = await db.items.first.fetch();
    check(item2).isNull();
  });

  r.addTest('db.select', (db) async {
    final value = await db.select((initialValue.asExpr,)).fetch();
    check(value).isNotNull().equals(initialValue);
  });

  r.run();
}
