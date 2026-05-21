// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insert_values_mapped_test.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

/// Extension methods for a [Database] operating on [MappedDatabase].
extension MappedDatabaseSchema on Database<MappedDatabase> {
  static final _$tables = [_$MappedItem._$table];

  Table<MappedItem> get mappedItems =>
      $ForGeneratedCode.declareTable(this, _$MappedItem._$table);

  /// Create tables defined in [MappedDatabase].
  ///
  /// Calling this on an empty database will create the tables
  /// defined in [MappedDatabase]. In production it's often better to
  /// use [createMappedDatabaseTables] and manage migrations using
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

/// Get SQL [DDL statements][1] for tables defined in [MappedDatabase].
///
/// This returns a SQL script with multiple DDL statements separated by `;`
/// using the specified [dialect].
///
/// Executing these statements in an empty database will create the tables
/// defined in [MappedDatabase]. In practice, this method is often used for
/// printing the DDL statements, such that migrations can be managed by
/// external tools.
///
/// [1]: https://en.wikipedia.org/wiki/Data_definition_language
String createMappedDatabaseTables(SqlDialect dialect) => $ForGeneratedCode
    .createTableSchema(dialect: dialect, tables: MappedDatabaseSchema._$tables);

final class _$MappedItem extends MappedItem {
  _$MappedItem._(this.id, this.value, this.count, this.nullableValue);

  @override
  final int id;

  @override
  final String value;

  @override
  final int count;

  @override
  final String? nullableValue;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'mappedItems',
    columns: <String>['id', 'value', 'count', 'nullableValue'],
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
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.integer,
        isNotNull: true,
        defaultValue: (kind: 'raw', value: 0),
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: false,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
    ],
    primaryKey: <String>['id'],
    unique: <List<String>>[],
    foreignKeys: [],
    readRow: _$MappedItem._$fromDatabase,
  );

  static MappedItem? _$fromDatabase(RowReader row) {
    final id = row.readInt();
    final value = row.readString();
    final count = row.readInt();
    final nullableValue = row.readString();
    if (id == null && value == null && count == null && nullableValue == null) {
      return null;
    }
    return _$MappedItem._(id!, value!, count!, nullableValue);
  }

  @override
  String toString() =>
      'MappedItem(id: "$id", value: "$value", count: "$count", nullableValue: "$nullableValue")';
}

/// Extension methods for table defined in [MappedItem].
extension TableMappedItemExt on Table<MappedItem> {
  /// Insert row into the `mappedItems` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<MappedItem> insert({
    Expr<int>? id,
    required Expr<String> value,
    Expr<int>? count,
    Expr<String?>? nullableValue,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [id, value, count, nullableValue],
  );

  /// Insert row into the `mappedItems` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<MappedItem> insertValue({
    int? id,
    required String value,
    int? count,
    String? nullableValue,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [id?.asExpr, value.asExpr, count?.asExpr, nullableValue.asExpr],
  );

  /// Bulk insert rows into the `mappedItems` table.
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
  Insert<MappedItem> insertValuesMapped<T>(
    Iterable<T> rows, {
    int Function(T row)? id,
    required String Function(T row) value,
    int Function(T row)? count,
    String? Function(T row)? nullableValue,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mappings: [id, value, count, nullableValue],
  );

  /// Delete a single row from the `mappedItems` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<MappedItem> delete(int id) =>
      $ForGeneratedCode.deleteSingle(byKey(id), _$MappedItem._$table);
}

/// Extension methods for building queries against the `mappedItems` table.
extension QueryMappedItemExt on Query<(Expr<MappedItem>,)> {
  /// Lookup a single row in `mappedItems` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<MappedItem>,)> byKey(int id) =>
      where((mappedItem) => mappedItem.id.equalsValue(id)).first;

  /// Update all rows in the `mappedItems` table matching this [Query].
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
  Update<MappedItem> update(
    UpdateSet<MappedItem> Function(
      Expr<MappedItem> mappedItem,
      UpdateSet<MappedItem> Function({
        Expr<int> id,
        Expr<String> value,
        Expr<int> count,
        Expr<String?> nullableValue,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<MappedItem>(
    this,
    _$MappedItem._$table,
    (mappedItem) => updateBuilder(
      mappedItem,
      ({
        Expr<int>? id,
        Expr<String>? value,
        Expr<int>? count,
        Expr<String?>? nullableValue,
      }) => $ForGeneratedCode.buildUpdate<MappedItem>([
        id,
        value,
        count,
        nullableValue,
      ]),
    ),
  );

  /// Delete all rows in the `mappedItems` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<MappedItem> delete() =>
      $ForGeneratedCode.delete(this, _$MappedItem._$table);
}

/// Extension methods for building point queries against the `mappedItems` table.
extension QuerySingleMappedItemExt on QuerySingle<(Expr<MappedItem>,)> {
  /// Update the row (if any) in the `mappedItems` table matching this
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
  UpdateSingle<MappedItem> update(
    UpdateSet<MappedItem> Function(
      Expr<MappedItem> mappedItem,
      UpdateSet<MappedItem> Function({
        Expr<int> id,
        Expr<String> value,
        Expr<int> count,
        Expr<String?> nullableValue,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<MappedItem>(
    this,
    _$MappedItem._$table,
    (mappedItem) => updateBuilder(
      mappedItem,
      ({
        Expr<int>? id,
        Expr<String>? value,
        Expr<int>? count,
        Expr<String?>? nullableValue,
      }) => $ForGeneratedCode.buildUpdate<MappedItem>([
        id,
        value,
        count,
        nullableValue,
      ]),
    ),
  );

  /// Delete the row (if any) in the `mappedItems` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<MappedItem> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$MappedItem._$table);
}

/// Extension methods for expressions on a row in the `mappedItems` table.
extension ExpressionMappedItemExt on Expr<MappedItem> {
  Expr<int> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String> get value =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<int> get count =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.integer);

  Expr<String?> get nullableValue =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.text);
}

extension ExpressionNullableMappedItemExt on Expr<MappedItem?> {
  Expr<int?> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String?> get value =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<int?> get count =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.integer);

  Expr<String?> get nullableValue =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.text);

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

/// `Table<MappedItem>` conflict targets for use with `.onConflict`.
enum MappedItemConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `id`.
  primaryKey(['id']);

  const MappedItemConflict(this._fields);

  final List<String> _fields;
}

extension InsertMappedItemExt on Insert<MappedItem> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((mappedItem, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflict<MappedItem> onConflict(MappedItemConflict target) =>
      $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictMappedItemExt on InsertOnConflict<MappedItem> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `mappedItem` an [Expr] representing the existing row in
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
  Upsert<MappedItem> update(
    UpdateSet<MappedItem> Function(
      Expr<MappedItem> mappedItem,
      Expr<MappedItem> excluded,
      UpdateSet<MappedItem> Function({
        Expr<int> id,
        Expr<String> value,
        Expr<int> count,
        Expr<String?> nullableValue,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<MappedItem>(
    this,
    (mappedItem, excluded) => updateBuilder(
      mappedItem,
      excluded,
      ({
        Expr<int>? id,
        Expr<String>? value,
        Expr<int>? count,
        Expr<String?>? nullableValue,
      }) => $ForGeneratedCode.buildUpdate<MappedItem>([
        id,
        value,
        count,
        nullableValue,
      ]),
    ),
  );
}

extension InsertSingleMappedItemExt on InsertSingle<MappedItem> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((mappedItem, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflictSingle<MappedItem> onConflict(MappedItemConflict target) =>
      $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleMappedItemExt
    on InsertOnConflictSingle<MappedItem> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `mappedItem` an [Expr] representing the existing row in
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
  UpsertSingle<MappedItem> update(
    UpdateSet<MappedItem> Function(
      Expr<MappedItem> mappedItem,
      Expr<MappedItem> excluded,
      UpdateSet<MappedItem> Function({
        Expr<int> id,
        Expr<String> value,
        Expr<int> count,
        Expr<String?> nullableValue,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<MappedItem>(
    this,
    (mappedItem, excluded) => updateBuilder(
      mappedItem,
      excluded,
      ({
        Expr<int>? id,
        Expr<String>? value,
        Expr<int>? count,
        Expr<String?>? nullableValue,
      }) => $ForGeneratedCode.buildUpdate<MappedItem>([
        id,
        value,
        count,
        nullableValue,
      ]),
    ),
  );
}

/// Extension methods for assertions on [MappedItem] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension MappedItemChecks on Subject<MappedItem> {
  /// Create assertions on [MappedItem.id].
  Subject<int> get id => has((m) => m.id, 'id');

  /// Create assertions on [MappedItem.value].
  Subject<String> get value => has((m) => m.value, 'value');

  /// Create assertions on [MappedItem.count].
  Subject<int> get count => has((m) => m.count, 'count');

  /// Create assertions on [MappedItem.nullableValue].
  Subject<String?> get nullableValue =>
      has((m) => m.nullableValue, 'nullableValue');
}
