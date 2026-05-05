// Copyright 2026 Google LLC
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

part 'json_groupby_caveat_test.g.dart';

abstract final class ProductCatalog extends Schema {
  Table<Product> get products;
}

@PrimaryKey(['id'])
abstract final class Product extends Row {
  @AutoIncrement()
  int get id;

  String get name;

  JsonValue get metadata;
}

void main() {
  final r = TestRunner<ProductCatalog>(
    setup: (db) async {
      await db.createTables();
    },
  );

  // This will fail if we use parameterization to inject JSON paths, but we
  // don't do that anymore.
  r.addTest(
    'GroupBy JSON field',
    (db) async {
      await db.products
          .insertValue(name: 'A', metadata: const JsonValue({'category': 'X'}))
          .execute();
      await db.products
          .insertValue(name: 'B', metadata: const JsonValue({'category': 'X'}))
          .execute();
      await db.products
          .insertValue(name: 'C', metadata: const JsonValue({'category': 'Y'}))
          .execute();

      final counts = await db.products
          .groupBy((p) => (p.metadata['category'].asString(),))
          .aggregate((agg) => agg.count())
          .fetch();

      check(counts).unorderedEquals([
        ('X', 2),
        ('Y', 1),
      ]);
    },
  );

  r.run();
}
