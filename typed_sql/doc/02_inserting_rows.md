This document aims to demonstrate how rows can be inserting into a database
using `package:typed_sql`.

In the examples below, assume a database schema defined as follows:

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

  @Unique.field()
  String? get title;

  @References(table: 'authors', field: 'authorId', name: 'author', as: 'books')
  int get authorId;

  @DefaultValue(0)
  int get stock;
}
```

And assume that `db` is an instance of
`Database<Bookstore>`.


## Insert a row in the `authors` table
If we want to insert an author into our database we can do that as follows:

```dart bookstore_test.dart#authors-insert
await db.authors
    .insert(
      name: toExpr('Roger Rabbit'),
    )
    .execute();
```

This works because the `authorId` is annotated `@AutoIncrement()`, which means
that by default it'll get an integer value higher than the previous one
(the exact semantics may depend on the database).

It is also possible to explicitly insert an author with a specific `authorId`,
as illustrated below:

```dart bookstore_test.dart#authors-insert-with-id
await db.authors
    .insert(
      authorId: toExpr(42),
      name: toExpr('Roger Rabbit'),
    )
    .execute();
```

For maximum flexibility we do not simply provide `name` or `id` as
`String` or `int` respectively. Instead we have to give an `Expr<String>` or
`Expr<int>`. We can create such expressions using the [toExpr] function
(or `.asExpr` extension method).

The `toExpr<T>(T value)` function works for the following types:
 * `bool` (e.g. `toExpr(true)`),
 * `int` (e.g. `toExpr(42)`),
 * `double` (e.g. `toExpr(3.14)`),
 * `String` (e.g. `toExpr('hello world')`),
 * `DateTime` (e.g. `toExpr(DateTime.now())`, will normalize to UTC),
 * `Uint8List` (e.g. `toExpr(Uint8List.from([1, 2, 3]))`), and,
 * `Null` (e.g. `toExpr(null)`).

By wrapping values in `Expr<T>` it possible for `package:typed_sql` to
distinguish between an omitted value (default value), and intentional decision
to insert `NULL`. Because `NULL` is always represented as `toExpr(null)`.
As we will explore later, this also enables us to insert values directly
from a subquery.

For convinience, `package:typed_sql` will generate a `.insertValue` method,
which wraps arguments with [toExpr]. This is strictly less powerful than using
`.insert` as you cannot insert value from a subquery.

```dart bookstore_test.dart#authors-insertValue-with-id
await db.authors
    .insertValue(
      authorId: 42,
      name: 'Roger Rabbit',
    )
    .execute();
```

> [!CAUTION]
> If a field is _nullable_ in the database, then providing `null` to
> `insertValue` will insert `NULL`, even if the field has a _default value_.
>
> It is possible to omit a field that has a _default value_ by providing `null`,
> but for nullable fields, this does **not** insert the _default value_.


## Insert with `RETURNING` clause
Using `@AutoIncrement()` for _primary key_ fields is very convinient, but it makes it
hard to know what the `authorId` of the newly inserted row is. In SQL we can
access the inserted row using a `RETURNING` clause, with `package:typed_sql` we
also add a `.returning` clause.

In the simplest form, we can add a `.returnInserted()` clause, this
will return an `Author` object representing the inserted row, as illustrated
below:

```dart bookstore_test.dart#authors-insert-returnInserted
final author = await db.authors
    .insert(
      name: toExpr('Roger Rabbit'),
    )
    .returnInserted()
    .executeAndFetch();

// We can now access properties on author, like:
// author.authorId
check(author.authorId).isA<int>();
```

While simple and easy to type, if we only want access to a subset of the
properties of the row that was inserted, we can return a projection with
`.returning(projectionBuilder)`. In the example below the `projectionBuilder`
gets an `Expr<Author>` representing the row that was inserted, and it returns
a record where values are [Expr] objects.

```dart bookstore_test.dart#authors-insert-returning-authorId
final authorId = await db.authors
    .insert(
      name: toExpr('Roger Rabbit'),
    )
    .returning((author) => (author.authorId,))
    .executeAndFetch();

// We now have the authorId available as authorId
check(authorId).isA<int>();
```

In the example above the we create a record with one value `author.authorId`,
which means that the result from `.executeAndFetch()` will be the `authorId`
of the newly inserted row. This is useful if we want to insert books referencing
the newly inserted author.

It's worth noting that it is possible to write complex expressions and return
multiple values in the `.returning` clause.
For more information on projections, see [Writing queries].

## Insert from subquery
If we want to insert a row in the `books` table, but we don't know the
`authorId` of the author then we can obviously use a query to lookup the author
first. The following example shows how to lookup the author first, and then
insert a book referencing said author.

```dart bookstore_test.dart#books-insert-w-lookup
final authorId = await db.authors
    .where((author) => author.name.equals(toExpr('Easter Bunny')))
    .select((author) => (author.authorId,))
    .first
    .fetch();

if (authorId == null) {
  throw Exception('Could not find the author');
}

await db.books
    .insert(
      title: toExpr('How to hide eggs'),
      authorId: toExpr(authorId),
    )
    .execute();
```

Notice that when inserting a row in the `books` table, we are not required to
specify `stock`, the field has an `@DefaultValue(0)` annotation. Hence, when
we don't specify `stock` a default value of `0` is assigned to the newly
inserted row.

The approach above gives us a lot of control over failure scenarios, such as
when an author with `name = 'Easter Bunny'` cannot be found in the database.
The downside is that requires two queries, which also means two round-trips to
the database. If we know for fact that the Easter Bunny exists, we can
make a single insert where we lookup the `authorId` of the Easter Bunny in a
subquery.

```dart bookstore_test.dart#books-insert-subquery
await db.books
    .insert(
      title: toExpr('How to hide eggs'),
      authorId: db.authors.asSubQuery
          .where((author) => author.name.equals(toExpr('Easter Bunny')))
          .first
          .authorId
          .asNotNull(),
    )
    .execute();
```

The `.asSubQuery` converts the `Query<(Expr<Author>,)>` to a
`SubQuery<(Expr<Author>,)>` such that `.first` returns an `Expr<Author?>`.
The `.asNotNull()` is only safe because we know that the Easter Bunny
exists, if the subquery turns out to be empty, then `.authorId` may indeed by
`NULL` and the insertion will fail because `authorId` has a `NOT NULL`
constraint.

> [!WARNING]
> The `.asNotNull()` is a no-op that simply casts the value to a
> non-nullable `Expr<T>` in Dart. If the expression actually turns out to be
> `NULL` at runtime, `.asNotNull()` will not necessarily cause an error.
> Instead it'll allow the `NULL` value propagate, so if the `Book.authorId`
> property was nullable such insertion would have been allowed.

For more information on subqueries see [Writing queries].


## Upsert with `ON CONFLICT` clause
Suppose we wanted to ensure that an author exists in our database, we could use
a transaction to first check if the author exists, and insert a new row if it
doesn't exist. This is time proven and for some complex operations it is the
only way to do it. But for many common cases we could just use an
[upsert-clause][sqlite-upsert].

The following example will skip inserting the row, if the insertion would have
failed with a _primary key_ conflict. Creating a new row in `authors` if
`authorId: 42` does not exist, and otherwise, skip insertion.

```dart bookstore_test.dart#authors-insertValue-onConflict-doNothing
await db.authors
    .insertValue(
      authorId: 42,
      name: 'Roger Rabbit',
    )
    .onConflict(.primaryKey)
    .doNothing()
    .execute();
```

The `.onConflict(target)` extension method is used to specify a
_conflict target_. The _conflict target_ is either a `PRIMARY KEY` or `UNIQUE`
constraint. If the insert statement violates a constraint other than the one
specified as _conflict target_ the operation fails. `package:typed_sql` will
generate an enum consisting of _conflict targets_ ensuring that you can only
pass valid _conflict targets_ to `.onConflict(target)`.

Once you have specified a _conflict target_ using `.onConflict`, you must
specify a conflict action. This can be `.doNothing()` or `.update(...)`
depending on whether you wish to skip inserting the row, or update the existing
row. The `.update((row, excluded, set) => set(...))` method takes a builder that
is given 3 parameters:
 * `row`, the conflicting row as it exists in the database.
 * `excluded`, the row that should have been inserted, but conflicted with row.
 * `set`, a builder for defining the updates to be made on `row`.

The following example demonstrates how to insert a book with `stock: 5` or
update the existing row, if a book with matching `title` already exists.

```dart bookstore_test.dart#books-insert-onConflict-update
await db.books
    .insert(
      title: toExpr('Vegan Dining'),
      authorId: db.authors
          .byName('Bucks Bunny')
          .asExpr
          .authorId
          .asNotNull(),
      stock: toExpr(5),
    )
    .onConflict(.title)
    .update(
      (book, excluded, set) => set(
        stock: book.stock + excluded.stock,
      ),
    )
    .execute();
```

Finally, if we only wanted the `stock` to be updated if the current stock is
below `50`, we can make the `.update` clause conditional using the `.where`
extension method as illustrated below:

```dart bookstore_test.dart#books-insert-onConflict-update-where
await db.books
    .insert(
      title: toExpr('Vegan Dining'),
      authorId: db.authors
          .byName('Bucks Bunny')
          .asExpr
          .authorId
          .asNotNull(),
      stock: toExpr(5),
    )
    .onConflict(.title)
    .update(
      (book, excluded, set) => set(
        stock: book.stock + excluded.stock,
      ),
    )
    .where((book, excluded) => book.stock < toExpr(50))
    .execute();
```

This will insert a new book, or if there is an existing row with a conflicting
`title`, it will update `stock` on the existing row, if the existing `stock` is
less than 50. If existing `stock` is more than 50, then it'll skip inserting and
updating the row altogether (similar to `.doNothing()`).

This may be further combined with `.returning()` or `.returnUpserted()` to add
on a `RETURNING` clause. Though it should be observed that only the inserted or
updated rows will be returned, and if you're using `.doNothing()` or `.where()`
rows may be skipped.

```dart bookstore_test.dart#books-insert-onConflict-update-where-returning
final currentStock = await db.books
    .insert(
      title: toExpr('Vegan Dining'),
      authorId: db.authors
          .byName('Bucks Bunny')
          .asExpr
          .authorId
          .asNotNull(),
      stock: toExpr(5),
    )
    .onConflict(.title)
    .update(
      (book, excluded, set) => set(
        stock: book.stock + excluded.stock,
      ),
    )
    .where((book, excluded) => book.stock < toExpr(50))
    .returning((book) => (book.stock,))
    .executeAndFetch();

// We now have the stock, whether inserted or updated,
// but not if skipped!
check(currentStock).equals(8);
```

The equivalent SQL depends on the database, but it looks something like:
```sql
INSERT INTO books (title, authorId, stock)
VALUES ('Vegan Dining', (SELECT authorId FROM authors WHERE name = 'Bucks Bunny'), 5)
ON CONFLICT (title)
UPDATE SET stock = stock + excluded.stock
WHERE stock < 50
RETURNING stock
```

[sqlite-upsert]: https://sqlite.org/lang_upsert.html

<!-- GENERATED DOCUMENTATION LINKS -->
[Expr]: ../typed_sql/Expr-class.html
[Writing queries]: ../topics/writing_queries-topic.html
[toExpr]: ../typed_sql/toExpr.html
