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

part 'group_by_reference_test.g.dart';

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

  r.addTest('books.groupBy(.authorId).aggregate(sum(.stock))', (db) async {
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
  });

  r.addTest('books.groupBy(.author).aggregate(sum(.stock))', (db) async {
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
            author.authorId,
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
  });

  r.addTest(
      'books.groupBy(.author).aggregate(sum(.stock)).select(.author, ...)',
      (db) async {
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
            author,
            stock,
            countBooksByAuthor,
          ),
        )
        .fetch();

    check(result).length.equals(2);
  });

  r.addTest(
      'books.groupBy(.author).aggregate(sum(.stock)).select(.author, ...).where(...)',
      (db) async {
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
            author,
            stock,
            countBooksByAuthor,
          ),
        )
        .where(
          (author, stock, countBooksByAuthor) =>
              author.name.equalsLiteral('Bucks Bunny'),
        )
        .fetch();

    check(result).length.equals(1);
  });

  r.addTest(
      'books.groupBy(.author).aggregate(sum(.stock)).select(.author, ...).where(...).first',
      (db) async {
    final (author, stock, countBooksByAuthor) = await db.books
        .groupBy((b) => (b.author,))
        .aggregate(
          (agg) => agg
              // aggregates:
              .sum((book) => book.stock)
              .count(),
        )
        .select(
          (author, stock, countBooksByAuthor) => (
            author,
            stock,
            countBooksByAuthor,
          ),
        )
        .where(
          (author, stock, countBooksByAuthor) =>
              author.name.equalsLiteral('Bucks Bunny'),
        )
        .first
        .fetchOrNulls();

    check(author).isNotNull()
      ..name.equals('Bucks Bunny')
      ..authorId.equals(2);
    check(stock).isNotNull().equals(45);
    check(countBooksByAuthor).isNotNull().equals(2);
  });

  r.addTest(
      'books.groupBy(.author, .authorId).aggregate(sum(.stock)).select(.author, ...).where(...).first',
      (db) async {
    final (author, stock, countBooksByAuthor) = await db.books
        // This doesn't really make sense, but it's nice to exercise that it works
        .groupBy((b) => (b.author, b.authorId))
        .aggregate(
          (agg) => agg
              // aggregates:
              .sum((book) => book.stock)
              .count(),
        )
        .select(
          (author, authorId, stock, countBooksByAuthor) => (
            author,
            stock,
            countBooksByAuthor,
          ),
        )
        .where(
          (author, stock, countBooksByAuthor) =>
              author.name.equalsLiteral('Bucks Bunny'),
        )
        .first
        .fetchOrNulls();

    check(author).isNotNull()
      ..name.equals('Bucks Bunny')
      ..authorId.equals(2);
    check(stock).isNotNull().equals(45);
    check(countBooksByAuthor).isNotNull().equals(2);
  });

  r.addTest('authors.groupBy(.books.first)', (db) async {
    final result = await db.authors
        // Again groupBy first book the author wrote doesn't really make sense
        // the group size will always be one. But it's nice to test that we can
        // group by a reference fetched from a subquery.
        .groupBy(
          (author) => (
            author.books.orderBy((b) => [(b.bookId, Order.ascending)]).first,
          ),
        )
        .aggregate(
          (agg) => agg //
              .count(), // should always be 1
        )
        .orderBy((author, firstBook) => [(author.authorId, Order.ascending)])
        .fetch();
    check(result).length.equals(2);
    check(result[0].$1).isNotNull().title.equals('Are Bunnies Unhealthy?');
    check(result[1].$1).isNotNull().title.equals('Vegetarian Dining');
    check(result[0].$2).isNotNull().equals(1);
    check(result[1].$2).isNotNull().equals(1);
  });

  r.run();
}
