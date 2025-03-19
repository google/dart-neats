// GENERATED CODE - DO NOT MODIFY BY HAND
//
// See tool/generate_crud_tests.dart

// ignore: unused_import
import 'dart:typed_data';

import 'package:typed_sql/typed_sql.dart';

import '../../testrunner.dart';

part 'boolean_test.g.dart';

abstract final class TestDatabase extends Schema {
  Table<Item> get items;
}

@PrimaryKey(['id'])
abstract final class Item extends Model {
  @AutoIncrement()
  int get id;

  bool get value;
}

void main() {
  final r = TestRunner<TestDatabase>(
    setup: (db) async {
      await db.createTables();
    },
  );

  final initialValue = true;
  final updatedValue = false;

  r.addTest('.insert()', (db) async {
    await db.items
        .insert(
          id: literal(1),
          value: literal(initialValue),
        )
        .execute();

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.equals(initialValue);
  });

  r.addTest('.insert().returnInserted()', (db) async {
    final item = await db.items
        .insert(
          id: literal(1),
          value: literal(initialValue),
        )
        .returnInserted()
        .executeAndFetch();
    check(item).isNotNull().value.equals(initialValue);
  });

  r.addTest('.insert().returning(.value)', (db) async {
    final value = await db.items
        .insert(
          id: literal(1),
          value: literal(initialValue),
        )
        .returning((item) => (item.value,))
        .executeAndFetch();
    check(value).isNotNull().equals(initialValue);
  });

  r.addTest('.update()', (db) async {
    await db.items
        .insert(
          id: literal(1),
          value: literal(initialValue),
        )
        .execute();

    await db.items
        .updateAll((item, set) => set(
              value: literal(updatedValue),
            ))
        .execute();

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.equals(updatedValue);
  });

  r.addTest('.update().returnUpdated()', (db) async {
    await db.items
        .insert(
          id: literal(1),
          value: literal(initialValue),
        )
        .execute();

    final updatedItems = await db.items
        .updateAll((item, set) => set(
              value: literal(updatedValue),
            ))
        .returnUpdated()
        .executeAndFetch();

    check(updatedItems)
      ..length.equals(1)
      ..first.value.equals(updatedValue);

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.equals(updatedValue);
  });

  r.addTest('.update().returning(.value)', (db) async {
    await db.items
        .insert(
          id: literal(1),
          value: literal(initialValue),
        )
        .execute();

    final values = await db.items
        .updateAll((item, set) => set(
              value: literal(updatedValue),
            ))
        .returning((item) => (item.value,))
        .executeAndFetch();

    check(values)
      ..length.equals(1)
      ..first.equals(updatedValue);

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.equals(updatedValue);
  });

  r.addTest('.delete()', (db) async {
    await db.items
        .insert(
          id: literal(1),
          value: literal(initialValue),
        )
        .execute();

    final item1 = await db.items.first.fetch();
    check(item1).isNotNull();

    await db.items.where((i) => i.id.equalsLiteral(1)).delete().execute();

    final item2 = await db.items.first.fetch();
    check(item2).isNull();
  });

  r.addTest('.delete().returnDeleted()', (db) async {
    await db.items
        .insert(
          id: literal(1),
          value: literal(initialValue),
        )
        .execute();

    final item1 = await db.items.first.fetch();
    check(item1).isNotNull();

    final deletedItems = await db.items
        .where((i) => i.id.equalsLiteral(1))
        .delete()
        .returnDeleted()
        .executeAndFetch();
    check(deletedItems)
      ..length.equals(1)
      ..first.value.equals(initialValue);

    final item2 = await db.items.first.fetch();
    check(item2).isNull();
  });

  r.addTest('.delete().returning(.value)', (db) async {
    await db.items
        .insert(
          id: literal(1),
          value: literal(initialValue),
        )
        .execute();

    final item1 = await db.items.first.fetch();
    check(item1).isNotNull();

    final values = await db.items
        .where((i) => i.id.equalsLiteral(1))
        .delete()
        .returning((item) => (item.value,))
        .executeAndFetch();
    check(values)
      ..length.equals(1)
      ..first.equals(initialValue);

    final item2 = await db.items.first.fetch();
    check(item2).isNull();
  });

  r.run();
}
