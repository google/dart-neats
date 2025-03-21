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

part 'nullable_reference_test.g.dart';

abstract final class TestDatabase extends Schema {
  Table<Author> get authors;
  Table<Book> get books;
}

@PrimaryKey(['authorId'])
abstract final class Author extends Model {
  @AutoIncrement()
  int get authorId;

  String get name;

  @References(
    table: 'books',
    field: 'bookId',
    name: 'favoriteBook',
    as: 'favoritedBy',
  )
  int? get favoriteBookId;
}

@PrimaryKey(['bookId'])
abstract final class Book extends Model {
  @AutoIncrement()
  int get bookId;

  String get title;

  @References(table: 'authors', field: 'authorId', name: 'author', as: 'books')
  int get authorId;

  /// Not all books have an editor.
  @References(
    table: 'authors',
    field: 'authorId',
    name: 'editor',
    as: 'booksEditedBy',
  )
  int? get editorId;

  int get stock;
}

final _testAuthors = [
  (authorId: 1, name: 'Easter Bunny', favoriteBookId: null),
  (authorId: 2, name: 'Bucks Bunny', favoriteBookId: 4),
];

final _testBooks = [
  // By Easter Bunny
  (bookId: 1, title: 'Bunny-free?', authorId: 1, editorId: null, stock: 10),
  (bookId: 2, title: 'Egg Recipies', authorId: 1, editorId: null, stock: 0),
  (bookId: 3, title: 'Eggs for dummies', authorId: 1, editorId: 2, stock: 12),
  // By Bucks Bunny
  (bookId: 4, title: 'Vegetarian Dining', authorId: 2, editorId: 1, stock: 42),
  (bookId: 5, title: 'Vegan Dining', authorId: 2, editorId: 1, stock: 3),
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
              name: v.name,
            )
            .execute();
      }
      for (final v in _testBooks) {
        await db.books
            .insertLiteral(
              bookId: v.bookId,
              title: v.title,
              authorId: v.authorId,
              editorId: v.editorId,
              stock: v.stock,
            )
            .execute();
      }
      for (final v in _testAuthors) {
        await db.authors
            .byKey(authorId: v.authorId)
            .update((author, set) => set(
                  favoriteBookId: literal(v.favoriteBookId),
                ))
            .execute();
      }
    },
  );

  r.addTest('authors.fetch()', (db) async {
    final result = await db.authors.fetch();
    check(result).length.equals(2);
  });

  r.addTest('books.fetch()', (db) async {
    final result = await db.books.fetch();
    check(result).length.equals(5);
  });

  r.addTest('books.byKey().select(book, .editor)', (db) async {
    final (book, editor) = await db.books
        .byKey(bookId: 3)
        .select((book) => (book, book.editor))
        .fetchOrNulls();
    check(book).isNotNull().title.equals('Eggs for dummies');
    check(editor).isNotNull().name.equals('Bucks Bunny');
  });

  r.addTest('books.byKey().select(book, .editor) -> (book, null)', (db) async {
    final (book, editor) = await db.books
        .byKey(bookId: 1)
        .select((book) => (book, book.editor))
        .fetchOrNulls();
    check(book).isNotNull().title.equals('Bunny-free?');
    check(editor).isNull();
  });

  r.addTest('books.select(book, .editor)', (db) async {
    final result = await db.books
        .select(
          (book) => (
            book,
            book.editor,
          ),
        )
        .fetch();
    check(result).length.equals(5);
  });

  r.addTest('books.where(.author.name = ...).select(book, .editor)',
      (db) async {
    final result = await db.books
        .where((book) => book.author.name.equals(literal('Easter Bunny')))
        .select(
          (book) => (
            book,
            book.editor,
          ),
        )
        .fetch();
    check(result).length.equals(3);
  });

  r.addTest('books.where(.bookId = 1).select(book, .editor)', (db) async {
    final result = await db.books
        .where((book) => book.bookId.equals(literal(1)))
        .select(
          (book) => (
            book,
            book.editor,
          ),
        )
        .fetch();
    check(result).length.equals(1);
    final (book, editor) = result.first;
    check(book).isNotNull().title.equals('Bunny-free?');
    check(editor).isNull();
  });

  r.addTest('author.select(.name, .booksEditedBy.count())', (db) async {
    final result = await db.authors
        .select(
          (author) => (
            author.name,
            author.booksEditedBy.count(),
          ),
        )
        .fetch();
    check(result).unorderedEquals({
      ('Easter Bunny', 2),
      ('Bucks Bunny', 1),
    });
  });

  r.addTest('books', (db) async {
    final result = await db.books
        .select(
          (book) => (
            book.title,
            book.author.name,
            book.editor.authorId,
            book.editor.name.orElseLiteral('No editor'),
          ),
        )
        .fetch();
    check(result).unorderedEquals({
      ('Bunny-free?', 'Easter Bunny', null, 'No editor'),
      ('Egg Recipies', 'Easter Bunny', null, 'No editor'),
      ('Eggs for dummies', 'Easter Bunny', 2, 'Bucks Bunny'),
      ('Vegetarian Dining', 'Bucks Bunny', 1, 'Easter Bunny'),
      ('Vegan Dining', 'Bucks Bunny', 1, 'Easter Bunny'),
    });
  });

  r.addTest('books.select(..., .editor.books.count())', (db) async {
    final result = await db.books
        .select(
          (book) => (
            book.title,
            book.editor.name.orElseLiteral('No editor'),
            book.editor.books.count(),
          ),
        )
        .fetch();
    check(result).unorderedEquals({
      ('Bunny-free?', 'No editor', 0),
      ('Egg Recipies', 'No editor', 0),
      ('Eggs for dummies', 'Bucks Bunny', 2),
      ('Vegetarian Dining', 'Easter Bunny', 3),
      ('Vegan Dining', 'Easter Bunny', 3),
    });
  });

  r.addTest('books.select(..., .editor.booksEditedBy.count())', (db) async {
    final result = await db.books
        .select(
          (book) => (
            book.title,
            book.editor.name.orElseLiteral('No editor'),
            // This is an important thing to test, because book.editor may be
            // NULL, in which case book.editor.booksEditedBy is a subquery
            // that should return no rows, but if there are rows where the
            // editor is NULL (which we have), then it will return those rows.
            // That's obviously, wrong! Which is why the subquery checks if
            // the book.editor given as argument is NULL!
            book.editor.booksEditedBy.count(),
          ),
        )
        .fetch();
    check(result).unorderedEquals({
      ('Bunny-free?', 'No editor', 0),
      ('Egg Recipies', 'No editor', 0),
      ('Eggs for dummies', 'Bucks Bunny', 1),
      ('Vegetarian Dining', 'Easter Bunny', 2),
      ('Vegan Dining', 'Easter Bunny', 2),
    });
  });

  r.addTest('books.select(..., .editor.favoriteBook.title)', (db) async {
    final result = await db.books
        .select(
          (book) => (
            book.title,
            book.editor.name.orElseLiteral('No editor'),
            book.editor.favoriteBook.title,
          ),
        )
        .fetch();
    check(result).unorderedEquals({
      ('Bunny-free?', 'No editor', null),
      ('Egg Recipies', 'No editor', null),
      ('Eggs for dummies', 'Bucks Bunny', 'Vegetarian Dining'),
      ('Vegetarian Dining', 'Easter Bunny', null),
      ('Vegan Dining', 'Easter Bunny', null),
    });
  });

  r.addTest(
      'books.join(authors).on(editorId = authorId).select(..., .editor.name)',
      (db) async {
    final result = await db.books
        .join(db.authors)
        .on((book, author) => book.editorId.equals(author.authorId))
        .select(
          (book, editor) => (
            book.title,
            editor.name,
          ),
        )
        .fetch();
    check(result).unorderedEquals({
      ('Eggs for dummies', 'Bucks Bunny'),
      ('Vegetarian Dining', 'Easter Bunny'),
      ('Vegan Dining', 'Easter Bunny'),
    });
  });

  r.run();
}
