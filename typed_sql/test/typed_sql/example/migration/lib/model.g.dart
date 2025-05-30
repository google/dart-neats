// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

/// Extension methods for a [Database] operating on [BankVault].
extension BankVaultSchema on Database<BankVault> {
  static const _$tables = [_$Account._$table];

  Table<Account> get accounts => ExposedForCodeGen.declareTable(
        this,
        _$Account._$table,
      );

  /// Create tables defined in [BankVault].
  ///
  /// Calling this on an empty database will create the tables
  /// defined in [BankVault]. In production it's often better to
  /// use [createBankVaultTables] and manage migrations using
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

/// Get SQL [DDL statements][1] for tables defined in [BankVault].
///
/// This returns a SQL script with multiple DDL statements separated by `;`
/// using the specified [dialect].
///
/// Executing these statements in an empty database will create the tables
/// defined in [BankVault]. In practice, this method is often used for
/// printing the DDL statements, such that migrations can be managed by
/// external tools.
///
/// [1]: https://en.wikipedia.org/wiki/Data_definition_language
String createBankVaultTables(SqlDialect dialect) =>
    ExposedForCodeGen.createTableSchema(
      dialect: dialect,
      tables: BankVaultSchema._$tables,
    );

final class _$Account extends Account {
  _$Account._(
    this.accountId,
    this.accountNumber,
  );

  @override
  final int accountId;

  @override
  final String accountNumber;

  static const _$table = (
    tableName: 'accounts',
    columns: <String>['accountId', 'accountNumber'],
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
      )
    ],
    primaryKey: <String>['accountId'],
    unique: <List<String>>[
      ['accountNumber']
    ],
    foreignKeys: <({
      String name,
      List<String> columns,
      String referencedTable,
      List<String> referencedColumns,
    })>[],
    readRow: _$Account._$fromDatabase,
  );

  static Account? _$fromDatabase(RowReader row) {
    final accountId = row.readInt();
    final accountNumber = row.readString();
    if (accountId == null && accountNumber == null) {
      return null;
    }
    return _$Account._(accountId!, accountNumber!);
  }

  @override
  String toString() =>
      'Account(accountId: "$accountId", accountNumber: "$accountNumber")';
}

/// Extension methods for table defined in [Account].
extension TableAccountExt on Table<Account> {
  /// Insert row into the `accounts` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<Account> insert({
    Expr<int>? accountId,
    required Expr<String> accountNumber,
  }) =>
      ExposedForCodeGen.insertInto(
        table: this,
        values: [
          accountId,
          accountNumber,
        ],
      );

  /// Delete a single row from the `accounts` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<Account> delete(int accountId) => ExposedForCodeGen.deleteSingle(
        byKey(accountId),
        _$Account._$table,
      );
}

/// Extension methods for building queries against the `accounts` table.
extension QueryAccountExt on Query<(Expr<Account>,)> {
  /// Lookup a single row in `accounts` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<Account>,)> byKey(int accountId) =>
      where((account) => account.accountId.equalsValue(accountId)).first;

  /// Update all rows in the `accounts` table matching this [Query].
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
  Update<Account> update(
          UpdateSet<Account> Function(
            Expr<Account> account,
            UpdateSet<Account> Function({
              Expr<int> accountId,
              Expr<String> accountNumber,
            }) set,
          ) updateBuilder) =>
      ExposedForCodeGen.update<Account>(
        this,
        _$Account._$table,
        (account) => updateBuilder(
          account,
          ({
            Expr<int>? accountId,
            Expr<String>? accountNumber,
          }) =>
              ExposedForCodeGen.buildUpdate<Account>([
            accountId,
            accountNumber,
          ]),
        ),
      );

  /// Lookup a single row in `accounts` table using the
  /// `accountNumber` field.
  ///
  /// We know that lookup by the `accountNumber` field returns
  /// at-most one row because the `accountNumber` has an [Unique]
  /// annotation in [Account].
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<Account>,)> byAccountNumber(String accountNumber) =>
      where((account) => account.accountNumber.equalsValue(accountNumber))
          .first;

  /// Delete all rows in the `accounts` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<Account> delete() => ExposedForCodeGen.delete(this, _$Account._$table);
}

/// Extension methods for building point queries against the `accounts` table.
extension QuerySingleAccountExt on QuerySingle<(Expr<Account>,)> {
  /// Update the row (if any) in the `accounts` table matching this
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
  UpdateSingle<Account> update(
          UpdateSet<Account> Function(
            Expr<Account> account,
            UpdateSet<Account> Function({
              Expr<int> accountId,
              Expr<String> accountNumber,
            }) set,
          ) updateBuilder) =>
      ExposedForCodeGen.updateSingle<Account>(
        this,
        _$Account._$table,
        (account) => updateBuilder(
          account,
          ({
            Expr<int>? accountId,
            Expr<String>? accountNumber,
          }) =>
              ExposedForCodeGen.buildUpdate<Account>([
            accountId,
            accountNumber,
          ]),
        ),
      );

  /// Delete the row (if any) in the `accounts` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<Account> delete() =>
      ExposedForCodeGen.deleteSingle(this, _$Account._$table);
}

/// Extension methods for expressions on a row in the `accounts` table.
extension ExpressionAccountExt on Expr<Account> {
  Expr<int> get accountId =>
      ExposedForCodeGen.field(this, 0, ExposedForCodeGen.integer);

  Expr<String> get accountNumber =>
      ExposedForCodeGen.field(this, 1, ExposedForCodeGen.text);
}

extension ExpressionNullableAccountExt on Expr<Account?> {
  Expr<int?> get accountId =>
      ExposedForCodeGen.field(this, 0, ExposedForCodeGen.integer);

  Expr<String?> get accountNumber =>
      ExposedForCodeGen.field(this, 1, ExposedForCodeGen.text);

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
