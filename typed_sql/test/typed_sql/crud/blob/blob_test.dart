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
abstract final class Item extends Model {
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

  r.addTest('insert', (db) async {
    await db.items
        .insert(
          id: literal(1),
          value: literal(initialValue),
        )
        .execute();

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.deepEquals(initialValue);
  });

  r.addTest('update', (db) async {
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
    check(item).isNotNull().value.deepEquals(updatedValue);
  });

  r.addTest('delete', (db) async {
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

  r.run();
}
