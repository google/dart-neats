// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'references_id_as_test.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

/// Extension methods for a [Database] operating on [TestDatabase].
extension TestDatabaseSchema on Database<TestDatabase> {
  static const _$tables = [_$Author._$table, _$Book._$table];

  Table<Author> get authors => $ForGeneratedCode.declareTable(
        this,
        _$Author._$table,
      );

  Table<Book> get books => $ForGeneratedCode.declareTable(
        this,
        _$Book._$table,
      );

  /// Create tables defined in [TestDatabase].
  ///
  /// Calling this on an empty database will create the tables
  /// defined in [TestDatabase]. In production it's often better to
  /// use [createTestDatabaseTables] and manage migrations using
  /// external tools.
  ///
  /// This method is mostly useful for testing.
  ///
  /// > [!WARNING]
  /// > If the database is **not empty** behavior is undefined, most
  /// > likely this operation will fail.
  Future<void> createTables() async => $ForGeneratedCode.createTables(
        context: this,
        tables: _$tables,
      );
}

/// Get SQL [DDL statements][1] for tables defined in [TestDatabase].
///
/// This returns a SQL script with multiple DDL statements separated by `;`
/// using the specified [dialect].
///
/// Executing these statements in an empty database will create the tables
/// defined in [TestDatabase]. In practice, this method is often used for
/// printing the DDL statements, such that migrations can be managed by
/// external tools.
///
/// [1]: https://en.wikipedia.org/wiki/Data_definition_language
String createTestDatabaseTables(SqlDialect dialect) =>
    $ForGeneratedCode.createTableSchema(
      dialect: dialect,
      tables: TestDatabaseSchema._$tables,
    );

final class _$Author extends Author {
  _$Author._(
    this.authorId,
    this.firstname,
    this.lastname,
  );

  @override
  final int authorId;

  @override
  final String firstname;

  @override
  final String lastname;

  static const _$table = (
    tableName: 'authors',
    columns: <String>['authorId', 'firstname', 'lastname'],
    columnInfo: <({
      ColumnType type,
      bool isNotNull,
      Object? defaultValue,
      bool autoIncrement,
      List<SqlOverride> overrides,
    })>[
      (
        type: $ForGeneratedCode.integer,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: true,
        overrides: <SqlOverride>[],
      ),
      (
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: <SqlOverride>[],
      ),
      (
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: <SqlOverride>[],
      )
    ],
    primaryKey: <String>['authorId'],
    unique: <List<String>>[],
    foreignKeys: <({
      String name,
      List<String> columns,
      String referencedTable,
      List<String> referencedColumns,
    })>[],
    readRow: _$Author._$fromDatabase,
  );

  static Author? _$fromDatabase(RowReader row) {
    final authorId = row.readInt();
    final firstname = row.readString();
    final lastname = row.readString();
    if (authorId == null && firstname == null && lastname == null) {
      return null;
    }
    return _$Author._(authorId!, firstname!, lastname!);
  }

  @override
  String toString() =>
      'Author(authorId: "$authorId", firstname: "$firstname", lastname: "$lastname")';
}

/// Extension methods for table defined in [Author].
extension TableAuthorExt on Table<Author> {
  /// Insert row into the `authors` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<Author> insert({
    Expr<int>? authorId,
    required Expr<String> firstname,
    required Expr<String> lastname,
  }) =>
      $ForGeneratedCode.insertInto(
        table: this,
        values: [
          authorId,
          firstname,
          lastname,
        ],
      );

  /// Delete a single row from the `authors` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<Author> delete(int authorId) => $ForGeneratedCode.deleteSingle(
        byKey(authorId),
        _$Author._$table,
      );
}

/// Extension methods for building queries against the `authors` table.
extension QueryAuthorExt on Query<(Expr<Author>,)> {
  /// Lookup a single row in `authors` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<Author>,)> byKey(int authorId) =>
      where((author) => author.authorId.equalsValue(authorId)).first;

  /// Update all rows in the `authors` table matching this [Query].
  ///
  /// The changes to be applied to each row matching this [Query] are
  /// defined using the [updateBuilder], which is given an [Expr]
  /// representation of the row being updated and a `set` function to
  /// specify which fields should be updated. The result of the `set`
  /// function should always be returned from the `updateBuilder`.
  ///
  /// Returns an [Update] statement on which `.execute()` must be called
  /// for the rows to be updated.
  ///
  /// **Example:** decrementing `1` from the `value` field for each row
  /// where `value > 0`.
  /// ```dart
  /// await db.mytable
  ///   .where((row) => row.value > toExpr(0))
  ///   .update((row, set) => set(
  ///     value: row.value - toExpr(1),
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  Update<Author> update(
          UpdateSet<Author> Function(
            Expr<Author> author,
            UpdateSet<Author> Function({
              Expr<int> authorId,
              Expr<String> firstname,
              Expr<String> lastname,
            }) set,
          ) updateBuilder) =>
      $ForGeneratedCode.update<Author>(
        this,
        _$Author._$table,
        (author) => updateBuilder(
          author,
          ({
            Expr<int>? authorId,
            Expr<String>? firstname,
            Expr<String>? lastname,
          }) =>
              $ForGeneratedCode.buildUpdate<Author>([
            authorId,
            firstname,
            lastname,
          ]),
        ),
      );

  /// Delete all rows in the `authors` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<Author> delete() => $ForGeneratedCode.delete(this, _$Author._$table);
}

/// Extension methods for building point queries against the `authors` table.
extension QuerySingleAuthorExt on QuerySingle<(Expr<Author>,)> {
  /// Update the row (if any) in the `authors` table matching this
  /// [QuerySingle].
  ///
  /// The changes to be applied to the row matching this [QuerySingle] are
  /// defined using the [updateBuilder], which is given an [Expr]
  /// representation of the row being updated and a `set` function to
  /// specify which fields should be updated. The result of the `set`
  /// function should always be returned from the `updateBuilder`.
  ///
  /// Returns an [UpdateSingle] statement on which `.execute()` must be
  /// called for the row to be updated. The resulting statement will
  /// **not** fail, if there are no rows matching this query exists.
  ///
  /// **Example:** decrementing `1` from the `value` field the row with
  /// `id = 1`.
  /// ```dart
  /// await db.mytable
  ///   .byKey(1)
  ///   .update((row, set) => set(
  ///     value: row.value - toExpr(1),
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  UpdateSingle<Author> update(
          UpdateSet<Author> Function(
            Expr<Author> author,
            UpdateSet<Author> Function({
              Expr<int> authorId,
              Expr<String> firstname,
              Expr<String> lastname,
            }) set,
          ) updateBuilder) =>
      $ForGeneratedCode.updateSingle<Author>(
        this,
        _$Author._$table,
        (author) => updateBuilder(
          author,
          ({
            Expr<int>? authorId,
            Expr<String>? firstname,
            Expr<String>? lastname,
          }) =>
              $ForGeneratedCode.buildUpdate<Author>([
            authorId,
            firstname,
            lastname,
          ]),
        ),
      );

  /// Delete the row (if any) in the `authors` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<Author> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$Author._$table);
}

/// Extension methods for expressions on a row in the `authors` table.
extension ExpressionAuthorExt on Expr<Author> {
  Expr<int> get authorId =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String> get firstname =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<String> get lastname =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  /// Get [SubQuery] of rows from the `books` table which
  /// reference this row.
  ///
  /// This returns a [SubQuery] of [Book] rows,
  /// where [Book.authorId]
  /// references [Author.authorId]
  /// in this row.
  SubQuery<(Expr<Book>,)> get books => $ForGeneratedCode
      .subqueryTable(_$Book._$table)
      .where((r) => r.authorId.equals(authorId));
}

extension ExpressionNullableAuthorExt on Expr<Author?> {
  Expr<int?> get authorId =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String?> get firstname =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<String?> get lastname =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  /// Get [SubQuery] of rows from the `books` table which
  /// reference this row.
  ///
  /// This returns a [SubQuery] of [Book] rows,
  /// where [Book.authorId]
  /// references [Author.authorId]
  /// in this row, if any.
  ///
  /// If this row is `NULL` the subquery is always be empty.
  SubQuery<(Expr<Book>,)> get books => $ForGeneratedCode
      .subqueryTable(_$Book._$table)
      .where((r) => r.authorId.equalsUnlessNull(authorId).asNotNull());

  /// Check if the row is not `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNotNull() => authorId.isNotNull();

  /// Check if the row is `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNull() => isNotNull().not();
}

extension InnerJoinAuthorBookExt on InnerJoin<(Expr<Author>,), (Expr<Book>,)> {
  /// Join using the `author` _foreign key_.
  ///
  /// This will match rows where [Author.authorId] = [Book.authorId].
  Query<(Expr<Author>, Expr<Book>)> usingAuthor() =>
      on((a, b) => a.authorId.equals(b.authorId));
}

extension LeftJoinAuthorBookExt on LeftJoin<(Expr<Author>,), (Expr<Book>,)> {
  /// Join using the `author` _foreign key_.
  ///
  /// This will match rows where [Author.authorId] = [Book.authorId].
  Query<(Expr<Author>, Expr<Book?>)> usingAuthor() =>
      on((a, b) => a.authorId.equals(b.authorId));
}

extension RightJoinAuthorBookExt on RightJoin<(Expr<Author>,), (Expr<Book>,)> {
  /// Join using the `author` _foreign key_.
  ///
  /// This will match rows where [Author.authorId] = [Book.authorId].
  Query<(Expr<Author?>, Expr<Book>)> usingAuthor() =>
      on((a, b) => a.authorId.equals(b.authorId));
}

final class _$Book extends Book {
  _$Book._(
    this.bookId,
    this.title,
    this.authorId,
    this.stock,
  );

  @override
  final int bookId;

  @override
  final String title;

  @override
  final int authorId;

  @override
  final int stock;

  static const _$table = (
    tableName: 'books',
    columns: <String>['bookId', 'title', 'authorId', 'stock'],
    columnInfo: <({
      ColumnType type,
      bool isNotNull,
      Object? defaultValue,
      bool autoIncrement,
      List<SqlOverride> overrides,
    })>[
      (
        type: $ForGeneratedCode.integer,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: true,
        overrides: <SqlOverride>[],
      ),
      (
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: <SqlOverride>[],
      ),
      (
        type: $ForGeneratedCode.integer,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: <SqlOverride>[],
      ),
      (
        type: $ForGeneratedCode.integer,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: <SqlOverride>[],
      )
    ],
    primaryKey: <String>['bookId'],
    unique: <List<String>>[],
    foreignKeys: <({
      String name,
      List<String> columns,
      String referencedTable,
      List<String> referencedColumns,
    })>[
      (
        name: 'author',
        columns: ['authorId'],
        referencedTable: 'authors',
        referencedColumns: ['authorId'],
      )
    ],
    readRow: _$Book._$fromDatabase,
  );

  static Book? _$fromDatabase(RowReader row) {
    final bookId = row.readInt();
    final title = row.readString();
    final authorId = row.readInt();
    final stock = row.readInt();
    if (bookId == null && title == null && authorId == null && stock == null) {
      return null;
    }
    return _$Book._(bookId!, title!, authorId!, stock!);
  }

  @override
  String toString() =>
      'Book(bookId: "$bookId", title: "$title", authorId: "$authorId", stock: "$stock")';
}

/// Extension methods for table defined in [Book].
extension TableBookExt on Table<Book> {
  /// Insert row into the `books` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<Book> insert({
    Expr<int>? bookId,
    required Expr<String> title,
    required Expr<int> authorId,
    required Expr<int> stock,
  }) =>
      $ForGeneratedCode.insertInto(
        table: this,
        values: [
          bookId,
          title,
          authorId,
          stock,
        ],
      );

  /// Delete a single row from the `books` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<Book> delete(int bookId) => $ForGeneratedCode.deleteSingle(
        byKey(bookId),
        _$Book._$table,
      );
}

/// Extension methods for building queries against the `books` table.
extension QueryBookExt on Query<(Expr<Book>,)> {
  /// Lookup a single row in `books` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<Book>,)> byKey(int bookId) =>
      where((book) => book.bookId.equalsValue(bookId)).first;

  /// Update all rows in the `books` table matching this [Query].
  ///
  /// The changes to be applied to each row matching this [Query] are
  /// defined using the [updateBuilder], which is given an [Expr]
  /// representation of the row being updated and a `set` function to
  /// specify which fields should be updated. The result of the `set`
  /// function should always be returned from the `updateBuilder`.
  ///
  /// Returns an [Update] statement on which `.execute()` must be called
  /// for the rows to be updated.
  ///
  /// **Example:** decrementing `1` from the `value` field for each row
  /// where `value > 0`.
  /// ```dart
  /// await db.mytable
  ///   .where((row) => row.value > toExpr(0))
  ///   .update((row, set) => set(
  ///     value: row.value - toExpr(1),
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  Update<Book> update(
          UpdateSet<Book> Function(
            Expr<Book> book,
            UpdateSet<Book> Function({
              Expr<int> bookId,
              Expr<String> title,
              Expr<int> authorId,
              Expr<int> stock,
            }) set,
          ) updateBuilder) =>
      $ForGeneratedCode.update<Book>(
        this,
        _$Book._$table,
        (book) => updateBuilder(
          book,
          ({
            Expr<int>? bookId,
            Expr<String>? title,
            Expr<int>? authorId,
            Expr<int>? stock,
          }) =>
              $ForGeneratedCode.buildUpdate<Book>([
            bookId,
            title,
            authorId,
            stock,
          ]),
        ),
      );

  /// Delete all rows in the `books` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<Book> delete() => $ForGeneratedCode.delete(this, _$Book._$table);
}

/// Extension methods for building point queries against the `books` table.
extension QuerySingleBookExt on QuerySingle<(Expr<Book>,)> {
  /// Update the row (if any) in the `books` table matching this
  /// [QuerySingle].
  ///
  /// The changes to be applied to the row matching this [QuerySingle] are
  /// defined using the [updateBuilder], which is given an [Expr]
  /// representation of the row being updated and a `set` function to
  /// specify which fields should be updated. The result of the `set`
  /// function should always be returned from the `updateBuilder`.
  ///
  /// Returns an [UpdateSingle] statement on which `.execute()` must be
  /// called for the row to be updated. The resulting statement will
  /// **not** fail, if there are no rows matching this query exists.
  ///
  /// **Example:** decrementing `1` from the `value` field the row with
  /// `id = 1`.
  /// ```dart
  /// await db.mytable
  ///   .byKey(1)
  ///   .update((row, set) => set(
  ///     value: row.value - toExpr(1),
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  UpdateSingle<Book> update(
          UpdateSet<Book> Function(
            Expr<Book> book,
            UpdateSet<Book> Function({
              Expr<int> bookId,
              Expr<String> title,
              Expr<int> authorId,
              Expr<int> stock,
            }) set,
          ) updateBuilder) =>
      $ForGeneratedCode.updateSingle<Book>(
        this,
        _$Book._$table,
        (book) => updateBuilder(
          book,
          ({
            Expr<int>? bookId,
            Expr<String>? title,
            Expr<int>? authorId,
            Expr<int>? stock,
          }) =>
              $ForGeneratedCode.buildUpdate<Book>([
            bookId,
            title,
            authorId,
            stock,
          ]),
        ),
      );

  /// Delete the row (if any) in the `books` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<Book> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$Book._$table);
}

/// Extension methods for expressions on a row in the `books` table.
extension ExpressionBookExt on Expr<Book> {
  Expr<int> get bookId =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String> get title =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<int> get authorId =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.integer);

  Expr<int> get stock =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.integer);

  /// Do a subquery lookup of the row from table
  /// `authors` referenced in
  /// [authorId].
  ///
  /// The gets the row from table `authors` where
  /// [Author.authorId]
  /// is equal to [authorId].
  Expr<Author> get author => $ForGeneratedCode
      .subqueryTable(_$Author._$table)
      .where((r) => r.authorId.equals(authorId))
      .first
      .asNotNull();
}

extension ExpressionNullableBookExt on Expr<Book?> {
  Expr<int?> get bookId =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String?> get title =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<int?> get authorId =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.integer);

  Expr<int?> get stock =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.integer);

  /// Do a subquery lookup of the row from table
  /// `authors` referenced in
  /// [authorId].
  ///
  /// The gets the row from table `authors` where
  /// [Author.authorId]
  /// is equal to [authorId], if any.
  ///
  /// If this row is `NULL` the subquery is always return `NULL`.
  Expr<Author?> get author => $ForGeneratedCode
      .subqueryTable(_$Author._$table)
      .where((r) => r.authorId.equalsUnlessNull(authorId).asNotNull())
      .first;

  /// Check if the row is not `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNotNull() => bookId.isNotNull();

  /// Check if the row is `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNull() => isNotNull().not();
}

extension InnerJoinBookAuthorExt on InnerJoin<(Expr<Book>,), (Expr<Author>,)> {
  /// Join using the `author` _foreign key_.
  ///
  /// This will match rows where [Book.authorId] = [Author.authorId].
  Query<(Expr<Book>, Expr<Author>)> usingAuthor() =>
      on((a, b) => b.authorId.equals(a.authorId));
}

extension LeftJoinBookAuthorExt on LeftJoin<(Expr<Book>,), (Expr<Author>,)> {
  /// Join using the `author` _foreign key_.
  ///
  /// This will match rows where [Book.authorId] = [Author.authorId].
  Query<(Expr<Book>, Expr<Author?>)> usingAuthor() =>
      on((a, b) => b.authorId.equals(a.authorId));
}

extension RightJoinBookAuthorExt on RightJoin<(Expr<Book>,), (Expr<Author>,)> {
  /// Join using the `author` _foreign key_.
  ///
  /// This will match rows where [Book.authorId] = [Author.authorId].
  Query<(Expr<Book?>, Expr<Author>)> usingAuthor() =>
      on((a, b) => b.authorId.equals(a.authorId));
}

/// Extension methods for assertions on [Author] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension AuthorChecks on Subject<Author> {
  /// Create assertions on [Author.authorId].
  Subject<int> get authorId => has((m) => m.authorId, 'authorId');

  /// Create assertions on [Author.firstname].
  Subject<String> get firstname => has((m) => m.firstname, 'firstname');

  /// Create assertions on [Author.lastname].
  Subject<String> get lastname => has((m) => m.lastname, 'lastname');
}

/// Extension methods for assertions on [Book] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension BookChecks on Subject<Book> {
  /// Create assertions on [Book.bookId].
  Subject<int> get bookId => has((m) => m.bookId, 'bookId');

  /// Create assertions on [Book.title].
  Subject<String> get title => has((m) => m.title, 'title');

  /// Create assertions on [Book.authorId].
  Subject<int> get authorId => has((m) => m.authorId, 'authorId');

  /// Create assertions on [Book.stock].
  Subject<int> get stock => has((m) => m.stock, 'stock');
}
