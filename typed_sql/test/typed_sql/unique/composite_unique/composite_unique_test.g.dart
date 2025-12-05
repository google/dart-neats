// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'composite_unique_test.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

/// Extension methods for a [Database] operating on [PrimaryDatabase].
extension PrimaryDatabaseSchema on Database<PrimaryDatabase> {
  static const _$tables = [_$User._$table];

  Table<User> get users => $ForGeneratedCode.declareTable(
        this,
        _$User._$table,
      );

  /// Create tables defined in [PrimaryDatabase].
  ///
  /// Calling this on an empty database will create the tables
  /// defined in [PrimaryDatabase]. In production it's often better to
  /// use [createPrimaryDatabaseTables] and manage migrations using
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

/// Get SQL [DDL statements][1] for tables defined in [PrimaryDatabase].
///
/// This returns a SQL script with multiple DDL statements separated by `;`
/// using the specified [dialect].
///
/// Executing these statements in an empty database will create the tables
/// defined in [PrimaryDatabase]. In practice, this method is often used for
/// printing the DDL statements, such that migrations can be managed by
/// external tools.
///
/// [1]: https://en.wikipedia.org/wiki/Data_definition_language
String createPrimaryDatabaseTables(SqlDialect dialect) =>
    $ForGeneratedCode.createTableSchema(
      dialect: dialect,
      tables: PrimaryDatabaseSchema._$tables,
    );

final class _$User extends User {
  _$User._(
    this.accountId,
    this.firstName,
    this.lastName,
  );

  @override
  final int accountId;

  @override
  final String firstName;

  @override
  final String lastName;

  static const _$table = (
    tableName: 'users',
    columns: <String>['accountId', 'firstName', 'lastName'],
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
        overrides: <SqlOverride>[
          SqlOverride(dialect: 'mysql', columnType: 'VARCHAR(255)')
        ],
      ),
      (
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: <SqlOverride>[
          SqlOverride(dialect: 'mysql', columnType: 'VARCHAR(255)')
        ],
      )
    ],
    primaryKey: <String>['accountId'],
    unique: <List<String>>[
      ['firstName', 'lastName']
    ],
    foreignKeys: <({
      String name,
      List<String> columns,
      String referencedTable,
      List<String> referencedColumns,
    })>[],
    readRow: _$User._$fromDatabase,
  );

  static User? _$fromDatabase(RowReader row) {
    final accountId = row.readInt();
    final firstName = row.readString();
    final lastName = row.readString();
    if (accountId == null && firstName == null && lastName == null) {
      return null;
    }
    return _$User._(accountId!, firstName!, lastName!);
  }

  @override
  String toString() =>
      'User(accountId: "$accountId", firstName: "$firstName", lastName: "$lastName")';
}

/// Extension methods for table defined in [User].
extension TableUserExt on Table<User> {
  /// Insert row into the `users` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<User> insert({
    Expr<int>? accountId,
    required Expr<String> firstName,
    required Expr<String> lastName,
  }) =>
      $ForGeneratedCode.insertInto(
        table: this,
        values: [
          accountId,
          firstName,
          lastName,
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
  DeleteSingle<User> delete(int accountId) => $ForGeneratedCode.deleteSingle(
        byKey(accountId),
        _$User._$table,
      );
}

/// Extension methods for building queries against the `users` table.
extension QueryUserExt on Query<(Expr<User>,)> {
  /// Lookup a single row in `users` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<User>,)> byKey(int accountId) =>
      where((user) => user.accountId.equalsValue(accountId)).first;

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
              Expr<int> accountId,
              Expr<String> firstName,
              Expr<String> lastName,
            }) set,
          ) updateBuilder) =>
      $ForGeneratedCode.update<User>(
        this,
        _$User._$table,
        (user) => updateBuilder(
          user,
          ({
            Expr<int>? accountId,
            Expr<String>? firstName,
            Expr<String>? lastName,
          }) =>
              $ForGeneratedCode.buildUpdate<User>([
            accountId,
            firstName,
            lastName,
          ]),
        ),
      );

  /// Lookup a single row in `users` table using the
  /// `firstName`, `lastName` fields
  ///
  /// We know that lookup by the `firstName`, `lastName` fields returns
  /// at-most one row because the [Unique] annotation in [User].
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<User>,)> byFullname(
    String firstName,
    String lastName,
  ) =>
      where((user) =>
          user.firstName.equalsValue(firstName) &
          user.lastName.equalsValue(lastName)).first;

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
              Expr<int> accountId,
              Expr<String> firstName,
              Expr<String> lastName,
            }) set,
          ) updateBuilder) =>
      $ForGeneratedCode.updateSingle<User>(
        this,
        _$User._$table,
        (user) => updateBuilder(
          user,
          ({
            Expr<int>? accountId,
            Expr<String>? firstName,
            Expr<String>? lastName,
          }) =>
              $ForGeneratedCode.buildUpdate<User>([
            accountId,
            firstName,
            lastName,
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
  Expr<int> get accountId =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String> get firstName =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<String> get lastName =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);
}

extension ExpressionNullableUserExt on Expr<User?> {
  Expr<int?> get accountId =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String?> get firstName =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<String?> get lastName =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  /// Check if the row is not `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNotNull() => accountId.isNotNull();

  /// Check if the row is `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNull() => isNotNull().not();
}

/// Extension methods for assertions on [User] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension UserChecks on Subject<User> {
  /// Create assertions on [User.accountId].
  Subject<int> get accountId => has((m) => m.accountId, 'accountId');

  /// Create assertions on [User.firstName].
  Subject<String> get firstName => has((m) => m.firstName, 'firstName');

  /// Create assertions on [User.lastName].
  Subject<String> get lastName => has((m) => m.lastName, 'lastName');
}
