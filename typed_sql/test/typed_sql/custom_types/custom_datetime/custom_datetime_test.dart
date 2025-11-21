// GENERATED CODE - DO NOT MODIFY BY HAND
//
// See tool/generate_custom_type_tests.dart

// ignore: unused_import
import 'dart:typed_data';

import 'package:typed_sql/typed_sql.dart';

import '../../testrunner.dart';

part 'custom_datetime_test.g.dart';

abstract final class TestDatabase extends Schema {
  Table<Item> get items;
}

@PrimaryKey(['id'])
abstract final class Item extends Row {
  @AutoIncrement()
  int get id;

  MyCustomType get value;
}

final class MyCustomType implements CustomDataType<DateTime> {
  final DateTime value;

  MyCustomType(this.value);

  factory MyCustomType.fromDatabase(DateTime value) => MyCustomType(value);

  @override
  DateTime toDatabase() => value;
}

extension on Subject<MyCustomType> {
  void equals(MyCustomType other) =>
      has((e) => e.value, 'value').equals(other.value);
}

void main() {
  final r = TestRunner<TestDatabase>(
    setup: (db) async {
      await db.createTables();
    },
  );

  final initialValue = MyCustomType(DateTime(2024).toUtc());
  final updatedValue = MyCustomType(DateTime(2025).toUtc());

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

  r.addTest('updateAll', (db) async {
    await db.items
        .insert(
          id: toExpr(1),
          value: initialValue.asExpr,
        )
        .execute();

    await db.items
        .updateAll((item, set) => set(
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
