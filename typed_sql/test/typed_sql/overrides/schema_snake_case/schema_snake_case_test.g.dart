// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schema_snake_case_test.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

/// Extension methods for a [Database] operating on [SnakeDatabase].
extension SnakeDatabaseSchema on Database<SnakeDatabase> {
  static final _$tables = [_$SnakeUser._$table, _$SnakeProfile._$table];

  Table<SnakeUser> get snakeUsers =>
      $ForGeneratedCode.declareTable(this, _$SnakeUser._$table);

  Table<SnakeProfile> get snakeProfiles =>
      $ForGeneratedCode.declareTable(this, _$SnakeProfile._$table);

  /// Create tables defined in [SnakeDatabase].
  ///
  /// Calling this on an empty database will create the tables
  /// defined in [SnakeDatabase]. In production it's often better to
  /// use [createSnakeDatabaseTables] and manage migrations using
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

/// Get SQL [DDL statements][1] for tables defined in [SnakeDatabase].
///
/// This returns a SQL script with multiple DDL statements separated by `;`
/// using the specified [dialect].
///
/// Executing these statements in an empty database will create the tables
/// defined in [SnakeDatabase]. In practice, this method is often used for
/// printing the DDL statements, such that migrations can be managed by
/// external tools.
///
/// [1]: https://en.wikipedia.org/wiki/Data_definition_language
String createSnakeDatabaseTables(SqlDialect dialect) => $ForGeneratedCode
    .createTableSchema(dialect: dialect, tables: SnakeDatabaseSchema._$tables);

final class _$SnakeUser extends SnakeUser {
  _$SnakeUser._(
    this.userId,
    this.firstName,
    this.lastName,
    this.emailAddress,
    this.favoriteColor,
  );

  @override
  final int userId;

  @override
  final String firstName;

  @override
  final String lastName;

  @override
  final String emailAddress;

  @override
  final Color favoriteColor;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'snake_users',
    columns: <String>[
      'user_id',
      'first_name',
      'last_name',
      'email_address',
      'favorite_color',
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
    primaryKey: <String>['user_id'],
    unique: <List<String>>[
      ['email_address'],
      ['first_name', 'last_name'],
    ],
    foreignKeys: [],
    readRow: _$SnakeUser._$fromDatabase,
  );

  static SnakeUser? _$fromDatabase(RowReader row) {
    final userId = row.readInt();
    final firstName = row.readString();
    final lastName = row.readString();
    final emailAddress = row.readString();
    final favoriteColor = $ForGeneratedCode.customDataTypeOrNull(
      row.readInt(),
      Color.fromDatabase,
    );
    if (userId == null &&
        firstName == null &&
        lastName == null &&
        emailAddress == null &&
        favoriteColor == null) {
      return null;
    }
    return _$SnakeUser._(
      userId!,
      firstName!,
      lastName!,
      emailAddress!,
      favoriteColor!,
    );
  }

  @override
  String toString() =>
      'SnakeUser(userId: "$userId", firstName: "$firstName", lastName: "$lastName", emailAddress: "$emailAddress", favoriteColor: "$favoriteColor")';
}

/// Extension methods for table defined in [SnakeUser].
extension TableSnakeUserExt on Table<SnakeUser> {
  /// Insert row into the `snakeUsers` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<SnakeUser> insert({
    Expr<int>? userId,
    required Expr<String> firstName,
    required Expr<String> lastName,
    required Expr<String> emailAddress,
    required Expr<Color> favoriteColor,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [userId, firstName, lastName, emailAddress, favoriteColor],
  );

  /// Insert row into the `snakeUsers` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<SnakeUser> insertValue({
    int? userId,
    required String firstName,
    required String lastName,
    required String emailAddress,
    required Color favoriteColor,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [
      userId?.asExpr,
      firstName.asExpr,
      lastName.asExpr,
      emailAddress.asExpr,
      favoriteColor.asExpr,
    ],
  );

  /// Bulk insert rows into the `snakeUsers` table.
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
  Insert<SnakeUser> insertValuesMapped<T>(
    Iterable<T> rows, {
    int Function(T row)? userId,
    required String Function(T row) firstName,
    required String Function(T row) lastName,
    required String Function(T row) emailAddress,
    required Color Function(T row) favoriteColor,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mappings: [
      userId,
      firstName,
      lastName,
      emailAddress,
      (T v) => favoriteColor(v).toDatabase(),
    ],
  );

  /// Delete a single row from the `snakeUsers` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<SnakeUser> delete(int userId) =>
      $ForGeneratedCode.deleteSingle(byKey(userId), _$SnakeUser._$table);
}

/// Extension methods for building queries against the `snakeUsers` table.
extension QuerySnakeUserExt on Query<(Expr<SnakeUser>,)> {
  /// Lookup a single row in `snakeUsers` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<SnakeUser>,)> byKey(int userId) =>
      where((snakeUser) => snakeUser.userId.equalsValue(userId)).first;

  /// Update all rows in the `snakeUsers` table matching this [Query].
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
  Update<SnakeUser> update(
    UpdateSet<SnakeUser> Function(
      Expr<SnakeUser> snakeUser,
      UpdateSet<SnakeUser> Function({
        Expr<int> userId,
        Expr<String> firstName,
        Expr<String> lastName,
        Expr<String> emailAddress,
        Expr<Color> favoriteColor,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<SnakeUser>(
    this,
    _$SnakeUser._$table,
    (snakeUser) => updateBuilder(
      snakeUser,
      ({
        Expr<int>? userId,
        Expr<String>? firstName,
        Expr<String>? lastName,
        Expr<String>? emailAddress,
        Expr<Color>? favoriteColor,
      }) => $ForGeneratedCode.buildUpdate<SnakeUser>([
        userId,
        firstName,
        lastName,
        emailAddress,
        favoriteColor,
      ]),
    ),
  );

  /// Lookup a single row in `snakeUsers` table using the
  /// `emailAddress` field
  ///
  /// We know that lookup by the `emailAddress` field returns
  /// at-most one row because the [Unique] annotation in [SnakeUser].
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<SnakeUser>,)> byEmailAddress(String emailAddress) => where(
    (snakeUser) => snakeUser.emailAddress.equalsValue(emailAddress),
  ).first;

  /// Delete all rows in the `snakeUsers` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<SnakeUser> delete() =>
      $ForGeneratedCode.delete(this, _$SnakeUser._$table);
}

/// Extension methods for building point queries against the `snakeUsers` table.
extension QuerySingleSnakeUserExt on QuerySingle<(Expr<SnakeUser>,)> {
  /// Update the row (if any) in the `snakeUsers` table matching this
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
  UpdateSingle<SnakeUser> update(
    UpdateSet<SnakeUser> Function(
      Expr<SnakeUser> snakeUser,
      UpdateSet<SnakeUser> Function({
        Expr<int> userId,
        Expr<String> firstName,
        Expr<String> lastName,
        Expr<String> emailAddress,
        Expr<Color> favoriteColor,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<SnakeUser>(
    this,
    _$SnakeUser._$table,
    (snakeUser) => updateBuilder(
      snakeUser,
      ({
        Expr<int>? userId,
        Expr<String>? firstName,
        Expr<String>? lastName,
        Expr<String>? emailAddress,
        Expr<Color>? favoriteColor,
      }) => $ForGeneratedCode.buildUpdate<SnakeUser>([
        userId,
        firstName,
        lastName,
        emailAddress,
        favoriteColor,
      ]),
    ),
  );

  /// Delete the row (if any) in the `snakeUsers` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<SnakeUser> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$SnakeUser._$table);
}

/// Extension methods for expressions on a row in the `snakeUsers` table.
extension ExpressionSnakeUserExt on Expr<SnakeUser> {
  Expr<int> get userId =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String> get firstName =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<String> get lastName =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  Expr<String> get emailAddress =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.text);

  Expr<Color> get favoriteColor =>
      $ForGeneratedCode.field(this, 4, ColorExt._exprType);
}

extension ExpressionNullableSnakeUserExt on Expr<SnakeUser?> {
  Expr<int?> get userId =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String?> get firstName =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<String?> get lastName =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  Expr<String?> get emailAddress =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.text);

  Expr<Color?> get favoriteColor =>
      $ForGeneratedCode.field(this, 4, ColorExt._exprType);

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

/// `Table<SnakeUser>` conflict targets for use with `.onConflict`.
enum SnakeUserConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `userId`.
  primaryKey(['userId']),

  /// `emailAddress` conflict.
  ///
  /// Due to violation of the `UNIQUE` constraint on
  /// `emailAddress`.
  ///
  /// Thus, the conflicting row has matching values for these fields.
  emailAddress(['emailAddress']),

  /// `firstName`, `lastName` conflict.
  ///
  /// Due to violation of the `UNIQUE` constraint on
  /// `firstName`, `lastName`.
  ///
  /// Thus, the conflicting row has matching values for these fields.
  firstNameLastName(['firstName', 'lastName']);

  const SnakeUserConflict(this._fields);

  final List<String> _fields;
}

extension InsertSnakeUserExt on Insert<SnakeUser> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((snakeUser, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflict<SnakeUser> onConflict(SnakeUserConflict target) =>
      $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictSnakeUserExt on InsertOnConflict<SnakeUser> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `snakeUser` an [Expr] representing the existing row in
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
  Upsert<SnakeUser> update(
    UpdateSet<SnakeUser> Function(
      Expr<SnakeUser> snakeUser,
      Expr<SnakeUser> excluded,
      UpdateSet<SnakeUser> Function({
        Expr<int> userId,
        Expr<String> firstName,
        Expr<String> lastName,
        Expr<String> emailAddress,
        Expr<Color> favoriteColor,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<SnakeUser>(
    this,
    (snakeUser, excluded) => updateBuilder(
      snakeUser,
      excluded,
      ({
        Expr<int>? userId,
        Expr<String>? firstName,
        Expr<String>? lastName,
        Expr<String>? emailAddress,
        Expr<Color>? favoriteColor,
      }) => $ForGeneratedCode.buildUpdate<SnakeUser>([
        userId,
        firstName,
        lastName,
        emailAddress,
        favoriteColor,
      ]),
    ),
  );
}

extension InsertSingleSnakeUserExt on InsertSingle<SnakeUser> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((snakeUser, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflictSingle<SnakeUser> onConflict(SnakeUserConflict target) =>
      $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleSnakeUserExt
    on InsertOnConflictSingle<SnakeUser> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `snakeUser` an [Expr] representing the existing row in
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
  UpsertSingle<SnakeUser> update(
    UpdateSet<SnakeUser> Function(
      Expr<SnakeUser> snakeUser,
      Expr<SnakeUser> excluded,
      UpdateSet<SnakeUser> Function({
        Expr<int> userId,
        Expr<String> firstName,
        Expr<String> lastName,
        Expr<String> emailAddress,
        Expr<Color> favoriteColor,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<SnakeUser>(
    this,
    (snakeUser, excluded) => updateBuilder(
      snakeUser,
      excluded,
      ({
        Expr<int>? userId,
        Expr<String>? firstName,
        Expr<String>? lastName,
        Expr<String>? emailAddress,
        Expr<Color>? favoriteColor,
      }) => $ForGeneratedCode.buildUpdate<SnakeUser>([
        userId,
        firstName,
        lastName,
        emailAddress,
        favoriteColor,
      ]),
    ),
  );
}

final class _$SnakeProfile extends SnakeProfile {
  _$SnakeProfile._(this.profileId, this.userRefId, this.profileType);

  @override
  final int profileId;

  @override
  final int userRefId;

  @override
  final String profileType;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'snake_profiles',
    columns: <String>['profile_id', 'user_ref_id', 'profile_type'],
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
    primaryKey: <String>['profile_id'],
    unique: <List<String>>[
      ['profile_type'],
    ],
    foreignKeys: [
      $ForGeneratedCode.foreignKeyDefinition(
        name: 'null',
        columns: ['user_ref_id'],
        referencedTable: 'snake_users',
        referencedColumns: ['user_id'],
        onDelete: .noAction,
        onUpdate: .noAction,
      ),
    ],
    readRow: _$SnakeProfile._$fromDatabase,
  );

  static SnakeProfile? _$fromDatabase(RowReader row) {
    final profileId = row.readInt();
    final userRefId = row.readInt();
    final profileType = row.readString();
    if (profileId == null && userRefId == null && profileType == null) {
      return null;
    }
    return _$SnakeProfile._(profileId!, userRefId!, profileType!);
  }

  @override
  String toString() =>
      'SnakeProfile(profileId: "$profileId", userRefId: "$userRefId", profileType: "$profileType")';
}

/// Extension methods for table defined in [SnakeProfile].
extension TableSnakeProfileExt on Table<SnakeProfile> {
  /// Insert row into the `snakeProfiles` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<SnakeProfile> insert({
    Expr<int>? profileId,
    required Expr<int> userRefId,
    required Expr<String> profileType,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [profileId, userRefId, profileType],
  );

  /// Insert row into the `snakeProfiles` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<SnakeProfile> insertValue({
    int? profileId,
    required int userRefId,
    required String profileType,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [profileId?.asExpr, userRefId.asExpr, profileType.asExpr],
  );

  /// Bulk insert rows into the `snakeProfiles` table.
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
  Insert<SnakeProfile> insertValuesMapped<T>(
    Iterable<T> rows, {
    int Function(T row)? profileId,
    required int Function(T row) userRefId,
    required String Function(T row) profileType,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mappings: [profileId, userRefId, profileType],
  );

  /// Delete a single row from the `snakeProfiles` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<SnakeProfile> delete(int profileId) =>
      $ForGeneratedCode.deleteSingle(byKey(profileId), _$SnakeProfile._$table);
}

/// Extension methods for building queries against the `snakeProfiles` table.
extension QuerySnakeProfileExt on Query<(Expr<SnakeProfile>,)> {
  /// Lookup a single row in `snakeProfiles` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<SnakeProfile>,)> byKey(int profileId) => where(
    (snakeProfile) => snakeProfile.profileId.equalsValue(profileId),
  ).first;

  /// Update all rows in the `snakeProfiles` table matching this [Query].
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
  Update<SnakeProfile> update(
    UpdateSet<SnakeProfile> Function(
      Expr<SnakeProfile> snakeProfile,
      UpdateSet<SnakeProfile> Function({
        Expr<int> profileId,
        Expr<int> userRefId,
        Expr<String> profileType,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<SnakeProfile>(
    this,
    _$SnakeProfile._$table,
    (snakeProfile) => updateBuilder(
      snakeProfile,
      ({
        Expr<int>? profileId,
        Expr<int>? userRefId,
        Expr<String>? profileType,
      }) => $ForGeneratedCode.buildUpdate<SnakeProfile>([
        profileId,
        userRefId,
        profileType,
      ]),
    ),
  );

  /// Lookup a single row in `snakeProfiles` table using the
  /// `profileType` field
  ///
  /// We know that lookup by the `profileType` field returns
  /// at-most one row because the [Unique] annotation in [SnakeProfile].
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<SnakeProfile>,)> byProfileType(String profileType) => where(
    (snakeProfile) => snakeProfile.profileType.equalsValue(profileType),
  ).first;

  /// Delete all rows in the `snakeProfiles` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<SnakeProfile> delete() =>
      $ForGeneratedCode.delete(this, _$SnakeProfile._$table);
}

/// Extension methods for building point queries against the `snakeProfiles` table.
extension QuerySingleSnakeProfileExt on QuerySingle<(Expr<SnakeProfile>,)> {
  /// Update the row (if any) in the `snakeProfiles` table matching this
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
  UpdateSingle<SnakeProfile> update(
    UpdateSet<SnakeProfile> Function(
      Expr<SnakeProfile> snakeProfile,
      UpdateSet<SnakeProfile> Function({
        Expr<int> profileId,
        Expr<int> userRefId,
        Expr<String> profileType,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<SnakeProfile>(
    this,
    _$SnakeProfile._$table,
    (snakeProfile) => updateBuilder(
      snakeProfile,
      ({
        Expr<int>? profileId,
        Expr<int>? userRefId,
        Expr<String>? profileType,
      }) => $ForGeneratedCode.buildUpdate<SnakeProfile>([
        profileId,
        userRefId,
        profileType,
      ]),
    ),
  );

  /// Delete the row (if any) in the `snakeProfiles` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<SnakeProfile> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$SnakeProfile._$table);
}

/// Extension methods for expressions on a row in the `snakeProfiles` table.
extension ExpressionSnakeProfileExt on Expr<SnakeProfile> {
  Expr<int> get profileId =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<int> get userRefId =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.integer);

  Expr<String> get profileType =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);
}

extension ExpressionNullableSnakeProfileExt on Expr<SnakeProfile?> {
  Expr<int?> get profileId =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<int?> get userRefId =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.integer);

  Expr<String?> get profileType =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  /// Check if the row is not `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNotNull() => profileId.isNotNull();

  /// Check if the row is `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNull() => isNotNull().not();
}

/// `Table<SnakeProfile>` conflict targets for use with `.onConflict`.
enum SnakeProfileConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `profileId`.
  primaryKey(['profileId']),

  /// `profileType` conflict.
  ///
  /// Due to violation of the `UNIQUE` constraint on
  /// `profileType`.
  ///
  /// Thus, the conflicting row has matching values for these fields.
  profileType(['profileType']);

  const SnakeProfileConflict(this._fields);

  final List<String> _fields;
}

extension InsertSnakeProfileExt on Insert<SnakeProfile> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((snakeProfile, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflict<SnakeProfile> onConflict(SnakeProfileConflict target) =>
      $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictSnakeProfileExt on InsertOnConflict<SnakeProfile> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `snakeProfile` an [Expr] representing the existing row in
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
  Upsert<SnakeProfile> update(
    UpdateSet<SnakeProfile> Function(
      Expr<SnakeProfile> snakeProfile,
      Expr<SnakeProfile> excluded,
      UpdateSet<SnakeProfile> Function({
        Expr<int> profileId,
        Expr<int> userRefId,
        Expr<String> profileType,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<SnakeProfile>(
    this,
    (snakeProfile, excluded) => updateBuilder(
      snakeProfile,
      excluded,
      ({
        Expr<int>? profileId,
        Expr<int>? userRefId,
        Expr<String>? profileType,
      }) => $ForGeneratedCode.buildUpdate<SnakeProfile>([
        profileId,
        userRefId,
        profileType,
      ]),
    ),
  );
}

extension InsertSingleSnakeProfileExt on InsertSingle<SnakeProfile> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((snakeProfile, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflictSingle<SnakeProfile> onConflict(
    SnakeProfileConflict target,
  ) => $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleSnakeProfileExt
    on InsertOnConflictSingle<SnakeProfile> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `snakeProfile` an [Expr] representing the existing row in
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
  UpsertSingle<SnakeProfile> update(
    UpdateSet<SnakeProfile> Function(
      Expr<SnakeProfile> snakeProfile,
      Expr<SnakeProfile> excluded,
      UpdateSet<SnakeProfile> Function({
        Expr<int> profileId,
        Expr<int> userRefId,
        Expr<String> profileType,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<SnakeProfile>(
    this,
    (snakeProfile, excluded) => updateBuilder(
      snakeProfile,
      excluded,
      ({
        Expr<int>? profileId,
        Expr<int>? userRefId,
        Expr<String>? profileType,
      }) => $ForGeneratedCode.buildUpdate<SnakeProfile>([
        profileId,
        userRefId,
        profileType,
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
  Expr<Color> get asExpr =>
      $ForGeneratedCode.literalCustomDataType(this, _exprType).asNotNull();
}

/// Wrap this [Color] as [Expr<Color>] for use queries with
/// `package:typed_sql`.
extension ColorNullableExt on Color? {
  /// Wrap this [Color] as [Expr<Color?>] for use queries with
  /// `package:typed_sql`.
  Expr<Color?> get asExpr =>
      $ForGeneratedCode.literalCustomDataType(this, ColorExt._exprType);
}

/// Extension methods for assertions on [SnakeProfile] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension SnakeProfileChecks on Subject<SnakeProfile> {
  /// Create assertions on [SnakeProfile.profileId].
  Subject<int> get profileId => has((m) => m.profileId, 'profileId');

  /// Create assertions on [SnakeProfile.userRefId].
  Subject<int> get userRefId => has((m) => m.userRefId, 'userRefId');

  /// Create assertions on [SnakeProfile.profileType].
  Subject<String> get profileType => has((m) => m.profileType, 'profileType');
}

/// Extension methods for assertions on [SnakeUser] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension SnakeUserChecks on Subject<SnakeUser> {
  /// Create assertions on [SnakeUser.userId].
  Subject<int> get userId => has((m) => m.userId, 'userId');

  /// Create assertions on [SnakeUser.firstName].
  Subject<String> get firstName => has((m) => m.firstName, 'firstName');

  /// Create assertions on [SnakeUser.lastName].
  Subject<String> get lastName => has((m) => m.lastName, 'lastName');

  /// Create assertions on [SnakeUser.emailAddress].
  Subject<String> get emailAddress =>
      has((m) => m.emailAddress, 'emailAddress');

  /// Create assertions on [SnakeUser.favoriteColor].
  Subject<Color> get favoriteColor =>
      has((m) => m.favoriteColor, 'favoriteColor');
}
