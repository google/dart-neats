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

part 'deep_extraction_test.g.dart';

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

  r.addTest(
    'Deep JSON extraction with mixed keys and indices',
    (db) async {
      await db.products
          .insertValue(
            name: 'Gadget',
            metadata: const JsonValue({
              'tags': ['electronics', 'new'],
              'specs': {
                'dimensions': [10, 20, 30],
                'color': 'black',
              },
            }),
          )
          .execute();

      final result = await db.products
          .select(
            (p) => (
              p.metadata['specs']['dimensions'][1].asInt(),
              p.metadata['tags'][0].asString(),
            ),
          )
          .first
          .fetch();

      check(result).isNotNull().equals((20, 'electronics'));
    },
    skipMysql: 'MariaDB fails to extract array index with parameterized path',
  );

  r.run();
}
