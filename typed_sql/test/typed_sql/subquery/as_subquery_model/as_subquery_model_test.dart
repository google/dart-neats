// Copyright 2025 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:typed_sql/typed_sql.dart';

import '../../testrunner.dart';

part 'as_subquery_model_test.g.dart';

abstract final class TestDatabase extends Schema {
  Table<Item> get items;
}

@PrimaryKey(['id'])
abstract final class Item extends Row {
  @AutoIncrement()
  int get id;

  String get value;
}

void main() {
  final r = TestRunner<TestDatabase>(
    setup: (db) async {
      await db.createTables();
      await db.items.insert(id: toExpr(1), value: toExpr('a')).execute();
      await db.items.insert(id: toExpr(2), value: toExpr('b')).execute();
      await db.items.insert(id: toExpr(3), value: toExpr('c')).execute();
      await db.items.insert(id: toExpr(4), value: toExpr('c')).execute();
      await db.items.insert(id: toExpr(5), value: toExpr('c')).execute();
    },
  );

  r.addTest('db.select(db.items.asSubQuery.where().first)', (db) async {
    final (itemA, itemB) = await db.select(
      (
        db.items.asSubQuery.where((i) => i.id.equals(toExpr(1))).first,
        db.items.asSubQuery.where((i) => i.id.equals(toExpr(2))).first,
      ),
    ).fetchOrNulls();
    check(itemA).isNotNull().value.equals('a');
    check(itemB).isNotNull().value.equals('b');
  });

  r.addTest('db.select(db.items.asSubQuery.where(false).first)', (db) async {
    final (itemA, itemB) = await db.select(
      (
        db.items.asSubQuery.where((i) => i.id.equals(toExpr(1))).first,
        db.items.asSubQuery.where((i) => toExpr(false)).first,
      ),
    ).fetchOrNulls();
    check(itemA).isNotNull().value.equals('a');
    check(itemB).isNull();
  });

  r.addTest('.where(items.where(.value = value).exists()).delete()',
      (db) async {
    await db.items
        .where(
          (item) => db.items.asSubQuery
              .where(
                (i) => i.value.equals(item.value) & i.id.notEquals(item.id),
              )
              .exists(),
        )
        .delete()
        .execute();
    final remaining = await db.items.select((i) => (i.id, i.value)).fetch();
    check(remaining).unorderedEquals([
      (1, 'a'),
      (2, 'b'),
    ]);
  });

  r.addTest(
      'db.items.select(.value, db.items.asSubQuery.where(.value = value).orderBy(.id).first.id)',
      (db) async {
    final result = await db.items
        .select(
          (item) => (
            item.value,
            db.items.asSubQuery
                .where((i) => i.value.equals(item.value))
                .orderBy((i) => [(i.id, Order.ascending)])
                .first // test .first on SubQuery!
                .id,
          ),
        )
        .fetch();
    check(result).unorderedEquals([
      ('a', 1),
      ('b', 2),
      ('c', 3),
      ('c', 3),
      ('c', 3),
    ]);
  });

  r.addTest(
      'db.items.select(.value, db.items.where(.value = value).orderBy(.id).first.asExpr.id)',
      (db) async {
    final result = await db.items
        .select(
          (item) => (
            item.value,
            db.items
                .where((i) => i.value.equals(item.value))
                .orderBy((i) => [(i.id, Order.ascending)])
                .first
                .asExpr // test QuerySingle.first
                .id,
          ),
        )
        .fetch();
    check(result).unorderedEquals([
      ('a', 1),
      ('b', 2),
      ('c', 3),
      ('c', 3),
      ('c', 3),
    ]);
  });

  r.addTest('test 1', (db) async {
    await db.items
        .select((i) => (
              i.id,
              db.items.where((item) => item.id.equals(i.id)).count().asExpr,
            ))
        .fetch();
  });

  r.addTest('test 2', (db) async {
    await db.items
        .select((i) => (
              i.id,
              db.items
                  .where((item) => db.items
                      .where(
                        (item2) =>
                            item2.id.equals(i.id) & item2.id.equals(item.id),
                      )
                      .exists()
                      .asExpr
                      .isTrue())
                  .count()
                  .asExpr,
            ))
        .fetch();
  });

  r.run();
}
