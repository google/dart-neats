This documents shows how to update and delete rows using `package:typed_sql`.
Examples through out this document shall assume a database schemas defined as
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

  @Unique()
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

## Update a single row with `.update`
In `package:typed_sql` a `QuerySingle<(Expr<T>,)>` where `T extends Row` will
always have a `.update` method. You may construct the [QuerySingle] object
using `.byKey` or `.first`, even ontop of complex [Query] objects.
Though, in practice, you'll probably mostly update rows using the _primary key_
with `.byKey`.

If we wanted to decrement the stock count for the book with `bookId = 1`,
we can do this as follows:

```dart bookstore_test.dart#update-book-bykey
await db.books
    .byKey(1)
    .update((book, set) => set(
          stock: book.stock - toExpr(1),
        ))
    .execute();
```

The equivalent SQL would look something like:
```sql
UPDATE books
SET stock = stock - 1
WHERE bookId IS NOT DISTINCT FROM 1;
```

The `.update` extension method takes an callback that gets `Expr<Book>` and
a `set` function. The callback must return an `UpdateSet<Book>` object, which
can only be constructed by calling `set`. Hence, you must always write:
`.update((book, set) => set(...))`. The `set` function is generated by along
with your schema, and allows you to specify an expression for each field
that `Book` has, using a _named optional parameter_.

Thus, not only can we decide which fields to update, we also get a type error
in Dart if we specify a field that doesn't exist or tries to provide an
expression type that don't match. For example:
`.update((book, set) => set(stock: toExpr(3.14)))` would fail type checking in
Dart because the _named optional parameter_ `stock` has type `Expr<int>` and not
`Expr<double>`.

Furthermore, as illustrated in the example above, we can use complex
expressions, including subqueries, to update the field. See [Writing queries]
for details on how to construct expressions.

## Setting a field to `null` with `.update`
If we wanted to set the title of the book with `bookId = 1` to `null` we have
to use `toExpr(null)` as the value for the field. As illustrated in the
following example.

```dart bookstore_test.dart#update-book-bykey-set-null
await db.books
    .byKey(1)
    .update((book, set) => set(
          title: toExpr(null),
        ))
    .execute();
```

## Update multiple rows with `.update`
In `package:typed_sql` a `Query<(Expr<T>,)>` where `T extends Row` will
always have a `.update` method. We can use this `.update` method to update all
rows that match the query.

The following example shows how to reduce the stock by half for all books with
`stock > 5`. As division by two results in a `Expr<double>`, so we use
`.asInt()` to truncate to an `Expr<int>` with a `CAST` in SQL.

```dart bookstore_test.dart#update-books-where-stock-gt-5
await db.books
    .where((book) => book.stock > toExpr(5))
    .update((book, set) => set(
          stock: (book.stock / toExpr(2)).asInt(),
        ))
    .execute();
```


## Returning the updated values with `.returning`
When updating a row in SQL we can use a `RETURNING` clause to return the
updated rows. We can do the same thing in `package:typed_sql`.
The following example shows, how to use `.returnUpdated()` in the
`QuerySingle<(Expr<Row>,)>.update` example from earlier.

```dart bookstore_test.dart#update-book-bykey-returnUpdated
final updatedBook = await db.books
    .byKey(1)
    .update((book, set) => set(
          stock: book.stock - toExpr(1),
        ))
    .returnUpdated() // return the updated row
    .executeAndFetch();

if (updatedBook == null) {
  throw Exception('Book not found');
}
check(updatedBook.stock).equals(9);
```

The `.returnUpdated()` extension method can also be used with
`Query<(Expr<Row>,)>.update`, it will just return a list of the updated rows
instead. More generally, it's also possible to return a custom projection,
similar to the ones you can make with `.select`, as illustrated below:

```dart bookstore_test.dart#update-books-where-returning
final updatedStock = await db.books
    .where((book) => book.stock > toExpr(5))
    .update((book, set) => set(
          stock: (book.stock / toExpr(2)).asInt(),
        ))
    .returning((book) => (book.stock,))
    .executeAndFetch();

// We get 3 values because we updated 3 rows.
check(updatedStock).unorderedEquals([
  21,
  5,
  6,
]);
```

Using `.returning` it's possible to return only the particular fields you care
about. You can also use it to return more complex expressions,
including subqueries.
The astute reader might realize that the `.returnInserted()` extension method is
just an short-hand for `.returning((row) => (row,))`.

> [!NOTE]
> The return value of the `.returning` extension method is **not** a `Query`
> object, because SQL does not support using results from an `UPDATE` statement
> in a subquery. Thus, it is not possible to combine it with other extension
> methods for `Query` objects. The only thing you can do is `.executeAndFetch()`.


## Deleting rows with `.delete`
If you have a `QuerySingle<(Expr<T>,)>` or `Query<(Expr<T>,)>` where
`T extends Row`, then you can delete the rows using `.delete`.
The following example shows how to delete the book with `bookId = 1`.

```dart bookstore_test.dart#books-byKey-delete
await db.books.byKey(1).delete().execute();
```

The equivalent SQL would look something like:
```sql
DELETE FROM books WHERE bookId IS NOT DISTINCT FROM 1
```

> [!NOTE]
> In this example `db.books` is actually a `Table<Book>` object, which extends
> `Query<(Expr<Book>,)>`. However, to make it harder to accidentally delete all
> rows in your table, there is a special `.delete(bookId: ...)` extension method
> on `Table<Book>`.
>
> If you really want to delete all rows in a table, simply do:
> ```dart
> await db.books.where((b) => toExpr(true)).delete().execute();
> ```

Similarly, to `.update` it is also possible to use `.returning`
(or `.returnDeleted`) to fetch the deleted rows. The following example shows how
delete all books with `authorId = 1` and return the title and stock field from
the book.

```dart bookstore_test.dart#books-where-delete-return
final deletedBooks = await db.books
    .where((book) => book.authorId.equals(toExpr(1)))
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
```

Similarly, to `.update`, you'll find that when you use `.delete().returning`
on a `Query<(Expr<T>,)>` the `.executeAndFetch()` method returns a `List`.
But if you use it on a `QuerySingle<(Expr<T>,)>`, you just get a nullable row.

<!-- GENERATED DOCUMENTATION LINKS -->
[Query]: ../typed_sql/Query-class.html
[QuerySingle]: ../typed_sql/QuerySingle-class.html
[Writing queries]: ../topics/Writing%20queries-topic.html
