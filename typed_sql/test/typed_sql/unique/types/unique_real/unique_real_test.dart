// GENERATED CODE - DO NOT MODIFY BY HAND
//
// See tool/generate_unique_tests.dart

import 'package:typed_sql/typed_sql.dart';

import '../../../testrunner.dart';

part 'unique_real_test.g.dart';

final _value1 = 42.2;
final _value2 = 3.14;

abstract final class PrimaryDatabase extends Schema {
  Table<Item> get items;
}

@PrimaryKey(['id'])
abstract final class Item extends Row {
  @AutoIncrement()
  int get id;

  @Unique.field()
  double get value;
}

void main() {
  final r = TestRunner<PrimaryDatabase>(
    setup: (db) async {
      await db.createTables();
    },
  );

  r.addTest('db.items.insert', (db) async {
    await db.items.insert(value: toExpr(_value1)).execute();
    await db.items.insert(value: toExpr(_value2)).execute();
  });

  r.addTest('db.items.insert (unique violation)', (db) async {
    await db.items.insert(value: toExpr(_value1)).execute();
    try {
      await db.items.insert(value: toExpr(_value1)).execute();
      fail('expected violation of unique constraint!');
    } on OperationException {
      return;
    }
  });

  r.addTest('db.items.byValue()', (db) async {
    await db.items.insert(value: toExpr(_value1)).execute();
    await db.items.insert(value: toExpr(_value2)).execute();

    final item = await db.items.byValue(_value1).fetch();
    check(item).isNotNull().value.equals(_value1);
  });

  r.addTest('db.items.byValue() - not found', (db) async {
    await db.items.insert(value: toExpr(_value1)).execute();

    final item = await db.items.byValue(_value2).fetch();
    check(item).isNull();
  });

  r.run();
}
