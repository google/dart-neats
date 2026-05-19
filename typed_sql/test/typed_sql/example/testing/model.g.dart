// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

/// Extension methods for a [Database] operating on [BankVault].
extension BankVaultSchema on Database<BankVault> {
  static final _$tables = [_$Account._$table];

  Table<Account> get accounts =>
      $ForGeneratedCode.declareTable(this, _$Account._$table);

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
  Future<void> createTables() async =>
      $ForGeneratedCode.createTables(context: this, tables: _$tables);
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
String createBankVaultTables(SqlDialect dialect) => $ForGeneratedCode
    .createTableSchema(dialect: dialect, tables: BankVaultSchema._$tables);

final class _$Account extends Account {
  _$Account._(this.accountId, this.accountNumber, this.balance);

  @override
  final int accountId;

  @override
  final String accountNumber;

  @override
  final double balance;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'accounts',
    columns: <String>['accountId', 'accountNumber', 'balance'],
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
        type: $ForGeneratedCode.real,
        isNotNull: true,
        defaultValue: (kind: 'raw', value: 0.0),
        autoIncrement: false,
        overrides: [],
      ),
    ],
    primaryKey: <String>['accountId'],
    unique: <List<String>>[
      ['accountNumber'],
    ],
    foreignKeys: [],
    readRow: _$Account._$fromDatabase,
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
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [accountId, accountNumber, balance],
  );

  /// Insert row into the `accounts` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<Account> insertValue({
    int? accountId,
    required String accountNumber,
    double? balance,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [accountId?.asExpr, accountNumber.asExpr, balance?.asExpr],
  );

  /// Bulk insert rows into the `accounts` table.
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
  Insert<Account> insertValuesMapped<T>(
    Iterable<T> rows, {
    int Function(T row)? accountId,
    required String Function(T row) accountNumber,
    double Function(T row)? balance,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mapping: {
      'accountId': accountId,
      'accountNumber': accountNumber,
      'balance': balance,
    },
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
  DeleteSingle<Account> delete(int accountId) =>
      $ForGeneratedCode.deleteSingle(byKey(accountId), _$Account._$table);
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
        Expr<double> balance,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<Account>(
    this,
    _$Account._$table,
    (account) => updateBuilder(
      account,
      ({
        Expr<int>? accountId,
        Expr<String>? accountNumber,
        Expr<double>? balance,
      }) => $ForGeneratedCode.buildUpdate<Account>([
        accountId,
        accountNumber,
        balance,
      ]),
    ),
  );

  /// Lookup a single row in `accounts` table using the
  /// `accountNumber` field
  ///
  /// We know that lookup by the `accountNumber` field returns
  /// at-most one row because the [Unique] annotation in [Account].
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<Account>,)> byAccountNumber(String accountNumber) => where(
    (account) => account.accountNumber.equalsValue(accountNumber),
  ).first;

  /// Delete all rows in the `accounts` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<Account> delete() => $ForGeneratedCode.delete(this, _$Account._$table);
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
        Expr<double> balance,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<Account>(
    this,
    _$Account._$table,
    (account) => updateBuilder(
      account,
      ({
        Expr<int>? accountId,
        Expr<String>? accountNumber,
        Expr<double>? balance,
      }) => $ForGeneratedCode.buildUpdate<Account>([
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
      $ForGeneratedCode.deleteSingle(this, _$Account._$table);
}

/// Extension methods for expressions on a row in the `accounts` table.
extension ExpressionAccountExt on Expr<Account> {
  Expr<int> get accountId =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String> get accountNumber =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<double> get balance =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.real);
}

extension ExpressionNullableAccountExt on Expr<Account?> {
  Expr<int?> get accountId =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String?> get accountNumber =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<double?> get balance =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.real);

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

/// `Table<Account>` conflict targets for use with `.onConflict`.
enum AccountConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `accountId`.
  primaryKey(['accountId']),

  /// `accountNumber` conflict.
  ///
  /// Due to violation of the `UNIQUE` constraint on
  /// `accountNumber`.
  ///
  /// Thus, the conflicting row has matching values for these fields.
  accountNumber(['accountNumber']);

  const AccountConflict(this._fields);

  final List<String> _fields;
}

extension InsertAccountExt on Insert<Account> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((account, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflict<Account> onConflict(AccountConflict target) =>
      $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictAccountExt on InsertOnConflict<Account> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `account` an [Expr] representing the existing row in
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
  Upsert<Account> update(
    UpdateSet<Account> Function(
      Expr<Account> account,
      Expr<Account> excluded,
      UpdateSet<Account> Function({
        Expr<int> accountId,
        Expr<String> accountNumber,
        Expr<double> balance,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<Account>(
    this,
    (account, excluded) => updateBuilder(
      account,
      excluded,
      ({
        Expr<int>? accountId,
        Expr<String>? accountNumber,
        Expr<double>? balance,
      }) => $ForGeneratedCode.buildUpdate<Account>([
        accountId,
        accountNumber,
        balance,
      ]),
    ),
  );
}

extension InsertSingleAccountExt on InsertSingle<Account> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((account, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflictSingle<Account> onConflict(AccountConflict target) =>
      $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleAccountExt on InsertOnConflictSingle<Account> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `account` an [Expr] representing the existing row in
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
  UpsertSingle<Account> update(
    UpdateSet<Account> Function(
      Expr<Account> account,
      Expr<Account> excluded,
      UpdateSet<Account> Function({
        Expr<int> accountId,
        Expr<String> accountNumber,
        Expr<double> balance,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<Account>(
    this,
    (account, excluded) => updateBuilder(
      account,
      excluded,
      ({
        Expr<int>? accountId,
        Expr<String>? accountNumber,
        Expr<double>? balance,
      }) => $ForGeneratedCode.buildUpdate<Account>([
        accountId,
        accountNumber,
        balance,
      ]),
    ),
  );
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
