// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hash_index_test.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

/// Extension methods for a [Database] operating on [AccountDatabase].
extension AccountDatabaseSchema on Database<AccountDatabase> {
  static final _$tables = [_$Account._$table];

  Table<Account> get accounts =>
      $ForGeneratedCode.declareTable(this, _$Account._$table);

  /// Create tables defined in [AccountDatabase].
  ///
  /// Calling this on an empty database will create the tables
  /// defined in [AccountDatabase]. In production it's often better to
  /// use [createAccountDatabaseTables] and manage migrations using
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

/// Get SQL [DDL statements][1] for tables defined in [AccountDatabase].
///
/// This returns a SQL script with multiple DDL statements separated by `;`
/// using the specified [dialect].
///
/// Executing these statements in an empty database will create the tables
/// defined in [AccountDatabase]. In practice, this method is often used for
/// printing the DDL statements, such that migrations can be managed by
/// external tools.
///
/// [1]: https://en.wikipedia.org/wiki/Data_definition_language
String createAccountDatabaseTables(SqlDialect dialect) =>
    $ForGeneratedCode.createTableSchema(
      dialect: dialect,
      tables: AccountDatabaseSchema._$tables,
    );

final class _$Account extends Account {
  _$Account._(this.id, this.email);

  @override
  final int id;

  @override
  final String email;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'accounts',
    columns: <String>['id', 'email'],
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
    ],
    primaryKey: <String>['id'],
    unique: <List<String>>[],
    foreignKeys: [],
    indexes: [
      $ForGeneratedCode.indexDefinition(
        name: null,
        sqlName: null,
        columns: ['email'],
        method: .hash,
        covering: [],
      ),
    ],
    readRow: _$Account._$fromDatabase,
  );

  static Account? _$fromDatabase(RowReader row) {
    final id = row.readInt();
    final email = row.readString();
    if (id == null && email == null) {
      return null;
    }
    return _$Account._(id!, email!);
  }

  @override
  String toString() => 'Account(id: "$id", email: "$email")';
}

/// Extension methods for table defined in [Account].
extension TableAccountExt on Table<Account> {
  /// Insert row into the `accounts` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<Account> insert({Expr<int>? id, required Expr<String> email}) =>
      $ForGeneratedCode.insertInto(table: this, values: [id, email]);

  /// Insert row into the `accounts` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<Account> insertValue({int? id, required String email}) =>
      $ForGeneratedCode.insertInto(
        table: this,
        values: [id?.asExpr, email.asExpr],
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
    int Function(T row)? id,
    required String Function(T row) email,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mappings: [id, email],
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
  DeleteSingle<Account> delete(int id) =>
      $ForGeneratedCode.deleteSingle(byKey(id), _$Account._$table);
}

/// Extension methods for building queries against the `accounts` table.
extension QueryAccountExt on Query<(Expr<Account>,)> {
  /// Lookup a single row in `accounts` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<Account>,)> byKey(int id) =>
      where((account) => account.id.equalsValue(id)).first;

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
      UpdateSet<Account> Function({Expr<int> id, Expr<String> email}) set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<Account>(
    this,
    _$Account._$table,
    (account) => updateBuilder(
      account,
      ({Expr<int>? id, Expr<String>? email}) =>
          $ForGeneratedCode.buildUpdate<Account>([id, email]),
    ),
  );

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
      UpdateSet<Account> Function({Expr<int> id, Expr<String> email}) set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<Account>(
    this,
    _$Account._$table,
    (account) => updateBuilder(
      account,
      ({Expr<int>? id, Expr<String>? email}) =>
          $ForGeneratedCode.buildUpdate<Account>([id, email]),
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
  Expr<int> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String> get email =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);
}

extension ExpressionNullableAccountExt on Expr<Account?> {
  Expr<int?> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String?> get email =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  /// Check if the row is not `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNotNull() => id.isNotNull();

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
  /// `id`.
  primaryKey(['id']);

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
      UpdateSet<Account> Function({Expr<int> id, Expr<String> email}) set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<Account>(
    this,
    (account, excluded) => updateBuilder(
      account,
      excluded,
      ({Expr<int>? id, Expr<String>? email}) =>
          $ForGeneratedCode.buildUpdate<Account>([id, email]),
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
      UpdateSet<Account> Function({Expr<int> id, Expr<String> email}) set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<Account>(
    this,
    (account, excluded) => updateBuilder(
      account,
      excluded,
      ({Expr<int>? id, Expr<String>? email}) =>
          $ForGeneratedCode.buildUpdate<Account>([id, email]),
    ),
  );
}

/// Extension methods for assertions on [Account] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension AccountChecks on Subject<Account> {
  /// Create assertions on [Account.id].
  Subject<int> get id => has((m) => m.id, 'id');

  /// Create assertions on [Account.email].
  Subject<String> get email => has((m) => m.email, 'email');
}
