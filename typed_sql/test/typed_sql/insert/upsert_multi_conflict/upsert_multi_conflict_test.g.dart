// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upsert_multi_conflict_test.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

/// Extension methods for a [Database] operating on [MultiConflictDatabase].
extension MultiConflictDatabaseSchema on Database<MultiConflictDatabase> {
  static final _$tables = [_$MultiItem._$table];

  Table<MultiItem> get multiItems =>
      $ForGeneratedCode.declareTable(this, _$MultiItem._$table);

  /// Create tables defined in [MultiConflictDatabase].
  ///
  /// Calling this on an empty database will create the tables
  /// defined in [MultiConflictDatabase]. In production it's often better to
  /// use [createMultiConflictDatabaseTables] and manage migrations using
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

/// Get SQL [DDL statements][1] for tables defined in [MultiConflictDatabase].
///
/// This returns a SQL script with multiple DDL statements separated by `;`
/// using the specified [dialect].
///
/// Executing these statements in an empty database will create the tables
/// defined in [MultiConflictDatabase]. In practice, this method is often used for
/// printing the DDL statements, such that migrations can be managed by
/// external tools.
///
/// [1]: https://en.wikipedia.org/wiki/Data_definition_language
String createMultiConflictDatabaseTables(SqlDialect dialect) =>
    $ForGeneratedCode.createTableSchema(
      dialect: dialect,
      tables: MultiConflictDatabaseSchema._$tables,
    );

final class _$MultiItem extends MultiItem {
  _$MultiItem._(this.id, this.name, this.email, this.value);

  @override
  final int id;

  @override
  final String name;

  @override
  final String email;

  @override
  final int value;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'multiItems',
    columns: <String>['id', 'name', 'email', 'value'],
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
        type: $ForGeneratedCode.integer,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
    ],
    primaryKey: <String>['id'],
    unique: <List<String>>[
      ['name'],
      ['email'],
    ],
    foreignKeys: [],
    readRow: _$MultiItem._$fromDatabase,
  );

  static MultiItem? _$fromDatabase(RowReader row) {
    final id = row.readInt();
    final name = row.readString();
    final email = row.readString();
    final value = row.readInt();
    if (id == null && name == null && email == null && value == null) {
      return null;
    }
    return _$MultiItem._(id!, name!, email!, value!);
  }

  @override
  String toString() =>
      'MultiItem(id: "$id", name: "$name", email: "$email", value: "$value")';
}

/// Extension methods for table defined in [MultiItem].
extension TableMultiItemExt on Table<MultiItem> {
  /// Insert row into the `multiItems` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<MultiItem> insert({
    Expr<int>? id,
    required Expr<String> name,
    required Expr<String> email,
    required Expr<int> value,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [id, name, email, value],
  );

  /// Insert row into the `multiItems` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<MultiItem> insertValue({
    int? id,
    required String name,
    required String email,
    required int value,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [id?.asExpr, name.asExpr, email.asExpr, value.asExpr],
  );

  /// Bulk insert rows into the `multiItems` table.
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
  Insert<MultiItem> insertValuesMapped<T>(
    Iterable<T> rows, {
    int Function(T row)? id,
    required String Function(T row) name,
    required String Function(T row) email,
    required int Function(T row) value,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mapping: {'id': id, 'name': name, 'email': email, 'value': value},
  );

  /// Delete a single row from the `multiItems` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<MultiItem> delete(int id) =>
      $ForGeneratedCode.deleteSingle(byKey(id), _$MultiItem._$table);
}

/// Extension methods for building queries against the `multiItems` table.
extension QueryMultiItemExt on Query<(Expr<MultiItem>,)> {
  /// Lookup a single row in `multiItems` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<MultiItem>,)> byKey(int id) =>
      where((multiItem) => multiItem.id.equalsValue(id)).first;

  /// Update all rows in the `multiItems` table matching this [Query].
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
  Update<MultiItem> update(
    UpdateSet<MultiItem> Function(
      Expr<MultiItem> multiItem,
      UpdateSet<MultiItem> Function({
        Expr<int> id,
        Expr<String> name,
        Expr<String> email,
        Expr<int> value,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<MultiItem>(
    this,
    _$MultiItem._$table,
    (multiItem) => updateBuilder(
      multiItem,
      ({
        Expr<int>? id,
        Expr<String>? name,
        Expr<String>? email,
        Expr<int>? value,
      }) => $ForGeneratedCode.buildUpdate<MultiItem>([id, name, email, value]),
    ),
  );

  /// Lookup a single row in `multiItems` table using the
  /// `name` field
  ///
  /// We know that lookup by the `name` field returns
  /// at-most one row because the [Unique] annotation in [MultiItem].
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<MultiItem>,)> byName(String name) =>
      where((multiItem) => multiItem.name.equalsValue(name)).first;

  /// Lookup a single row in `multiItems` table using the
  /// `email` field
  ///
  /// We know that lookup by the `email` field returns
  /// at-most one row because the [Unique] annotation in [MultiItem].
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<MultiItem>,)> byEmail(String email) =>
      where((multiItem) => multiItem.email.equalsValue(email)).first;

  /// Delete all rows in the `multiItems` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<MultiItem> delete() =>
      $ForGeneratedCode.delete(this, _$MultiItem._$table);
}

/// Extension methods for building point queries against the `multiItems` table.
extension QuerySingleMultiItemExt on QuerySingle<(Expr<MultiItem>,)> {
  /// Update the row (if any) in the `multiItems` table matching this
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
  UpdateSingle<MultiItem> update(
    UpdateSet<MultiItem> Function(
      Expr<MultiItem> multiItem,
      UpdateSet<MultiItem> Function({
        Expr<int> id,
        Expr<String> name,
        Expr<String> email,
        Expr<int> value,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<MultiItem>(
    this,
    _$MultiItem._$table,
    (multiItem) => updateBuilder(
      multiItem,
      ({
        Expr<int>? id,
        Expr<String>? name,
        Expr<String>? email,
        Expr<int>? value,
      }) => $ForGeneratedCode.buildUpdate<MultiItem>([id, name, email, value]),
    ),
  );

  /// Delete the row (if any) in the `multiItems` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<MultiItem> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$MultiItem._$table);
}

/// Extension methods for expressions on a row in the `multiItems` table.
extension ExpressionMultiItemExt on Expr<MultiItem> {
  Expr<int> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String> get name =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<String> get email =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  Expr<int> get value =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.integer);
}

extension ExpressionNullableMultiItemExt on Expr<MultiItem?> {
  Expr<int?> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String?> get name =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<String?> get email =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  Expr<int?> get value =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.integer);

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

/// `Table<MultiItem>` conflict targets for use with `.onConflict`.
enum MultiItemConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `id`.
  primaryKey(['id']),

  /// `name` conflict.
  ///
  /// Due to violation of the `UNIQUE` constraint on
  /// `name`.
  ///
  /// Thus, the conflicting row has matching values for these fields.
  name(['name']),

  /// `email` conflict.
  ///
  /// Due to violation of the `UNIQUE` constraint on
  /// `email`.
  ///
  /// Thus, the conflicting row has matching values for these fields.
  email(['email']);

  const MultiItemConflict(this._fields);

  final List<String> _fields;
}

extension InsertMultiItemExt on Insert<MultiItem> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((multiItem, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflict<MultiItem> onConflict(MultiItemConflict target) =>
      $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictMultiItemExt on InsertOnConflict<MultiItem> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `multiItem` an [Expr] representing the existing row in
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
  Upsert<MultiItem> update(
    UpdateSet<MultiItem> Function(
      Expr<MultiItem> multiItem,
      Expr<MultiItem> excluded,
      UpdateSet<MultiItem> Function({
        Expr<int> id,
        Expr<String> name,
        Expr<String> email,
        Expr<int> value,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<MultiItem>(
    this,
    (multiItem, excluded) => updateBuilder(
      multiItem,
      excluded,
      ({
        Expr<int>? id,
        Expr<String>? name,
        Expr<String>? email,
        Expr<int>? value,
      }) => $ForGeneratedCode.buildUpdate<MultiItem>([id, name, email, value]),
    ),
  );
}

extension InsertSingleMultiItemExt on InsertSingle<MultiItem> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((multiItem, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflictSingle<MultiItem> onConflict(MultiItemConflict target) =>
      $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleMultiItemExt
    on InsertOnConflictSingle<MultiItem> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `multiItem` an [Expr] representing the existing row in
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
  UpsertSingle<MultiItem> update(
    UpdateSet<MultiItem> Function(
      Expr<MultiItem> multiItem,
      Expr<MultiItem> excluded,
      UpdateSet<MultiItem> Function({
        Expr<int> id,
        Expr<String> name,
        Expr<String> email,
        Expr<int> value,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<MultiItem>(
    this,
    (multiItem, excluded) => updateBuilder(
      multiItem,
      excluded,
      ({
        Expr<int>? id,
        Expr<String>? name,
        Expr<String>? email,
        Expr<int>? value,
      }) => $ForGeneratedCode.buildUpdate<MultiItem>([id, name, email, value]),
    ),
  );
}

/// Extension methods for assertions on [MultiItem] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension MultiItemChecks on Subject<MultiItem> {
  /// Create assertions on [MultiItem.id].
  Subject<int> get id => has((m) => m.id, 'id');

  /// Create assertions on [MultiItem.name].
  Subject<String> get name => has((m) => m.name, 'name');

  /// Create assertions on [MultiItem.email].
  Subject<String> get email => has((m) => m.email, 'email');

  /// Create assertions on [MultiItem.value].
  Subject<int> get value => has((m) => m.value, 'value');
}
