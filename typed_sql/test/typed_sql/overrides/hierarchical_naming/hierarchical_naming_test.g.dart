// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hierarchical_naming_test.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

/// Extension methods for a [Database] operating on [HierarchyDatabase].
extension HierarchyDatabaseSchema on Database<HierarchyDatabase> {
  static final _$tables = [_$HierarchyUser._$table, _$HierarchyProfile._$table];

  Table<HierarchyUser> get hierarchyUsers =>
      $ForGeneratedCode.declareTable(this, _$HierarchyUser._$table);

  Table<HierarchyProfile> get hierarchyProfiles =>
      $ForGeneratedCode.declareTable(this, _$HierarchyProfile._$table);

  /// Create tables defined in [HierarchyDatabase].
  ///
  /// Calling this on an empty database will create the tables
  /// defined in [HierarchyDatabase]. In production it's often better to
  /// use [createHierarchyDatabaseTables] and manage migrations using
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

/// Get SQL [DDL statements][1] for tables defined in [HierarchyDatabase].
///
/// This returns a SQL script with multiple DDL statements separated by `;`
/// using the specified [dialect].
///
/// Executing these statements in an empty database will create the tables
/// defined in [HierarchyDatabase]. In practice, this method is often used for
/// printing the DDL statements, such that migrations can be managed by
/// external tools.
///
/// [1]: https://en.wikipedia.org/wiki/Data_definition_language
String createHierarchyDatabaseTables(SqlDialect dialect) =>
    $ForGeneratedCode.createTableSchema(
      dialect: dialect,
      tables: HierarchyDatabaseSchema._$tables,
    );

final class _$HierarchyUser extends HierarchyUser {
  _$HierarchyUser._(
    this.userId,
    this.firstName,
    this.lastName,
    this.emailAddress,
    this.userColor,
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
  final Color userColor;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'tbl_users',
    columns: <String>[
      'userId',
      'str_first_name',
      'lastName',
      'emailAddress',
      'userColor',
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
    primaryKey: <String>['userId'],
    unique: <List<String>>[
      ['emailAddress'],
      ['str_first_name', 'lastName'],
    ],
    foreignKeys: [],
    readRow: _$HierarchyUser._$fromDatabase,
  );

  static HierarchyUser? _$fromDatabase(RowReader row) {
    final userId = row.readInt();
    final firstName = row.readString();
    final lastName = row.readString();
    final emailAddress = row.readString();
    final userColor = $ForGeneratedCode.customDataTypeOrNull(
      row.readInt(),
      Color.fromDatabase,
    );
    if (userId == null &&
        firstName == null &&
        lastName == null &&
        emailAddress == null &&
        userColor == null) {
      return null;
    }
    return _$HierarchyUser._(
      userId!,
      firstName!,
      lastName!,
      emailAddress!,
      userColor!,
    );
  }

  @override
  String toString() =>
      'HierarchyUser(userId: "$userId", firstName: "$firstName", lastName: "$lastName", emailAddress: "$emailAddress", userColor: "$userColor")';
}

/// Extension methods for table defined in [HierarchyUser].
extension TableHierarchyUserExt on Table<HierarchyUser> {
  /// Insert row into the `hierarchyUsers` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<HierarchyUser> insert({
    Expr<int>? userId,
    required Expr<String> firstName,
    required Expr<String> lastName,
    required Expr<String> emailAddress,
    required Expr<Color> userColor,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [userId, firstName, lastName, emailAddress, userColor],
  );

  /// Insert row into the `hierarchyUsers` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<HierarchyUser> insertValue({
    int? userId,
    required String firstName,
    required String lastName,
    required String emailAddress,
    required Color userColor,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [
      userId?.asExpr,
      firstName.asExpr,
      lastName.asExpr,
      emailAddress.asExpr,
      userColor.asExpr,
    ],
  );

  /// Bulk insert rows into the `hierarchyUsers` table.
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
  Insert<HierarchyUser> insertValuesMapped<T>(
    Iterable<T> rows, {
    int Function(T row)? userId,
    required String Function(T row) firstName,
    required String Function(T row) lastName,
    required String Function(T row) emailAddress,
    required Color Function(T row) userColor,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mappings: [
      userId,
      firstName,
      lastName,
      emailAddress,
      (T v) => userColor(v).toDatabase(),
    ],
  );

  /// Delete a single row from the `hierarchyUsers` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<HierarchyUser> delete(int userId) =>
      $ForGeneratedCode.deleteSingle(byKey(userId), _$HierarchyUser._$table);
}

/// Extension methods for building queries against the `hierarchyUsers` table.
extension QueryHierarchyUserExt on Query<(Expr<HierarchyUser>,)> {
  /// Lookup a single row in `hierarchyUsers` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<HierarchyUser>,)> byKey(int userId) =>
      where((hierarchyUser) => hierarchyUser.userId.equalsValue(userId)).first;

  /// Update all rows in the `hierarchyUsers` table matching this [Query].
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
  Update<HierarchyUser> update(
    UpdateSet<HierarchyUser> Function(
      Expr<HierarchyUser> hierarchyUser,
      UpdateSet<HierarchyUser> Function({
        Expr<int> userId,
        Expr<String> firstName,
        Expr<String> lastName,
        Expr<String> emailAddress,
        Expr<Color> userColor,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<HierarchyUser>(
    this,
    _$HierarchyUser._$table,
    (hierarchyUser) => updateBuilder(
      hierarchyUser,
      ({
        Expr<int>? userId,
        Expr<String>? firstName,
        Expr<String>? lastName,
        Expr<String>? emailAddress,
        Expr<Color>? userColor,
      }) => $ForGeneratedCode.buildUpdate<HierarchyUser>([
        userId,
        firstName,
        lastName,
        emailAddress,
        userColor,
      ]),
    ),
  );

  /// Lookup a single row in `hierarchyUsers` table using the
  /// `emailAddress` field
  ///
  /// We know that lookup by the `emailAddress` field returns
  /// at-most one row because the [Unique] annotation in [HierarchyUser].
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<HierarchyUser>,)> byEmailAddress(String emailAddress) =>
      where(
        (hierarchyUser) => hierarchyUser.emailAddress.equalsValue(emailAddress),
      ).first;

  /// Delete all rows in the `hierarchyUsers` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<HierarchyUser> delete() =>
      $ForGeneratedCode.delete(this, _$HierarchyUser._$table);
}

/// Extension methods for building point queries against the `hierarchyUsers` table.
extension QuerySingleHierarchyUserExt on QuerySingle<(Expr<HierarchyUser>,)> {
  /// Update the row (if any) in the `hierarchyUsers` table matching this
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
  UpdateSingle<HierarchyUser> update(
    UpdateSet<HierarchyUser> Function(
      Expr<HierarchyUser> hierarchyUser,
      UpdateSet<HierarchyUser> Function({
        Expr<int> userId,
        Expr<String> firstName,
        Expr<String> lastName,
        Expr<String> emailAddress,
        Expr<Color> userColor,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<HierarchyUser>(
    this,
    _$HierarchyUser._$table,
    (hierarchyUser) => updateBuilder(
      hierarchyUser,
      ({
        Expr<int>? userId,
        Expr<String>? firstName,
        Expr<String>? lastName,
        Expr<String>? emailAddress,
        Expr<Color>? userColor,
      }) => $ForGeneratedCode.buildUpdate<HierarchyUser>([
        userId,
        firstName,
        lastName,
        emailAddress,
        userColor,
      ]),
    ),
  );

  /// Delete the row (if any) in the `hierarchyUsers` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<HierarchyUser> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$HierarchyUser._$table);
}

/// Extension methods for expressions on a row in the `hierarchyUsers` table.
extension ExpressionHierarchyUserExt on Expr<HierarchyUser> {
  Expr<int> get userId =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String> get firstName =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<String> get lastName =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  Expr<String> get emailAddress =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.text);

  Expr<Color> get userColor =>
      $ForGeneratedCode.field(this, 4, ColorExt._exprType);
}

extension ExpressionNullableHierarchyUserExt on Expr<HierarchyUser?> {
  Expr<int?> get userId =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String?> get firstName =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<String?> get lastName =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  Expr<String?> get emailAddress =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.text);

  Expr<Color?> get userColor =>
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

/// `Table<HierarchyUser>` conflict targets for use with `.onConflict`.
enum HierarchyUserConflict {
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

  const HierarchyUserConflict(this._fields);

  final List<String> _fields;
}

extension InsertHierarchyUserExt on Insert<HierarchyUser> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((hierarchyUser, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflict<HierarchyUser> onConflict(HierarchyUserConflict target) =>
      $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictHierarchyUserExt on InsertOnConflict<HierarchyUser> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `hierarchyUser` an [Expr] representing the existing row in
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
  Upsert<HierarchyUser> update(
    UpdateSet<HierarchyUser> Function(
      Expr<HierarchyUser> hierarchyUser,
      Expr<HierarchyUser> excluded,
      UpdateSet<HierarchyUser> Function({
        Expr<int> userId,
        Expr<String> firstName,
        Expr<String> lastName,
        Expr<String> emailAddress,
        Expr<Color> userColor,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<HierarchyUser>(
    this,
    (hierarchyUser, excluded) => updateBuilder(
      hierarchyUser,
      excluded,
      ({
        Expr<int>? userId,
        Expr<String>? firstName,
        Expr<String>? lastName,
        Expr<String>? emailAddress,
        Expr<Color>? userColor,
      }) => $ForGeneratedCode.buildUpdate<HierarchyUser>([
        userId,
        firstName,
        lastName,
        emailAddress,
        userColor,
      ]),
    ),
  );
}

extension InsertSingleHierarchyUserExt on InsertSingle<HierarchyUser> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((hierarchyUser, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflictSingle<HierarchyUser> onConflict(
    HierarchyUserConflict target,
  ) => $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleHierarchyUserExt
    on InsertOnConflictSingle<HierarchyUser> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `hierarchyUser` an [Expr] representing the existing row in
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
  UpsertSingle<HierarchyUser> update(
    UpdateSet<HierarchyUser> Function(
      Expr<HierarchyUser> hierarchyUser,
      Expr<HierarchyUser> excluded,
      UpdateSet<HierarchyUser> Function({
        Expr<int> userId,
        Expr<String> firstName,
        Expr<String> lastName,
        Expr<String> emailAddress,
        Expr<Color> userColor,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<HierarchyUser>(
    this,
    (hierarchyUser, excluded) => updateBuilder(
      hierarchyUser,
      excluded,
      ({
        Expr<int>? userId,
        Expr<String>? firstName,
        Expr<String>? lastName,
        Expr<String>? emailAddress,
        Expr<Color>? userColor,
      }) => $ForGeneratedCode.buildUpdate<HierarchyUser>([
        userId,
        firstName,
        lastName,
        emailAddress,
        userColor,
      ]),
    ),
  );
}

final class _$HierarchyProfile extends HierarchyProfile {
  _$HierarchyProfile._(this.profileId, this.userRefId, this.profileType);

  @override
  final int profileId;

  @override
  final int userRefId;

  @override
  final String profileType;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'hierarchy_profiles',
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
        referencedTable: 'tbl_users',
        referencedColumns: ['userId'],
        onDelete: .noAction,
        onUpdate: .noAction,
      ),
    ],
    readRow: _$HierarchyProfile._$fromDatabase,
  );

  static HierarchyProfile? _$fromDatabase(RowReader row) {
    final profileId = row.readInt();
    final userRefId = row.readInt();
    final profileType = row.readString();
    if (profileId == null && userRefId == null && profileType == null) {
      return null;
    }
    return _$HierarchyProfile._(profileId!, userRefId!, profileType!);
  }

  @override
  String toString() =>
      'HierarchyProfile(profileId: "$profileId", userRefId: "$userRefId", profileType: "$profileType")';
}

/// Extension methods for table defined in [HierarchyProfile].
extension TableHierarchyProfileExt on Table<HierarchyProfile> {
  /// Insert row into the `hierarchyProfiles` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<HierarchyProfile> insert({
    Expr<int>? profileId,
    required Expr<int> userRefId,
    required Expr<String> profileType,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [profileId, userRefId, profileType],
  );

  /// Insert row into the `hierarchyProfiles` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<HierarchyProfile> insertValue({
    int? profileId,
    required int userRefId,
    required String profileType,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [profileId?.asExpr, userRefId.asExpr, profileType.asExpr],
  );

  /// Bulk insert rows into the `hierarchyProfiles` table.
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
  Insert<HierarchyProfile> insertValuesMapped<T>(
    Iterable<T> rows, {
    int Function(T row)? profileId,
    required int Function(T row) userRefId,
    required String Function(T row) profileType,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mappings: [profileId, userRefId, profileType],
  );

  /// Delete a single row from the `hierarchyProfiles` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<HierarchyProfile> delete(int profileId) => $ForGeneratedCode
      .deleteSingle(byKey(profileId), _$HierarchyProfile._$table);
}

/// Extension methods for building queries against the `hierarchyProfiles` table.
extension QueryHierarchyProfileExt on Query<(Expr<HierarchyProfile>,)> {
  /// Lookup a single row in `hierarchyProfiles` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<HierarchyProfile>,)> byKey(int profileId) => where(
    (hierarchyProfile) => hierarchyProfile.profileId.equalsValue(profileId),
  ).first;

  /// Update all rows in the `hierarchyProfiles` table matching this [Query].
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
  Update<HierarchyProfile> update(
    UpdateSet<HierarchyProfile> Function(
      Expr<HierarchyProfile> hierarchyProfile,
      UpdateSet<HierarchyProfile> Function({
        Expr<int> profileId,
        Expr<int> userRefId,
        Expr<String> profileType,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<HierarchyProfile>(
    this,
    _$HierarchyProfile._$table,
    (hierarchyProfile) => updateBuilder(
      hierarchyProfile,
      ({
        Expr<int>? profileId,
        Expr<int>? userRefId,
        Expr<String>? profileType,
      }) => $ForGeneratedCode.buildUpdate<HierarchyProfile>([
        profileId,
        userRefId,
        profileType,
      ]),
    ),
  );

  /// Lookup a single row in `hierarchyProfiles` table using the
  /// `profileType` field
  ///
  /// We know that lookup by the `profileType` field returns
  /// at-most one row because the [Unique] annotation in [HierarchyProfile].
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<HierarchyProfile>,)> byProfileType(String profileType) =>
      where(
        (hierarchyProfile) =>
            hierarchyProfile.profileType.equalsValue(profileType),
      ).first;

  /// Delete all rows in the `hierarchyProfiles` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<HierarchyProfile> delete() =>
      $ForGeneratedCode.delete(this, _$HierarchyProfile._$table);
}

/// Extension methods for building point queries against the `hierarchyProfiles` table.
extension QuerySingleHierarchyProfileExt
    on QuerySingle<(Expr<HierarchyProfile>,)> {
  /// Update the row (if any) in the `hierarchyProfiles` table matching this
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
  UpdateSingle<HierarchyProfile> update(
    UpdateSet<HierarchyProfile> Function(
      Expr<HierarchyProfile> hierarchyProfile,
      UpdateSet<HierarchyProfile> Function({
        Expr<int> profileId,
        Expr<int> userRefId,
        Expr<String> profileType,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<HierarchyProfile>(
    this,
    _$HierarchyProfile._$table,
    (hierarchyProfile) => updateBuilder(
      hierarchyProfile,
      ({
        Expr<int>? profileId,
        Expr<int>? userRefId,
        Expr<String>? profileType,
      }) => $ForGeneratedCode.buildUpdate<HierarchyProfile>([
        profileId,
        userRefId,
        profileType,
      ]),
    ),
  );

  /// Delete the row (if any) in the `hierarchyProfiles` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<HierarchyProfile> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$HierarchyProfile._$table);
}

/// Extension methods for expressions on a row in the `hierarchyProfiles` table.
extension ExpressionHierarchyProfileExt on Expr<HierarchyProfile> {
  Expr<int> get profileId =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<int> get userRefId =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.integer);

  Expr<String> get profileType =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);
}

extension ExpressionNullableHierarchyProfileExt on Expr<HierarchyProfile?> {
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

/// `Table<HierarchyProfile>` conflict targets for use with `.onConflict`.
enum HierarchyProfileConflict {
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

  const HierarchyProfileConflict(this._fields);

  final List<String> _fields;
}

extension InsertHierarchyProfileExt on Insert<HierarchyProfile> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((hierarchyProfile, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflict<HierarchyProfile> onConflict(
    HierarchyProfileConflict target,
  ) => $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictHierarchyProfileExt
    on InsertOnConflict<HierarchyProfile> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `hierarchyProfile` an [Expr] representing the existing row in
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
  Upsert<HierarchyProfile> update(
    UpdateSet<HierarchyProfile> Function(
      Expr<HierarchyProfile> hierarchyProfile,
      Expr<HierarchyProfile> excluded,
      UpdateSet<HierarchyProfile> Function({
        Expr<int> profileId,
        Expr<int> userRefId,
        Expr<String> profileType,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<HierarchyProfile>(
    this,
    (hierarchyProfile, excluded) => updateBuilder(
      hierarchyProfile,
      excluded,
      ({
        Expr<int>? profileId,
        Expr<int>? userRefId,
        Expr<String>? profileType,
      }) => $ForGeneratedCode.buildUpdate<HierarchyProfile>([
        profileId,
        userRefId,
        profileType,
      ]),
    ),
  );
}

extension InsertSingleHierarchyProfileExt on InsertSingle<HierarchyProfile> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((hierarchyProfile, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflictSingle<HierarchyProfile> onConflict(
    HierarchyProfileConflict target,
  ) => $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleHierarchyProfileExt
    on InsertOnConflictSingle<HierarchyProfile> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `hierarchyProfile` an [Expr] representing the existing row in
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
  UpsertSingle<HierarchyProfile> update(
    UpdateSet<HierarchyProfile> Function(
      Expr<HierarchyProfile> hierarchyProfile,
      Expr<HierarchyProfile> excluded,
      UpdateSet<HierarchyProfile> Function({
        Expr<int> profileId,
        Expr<int> userRefId,
        Expr<String> profileType,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<HierarchyProfile>(
    this,
    (hierarchyProfile, excluded) => updateBuilder(
      hierarchyProfile,
      excluded,
      ({
        Expr<int>? profileId,
        Expr<int>? userRefId,
        Expr<String>? profileType,
      }) => $ForGeneratedCode.buildUpdate<HierarchyProfile>([
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
      $ForGeneratedCode.customDataTypeAsExpr(this, _exprType).asNotNull();
}

/// Wrap this [Color] as [Expr<Color>] for use queries with
/// `package:typed_sql`.
extension ColorNullableExt on Color? {
  /// Wrap this [Color] as [Expr<Color?>] for use queries with
  /// `package:typed_sql`.
  Expr<Color?> get asExpr =>
      $ForGeneratedCode.customDataTypeAsExpr(this, ColorExt._exprType);
}

/// Extension methods for assertions on [HierarchyProfile] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension HierarchyProfileChecks on Subject<HierarchyProfile> {
  /// Create assertions on [HierarchyProfile.profileId].
  Subject<int> get profileId => has((m) => m.profileId, 'profileId');

  /// Create assertions on [HierarchyProfile.userRefId].
  Subject<int> get userRefId => has((m) => m.userRefId, 'userRefId');

  /// Create assertions on [HierarchyProfile.profileType].
  Subject<String> get profileType => has((m) => m.profileType, 'profileType');
}

/// Extension methods for assertions on [HierarchyUser] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension HierarchyUserChecks on Subject<HierarchyUser> {
  /// Create assertions on [HierarchyUser.userId].
  Subject<int> get userId => has((m) => m.userId, 'userId');

  /// Create assertions on [HierarchyUser.firstName].
  Subject<String> get firstName => has((m) => m.firstName, 'firstName');

  /// Create assertions on [HierarchyUser.lastName].
  Subject<String> get lastName => has((m) => m.lastName, 'lastName');

  /// Create assertions on [HierarchyUser.emailAddress].
  Subject<String> get emailAddress =>
      has((m) => m.emailAddress, 'emailAddress');

  /// Create assertions on [HierarchyUser.userColor].
  Subject<Color> get userColor => has((m) => m.userColor, 'userColor');
}
