// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_insert_test.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

/// Extension methods for a [Database] operating on [JsonInsertDatabase].
extension JsonInsertDatabaseSchema on Database<JsonInsertDatabase> {
  static final _$tables = [_$JsonItem._$table];

  Table<JsonItem> get jsonItems =>
      $ForGeneratedCode.declareTable(this, _$JsonItem._$table);

  /// Create tables defined in [JsonInsertDatabase].
  ///
  /// Calling this on an empty database will create the tables
  /// defined in [JsonInsertDatabase]. In production it's often better to
  /// use [createJsonInsertDatabaseTables] and manage migrations using
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

/// Get SQL [DDL statements][1] for tables defined in [JsonInsertDatabase].
///
/// This returns a SQL script with multiple DDL statements separated by `;`
/// using the specified [dialect].
///
/// Executing these statements in an empty database will create the tables
/// defined in [JsonInsertDatabase]. In practice, this method is often used for
/// printing the DDL statements, such that migrations can be managed by
/// external tools.
///
/// [1]: https://en.wikipedia.org/wiki/Data_definition_language
String createJsonInsertDatabaseTables(SqlDialect dialect) =>
    $ForGeneratedCode.createTableSchema(
      dialect: dialect,
      tables: JsonInsertDatabaseSchema._$tables,
    );

final class _$JsonItem extends JsonItem {
  _$JsonItem._(this.id, this.data);

  @override
  final int id;

  @override
  final JsonValue data;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'jsonItems',
    columns: <String>['id', 'data'],
    columnInfo: [
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.integer,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: true,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.jsonValue,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
    ],
    primaryKey: <String>['id'],
    unique: <List<String>>[],
    foreignKeys: [],
    readRow: _$JsonItem._$fromDatabase,
  );

  static JsonItem? _$fromDatabase(RowReader row) {
    final id = row.readInt();
    final data = row.readJsonValue();
    if (id == null && data == null) {
      return null;
    }
    return _$JsonItem._(id!, data!);
  }

  @override
  String toString() => 'JsonItem(id: "$id", data: "$data")';
}

/// Extension methods for table defined in [JsonItem].
extension TableJsonItemExt on Table<JsonItem> {
  /// Insert row into the `jsonItems` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<JsonItem> insert({
    Expr<int>? id,
    required Expr<JsonValue> data,
  }) => $ForGeneratedCode.insertInto(table: this, values: [id, data]);

  /// Insert row into the `jsonItems` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<JsonItem> insertValue({int? id, required JsonValue data}) =>
      $ForGeneratedCode.insertInto(
        table: this,
        values: [id?.asExpr, data.asExpr],
      );

  /// Bulk insert rows into the `jsonItems` table.
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
  Insert<JsonItem> insertValuesMapped<T>(
    Iterable<T> rows, {
    int Function(T row)? id,
    required JsonValue Function(T row) data,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mappings: [id, data],
  );

  /// Delete a single row from the `jsonItems` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<JsonItem> delete(int id) =>
      $ForGeneratedCode.deleteSingle(byKey(id), _$JsonItem._$table);
}

/// Extension methods for building queries against the `jsonItems` table.
extension QueryJsonItemExt on Query<(Expr<JsonItem>,)> {
  /// Lookup a single row in `jsonItems` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<JsonItem>,)> byKey(int id) =>
      where((jsonItem) => jsonItem.id.equalsValue(id)).first;

  /// Update all rows in the `jsonItems` table matching this [Query].
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
  Update<JsonItem> update(
    UpdateSet<JsonItem> Function(
      Expr<JsonItem> jsonItem,
      UpdateSet<JsonItem> Function({Expr<int> id, Expr<JsonValue> data}) set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<JsonItem>(
    this,
    _$JsonItem._$table,
    (jsonItem) => updateBuilder(
      jsonItem,
      ({Expr<int>? id, Expr<JsonValue>? data}) =>
          $ForGeneratedCode.buildUpdate<JsonItem>([id, data]),
    ),
  );

  /// Delete all rows in the `jsonItems` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<JsonItem> delete() =>
      $ForGeneratedCode.delete(this, _$JsonItem._$table);
}

/// Extension methods for building point queries against the `jsonItems` table.
extension QuerySingleJsonItemExt on QuerySingle<(Expr<JsonItem>,)> {
  /// Update the row (if any) in the `jsonItems` table matching this
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
  UpdateSingle<JsonItem> update(
    UpdateSet<JsonItem> Function(
      Expr<JsonItem> jsonItem,
      UpdateSet<JsonItem> Function({Expr<int> id, Expr<JsonValue> data}) set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<JsonItem>(
    this,
    _$JsonItem._$table,
    (jsonItem) => updateBuilder(
      jsonItem,
      ({Expr<int>? id, Expr<JsonValue>? data}) =>
          $ForGeneratedCode.buildUpdate<JsonItem>([id, data]),
    ),
  );

  /// Delete the row (if any) in the `jsonItems` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<JsonItem> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$JsonItem._$table);
}

/// Extension methods for expressions on a row in the `jsonItems` table.
extension ExpressionJsonItemExt on Expr<JsonItem> {
  Expr<int> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<JsonValue> get data =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.jsonValue);
}

extension ExpressionNullableJsonItemExt on Expr<JsonItem?> {
  Expr<int?> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<JsonValue?> get data =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.jsonValue);

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

/// `Table<JsonItem>` conflict targets for use with `.onConflict`.
enum JsonItemConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `id`.
  primaryKey(['id']);

  const JsonItemConflict(this._fields);

  final List<String> _fields;
}

extension InsertJsonItemExt on Insert<JsonItem> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((jsonItem, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflict<JsonItem> onConflict(JsonItemConflict target) =>
      $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictJsonItemExt on InsertOnConflict<JsonItem> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `jsonItem` an [Expr] representing the existing row in
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
  Upsert<JsonItem> update(
    UpdateSet<JsonItem> Function(
      Expr<JsonItem> jsonItem,
      Expr<JsonItem> excluded,
      UpdateSet<JsonItem> Function({Expr<int> id, Expr<JsonValue> data}) set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<JsonItem>(
    this,
    (jsonItem, excluded) => updateBuilder(
      jsonItem,
      excluded,
      ({Expr<int>? id, Expr<JsonValue>? data}) =>
          $ForGeneratedCode.buildUpdate<JsonItem>([id, data]),
    ),
  );
}

extension InsertSingleJsonItemExt on InsertSingle<JsonItem> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((jsonItem, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflictSingle<JsonItem> onConflict(JsonItemConflict target) =>
      $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleJsonItemExt
    on InsertOnConflictSingle<JsonItem> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `jsonItem` an [Expr] representing the existing row in
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
  UpsertSingle<JsonItem> update(
    UpdateSet<JsonItem> Function(
      Expr<JsonItem> jsonItem,
      Expr<JsonItem> excluded,
      UpdateSet<JsonItem> Function({Expr<int> id, Expr<JsonValue> data}) set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<JsonItem>(
    this,
    (jsonItem, excluded) => updateBuilder(
      jsonItem,
      excluded,
      ({Expr<int>? id, Expr<JsonValue>? data}) =>
          $ForGeneratedCode.buildUpdate<JsonItem>([id, data]),
    ),
  );
}

/// Extension methods for assertions on [JsonItem] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension JsonItemChecks on Subject<JsonItem> {
  /// Create assertions on [JsonItem.id].
  Subject<int> get id => has((m) => m.id, 'id');

  /// Create assertions on [JsonItem.data].
  Subject<JsonValue> get data => has((m) => m.data, 'data');
}
