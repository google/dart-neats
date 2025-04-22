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

part 'custom_blob_alias_test.g.dart';

abstract final class TestDatabase extends Schema {
  Table<Item> get items;
}

@PrimaryKey(['id'])
abstract final class Item extends Model {
  @AutoIncrement()
  int get id;

  MyCustomTypeAlias get value;
}

typedef MyCustomTypeAlias = JsonValue<Uint8List>;

final class JsonValue<T extends Uint8List> implements CustomDataType<T> {
  final Object? jsonValue;

  JsonValue(this.jsonValue);

  factory JsonValue.fromDatabase(Uint8List bytes) =>
      JsonValue(json.fuse(utf8).decode(bytes));

  @override
  T toDatabase() => json.fuse(utf8).encode(jsonValue) as T;
}

extension on Subject<MyCustomTypeAlias> {
  void equals(MyCustomTypeAlias other) =>
      has((e) => json.encode(e.jsonValue), 'jsonValue')
          .equals(json.encode(other.jsonValue));
}

void main() {
  final r = TestRunner<TestDatabase>(
    setup: (db) async {
      await db.createTables();
    },
  );

  final initialValue = MyCustomTypeAlias(['a', 'b', 'c']);
  final updatedValue = MyCustomTypeAlias(['a', 'b', 'c', 'd']);

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

  r.addTest('db.select()', (db) async {
    final value = await db.select((initialValue.asExpr,)).fetch();
    check(value).isNotNull().equals(initialValue);
  });

  r.run();
}
