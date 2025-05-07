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

part 'composite_foreign_key_test.g.dart';

abstract final class TestDatabase extends Schema {
  Table<Author> get authors;
  Table<Book> get books;
}

@PrimaryKey(['firstName', 'lastName'])
abstract final class Author extends Row {
  String get firstName;
  String get lastName;
}

@PrimaryKey(['bookId'])
@ForeignKey(
  ['authorFirstName', 'authorLastName'],
  table: 'authors',
  fields: ['firstName', 'lastName'],
  name: 'author',
  as: 'books',
)
abstract final class Book extends Row {
  @AutoIncrement()
  int get bookId;

  String get title;

  String get authorFirstName;
  String get authorLastName;

  int get stock;
}

final _testAuthors = [
  (firstName: 'Easter', lastName: 'Bunny'),
  (firstName: 'Bucks', lastName: 'Bunny'),
];

final _testBooks = [
  // By Easter Bunny
  (
    bookId: 1,
    title: 'Are Bunnies Unhealthy?',
    authorFirstName: 'Easter',
    authorLastName: 'Bunny',
    stock: 10
  ),
  (
    bookId: 2,
    title: 'Cooking with Chocolate Eggs',
    authorFirstName: 'Easter',
    authorLastName: 'Bunny',
    stock: 0
  ),
  (
    bookId: 3,
    title: 'Hiding Eggs for dummies',
    authorFirstName: 'Easter',
    authorLastName: 'Bunny',
    stock: 12
  ),
  // By Bucks Bunny
  (
    bookId: 4,
    title: 'Vegetarian Dining',
    authorFirstName: 'Bucks',
    authorLastName: 'Bunny',
    stock: 42
  ),
  (
    bookId: 5,
    title: 'Vegan Dining',
    authorFirstName: 'Bucks',
    authorLastName: 'Bunny',
    stock: 3
  ),
];

void main() {
  final r = TestRunner<TestDatabase>(
    setup: (db) async {
      await db.createTables();

      // Insert test Authrs and books
      for (final v in _testAuthors) {
        await db.authors
            .insert(
              firstName: toExpr(v.firstName),
              lastName: toExpr(v.lastName),
            )
            .execute();
      }
      for (final v in _testBooks) {
        await db.books
            .insert(
              bookId: toExpr(v.bookId),
              title: toExpr(v.title),
              authorFirstName: toExpr(v.authorFirstName),
              authorLastName: toExpr(v.authorLastName),
              stock: toExpr(v.stock),
            )
            .execute();
      }
    },
  );

  r.addTest('authors.fetch()', (db) async {
    final result = await db.authors.fetch();
    check(result).length.equals(2);
  });

  r.addTest('books.where(.author.firstName.equals(Bucks))', (db) async {
    final result = await db.books
        .where((b) => b.author.firstName.equalsValue('Bucks'))
        .fetch();
    check(result).length.equals(2);
  });

  r.addTest('books.select(book, book.author)', (db) async {
    final result = await db.books
        .select(
          (b) => (b, b.author),
        )
        .fetch();
    check(result).length.equals(5);
    for (final (book, author) in result) {
      check(book.authorFirstName).equals(author.firstName);
      check(book.authorLastName).equals(author.lastName);
    }
  });

  r.addTest('books.select(title, book.author.firstName)', (db) async {
    final result = await db.books
        .select(
          (b) => (
            b.title,
            b.author.firstName,
          ),
        )
        .fetch();
    check(result).unorderedEquals([
      ('Are Bunnies Unhealthy?', 'Easter'),
      ('Cooking with Chocolate Eggs', 'Easter'),
      ('Hiding Eggs for dummies', 'Easter'),
      ('Vegetarian Dining', 'Bucks'),
      ('Vegan Dining', 'Bucks'),
    ]);
  });

  r.addTest('authors.where(.books.count() >= 3)', (db) async {
    final result = await db.authors
        .where((a) => a.books.count() >= toExpr(3))
        .select(
          (a) => (a.firstName, a.lastName),
        )
        .fetch();
    check(result).unorderedEquals([
      ('Easter', 'Bunny'),
    ]);
  }, skipMysql: 'mysql is not good with nested scalar subqueries');

  r.addTest('books.groupBy(.author).aggregate(sum(.stock))', (db) async {
    final result = await db.books
        .groupBy((b) => (b.author,))
        .aggregate(
          (agg) => //
              agg.sum((book) => book.stock),
        )
        .select(
          (author, stock) => (
            author.firstName,
            author.lastName,
            stock,
          ),
        )
        .fetch();
    check(result).unorderedEquals([
      ('Easter', 'Bunny', 22),
      ('Bucks', 'Bunny', 45),
    ]);
  });

  r.addTest('authors.select(.firstName, .lastName, .books.sum(.stock))',
      (db) async {
    final result = await db.authors
        .select(
          (author) => (
            author.firstName,
            author.lastName,
            author.books.select((b) => (b.stock,)).sum(),
          ),
        )
        .fetch();
    check(result).unorderedEquals([
      ('Easter', 'Bunny', 22),
      ('Bucks', 'Bunny', 45),
    ]);
  }, skipMysql: 'TODO: Fix nested subqueries in mysql');

  r.addTest(
      'authors.select(.firstName, .lastName, db.where(...).books.sum(.stock))',
      (db) async {
    final result = await db.authors
        .select(
          (author) => (
            author.firstName,
            author.lastName,
            db.books
                .where((b) =>
                    b.authorFirstName.equals(author.firstName) &
                    b.authorLastName.equals(author.lastName))
                .select((b) => (b.stock,))
                .sum()
                .asExpr,
          ),
        )
        .fetch();
    check(result).unorderedEquals([
      ('Easter', 'Bunny', 22),
      ('Bucks', 'Bunny', 45),
    ]);
  }, skipMysql: 'TODO: Fix nested subqueries in mysql');

  r.addTest('authors.join(books).groupBy(.author).aggregate(sum(.stock))',
      (db) async {
    final result = await db.authors
        .join(db.books)
        .on((author, book) =>
            author.firstName.equals(book.authorFirstName) &
            author.lastName.equals(book.authorLastName))
        .groupBy((author, book) => (author,))
        .aggregate(
          (agg) => //
              agg.sum((author, book) => book.stock),
        )
        .select(
          (author, stock) => (
            author.firstName,
            author.lastName,
            stock,
          ),
        )
        .fetch();

    check(result).unorderedEquals([
      ('Easter', 'Bunny', 22),
      ('Bucks', 'Bunny', 45),
    ]);
  });

  r.run();
}
