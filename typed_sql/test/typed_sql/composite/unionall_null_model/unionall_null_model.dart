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

part 'unionall_null_model.g.dart';

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
    },
  );

  // Tests that we can union with NULL, this is difficult because it requires
  // casts, and those casts needs to be exploded if the left hand side is an
  // Expr<Model>

  r.addTest('.unionAll(NULL)', (db) async {
    final q1 = db.select((db.items.byKey(id: 42).asExpr,)).asQuery;
    final q2 = db.select((literal(null),)).asQuery;

    final result = await q1.unionAll(q2).fetch();
    check(result).deepEquals([null, null]);
  });

  r.addTest('.unionAll((NULL, 42))', (db) async {
    final q1 =
        db.select((db.items.byKey(id: 42).asExpr,)).asQuery.select((item) => (
              item,
              literal(42),
            ));
    final q2 = db.select((literal(null), literal(42))).asQuery;

    final result = await q1.unionAll(q2).fetch();
    check(result).length.equals(2);
    check(result).first.equals((null, 42));
  });

  r.addTest('.insert + .unionAll((NULL, 42))', (db) async {
    await db.items.insert(id: literal(42), value: literal('hello')).execute();
    final q1 =
        db.select((db.items.byKey(id: 42).asExpr,)).asQuery.select((item) => (
              item,
              literal(42),
            ));
    final q2 = db.select((literal(null), literal(42))).asQuery;

    final result = await q1.unionAll(q2).fetch();
    check(result).length.equals(2);
    final (item, i) = result.first;
    check(item).isNotNull().value.equals('hello');
    check(i).equals(42);
  });

  r.addTest('.unionAll(select(NULL).where(42 > 21)).select()', (db) async {
    final q1 = db.select((db.items.byKey(id: 42).asExpr,)).asQuery;
    // This tests that .where doesn't change the expression in a manner that
    // breaks our cast!
    final q2 = db
        .select((literal(null),))
        .asQuery
        // Using a non-trival expression to ensure trivial avoid optimizations
        // don't compile the WHERE-clause away.
        .where((v) => literal(42) > literal(21))
        .select((v) => (v,));

    final result = await q1.unionAll(q2).fetch();
    check(result).deepEquals([null, null]);
  });

  r.run();
}
