import 'package:typed_sql/typed_sql.dart';

import '../../testrunner.dart';

part 'all_default_values_test.g.dart';

@PrimaryKey(['id'])
abstract final class Item extends Row {
  @AutoIncrement()
  int get id;

  @DefaultValue('Bob')
  String get name;

  @DefaultValue.epoch
  DateTime get birthday;

  @DefaultValue.now
  DateTime get createdAt;

  @DefaultValue.dateTime(2035, 11, 17)
  DateTime get expires;
}

abstract final class MySchema extends Schema {
  Table<Item> get items;
}

void main() {
  final r = TestRunner<MySchema>(
    setup: (db) async {
      await db.createTables();
    },
  );

  r.addTest('.insert() DEFAULT VALUES', (db) async {
    // Inserting a row with all default values.
    // This requires special syntax in sqlite and postgres.
    await db.items.insert().execute();

    final item = await db.items.first.fetch();
    check(item).isNotNull().name.equals('Bob');
  });

  r.addTest('override defaults', (db) async {
    final bday = DateTime.utc(2000, 1, 1);
    final now = DateTime.utc(2023, 10, 27, 12, 0, 0);
    final exp = DateTime.utc(2025, 1, 1);

    await db.items
        .insert(
          name: toExpr('Charlie'),
          birthday: toExpr(bday),
          createdAt: toExpr(now),
          expires: toExpr(exp),
        )
        .execute();

    final item = await db.items
        .where(
          (i) => i.name.equalsValue('Charlie'),
        )
        .first
        .fetch();

    check(item).isNotNull().birthday.equals(bday);
    check(item).isNotNull().createdAt.equals(now);
    check(item).isNotNull().expires.equals(exp);
  });

  r.run();
}
