// GENERATED CODE - DO NOT MODIFY BY HAND
//
// See tool/generate_crud_tests.dart

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

  r.addTest('insert', (db) async {
    await db.items.insert(
      id: literal(1),
      value: literal(initialValue),
    );

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.equals(initialValue);
  });

  r.addTest('update', (db) async {
    await db.items.insert(
      id: literal(1),
      value: literal(initialValue),
    );

    await db.items.updateAll((item, set) => set(
          value: literal(updatedValue),
        ));

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.equals(updatedValue);
  });

  r.addTest('delete', (db) async {
    await db.items.insert(
      id: literal(1),
      value: literal(initialValue),
    );

    final item1 = await db.items.first.fetch();
    check(item1).isNotNull();

    await db.items.where((i) => i.id.equalsLiteral(1)).delete();

    final item2 = await db.items.first.fetch();
    check(item2).isNull();
  });

  r.run();
}
