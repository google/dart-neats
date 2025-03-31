# Type-safe SQL in Dart
This package aims to offer a _slightly oppiniated_ type-safe API for
interacting with an SQL database from Dart. Thus, offering users the power
of SQL, with the type-safety of Dart (including null-safety!).

**Features:**
 * **Type safety:** If your Dart code is type-safe you will not get SQL
   syntax errors at runtime.
 * **Null-safety:** If you return a field that has a `NOT NULL` constraint, the
   deserialized Dart type will be non-nullable!
 * **Fluent API:** Queries and expressions are build with chainable extension
   methods making it easy to discover available operators using auto-completion!
 * **Expressiveness:** Support for a wide range of SQL features, including:
   * Powerful arbitrary SQL expressions, including subqueries.
   * Insert, update and delete with
     * Returning clause for projections of affected rows.
     * Update/Delete filtering with SQL expressions.
     * Update with SQL expression on existing rows.
   * Select queries with
     * Projections with SQL expressions,
     * Aggregations (sum, count, avg, min, max) and `GROUP BY`,
     * Joins
     * Subqueries (including convinient lookups of foreign keys)
     * Ordering, limiting, and offsetting
     * Transactions (including nested transactions)
   * Schema definition with
     * Auto increment
     * Composite primary keys
     * Unique constraints
     * Not null constraints (linked to nullability in Dart!)
     * default values
     * Foreign keys
 * **Database agnostic:** This package already supports
   * **Sqlite**, and,
   * **Postgres**!

## Example
This packages requires that you define a schema for code-generation with
[build_runner]. This is usually defined in a `model.dart`, with the generated
code ending up in a `model.g.dart` part-file.

```dart bookstore_test.dart#bookstore-schema
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
```

To use this you must first install `build_runner` as dev-dependency, and run it:
```sh
dart pub add typed_sql
dart pub add dev:build_runner
dart run build_runner build
```

Once the `model.g.dart` file has been generated, you can create tables and
insert rows as follows:

```dart bookstore_test.dart#setup
final db = Database<BookStore>(DatabaseAdaptor.sqlite(), SqlDialect.sqlite());

await db.createTables();

await db.authors.insert(name: literal('Easter Bunny')).execute();

final authorId = await db.authors.insert(
  name: literal('Bucks Bunny'),
).returning((author) => (author.authorId,))
.executeAndFetch();

await db.books.insert(
  title: literal('Vegan Dining'),
  authorId: literal(authorId), // by Bucks Bunny
  stock: literal(3),
).execute();
```

Suppose we had the following books:
```dart bookstore_test.dart#initial-data
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
```

Then it's possible to query the database as follows:
```dart
// Lookup author by id
final author = db.authors.byKey(authorId).fetch();
if (author == null) throw Exception('Author not found!');
check(author.name).equals('Bucks Bunny');

// Lookup book and associated author in one query
final (book, author) = await db.books
  .where((b) => b.title.equals(literal('Vegan Dining')))
  .select((b) => (b, b.author))
  .first // only get the first result
  .fetchOrNulls();
if (book == null || author == null) throw Exception('Book or author not found');
check(book.title).equals('Vegan Dining');
check(author.name).equals('Bucks Bunny');

// We can also query for books with more than 5 in stock and get the title and
// and stock of each book.
final titleAndStock = await db.books
  .where((b) => b.stock > literal(5))
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
final stockByAuthor = await db.books.join(author).on((b, a) => a.authorId.equals(b.authorId)).groupBy((b, a) => (a,)).aggregate((agg) => agg.sum((b, a) => b.stock)).select((a, totalStock) => (a.name, totalStock)).fetch();
check(stockByAuthor).unorderedEquals([
  // name, totalStock
  ('Easter Bunny', 22),
  ('Bucks Bunny', 45),
]);

// We can also compute this with subqueries using the @Reference annotation
final stockByAuthorUsingSubquery = await db.authors.select((a) =>
  (
    a.name,
    a.books.count(),
  )
).fetch();
check(stockByAuthorUsingSubquery).unorderedEquals([
  // name, totalStock
  ('Easter Bunny', 22),
  ('Bucks Bunny', 45),
]);
```

In general `.where` can be used to filter results, you can build complex
expressions using differnet extension methods for `Expr<String>`, `Expr<int>`,
`Expr<DateTime>`, etc. making it easy to compare values correctly, and hard
(if not impossible) to make syntax errors in SQL!

The `.select` can be used to create custom projections, by returning a
positional record of `Expr` objects. Where the type of the objects are carried
into the `.fetch()` method ensuring that `Expr<String>` becomes a `String` when
fetched. Here nullability is preserved, so you don't have to do null checks for
columns (or expressions) that can't be `null`!

`package:typed_sql` has many more features and tutorial style documentation
that demonstrates most of the features by example. In practice, you'll hopefully
find that most features are discoverable through auto-completion.

[build_runner]: https://pub.dev/packages/build_runner

