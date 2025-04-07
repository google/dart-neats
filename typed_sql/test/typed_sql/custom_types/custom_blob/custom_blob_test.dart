// GENERATED CODE - DO NOT MODIFY BY HAND
//
// See tool/generate_custom_type_tests.dart

// ignore: unused_import
import 'dart:typed_data';

import 'package:typed_sql/typed_sql.dart';

import '../../testrunner.dart';

part 'custom_blob_test.g.dart';

abstract final class TestDatabase extends Schema {
  Table<Item> get items;
}

@PrimaryKey(['id'])
abstract final class Item extends Model {
  @AutoIncrement()
  int get id;

  MyCustomType get value;
}

final class MyCustomType implements CustomDataType<Uint8List> {
  final Uint8List value;

  MyCustomType(this.value);

  factory MyCustomType.fromDatabase(Uint8List value) => MyCustomType(value);

  @override
  Uint8List toDatabase() => value;
}

extension on Subject<MyCustomType> {
  void equals(MyCustomType other) =>
      has((e) => e.value, 'value').deepEquals(other.value);
}

void main() {
  final r = TestRunner<TestDatabase>(
    setup: (db) async {
      await db.createTables();
    },
  );

  final initialValue = MyCustomType(Uint8List.fromList([1, 2, 3]));
  final updatedValue = MyCustomType(Uint8List.fromList([1, 2, 3, 4]));

  r.addTest('insert', (db) async {
    await db.items
        .insert(
          id: literal(1),
          value: initialValue.asExpr,
        )
        .execute();

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.equals(initialValue);
  });

  r.addTest('update', (db) async {
    await db.items
        .insert(
          id: literal(1),
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
          id: literal(1),
          value: initialValue.asExpr,
        )
        .execute();

    final item1 = await db.items.first.fetch();
    check(item1).isNotNull();

    await db.items.where((i) => i.id.equalsLiteral(1)).delete().execute();

    final item2 = await db.items.first.fetch();
    check(item2).isNull();
  });

  r.addTest('db.select', (db) async {
    final value = await db.select((initialValue.asExpr,)).fetch();
    check(value).isNotNull().equals(initialValue);
  });

  r.run();
}
