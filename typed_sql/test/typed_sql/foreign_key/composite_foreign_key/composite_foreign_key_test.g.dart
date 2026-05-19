// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'composite_foreign_key_test.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

/// Extension methods for a [Database] operating on [TestDatabase].
extension TestDatabaseSchema on Database<TestDatabase> {
  static final _$tables = [_$Author._$table, _$Book._$table];

  Table<Author> get authors =>
      $ForGeneratedCode.declareTable(this, _$Author._$table);

  Table<Book> get books => $ForGeneratedCode.declareTable(this, _$Book._$table);

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
  Future<void> createTables() async =>
      $ForGeneratedCode.createTables(context: this, tables: _$tables);
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
String createTestDatabaseTables(SqlDialect dialect) => $ForGeneratedCode
    .createTableSchema(dialect: dialect, tables: TestDatabaseSchema._$tables);

final class _$Author extends Author {
  _$Author._(this.firstName, this.lastName);

  @override
  final String firstName;

  @override
  final String lastName;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'authors',
    columns: <String>['firstName', 'lastName'],
    columnInfo: [
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [
          (
            dialect: 'mysql',
            columnType: 'VARCHAR(255)',
            defaultValue: null,
            collation: null,
          ),
        ],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [
          (
            dialect: 'mysql',
            columnType: 'VARCHAR(255)',
            defaultValue: null,
            collation: null,
          ),
        ],
      ),
    ],
    primaryKey: <String>['firstName', 'lastName'],
    unique: <List<String>>[],
    foreignKeys: [],
    readRow: _$Author._$fromDatabase,
  );

  static Author? _$fromDatabase(RowReader row) {
    final firstName = row.readString();
    final lastName = row.readString();
    if (firstName == null && lastName == null) {
      return null;
    }
    return _$Author._(firstName!, lastName!);
  }

  @override
  String toString() => 'Author(firstName: "$firstName", lastName: "$lastName")';
}

/// Extension methods for table defined in [Author].
extension TableAuthorExt on Table<Author> {
  /// Insert row into the `authors` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<Author> insert({
    required Expr<String> firstName,
    required Expr<String> lastName,
  }) =>
      $ForGeneratedCode.insertInto(table: this, values: [firstName, lastName]);

  /// Insert row into the `authors` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<Author> insertValue({
    required String firstName,
    required String lastName,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [firstName.asExpr, lastName.asExpr],
  );

  /// Bulk insert rows into the `authors` table.
  ///
  /// This method takes an `Iterable<T>` and requires that you provide
  /// a _mapping function_ from `T` to each column to be inserted.
  ///
  /// If a mapping function is omitted, the _default value_ will be
  /// inserted, or `NULL` if column is nullable and as no default value.
  /// To explicitely insert `NULL`, use a _mapping function_ that maps
  /// `T` to `null`.
  ///
  /// > [!NOTE]
  /// > This method aims utilize database specific bulk insertion logic
  /// > to ensure good performance. Database adapters may pipeline bulk
  /// > insertions through multiple statements inside a transaction.
  ///
  /// Returns a [Insert] statement on which `.execute` must be
  /// called for the rows to be inserted.
  Insert<Author> insertValuesMapped<T>(
    Iterable<T> rows, {
    required String Function(T row) firstName,
    required String Function(T row) lastName,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mapping: {'firstName': firstName, 'lastName': lastName},
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
  DeleteSingle<Author> delete(String firstName, String lastName) =>
      $ForGeneratedCode.deleteSingle(
        byKey(firstName, lastName),
        _$Author._$table,
      );
}

/// Extension methods for building queries against the `authors` table.
extension QueryAuthorExt on Query<(Expr<Author>,)> {
  /// Lookup a single row in `authors` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<Author>,)> byKey(String firstName, String lastName) =>
      where(
        (author) =>
            author.firstName.equalsValue(firstName) &
            author.lastName.equalsValue(lastName),
      ).first;

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
        Expr<String> firstName,
        Expr<String> lastName,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<Author>(
    this,
    _$Author._$table,
    (author) => updateBuilder(
      author,
      ({Expr<String>? firstName, Expr<String>? lastName}) =>
          $ForGeneratedCode.buildUpdate<Author>([firstName, lastName]),
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
        Expr<String> firstName,
        Expr<String> lastName,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<Author>(
    this,
    _$Author._$table,
    (author) => updateBuilder(
      author,
      ({Expr<String>? firstName, Expr<String>? lastName}) =>
          $ForGeneratedCode.buildUpdate<Author>([firstName, lastName]),
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
  Expr<String> get firstName =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.text);

  Expr<String> get lastName =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  /// Get [SubQuery] of rows from the `books` table which
  /// reference this row.
  ///
  /// This returns a [SubQuery] of [Book] rows,
  /// where [Book.authorFirstName], [Book.authorLastName]
  /// references [Author.firstName], [Author.lastName]
  /// in this row.
  SubQuery<(Expr<Book>,)> get books => $ForGeneratedCode
      .subqueryTable(_$Book._$table)
      .where(
        (r) =>
            r.authorFirstName.equals(firstName) &
            r.authorLastName.equals(lastName),
      );
}

extension ExpressionNullableAuthorExt on Expr<Author?> {
  Expr<String?> get firstName =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.text);

  Expr<String?> get lastName =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  /// Get [SubQuery] of rows from the `books` table which
  /// reference this row.
  ///
  /// This returns a [SubQuery] of [Book] rows,
  /// where [Book.authorFirstName], [Book.authorLastName]
  /// references [Author.firstName], [Author.lastName]
  /// in this row, if any.
  ///
  /// If this row is `NULL` the subquery is always be empty.
  SubQuery<(Expr<Book>,)> get books => $ForGeneratedCode
      .subqueryTable(_$Book._$table)
      .where(
        (r) =>
            r.authorFirstName.equalsUnlessNull(firstName).asNotNull() &
            r.authorLastName.equalsUnlessNull(lastName).asNotNull(),
      );

  /// Check if the row is not `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNotNull() => firstName.isNotNull() & lastName.isNotNull();

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
  /// This will match rows where [Author.firstName] = [Book.authorFirstName] and [Author.lastName] = [Book.authorLastName].
  Query<(Expr<Author>, Expr<Book>)> usingAuthor() => on(
    (a, b) =>
        a.firstName.equals(b.authorFirstName) &
        a.lastName.equals(b.authorLastName),
  );
}

extension LeftJoinAuthorBookExt on LeftJoin<(Expr<Author>,), (Expr<Book>,)> {
  /// Join using the `author` _foreign key_.
  ///
  /// This will match rows where [Author.firstName] = [Book.authorFirstName] and [Author.lastName] = [Book.authorLastName].
  Query<(Expr<Author>, Expr<Book?>)> usingAuthor() => on(
    (a, b) =>
        a.firstName.equals(b.authorFirstName) &
        a.lastName.equals(b.authorLastName),
  );
}

extension RightJoinAuthorBookExt on RightJoin<(Expr<Author>,), (Expr<Book>,)> {
  /// Join using the `author` _foreign key_.
  ///
  /// This will match rows where [Author.firstName] = [Book.authorFirstName] and [Author.lastName] = [Book.authorLastName].
  Query<(Expr<Author?>, Expr<Book>)> usingAuthor() => on(
    (a, b) =>
        a.firstName.equals(b.authorFirstName) &
        a.lastName.equals(b.authorLastName),
  );
}

/// `Table<Author>` conflict targets for use with `.onConflict`.
enum AuthorConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `firstName`, `lastName`.
  primaryKey(['firstName', 'lastName']);

  const AuthorConflict(this._fields);

  final List<String> _fields;
}

extension InsertAuthorExt on Insert<Author> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((author, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflict<Author> onConflict(AuthorConflict target) =>
      $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictAuthorExt on InsertOnConflict<Author> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `author` an [Expr] representing the existing row in
  ///     the database,
  ///   * `excluded` an [Expr] representing the row to be inserted in the
  ///     database, and,
  ///   * `set` a function to specify which fields should be updated and
  ///     build the [UpdateSet].
  ///
  /// The result of the `set` function should always be immediately
  /// returned from the [updateBuilder].
  ///
  /// **Example:** Insert a counter with `count = 2` or increment the
  /// existing row, if a `PRIMARY KEY` conflict occurs.
  /// ```dart
  /// await db.counters.insertValue(
  ///     name: 'my-counter', // primary key
  ///     count: 2,
  ///   )
  ///   .onConflict(.primaryKey)
  ///   .update((counter, excluded, set) => set(
  ///     count: counter.count + excluded.count,
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// This is equivalent to
  /// `INSERT ... ON CONFLICT (...) UPDATE SET ...` in SQL.
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  ///
  /// [1]: https://www.sqlite.org/lang_upsert.html
  Upsert<Author> update(
    UpdateSet<Author> Function(
      Expr<Author> author,
      Expr<Author> excluded,
      UpdateSet<Author> Function({
        Expr<String> firstName,
        Expr<String> lastName,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<Author>(
    this,
    (author, excluded) => updateBuilder(
      author,
      excluded,
      ({Expr<String>? firstName, Expr<String>? lastName}) =>
          $ForGeneratedCode.buildUpdate<Author>([firstName, lastName]),
    ),
  );
}

extension InsertSingleAuthorExt on InsertSingle<Author> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((author, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflictSingle<Author> onConflict(AuthorConflict target) =>
      $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleAuthorExt on InsertOnConflictSingle<Author> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `author` an [Expr] representing the existing row in
  ///     the database,
  ///   * `excluded` an [Expr] representing the row to be inserted in the
  ///     database, and,
  ///   * `set` a function to specify which fields should be updated and
  ///     build the [UpdateSet].
  ///
  /// The result of the `set` function should always be immediately
  /// returned from the [updateBuilder].
  ///
  /// **Example:** Insert a counter with `count = 2` or increment the
  /// existing row, if a `PRIMARY KEY` conflict occurs.
  /// ```dart
  /// await db.counters.insertValue(
  ///     name: 'my-counter', // primary key
  ///     count: 2,
  ///   )
  ///   .onConflict(.primaryKey)
  ///   .update((counter, excluded, set) => set(
  ///     count: counter.count + excluded.count,
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// This is equivalent to
  /// `INSERT ... ON CONFLICT (...) UPDATE SET ...` in SQL.
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  ///
  /// [1]: https://www.sqlite.org/lang_upsert.html
  UpsertSingle<Author> update(
    UpdateSet<Author> Function(
      Expr<Author> author,
      Expr<Author> excluded,
      UpdateSet<Author> Function({
        Expr<String> firstName,
        Expr<String> lastName,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<Author>(
    this,
    (author, excluded) => updateBuilder(
      author,
      excluded,
      ({Expr<String>? firstName, Expr<String>? lastName}) =>
          $ForGeneratedCode.buildUpdate<Author>([firstName, lastName]),
    ),
  );
}

final class _$Book extends Book {
  _$Book._(
    this.bookId,
    this.title,
    this.authorFirstName,
    this.authorLastName,
    this.stock,
  );

  @override
  final int bookId;

  @override
  final String title;

  @override
  final String authorFirstName;

  @override
  final String authorLastName;

  @override
  final int stock;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'books',
    columns: <String>[
      'bookId',
      'title',
      'authorFirstName',
      'authorLastName',
      'stock',
    ],
    columnInfo: [
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.integer,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: true,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [
          (
            dialect: 'mysql',
            columnType: 'VARCHAR(255)',
            defaultValue: null,
            collation: null,
          ),
        ],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [
          (
            dialect: 'mysql',
            columnType: 'VARCHAR(255)',
            defaultValue: null,
            collation: null,
          ),
        ],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.integer,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
    ],
    primaryKey: <String>['bookId'],
    unique: <List<String>>[],
    foreignKeys: [
      $ForGeneratedCode.foreignKeyDefinition(
        name: 'author',
        columns: ['authorFirstName', 'authorLastName'],
        referencedTable: 'authors',
        referencedColumns: ['firstName', 'lastName'],
        onDelete: .noAction,
        onUpdate: .noAction,
      ),
    ],
    readRow: _$Book._$fromDatabase,
  );

  static Book? _$fromDatabase(RowReader row) {
    final bookId = row.readInt();
    final title = row.readString();
    final authorFirstName = row.readString();
    final authorLastName = row.readString();
    final stock = row.readInt();
    if (bookId == null &&
        title == null &&
        authorFirstName == null &&
        authorLastName == null &&
        stock == null) {
      return null;
    }
    return _$Book._(bookId!, title!, authorFirstName!, authorLastName!, stock!);
  }

  @override
  String toString() =>
      'Book(bookId: "$bookId", title: "$title", authorFirstName: "$authorFirstName", authorLastName: "$authorLastName", stock: "$stock")';
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
    required Expr<String> authorFirstName,
    required Expr<String> authorLastName,
    required Expr<int> stock,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [bookId, title, authorFirstName, authorLastName, stock],
  );

  /// Insert row into the `books` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<Book> insertValue({
    int? bookId,
    required String title,
    required String authorFirstName,
    required String authorLastName,
    required int stock,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [
      bookId?.asExpr,
      title.asExpr,
      authorFirstName.asExpr,
      authorLastName.asExpr,
      stock.asExpr,
    ],
  );

  /// Bulk insert rows into the `books` table.
  ///
  /// This method takes an `Iterable<T>` and requires that you provide
  /// a _mapping function_ from `T` to each column to be inserted.
  ///
  /// If a mapping function is omitted, the _default value_ will be
  /// inserted, or `NULL` if column is nullable and as no default value.
  /// To explicitely insert `NULL`, use a _mapping function_ that maps
  /// `T` to `null`.
  ///
  /// > [!NOTE]
  /// > This method aims utilize database specific bulk insertion logic
  /// > to ensure good performance. Database adapters may pipeline bulk
  /// > insertions through multiple statements inside a transaction.
  ///
  /// Returns a [Insert] statement on which `.execute` must be
  /// called for the rows to be inserted.
  Insert<Book> insertValuesMapped<T>(
    Iterable<T> rows, {
    int Function(T row)? bookId,
    required String Function(T row) title,
    required String Function(T row) authorFirstName,
    required String Function(T row) authorLastName,
    required int Function(T row) stock,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mapping: {
      'bookId': bookId,
      'title': title,
      'authorFirstName': authorFirstName,
      'authorLastName': authorLastName,
      'stock': stock,
    },
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
  DeleteSingle<Book> delete(int bookId) =>
      $ForGeneratedCode.deleteSingle(byKey(bookId), _$Book._$table);
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
        Expr<String> authorFirstName,
        Expr<String> authorLastName,
        Expr<int> stock,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<Book>(
    this,
    _$Book._$table,
    (book) => updateBuilder(
      book,
      ({
        Expr<int>? bookId,
        Expr<String>? title,
        Expr<String>? authorFirstName,
        Expr<String>? authorLastName,
        Expr<int>? stock,
      }) => $ForGeneratedCode.buildUpdate<Book>([
        bookId,
        title,
        authorFirstName,
        authorLastName,
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
        Expr<String> authorFirstName,
        Expr<String> authorLastName,
        Expr<int> stock,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<Book>(
    this,
    _$Book._$table,
    (book) => updateBuilder(
      book,
      ({
        Expr<int>? bookId,
        Expr<String>? title,
        Expr<String>? authorFirstName,
        Expr<String>? authorLastName,
        Expr<int>? stock,
      }) => $ForGeneratedCode.buildUpdate<Book>([
        bookId,
        title,
        authorFirstName,
        authorLastName,
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

  Expr<String> get authorFirstName =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  Expr<String> get authorLastName =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.text);

  Expr<int> get stock =>
      $ForGeneratedCode.field(this, 4, $ForGeneratedCode.integer);

  /// Do a subquery lookup of the row from table
  /// `authors` referenced in
  /// [authorFirstName], [authorLastName].
  ///
  /// The gets the row from table `authors` where
  /// [Author.firstName], [Author.lastName]
  /// is equal to [authorFirstName], [authorLastName].
  Expr<Author> get author => $ForGeneratedCode
      .subqueryTable(_$Author._$table)
      .where(
        (r) =>
            r.firstName.equals(authorFirstName) &
            r.lastName.equals(authorLastName),
      )
      .first
      .asNotNull();
}

extension ExpressionNullableBookExt on Expr<Book?> {
  Expr<int?> get bookId =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String?> get title =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<String?> get authorFirstName =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  Expr<String?> get authorLastName =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.text);

  Expr<int?> get stock =>
      $ForGeneratedCode.field(this, 4, $ForGeneratedCode.integer);

  /// Do a subquery lookup of the row from table
  /// `authors` referenced in
  /// [authorFirstName], [authorLastName].
  ///
  /// The gets the row from table `authors` where
  /// [Author.firstName], [Author.lastName]
  /// is equal to [authorFirstName], [authorLastName], if any.
  ///
  /// If this row is `NULL` the subquery is always return `NULL`.
  Expr<Author?> get author => $ForGeneratedCode
      .subqueryTable(_$Author._$table)
      .where(
        (r) =>
            r.firstName.equalsUnlessNull(authorFirstName).asNotNull() &
            r.lastName.equalsUnlessNull(authorLastName).asNotNull(),
      )
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
  /// This will match rows where [Book.authorFirstName] = [Author.firstName] and [Book.authorLastName] = [Author.lastName].
  Query<(Expr<Book>, Expr<Author>)> usingAuthor() => on(
    (a, b) =>
        b.firstName.equals(a.authorFirstName) &
        b.lastName.equals(a.authorLastName),
  );
}

extension LeftJoinBookAuthorExt on LeftJoin<(Expr<Book>,), (Expr<Author>,)> {
  /// Join using the `author` _foreign key_.
  ///
  /// This will match rows where [Book.authorFirstName] = [Author.firstName] and [Book.authorLastName] = [Author.lastName].
  Query<(Expr<Book>, Expr<Author?>)> usingAuthor() => on(
    (a, b) =>
        b.firstName.equals(a.authorFirstName) &
        b.lastName.equals(a.authorLastName),
  );
}

extension RightJoinBookAuthorExt on RightJoin<(Expr<Book>,), (Expr<Author>,)> {
  /// Join using the `author` _foreign key_.
  ///
  /// This will match rows where [Book.authorFirstName] = [Author.firstName] and [Book.authorLastName] = [Author.lastName].
  Query<(Expr<Book?>, Expr<Author>)> usingAuthor() => on(
    (a, b) =>
        b.firstName.equals(a.authorFirstName) &
        b.lastName.equals(a.authorLastName),
  );
}

/// `Table<Book>` conflict targets for use with `.onConflict`.
enum BookConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `bookId`.
  primaryKey(['bookId']);

  const BookConflict(this._fields);

  final List<String> _fields;
}

extension InsertBookExt on Insert<Book> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((book, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflict<Book> onConflict(BookConflict target) =>
      $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictBookExt on InsertOnConflict<Book> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `book` an [Expr] representing the existing row in
  ///     the database,
  ///   * `excluded` an [Expr] representing the row to be inserted in the
  ///     database, and,
  ///   * `set` a function to specify which fields should be updated and
  ///     build the [UpdateSet].
  ///
  /// The result of the `set` function should always be immediately
  /// returned from the [updateBuilder].
  ///
  /// **Example:** Insert a counter with `count = 2` or increment the
  /// existing row, if a `PRIMARY KEY` conflict occurs.
  /// ```dart
  /// await db.counters.insertValue(
  ///     name: 'my-counter', // primary key
  ///     count: 2,
  ///   )
  ///   .onConflict(.primaryKey)
  ///   .update((counter, excluded, set) => set(
  ///     count: counter.count + excluded.count,
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// This is equivalent to
  /// `INSERT ... ON CONFLICT (...) UPDATE SET ...` in SQL.
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  ///
  /// [1]: https://www.sqlite.org/lang_upsert.html
  Upsert<Book> update(
    UpdateSet<Book> Function(
      Expr<Book> book,
      Expr<Book> excluded,
      UpdateSet<Book> Function({
        Expr<int> bookId,
        Expr<String> title,
        Expr<String> authorFirstName,
        Expr<String> authorLastName,
        Expr<int> stock,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<Book>(
    this,
    (book, excluded) => updateBuilder(
      book,
      excluded,
      ({
        Expr<int>? bookId,
        Expr<String>? title,
        Expr<String>? authorFirstName,
        Expr<String>? authorLastName,
        Expr<int>? stock,
      }) => $ForGeneratedCode.buildUpdate<Book>([
        bookId,
        title,
        authorFirstName,
        authorLastName,
        stock,
      ]),
    ),
  );
}

extension InsertSingleBookExt on InsertSingle<Book> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((book, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflictSingle<Book> onConflict(BookConflict target) =>
      $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleBookExt on InsertOnConflictSingle<Book> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `book` an [Expr] representing the existing row in
  ///     the database,
  ///   * `excluded` an [Expr] representing the row to be inserted in the
  ///     database, and,
  ///   * `set` a function to specify which fields should be updated and
  ///     build the [UpdateSet].
  ///
  /// The result of the `set` function should always be immediately
  /// returned from the [updateBuilder].
  ///
  /// **Example:** Insert a counter with `count = 2` or increment the
  /// existing row, if a `PRIMARY KEY` conflict occurs.
  /// ```dart
  /// await db.counters.insertValue(
  ///     name: 'my-counter', // primary key
  ///     count: 2,
  ///   )
  ///   .onConflict(.primaryKey)
  ///   .update((counter, excluded, set) => set(
  ///     count: counter.count + excluded.count,
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// This is equivalent to
  /// `INSERT ... ON CONFLICT (...) UPDATE SET ...` in SQL.
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  ///
  /// [1]: https://www.sqlite.org/lang_upsert.html
  UpsertSingle<Book> update(
    UpdateSet<Book> Function(
      Expr<Book> book,
      Expr<Book> excluded,
      UpdateSet<Book> Function({
        Expr<int> bookId,
        Expr<String> title,
        Expr<String> authorFirstName,
        Expr<String> authorLastName,
        Expr<int> stock,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<Book>(
    this,
    (book, excluded) => updateBuilder(
      book,
      excluded,
      ({
        Expr<int>? bookId,
        Expr<String>? title,
        Expr<String>? authorFirstName,
        Expr<String>? authorLastName,
        Expr<int>? stock,
      }) => $ForGeneratedCode.buildUpdate<Book>([
        bookId,
        title,
        authorFirstName,
        authorLastName,
        stock,
      ]),
    ),
  );
}

/// Extension methods for assertions on [Author] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension AuthorChecks on Subject<Author> {
  /// Create assertions on [Author.firstName].
  Subject<String> get firstName => has((m) => m.firstName, 'firstName');

  /// Create assertions on [Author.lastName].
  Subject<String> get lastName => has((m) => m.lastName, 'lastName');
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

  /// Create assertions on [Book.authorFirstName].
  Subject<String> get authorFirstName =>
      has((m) => m.authorFirstName, 'authorFirstName');

  /// Create assertions on [Book.authorLastName].
  Subject<String> get authorLastName =>
      has((m) => m.authorLastName, 'authorLastName');

  /// Create assertions on [Book.stock].
  Subject<int> get stock => has((m) => m.stock, 'stock');
}
