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

import '../../../testrunner.dart';

part 'schema_overrides_test.g.dart';

// Remark: please keep this schema in sync with ../bookstore/bookstore_test.dart
//         Documentation will assume that both of them uses the same schema,
//         we just have different clips of the regions and comments in:
//         - schema_default_value_test.dart
//         - schema_references_test.dart

// #region schema-override
@SqlOverride.schema(naming: .snake_case)
abstract final class Bookstore extends Schema {
  @SqlOverride.tableName(name: 'tbl_authors')
  Table<Author> get authors; // 'tbl_authors' in SQL

  Table<Book> get booksInStock; // 'books_in_stock' in SQL
}

// #endregion

// #region author-override
@PrimaryKey(['authorId'])
abstract final class Author extends Row {
  @AutoIncrement()
  int get authorId; // 'author_id' in SQL

  @Unique.field()
  @SqlOverride.field(name: 'author_name')
  @SqlOverride.field(dialect: 'sqlite', collation: 'NOCASE')
  @SqlOverride.field(dialect: 'mysql', columnType: 'VARCHAR(255)') // #hide
  String get name; // 'author_name' in SQL
}

// #endregion

@PrimaryKey(['bookId'])
abstract final class Book extends Row {
  @AutoIncrement()
  int get bookId;

  @Unique.field()
  @SqlOverride.field(dialect: 'mysql', columnType: 'VARCHAR(255)') // #hide
  String? get title;

  @References(table: 'authors', field: 'authorId', name: 'author', as: 'books')
  int get authorId;

  @DefaultValue(0)
  int get stock;
}

final initialAuthors = [
  (
    name: 'Easter Bunny',
  ),
  (
    name: 'Bucks Bunny',
  ),
];

final initialBooks = [
  // By Easter Bunny
  (title: 'Are Bunnies Unhealthy?', authorId: 1, stock: 10),
  (title: 'Cooking with Chocolate Eggs', authorId: 1, stock: 0),
  (title: 'Hiding Eggs for dummies', authorId: 1, stock: 12),
  // By Bucks Bunny
  (title: 'Vegetarian Dining', authorId: 2, stock: 42),
  (title: 'Vegan Dining', authorId: 2, stock: 3),
];

void main() {
  final r = TestRunner<Bookstore>(
    setup: (db) async {
      await db.createTables();

      // Insert test Authors and books
      for (final v in initialAuthors) {
        await db.authors
            .insert(
              name: toExpr(v.name),
            )
            .execute();
      }
      for (final v in initialBooks) {
        await db.booksInStock
            .insert(
              title: toExpr(v.title),
              authorId: toExpr(v.authorId),
              stock: toExpr(v.stock),
            )
            .execute();
      }
    },
  );

  r.addTest('authors.insert w. authorId', (db) async {
    await db.authors
        .insert(
          authorId: toExpr(42),
          name: toExpr('Roger Rabbit'),
        )
        .execute();
  });

  r.run();
}
