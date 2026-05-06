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

part 'null_handling_test.g.dart';

abstract final class ProductCatalog extends Schema {
  Table<Product> get products;
}

@PrimaryKey(['id'])
abstract final class Product extends Row {
  @AutoIncrement()
  int get id;

  String get name;

  @DefaultValue(JsonValue({}))
  JsonValue get metadata;
}

void main() {
  final r = TestRunner<ProductCatalog>(
    setup: (db) async {
      await db.createTables();
    },
  );

  r.addTest('JSON null vs SQL NULL', (db) async {
    await db.products
        .insertValue(
          name: 'NullGadget',
          metadata: const JsonValue(null),
        )
        .execute();

    final result = await db.products
        .where((p) => p.name.equals(toExpr('NullGadget')))
        .select(
          (p) => (
            p.metadata.isNull(),
            p.metadata.asString().isNull(),
          ),
        )
        .first
        .fetch();

    check(result).isNotNull().equals((false, true));
  });

  r.run();
}
