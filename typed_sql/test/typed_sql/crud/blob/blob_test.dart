// GENERATED CODE - DO NOT MODIFY BY HAND
//
// See tool/generate_crud_tests.dart

// ignore: unused_import
import 'dart:typed_data';

import 'package:typed_sql/typed_sql.dart';

import '../../testrunner.dart';

part 'blob_test.g.dart';

abstract final class TestDatabase extends Schema {
  Table<Item> get items;
}

@PrimaryKey(['id'])
abstract final class Item extends Row {
  @AutoIncrement()
  int get id;

  Uint8List get value;
}

void main() {
  final r = TestRunner<TestDatabase>(
    setup: (db) async {
      await db.createTables();
    },
  );

  final initialValue = Uint8List.fromList([1, 2, 3]);
  final updatedValue = Uint8List.fromList([1, 2, 3, 4]);
  final emptyValue = Uint8List.fromList([]);
  final otherValue = Uint8List.fromList([0]);

  r.addTest('.insert()', (db) async {
    await db.items
        .insert(
          id: toExpr(1),
          value: toExpr(initialValue),
        )
        .execute();

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.deepEquals(initialValue);
  });

  r.addTest('.insert(value: empty)', (db) async {
    await db.items
        .insert(
          id: toExpr(1),
          value: toExpr(emptyValue),
        )
        .execute();

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.deepEquals(emptyValue);
  });

  r.addTest('.insert(value: other)', (db) async {
    await db.items
        .insert(
          id: toExpr(1),
          value: toExpr(otherValue),
        )
        .execute();

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.deepEquals(otherValue);
  });

  r.addTest('.insert().returnInserted()', (db) async {
    final item = await db.items
        .insert(
          id: toExpr(1),
          value: toExpr(initialValue),
        )
        .returnInserted()
        .executeAndFetch();
    check(item).isNotNull().value.deepEquals(initialValue);
  });

  r.addTest('.insert().returning(.value)', (db) async {
    final value = await db.items
        .insert(
          id: toExpr(1),
          value: toExpr(initialValue),
        )
        .returning((item) => (item.value,))
        .executeAndFetch();
    check(value).isNotNull().deepEquals(initialValue);
  });

  r.addTest('.update()', (db) async {
    await db.items
        .insert(
          id: toExpr(1),
          value: toExpr(initialValue),
        )
        .execute();

    await db.items
        .update((item, set) => set(
              value: toExpr(updatedValue),
            ))
        .execute();

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.deepEquals(updatedValue);
  });

  r.addTest('.update().returnUpdated()', (db) async {
    await db.items
        .insert(
          id: toExpr(1),
          value: toExpr(initialValue),
        )
        .execute();

    final updatedItems = await db.items
        .update((item, set) => set(
              value: toExpr(updatedValue),
            ))
        .returnUpdated()
        .executeAndFetch();

    check(updatedItems)
      ..length.equals(1)
      ..first.value.deepEquals(updatedValue);

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.deepEquals(updatedValue);
  }, skipMysql: 'UPDATE RETURNING not supported');

  r.addTest('.update().returning(.value)', (db) async {
    await db.items
        .insert(
          id: toExpr(1),
          value: toExpr(initialValue),
        )
        .execute();

    final values = await db.items
        .update((item, set) => set(
              value: toExpr(updatedValue),
            ))
        .returning((item) => (item.value,))
        .executeAndFetch();

    check(values)
      ..length.equals(1)
      ..first.deepEquals(updatedValue);

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.deepEquals(updatedValue);
  }, skipMysql: 'UPDATE RETURNING not supported');

  r.addTest('.delete()', (db) async {
    await db.items
        .insert(
          id: toExpr(1),
          value: toExpr(initialValue),
        )
        .execute();

    final item1 = await db.items.first.fetch();
    check(item1).isNotNull();

    await db.items.where((i) => i.id.equalsValue(1)).delete().execute();

    final item2 = await db.items.first.fetch();
    check(item2).isNull();
  });

  r.addTest('.delete().returnDeleted()', (db) async {
    await db.items
        .insert(
          id: toExpr(1),
          value: toExpr(initialValue),
        )
        .execute();

    final item1 = await db.items.first.fetch();
    check(item1).isNotNull();

    final deletedItems = await db.items
        .where((i) => i.id.equalsValue(1))
        .delete()
        .returnDeleted()
        .executeAndFetch();
    check(deletedItems)
      ..length.equals(1)
      ..first.value.deepEquals(initialValue);

    final item2 = await db.items.first.fetch();
    check(item2).isNull();
  });

  r.addTest('.delete().returning(.value)', (db) async {
    await db.items
        .insert(
          id: toExpr(1),
          value: toExpr(initialValue),
        )
        .execute();

    final item1 = await db.items.first.fetch();
    check(item1).isNotNull();

    final values = await db.items
        .where((i) => i.id.equalsValue(1))
        .delete()
        .returning((item) => (item.value,))
        .executeAndFetch();
    check(values)
      ..length.equals(1)
      ..first.deepEquals(initialValue);

    final item2 = await db.items.first.fetch();
    check(item2).isNull();
  });

  r.run();
}
