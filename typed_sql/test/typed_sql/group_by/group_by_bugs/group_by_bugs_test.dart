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

part 'group_by_bugs_test.g.dart';

abstract final class TestDatabase extends Schema {
  Table<Item> get items;
}

@PrimaryKey(['id'])
abstract final class Item extends Row {
  @AutoIncrement()
  int get id;

  String get category;

  JsonValue get data;

  int get score;
}

final _testData = [
  (category: 'A', data: JsonValue({'type': 'X', 'val': 10}), score: 100),
  (category: 'A', data: JsonValue({'type': 'X', 'val': 20}), score: 200),
  (category: 'A', data: JsonValue({'type': 'Y', 'val': 30}), score: 300),
  (category: 'B', data: JsonValue({'type': 'X', 'val': 40}), score: 400),
  (category: 'B', data: JsonValue({'type': 'Z', 'val': 50}), score: 500),
];

void main() {
  final r = TestRunner<TestDatabase>(
    setup: (db) async {
      await db.createTables();

      for (final v in _testData) {
        await db.items
            .insert(
              category: toExpr(v.category),
              data: toExpr(v.data),
              score: toExpr(v.score),
            )
            .execute();
      }
    },
  );

  r.addTest('groupBy(json subfield)', (db) async {
    final result = await db.items
        .groupBy((i) => (i.data['type'].asString(),))
        .aggregate((agg) => agg.count())
        .fetch();

    // X: 3
    // Y: 1
    // Z: 1

    check(result).unorderedEquals([
      ('X', 3),
      ('Y', 1),
      ('Z', 1),
    ]);
  });

  r.addTest('groupBy(category).aggregate(sum(score * score))', (db) async {
    final result = await db.items
        .groupBy((i) => (i.category,))
        .aggregate((agg) => agg.sum((i) => i.score * i.score))
        .fetch();

    // A: 100^2 + 200^2 + 300^2 = 10000 + 40000 + 90000 = 140000
    // B: 400^2 + 500^2 = 160000 + 250000 = 410000

    check(result).unorderedEquals([
      ('A', 140000),
      ('B', 410000),
    ]);
  });

  r.addTest('groupBy.aggregate.orderBy.limit', (db) async {
    final result = await db.items
        .groupBy((i) => (i.category,))
        .aggregate((agg) => agg.sum((i) => i.score))
        .orderBy((category, sumScore) => [(sumScore, Order.descending)])
        .limit(1)
        .fetch();

    // A sum: 100+200+300 = 600
    // B sum: 400+500 = 900

    check(result).unorderedEquals([
      ('B', 900),
    ]);
  });

  r.addTest('groupBy(subquery count)', (db) async {
    // This is a crazy query: group items by how many items are in their category
    final result = await db.items
        .groupBy((i) => (
              db.items.asSubQuery
                  .where((i2) => i2.category.equals(i.category))
                  .count(),
            ))
        .aggregate((agg) => agg.count())
        .fetch();

    // Category A has 3 items. Category B has 2 items.
    // So we group by 3 and 2.
    // Group 3 has 3 rows (from category A).
    // Group 2 has 2 rows (from category B).

    check(result).unorderedEquals([
      (3, 3),
      (2, 2),
    ]);
  });

  r.addTest('nested aggregation', (db) async {
    // Group by category, sum scores, then group by that sum and count how many categories have that sum
    final result = await db.items
        .groupBy((i) => (i.category,))
        .aggregate((agg) => agg.sum((i) => i.score))
        .groupBy((category, sumScore) => (sumScore,))
        .aggregate((agg) => agg.count())
        .fetch();

    // A sum: 600
    // B sum: 900
    // Sums are 600 and 900.
    // Group by 600 -> count 1
    // Group by 900 -> count 1

    check(result).unorderedEquals([
      (600, 1),
      (900, 1),
    ]);
  });

  r.run();
}
