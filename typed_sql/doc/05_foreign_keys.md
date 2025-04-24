This document aims to demonstrate how to use foreign keys when writing queries
in `package:typed_sql`.

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

And that the database is loaded with the following examples:
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

## Declaring foreign keys
In the schema above `Book.authorId` is declared as a _foreign key_ using the
`@References` annotation. The `table` and `field` parameters are required,
these point to the _table_ and _field_ that is being referenced.
The `name` and `as` properties are optional, if present they will be used to
generate convenient subquery properties when building queries.

```dart schema_test.dart#book-model
@PrimaryKey(['bookId'])
abstract final class Book extends Row {
  @AutoIncrement()
  int get bookId;

  String? get title;

  @References(
    // This fields references "authorId" from "authors" table
    table: 'authors',
    field: 'authorId',

    // The reference is _named_ "author", this gives rise to a
    // Expr<Book>.author property when building queries.
    name: 'author', // optional

    // This is referenced _as_ "books", this gives rise to a
    // Expr<Author>.books property when building queries.
    as: 'books', // optional
  )
  int get authorId;

  @DefaultValue(0)
  int get stock;
}
```

> [!NOTE]
> At this point `package:typed_sql` does not support composite _foreign keys_.
> There is probably nothing that fundamentally makes it impossible to introduce
> support for composite foreign keys in the future. But in most cases, you
> should probably avoid such constructs when possible.


## Following references in a query (using reference `name`)
With the `@References` annotation in place, `package:typed_sql` will use
the `name: 'author'` parameter to generate an extension method
`Expr<Book>.author`. The `author` extension method will return a subquery
looking up the row in the authors table referenced by `Book.authorId`.

The following example shows, how we can use the `Expr<Book>.author` to lookup
a book and its author in a single query.

```dart bookstore_test.dart#books-follow-reference-by-name
final bookAndAuthor = await db.books
    .byKey(1)
    .select((book) => (
          book,
          book.author, // <-- use the 'author' subquery property
        ))
    .fetch(); // return Future<(Book, Author)?>

if (bookAndAuthor == null) {
  throw Exception('Book not found');
}
final (book, author) = bookAndAuthor;
check(book.title).equals('Are Bunnies Unhealthy?');
check(author.name).equals('Easter Bunny');
```

We can also use the `Expr<Book>.author` property in `.where`, and we can access
properties on the `Expr<Author>` returned by `Expr<Book>.author`, as
demonstrated in the following example:

```dart bookstore_test.dart#books-use-reference-in-where
final titleAndAuthor = await db.books
    .where((book) => book.author.name.equals(toExpr('Easter Bunny')))
    .select((book) => (
          book.title,
          book.author.name,
        ))
    .fetch();

check(titleAndAuthor).unorderedEquals([
  // title, author
  ('Are Bunnies Unhealthy?', 'Easter Bunny'),
  ('Cooking with Chocolate Eggs', 'Easter Bunny'),
  ('Hiding Eggs for dummies', 'Easter Bunny'),
]);
```

Had the `Book.authorId` been nullable, then `Expr<Book>.author` would have
returned `Expr<Author?>`. But you can still access properties on
`Expr<Author?>`, however, you'll find that all properties are nullable.

It's also worth noting that if we had omitted the `name: 'author'` parameter
from the `@References` annotation, then the `Expr<Book>.author` extension method
would not have been generated. So you can decide whether or not you want the
these helper methods.

While subqueries are simple to use, and outright fantastic when writing
point queries, as they make it easy to return a row along with any referenced rows
in a single query. Subqueries can also lead to poor query
performance, in which case joins _might_ be a better option.

> [!WARNING]
> When accessing properties on a subquery like `Expr<Book>.author.name` it is
> important to remember that accessing two properties leads to two subqueries.
> It's possible that the _query optimizer_ will coalesce them, but this might
> depend on your database.

## Following referenced-by in a query (using reference `as`)
The `@Reference` annotation also has an optional `as: books` parameter.
This will be used by `package:typed_sql` to generate an extension method
`Expr<Author>.books`. The `books` extension method will return a
`SubQuery<(Expr<Book>,)>` matching all the rows in the books table that
reference the given row in the authors table.

We can't directly return a `SubQuery` in a`.select` projection, but we can use
`.first` or an _aggregate function_ on the `SubQuery` in a `.select` projection,
or `.where` filter. The following example shows how lookup `authorId = 1` along
with the count of books referencing said row the authors table.

```dart bookstore_test.dart#authors-bykey-count-books
final authorAndCount = await db.authors
    .byKey(1)
    .select((author) => (
          author,
          author.books.count(),
        ))
    .fetch();

if (authorAndCount == null) {
  throw Exception('Author not found');
}
final (author, count) = authorAndCount;
check(author.name).equals('Easter Bunny');
check(count).equals(3);
```

This is particularly convenient for point queries as demonstrated above. But
you can also use it for queries returning multiple rows, as in the example
below.

```dart bookstore_test.dart#authors-count-books
final authorAndCount = await db.authors
    .select((author) => (
          author.name,
          author.books.count(),
        ))
    .fetch();

check(authorAndCount).unorderedEquals([
  // name, count
  ('Easter Bunny', 3),
  ('Bucks Bunny', 2),
]);
```

While it's possible to count authors for each book using a subquery, as in the
example above. It may be easier for the _query optimizer_ to optimize this
query, if we used `.join` and `.groupBy`, see [Aggregate functions] for more
details.

<!-- GENERATED DOCUMENTATION LINKS -->
[Aggregate functions]: ../topics/Aggregate%20functions-topic.html
