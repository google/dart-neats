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

part 'schema_default_value_test.g.dart';

// Remark: please keep this schema in sync with ../bookstore/bookstore_test.dart
//         Documentation will assume that both of them uses the same schema,
//         we just have different clips of the regions and comments in:
//         - schema_default_value_test.dart
//         - schema_references_test.dart

abstract final class Bookstore extends Schema {
  Table<Author> get authors;
  Table<Book> get books;
}

@PrimaryKey(['authorId'])
abstract final class Author extends Row {
  @AutoIncrement()
  int get authorId;

  @Unique()
  @SqlOverride(dialect: 'mysql', columnType: 'VARCHAR(255)') // #hide
  String get name;
}

// #region book-model
@PrimaryKey(['bookId'])
abstract final class Book extends Row {
  @AutoIncrement()
  int get bookId;

  String? get title;

  @References(table: 'authors', field: 'authorId', name: 'author', as: 'books')
  int get authorId;

  @DefaultValue(0) // Gives the `stock` field to have a default value!
  int get stock;
}
// #endregion

void main() {
  final r = TestRunner<Bookstore>();

  r.addTest('use the database', (db) async {
    // Create tables
    await db.createTables();

    // Get the database schema
    final ddl = createBookstoreTables(SqlDialect.postgres());
    check(ddl).isNotEmpty();
  });

  r.run();
}
