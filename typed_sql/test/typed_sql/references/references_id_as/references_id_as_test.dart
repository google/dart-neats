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

part 'references_id_as_test.g.dart';

abstract final class TestDatabase extends Schema {
  Table<Author> get authors;
  Table<Book> get books;
}

@PrimaryKey(['authorId'])
abstract final class Author extends Model {
  @AutoIncrement()
  int get authorId;

  String get firstname;
  String get lastname;
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

final _testAuthors = [
  (authorId: 1, firstname: 'John', lastname: 'Doe'),
  (authorId: 2, firstname: 'Jane', lastname: 'Doe'),
  (authorId: 3, firstname: 'Easter', lastname: 'Bunny'),
  (authorId: 4, firstname: 'Bucks', lastname: 'Bunny'),
];

final _testBooks = [
  // By John Doe
  (bookId: 1, title: 'The Mystery of John Doe', authorId: 1, stock: 0),
  (bookId: 2, title: 'Who is John Doe?', authorId: 1, stock: 5),
  // By Jane Doe
  (bookId: 3, title: 'Who is Jane Doe?', authorId: 2, stock: 5),
  (bookId: 4, title: 'The Mystery of Jane Doe', authorId: 2, stock: 2),
  // By Easter Bunny
  (bookId: 5, title: 'Are Bunnies Unhealthy?', authorId: 3, stock: 10),
  (bookId: 6, title: 'Cooking with Chocolate Eggs', authorId: 3, stock: 0),
  (bookId: 7, title: 'Hiding Eggs for dummies', authorId: 3, stock: 12),
  // By Bucks Bunny
  (bookId: 8, title: 'Vegetarian Dining', authorId: 4, stock: 42),
  (bookId: 9, title: 'Vegan Dining', authorId: 4, stock: 3),
];

void main() {
  final r = TestRunner<TestDatabase>(
    setup: (db) async {
      await db.createTables();

      // Insert test Authrs and books
      for (final v in _testAuthors) {
        await db.authors
            .insertLiteral(
              authorId: v.authorId,
              firstname: v.firstname,
              lastname: v.lastname,
            )
            .execute();
      }
      for (final v in _testBooks) {
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

  r.addTest('authors.fetch()', (db) async {
    final result = await db.authors.fetch();
    check(result).length.equals(4);
  });

  r.addTest('books.where(.author.lastname.equals(Doe))', (db) async {
    final result = await db.books
        .where((b) => b.author.lastname.equalsLiteral('Doe'))
        .fetch();
    check(result).length.equals(4);
  });

  r.addTest('books.select(book, book.author)', (db) async {
    final result = await db.books
        .select(
          (b) => (b, b.author),
        )
        .fetch();
    check(result).length.equals(9);
    for (final (book, author) in result) {
      check(book.authorId).equals(author.authorId);
    }
  });

  r.addTest('books.select(title, book.author.firstname)', (db) async {
    final result = await db.books
        .select(
          (b) => (
            b.title,
            b.author.firstname,
          ),
        )
        .fetch();
    check(result).unorderedEquals([
      ('The Mystery of John Doe', 'John'),
      ('Who is John Doe?', 'John'),
      ('Who is Jane Doe?', 'Jane'),
      ('The Mystery of Jane Doe', 'Jane'),
      ('Are Bunnies Unhealthy?', 'Easter'),
      ('Cooking with Chocolate Eggs', 'Easter'),
      ('Hiding Eggs for dummies', 'Easter'),
      ('Vegetarian Dining', 'Bucks'),
      ('Vegan Dining', 'Bucks'),
    ]);
  });

  r.addTest('authors.where(.books.count() >= 3)', (db) async {
    final result = await db.authors
        .where((a) => a.books.count() >= literal(3))
        .select(
          (a) => (a.firstname, a.lastname),
        )
        .fetch();
    check(result).unorderedEquals([
      ('Easter', 'Bunny'),
    ]);
  });

  r.addTest('books.groupBy(.author).aggregate(sum(.stock))', (db) async {
    final result = await db.books
        .groupBy((b) => (b.author,))
        .aggregate(
          (agg) => //
              agg.sum((book) => book.stock),
        )
        .select(
          (author, stock) => (
            author.firstname,
            author.lastname,
            stock,
          ),
        )
        .fetch();
    check(result).unorderedEquals([
      ('John', 'Doe', 5),
      ('Jane', 'Doe', 7),
      ('Easter', 'Bunny', 22),
      ('Bucks', 'Bunny', 45),
    ]);
  });

  r.addTest('authors.select(.firstname, .lastname, .books.sum(.stock))',
      (db) async {
    final result = await db.authors
        .select(
          (author) => (
            author.firstname,
            author.lastname,
            author.books.select((b) => (b.stock,)).sum(),
          ),
        )
        .fetch();
    check(result).unorderedEquals([
      ('John', 'Doe', 5),
      ('Jane', 'Doe', 7),
      ('Easter', 'Bunny', 22),
      ('Bucks', 'Bunny', 45),
    ]);
  });

  r.addTest(
      'authors.select(.firstname, .lastname, db.where(...).books.sum(.stock))',
      (db) async {
    final result = await db.authors
        .select(
          (author) => (
            author.firstname,
            author.lastname,
            db.books
                .where((b) => b.authorId.equals(author.authorId))
                .select((b) => (b.stock,))
                .sum()
                .asExpr,
          ),
        )
        .fetch();
    check(result).unorderedEquals([
      ('John', 'Doe', 5),
      ('Jane', 'Doe', 7),
      ('Easter', 'Bunny', 22),
      ('Bucks', 'Bunny', 45),
    ]);
  });

  r.addTest('authors.join(books).groupBy(.author).aggregate(sum(.stock))',
      (db) async {
    final result = await db.authors
        .join(db.books)
        .on((author, book) => author.authorId.equals(book.authorId))
        .groupBy((author, book) => (author,))
        .aggregate(
          (agg) => //
              agg.sum((author, book) => book.stock),
        )
        .select(
          (author, stock) => (
            author.firstname,
            author.lastname,
            stock,
          ),
        )
        .fetch();

    check(result).unorderedEquals([
      ('John', 'Doe', 5),
      ('Jane', 'Doe', 7),
      ('Easter', 'Bunny', 22),
      ('Bucks', 'Bunny', 45),
    ]);
  });

  r.run();
}
