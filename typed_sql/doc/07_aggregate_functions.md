With SQL it's possible to derive aggregates like `SUM`, `AVG`, `MIN`, `MAX` and
`COUNT`, these aggregate functions are also available in `package:typed_sql`.
However, inorder to prevent runtime errors due to malformed queries, you cannot
simply pass an `Expr` to an aggregate function in a projection with `.select()`.
Instead, the aggregate functions are exposed as extension methods on queries
with a single column, or using `.groupBy` to build complex aggregations.

## Bookstore example
This document will show to use aggregate functions count books, and summarize
inventory by author in a bookstore example with schema defined as follows:

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

For the remainder of this document we shall assume that `db` is an instance of
`Database<Bookstore>`.


## Example data
Through examples in this document we shall assume that the following test-data
has been loaded into the database.

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


## `SUM(stock)` for books in inventory
Using SQL we could `SUM(stock)` for all books to get the total number of books
in inventory, in SQL this might look like:
```sql
SELECT SUM(stock) FROM books;
```

In Dart we can do the same thing by first doing a `.select` to project from
`Query<(Expr<Book>,)>` to `Query<(Expr<int>,)>` for which `.sum()` extension
method is available.

```dart bookstore_test.dart#sum-books-in-inventory
final result = await db.books
    .select(
      (book) => (book.stock,),
    ) // .select() returns Query<(Expr<int>,)>, which has a .sum() method
    .sum()
    .fetch();

check(result).equals(67);
```

## `SUM(stock)`, `COUNT(*)` for books in inventory
Supposed you wanted to know how many books you have in inventory and how many
different books, in SQL this might look like:
```sql
SELECT SUM(stock), COUNT(*) FROM books;
```

In Dart we can't really do the same thing, but we can make two subqueries in
`db.select()` as follows:
```dart bookstore_test.dart#sum-books-and-count-books-in-inventory
final (totalStock, countDifferntBooks) = await db.select(
  (
    db.books.asSubQuery.select((book) => (book.stock,)).sum(),
    db.books.asSubQuery.count(),
  ),
).fetchOrNulls();

check(totalStock).equals(67);
check(countDifferntBooks).equals(5);
```

Using `.asSubQuery` let's us convert a `Query<T>` into a `SubQuery<T>`, where
all the methods that would have returned `QuerySingle<(Expr<T>,)>` instead
return `Expr<T>`, which makes it easier to use result as expressions in other
queries.

The same query could also be done with `.asExpr` to convert
`QuerySingle<(Expr<T>,)>` into `Expr<T?>`. However, using `.asSubQuery` should
be preferred as it doesn't make the result nullable.

```dart bookstore_test.dart#sum-books-and-count-books-in-inventory-as-expr
final (totalStock, countDifferntBooks) = await db.select(
  (
    db.books.select((book) => (book.stock,)).sum().asExpr,
    db.books.count().asExpr,
  ),
).fetchOrNulls();

check(totalStock).equals(67);
check(countDifferntBooks).equals(5);
```

> [!NOTE]  
> Using multiple subqueries this way _might_ not be as efficient as the SQL
> expressed in the initial example. But for simple cases, the query optimizer
> can hopefully execute the subqueries concurrently.
>
> For advanced cases `.groupBy` can be used aggregate across multiple columns.


## `SUM(stock), COUNT(*)` for books `GROUP BY author`
Supposed that in our example we wanted to do know how many books we have in
stock for each author. In SQL this would typically be done using a `GROUP BY`
query, as illustrated below:

```sql
SELECT authorId, SUM(stock) FROM books GROUP BY authorId;
```

In Dart we can do the same thing using `.groupBy` and `.aggregate` as follows:
```dart bookstore_test.dart#sum-books-group-by-author
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
```

The `.groupBy` method is used to make a projection (like `.select`), each
distinct row of the projection becomes a group, and rows in said group is
aggregated using `.aggregate`.

The `.aggregate` function give you an _aggregation builder_ `agg` which is used
to build aggregations. By adding each aggregate function with chained method
calls the `.aggregate` function can return query that is the combination of
projection from the `.groupBy` and the aggregations.

The following `.select` is entirely optional, without the result would have been
`List<(Author, int, int)>` instead of `List<(String, int, int)>`.

> [!TIP]  
> The optional `// aggregates:` comment after `(agg) => agg` forces the
> Dart formatter put each aggregated column on a new line.

The astute reader might have noticed that the SQL query given at the start of
this section does in fact not return the _author name_, instead it's grouped by
`authorId`, and would return the `authorId`. This is because the `b.author` in
the `.groupBy` projection is actually a reference, which in turn makes the
`author.name` in the final `.select` projection a subquery. We could avoided
this by simply using `b.authorId` in the `.groupBy` projection, as illustrated
below:
```dart bookstore_test.dart#sum-books-group-by-authorId
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
```

But in practice, using references like `b.author` instead of `b.authorId` make
it easy to lookup associated rows in the database. However, for complex queries
subqueries can sometimes be slow. The next section on `.join` illustrates how
to effectively avoid subqueries. Though it can be wise to not optimize
prematurely, and instead prefer to optimize slow queries when they become
a problem.

## `SUM(stock), COUNT(*)` for books `GROUP BY author` using `JOIN`
As mentioned in the previous section, if we want to look up _author name_ along
with the aggregates for stock and count of books, we can also use a `JOIN`.
In SQL this is typically done as follows:
```sql
SELECT authors.name, SUM(stock), COUNT(*)
FROM books
JOIN authors ON books.authorId = authors.authorId
GROUP BY authors.name;
```

In Dart we can do the same with `.join` which creates a `CROSS JOIN`, and `.on`
which specifies which columns to join on.
```dart bookstore_test.dart#sum-books-group-by-using-join
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
```

## `SUM(STOCK)` in subquery for each author
While the `.groupBy` or `.join`/`.groupBy` approaches above are likely to give
the query optimizer the best information for efficient execution, these
mechanisms are not always the easiest to use. This is obviously a matter of
personal preference and style, but aggregation by author can also be done using
subqueries as follows:

```dart bookstore_test.dart#sum-books-by-author-with-subquery
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
```

Because `Book.authorId` is annotated with `References(..., as: 'books')` we get
a generated extension method `Expr<Author>.books` which returns a `SubQuery`
for books that reference the represented authors row.

This is equivalent to to the following SQL:
```sql
SELECT
  authors.name,
  (SELECT SUM(stock) FROM books WHERE books.authorId = authors.authorId)
FROM authors;
```

> [!NOTE]
> Using subqueries this way can provide challenges for the query optimizer.
> But it can be preferable to write queries as comphrensible as possible, and
> then add instrumentation and optimize slow queries only when they become
> problematic.

## Aggregate function reference
As illustrated above there are two ways to use aggregate functions:
 * (A) Use `.select` to project to single column and use an extension method:
   * `Query<(Expr<T>,)>.count()`,
   * `Query<(Expr<num>,)>.sum()`,
   * `Query<(Expr<num>,)>.avg()`,
   * `Query<(Expr<Comparable>,)>.min()`, and,
   * `Query<(Expr<Comparable>,)>.min()`,
 * (B) Use `.groupBy` to create groups where `.aggregate` can build aggregations
   using:
   * `agg.count()`,
   * `agg.sum((column1, column2, ...) => Expr<num>)`,
   * `agg.avg((column1, column2, ...) => Expr<num>)`,
   * `agg.min((column1, column2, ...) => Expr<Comparable>)`, and,
   * `agg.max((column1, column2, ...) => Expr<Comparable>)`.

In all cases it's important to note that `package:typed_sql` have the following
discrepencies from SQL:
 * `SUM()` in SQL may return `NULL`, if there are no rows or all rows are `NULL`.
   But in `package:typed_sql` the `.sum()` expressions will always return zero
   instead of `null`.
 * `AVG()` in SQL will not count `NULL` values for the purpose of calculating
   the average. These semantics are preserved in `package:typed_sql`.
 * `AVG()`, `MIN()`, and `MAX()` in SQL may return `NULL`, if there are no rows
   or all rows are `NULL`, these semantics are preserved in `package:typed_sql`.
 * `COUNT(*)` in SQL will count all rows, including `NULL` values, these
   semantics are preserved in `.count()`.
 * `COUNT(column)` in SQL will count all rows that are not `NULL`, this is not
   offered in `package:typed_sql`, but can be trivially emulated using
   `.where((row) => row.isNotNull()).sum()`.
