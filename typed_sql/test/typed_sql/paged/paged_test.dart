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

import 'package:typed_sql/typed_sql.dart';

import '../testrunner.dart';

part 'paged_test.g.dart';

abstract final class TestDatabase extends Schema {
  Table<Author> get authors;
  Table<Book> get books;
}

@PrimaryKey(['authorId'])
abstract final class Author extends Row {
  int get authorId;

  @SqlOverride.field(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String get name;
}

@PrimaryKey(['bookId'])
abstract final class Book extends Row {
  int get bookId;

  @SqlOverride.field(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String get title;

  int? get authorId;

  int get stock;
}

final _authors = [
  (authorId: 1, name: 'Alice'),
  (authorId: 2, name: 'Bob'),
  (authorId: 3, name: 'Carol'), // has no books
];

final _books = [
  (bookId: 1, title: 'A', authorId: 1, stock: 5),
  (bookId: 2, title: 'B', authorId: 2, stock: 3),
  (bookId: 3, title: 'C', authorId: null, stock: 5),
  (bookId: 4, title: 'D', authorId: 1, stock: 0),
  (bookId: 5, title: 'E', authorId: 2, stock: 3),
  (bookId: 6, title: 'F', authorId: null, stock: 5),
  (bookId: 7, title: 'G', authorId: 1, stock: 1),
];

void main() {
  final r = TestRunner<TestDatabase>(
    setup: (db) async {
      await db.createTables();
      await db.authors
          .insertValuesMapped(
            _authors,
            authorId: (a) => a.authorId,
            name: (a) => a.name,
          )
          .execute();
      await db.books
          .insertValuesMapped(
            _books,
            bookId: (b) => b.bookId,
            title: (b) => b.title,
            authorId: (b) => b.authorId,
            stock: (b) => b.stock,
          )
          .execute();
    },
  );

  r.addTest('books.pagedBy(bookId) with different pageSizes', (db) async {
    for (final pageSize in [1, 2, 3, 6, 7, 8, 100]) {
      final ids = await db.books
          .pagedBy((b) => [(b.bookId, Order.ascending)], pageSize: pageSize)
          .map((b) => b.bookId)
          .toList();
      check(because: 'pageSize: $pageSize', ids).deepEquals([
        1, 2, 3, 4, 5, 6, 7, //
      ]);
    }
  });

  r.addTest('books.pagedBy(bookId desc)', (db) async {
    final ids = await db.books
        .pagedBy((b) => [(b.bookId, Order.descending)], pageSize: 2)
        .map((b) => b.bookId)
        .toList();
    check(ids).deepEquals([7, 6, 5, 4, 3, 2, 1]);
  });

  r.addTest('books.where(false).pagedBy(bookId)', (db) async {
    final books = await db.books
        .where((b) => b.stock < toExpr(0))
        .pagedBy((b) => [(b.bookId, Order.ascending)], pageSize: 2)
        .toList();
    check(books).isEmpty();
  });

  r.addTest('books.where(..).pagedBy(bookId)', (db) async {
    final ids = await db.books
        .where((b) => b.stock > toExpr(0))
        .pagedBy((b) => [(b.bookId, Order.ascending)], pageSize: 2)
        .map((b) => b.bookId)
        .toList();
    check(ids).deepEquals([1, 2, 3, 5, 6, 7]);
  });

  r.addTest('books.pagedBy(bookId, startFrom: book)', (db) async {
    final book = await db.books.byKey(3).fetch();
    final ids = await db.books
        .pagedBy(
          (b) => [(b.bookId, Order.ascending)],
          pageSize: 2,
          startFrom: book,
        )
        .map((b) => b.bookId)
        .toList();
    check(ids).deepEquals([4, 5, 6, 7]);
  });

  r.addTest('books.pagedBy(pageSize: 0) throws', (db) async {
    check(
      () => db.books.pagedBy((b) => [(b.bookId, Order.ascending)], pageSize: 0),
    ).throws<RangeError>();
  });

  r.addTest('books.select(title).pagedBy(title, startFrom: title)', (
    db,
  ) async {
    final titles = await db.books
        .select((b) => (b.title,))
        .pagedBy(
          (title) => [(title, Order.ascending)],
          pageSize: 3,
          startFrom: 'C',
        )
        .toList();
    check(titles).deepEquals(['D', 'E', 'F', 'G']);
  });

  r.addTest('books.select(stock, bookId).pagedBy(stock desc, bookId)', (
    db,
  ) async {
    final result = await db.books
        .select((b) => (b.stock, b.bookId))
        .pagedBy(
          (stock, bookId) => [
            (stock, Order.descending),
            (bookId, Order.ascending),
          ],
          pageSize: 2,
        )
        .toList();
    check(result).deepEquals([
      (5, 1),
      (5, 3),
      (5, 6),
      (3, 2),
      (3, 5),
      (1, 7),
      (0, 4),
    ]);
  });

  r.addTest('books.join(authors).pagedBy(name desc, bookId)', (db) async {
    final result = await db.books
        .join(db.authors)
        .on((b, a) => b.authorId.equals(a.authorId))
        .pagedBy(
          (b, a) => [
            (a.name, Order.descending),
            (b.bookId, Order.ascending),
          ],
          pageSize: 2,
        )
        .map((r) => (r.$1.bookId, r.$2.name))
        .toList();
    check(result).deepEquals([
      (2, 'Bob'),
      (5, 'Bob'),
      (1, 'Alice'),
      (4, 'Alice'),
      (7, 'Alice'),
    ]);
  });

  r.addTest('books.leftJoin(authors).pagedBy(name, bookId)', (db) async {
    // Books without an author are first, so the last author is often null.
    final result = await db.books
        .leftJoin(db.authors)
        .on((b, a) => b.authorId.equals(a.authorId))
        .pagedBy(
          (b, a) => [
            (a.name.orElseValue(''), Order.ascending),
            (b.bookId, Order.ascending),
          ],
          pageSize: 1,
        )
        .map((r) => (r.$1.bookId, r.$2?.name))
        .toList();
    check(result).deepEquals([
      (3, null),
      (6, null),
      (1, 'Alice'),
      (4, 'Alice'),
      (7, 'Alice'),
      (2, 'Bob'),
      (5, 'Bob'),
    ]);
  });

  r.addTest('authors.leftJoin(books).select(..).pagedBy(..)', (db) async {
    // Carol has no books, so bookId is null for the last row.
    final result = await db.authors
        .leftJoin(db.books)
        .on((a, b) => a.authorId.equals(b.authorId))
        .select((a, b) => (a.authorId, b.bookId))
        .pagedBy(
          (authorId, bookId) => [
            (authorId, Order.ascending),
            (bookId.orElseValue(0), Order.ascending),
          ],
          pageSize: 1,
        )
        .toList();
    check(result).deepEquals([
      (1, 1),
      (1, 4),
      (1, 7),
      (2, 2),
      (2, 5),
      (3, null),
    ]);
  });

  r.run();
}
