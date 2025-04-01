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

import 'package:test/test.dart' show test;
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

  String? get title;

  @References(table: 'authors', field: 'authorId', name: 'author', as: 'books')
  int get authorId;

  @DefaultValue(0)
  int get stock;
}
// #endregion

// #region initial-data
final initialAuthors = [
  (name: 'Easter Bunny',),
  (name: 'Bucks Bunny',),
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
// #endregion

void main() {
  test('setup test', () async {
    final file = 'file:inmemory?mode=memory&cache=shared';
    // #region setup
    // Connect to database
    final db = Database<Bookstore>(
      DatabaseAdaptor.sqlite3(Uri.parse(file)),
      SqlDialect.sqlite(),
    );

    // Create tables
    await db.createTables();

    // Insert an author and return the authorId!
    final authorId = await db.authors
        .insert(
          name: literal('Bucks Bunny'),
        )
        .returning((author) => (author.authorId,))
        .executeAndFetch();

    // Insert a book, omitting stock since it has a default value!
    await db.books
        .insert(
          title: literal('Vegan Dining'),
          authorId: literal(authorId!), // by Bucks Bunny
          stock: literal(3),
        )
        .execute();

    // Decrease stock for 'Vegan Dining', return update stock
    final updatedStock = await db.books
        .where((b) => b.title.equals(literal('Vegan Dining')))
        .updateAll((b, set) => set(
              stock: b.stock - literal(1),
            ))
        .returning((b) => (b.stock,))
        .executeAndFetch();
    check(updatedStock).deepEquals([2]);

    // Delete all books by Bucks Bunny
    await db.books
        .where((b) => b.authorId.equals(literal(authorId)))
        .delete()
        .execute();
    // #endregion
  });

  final r = TestRunner<Bookstore>(
    setup: (db) async {
      await db.createTables();

      // Insert test Authors and books
      for (final v in initialAuthors) {
        await db.authors
            .insertLiteral(
              name: v.name,
            )
            .execute();
      }
      for (final v in initialBooks) {
        await db.books
            .insertLiteral(
              title: v.title,
              authorId: v.authorId,
              stock: v.stock,
            )
            .execute();
      }
    },
  );

  r.addTest('README-query-example', (db) async {
    final authorId = 2;
    // #region README-query-example
    // Lookup author by id
    final author = await db.authors.byKey(authorId: authorId).fetch();
    if (author == null) {
      throw Exception('Author not found!');
    }
    check(author.name).equals('Bucks Bunny');

    // Lookup book and associated author in one query
    final (book, authorOfBook) = await db.books
        // Filtering using a .where clause with a typed expression
        .where((b) => b.title.equals(literal('Vegan Dining')))
        // Projection to select Expr<book> and Expr<Author> using a subquery
        .select((b) => (b, b.author))
        .first // only get the first result
        .fetchOrNulls();
    if (book == null || authorOfBook == null) {
      throw Exception('Book or author not found');
    }
    check(book.title).equals('Vegan Dining');
    check(authorOfBook.name).equals('Bucks Bunny');

    // We can also query for books with more than 5 in stock and get the title
    // and stock of each book.
    final titleAndStock = await db.books
        .where((Expr<Book> b) => b.stock > literal(5))
        .select((b) => (b.title, b.stock))
        .fetch();
    check(titleAndStock).unorderedEquals([
      // title, stock
      ('Are Bunnies Unhealthy?', 10),
      ('Hiding Eggs for dummies', 12),
      ('Vegetarian Dining', 42),
    ]);

    // We can also join books and authors, group by author sum how many books we
    // have in stock by author.
    final stockByAuthor = await db.books
        .join(db.authors)
        .on((b, a) => a.authorId.equals(b.authorId))
        .groupBy((b, a) => (a,))
        .aggregate((agg) => agg.sum((b, a) => b.stock))
        .select((a, totalStock) => (a.name, totalStock))
        .fetch();
    check(stockByAuthor).unorderedEquals([
      // name, totalStock
      ('Easter Bunny', 22),
      ('Bucks Bunny', 45),
    ]);

    // We can also compute this with subqueries using the @Reference annotation
    final stockByAuthorUsingSubquery = await db.authors
        .select((a) => (
              a.name,
              a.books.select((b) => (b.stock,)).sum(),
            ))
        .fetch();
    check(stockByAuthorUsingSubquery).unorderedEquals([
      // name, totalStock
      ('Easter Bunny', 22),
      ('Bucks Bunny', 45),
    ]);
    // #endregion
  });

  r.addTest('authors.insert', (db) async {
    // #region authors-insert
    await db.authors
        .insert(
          name: literal('Roger Rabbit'),
        )
        .execute();
    // #endregion
  });

  r.addTest('authors.insert w. authorId', (db) async {
    // #region authors-insert-with-id
    await db.authors
        .insert(
          authorId: literal(42),
          name: literal('Roger Rabbit'),
        )
        .execute();
    // #endregion
  });

  r.addTest('authors.insert().returnInserted', (db) async {
    // #region authors-insert-returnInserted
    final author = await db.authors
        .insert(
          name: literal('Roger Rabbit'),
        )
        .returnInserted()
        .executeAndFetch();

    // We can now access properties on author, like:
    // author.authorId
    check(author!.authorId).isA<int>();
    // #endregion
  });

  r.addTest('authors.insert().returning', (db) async {
    // #region authors-insert-returning-authorId
    final authorId = await db.authors
        .insert(
          name: literal('Roger Rabbit'),
        )
        .returning((author) => (author.authorId,))
        .executeAndFetch();

    // We now have the authorId available as authorId
    check(authorId).isA<int>();
    // #endregion
  });

  r.addTest('books.insert(authorId: fromLookup)', (db) async {
    // #region books-insert-w-lookup
    final authorId = await db.authors
        .where((author) => author.name.equals(literal('Easter Bunny')))
        .select((author) => (author.authorId,))
        .first
        .fetch();

    if (authorId == null) {
      throw Exception('Could not find the author');
    }

    await db.books
        .insert(
          title: literal('How to hide eggs'),
          authorId: literal(authorId),
        )
        .execute();
    // #endregion
  });

  r.addTest('books.insert(authorId: subquery)', (db) async {
    // #region books-insert-subquery
    await db.books
        .insert(
          title: literal('How to hide eggs'),
          authorId: db.authors.asSubQuery
              .where((author) => author.name.equals(literal('Easter Bunny')))
              .first
              .authorId
              .assertNotNull(),
        )
        .execute();
    // #endregion
  });

  r.addTest('books.where(stock > 3)', (db) async {
    // #region books.where-stock-gt-3
    final result = await db.books
        .where(
          (b) => b.stock > literal(3),
        )
        .fetch();

    check(result).length.equals(3);
    for (final book in result) {
      check(book.stock > 3).isTrue();
    }
    // #endregion
  });

  r.addTest('books.select(.title, .stock, .stock > 3)', (db) async {
    // #region books-select-title-stock
    final result = await db.books
        .select((b) => (
              b.title,
              b.stock,
              b.stock > literal(3),
            ))
        // .select() returns Query<(Expr<String>, Expr<int>, Expr<bool>)>,
        .fetch();

    check(result).unorderedEquals([
      // title, stock, stock > 3
      ('Are Bunnies Unhealthy?', 10, true),
      ('Cooking with Chocolate Eggs', 0, false),
      ('Hiding Eggs for dummies', 12, true),
      ('Vegetarian Dining', 42, true),
      ('Vegan Dining', 3, false),
    ]);
    // #endregion
  });

  r.addTest('books.select(.title, .stock, .stock > 3)', (db) async {
    // #region books-select-title
    final result = await db.books
        .select(
          // The extra comma in the parathensis here `(b.title,)` is
          // necessary to create a tuple with a single element!
          (b) => (b.title,),
          //             ▲
          //             └───── This extra comma is important!
        )
        // .select() returns Query<(Expr<String>,)>
        .fetch();

    check(result).unorderedEquals([
      'Are Bunnies Unhealthy?',
      'Cooking with Chocolate Eggs',
      'Hiding Eggs for dummies',
      'Vegetarian Dining',
      'Vegan Dining',
    ]);
    // #endregion
  });

  r.addTest('books.select().where().select()', (db) async {
    // #region books-select-where-select
    final titles = await db.books
        .select((b) => (
              b.title, // Expr<String?>, because Book.title is nullable
              b.stock, // Expr<int>, because Book.stock is non-nullable
            ))
        // This .where extension method takes a callback with two arguments
        // Expr<String?> and Expr<int>.
        .where((title, stock) => stock > literal(3))
        .select((title, stock) => (title,))
        // Remove null rows, we cannot do type promotion so the result is still
        // a Query<(Expr<String?>,)>
        .where((title) => title.isNotNull())
        // But we can use .orElse to callback to '', which gives us an
        // Query<(Expr<String>,)>, not that there is anything wrong with
        // returning a nullable expression.
        .select((title) => (title.orElse(literal('')),))
        .fetch();

    check(titles).unorderedEquals([
      'Are Bunnies Unhealthy?',
      'Hiding Eggs for dummies',
      'Vegetarian Dining',
    ]);
    // #endregion
  });

  r.addTest('Query.stream()', (db) async {
    // #region query-stream
    final q = db.books
        .select((b) => (
              b.title,
              b.stock,
            ))
        .where((title, stock) => stock > literal(3));

    // Use await-for to process the stream one row at the time.
    await for (final (title, stock) in q.stream()) {
      // Book.title is a nullable property, so the 'title' field does
      // not have a 'NOT NULL' constraint, hence, title variable in the result
      // here will be nullable!

      check(title).isNotNull();

      // Book.stock is a non-nullable property
      check(stock).isGreaterThan(3);
    }
    // #endregion
  });

  r.addTest('Query.orderBy', (db) async {
    // #region query-orderby
    final result = await db.books
        .orderBy((b) => [(b.stock, Order.descending)])
        .select((b) => (b.title, b.stock))
        .fetch();

    check(result).deepEquals([
      // title, stock
      ('Vegetarian Dining', 42),
      ('Hiding Eggs for dummies', 12),
      ('Are Bunnies Unhealthy?', 10),
      ('Vegan Dining', 3),
      ('Cooking with Chocolate Eggs', 0),
    ]);
    // #endregion
  });

  r.addTest('Query.orderBy.offset.limit', (db) async {
    // #region query-orderby-offset
    final result = await db.books
        .orderBy((b) => [(b.stock, Order.descending)])
        .select((b) => (b.title, b.stock))
        // The order in which .orderBy, .offset, .limit appears is significant.
        .offset(2)
        .limit(3)
        .fetch();

    check(result).deepEquals([
      // title, stock
      ('Are Bunnies Unhealthy?', 10),
      ('Vegan Dining', 3),
      ('Cooking with Chocolate Eggs', 0),
    ]);
    // #endregion
  });

  r.addTest('books.byKey()', (db) async {
    // #region books-bykey
    final book = await db.books.byKey(bookId: 1).fetch();
    if (book == null) {
      throw Exception('Book not found');
    }

    check(book.title).equals('Are Bunnies Unhealthy?');
    // #endregion
  });

  r.addTest('books.where().first', (db) async {
    // #region books-where-first
    final book = await db.books
        .where((b) => b.title.equals(literal('Are Bunnies Unhealthy?')))
        .first
        .fetch();

    if (book == null) {
      throw Exception('Book not found');
    }
    check(book.bookId).equals(1);
    // #endregion
  });

  r.addTest('db.select(author, book)', (db) async {
    // #region select-book-and-author
    final (book, author) = await db.select((
      db.books.asSubQuery
          .where((b) => b.title.equals(literal('Are Bunnies Unhealthy?')))
          .first,
      db.authors.byKey(authorId: 1).asExpr,
    )).fetchOrNulls();

    if (book == null) {
      throw Exception('Book not found');
    }
    check(book.bookId).equals(1);
    if (author == null) {
      throw Exception('Author not found');
    }
    check(author.name).equals('Easter Bunny');
    // #endregion
  });

  r.addTest('books.byKey().update()', (db) async {
    // #region update-book-bykey
    await db.books
        .byKey(bookId: 1)
        .update((book, set) => set(
              stock: book.stock - literal(1),
            ))
        .execute();
    // #endregion
  });

  r.addTest('books.byKey().update(title: null)', (db) async {
    // #region update-book-bykey-set-null
    await db.books
        .byKey(bookId: 1)
        .update((book, set) => set(
              title: literal(null),
            ))
        .execute();
    // #endregion
  });

  r.addTest('books.where(.stock > 5).updateAll(stock = stock / 2)', (db) async {
    // #region update-all-books-where-stock-gt-5
    await db.books
        .where((book) => book.stock > literal(5))
        .updateAll((book, set) => set(
              stock: (book.stock / literal(2)).asInt(),
            ))
        .execute();
    // #endregion
  });

  r.addTest('books.byKey().update().returnUpdated', (db) async {
    // #region update-book-bykey-returnUpdated
    final updatedBook = await db.books
        .byKey(bookId: 1)
        .update((book, set) => set(
              stock: book.stock - literal(1),
            ))
        .returnUpdated() // return the updated row
        .executeAndFetch();

    if (updatedBook == null) {
      throw Exception('Book not found');
    }
    check(updatedBook.stock).equals(9);
    // #endregion
  });

  r.addTest('books.where(.stock > 5).updateAll(stock = stock / 2).returning',
      (db) async {
    // #region update-all-books-where-returning
    final updatedStock = await db.books
        .where((book) => book.stock > literal(5))
        .updateAll((book, set) => set(
              stock: (book.stock / literal(2)).asInt(),
            ))
        .returning((book) => (book.stock,))
        .executeAndFetch();

    // We get 3 values because we updated 3 rows.
    check(updatedStock).unorderedEquals([
      21,
      5,
      6,
    ]);
    // #endregion
  });

  r.addTest('books.byKey().delete()', (db) async {
    // #region books-byKey-delete
    await db.books.byKey(bookId: 1).delete().execute();
    // #endregion
  });

  r.addTest('books.where().delete().returnDeleted()', (db) async {
    // #region books-where-delete-return
    final deletedBooks = await db.books
        .where((book) => book.authorId.equals(literal(1)))
        .delete()
        .returning((b) => (
              b.title,
              b.stock,
            ))
        .executeAndFetch();

    check(deletedBooks).unorderedEquals([
      // title, stock
      ('Are Bunnies Unhealthy?', 10),
      ('Cooking with Chocolate Eggs', 0),
      ('Hiding Eggs for dummies', 12),
    ]);
    // #endregion
  });

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
