// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_test.dart';

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
    this.balance,
  );

  @override
  final int accountId;

  @override
  final String accountNumber;

  @override
  final double balance;

  static const _$table = (
    tableName: 'accounts',
    columns: <String>['accountId', 'accountNumber', 'balance'],
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
        type: ExposedForCodeGen.real,
        isNotNull: true,
        defaultValue: 0.0,
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
    readModel: _$Account._$fromDatabase,
  );

  static Account? _$fromDatabase(RowReader row) {
    final accountId = row.readInt();
    final accountNumber = row.readString();
    final balance = row.readDouble();
    if (accountId == null && accountNumber == null && balance == null) {
      return null;
    }
    return _$Account._(accountId!, accountNumber!, balance!);
  }

  @override
  String toString() =>
      'Account(accountId: "$accountId", accountNumber: "$accountNumber", balance: "$balance")';
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
    Expr<double>? balance,
  }) =>
      ExposedForCodeGen.insertInto(
        table: this,
        values: [
          accountId,
          accountNumber,
          balance,
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
  /// `.where((_) => literal(true)).delete()`.
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
      where((account) => account.accountId.equalsLiteral(accountId)).first;

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
  Update<Account> update(
          UpdateSet<Account> Function(
            Expr<Account> account,
            UpdateSet<Account> Function({
              Expr<int> accountId,
              Expr<String> accountNumber,
              Expr<double> balance,
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
            Expr<double>? balance,
          }) =>
              ExposedForCodeGen.buildUpdate<Account>([
            accountId,
            accountNumber,
            balance,
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
      where((account) => account.accountNumber.equalsLiteral(accountNumber))
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
  UpdateSingle<Account> update(
          UpdateSet<Account> Function(
            Expr<Account> account,
            UpdateSet<Account> Function({
              Expr<int> accountId,
              Expr<String> accountNumber,
              Expr<double> balance,
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
            Expr<double>? balance,
          }) =>
              ExposedForCodeGen.buildUpdate<Account>([
            accountId,
            accountNumber,
            balance,
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

  Expr<double> get balance =>
      ExposedForCodeGen.field(this, 2, ExposedForCodeGen.real);
}

extension ExpressionNullableAccountExt on Expr<Account?> {
  Expr<int?> get accountId =>
      ExposedForCodeGen.field(this, 0, ExposedForCodeGen.integer);

  Expr<String?> get accountNumber =>
      ExposedForCodeGen.field(this, 1, ExposedForCodeGen.text);

  Expr<double?> get balance =>
      ExposedForCodeGen.field(this, 2, ExposedForCodeGen.real);

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

/// Extension methods for assertions on [Account] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension AccountChecks on Subject<Account> {
  /// Create assertions on [Account.accountId].
  Subject<int> get accountId => has((m) => m.accountId, 'accountId');

  /// Create assertions on [Account.accountNumber].
  Subject<String> get accountNumber =>
      has((m) => m.accountNumber, 'accountNumber');

  /// Create assertions on [Account.balance].
  Subject<double> get balance => has((m) => m.balance, 'balance');
}
