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

import 'dart:async';

import 'package:test/test.dart';
import 'package:typed_sql/typed_sql.dart';

import '../../testrunner.dart';

part 'on_referential_event_cascade_foreign_key_test.g.dart';

abstract final class TestDatabase extends Schema {
  Table<Author> get authors;
  Table<Book> get books;
}

@PrimaryKey(['authorId'])
abstract final class Author extends Row {
  @AutoIncrement()
  int get authorId;

  String get firstname;
  String get lastname;
}

@PrimaryKey(['bookId'])
@ForeignKey(
  ['authorId'],
  table: 'authors',
  fields: ['authorId'],
  name: 'author',
  as: 'books',
  onDelete: .cascade,
  onUpdate: .cascade,
)
abstract final class Book extends Row {
  @AutoIncrement()
  int get bookId;

  String get title;

  int? get authorId;

  int get stock;
}

extension on Database<TestDatabase> {
  Future<List<(int?, int)>> booksCountByAuthorId() =>
      books.groupBy((b) => (b.authorId,)).aggregate((a) => a.count()).fetch();
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

      // Insert test authors and books
      for (final v in _testAuthors) {
        await db.authors
            .insert(
              authorId: toExpr(v.authorId),
              firstname: toExpr(v.firstname),
              lastname: toExpr(v.lastname),
            )
            .execute();
      }
      for (final v in _testBooks) {
        await db.books
            .insert(
              bookId: toExpr(v.bookId),
              title: toExpr(v.title),
              authorId: toExpr(v.authorId),
              stock: toExpr(v.stock),
            )
            .execute();
      }
    },
  );

  Future<List<int>> authorIds(Database<TestDatabase> db) async {
    return await db.authors
        .select((a) => (a.authorId,))
        .orderBy((a) => [(a, .ascending)])
        .fetch();
  }

  r.addTest('Delete is cascaded', (db) async {
    expect(await authorIds(db), [1, 2, 3, 4]);
    check(await db.booksCountByAuthorId()).unorderedEquals([
      (1, 2),
      (2, 2),
      (3, 3),
      (4, 2),
    ]);
    await db.authors.delete(1).execute();
    expect(await authorIds(db), [2, 3, 4]);
    check(await db.booksCountByAuthorId()).unorderedEquals([
      (2, 2),
      (3, 3),
      (4, 2),
    ]);
  });

  r.addTest('Update is cascaded', (db) async {
    expect(await authorIds(db), [1, 2, 3, 4]);
    check(await db.booksCountByAuthorId()).unorderedEquals([
      (1, 2),
      (2, 2),
      (3, 3),
      (4, 2),
    ]);
    await db.authors
        .byKey(1)
        .update((author, set) => set(authorId: 6.asExpr))
        .execute();
    expect(await authorIds(db), [2, 3, 4, 6]);
    check(await db.booksCountByAuthorId()).unorderedEquals([
      (2, 2),
      (3, 3),
      (4, 2),
      (6, 2),
    ]);
  });

  r.run();
}
