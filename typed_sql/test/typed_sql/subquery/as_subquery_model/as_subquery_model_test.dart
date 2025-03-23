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

import 'package:typed_sql/adaptor.dart';
import 'package:typed_sql/typed_sql.dart';

import '../../testrunner.dart';

part 'as_subquery_model_test.g.dart';

abstract final class TestDatabase extends Schema {
  Table<Item> get items;
}

@PrimaryKey(['id'])
abstract final class Item extends Model {
  @AutoIncrement()
  int get id;

  String get value;
}

void main() {
  final r = TestRunner<TestDatabase>(
    setup: (db) async {
      await db.createTables();
      await db.items.insertLiteral(id: 1, value: 'a').execute();
      await db.items.insertLiteral(id: 2, value: 'b').execute();
      await db.items.insertLiteral(id: 3, value: 'c').execute();
      await db.items.insertLiteral(id: 4, value: 'c').execute();
      await db.items.insertLiteral(id: 5, value: 'c').execute();
    },
  );

  r.addTest('db.select(db.items.asSubQuery.where().first)', (db) async {
    final (itemA, itemB) = await db.select(
      (
        db.items.asSubQuery.where((i) => i.id.equals(literal(1))).first,
        db.items.asSubQuery.where((i) => i.id.equals(literal(2))).first,
      ),
    ).fetchOrNulls();
    check(itemA).isNotNull().value.equals('a');
    check(itemB).isNotNull().value.equals('b');
  });

  r.addTest('db.select(db.items.asSubQuery.where(false).first)', (db) async {
    final (itemA, itemB) = await db.select(
      (
        db.items.asSubQuery.where((i) => i.id.equals(literal(1))).first,
        db.items.asSubQuery.where((i) => literal(false)).first,
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
                .orderBy((i) => i.id)
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
                .orderBy((i) => i.id)
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

  r.run();
}
