import 'package:typed_sql/typed_sql.dart';

import '../../testrunner.dart';

part 'default_date_time_test.g.dart';

@PrimaryKey(['id'])
abstract final class Item extends Row {
  @AutoIncrement()
  int get id;

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
      await db.items.insert(name: toExpr('Bob')).execute();
    },
  );

  r.addTest('DefaultValue.epoch', (db) async {
    final item = await db.items.first.fetch();
    check(item).isNotNull().birthday.equals(DateTime.utc(1970));
  });

  r.addTest('DefaultValue.now', (db) async {
    // Allow 1s drift, this also fixes issues where databases don't have the
    // same resolution as Dart does.
    final before = DateTime.now().toUtc().subtract(const Duration(seconds: 1));
    await db.items.insert(name: toExpr('Alice')).execute();
    final after = DateTime.now().toUtc().add(const Duration(seconds: 1));

    final item = await db.items
        .where(
          (i) => i.name.equalsValue('Alice'),
        )
        .first
        .fetch();

    check(item).isNotNull().createdAt
      ..isGreaterOrEqual(before)
      ..isLessOrEqual(after);
  });

  r.addTest('DefaultValue.dateTime', (db) async {
    final item = await db.items.first.fetch();
    check(item).isNotNull().expires.equals(DateTime.utc(2035, 11, 17));
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
