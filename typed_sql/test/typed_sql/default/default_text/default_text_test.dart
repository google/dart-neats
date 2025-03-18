// GENERATED CODE - DO NOT MODIFY BY HAND
//
// See tool/generate_default_tests.dart

import 'package:typed_sql/typed_sql.dart';

import '../../testrunner.dart';

part 'default_text_test.g.dart';

abstract final class TestDatabase extends Schema {
  Table<Item> get items;
}

const _defaultValue = 'hello';
const _nonDefaultValue = 'hello world';

@PrimaryKey(['id'])
abstract final class Item extends Model {
  @AutoIncrement()
  int get id;

  @DefaultValue(_defaultValue)
  String get value;
}

void main() {
  final r = TestRunner<TestDatabase>(
    setup: (db) async {
      await db.createTables();
    },
  );

  r.addTest('.insert() without default', (db) async {
    await db.items.insert(
      id: literal(1),
      value: literal(_nonDefaultValue),
    );

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.equals(_nonDefaultValue);
  });

  r.addTest('.insert() with default', (db) async {
    await db.items.insert(
      id: literal(1),
    );

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.equals(_defaultValue);
  });

  r.addTest('.update() default value', (db) async {
    await db.items.insert(
      id: literal(1),
    );

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.equals(_defaultValue);

    await db.items.byKey(id: 1).update((item, set) => set(
          value: literal(_nonDefaultValue),
        ));

    final updateItem = await db.items.first.fetch();
    check(updateItem).isNotNull().value.equals(_nonDefaultValue);
  });

  r.run();
}
