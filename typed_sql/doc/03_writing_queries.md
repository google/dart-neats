In this document aims to show how to write queries with `package:typed_sql`.
Examples throughout this document assume a database schema defined as
follows:

```dart bookstore_test.dart#bookstore-schema
abstract final class Bookstore extends Schema {
  Table<Author> get authors;
  Table<Book> get books;
}

@PrimaryKey(['authorId'])
abstract final class Author extends Row {
  @AutoIncrement()
  int get authorId;

  @Unique.field()
  String get name;
}

@PrimaryKey(['bookId'])
abstract final class Book extends Row {
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
We can use the query builder `.where` to filter rows from a table
(or subquery). It corresponds to SQL `WHERE`.

If we want get all books with more than 3 in stock, we can write
the query as follows:

```dart bookstore_test.dart#books.where-stock-gt-3
final result = await db.books
    .where(
      (b) => b.stock > toExpr(3),
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

However, you might still need to know that `toExpr<T>(value)` is used to
inject Dart values into the SQL expressions as parameters.


## Projections with `.select`
While we can build expressions with `.where` to filter rows from a table
(or subquery), we can use `.select` to evaluate a set of expressions for each row
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
          b.stock > toExpr(3),
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

The callback given to `.select` must return a _positional [record](https://dart.dev/language/records)_ where values
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
manage such a large number of positional values.

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
like. But if you do `.select` or `.where` on `Query<T>`, then the number of
arguments given to your callback depends on how many positional `Expr` objects
there are in `T`. This principle is illustrated below:

```dart bookstore_test.dart#books-select-where-select
final titles = await db.books
    .select((b) => (
          b.title, // Expr<String?>, because Book.title is nullable
          b.stock, // Expr<int>, because Book.stock is non-nullable
        ))
    // This .where extension method takes a callback with two arguments
    // Expr<String?> and Expr<int>.
    .where((title, stock) => stock > toExpr(3))
    .select((title, stock) => (title,))
    // Remove null rows, we cannot do type promotion so the result is still
    // a Query<(Expr<String?>,)>
    .where((title) => title.isNotNull())
    // But we can use .orElse to callback to '', which gives us an
    // Query<(Expr<String>,)>, not that there is anything wrong with
    // returning a nullable expression.
    .select((title) => (title.orElse(toExpr('')),))
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

However, most databases have a query optimizer that'll make most of
the nested queries in the SQL above melt away. In practice, it's likely that,
while above query looks scary, it's probably as efficient as:
```sql
SELECT
  title
FROM books
WHERE stock > 3
  AND title IS NOT NULL
```

Of course, you should take care when writing queries, but it's probably more
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
    .where((title, stock) => stock > toExpr(3));

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
really necessary when scanning through a large set of rows from the database.

> [!NOTE]
> Within a transaction `Query.stream()` will not pause the stream when
> encountering back-pressure, instead it'll buffer the result-rows in-memory if
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
```

You must always provide `Order.ascending` or `Order.descending` for entries in
the return value from the callback in `.orderBy`. You can sort by any
`Expr<Comparable>`, typically `Expr<int>`, `Expr<double>`, `Expr<DateTime>`,
`Expr<String>`, or, `Expr<bool>`.

You can sort by arbitrary expressions not just fields, including subqueries,
but you might want to consider the performance implications before using a
complex subquery for ordering.

### Understanding `OrderedQuery<T>`
Unlike other _extension methods_ on `Query<T>` the `.orderBy` method returns
an `OrderedQuery<T>`, and not a `Query<T>`. This is because SQL disregards
ordering of rows in a subquery when used as _derived table_. Meaning that any
operation which needs to use the current query as a _derived table_ will
disgard the ordering established by a preceeding `.orderBy`.

To avoid the ordering from being accidentally discarded, the `.orderBy` method
returns an `OrderedQuery` object. The `OrderedQuery` object only has
_extension methods_ for which the ordering is preserved, unless explicitly
specified. Specifically, an `OrderedQuery` has a `.asQuery` extension method
that returns a `Query<T>`, which will allows the ordering to be disgarded.
Thus, if you have an `OrderedQuery` and wish to use it with `.union` or other
operation that disgards the ordering, you simply need to use `.asQuery`.

> [!NOTE]
> Technically, speaking the ordered query also has a `.orderBy`
> _extension method_ which returns an `OrderedQuery` wuth a new ordering,
> thus, discarding the existing ordering. But this should not come as a surprise
> to anyone, as the purpose of `.orderBy` is to specify an order.

When working on an `OrderedQuery` object, you will also find that some
_extension methods_ don't return an `OrderedQuery`, but instead a
`ProjectedOrderedQuery`, an `OrderedQueryRange` or a
`ProjectedOrderedQueryRange`. This is because once you have used `.limit` or
`.offset` on an `OrderedQuery`, it is no longer possible to apply `.where`
without using `.asQuery` (and discarding the establish order). Similar,
limitations occur when using `.distinct` or `.select`.

For the most part you can resolve these issues by applying `.orderBy` as late
as possible. Obviously, if you apply `.limit` or `.offset` before specifying an
order, you will get an arbitrary subset of the rows. But you can often specify
joins, filters, etc. before using `.orderBy`. If you can't, you can discard the
ordering with `.asQuery`, and either have unordered results, or specify the
ordering again using `.orderBy`.

> [!WARNING]
> Using `.asQuery` following `.orderBy` may cause the ordering to be discarded.


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

As previously mentioned, `.orderBy` returns an `OrderedQuery`, and while it's
still possible to use `.select` and `.limit` following `.orderBy`. It is not
possible to apply `.where` after `.limit`. Because `.where` would need to use
the query as a _derived table_ in SQL, where the ordering would be discarded.
We can allow `.where` to be used after `.limit` by using `.asQuery`, which
allows the ordering to be discarded.

Suppose we did want to books by a specific author that also appear in the top 3
of _all books_ with most stock. To do this we need to apply `.where` after
`.orderBy`, thus, we must use `.asQuery` to signal our intend to discard the
ordering, before we can use `.where`. If we wish to impose the ordering, we can
do so with an additional `.orderBy` as illustrated below.

```dart bookstore_test.dart#query-orderby-limit-where
final result = await db.books
    .orderBy((b) => [(b.stock, Order.descending)])
    .limit(3)
    .asQuery // allow the ordering to be discarded!
    .where((b) => b.authorId.equalsValue(2))
    .orderBy((b) => [(b.stock, Order.descending)])
    .select((b) => (b.title, b.stock))
    .fetch();

check(result).deepEquals([
  // title, stock
  ('Vegetarian Dining', 42),
]);
```

Notice that in the equivalent SQL below, the query before `.asQuery` is used
as a subquery in a _derived table_. While the `LIMIT 3` is used to limit the
rows from the subquery, the ordering of rows in the subquery does not affect
the order of the rows in the outer query. This has to be re-imposed with
another `ORDER BY` clause.

```sql
SELECT title, stock
FROM (
  SELECT bookId, title, authorId, stock
  FROM books
  ORDER BY stock DESC NULLS LAST
  LIMIT 3
)
WHERE authorId = 2
ORDER BY stock DESC NULLS LAST
```

Had we applied `.where` before imposing an order and limit of 3, we wouldn't
get the same result. We would instead get top 3 books of a specific author by
stock, as illustrated in the example below:

```dart bookstore_test.dart#query-where-orderby-limit
final result = await db.books
    .where((b) => b.authorId.equalsValue(2))
    .orderBy((b) => [(b.stock, Order.descending)])
    .limit(3)
    .select((b) => (b.title, b.stock))
    .fetch();

check(result).deepEquals([
  // title, stock
  ('Vegetarian Dining', 42),
  ('Vegan Dining', 3),
]);
```

For which the equivalent SQL looks something like:

```sql
SELECT title, stock
FROM books
WHERE authorId = 2
ORDER BY stock DESC NULLS LAST
LIMIT 3
```

To the extend possible, it is often possible to apply `.orderBy` as late as
possible, ideally right before `.limit` and `.offset`. But as can be seen in the
example above, this is not always possible.

> [!NOTE]
> After applying `.orderBy` the available extension methods are restricted to
> those that _preserved ordering_. You can use `.asQuery` to discard the
> ordering and use all the _extension methods_ available on `Query`.
> If you wanted the results of your query to be ordered, you must either avoid
> `.asQuery` or re-impose the ordering with another `.orderBy`.


## Point queries with `.byKey`, `.first` and `db.select()`
`package:typed_sql` generates a `.byKey()` method convenient for looking up a
row by _primary key_.
To look up the row in `books` with `bookId = 1` write:

```dart bookstore_test.dart#books-bykey
final book = await db.books.byKey(1).fetch();
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
useful if we only one care about the
first row. In practice, there are many scenarios where we know that there is
at-most one row, and using `.first` gives nicer typing.

```dart bookstore_test.dart#books-where-first
final book = await db.books
    .where((b) => b.title.equals(toExpr('Are Bunnies Unhealthy?')))
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
a book and an author in a single query performing two point queries at once, saving a round-trip to the database:

```dart bookstore_test.dart#select-book-and-author
final (book, author) = await db.select((
  db.books.asSubQuery
      .where((b) => b.title.equals(toExpr('Are Bunnies Unhealthy?')))
      .first,
  db.authors.byKey(1).asExpr,
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
> which on `SubQuery` returns `Expr<T>` as opposed to `.asExpr` which always
> gives you a nullable `Expr<T?>`.
>
> See [Aggregate functions] for more details.

In general, `.asExpr` is only available on `QuerySingle<(Expr<T>,)>`,
`.asExpr` is not available on queries returning multiple values.


## Point queries with `.byName` using `@Unique` constraints
Whenever a field is annotated `@Unique.field()` a `UNIQUE` constraint will be
added to the table schema, and in the generated code `package:typed_sql` will
introduce a convenient `.By<fieldName>` method to make _point queries_ using
the unique field.

Recall that `Author.name` is annotated with `@Unique.field()`. This means that
the _name_ field in the database will have `UNIQUE` constraint. But also that
`Query<(Expr<Author>,)>` will have a convenient `.byName` method.

```dart schema_references_test.dart#author-model
@PrimaryKey(['authorId'])
abstract final class Author extends Row {
  @AutoIncrement()
  int get authorId;

  @Unique.field()
  String get name;
}
```

The following example shows how to use the `.byName` extension method to
create a point query.

```dart bookstore_test.dart#authors.byName
final author = await db.authors.byName('Easter Bunny').fetch();

if (author == null) {
  throw Exception('Author not found');
}
check(author.authorId).equals(1);
```

Since `package:typed_sql` knows that a lookup on the _name_ field at-most return
a single row, the return value from `.byName` is `QuerySingle<(Expr<Author>,)>`.
Thus, `.fetch()` returns `Future<Author?>`.


## Expression reference
While it's possible to find extension methods by exploring the generated API
documentation, this can be a bit of a hassle. In practice, you're often better
off discovering available extension method using auto-completion. That said, it
can sometimes be nice to have an idea of what methods are available on
`Expr<T>` given a specific `T`.

The following is a high-level reference of _some_ of the available
_extension methods_:

 * `Expr<T?>`, when `T` is one of `bool`, `int`, `double`, `String`, `DateTime`, has:
    * `.equals(Expr<T> other) -> Expr<bool>`
    * `.equalsUnlessNull(Expr<T?> other) -> Expr<bool?>`
    * `.isNotDistinctFrom(Expr<T?> other) -> Expr<bool>`
    * `.isNull() -> Expr<bool>`
    * `.isNotNull() -> Expr<bool>`
    * `.orElse(Expr<T> other) -> Expr<T>`
    * `.asNotNull() -> Expr<T>`
 * `Expr<T>`, when `T` is one of `bool`, `int`, `double`, `String`, `DateTime`, has:
    * `.equals(Expr<T?> other) -> Expr<bool>`
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
 * `Expr<Uint8List>`, has:
    * `.length -> Expr<int>`,
    * `.toHex() -> Expr<String>`,
    * `.concat(Expr<UintList> other) -> Expr<UintList>`,
    * `.subList(Expr<int> start, {Expr<int>? length}) -> Expr<UintList>`
    * `.decodeUtf8() -> Expr<String>`

> [!NOTE]
> The reference above is not exhaustive, this is a quick reference, it'll not be
> updated for every new extension method introduced, though pull-requests to
> the documentation are appreciated.

The reference above, deliberately omits variations such as
`.<method>Value(...)` and `.not<method>(...)` because they are merely
convinience functions.

### Equality operators
In the previous reference there are 3 equality operators:

| `package:typed_sql`      | Return type   | SQL equivalent             | `NULL` compared to `NULL`? |
|--------------------------|---------------|:--------------------------:|:--------------------------:|
| `a.equals(b)`            | `Expr<bool>`  | `a = b`                    | N/A                        |
| `a.equalsUnlessNull(b)`  | `Expr<bool?>` | `a = b`                    | `NULL`                     |
| `a.isNotDistinctFrom(b)` | `Expr<bool>`  | `a IS NOT DISTINCT FROM b` | `TRUE`                     |

The difference between these operators is what arguments they take, and how they
behave when comparing to `NULL`. In SQL `NULL = NULL` yields `UNKNOWN`
represented by `NULL`. Meaning that when we compare two expressions in SQL using
the `=` operator, the result cannot be `TRUE` if one of the expressions is `NULL`.
This is very different from Dart. Thus, to avoid any confusion the SQL `=`
operator is exposed using the `.equalsUnlessNull` extension method.

The `.equalsUnlessNull` extension method will return `NULL` if any of the two
operands are `NULL`, thus, the return type for `.equalsUnlessNull` is
`Expr<bool?>`. This isn't very convenient, but if you're comparing two
expressions where one of them is not nullable, you can use the `.equals`
extension method.

The `.equals` extension method requires that at least one of the two operands
are not nullable. This is implemented by having two variants:
 * `Expr<T>.equals(Expr<T?> other) -> Expr<bool>`, and,
 * `Expr<T?>.equals(Expr<T> other) -> Expr<bool>`.

Thus, when using the `.equals` extension method the return type is `Expr<bool>`,
and the SQL operator used is `=`. The downside is that you cannot compare two
nullable expressions. If you wish to compare two nullable expressions you can use
`.isNotDistinctFrom` which has the same semantics as Dart, meaning that
`NULL IS NOT DISTINCT FROM NULL` evaluates to `TRUE`. Or you can use
`.equalsUnlessNull` if you want SQL semantics, where `NULL = NULL` evaluates to
`NULL`.

If you wish to compare two nullable expressions in manner where `NULL = NULL`
evaluates to `FALSE`, you can use `a.equalsUnlessNull(b).orElseValue(false)`.
Or you can do `a.isNotDistinctFrom(b) & a.isNotNull()`.

> [!TIP]
> While it is tempting to always use `.isNotDistinctFrom`, which has the same
> comparison semantics as equality in Dart, there are many scenarios where
> database engines are optimized for the `=` operator in SQL.
> And if you are joining tables you'll
> often find that you do not want to join two rows when the key in both tables
> is `NULL`.
>
> Thus, whenever you find that the `.equals` extension method doesn't work,
> because you are comparing two nullable expressions, do consider if you want
> the `NULL = NULL` to be `TRUE` or `FALSE`, before resorting to use
> `.isNotDistinctFrom`.


## Query reference
The following is a high-level overview of the most important extension methods
for `Query` objects. In practice, you'll often discover these through
auto-completion, but it can be useful to know that if you use `.select` to
select a single integer field (or expression) such that you have
`Query<(Expr<int>,)>` then you can call `.sum()` and get a
`QuerySingle<(Expr<int>,)>`.

 * `Query<T>`, when `T` is `(Expr<A>, Expr<B>, ...)`, has:
   * `.orderBy(List<(Expr<Comparable>, Order)> Function(Expr<A>, Expr<B>, ...) orderBy) -> OrderedQuery<T>`
   * `.where(Expr<bool> Function(Expr<A>, Expr<B>, ...) filter) -> Query<T>`
   * `.first -> QuerySingle<T>`
   * `.limit(int limit) -> Query<T>`
   * `.offset(int offset) -> Query<T>`
   * `.count() -> QuerySingle<(Expr<int>,)>`
   * `.exists() -> QuerySingle<(Expr<bool>,)>`
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
 * `OrderedQuery<T>`, when `T` is `(Expr<A>, Expr<B>, ...)`, has:
   * `.where(Expr<bool> Function(Expr<A>, Expr<B>, ...) filter) -> OrderQuery<T>`
   * `.limit(int limit) -> OrderedQueryRange<T>`
   * `.offset(int offset) -> OrderedQueryRange<T>`
   * `.select<S>(S Function(Expr<A>, Expr<B>, ...) projection) -> ProjectedOrderedQuery<S>`
   * `.distinct() -> ProjectedOrderedQuery<T>`
   * `.orderBy(List<(Expr<Comparable>, Order)> Function(Expr<A>, Expr<B>, ...) orderBy) -> OrderedQuery<T>`
   * `.asQuery -> Query<T>`
   * `.fetch() -> Future<List<(A, B, ...)>>`
   * `.stream() -> Stream<(A, B, ...)>`
 * `OrderedQueryRange<T>`, when `T` is `(Expr<A>, Expr<B>, ...)`, has:
   * `.limit(int limit) -> OrderedQueryRange<T>`
   * `.offset(int offset) -> OrderedQueryRange<T>`
   * `.select<S>(S Function(Expr<A>, Expr<B>, ...) projection) -> ProjectedOrderedQueryRange<S>`
   * `.orderBy(List<(Expr<Comparable>, Order)> Function(Expr<A>, Expr<B>, ...) orderBy) -> OrderedQuery<T>`
   * `.asQuery -> Query<T>`
   * `.fetch() -> Future<List<(A, B, ...)>>`
   * `.stream() -> Stream<(A, B, ...)>`
 * `ProjectedOrderedQuery<T>`, when `T` is `(Expr<A>, Expr<B>, ...)`, has:
   * `.limit(int limit) -> ProjectedOrderedQueryRange<T>`
   * `.offset(int offset) -> ProjectedOrderedQueryRange<T>`
   * `.distinct() -> ProjectedOrderedQuery<T>`
   * `.orderBy(List<(Expr<Comparable>, Order)> Function(Expr<A>, Expr<B>, ...) orderBy) -> OrderedQuery<T>`
   * `.asQuery -> Query<T>`
   * `.fetch() -> Future<List<(A, B, ...)>>`
   * `.stream() -> Stream<(A, B, ...)>`
 * `ProjectedOrderedQueryRange<T>`, when `T` is `(Expr<A>, Expr<B>, ...)`, has:
   * `.limit(int limit) -> ProjectedOrderedQueryRange<T>`
   * `.offset(int offset) -> ProjectedOrderedQueryRange<T>`
   * `.orderBy(List<(Expr<Comparable>, Order)> Function(Expr<A>, Expr<B>, ...) orderBy) -> OrderedQuery<T>`
   * `.asQuery -> Query<T>`
   * `.fetch() -> Future<List<(A, B, ...)>>`
   * `.stream() -> Stream<(A, B, ...)>`
 * `SubQuery<(Expr<T>,)>`, has:
   * `.first -> Expr<T?>`
 * `SubQuery<(Expr<T>,)>`, when `T` is one of `int`, `double`, `String`, `DateTime`, has:
   * `.min -> Expr<T>`
   * `.max -> Expr<T>`
 * `SubQuery<(Expr<T>,)>`, when `T` is one of `int`, `double` has:
   * `.sum() -> Expr<T>`
   * `.avg() -> Expr<double>`
 * `SubQuery` also has many of the same methods as `Query`.
 * `OrderedSubQuery`, etc, has many of the same methods as `OrderedQuery`.

> [!NOTE]
> The reference above is not exhaustive, this is a quick reference, it'll not be
> updated for every new extension method introduced, though pull-requests to
> the documentation are appreciated.

The above documentation does not outline how `.join` and `.groupBy` works, for
details on how to use these see [Joins] and [Aggregate functions].

<!-- GENERATED DOCUMENTATION LINKS -->
[Aggregate functions]: ../topics/Aggregate%20functions-topic.html
[Joins]: ../topics/Joins-topic.html
