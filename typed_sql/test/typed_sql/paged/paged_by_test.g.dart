// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paged_by_test.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

/// Extension methods for a [Database] operating on [TestDatabase].
extension TestDatabaseSchema on Database<TestDatabase> {
  static final _$tables = [_$User._$table, _$Event._$table];

  Table<User> get users => $ForGeneratedCode.declareTable(this, _$User._$table);

  Table<Event> get events =>
      $ForGeneratedCode.declareTable(this, _$Event._$table);

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

final class _$User extends User {
  _$User._(
    this.userId,
    this.email,
    this.firstName,
    this.lastName,
    this.nickname,
  );

  @override
  final int userId;

  @override
  final String email;

  @override
  final String firstName;

  @override
  final String lastName;

  @override
  final String? nickname;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'users',
    columns: <String>['userId', 'email', 'firstName', 'lastName', 'nickname'],
    columnInfo: [
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.integer,
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
        isNotNull: false,
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
    primaryKey: <String>['userId'],
    unique: <List<String>>[
      ['email'],
      ['nickname'],
      ['firstName', 'lastName'],
    ],
    foreignKeys: [],
    indexes: [],
    readRow: _$User._$fromDatabase,
    fieldReaders: [
      (User r) => r.userId,
      (User r) => r.email,
      (User r) => r.firstName,
      (User r) => r.lastName,
      (User r) => r.nickname,
    ],
  );

  static User? _$fromDatabase(RowReader row) {
    final userId = row.readInt();
    final email = row.readString();
    final firstName = row.readString();
    final lastName = row.readString();
    final nickname = row.readString();
    if (userId == null &&
        email == null &&
        firstName == null &&
        lastName == null &&
        nickname == null) {
      return null;
    }
    return _$User._(userId!, email!, firstName!, lastName!, nickname);
  }

  @override
  String toString() =>
      'User(userId: "$userId", email: "$email", firstName: "$firstName", lastName: "$lastName", nickname: "$nickname")';
}

/// Extension methods for table defined in [User].
extension TableUserExt on Table<User> {
  /// Insert row into the `users` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<User> insert({
    required Expr<int> userId,
    required Expr<String> email,
    required Expr<String> firstName,
    required Expr<String> lastName,
    Expr<String?>? nickname,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [userId, email, firstName, lastName, nickname],
  );

  /// Insert row into the `users` table, or update the
  /// existing row if it conflicts with the _primary key_.
  ///
  /// This is a shorthand for calling `.insert(...)` followed by
  /// `.onConflict(.primaryKey)` and `.update(...)` to overwrite
  /// the fields `email`, `firstName`, `lastName`, `nickname`,
  /// with the values given, leaving the _primary key_ untouched.
  ///
  /// Returns an [UpsertSingle] statement on which `.execute()` must be
  /// called for the row to be inserted or updated.
  UpsertSingle<User> upsert({
    required Expr<int> userId,
    required Expr<String> email,
    required Expr<String> firstName,
    required Expr<String> lastName,
    Expr<String?>? nickname,
  }) =>
      insert(
            userId: userId,
            email: email,
            firstName: firstName,
            lastName: lastName,
            nickname: nickname,
          )
          .onConflict(.primaryKey)
          .update(
            (_, excluded, set) => set(
              email: excluded.email,
              firstName: excluded.firstName,
              lastName: excluded.lastName,
              nickname: excluded.nickname,
            ),
          );

  /// Insert row into the `users` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<User> insertValue({
    required int userId,
    required String email,
    required String firstName,
    required String lastName,
    String? nickname,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [
      userId.asExpr,
      email.asExpr,
      firstName.asExpr,
      lastName.asExpr,
      nickname.asExpr,
    ],
  );

  /// Insert row into the `users` table, or update the
  /// existing row if it conflicts with the _primary key_.
  ///
  /// This is a shorthand for calling `.insertValue(...)` followed by
  /// `.onConflict(.primaryKey)` and `.update(...)` to overwrite
  /// the fields `email`, `firstName`, `lastName`, `nickname`,
  /// with the values given, leaving the _primary key_ untouched.
  ///
  /// Returns an [UpsertSingle] statement on which `.execute()` must be
  /// called for the row to be inserted or updated.
  UpsertSingle<User> upsertValue({
    required int userId,
    required String email,
    required String firstName,
    required String lastName,
    String? nickname,
  }) =>
      insertValue(
            userId: userId,
            email: email,
            firstName: firstName,
            lastName: lastName,
            nickname: nickname,
          )
          .onConflict(.primaryKey)
          .update(
            (_, excluded, set) => set(
              email: excluded.email,
              firstName: excluded.firstName,
              lastName: excluded.lastName,
              nickname: excluded.nickname,
            ),
          );

  /// Bulk insert rows into the `users` table.
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
  Insert<User> insertValuesMapped<T>(
    Iterable<T> rows, {
    required int Function(T row) userId,
    required String Function(T row) email,
    required String Function(T row) firstName,
    required String Function(T row) lastName,
    String? Function(T row)? nickname,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mappings: [userId, email, firstName, lastName, nickname],
  );

  /// Delete a single row from the `users` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<User> delete(int userId) =>
      $ForGeneratedCode.deleteSingle(byKey(userId), _$User._$table);
}

/// Extension methods for building queries against the `users` table.
extension QueryUserExt on Query<(Expr<User>,)> {
  /// Lookup a single row in `users` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<User>,)> byKey(int userId) =>
      where((user) => user.userId.equalsValue(userId)).first;

  /// Update all rows in the `users` table matching this [Query].
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
  Update<User> update(
    UpdateSet<User> Function(
      Expr<User> user,
      UpdateSet<User> Function({
        Expr<int> userId,
        Expr<String> email,
        Expr<String> firstName,
        Expr<String> lastName,
        Expr<String?> nickname,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<User>(
    this,
    _$User._$table,
    (user) => updateBuilder(
      user,
      ({
        Expr<int>? userId,
        Expr<String>? email,
        Expr<String>? firstName,
        Expr<String>? lastName,
        Expr<String?>? nickname,
      }) => $ForGeneratedCode.buildUpdate<User>([
        userId,
        email,
        firstName,
        lastName,
        nickname,
      ]),
    ),
  );

  /// Lookup a single row in `users` table using the
  /// `email` field
  ///
  /// We know that lookup by the `email` field returns
  /// at-most one row because the [Unique] annotation in [User].
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<User>,)> byEmail(String email) =>
      where((user) => user.email.equalsValue(email)).first;

  /// Lookup a single row in `users` table using the
  /// `nickname` field
  ///
  /// We know that lookup by the `nickname` field returns
  /// at-most one row because the [Unique] annotation in [User].
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<User>,)> byNickname(String nickname) =>
      where((user) => user.nickname.equalsValue(nickname)).first;

  /// Lookup a single row in `users` table using the
  /// `firstName`, `lastName` fields
  ///
  /// We know that lookup by the `firstName`, `lastName` fields returns
  /// at-most one row because the [Unique] annotation in [User].
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<User>,)> byFullName(String firstName, String lastName) =>
      where(
        (user) =>
            user.firstName.equalsValue(firstName) &
            user.lastName.equalsValue(lastName),
      ).first;

  /// Query the database for rows in this [Query] in pages of [pageSize]
  /// rows, ordered by the _primary key_, using _keyset pagination_.
  ///
  /// This is a shorthand for `.pagedBy(...)`, where each page is fetched by
  /// a separate query. If [startFrom] is given, only rows after [startFrom]
  /// in the given [order] are returned.
  ///
  /// > [!WARNING]
  /// > Rows in this [Query] must be unique, otherwise rows may be skipped.
  /// > Avoid using this on a `.join` projected to a single row or on a
  /// > `.unionAll`. Never use this after `.limit` or `.offset`, instead
  /// > use `.take` on the returned [Stream].
  $Stream<User> pagedByKey({
    $Order order = $Order.ascending,
    int pageSize = 100,
    User? startFrom,
  }) => pagedBy(
    (row) => [(row.userId, order)],
    pageSize: pageSize,
    startFrom: startFrom,
  );

  /// Query the database for rows in this [Query] in pages of [pageSize]
  /// rows, ordered by the unique `email` field, using _keyset pagination_.
  ///
  /// This is a shorthand for `.pagedBy(...)`, where each page is fetched by
  /// a separate query. If [startFrom] is given, only rows after [startFrom]
  /// in the given [order] are returned.
  ///
  /// > [!WARNING]
  /// > Rows in this [Query] must be unique, otherwise rows may be skipped.
  /// > Avoid using this on a `.join` projected to a single row or on a
  /// > `.unionAll`. Never use this after `.limit` or `.offset`, instead
  /// > use `.take` on the returned [Stream].
  $Stream<User> pagedByEmail({
    $Order order = $Order.ascending,
    int pageSize = 100,
    User? startFrom,
  }) => pagedBy(
    (row) => [(row.email, order)],
    pageSize: pageSize,
    startFrom: startFrom,
  );

  /// Query the database for rows in this [Query] in pages of [pageSize]
  /// rows, ordered by the unique combination of `firstName`, `lastName`, using _keyset pagination_.
  ///
  /// This is a shorthand for `.pagedBy(...)`, where each page is fetched by
  /// a separate query. If [startFrom] is given, only rows after [startFrom]
  /// in the given [order] are returned.
  ///
  /// > [!WARNING]
  /// > Rows in this [Query] must be unique, otherwise rows may be skipped.
  /// > Avoid using this on a `.join` projected to a single row or on a
  /// > `.unionAll`. Never use this after `.limit` or `.offset`, instead
  /// > use `.take` on the returned [Stream].
  $Stream<User> pagedByFullName({
    $Order order = $Order.ascending,
    int pageSize = 100,
    User? startFrom,
  }) => pagedBy(
    (row) => [(row.firstName, order), (row.lastName, order)],
    pageSize: pageSize,
    startFrom: startFrom,
  );

  /// Delete all rows in the `users` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<User> delete() => $ForGeneratedCode.delete(this, _$User._$table);
}

/// Extension methods for building point queries against the `users` table.
extension QuerySingleUserExt on QuerySingle<(Expr<User>,)> {
  /// Update the row (if any) in the `users` table matching this
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
  UpdateSingle<User> update(
    UpdateSet<User> Function(
      Expr<User> user,
      UpdateSet<User> Function({
        Expr<int> userId,
        Expr<String> email,
        Expr<String> firstName,
        Expr<String> lastName,
        Expr<String?> nickname,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<User>(
    this,
    _$User._$table,
    (user) => updateBuilder(
      user,
      ({
        Expr<int>? userId,
        Expr<String>? email,
        Expr<String>? firstName,
        Expr<String>? lastName,
        Expr<String?>? nickname,
      }) => $ForGeneratedCode.buildUpdate<User>([
        userId,
        email,
        firstName,
        lastName,
        nickname,
      ]),
    ),
  );

  /// Delete the row (if any) in the `users` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<User> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$User._$table);
}

/// Extension methods for expressions on a row in the `users` table.
extension ExpressionUserExt on Expr<User> {
  Expr<int> get userId =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String> get email =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<String> get firstName =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  Expr<String> get lastName =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.text);

  /// Nullable, so `.pagedByNickname` is not generated.
  Expr<String?> get nickname =>
      $ForGeneratedCode.field(this, 4, $ForGeneratedCode.text);
}

extension ExpressionNullableUserExt on Expr<User?> {
  Expr<int?> get userId =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String?> get email =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<String?> get firstName =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  Expr<String?> get lastName =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.text);

  /// Nullable, so `.pagedByNickname` is not generated.
  Expr<String?> get nickname =>
      $ForGeneratedCode.field(this, 4, $ForGeneratedCode.text);

  /// Check if the row is not `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNotNull() => userId.isNotNull();

  /// Check if the row is `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNull() => isNotNull().not();
}

/// `Table<User>` conflict targets for use with `.onConflict`.
enum UserConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `userId`.
  primaryKey(['userId']),

  /// `email` conflict.
  ///
  /// Due to violation of the `UNIQUE` constraint on
  /// `email`.
  ///
  /// Thus, the conflicting row has matching values for these fields.
  email(['email']),

  /// `nickname` conflict.
  ///
  /// Due to violation of the `UNIQUE` constraint on
  /// `nickname`.
  ///
  /// Thus, the conflicting row has matching values for these fields.
  nickname(['nickname']),

  /// `firstName`, `lastName` conflict.
  ///
  /// Due to violation of the `UNIQUE` constraint on
  /// `firstName`, `lastName`.
  ///
  /// Thus, the conflicting row has matching values for these fields.
  fullName(['firstName', 'lastName']);

  const UserConflict(this._fields);

  final List<String> _fields;
}

extension InsertUserExt on Insert<User> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((user, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflict<User> onConflict(UserConflict target) =>
      $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictUserExt on InsertOnConflict<User> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `user` an [Expr] representing the existing row in
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
  Upsert<User> update(
    UpdateSet<User> Function(
      Expr<User> user,
      Expr<User> excluded,
      UpdateSet<User> Function({
        Expr<int> userId,
        Expr<String> email,
        Expr<String> firstName,
        Expr<String> lastName,
        Expr<String?> nickname,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<User>(
    this,
    (user, excluded) => updateBuilder(
      user,
      excluded,
      ({
        Expr<int>? userId,
        Expr<String>? email,
        Expr<String>? firstName,
        Expr<String>? lastName,
        Expr<String?>? nickname,
      }) => $ForGeneratedCode.buildUpdate<User>([
        userId,
        email,
        firstName,
        lastName,
        nickname,
      ]),
    ),
  );
}

extension InsertSingleUserExt on InsertSingle<User> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((user, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflictSingle<User> onConflict(UserConflict target) =>
      $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleUserExt on InsertOnConflictSingle<User> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `user` an [Expr] representing the existing row in
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
  UpsertSingle<User> update(
    UpdateSet<User> Function(
      Expr<User> user,
      Expr<User> excluded,
      UpdateSet<User> Function({
        Expr<int> userId,
        Expr<String> email,
        Expr<String> firstName,
        Expr<String> lastName,
        Expr<String?> nickname,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<User>(
    this,
    (user, excluded) => updateBuilder(
      user,
      excluded,
      ({
        Expr<int>? userId,
        Expr<String>? email,
        Expr<String>? firstName,
        Expr<String>? lastName,
        Expr<String?>? nickname,
      }) => $ForGeneratedCode.buildUpdate<User>([
        userId,
        email,
        firstName,
        lastName,
        nickname,
      ]),
    ),
  );
}

final class _$Event extends Event {
  _$Event._(this.source, this.created, this.seq);

  @override
  final Source source;

  @override
  final DateTime created;

  @override
  final double seq;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'events',
    columns: <String>['source', 'created', 'seq'],
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
        type: $ForGeneratedCode.dateTime,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.real,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
    ],
    primaryKey: <String>['source', 'created', 'seq'],
    unique: <List<String>>[],
    foreignKeys: [],
    indexes: [],
    readRow: _$Event._$fromDatabase,
    fieldReaders: [
      (Event r) => r.source,
      (Event r) => r.created,
      (Event r) => r.seq,
    ],
  );

  static Event? _$fromDatabase(RowReader row) {
    final source = $ForGeneratedCode.customDataTypeOrNull(
      row.readString(),
      Source.fromDatabase,
    );
    final created = row.readDateTime();
    final seq = row.readDouble();
    if (source == null && created == null && seq == null) {
      return null;
    }
    return _$Event._(source!, created!, seq!);
  }

  @override
  String toString() =>
      'Event(source: "$source", created: "$created", seq: "$seq")';
}

/// Extension methods for table defined in [Event].
extension TableEventExt on Table<Event> {
  /// Insert row into the `events` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<Event> insert({
    required Expr<Source> source,
    required Expr<DateTime> created,
    required Expr<double> seq,
  }) =>
      $ForGeneratedCode.insertInto(table: this, values: [source, created, seq]);

  /// Insert row into the `events` table, or update the
  /// existing row if it conflicts with the _primary key_.
  ///
  /// This is a shorthand for calling `.insert(...)` followed by
  /// `.onConflict(.primaryKey)` and `.update(...)` to overwrite
  /// nothing, as all fields are part of the _primary key_,
  /// with the values given, leaving the _primary key_ untouched.
  ///
  /// Returns an [UpsertSingle] statement on which `.execute()` must be
  /// called for the row to be inserted or updated.
  UpsertSingle<Event> upsert({
    required Expr<Source> source,
    required Expr<DateTime> created,
    required Expr<double> seq,
  }) => insert(
    source: source,
    created: created,
    seq: seq,
  ).onConflict(.primaryKey).update((_, excluded, set) => set());

  /// Insert row into the `events` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<Event> insertValue({
    required Source source,
    required DateTime created,
    required double seq,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [source.asExpr, created.asExpr, seq.asExpr],
  );

  /// Insert row into the `events` table, or update the
  /// existing row if it conflicts with the _primary key_.
  ///
  /// This is a shorthand for calling `.insertValue(...)` followed by
  /// `.onConflict(.primaryKey)` and `.update(...)` to overwrite
  /// nothing, as all fields are part of the _primary key_,
  /// with the values given, leaving the _primary key_ untouched.
  ///
  /// Returns an [UpsertSingle] statement on which `.execute()` must be
  /// called for the row to be inserted or updated.
  UpsertSingle<Event> upsertValue({
    required Source source,
    required DateTime created,
    required double seq,
  }) => insertValue(
    source: source,
    created: created,
    seq: seq,
  ).onConflict(.primaryKey).update((_, excluded, set) => set());

  /// Bulk insert rows into the `events` table.
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
  Insert<Event> insertValuesMapped<T>(
    Iterable<T> rows, {
    required Source Function(T row) source,
    required DateTime Function(T row) created,
    required double Function(T row) seq,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mappings: [(T v) => source(v).toDatabase(), created, seq],
  );

  /// Delete a single row from the `events` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<Event> delete(Source source, DateTime created, double seq) =>
      $ForGeneratedCode.deleteSingle(
        byKey(source, created, seq),
        _$Event._$table,
      );
}

/// Extension methods for building queries against the `events` table.
extension QueryEventExt on Query<(Expr<Event>,)> {
  /// Lookup a single row in `events` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<Event>,)> byKey(
    Source source,
    DateTime created,
    double seq,
  ) => where(
    (event) =>
        event.source.asEncoded().equalsValue(source.toDatabase()) &
        event.created.equalsValue(created) &
        event.seq.equalsValue(seq),
  ).first;

  /// Update all rows in the `events` table matching this [Query].
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
  Update<Event> update(
    UpdateSet<Event> Function(
      Expr<Event> event,
      UpdateSet<Event> Function({
        Expr<Source> source,
        Expr<DateTime> created,
        Expr<double> seq,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<Event>(
    this,
    _$Event._$table,
    (event) => updateBuilder(
      event,
      ({Expr<Source>? source, Expr<DateTime>? created, Expr<double>? seq}) =>
          $ForGeneratedCode.buildUpdate<Event>([source, created, seq]),
    ),
  );

  /// Query the database for rows in this [Query] in pages of [pageSize]
  /// rows, ordered by the _primary key_, using _keyset pagination_.
  ///
  /// This is a shorthand for `.pagedBy(...)`, where each page is fetched by
  /// a separate query. If [startFrom] is given, only rows after [startFrom]
  /// in the given [order] are returned.
  ///
  /// > [!WARNING]
  /// > Rows in this [Query] must be unique, otherwise rows may be skipped.
  /// > Avoid using this on a `.join` projected to a single row or on a
  /// > `.unionAll`. Never use this after `.limit` or `.offset`, instead
  /// > use `.take` on the returned [Stream].
  $Stream<Event> pagedByKey({
    $Order order = $Order.ascending,
    int pageSize = 100,
    Event? startFrom,
  }) => pagedBy(
    (row) => [
      (row.source.asEncoded(), order),
      (row.created, order),
      (row.seq, order),
    ],
    pageSize: pageSize,
    startFrom: startFrom,
  );

  /// Delete all rows in the `events` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<Event> delete() => $ForGeneratedCode.delete(this, _$Event._$table);
}

/// Extension methods for building point queries against the `events` table.
extension QuerySingleEventExt on QuerySingle<(Expr<Event>,)> {
  /// Update the row (if any) in the `events` table matching this
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
  UpdateSingle<Event> update(
    UpdateSet<Event> Function(
      Expr<Event> event,
      UpdateSet<Event> Function({
        Expr<Source> source,
        Expr<DateTime> created,
        Expr<double> seq,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<Event>(
    this,
    _$Event._$table,
    (event) => updateBuilder(
      event,
      ({Expr<Source>? source, Expr<DateTime>? created, Expr<double>? seq}) =>
          $ForGeneratedCode.buildUpdate<Event>([source, created, seq]),
    ),
  );

  /// Delete the row (if any) in the `events` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<Event> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$Event._$table);
}

/// Extension methods for expressions on a row in the `events` table.
extension ExpressionEventExt on Expr<Event> {
  Expr<Source> get source =>
      $ForGeneratedCode.field(this, 0, SourceExt._exprType);

  Expr<DateTime> get created =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.dateTime);

  Expr<double> get seq =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.real);
}

extension ExpressionNullableEventExt on Expr<Event?> {
  Expr<Source?> get source =>
      $ForGeneratedCode.field(this, 0, SourceExt._exprType);

  Expr<DateTime?> get created =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.dateTime);

  Expr<double?> get seq =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.real);

  /// Check if the row is not `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNotNull() =>
      source.asEncoded().isNotNull() & created.isNotNull() & seq.isNotNull();

  /// Check if the row is `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNull() => isNotNull().not();
}

/// `Table<Event>` conflict targets for use with `.onConflict`.
enum EventConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `source`, `created`, `seq`.
  primaryKey(['source', 'created', 'seq']);

  const EventConflict(this._fields);

  final List<String> _fields;
}

extension InsertEventExt on Insert<Event> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((event, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflict<Event> onConflict(EventConflict target) =>
      $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictEventExt on InsertOnConflict<Event> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `event` an [Expr] representing the existing row in
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
  Upsert<Event> update(
    UpdateSet<Event> Function(
      Expr<Event> event,
      Expr<Event> excluded,
      UpdateSet<Event> Function({
        Expr<Source> source,
        Expr<DateTime> created,
        Expr<double> seq,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<Event>(
    this,
    (event, excluded) => updateBuilder(
      event,
      excluded,
      ({Expr<Source>? source, Expr<DateTime>? created, Expr<double>? seq}) =>
          $ForGeneratedCode.buildUpdate<Event>([source, created, seq]),
    ),
  );
}

extension InsertSingleEventExt on InsertSingle<Event> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((event, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflictSingle<Event> onConflict(EventConflict target) =>
      $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleEventExt on InsertOnConflictSingle<Event> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `event` an [Expr] representing the existing row in
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
  UpsertSingle<Event> update(
    UpdateSet<Event> Function(
      Expr<Event> event,
      Expr<Event> excluded,
      UpdateSet<Event> Function({
        Expr<Source> source,
        Expr<DateTime> created,
        Expr<double> seq,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<Event>(
    this,
    (event, excluded) => updateBuilder(
      event,
      excluded,
      ({Expr<Source>? source, Expr<DateTime>? created, Expr<double>? seq}) =>
          $ForGeneratedCode.buildUpdate<Event>([source, created, seq]),
    ),
  );
}

/// Wrap this [Source] as [Expr<Source>] for use queries with
/// `package:typed_sql`.
extension SourceExt on Source {
  static final _exprType = $ForGeneratedCode.customDataType(
    $ForGeneratedCode.text,
    Source.fromDatabase,
  );

  /// Wrap this [Source] as [Expr<Source>] for use queries with
  /// `package:typed_sql`.
  ///
  /// Using [asExpr] will inject this value as an SQL parameter,
  /// use [asExprLiteral] if you wish to inject as SQL literal instead.
  Expr<Source> get asExpr =>
      $ForGeneratedCode.customDataTypeAsExpr(this, _exprType).asNotNull();

  /// Wrap this [Source] as [Expr<Source>] for use queries with
  /// `package:typed_sql`.
  ///
  /// Using [asExprLiteral] will inject this value as an SQL literal,
  /// use [asExpr] if you wish to inject as SQL parameter instead.
  Expr<Source> get asExprLiteral => $ForGeneratedCode
      .customDataTypeAsExprLiteral(this, _exprType)
      .asNotNull();
}

/// Wrap this [Source] as [Expr<Source>] for use queries with
/// `package:typed_sql`.
extension SourceNullableExt on Source? {
  /// Wrap this [Source] as [Expr<Source?>] for use queries with
  /// `package:typed_sql`.
  ///
  /// Using [asExpr] will inject this value as an SQL parameter,
  /// use [asExprLiteral] if you wish to inject as SQL literal instead.
  Expr<Source?> get asExpr =>
      $ForGeneratedCode.customDataTypeAsExpr(this, SourceExt._exprType);

  /// Wrap this [Source] as [Expr<Source?>] for use queries with
  /// `package:typed_sql`.
  ///
  /// Using [asExprLiteral] will inject this value as an SQL literal,
  /// use [asExpr] if you wish to inject as SQL parameter instead.
  Expr<Source?> get asExprLiteral =>
      $ForGeneratedCode.customDataTypeAsExprLiteral(this, SourceExt._exprType);
}

/// Extension methods for assertions on [Event] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension EventChecks on Subject<Event> {
  /// Create assertions on [Event.source].
  Subject<Source> get source => has((m) => m.source, 'source');

  /// Create assertions on [Event.created].
  Subject<DateTime> get created => has((m) => m.created, 'created');

  /// Create assertions on [Event.seq].
  Subject<double> get seq => has((m) => m.seq, 'seq');
}

/// Extension methods for assertions on [User] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension UserChecks on Subject<User> {
  /// Create assertions on [User.userId].
  Subject<int> get userId => has((m) => m.userId, 'userId');

  /// Create assertions on [User.email].
  Subject<String> get email => has((m) => m.email, 'email');

  /// Create assertions on [User.firstName].
  Subject<String> get firstName => has((m) => m.firstName, 'firstName');

  /// Create assertions on [User.lastName].
  Subject<String> get lastName => has((m) => m.lastName, 'lastName');

  /// Create assertions on [User.nickname].
  Subject<String?> get nickname => has((m) => m.nickname, 'nickname');
}
