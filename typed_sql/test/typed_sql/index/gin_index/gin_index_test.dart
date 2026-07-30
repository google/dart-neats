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

part 'gin_index_test.g.dart';

abstract final class ProductCatalog extends Schema {
  Table<Product> get products;
}

@PrimaryKey(['id'])
@Index(fields: ['tags'], method: .gin)
abstract final class Product extends Row {
  @AutoIncrement()
  int get id;

  String get name;

  @Index.field(method: .gin)
  JsonValue get metadata;

  JsonValue get tags;
}

void main() {
  final r = TestRunner<ProductCatalog>(
    setup: (db) async {
      await db.createTables();
    },
  );

  r.addTest('createTables() succeeds with GIN indexes on JSON fields', (
    db,
  ) async {
    await db.products
        .insertValue(
          name: 'Gadget',
          metadata: const JsonValue({'color': 'black', 'weight': 10}),
          tags: const JsonValue(['electronics', 'new']),
        )
        .execute();

    final item = await db.products.first.fetch();
    check(item).isNotNull()
      ..name.equals('Gadget')
      ..metadata.deepEquals(const JsonValue({'color': 'black', 'weight': 10}))
      ..tags.deepEquals(const JsonValue(['electronics', 'new']));
  });

  r.run();
}
