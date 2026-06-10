// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'legacy_names_test.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

/// Extension methods for a [Database] operating on [LegacyDatabase].
extension LegacyDatabaseSchema on Database<LegacyDatabase> {
  static final _$tables = [_$LegacyUser._$table, _$LegacyComment._$table];

  Table<LegacyUser> get users =>
      $ForGeneratedCode.declareTable(this, _$LegacyUser._$table);

  Table<LegacyComment> get comments =>
      $ForGeneratedCode.declareTable(this, _$LegacyComment._$table);

  /// Create tables defined in [LegacyDatabase].
  ///
  /// Calling this on an empty database will create the tables
  /// defined in [LegacyDatabase]. In production it's often better to
  /// use [createLegacyDatabaseTables] and manage migrations using
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

/// Get SQL [DDL statements][1] for tables defined in [LegacyDatabase].
///
/// This returns a SQL script with multiple DDL statements separated by `;`
/// using the specified [dialect].
///
/// Executing these statements in an empty database will create the tables
/// defined in [LegacyDatabase]. In practice, this method is often used for
/// printing the DDL statements, such that migrations can be managed by
/// external tools.
///
/// [1]: https://en.wikipedia.org/wiki/Data_definition_language
String createLegacyDatabaseTables(SqlDialect dialect) => $ForGeneratedCode
    .createTableSchema(dialect: dialect, tables: LegacyDatabaseSchema._$tables);

final class _$LegacyUser extends LegacyUser {
  _$LegacyUser._(
    this.tenantId,
    this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.color,
  );

  @override
  final int tenantId;

  @override
  final int userId;

  @override
  final String firstName;

  @override
  final String lastName;

  @override
  final String email;

  @override
  final Color color;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 't_user_data',
    columns: <String>[
      'INT_tenant_id',
      'INT_user_id',
      'str_First_Name',
      'str_Last_Name',
      'str_Email',
      'col_color',
    ],
    columnInfo: [
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.integer,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
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
        type: $ForGeneratedCode.integer,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
    ],
    primaryKey: <String>['INT_tenant_id', 'INT_user_id'],
    unique: <List<String>>[
      ['str_Email'],
      ['str_First_Name', 'str_Last_Name'],
    ],
    foreignKeys: [],
    readRow: _$LegacyUser._$fromDatabase,
  );

  static LegacyUser? _$fromDatabase(RowReader row) {
    final tenantId = row.readInt();
    final userId = row.readInt();
    final firstName = row.readString();
    final lastName = row.readString();
    final email = row.readString();
    final color = $ForGeneratedCode.customDataTypeOrNull(
      row.readInt(),
      Color.fromDatabase,
    );
    if (tenantId == null &&
        userId == null &&
        firstName == null &&
        lastName == null &&
        email == null &&
        color == null) {
      return null;
    }
    return _$LegacyUser._(
      tenantId!,
      userId!,
      firstName!,
      lastName!,
      email!,
      color!,
    );
  }

  @override
  String toString() =>
      'LegacyUser(tenantId: "$tenantId", userId: "$userId", firstName: "$firstName", lastName: "$lastName", email: "$email", color: "$color")';
}

/// Extension methods for table defined in [LegacyUser].
extension TableLegacyUserExt on Table<LegacyUser> {
  /// Insert row into the `users` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<LegacyUser> insert({
    required Expr<int> tenantId,
    required Expr<int> userId,
    required Expr<String> firstName,
    required Expr<String> lastName,
    required Expr<String> email,
    required Expr<Color> color,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [tenantId, userId, firstName, lastName, email, color],
  );

  /// Insert row into the `users` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<LegacyUser> insertValue({
    required int tenantId,
    required int userId,
    required String firstName,
    required String lastName,
    required String email,
    required Color color,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [
      tenantId.asExpr,
      userId.asExpr,
      firstName.asExpr,
      lastName.asExpr,
      email.asExpr,
      color.asExpr,
    ],
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
  Insert<LegacyUser> insertValuesMapped<T>(
    Iterable<T> rows, {
    required int Function(T row) tenantId,
    required int Function(T row) userId,
    required String Function(T row) firstName,
    required String Function(T row) lastName,
    required String Function(T row) email,
    required Color Function(T row) color,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mappings: [
      tenantId,
      userId,
      firstName,
      lastName,
      email,
      (T v) => color(v).toDatabase(),
    ],
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
  DeleteSingle<LegacyUser> delete(int tenantId, int userId) => $ForGeneratedCode
      .deleteSingle(byKey(tenantId, userId), _$LegacyUser._$table);
}

/// Extension methods for building queries against the `users` table.
extension QueryLegacyUserExt on Query<(Expr<LegacyUser>,)> {
  /// Lookup a single row in `users` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<LegacyUser>,)> byKey(int tenantId, int userId) => where(
    (legacyUser) =>
        legacyUser.tenantId.equalsValue(tenantId) &
        legacyUser.userId.equalsValue(userId),
  ).first;

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
  Update<LegacyUser> update(
    UpdateSet<LegacyUser> Function(
      Expr<LegacyUser> legacyUser,
      UpdateSet<LegacyUser> Function({
        Expr<int> tenantId,
        Expr<int> userId,
        Expr<String> firstName,
        Expr<String> lastName,
        Expr<String> email,
        Expr<Color> color,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<LegacyUser>(
    this,
    _$LegacyUser._$table,
    (legacyUser) => updateBuilder(
      legacyUser,
      ({
        Expr<int>? tenantId,
        Expr<int>? userId,
        Expr<String>? firstName,
        Expr<String>? lastName,
        Expr<String>? email,
        Expr<Color>? color,
      }) => $ForGeneratedCode.buildUpdate<LegacyUser>([
        tenantId,
        userId,
        firstName,
        lastName,
        email,
        color,
      ]),
    ),
  );

  /// Lookup a single row in `users` table using the
  /// `email` field
  ///
  /// We know that lookup by the `email` field returns
  /// at-most one row because the [Unique] annotation in [LegacyUser].
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<LegacyUser>,)> byEmail(String email) =>
      where((legacyUser) => legacyUser.email.equalsValue(email)).first;

  /// Delete all rows in the `users` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<LegacyUser> delete() =>
      $ForGeneratedCode.delete(this, _$LegacyUser._$table);
}

/// Extension methods for building point queries against the `users` table.
extension QuerySingleLegacyUserExt on QuerySingle<(Expr<LegacyUser>,)> {
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
  UpdateSingle<LegacyUser> update(
    UpdateSet<LegacyUser> Function(
      Expr<LegacyUser> legacyUser,
      UpdateSet<LegacyUser> Function({
        Expr<int> tenantId,
        Expr<int> userId,
        Expr<String> firstName,
        Expr<String> lastName,
        Expr<String> email,
        Expr<Color> color,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<LegacyUser>(
    this,
    _$LegacyUser._$table,
    (legacyUser) => updateBuilder(
      legacyUser,
      ({
        Expr<int>? tenantId,
        Expr<int>? userId,
        Expr<String>? firstName,
        Expr<String>? lastName,
        Expr<String>? email,
        Expr<Color>? color,
      }) => $ForGeneratedCode.buildUpdate<LegacyUser>([
        tenantId,
        userId,
        firstName,
        lastName,
        email,
        color,
      ]),
    ),
  );

  /// Delete the row (if any) in the `users` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<LegacyUser> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$LegacyUser._$table);
}

/// Extension methods for expressions on a row in the `users` table.
extension ExpressionLegacyUserExt on Expr<LegacyUser> {
  Expr<int> get tenantId =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<int> get userId =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.integer);

  Expr<String> get firstName =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  Expr<String> get lastName =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.text);

  Expr<String> get email =>
      $ForGeneratedCode.field(this, 4, $ForGeneratedCode.text);

  Expr<Color> get color => $ForGeneratedCode.field(this, 5, ColorExt._exprType);
}

extension ExpressionNullableLegacyUserExt on Expr<LegacyUser?> {
  Expr<int?> get tenantId =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<int?> get userId =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.integer);

  Expr<String?> get firstName =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  Expr<String?> get lastName =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.text);

  Expr<String?> get email =>
      $ForGeneratedCode.field(this, 4, $ForGeneratedCode.text);

  Expr<Color?> get color =>
      $ForGeneratedCode.field(this, 5, ColorExt._exprType);

  /// Check if the row is not `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNotNull() => tenantId.isNotNull() & userId.isNotNull();

  /// Check if the row is `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNull() => isNotNull().not();
}

/// `Table<LegacyUser>` conflict targets for use with `.onConflict`.
enum LegacyUserConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `tenantId`, `userId`.
  primaryKey(['tenantId', 'userId']),

  /// `email` conflict.
  ///
  /// Due to violation of the `UNIQUE` constraint on
  /// `email`.
  ///
  /// Thus, the conflicting row has matching values for these fields.
  email(['email']),

  /// `firstName`, `lastName` conflict.
  ///
  /// Due to violation of the `UNIQUE` constraint on
  /// `firstName`, `lastName`.
  ///
  /// Thus, the conflicting row has matching values for these fields.
  firstNameLastName(['firstName', 'lastName']);

  const LegacyUserConflict(this._fields);

  final List<String> _fields;
}

extension InsertLegacyUserExt on Insert<LegacyUser> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((legacyUser, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflict<LegacyUser> onConflict(LegacyUserConflict target) =>
      $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictLegacyUserExt on InsertOnConflict<LegacyUser> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `legacyUser` an [Expr] representing the existing row in
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
  Upsert<LegacyUser> update(
    UpdateSet<LegacyUser> Function(
      Expr<LegacyUser> legacyUser,
      Expr<LegacyUser> excluded,
      UpdateSet<LegacyUser> Function({
        Expr<int> tenantId,
        Expr<int> userId,
        Expr<String> firstName,
        Expr<String> lastName,
        Expr<String> email,
        Expr<Color> color,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<LegacyUser>(
    this,
    (legacyUser, excluded) => updateBuilder(
      legacyUser,
      excluded,
      ({
        Expr<int>? tenantId,
        Expr<int>? userId,
        Expr<String>? firstName,
        Expr<String>? lastName,
        Expr<String>? email,
        Expr<Color>? color,
      }) => $ForGeneratedCode.buildUpdate<LegacyUser>([
        tenantId,
        userId,
        firstName,
        lastName,
        email,
        color,
      ]),
    ),
  );
}

extension InsertSingleLegacyUserExt on InsertSingle<LegacyUser> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((legacyUser, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflictSingle<LegacyUser> onConflict(LegacyUserConflict target) =>
      $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleLegacyUserExt
    on InsertOnConflictSingle<LegacyUser> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `legacyUser` an [Expr] representing the existing row in
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
  UpsertSingle<LegacyUser> update(
    UpdateSet<LegacyUser> Function(
      Expr<LegacyUser> legacyUser,
      Expr<LegacyUser> excluded,
      UpdateSet<LegacyUser> Function({
        Expr<int> tenantId,
        Expr<int> userId,
        Expr<String> firstName,
        Expr<String> lastName,
        Expr<String> email,
        Expr<Color> color,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<LegacyUser>(
    this,
    (legacyUser, excluded) => updateBuilder(
      legacyUser,
      excluded,
      ({
        Expr<int>? tenantId,
        Expr<int>? userId,
        Expr<String>? firstName,
        Expr<String>? lastName,
        Expr<String>? email,
        Expr<Color>? color,
      }) => $ForGeneratedCode.buildUpdate<LegacyUser>([
        tenantId,
        userId,
        firstName,
        lastName,
        email,
        color,
      ]),
    ),
  );
}

final class _$LegacyComment extends LegacyComment {
  _$LegacyComment._(this.commentId, this.tId, this.uId, this.text);

  @override
  final int commentId;

  @override
  final int tId;

  @override
  final int uId;

  @override
  final String text;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 't_user_comments',
    columns: <String>['c_id', 't_id', 'u_id', 'c_text'],
    columnInfo: [
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.integer,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: true,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.integer,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
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
        overrides: [],
      ),
    ],
    primaryKey: <String>['c_id'],
    unique: <List<String>>[],
    foreignKeys: [
      $ForGeneratedCode.foreignKeyDefinition(
        name: 'null',
        columns: ['t_id', 'u_id'],
        referencedTable: 't_user_data',
        referencedColumns: ['INT_tenant_id', 'INT_user_id'],
        onDelete: .noAction,
        onUpdate: .noAction,
      ),
    ],
    readRow: _$LegacyComment._$fromDatabase,
  );

  static LegacyComment? _$fromDatabase(RowReader row) {
    final commentId = row.readInt();
    final tId = row.readInt();
    final uId = row.readInt();
    final text = row.readString();
    if (commentId == null && tId == null && uId == null && text == null) {
      return null;
    }
    return _$LegacyComment._(commentId!, tId!, uId!, text!);
  }

  @override
  String toString() =>
      'LegacyComment(commentId: "$commentId", tId: "$tId", uId: "$uId", text: "$text")';
}

/// Extension methods for table defined in [LegacyComment].
extension TableLegacyCommentExt on Table<LegacyComment> {
  /// Insert row into the `comments` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<LegacyComment> insert({
    Expr<int>? commentId,
    required Expr<int> tId,
    required Expr<int> uId,
    required Expr<String> text,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [commentId, tId, uId, text],
  );

  /// Insert row into the `comments` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<LegacyComment> insertValue({
    int? commentId,
    required int tId,
    required int uId,
    required String text,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [commentId?.asExpr, tId.asExpr, uId.asExpr, text.asExpr],
  );

  /// Bulk insert rows into the `comments` table.
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
  Insert<LegacyComment> insertValuesMapped<T>(
    Iterable<T> rows, {
    int Function(T row)? commentId,
    required int Function(T row) tId,
    required int Function(T row) uId,
    required String Function(T row) text,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mappings: [commentId, tId, uId, text],
  );

  /// Delete a single row from the `comments` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<LegacyComment> delete(int commentId) =>
      $ForGeneratedCode.deleteSingle(byKey(commentId), _$LegacyComment._$table);
}

/// Extension methods for building queries against the `comments` table.
extension QueryLegacyCommentExt on Query<(Expr<LegacyComment>,)> {
  /// Lookup a single row in `comments` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<LegacyComment>,)> byKey(int commentId) => where(
    (legacyComment) => legacyComment.commentId.equalsValue(commentId),
  ).first;

  /// Update all rows in the `comments` table matching this [Query].
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
  Update<LegacyComment> update(
    UpdateSet<LegacyComment> Function(
      Expr<LegacyComment> legacyComment,
      UpdateSet<LegacyComment> Function({
        Expr<int> commentId,
        Expr<int> tId,
        Expr<int> uId,
        Expr<String> text,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<LegacyComment>(
    this,
    _$LegacyComment._$table,
    (legacyComment) => updateBuilder(
      legacyComment,
      ({
        Expr<int>? commentId,
        Expr<int>? tId,
        Expr<int>? uId,
        Expr<String>? text,
      }) => $ForGeneratedCode.buildUpdate<LegacyComment>([
        commentId,
        tId,
        uId,
        text,
      ]),
    ),
  );

  /// Delete all rows in the `comments` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<LegacyComment> delete() =>
      $ForGeneratedCode.delete(this, _$LegacyComment._$table);
}

/// Extension methods for building point queries against the `comments` table.
extension QuerySingleLegacyCommentExt on QuerySingle<(Expr<LegacyComment>,)> {
  /// Update the row (if any) in the `comments` table matching this
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
  UpdateSingle<LegacyComment> update(
    UpdateSet<LegacyComment> Function(
      Expr<LegacyComment> legacyComment,
      UpdateSet<LegacyComment> Function({
        Expr<int> commentId,
        Expr<int> tId,
        Expr<int> uId,
        Expr<String> text,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<LegacyComment>(
    this,
    _$LegacyComment._$table,
    (legacyComment) => updateBuilder(
      legacyComment,
      ({
        Expr<int>? commentId,
        Expr<int>? tId,
        Expr<int>? uId,
        Expr<String>? text,
      }) => $ForGeneratedCode.buildUpdate<LegacyComment>([
        commentId,
        tId,
        uId,
        text,
      ]),
    ),
  );

  /// Delete the row (if any) in the `comments` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<LegacyComment> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$LegacyComment._$table);
}

/// Extension methods for expressions on a row in the `comments` table.
extension ExpressionLegacyCommentExt on Expr<LegacyComment> {
  Expr<int> get commentId =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<int> get tId =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.integer);

  Expr<int> get uId =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.integer);

  Expr<String> get text =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.text);
}

extension ExpressionNullableLegacyCommentExt on Expr<LegacyComment?> {
  Expr<int?> get commentId =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<int?> get tId =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.integer);

  Expr<int?> get uId =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.integer);

  Expr<String?> get text =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.text);

  /// Check if the row is not `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNotNull() => commentId.isNotNull();

  /// Check if the row is `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNull() => isNotNull().not();
}

/// `Table<LegacyComment>` conflict targets for use with `.onConflict`.
enum LegacyCommentConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `commentId`.
  primaryKey(['commentId']);

  const LegacyCommentConflict(this._fields);

  final List<String> _fields;
}

extension InsertLegacyCommentExt on Insert<LegacyComment> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((legacyComment, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflict<LegacyComment> onConflict(LegacyCommentConflict target) =>
      $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictLegacyCommentExt on InsertOnConflict<LegacyComment> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `legacyComment` an [Expr] representing the existing row in
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
  Upsert<LegacyComment> update(
    UpdateSet<LegacyComment> Function(
      Expr<LegacyComment> legacyComment,
      Expr<LegacyComment> excluded,
      UpdateSet<LegacyComment> Function({
        Expr<int> commentId,
        Expr<int> tId,
        Expr<int> uId,
        Expr<String> text,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<LegacyComment>(
    this,
    (legacyComment, excluded) => updateBuilder(
      legacyComment,
      excluded,
      ({
        Expr<int>? commentId,
        Expr<int>? tId,
        Expr<int>? uId,
        Expr<String>? text,
      }) => $ForGeneratedCode.buildUpdate<LegacyComment>([
        commentId,
        tId,
        uId,
        text,
      ]),
    ),
  );
}

extension InsertSingleLegacyCommentExt on InsertSingle<LegacyComment> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((legacyComment, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflictSingle<LegacyComment> onConflict(
    LegacyCommentConflict target,
  ) => $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleLegacyCommentExt
    on InsertOnConflictSingle<LegacyComment> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `legacyComment` an [Expr] representing the existing row in
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
  UpsertSingle<LegacyComment> update(
    UpdateSet<LegacyComment> Function(
      Expr<LegacyComment> legacyComment,
      Expr<LegacyComment> excluded,
      UpdateSet<LegacyComment> Function({
        Expr<int> commentId,
        Expr<int> tId,
        Expr<int> uId,
        Expr<String> text,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<LegacyComment>(
    this,
    (legacyComment, excluded) => updateBuilder(
      legacyComment,
      excluded,
      ({
        Expr<int>? commentId,
        Expr<int>? tId,
        Expr<int>? uId,
        Expr<String>? text,
      }) => $ForGeneratedCode.buildUpdate<LegacyComment>([
        commentId,
        tId,
        uId,
        text,
      ]),
    ),
  );
}

/// Wrap this [Color] as [Expr<Color>] for use queries with
/// `package:typed_sql`.
extension ColorExt on Color {
  static final _exprType = $ForGeneratedCode.customDataType(
    $ForGeneratedCode.integer,
    Color.fromDatabase,
  );

  /// Wrap this [Color] as [Expr<Color>] for use queries with
  /// `package:typed_sql`.
  ///
  /// Using [asExpr] will inject this value as an SQL parameter,
  /// use [asExprLiteral] if you wish to inject as SQL literal instead.
  Expr<Color> get asExpr =>
      $ForGeneratedCode.customDataTypeAsExpr(this, _exprType).asNotNull();

  /// Wrap this [Color] as [Expr<Color>] for use queries with
  /// `package:typed_sql`.
  ///
  /// Using [asExprLiteral] will inject this value as an SQL literal,
  /// use [asExpr] if you wish to inject as SQL parameter instead.
  Expr<Color> get asExprLiteral => $ForGeneratedCode
      .customDataTypeAsExprLiteral(this, _exprType)
      .asNotNull();
}

/// Wrap this [Color] as [Expr<Color>] for use queries with
/// `package:typed_sql`.
extension ColorNullableExt on Color? {
  /// Wrap this [Color] as [Expr<Color?>] for use queries with
  /// `package:typed_sql`.
  ///
  /// Using [asExpr] will inject this value as an SQL parameter,
  /// use [asExprLiteral] if you wish to inject as SQL literal instead.
  Expr<Color?> get asExpr =>
      $ForGeneratedCode.customDataTypeAsExpr(this, ColorExt._exprType);

  /// Wrap this [Color] as [Expr<Color?>] for use queries with
  /// `package:typed_sql`.
  ///
  /// Using [asExprLiteral] will inject this value as an SQL literal,
  /// use [asExpr] if you wish to inject as SQL parameter instead.
  Expr<Color?> get asExprLiteral =>
      $ForGeneratedCode.customDataTypeAsExprLiteral(this, ColorExt._exprType);
}

/// Extension methods for assertions on [LegacyComment] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension LegacyCommentChecks on Subject<LegacyComment> {
  /// Create assertions on [LegacyComment.commentId].
  Subject<int> get commentId => has((m) => m.commentId, 'commentId');

  /// Create assertions on [LegacyComment.tId].
  Subject<int> get tId => has((m) => m.tId, 'tId');

  /// Create assertions on [LegacyComment.uId].
  Subject<int> get uId => has((m) => m.uId, 'uId');

  /// Create assertions on [LegacyComment.text].
  Subject<String> get text => has((m) => m.text, 'text');
}

/// Extension methods for assertions on [LegacyUser] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension LegacyUserChecks on Subject<LegacyUser> {
  /// Create assertions on [LegacyUser.tenantId].
  Subject<int> get tenantId => has((m) => m.tenantId, 'tenantId');

  /// Create assertions on [LegacyUser.userId].
  Subject<int> get userId => has((m) => m.userId, 'userId');

  /// Create assertions on [LegacyUser.firstName].
  Subject<String> get firstName => has((m) => m.firstName, 'firstName');

  /// Create assertions on [LegacyUser.lastName].
  Subject<String> get lastName => has((m) => m.lastName, 'lastName');

  /// Create assertions on [LegacyUser.email].
  Subject<String> get email => has((m) => m.email, 'email');

  /// Create assertions on [LegacyUser.color].
  Subject<Color> get color => has((m) => m.color, 'color');
}
