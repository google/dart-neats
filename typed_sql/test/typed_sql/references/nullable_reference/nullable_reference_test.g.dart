// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nullable_reference_test.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

/// Extension methods for a [Database] operating on [TestDatabase].
extension TestDatabaseSchema on Database<TestDatabase> {
  static const _$tables = [_$Author._$table, _$Book._$table];

  Table<Author> get authors => ExposedForCodeGen.declareTable(
        this,
        _$Author._$table,
      );

  Table<Book> get books => ExposedForCodeGen.declareTable(
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
  Future<void> createTables() async => ExposedForCodeGen.createTables(
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
    ExposedForCodeGen.createTableSchema(
      dialect: dialect,
      tables: TestDatabaseSchema._$tables,
    );

final class _$Author extends Author {
  _$Author._(
    this.authorId,
    this.name,
    this.favoriteBookId,
  );

  @override
  final int authorId;

  @override
  final String name;

  @override
  final int? favoriteBookId;

  static const _$table = (
    tableName: 'authors',
    columns: <String>['authorId', 'name', 'favoriteBookId'],
    columnInfo: <({
      ColumnType type,
      bool isNotNull,
      Object? defaultValue,
      bool autoIncrement,
    })>[
      (
        type: ExposedForCodeGen.integer,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: true,
      ),
      (
        type: ExposedForCodeGen.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
      ),
      (
        type: ExposedForCodeGen.integer,
        isNotNull: false,
        defaultValue: null,
        autoIncrement: false,
      )
    ],
    primaryKey: <String>['authorId'],
    unique: <List<String>>[],
    foreignKeys: <({
      String name,
      List<String> columns,
      String referencedTable,
      List<String> referencedColumns,
    })>[
      (
        name: 'favoriteBook',
        columns: ['favoriteBookId'],
        referencedTable: 'books',
        referencedColumns: ['bookId'],
      )
    ],
    readModel: _$Author._$fromDatabase,
  );

  static Author? _$fromDatabase(RowReader row) {
    final authorId = row.readInt();
    final name = row.readString();
    final favoriteBookId = row.readInt();
    if (authorId == null && name == null && favoriteBookId == null) {
      return null;
    }
    return _$Author._(authorId!, name!, favoriteBookId);
  }

  @override
  String toString() =>
      'Author(authorId: "$authorId", name: "$name", favoriteBookId: "$favoriteBookId")';
}

/// Extension methods for table defined in [Author].
extension TableAuthorExt on Table<Author> {
  /// Insert row into the `authors` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<Author> insert({
    Expr<int>? authorId,
    required Expr<String> name,
    Expr<int?>? favoriteBookId,
  }) =>
      ExposedForCodeGen.insertInto(
        table: this,
        values: [
          authorId,
          name,
          favoriteBookId,
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
  /// `.where((_) => literal(true)).delete()`.
  DeleteSingle<Author> delete(int authorId) => ExposedForCodeGen.deleteSingle(
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
      where((author) => author.authorId.equalsLiteral(authorId)).first;

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
  ///   .where((row) => row.value > literal(0))
  ///   .update((row, set) => set(
  ///     value: row.value - literal(1),
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
              Expr<String> name,
              Expr<int?> favoriteBookId,
            }) set,
          ) updateBuilder) =>
      ExposedForCodeGen.update<Author>(
        this,
        _$Author._$table,
        (author) => updateBuilder(
          author,
          ({
            Expr<int>? authorId,
            Expr<String>? name,
            Expr<int?>? favoriteBookId,
          }) =>
              ExposedForCodeGen.buildUpdate<Author>([
            authorId,
            name,
            favoriteBookId,
          ]),
        ),
      );

  /// Delete all rows in the `authors` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<Author> delete() => ExposedForCodeGen.delete(this, _$Author._$table);
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
  ///     value: row.value - literal(1),
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
              Expr<String> name,
              Expr<int?> favoriteBookId,
            }) set,
          ) updateBuilder) =>
      ExposedForCodeGen.updateSingle<Author>(
        this,
        _$Author._$table,
        (author) => updateBuilder(
          author,
          ({
            Expr<int>? authorId,
            Expr<String>? name,
            Expr<int?>? favoriteBookId,
          }) =>
              ExposedForCodeGen.buildUpdate<Author>([
            authorId,
            name,
            favoriteBookId,
          ]),
        ),
      );

  /// Delete the row (if any) in the `authors` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<Author> delete() =>
      ExposedForCodeGen.deleteSingle(this, _$Author._$table);
}

/// Extension methods for expressions on a row in the `authors` table.
extension ExpressionAuthorExt on Expr<Author> {
  Expr<int> get authorId =>
      ExposedForCodeGen.field(this, 0, ExposedForCodeGen.integer);

  Expr<String> get name =>
      ExposedForCodeGen.field(this, 1, ExposedForCodeGen.text);

  Expr<int?> get favoriteBookId =>
      ExposedForCodeGen.field(this, 2, ExposedForCodeGen.integer);

  /// Get [SubQuery] of rows from the `books` table which
  /// reference [authorId] in the `authorId` field.
  ///
  /// This returns a [SubQuery] of [Book] rows,
  /// where [Book.authorId] is references
  /// [Author.authorId] in this row.
  SubQuery<(Expr<Book>,)> get books =>
      ExposedForCodeGen.subqueryTable(_$Book._$table)
          .where((r) => r.authorId.equals(authorId));

  /// Get [SubQuery] of rows from the `books` table which
  /// reference [authorId] in the `editorId` field.
  ///
  /// This returns a [SubQuery] of [Book] rows,
  /// where [Book.editorId] is references
  /// [Author.authorId] in this row.
  SubQuery<(Expr<Book>,)> get booksEditedBy =>
      ExposedForCodeGen.subqueryTable(_$Book._$table)
          .where((r) => r.editorId.equals(authorId));

  /// Do a subquery lookup of the row from table
  /// `books` referenced in [favoriteBookId].
  ///
  /// The gets the row from table `books` where
  /// [Book.bookId] is equal to
  /// [favoriteBookId], if any.
  Expr<Book?> get favoriteBook =>
      ExposedForCodeGen.subqueryTable(_$Book._$table)
          .where((r) => r.bookId.equals(favoriteBookId))
          .first;
}

extension ExpressionNullableAuthorExt on Expr<Author?> {
  Expr<int?> get authorId =>
      ExposedForCodeGen.field(this, 0, ExposedForCodeGen.integer);

  Expr<String?> get name =>
      ExposedForCodeGen.field(this, 1, ExposedForCodeGen.text);

  Expr<int?> get favoriteBookId =>
      ExposedForCodeGen.field(this, 2, ExposedForCodeGen.integer);

  /// Get [SubQuery] of rows from the `books` table which
  /// reference [authorId] in the `authorId` field.
  ///
  /// This returns a [SubQuery] of [Book] rows,
  /// where [Book.authorId] is references
  /// [Author.authorId] in this row, if any.
  ///
  /// If this row is `NULL` the subquery is always be empty.
  SubQuery<(Expr<Book>,)> get books =>
      ExposedForCodeGen.subqueryTable(_$Book._$table)
          .where((r) => authorId.isNotNull() & r.authorId.equals(authorId));

  /// Get [SubQuery] of rows from the `books` table which
  /// reference [authorId] in the `editorId` field.
  ///
  /// This returns a [SubQuery] of [Book] rows,
  /// where [Book.editorId] is references
  /// [Author.authorId] in this row, if any.
  ///
  /// If this row is `NULL` the subquery is always be empty.
  SubQuery<(Expr<Book>,)> get booksEditedBy =>
      ExposedForCodeGen.subqueryTable(_$Book._$table)
          .where((r) => authorId.isNotNull() & r.editorId.equals(authorId));

  /// Do a subquery lookup of the row from table
  /// `books` referenced in [favoriteBookId].
  ///
  /// The gets the row from table `books` where
  /// [Book.bookId] is equal to
  /// [favoriteBookId], if any.
  ///
  /// If this row is `NULL` the subquery is always return `NULL`.
  Expr<Book?> get favoriteBook =>
      ExposedForCodeGen.subqueryTable(_$Book._$table)
          .where((r) =>
              favoriteBookId.isNotNull() & r.bookId.equals(favoriteBookId))
          .first;

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

final class _$Book extends Book {
  _$Book._(
    this.bookId,
    this.title,
    this.authorId,
    this.editorId,
    this.stock,
  );

  @override
  final int bookId;

  @override
  final String title;

  @override
  final int authorId;

  @override
  final int? editorId;

  @override
  final int stock;

  static const _$table = (
    tableName: 'books',
    columns: <String>['bookId', 'title', 'authorId', 'editorId', 'stock'],
    columnInfo: <({
      ColumnType type,
      bool isNotNull,
      Object? defaultValue,
      bool autoIncrement,
    })>[
      (
        type: ExposedForCodeGen.integer,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: true,
      ),
      (
        type: ExposedForCodeGen.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
      ),
      (
        type: ExposedForCodeGen.integer,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
      ),
      (
        type: ExposedForCodeGen.integer,
        isNotNull: false,
        defaultValue: null,
        autoIncrement: false,
      ),
      (
        type: ExposedForCodeGen.integer,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
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
      ),
      (
        name: 'editor',
        columns: ['editorId'],
        referencedTable: 'authors',
        referencedColumns: ['authorId'],
      )
    ],
    readModel: _$Book._$fromDatabase,
  );

  static Book? _$fromDatabase(RowReader row) {
    final bookId = row.readInt();
    final title = row.readString();
    final authorId = row.readInt();
    final editorId = row.readInt();
    final stock = row.readInt();
    if (bookId == null &&
        title == null &&
        authorId == null &&
        editorId == null &&
        stock == null) {
      return null;
    }
    return _$Book._(bookId!, title!, authorId!, editorId, stock!);
  }

  @override
  String toString() =>
      'Book(bookId: "$bookId", title: "$title", authorId: "$authorId", editorId: "$editorId", stock: "$stock")';
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
    Expr<int?>? editorId,
    required Expr<int> stock,
  }) =>
      ExposedForCodeGen.insertInto(
        table: this,
        values: [
          bookId,
          title,
          authorId,
          editorId,
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
  /// `.where((_) => literal(true)).delete()`.
  DeleteSingle<Book> delete(int bookId) => ExposedForCodeGen.deleteSingle(
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
      where((book) => book.bookId.equalsLiteral(bookId)).first;

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
  ///   .where((row) => row.value > literal(0))
  ///   .update((row, set) => set(
  ///     value: row.value - literal(1),
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
              Expr<int?> editorId,
              Expr<int> stock,
            }) set,
          ) updateBuilder) =>
      ExposedForCodeGen.update<Book>(
        this,
        _$Book._$table,
        (book) => updateBuilder(
          book,
          ({
            Expr<int>? bookId,
            Expr<String>? title,
            Expr<int>? authorId,
            Expr<int?>? editorId,
            Expr<int>? stock,
          }) =>
              ExposedForCodeGen.buildUpdate<Book>([
            bookId,
            title,
            authorId,
            editorId,
            stock,
          ]),
        ),
      );

  /// Delete all rows in the `books` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<Book> delete() => ExposedForCodeGen.delete(this, _$Book._$table);
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
  ///     value: row.value - literal(1),
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
              Expr<int?> editorId,
              Expr<int> stock,
            }) set,
          ) updateBuilder) =>
      ExposedForCodeGen.updateSingle<Book>(
        this,
        _$Book._$table,
        (book) => updateBuilder(
          book,
          ({
            Expr<int>? bookId,
            Expr<String>? title,
            Expr<int>? authorId,
            Expr<int?>? editorId,
            Expr<int>? stock,
          }) =>
              ExposedForCodeGen.buildUpdate<Book>([
            bookId,
            title,
            authorId,
            editorId,
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
      ExposedForCodeGen.deleteSingle(this, _$Book._$table);
}

/// Extension methods for expressions on a row in the `books` table.
extension ExpressionBookExt on Expr<Book> {
  Expr<int> get bookId =>
      ExposedForCodeGen.field(this, 0, ExposedForCodeGen.integer);

  Expr<String> get title =>
      ExposedForCodeGen.field(this, 1, ExposedForCodeGen.text);

  Expr<int> get authorId =>
      ExposedForCodeGen.field(this, 2, ExposedForCodeGen.integer);

  /// Not all books have an editor.
  Expr<int?> get editorId =>
      ExposedForCodeGen.field(this, 3, ExposedForCodeGen.integer);

  Expr<int> get stock =>
      ExposedForCodeGen.field(this, 4, ExposedForCodeGen.integer);

  /// Get [SubQuery] of rows from the `authors` table which
  /// reference [bookId] in the `favoriteBookId` field.
  ///
  /// This returns a [SubQuery] of [Author] rows,
  /// where [Author.favoriteBookId] is references
  /// [Book.bookId] in this row.
  SubQuery<(Expr<Author>,)> get favoritedBy =>
      ExposedForCodeGen.subqueryTable(_$Author._$table)
          .where((r) => r.favoriteBookId.equals(bookId));

  /// Do a subquery lookup of the row from table
  /// `authors` referenced in [authorId].
  ///
  /// The gets the row from table `authors` where
  /// [Author.authorId] is equal to
  /// [authorId].
  Expr<Author> get author => ExposedForCodeGen.subqueryTable(_$Author._$table)
      .where((r) => r.authorId.equals(authorId))
      .first
      .assertNotNull();

  /// Do a subquery lookup of the row from table
  /// `authors` referenced in [editorId].
  ///
  /// The gets the row from table `authors` where
  /// [Author.authorId] is equal to
  /// [editorId], if any.
  Expr<Author?> get editor => ExposedForCodeGen.subqueryTable(_$Author._$table)
      .where((r) => r.authorId.equals(editorId))
      .first;
}

extension ExpressionNullableBookExt on Expr<Book?> {
  Expr<int?> get bookId =>
      ExposedForCodeGen.field(this, 0, ExposedForCodeGen.integer);

  Expr<String?> get title =>
      ExposedForCodeGen.field(this, 1, ExposedForCodeGen.text);

  Expr<int?> get authorId =>
      ExposedForCodeGen.field(this, 2, ExposedForCodeGen.integer);

  /// Not all books have an editor.
  Expr<int?> get editorId =>
      ExposedForCodeGen.field(this, 3, ExposedForCodeGen.integer);

  Expr<int?> get stock =>
      ExposedForCodeGen.field(this, 4, ExposedForCodeGen.integer);

  /// Get [SubQuery] of rows from the `authors` table which
  /// reference [bookId] in the `favoriteBookId` field.
  ///
  /// This returns a [SubQuery] of [Author] rows,
  /// where [Author.favoriteBookId] is references
  /// [Book.bookId] in this row, if any.
  ///
  /// If this row is `NULL` the subquery is always be empty.
  SubQuery<(Expr<Author>,)> get favoritedBy =>
      ExposedForCodeGen.subqueryTable(_$Author._$table)
          .where((r) => bookId.isNotNull() & r.favoriteBookId.equals(bookId));

  /// Do a subquery lookup of the row from table
  /// `authors` referenced in [authorId].
  ///
  /// The gets the row from table `authors` where
  /// [Author.authorId] is equal to
  /// [authorId], if any.
  ///
  /// If this row is `NULL` the subquery is always return `NULL`.
  Expr<Author?> get author => ExposedForCodeGen.subqueryTable(_$Author._$table)
      .where((r) => authorId.isNotNull() & r.authorId.equals(authorId))
      .first;

  /// Do a subquery lookup of the row from table
  /// `authors` referenced in [editorId].
  ///
  /// The gets the row from table `authors` where
  /// [Author.authorId] is equal to
  /// [editorId], if any.
  ///
  /// If this row is `NULL` the subquery is always return `NULL`.
  Expr<Author?> get editor => ExposedForCodeGen.subqueryTable(_$Author._$table)
      .where((r) => editorId.isNotNull() & r.authorId.equals(editorId))
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

/// Extension methods for assertions on [Author] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension AuthorChecks on Subject<Author> {
  /// Create assertions on [Author.authorId].
  Subject<int> get authorId => has((m) => m.authorId, 'authorId');

  /// Create assertions on [Author.name].
  Subject<String> get name => has((m) => m.name, 'name');

  /// Create assertions on [Author.favoriteBookId].
  Subject<int?> get favoriteBookId =>
      has((m) => m.favoriteBookId, 'favoriteBookId');
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

  /// Create assertions on [Book.editorId].
  Subject<int?> get editorId => has((m) => m.editorId, 'editorId');

  /// Create assertions on [Book.stock].
  Subject<int> get stock => has((m) => m.stock, 'stock');
}
