// GENERATED CODE - DO NOT MODIFY BY HAND
//
// See tool/generate_default_tests.dart

// ignore: unused_import
import 'dart:typed_data';

import 'package:typed_sql/typed_sql.dart';

import '../../testrunner.dart';

part 'nullable_json_test.g.dart';

abstract final class TestDatabase extends Schema {
  Table<Item> get items;
}

@PrimaryKey(['id'])
abstract final class Item extends Row {
  @AutoIncrement()
  int get id;

  JsonValue? get value;
}

final _value = const JsonValue({'foo': 'bar'});

void main() {
  final r = TestRunner<TestDatabase>(
    setup: (db) async {
      await db.createTables();
    },
  );

  r.addTest('.insert() non-null value', (db) async {
    await db.items
        .insert(
          id: toExpr(1),
          value: toExpr(_value),
        )
        .execute();

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.isNotNull().deepEquals(_value);
  });

  r.addTest('.insert() null by default', (db) async {
    await db.items
        .insert(
          id: toExpr(1),
        )
        .execute();

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.isNull();
  });

  r.addTest('.insert() null explicitly', (db) async {
    await db.items
        .insert(
          id: toExpr(1),
          value: toExpr(null),
        )
        .execute();

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.isNull();
  });

  r.addTest('.update() null by default', (db) async {
    await db.items
        .insert(
          id: toExpr(1),
        )
        .execute();

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.isNull();

    await db.items
        .byKey(1)
        .update((item, set) => set(
              value: toExpr(_value),
            ))
        .execute();

    final updateItem = await db.items.first.fetch();
    check(updateItem).isNotNull().value.isNotNull().deepEquals(_value);
  });

  r.addTest('.update() null explicitly', (db) async {
    await db.items
        .insert(
          id: toExpr(1),
          value: toExpr(null),
        )
        .execute();

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.isNull();

    await db.items
        .byKey(1)
        .update((item, set) => set(
              value: toExpr(_value),
            ))
        .execute();

    final updateItem = await db.items.first.fetch();
    check(updateItem).isNotNull().value.isNotNull().deepEquals(_value);
  });

  r.run();
}
