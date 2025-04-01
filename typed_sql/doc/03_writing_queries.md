In this document aims to show how to write queries with `package:typed_sql`.
Examples through out this document shall assume a database schemas defined as
follows:

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

Similarly, examples in this document will assume that the database is loaded
with the following examples:
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

## Filtering with `.where`
Similarly, to SQL we can use a `WHERE` clause to filter rows from a table
(or subquery). If we want get all books with more than 3 in stock, we can write
the query as follows:

```dart bookstore_test.dart#books.where-stock-gt-3
final result = await db.books
    .where(
      (b) => b.stock > literal(3),
    )
    .fetch();

check(result).length.equals(3);
for (final book in result) {
  check(book.stock > 3).isTrue();
}
```

The equivalent SQL would be:
```sql
SELECT * FROM books WHERE stock > 3;
```

Notice that with `package:typed_sql` the rows are deserialized into `Book`
objects, which makes it easy to access fields as named properties. Later, we'll
explore how to only return a subset of the fields using custom projections with
`.select`.

The `db.books` object has a type `Query<(Expr<Book>,)>`, and when we invoke
`.where` we provide a callback on the form `Expr<bool> Function(Expr<Book>)`.
Essentially, the `.where` invocation is passed a function that given an
`Expr<Book>` will return an `Expr<bool>`.

When `package:typed_sql` generates code for the database schema it'll generate
extension methods for `Expr<Book>` such that fields like `stock` can be accessed
as `b.stock` (in the example above). The `Expr<Book>.stock` extension
method/getter will itself return an `Expr<int>`. And `package:typed_sql` comes
with extension methods for building expressions of `Expr<int>`, `Expr<String>`,
`Expr<bool>`, etc.

While it's possible to find all these extension methods in the documentation,
in practice you simply type `db.where((b) => b.stock.` and leverage
auto-completion to tell you what extension methods are available for the
`Expr` object you are currently working with.

However, you might still need to know that `literal<T>(value)` is used to
inject Dart values into the SQL expressions as parameters.


## Projections with `.select`
While we build expressions in `.where` to filter rows from a table
(or subquery), we can use `.select` to return a set of expressions for each row
in a table (or subquery). In the simplest form this is useful if we want our
query to only return some fields, instead of returning the entire row.
But this can also be used to return any expression we can build, including
subqueries.

If in SQL we wanted to get the title, stock and a boolean indicating if
`stock > 3` from the books table, we could write an SQL query as follows:

```sql
SELECT
  title,
  stock,
  stock > 3
FROM books;
```

We can build the same query using `package:typed_sql` as follows:

```dart bookstore_test.dart#books-select-title-stock
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
```

The callback given to `.select` must return a _positional record_ where values
are `Expr` objects. Even if you only wanted to return a single expression it is
necessary to return a positional record, as illustrated below:

```dart bookstore_test.dart#books-select-title
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
```

In the example above the type returned by `.select` is `Query<(Expr<String>,)>`,
because this `Query` object only has a single expression record, the `.fetch()`
extension method just returns `Future<List<String>>`. As demonstrated in the
previous example, if there are multiple expressions, `.fetch()` will return a
list of records.

As all methods on `Query<T>` are extension methods, there is a limit to the
number of expressions that can be returned from `.select`. However, if you're
building a query that hits this limit you might need to consider if you can
managed such a large number of positional values.

> [!NOTE]
> The astute reader might realize that in Dart it's not possible to specify a
> type for `.select` such that the callback must return a _positional record_
> where all values are `Expr` objects.
>
> Indeed the type for `.select` in the example above is
> `.select<T extends Record>(T Function(Expr<Book>) projectionBuilder) -> Query<T>`.
>
> However, since all the methods on `Query<T>` are extension methods, there
> simply are no interesting methods available, if `T` is not a positional record
> of `Expr` objects.

It is worth noting that you can combine `.where` and `.select` as much as you
like. But you do `.select` or `.where` on `Query<T>`, then the number of
arguments given your callback depends on how many positional `Expr` objects
there are in `T`. This principal illustrated below:

```dart bookstore_test.dart#books-select-where-select
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
```

While the SQL rendering code in `package:typed_sql` employs pattern matching
to render common query patterns efficient, it's likely that example above would
result in an SQL query along the lines of:

```sql
SELECT
  COALESCE(title, '')
FROM (
  SELECT
    title
  FROM (
    SELECT
      title
    FROM (
      SELECT
        *
      FROM (
        SELECT
          title,
          stock
        FROM books
      )
      WHERE stock > 3
    )
  )
  WHERE title IS NOT NULL
)
```

However, most databases have a relational query optimizer that'll make most of
the nested queries in the SQL above melt away. In practice, it's likely that,
while above query looks scary, it's probably largely as efficient as:
```sql
SELECT
  title
FROM books
WHERE stock > 3
  AND title IS NOT NULL
```

Ofcourse, you should take care when writing queries, but it's probably more
important to worry about subqueries, complex expressions and inefficient joins
rather than depth of the nesting structure.


## Stream query results with `.stream`
The `.fetch()` extension methods on `Query` returns `List` of results. However,
in many databases it's possible to stream results in such a manner that you need
not keep all rows in memory at once. With `package:typed_sql` this can be done
using the `.stream()` method, as illustrate below.

```dart bookstore_test.dart#query-stream
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
```

While `.stream()` can alleviate the need to load all rows into memory, it's only
really necessary if scanning through a large set of rows from the database.

> [!NOTE]
> Within a transaction `Query.stream()` will not pause the stream when
> encountering back-pressure, instead it'll buffer the result rows in-memory if
> the database returns rows faster than the application code can process them.
>
> This aims to prevent deadlocks, because concurrent queries inside a
> transaction is not possible.


## Sorting results with `.orderBy`
Similar to SQL we can use `.orderBy` to sort rows with an `ORDER BY` clause.
The `.orderBy` methods takes a callback that returns a list of
`(Expr<Comparable>, Order)`, this allows ordering by multiple keys.
The following example demonstrates how to sort books by stock in descending
order:

```dart bookstore_test.dart#query-orderby
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
```

The equivalent SQL query would look something like:
```sql
SELECT
  title,
  stock
FROM books
ORDER BY stock DESC
LIMIT 3;
```

You must always provide `Order.ascending` or `Order.descending` for entries in
the return value from the callback in `.orderBy`. You can sort by any
`Expr<Comparable>`, typically `Expr<int>`, `Expr<double>`, `Expr<DateTime>`,
`Expr<String>`, or, `Expr<bool>`. Again, you can sort by expressions other than
just fields, including subqueries, but you might want to consider the
performance implications before using a subquery for ordering.


## Limit and offset with `.limit` and `.offset`
We can use `.limit` and `.offset` to return a subset of rows from a query.
The following example builds on top of the previous example, sorting by
stock in descending order, skipping the first two rows and returning at-most 3
rows.

```dart bookstore_test.dart#query-orderby-offset
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
```

The equivalent SQL query would look something like:
```sql
SELECT
  title,
  stock
FROM books
ORDER BY stock DESC
OFFSET 2
LIMIT 3;
```

> [!WARNING]
> The **ordering** of `.orderBy`, `.offset` and `.limit` is significant.
> Meaning that `.limit(3).offset(3)` will _always_ result in an empty query!

You may apply `.limit` and `.offset` more than once, but they do stack on-top of
each other. So `.limit(3).limit(4)` will at-most return 3 rows, and
`.offset(2).offset(1)` will skip the first 3 rows.


## Point queries with `.byKey`, `.first` and `db.select()`
If we want to lookup a row by _primary key_ `package:typed_sql` will generate
a convenient `.byKey()` method. If we wanted to look up the row in books with
`bookId = 1` we could simple write:

```dart bookstore_test.dart#books-bykey
final book = await db.books.byKey(bookId: 1).fetch();
if (book == null) {
  throw Exception('Book not found');
}

check(book.title).equals('Are Bunnies Unhealthy?');
```

The astute reader might realize that unlike previous query examples `.fetch()`
does not return a `Future<List<Book>>`. This is because `.byKey` returns a
`QuerySingle<(Expr<Book>,)>`, meaning that the `.fetch()` extension method knows
that the query returns _at-most one row_. Thus, `.fetch()` can simple return
`Future<Book?>`.

We can also get a `QuerySingle` using the `.first` extension method. This is
useful if we want to query for rows by title, but we only one care about the
first row. In practices, there are many scenarios where we know that there is
at-most one row, and using `.first` gives nicer typing.

```dart bookstore_test.dart#books-where-first
final book = await db.books
    .where((b) => b.title.equals(literal('Are Bunnies Unhealthy?')))
    .first
    .fetch();

if (book == null) {
  throw Exception('Book not found');
}
check(book.bookId).equals(1);
```

Often you'll want to lookup multiple point queries at the same time, this can
be easily done using `db.select`. This works the same as `.select` except, there
is only one result row, all values are `Expr` objects. Hence, we can lookup
a book and an author in a single query performing two point queries at once:

```dart bookstore_test.dart#select-book-and-author
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
```

Whenver, we have a `QuerySingle<(Expr<T>)>` consisting of a single value record,
we can convert it into a subquery using `.asExpr`. Similarly, whenever we have
a `Query<T>` we can convert it to a `SubQuery<T>` using `.asSubQuery`.
`SubQuery<T>` is not by itself magical, it's just that for convinience
`SubQuery<(Expr<T>,)>.first` returns `Expr<T?>`.

> [!TIP]
> Whether you use `.asExpr` or `.asSubQuery` doesn't matter, unless you're
> using _aggregate functions_ like `.count`, `.sum`, `.avg`, `.min`, and, `max`,
> which on `SubQuery` returns `Expr<T>` as oppose to `.asExpr` which always
> gives you a nullable `Expr<T?>`.
>
> See documentation for _aggregate functions_ for more details.

In general, the `.asExpr` is only available on `QuerySingle<(Expr<T>,)>`, the
`.asExpr` is not available on queries returning multiple values.


## Expression reference
While it's possible to find extension methods by exploring the generated API
documentation, this can be a bit of a hassle. In practice, you're often better
off discovering available extension method using auto-completion. That said, it
can sometimes be nice to have an idea of what methods are available on
`Expr<T>` given a specific `T`.

The following is a high-level reference of _some_ of the available
_extension methods_:

 * `Expr<T?>`, when `T` is one of `bool`, `int`, `double`, `String`, `DateTime`, has:
    * `.equals(Expr<T?> other) -> Expr<bool>`
    * `.notEquals(Expr<T?> other) -> Expr<bool>`
    * `.isNull() -> Expr<bool>`
    * `.isNotNull() -> Expr<bool>`
    * `.orElse(Expr<T> other) -> Expr<T>`
    * `.assertNotNull() -> Expr<T>`
 * `Expr<bool>`, has:
    * `.not() -> Expr<bool>` (also available as operator `~`)
    * `.and(Expr<bool> other) -> Expr<bool>` (also available as operator `&`)
    * `.or(Expr<bool> other) -> Expr<bool>` (also available as operator `|`)
 * `Expr<String>`, has:
    * `.endsWith(Expr<String> other) -> Expr<bool>`
    * `.startsWith(Expr<String> other) -> Expr<bool>`
    * `.length -> Expr<int>`
    * `.isEmpty -> Expr<bool>`
    * `.isNotEmpty -> Expr<bool>`
    * `.like(String pattern) -> Expr<bool>`
    * `.contains(Expr<String> substring) -> Expr<bool>`
    * `.toLowerCase() -> Expr<String>`
    * `.toUpperCase() -> Expr<String>`
    * `.asInt() -> Expr<int>` (unsafe cast)
    * `.asDouble() -> Expr<double>` (unsafe cast)
 * `Expr<T>`, when `T` is one of `int`, `double`, `String`, `DateTime`, has:
    * `.lessThan(Expr<T> other) -> Expr<bool>` (also available as operator `<`)
    * `.lessThanOrEqual(Expr<T> other) -> Expr<bool>` (also available as operator `<=`)
    * `.greaterThan(Expr<T> other) -> Expr<bool>` (also available as operator `>`)
    * `.greaterThanOrEqual(Expr<T> other) -> Expr<bool>` (also available as operator `>=`)
 * `Expr<T>`, when `T` is one of `int`, `double`, has:
    * `.add(Expr<T> other) -> Expr<T>` (also available as operator `+`)
    * `.subtract(Expr<T> other) -> Expr<T>` (also available as operator `-)
    * `.multiply(Expr<T> other) -> Expr<T>` (also available as operator `*`)
    * `.divide(Expr<T> other) -> Expr<T>` (also available as operator `/`)
    * `.asString() -> Expr<String>`
 * `Expr<int>`, has:
    * `.asDouble() -> Expr<double>`
 * `Expr<double>`, has:
    * `.asInt() -> Expr<int>`
 * `Expr<DateTime>`, has:
    * `.before(Expr<DateTime> other) -> Expr<bool>`
    * `.after(Expr<DateTime> other) -> Expr<bool>`

> [!NOTE]
> The reference above is not exhaustive, this is a quick reference, it'll not be
> updated for every new extension method introduced, though pull-requests to
> the documentation are appreciated.

The reference above, deliberately omits variations such as
`.<method>Literal(...)` and `.not<method>(...)` because they are merely
convinience functions.


## Query reference
The following is a high-level overview of the most important extension methods
for `Query` objects. In practice, you'll often discover these through
auto-completion, but it can be useful to know that if you use `.select` to
select a single integer fields (or expression) such that you have
`Query<(Expr<int>,)>` then you can call `.sum()` and get an
`QuerySingle<(Expr<int>,)>`.

 * `Query<T>`, when `T` is `(Expr<A>, Expr<B>, ...)`, has:
   * `.orderBy(List<(Expr<Comparable>, Order)> Function(Expr<A>, Expr<B>, ...) orderBy) -> Query<T>`
   * `.where(Expr<bool> Function(Expr<A>, Expr<B>, ...) filter) -> Query<T>`
   * `.first -> QuerySingle<T>`
   * `.limit(int limit) -> Query<T>`
   * `.offset(int offset) -> Query<T>`
   * `.count() -> Expr<int>`
   * `.exists() -> Expr<bool>`
   * `.select<S>(S Function(Expr<A>, Expr<B>, ...) projection) -> Query<S>`
   * `.groupBy<S>(S Function(Expr<A>, Expr<B>, ...) groupBy) -> Group<S, T>`
   * `.fetch() -> Future<List<(A, B, ...)>>`
   * `.stream() -> Stream<(A, B, ...)>`
   * `.join<S>(Query<S> other) -> InnerJoin<S, T>`
   * `.leftJoin<S>(Query<S> other) -> LeftJoin<S, T>`
   * `.rightJoin<S>(Query<S> other) -> RightJoin<S, T>`
   * `.union(Query<T> other) -> Query<T>`
   * `.unionAll(Query<T> other) -> Query<T>`
   * `.except(Query<T> other) -> Query<T>`
   * `.intersect(Query<T> other) -> Query<T>`
   * `.asSubQuery -> SubQuery<T>`
   * `.distinct() -> Query<T>`
 * `Query<(Expr<T>,)>`, when `T` is one of `int`, `double`, `String`, `DateTime`, has:
   * `.min -> QuerySingle<(Expr<T>,)>`
   * `.max -> QuerySingle<(Expr<T>,)>`
 * `Query<(Expr<T>,)>`, when `T` is one of `int`, `double` has:
   * `.sum() -> QuerySingle<(Expr<T>,)>`
   * `.avg() -> QuerySingle<(Expr<double>,)>`
 * `QuerySingle<(Expr<T>,)>`, has:
   * `.fetch() -> Future<T?>`
   * `.asExpr -> Expr<T>`
 * `QuerySingle<T>`, when `T` is `(Expr<A>, Expr<B>, ...)`, has:
   * `.fetch() -> Future<(A, B, ...)?>`
   * `.fetchOrNulls() -> Future<(A?, B?, ...)>`
   * `.where(Expr<bool> Function(Expr<A>, Expr<B>, ...) filter) -> QuerySingle<T>`
   * `.select<S>(S Function(Expr<A>, Expr<B>, ...) projection) -> QuerySingle<S>`
   * `.asQuery -> Query<T>`
 * `SubQuery<(Expr<T>,)>`, has:
   * `.first -> Expr<T?>`
 * `SubQuery<(Expr<T>,)>`, when `T` is one of `int`, `double`, `String`, `DateTime`, has:
   * `.min -> Expr<T>`
   * `.max -> Expr<T>`
 * `SubQuery<(Expr<T>,)>`, when `T` is one of `int`, `double` has:
   * `.sum() -> Expr<T>`
   * `.avg() -> Expr<double>`
 * `SubQuery` also has many of the same methods as `Query`.

> [!NOTE]
> The reference above is not exhaustive, this is a quick reference, it'll not be
> updated for every new extension method introduced, though pull-requests to
> the documentation are appreciated.

The above documentation does not outline how `.join` and `.groupBy` works, for
details on how to use these see their respective documentation topics.
