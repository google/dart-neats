// GENERATED CODE - DO NOT MODIFY BY HAND
//
// See tool/generate_default_tests.dart

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

part 'nullable_text_test.g.dart';

abstract final class TestDatabase extends Schema {
  Table<Item> get items;
}

@PrimaryKey(['id'])
abstract final class Item extends Model {
  @AutoIncrement()
  int get id;

  String? get value;
}

final _value = 'hello';

void main() {
  final r = TestRunner<TestDatabase>(
    setup: (db) async {
      await db.createTables();
    },
  );

  r.addTest('.insert() non-null value', (db) async {
    await db.items.insert(
      id: literal(1),
      value: literal(_value),
    );

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.equals(_value);
  });

  r.addTest('.insert() null by default', (db) async {
    await db.items.insert(
      id: literal(1),
    );

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.isNull();
  });

  r.addTest('.insert() null explicitly', (db) async {
    await db.items.insert(
      id: literal(1),
      value: literal(null),
    );

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.isNull();
  });

  r.addTest('.update() null by default', (db) async {
    await db.items.insert(
      id: literal(1),
    );

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.isNull();

    await db.items.byKey(id: 1).update((item, set) => set(
          value: literal(_value),
        ));

    final updateItem = await db.items.first.fetch();
    check(updateItem).isNotNull().value.equals(_value);
  });

  r.addTest('.update() null explicitly', (db) async {
    await db.items.insert(
      id: literal(1),
      value: literal(null),
    );

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.isNull();

    await db.items.byKey(id: 1).update((item, set) => set(
          value: literal(_value),
        ));

    final updateItem = await db.items.first.fetch();
    check(updateItem).isNotNull().value.equals(_value);
  });

  r.run();
}
