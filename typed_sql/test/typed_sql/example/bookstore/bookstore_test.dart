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

import 'dart:async';

import 'package:typed_sql/typed_sql.dart';

import '../../testrunner.dart';

part 'bookstore_test.g.dart';

// #region bookstore-schema
abstract final class Bookstore extends Schema {
  Table<Author> get authors;
  Table<Book> get books;
}

@PrimaryKey(['authorId'])
abstract final class Author extends Model {
  @AutoIncrement()
  int get authorId;

  String get name;
}

@PrimaryKey(['bookId'])
abstract final class Book extends Model {
  @AutoIncrement()
  int get bookId;

  String get title;

  @References(table: 'authors', field: 'authorId', name: 'author', as: 'books')
  int get authorId;

  int get stock;
}
// #endregion

// #region initial-data
final initialAuthors = [
  (authorId: 1, name: 'Easter Bunny'),
  (authorId: 2, name: 'Bucks Bunny'),
];

final initialBooks = [
  // By Easter Bunny
  (bookId: 1, title: 'Are Bunnies Unhealthy?', authorId: 1, stock: 10),
  (bookId: 2, title: 'Cooking with Chocolate Eggs', authorId: 1, stock: 0),
  (bookId: 3, title: 'Hiding Eggs for dummies', authorId: 1, stock: 12),
  // By Bucks Bunny
  (bookId: 4, title: 'Vegetarian Dining', authorId: 2, stock: 42),
  (bookId: 5, title: 'Vegan Dining', authorId: 2, stock: 3),
];
// #endregion

void main() {
  final r = TestRunner<Bookstore>(
    setup: (db) async {
      await db.createTables();

      // Insert test Authors and books
      for (final v in initialAuthors) {
        await db.authors
            .insertLiteral(
              authorId: v.authorId,
              name: v.name,
            )
            .execute();
      }
      for (final v in initialBooks) {
        await db.books
            .insertLiteral(
              bookId: v.bookId,
              title: v.title,
              authorId: v.authorId,
              stock: v.stock,
            )
            .execute();
      }
    },
  );

  r.addTest('books.select(title, book.author.name)', (db) async {
    final result = await db.books
        .select(
          (b) => (
            b.title,
            b.author.name,
          ),
        )
        .fetch();
    check(result).unorderedEquals([
      ('Are Bunnies Unhealthy?', 'Easter Bunny'),
      ('Cooking with Chocolate Eggs', 'Easter Bunny'),
      ('Hiding Eggs for dummies', 'Easter Bunny'),
      ('Vegetarian Dining', 'Bucks Bunny'),
      ('Vegan Dining', 'Bucks Bunny'),
    ]);
  });

  r.addTest('books.select(.stock).sum()', (db) async {
    // #region sum-books-in-inventory
    final result = await db.books
        .select(
          (book) => (book.stock,),
        ) // .select() returns Query<(Expr<int>,)>, which has a .sum() method
        .sum()
        .fetch();

    check(result).equals(67);
    // #endregion
  });

  r.addTest('.select(books.select(.stock).sum(), books.count())', (db) async {
    // #region sum-books-and-count-books-in-inventory
    final (totalStock, countDifferntBooks) = await db.select(
      (
        db.books.asSubQuery.select((book) => (book.stock,)).sum(),
        db.books.asSubQuery.count(),
      ),
    ).fetchOrNulls();

    check(totalStock).equals(67);
    check(countDifferntBooks).equals(5);
    // #endregion
  });

  r.addTest(
      '.select(books.asSubQuery.select(.stock).sum(), books.asSubQuery.count())',
      (db) async {
    // #region sum-books-and-count-books-in-inventory-as-expr
    final (totalStock, countDifferntBooks) = await db.select(
      (
        db.books.select((book) => (book.stock,)).sum().asExpr,
        db.books.count().asExpr,
      ),
    ).fetchOrNulls();

    check(totalStock).equals(67);
    check(countDifferntBooks).equals(5);
    // #endregion
  });

  r.addTest('books.groupBy(null).aggregate(sum(.stock))', (db) async {
    final (totalStock, countDifferntBooks) = await db.books
        .groupBy((b) => (literal(null),))
        .aggregate(
          (agg) => //
              agg.sum((book) => book.stock).count(),
        )
        .select(
          (_, stock, count) => (stock, count),
        )
        .first // since there is only one group
        .fetchOrNulls();

    check(totalStock).equals(67);
    check(countDifferntBooks).equals(5);
  });

  r.addTest('books.groupBy(.author).aggregate(sum(.stock))', (db) async {
    // #region sum-books-group-by-author
    final result = await db.books
        .groupBy((b) => (b.author,))
        .aggregate(
          (agg) => agg
              // aggregates:
              .sum((book) => book.stock)
              .count(),
        )
        .select(
          (author, stock, countBooksByAuthor) => (
            author.name,
            stock,
            countBooksByAuthor,
          ),
        )
        .fetch();

    check(result).unorderedEquals([
      // Author, total stock, count of books
      ('Easter Bunny', 22, 3),
      ('Bucks Bunny', 45, 2),
    ]);
    // #endregion
  });

  r.addTest('books.groupBy(.author).aggregate(sum(.stock))', (db) async {
    // #region sum-books-group-by-authorId
    final result = await db.books
        .groupBy((b) => (b.authorId,))
        .aggregate(
          (agg) => agg
              // aggregates:
              .sum((book) => book.stock)
              .count(),
        )
        .select(
          (authorId, stock, countBooksByAuthor) => (
            authorId,
            stock,
            countBooksByAuthor,
          ),
        )
        .fetch();

    check(result).unorderedEquals([
      // AuthorId, total stock, count of books
      (1, 22, 3),
      (2, 45, 2),
    ]);
    // #endregion
  });

  r.addTest('authors.select(.name, .books.sum(.stock))', (db) async {
    // #region sum-books-by-author-with-subquery
    final result = await db.authors
        .select(
          (author) => (
            author.name,
            author.books.select((b) => (b.stock,)).sum(),
          ),
        )
        .fetch();
    check(result).unorderedEquals([
      ('Easter Bunny', 22),
      ('Bucks Bunny', 45),
    ]);
    // #endregion
  });

  r.addTest(
      'authors.select(.firstname, .lastname, db.where(...).books.sum(.stock))',
      (db) async {
    final result = await db.authors
        .select(
          (author) => (
            author.name,
            db.books
                .where((b) => b.authorId.equals(author.authorId))
                .select((b) => (b.stock,))
                .sum()
                .asExpr,
          ),
        )
        .fetch();
    check(result).unorderedEquals([
      ('Easter Bunny', 22),
      ('Bucks Bunny', 45),
    ]);
  });

  r.addTest(
      'authors.join(books).groupBy(.author).aggregate(sum(.stock), count())',
      (db) async {
    // #region sum-books-group-by-using-join
    final result = await db.authors
        .join(db.books)
        .on((author, book) => author.authorId.equals(book.authorId))
        .groupBy((author, book) => (author,))
        .aggregate(
          (agg) => agg
              // aggregates:
              .sum((author, book) => book.stock)
              .count(),
        )
        .select(
          (author, stock, count) => (
            author.name,
            stock,
            count,
          ),
        )
        .fetch();

    check(result).unorderedEquals([
      // Author, total stock, count of books
      ('Easter Bunny', 22, 3),
      ('Bucks Bunny', 45, 2),
    ]);
    // #endregion
  });

  r.run();
}
