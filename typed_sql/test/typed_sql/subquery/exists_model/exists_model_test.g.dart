// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exists_model_test.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

/// Extension methods for a [Database] operating on [TestDatabase].
extension TestDatabaseSchema on Database<TestDatabase> {
  static final _$tables = [_$Item._$table];

  Table<Item> get items => $ForGeneratedCode.declareTable(this, _$Item._$table);

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

final class _$Item extends Item {
  _$Item._(this.id, this.value);

  @override
  final int id;

  @override
  final String value;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'items',
    columns: <String>['id', 'value'],
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
        overrides: [],
      ),
    ],
    primaryKey: <String>['id'],
    unique: <List<String>>[],
    foreignKeys: [],
    readRow: _$Item._$fromDatabase,
  );

  static Item? _$fromDatabase(RowReader row) {
    final id = row.readInt();
    final value = row.readString();
    if (id == null && value == null) {
      return null;
    }
    return _$Item._(id!, value!);
  }

  @override
  String toString() => 'Item(id: "$id", value: "$value")';
}

/// Extension methods for table defined in [Item].
extension TableItemExt on Table<Item> {
  /// Insert row into the `items` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<Item> insert({Expr<int>? id, required Expr<String> value}) =>
      $ForGeneratedCode.insertInto(table: this, values: [id, value]);

  /// Insert row into the `items` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<Item> insertValue({int? id, required String value}) =>
      $ForGeneratedCode.insertInto(
        table: this,
        values: [id?.asExpr, value.asExpr],
      );

  /// Bulk insert rows into the `items` table.
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
  Insert<Item> insertValuesMapped<T>(
    Iterable<T> rows, {
    int Function(T row)? id,
    required String Function(T row) value,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mapping: {'id': id, 'value': value},
  );

  /// Delete a single row from the `items` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<Item> delete(int id) =>
      $ForGeneratedCode.deleteSingle(byKey(id), _$Item._$table);
}

/// Extension methods for building queries against the `items` table.
extension QueryItemExt on Query<(Expr<Item>,)> {
  /// Lookup a single row in `items` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<Item>,)> byKey(int id) =>
      where((item) => item.id.equalsValue(id)).first;

  /// Update all rows in the `items` table matching this [Query].
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
  Update<Item> update(
    UpdateSet<Item> Function(
      Expr<Item> item,
      UpdateSet<Item> Function({Expr<int> id, Expr<String> value}) set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<Item>(
    this,
    _$Item._$table,
    (item) => updateBuilder(
      item,
      ({Expr<int>? id, Expr<String>? value}) =>
          $ForGeneratedCode.buildUpdate<Item>([id, value]),
    ),
  );

  /// Delete all rows in the `items` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<Item> delete() => $ForGeneratedCode.delete(this, _$Item._$table);
}

/// Extension methods for building point queries against the `items` table.
extension QuerySingleItemExt on QuerySingle<(Expr<Item>,)> {
  /// Update the row (if any) in the `items` table matching this
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
  UpdateSingle<Item> update(
    UpdateSet<Item> Function(
      Expr<Item> item,
      UpdateSet<Item> Function({Expr<int> id, Expr<String> value}) set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<Item>(
    this,
    _$Item._$table,
    (item) => updateBuilder(
      item,
      ({Expr<int>? id, Expr<String>? value}) =>
          $ForGeneratedCode.buildUpdate<Item>([id, value]),
    ),
  );

  /// Delete the row (if any) in the `items` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<Item> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$Item._$table);
}

/// Extension methods for expressions on a row in the `items` table.
extension ExpressionItemExt on Expr<Item> {
  Expr<int> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String> get value =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);
}

extension ExpressionNullableItemExt on Expr<Item?> {
  Expr<int?> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String?> get value =>
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

/// `Table<Item>` conflict targets for use with `.onConflict`.
enum ItemConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `id`.
  primaryKey(['id']);

  const ItemConflict(this._fields);

  final List<String> _fields;
}

extension InsertItemExt on Insert<Item> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((item, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflict<Item> onConflict(ItemConflict target) =>
      $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictItemExt on InsertOnConflict<Item> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `item` an [Expr] representing the existing row in
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
  Upsert<Item> update(
    UpdateSet<Item> Function(
      Expr<Item> item,
      Expr<Item> excluded,
      UpdateSet<Item> Function({Expr<int> id, Expr<String> value}) set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<Item>(
    this,
    (item, excluded) => updateBuilder(
      item,
      excluded,
      ({Expr<int>? id, Expr<String>? value}) =>
          $ForGeneratedCode.buildUpdate<Item>([id, value]),
    ),
  );
}

extension InsertSingleItemExt on InsertSingle<Item> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((item, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflictSingle<Item> onConflict(ItemConflict target) =>
      $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleItemExt on InsertOnConflictSingle<Item> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `item` an [Expr] representing the existing row in
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
  UpsertSingle<Item> update(
    UpdateSet<Item> Function(
      Expr<Item> item,
      Expr<Item> excluded,
      UpdateSet<Item> Function({Expr<int> id, Expr<String> value}) set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<Item>(
    this,
    (item, excluded) => updateBuilder(
      item,
      excluded,
      ({Expr<int>? id, Expr<String>? value}) =>
          $ForGeneratedCode.buildUpdate<Item>([id, value]),
    ),
  );
}

/// Extension methods for assertions on [Item] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension ItemChecks on Subject<Item> {
  /// Create assertions on [Item.id].
  Subject<int> get id => has((m) => m.id, 'id');

  /// Create assertions on [Item.value].
  Subject<String> get value => has((m) => m.value, 'value');
}
