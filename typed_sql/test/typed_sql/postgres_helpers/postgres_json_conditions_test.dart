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

import 'package:test/test.dart';
import 'package:typed_sql/postgres_helpers.dart';
import 'package:typed_sql/typed_sql.dart';

import '../testrunner.dart';

part 'postgres_json_conditions_test.g.dart';

const _notPostgres =
    'JSONB containment/existence operators are PostgreSQL-only, see '
    'package:typed_sql/postgres_helpers.dart';

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
      await db.products
          .insertValue(
            name: 'Gadget',
            metadata: const JsonValue({'color': 'black', 'weight': 10}),
          )
          .execute();
      await db.products
          .insertValue(
            name: 'Widget',
            metadata: const JsonValue({'color': 'red'}),
          )
          .execute();
    },
  );

  r.addTest(
    'contains() filters using the `@>` containment operator',
    (db) async {
      final names = await db.products
          .where(
            (p) =>
                p.metadata.containsValue(const JsonValue({'color': 'black'})),
          )
          .select((p) => (p.name,))
          .fetch();

      check(names).single.equals('Gadget');
    },
    skipSqlite: _notPostgres,
    skipMysql: _notPostgres,
  );

  r.addTest(
    'containedBy() filters using the `<@` containment operator',
    (db) async {
      final names = await db.products
          .where(
            (p) => p.metadata.containedByValue(
              const JsonValue({'color': 'black', 'weight': 10, 'extra': true}),
            ),
          )
          .select((p) => (p.name,))
          .fetch();

      check(names).single.equals('Gadget');
    },
    skipSqlite: _notPostgres,
    skipMysql: _notPostgres,
  );

  r.addTest(
    'hasKey() filters using the `?` operator',
    (db) async {
      final names = await db.products
          .where((p) => p.metadata.hasKey('weight'))
          .select((p) => (p.name,))
          .fetch();

      check(names).single.equals('Gadget');
    },
    skipSqlite: _notPostgres,
    skipMysql: _notPostgres,
  );

  r.addTest(
    'hasAnyKey() filters using the `?|` operator',
    (db) async {
      final names = await db.products
          .where((p) => p.metadata.hasAnyKey(['weight', 'nonsense']))
          .select((p) => (p.name,))
          .fetch();

      check(names).single.equals('Gadget');
    },
    skipSqlite: _notPostgres,
    skipMysql: _notPostgres,
  );

  r.addTest(
    'hasAllKeys() filters using the `?&` operator',
    (db) async {
      final names = await db.products
          .where((p) => p.metadata.hasAllKeys(['color', 'weight']))
          .select((p) => (p.name,))
          .fetch();

      check(names).single.equals('Gadget');
    },
    skipSqlite: _notPostgres,
    skipMysql: _notPostgres,
  );

  r.run();

  test('hasKey() throws UnsupportedError when compiled for SQLite', () async {
    final adapter = DatabaseAdapter.sqlite3TestDatabase();
    final db = Database<ProductCatalog>(adapter, SqlDialect.sqlite());
    try {
      await db.createTables();

      await check(
        db.products.where((p) => p.metadata.hasKey('color')).fetch(),
      ).throws<UnsupportedError>();
    } finally {
      await adapter.close();
    }
  });
}
