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

part 'exists_model_test.g.dart';

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

  r.addTest('db.select(items.exists())', (db) async {
    final exists = await db.select(
      (db.items.exists().asExpr,),
    ).fetch();
    check(exists).isNotNull().isTrue();
  });

  r.addTest('db.items.where(.id.equals(1)).exists()', (db) async {
    final exists = await db.items
        .where((item) => item.id.equals(literal(1)))
        .exists()
        .fetch();
    check(exists).isNotNull().isTrue();
  });

  r.addTest('db.items.where(.id.equals(-1)).exists()', (db) async {
    final exists = await db.items
        .where((item) => item.id.equals(literal(-1)))
        .exists()
        .fetch();
    check(exists).isNotNull().isFalse();
  });

  r.addTest('db.items.select(..., db.items.where(.value < value).exists())',
      (db) async {
    final result = await db.items
        .select(
          (item) => (
            item.id,
            item.value,
            db.items.where((i) => i.value.lessThan(item.value)).exists().asExpr
          ),
        )
        .fetch();
    check(result).unorderedEquals({
      (1, 'a', false),
      (2, 'b', true),
      (3, 'c', true),
      (4, 'c', true),
      (5, 'c', true),
    });
  });

  r.addTest('db.items.where(db.items.where(.value < value).exists()))',
      (db) async {
    final result = await db.items
        .where(
          (item) => db.items
              .where((i) => i.value.lessThan(item.value))
              .exists()
              .asExpr
              .orElseLiteral(false),
        )
        .select(
          (item) => (
            item.id,
            item.value,
          ),
        )
        .fetch();
    check(result).unorderedEquals({
      (2, 'b'),
      (3, 'c'),
      (4, 'c'),
      (5, 'c'),
    });
  });

  r.addTest(
      'db.items.where(db.items.asSubQuery.where(.value < value).exists()))',
      (db) async {
    final result = await db.items
        .where(
          (item) => db.items.asSubQuery
              .where((i) => i.value.lessThan(item.value))
              .exists(),
        )
        .select(
          (item) => (
            item.id,
            item.value,
          ),
        )
        .fetch();
    check(result).unorderedEquals({
      (2, 'b'),
      (3, 'c'),
      (4, 'c'),
      (5, 'c'),
    });
  });

  r.run();
}
