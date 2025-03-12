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

  r.addTest('Query<(Expr<Model>,)>.unionAll(NULL)', (db) async {
    final q1 = db.select((db.items.byKey(id: 42).asExpr,)).asQuery;
    final q2 = db.select((literal(null),)).asQuery;

    // TODO: What if Expr._columnType was a thing? Then we could possibly do
    //       the cast correctly. And if we get columnType UNKNOWN we know that
    //       somewhere it's null so a cast to Expr<Model> involves explode!
    //       Something something... still not sure how to hide such details from
    //       dialect.. maybe it has to live in CompositeQuery!
    //       I'm really not sure!!

    final result = await q1.unionAll(q2).fetch().toList();
    print(result);
  });

  r.run();
}
