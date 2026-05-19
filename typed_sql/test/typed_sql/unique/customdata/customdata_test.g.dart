// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customdata_test.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

/// Extension methods for a [Database] operating on [CustomDataDatabase].
extension CustomDataDatabaseSchema on Database<CustomDataDatabase> {
  static final _$tables = [_$CustomDataItem._$table];

  Table<CustomDataItem> get customDataItems =>
      $ForGeneratedCode.declareTable(this, _$CustomDataItem._$table);

  /// Create tables defined in [CustomDataDatabase].
  ///
  /// Calling this on an empty database will create the tables
  /// defined in [CustomDataDatabase]. In production it's often better to
  /// use [createCustomDataDatabaseTables] and manage migrations using
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

/// Get SQL [DDL statements][1] for tables defined in [CustomDataDatabase].
///
/// This returns a SQL script with multiple DDL statements separated by `;`
/// using the specified [dialect].
///
/// Executing these statements in an empty database will create the tables
/// defined in [CustomDataDatabase]. In practice, this method is often used for
/// printing the DDL statements, such that migrations can be managed by
/// external tools.
///
/// [1]: https://en.wikipedia.org/wiki/Data_definition_language
String createCustomDataDatabaseTables(SqlDialect dialect) =>
    $ForGeneratedCode.createTableSchema(
      dialect: dialect,
      tables: CustomDataDatabaseSchema._$tables,
    );

final class _$CustomDataItem extends CustomDataItem {
  _$CustomDataItem._(this.id, this.stringVal);

  @override
  final CustomIntType id;

  @override
  final CustomStringType stringVal;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'customDataItems',
    columns: <String>['id', 'stringVal'],
    columnInfo: [
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
    primaryKey: <String>['id'],
    unique: <List<String>>[
      ['stringVal'],
    ],
    foreignKeys: [],
    readRow: _$CustomDataItem._$fromDatabase,
  );

  static CustomDataItem? _$fromDatabase(RowReader row) {
    final id = $ForGeneratedCode.customDataTypeOrNull(
      row.readInt(),
      CustomIntType.fromDatabase,
    );
    final stringVal = $ForGeneratedCode.customDataTypeOrNull(
      row.readString(),
      CustomStringType.fromDatabase,
    );
    if (id == null && stringVal == null) {
      return null;
    }
    return _$CustomDataItem._(id!, stringVal!);
  }

  @override
  String toString() => 'CustomDataItem(id: "$id", stringVal: "$stringVal")';
}

/// Extension methods for table defined in [CustomDataItem].
extension TableCustomDataItemExt on Table<CustomDataItem> {
  /// Insert row into the `customDataItems` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<CustomDataItem> insert({
    required Expr<CustomIntType> id,
    required Expr<CustomStringType> stringVal,
  }) => $ForGeneratedCode.insertInto(table: this, values: [id, stringVal]);

  /// Insert row into the `customDataItems` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<CustomDataItem> insertValue({
    required CustomIntType id,
    required CustomStringType stringVal,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [id.asExpr, stringVal.asExpr],
  );

  /// Bulk insert rows into the `customDataItems` table.
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
  Insert<CustomDataItem> insertValuesMapped<T>(
    Iterable<T> rows, {
    required CustomIntType Function(T row) id,
    required CustomStringType Function(T row) stringVal,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mappings: [(T v) => id(v).toDatabase(), (T v) => stringVal(v).toDatabase()],
  );

  /// Delete a single row from the `customDataItems` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<CustomDataItem> delete(CustomIntType id) =>
      $ForGeneratedCode.deleteSingle(byKey(id), _$CustomDataItem._$table);
}

/// Extension methods for building queries against the `customDataItems` table.
extension QueryCustomDataItemExt on Query<(Expr<CustomDataItem>,)> {
  /// Lookup a single row in `customDataItems` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<CustomDataItem>,)> byKey(CustomIntType id) => where(
    (customDataItem) =>
        customDataItem.id.asEncoded().equalsValue(id.toDatabase()),
  ).first;

  /// Update all rows in the `customDataItems` table matching this [Query].
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
  Update<CustomDataItem> update(
    UpdateSet<CustomDataItem> Function(
      Expr<CustomDataItem> customDataItem,
      UpdateSet<CustomDataItem> Function({
        Expr<CustomIntType> id,
        Expr<CustomStringType> stringVal,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<CustomDataItem>(
    this,
    _$CustomDataItem._$table,
    (customDataItem) => updateBuilder(
      customDataItem,
      ({Expr<CustomIntType>? id, Expr<CustomStringType>? stringVal}) =>
          $ForGeneratedCode.buildUpdate<CustomDataItem>([id, stringVal]),
    ),
  );

  /// Lookup a single row in `customDataItems` table using the
  /// `stringVal` field
  ///
  /// We know that lookup by the `stringVal` field returns
  /// at-most one row because the [Unique] annotation in [CustomDataItem].
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<CustomDataItem>,)> byStringVal(
    CustomStringType stringVal,
  ) => where(
    (customDataItem) => customDataItem.stringVal.asEncoded().equalsValue(
      stringVal.toDatabase(),
    ),
  ).first;

  /// Delete all rows in the `customDataItems` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<CustomDataItem> delete() =>
      $ForGeneratedCode.delete(this, _$CustomDataItem._$table);
}

/// Extension methods for building point queries against the `customDataItems` table.
extension QuerySingleCustomDataItemExt on QuerySingle<(Expr<CustomDataItem>,)> {
  /// Update the row (if any) in the `customDataItems` table matching this
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
  UpdateSingle<CustomDataItem> update(
    UpdateSet<CustomDataItem> Function(
      Expr<CustomDataItem> customDataItem,
      UpdateSet<CustomDataItem> Function({
        Expr<CustomIntType> id,
        Expr<CustomStringType> stringVal,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<CustomDataItem>(
    this,
    _$CustomDataItem._$table,
    (customDataItem) => updateBuilder(
      customDataItem,
      ({Expr<CustomIntType>? id, Expr<CustomStringType>? stringVal}) =>
          $ForGeneratedCode.buildUpdate<CustomDataItem>([id, stringVal]),
    ),
  );

  /// Delete the row (if any) in the `customDataItems` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<CustomDataItem> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$CustomDataItem._$table);
}

/// Extension methods for expressions on a row in the `customDataItems` table.
extension ExpressionCustomDataItemExt on Expr<CustomDataItem> {
  Expr<CustomIntType> get id =>
      $ForGeneratedCode.field(this, 0, CustomIntTypeExt._exprType);

  Expr<CustomStringType> get stringVal =>
      $ForGeneratedCode.field(this, 1, CustomStringTypeExt._exprType);
}

extension ExpressionNullableCustomDataItemExt on Expr<CustomDataItem?> {
  Expr<CustomIntType?> get id =>
      $ForGeneratedCode.field(this, 0, CustomIntTypeExt._exprType);

  Expr<CustomStringType?> get stringVal =>
      $ForGeneratedCode.field(this, 1, CustomStringTypeExt._exprType);

  /// Check if the row is not `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNotNull() => id.asEncoded().isNotNull();

  /// Check if the row is `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNull() => isNotNull().not();
}

/// `Table<CustomDataItem>` conflict targets for use with `.onConflict`.
enum CustomDataItemConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `id`.
  primaryKey(['id']),

  /// `stringVal` conflict.
  ///
  /// Due to violation of the `UNIQUE` constraint on
  /// `stringVal`.
  ///
  /// Thus, the conflicting row has matching values for these fields.
  stringVal(['stringVal']);

  const CustomDataItemConflict(this._fields);

  final List<String> _fields;
}

extension InsertCustomDataItemExt on Insert<CustomDataItem> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((customDataItem, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflict<CustomDataItem> onConflict(CustomDataItemConflict target) =>
      $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictCustomDataItemExt
    on InsertOnConflict<CustomDataItem> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `customDataItem` an [Expr] representing the existing row in
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
  Upsert<CustomDataItem> update(
    UpdateSet<CustomDataItem> Function(
      Expr<CustomDataItem> customDataItem,
      Expr<CustomDataItem> excluded,
      UpdateSet<CustomDataItem> Function({
        Expr<CustomIntType> id,
        Expr<CustomStringType> stringVal,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<CustomDataItem>(
    this,
    (customDataItem, excluded) => updateBuilder(
      customDataItem,
      excluded,
      ({Expr<CustomIntType>? id, Expr<CustomStringType>? stringVal}) =>
          $ForGeneratedCode.buildUpdate<CustomDataItem>([id, stringVal]),
    ),
  );
}

extension InsertSingleCustomDataItemExt on InsertSingle<CustomDataItem> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((customDataItem, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflictSingle<CustomDataItem> onConflict(
    CustomDataItemConflict target,
  ) => $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleCustomDataItemExt
    on InsertOnConflictSingle<CustomDataItem> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `customDataItem` an [Expr] representing the existing row in
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
  UpsertSingle<CustomDataItem> update(
    UpdateSet<CustomDataItem> Function(
      Expr<CustomDataItem> customDataItem,
      Expr<CustomDataItem> excluded,
      UpdateSet<CustomDataItem> Function({
        Expr<CustomIntType> id,
        Expr<CustomStringType> stringVal,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<CustomDataItem>(
    this,
    (customDataItem, excluded) => updateBuilder(
      customDataItem,
      excluded,
      ({Expr<CustomIntType>? id, Expr<CustomStringType>? stringVal}) =>
          $ForGeneratedCode.buildUpdate<CustomDataItem>([id, stringVal]),
    ),
  );
}

/// Wrap this [CustomIntType] as [Expr<CustomIntType>] for use queries with
/// `package:typed_sql`.
extension CustomIntTypeExt on CustomIntType {
  static final _exprType = $ForGeneratedCode.customDataType(
    $ForGeneratedCode.integer,
    CustomIntType.fromDatabase,
  );

  /// Wrap this [CustomIntType] as [Expr<CustomIntType>] for use queries with
  /// `package:typed_sql`.
  Expr<CustomIntType> get asExpr =>
      $ForGeneratedCode.literalCustomDataType(this, _exprType).asNotNull();
}

/// Wrap this [CustomIntType] as [Expr<CustomIntType>] for use queries with
/// `package:typed_sql`.
extension CustomIntTypeNullableExt on CustomIntType? {
  /// Wrap this [CustomIntType] as [Expr<CustomIntType?>] for use queries with
  /// `package:typed_sql`.
  Expr<CustomIntType?> get asExpr =>
      $ForGeneratedCode.literalCustomDataType(this, CustomIntTypeExt._exprType);
}

/// Wrap this [CustomStringType] as [Expr<CustomStringType>] for use queries with
/// `package:typed_sql`.
extension CustomStringTypeExt on CustomStringType {
  static final _exprType = $ForGeneratedCode.customDataType(
    $ForGeneratedCode.text,
    CustomStringType.fromDatabase,
  );

  /// Wrap this [CustomStringType] as [Expr<CustomStringType>] for use queries with
  /// `package:typed_sql`.
  Expr<CustomStringType> get asExpr =>
      $ForGeneratedCode.literalCustomDataType(this, _exprType).asNotNull();
}

/// Wrap this [CustomStringType] as [Expr<CustomStringType>] for use queries with
/// `package:typed_sql`.
extension CustomStringTypeNullableExt on CustomStringType? {
  /// Wrap this [CustomStringType] as [Expr<CustomStringType?>] for use queries with
  /// `package:typed_sql`.
  Expr<CustomStringType?> get asExpr => $ForGeneratedCode.literalCustomDataType(
    this,
    CustomStringTypeExt._exprType,
  );
}

/// Extension methods for assertions on [CustomDataItem] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension CustomDataItemChecks on Subject<CustomDataItem> {
  /// Create assertions on [CustomDataItem.id].
  Subject<CustomIntType> get id => has((m) => m.id, 'id');

  /// Create assertions on [CustomDataItem.stringVal].
  Subject<CustomStringType> get stringVal =>
      has((m) => m.stringVal, 'stringVal');
}
