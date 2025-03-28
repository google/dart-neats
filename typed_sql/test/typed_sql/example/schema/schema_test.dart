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

part 'schema_test.g.dart';

// #region schema
abstract final class Bookstore extends Schema {
  Table<Author> get authors;
  Table<Book> get books;
}
// #endregion

// #region author-model
@PrimaryKey(['authorId'])
abstract final class Author extends Model {
  @AutoIncrement()
  int get authorId;

  @Unique()
  String get name;
}
// #endregion

// #region book-model
@PrimaryKey(['bookId'])
abstract final class Book extends Model {
  @AutoIncrement()
  int get bookId;

  String? get title;

  @References(
    // This fields references "authorId" from "authors" table
    table: 'authors',
    field: 'authorId',

    // The reference is _named_ "author", this gives rise to a
    // Expr<Book>.author property when building queries.
    name: 'author', // optional

    // This is referenced _as_ "books", this gives rise to a
    // Expr<Author>.books property when building queries.
    as: 'books', // optional
  )
  int get authorId;

  @DefaultValue(0)
  int get stock;
}
// #endregion

void main() {
  final r = TestRunner<Bookstore>();

  r.addTest('use the database', (db) async {
    // #region create-tables
    // Create tables
    await db.createTables();
    // #endregion

    // #region get-ddl
    // Get the database schema
    final ddl = createBookstoreTables(SqlDialect.postgres());
    // #endregion
    check(ddl).isNotEmpty();

    // #region insert-data
    // Insert a row into the "authors" table
    final author = await db.authors
        .insert(
          name: literal('Easter Bunny'),
        )
        .returnInserted()
        .executeAndFetch(); // returns Future<Author?>

    // Insert a row into the "books" table
    await db.books
        .insert(
          title: literal('How to hide eggs'),
          authorId: literal(author!.authorId),
        )
        .execute();
    // #endregion

    // #region query-data
    // Query for books where the title contains 'eggs'
    // select the title and author name
    final titleAndAuthor = await db.books
        .where(
          (book) => book.title
              .orElseLiteral('') // because title can be null
              .toLowerCase()
              .containsLiteral('eggs'),
        )
        .select(
          (book) => (
            book.title,
            book.author.name, // use the 'author' subquery property
          ),
        )
        .fetch();

    // Compare the results
    check(titleAndAuthor).unorderedEquals([
      ('How to hide eggs', 'Easter Bunny'),
    ]);
    // #endregion
  });

  r.run();
}
