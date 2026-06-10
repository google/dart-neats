// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dialect_specific_ddl_test.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

/// Extension methods for a [Database] operating on [DialectDatabase].
extension DialectDatabaseSchema on Database<DialectDatabase> {
  static final _$tables = [_$DialectItem._$table, _$DialectLog._$table];

  Table<DialectItem> get dialectItems =>
      $ForGeneratedCode.declareTable(this, _$DialectItem._$table);

  Table<DialectLog> get dialectLogs =>
      $ForGeneratedCode.declareTable(this, _$DialectLog._$table);

  /// Create tables defined in [DialectDatabase].
  ///
  /// Calling this on an empty database will create the tables
  /// defined in [DialectDatabase]. In production it's often better to
  /// use [createDialectDatabaseTables] and manage migrations using
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

/// Get SQL [DDL statements][1] for tables defined in [DialectDatabase].
///
/// This returns a SQL script with multiple DDL statements separated by `;`
/// using the specified [dialect].
///
/// Executing these statements in an empty database will create the tables
/// defined in [DialectDatabase]. In practice, this method is often used for
/// printing the DDL statements, such that migrations can be managed by
/// external tools.
///
/// [1]: https://en.wikipedia.org/wiki/Data_definition_language
String createDialectDatabaseTables(SqlDialect dialect) =>
    $ForGeneratedCode.createTableSchema(
      dialect: dialect,
      tables: DialectDatabaseSchema._$tables,
    );

final class _$DialectItem extends DialectItem {
  _$DialectItem._(
    this.itemId,
    this.name,
    this.category,
    this.status,
    this.itemColor,
  );

  @override
  final int itemId;

  @override
  final String name;

  @override
  final String category;

  @override
  final String status;

  @override
  final Color itemColor;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'dialectItems',
    columns: <String>['itemId', 'name', 'category', 'status', 'itemColor'],
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
            dialect: 'sqlite',
            columnType: 'TEXT',
            defaultValue: null,
            collation: 'NOCASE',
          ),
          (
            dialect: 'postgres',
            columnType: 'VARCHAR(255)',
            defaultValue: null,
            collation: null,
          ),
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
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [
          (
            dialect: 'postgres',
            columnType: null,
            defaultValue: '\'unknown\'',
            collation: null,
          ),
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
    primaryKey: <String>['itemId'],
    unique: <List<String>>[
      ['status'],
      ['name', 'category'],
    ],
    foreignKeys: [],
    readRow: _$DialectItem._$fromDatabase,
  );

  static DialectItem? _$fromDatabase(RowReader row) {
    final itemId = row.readInt();
    final name = row.readString();
    final category = row.readString();
    final status = row.readString();
    final itemColor = $ForGeneratedCode.customDataTypeOrNull(
      row.readInt(),
      Color.fromDatabase,
    );
    if (itemId == null &&
        name == null &&
        category == null &&
        status == null &&
        itemColor == null) {
      return null;
    }
    return _$DialectItem._(itemId!, name!, category!, status!, itemColor!);
  }

  @override
  String toString() =>
      'DialectItem(itemId: "$itemId", name: "$name", category: "$category", status: "$status", itemColor: "$itemColor")';
}

/// Extension methods for table defined in [DialectItem].
extension TableDialectItemExt on Table<DialectItem> {
  /// Insert row into the `dialectItems` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<DialectItem> insert({
    Expr<int>? itemId,
    required Expr<String> name,
    required Expr<String> category,
    required Expr<String> status,
    required Expr<Color> itemColor,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [itemId, name, category, status, itemColor],
  );

  /// Insert row into the `dialectItems` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<DialectItem> insertValue({
    int? itemId,
    required String name,
    required String category,
    required String status,
    required Color itemColor,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [
      itemId?.asExpr,
      name.asExpr,
      category.asExpr,
      status.asExpr,
      itemColor.asExpr,
    ],
  );

  /// Bulk insert rows into the `dialectItems` table.
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
  Insert<DialectItem> insertValuesMapped<T>(
    Iterable<T> rows, {
    int Function(T row)? itemId,
    required String Function(T row) name,
    required String Function(T row) category,
    required String Function(T row) status,
    required Color Function(T row) itemColor,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mappings: [
      itemId,
      name,
      category,
      status,
      (T v) => itemColor(v).toDatabase(),
    ],
  );

  /// Delete a single row from the `dialectItems` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<DialectItem> delete(int itemId) =>
      $ForGeneratedCode.deleteSingle(byKey(itemId), _$DialectItem._$table);
}

/// Extension methods for building queries against the `dialectItems` table.
extension QueryDialectItemExt on Query<(Expr<DialectItem>,)> {
  /// Lookup a single row in `dialectItems` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<DialectItem>,)> byKey(int itemId) =>
      where((dialectItem) => dialectItem.itemId.equalsValue(itemId)).first;

  /// Update all rows in the `dialectItems` table matching this [Query].
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
  Update<DialectItem> update(
    UpdateSet<DialectItem> Function(
      Expr<DialectItem> dialectItem,
      UpdateSet<DialectItem> Function({
        Expr<int> itemId,
        Expr<String> name,
        Expr<String> category,
        Expr<String> status,
        Expr<Color> itemColor,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<DialectItem>(
    this,
    _$DialectItem._$table,
    (dialectItem) => updateBuilder(
      dialectItem,
      ({
        Expr<int>? itemId,
        Expr<String>? name,
        Expr<String>? category,
        Expr<String>? status,
        Expr<Color>? itemColor,
      }) => $ForGeneratedCode.buildUpdate<DialectItem>([
        itemId,
        name,
        category,
        status,
        itemColor,
      ]),
    ),
  );

  /// Lookup a single row in `dialectItems` table using the
  /// `status` field
  ///
  /// We know that lookup by the `status` field returns
  /// at-most one row because the [Unique] annotation in [DialectItem].
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<DialectItem>,)> byStatus(String status) =>
      where((dialectItem) => dialectItem.status.equalsValue(status)).first;

  /// Delete all rows in the `dialectItems` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<DialectItem> delete() =>
      $ForGeneratedCode.delete(this, _$DialectItem._$table);
}

/// Extension methods for building point queries against the `dialectItems` table.
extension QuerySingleDialectItemExt on QuerySingle<(Expr<DialectItem>,)> {
  /// Update the row (if any) in the `dialectItems` table matching this
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
  UpdateSingle<DialectItem> update(
    UpdateSet<DialectItem> Function(
      Expr<DialectItem> dialectItem,
      UpdateSet<DialectItem> Function({
        Expr<int> itemId,
        Expr<String> name,
        Expr<String> category,
        Expr<String> status,
        Expr<Color> itemColor,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<DialectItem>(
    this,
    _$DialectItem._$table,
    (dialectItem) => updateBuilder(
      dialectItem,
      ({
        Expr<int>? itemId,
        Expr<String>? name,
        Expr<String>? category,
        Expr<String>? status,
        Expr<Color>? itemColor,
      }) => $ForGeneratedCode.buildUpdate<DialectItem>([
        itemId,
        name,
        category,
        status,
        itemColor,
      ]),
    ),
  );

  /// Delete the row (if any) in the `dialectItems` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<DialectItem> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$DialectItem._$table);
}

/// Extension methods for expressions on a row in the `dialectItems` table.
extension ExpressionDialectItemExt on Expr<DialectItem> {
  Expr<int> get itemId =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String> get name =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<String> get category =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  Expr<String> get status =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.text);

  Expr<Color> get itemColor =>
      $ForGeneratedCode.field(this, 4, ColorExt._exprType);
}

extension ExpressionNullableDialectItemExt on Expr<DialectItem?> {
  Expr<int?> get itemId =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String?> get name =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<String?> get category =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  Expr<String?> get status =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.text);

  Expr<Color?> get itemColor =>
      $ForGeneratedCode.field(this, 4, ColorExt._exprType);

  /// Check if the row is not `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNotNull() => itemId.isNotNull();

  /// Check if the row is `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNull() => isNotNull().not();
}

/// `Table<DialectItem>` conflict targets for use with `.onConflict`.
enum DialectItemConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `itemId`.
  primaryKey(['itemId']),

  /// `status` conflict.
  ///
  /// Due to violation of the `UNIQUE` constraint on
  /// `status`.
  ///
  /// Thus, the conflicting row has matching values for these fields.
  status(['status']),

  /// `name`, `category` conflict.
  ///
  /// Due to violation of the `UNIQUE` constraint on
  /// `name`, `category`.
  ///
  /// Thus, the conflicting row has matching values for these fields.
  nameCategory(['name', 'category']);

  const DialectItemConflict(this._fields);

  final List<String> _fields;
}

extension InsertDialectItemExt on Insert<DialectItem> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((dialectItem, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflict<DialectItem> onConflict(DialectItemConflict target) =>
      $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictDialectItemExt on InsertOnConflict<DialectItem> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `dialectItem` an [Expr] representing the existing row in
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
  Upsert<DialectItem> update(
    UpdateSet<DialectItem> Function(
      Expr<DialectItem> dialectItem,
      Expr<DialectItem> excluded,
      UpdateSet<DialectItem> Function({
        Expr<int> itemId,
        Expr<String> name,
        Expr<String> category,
        Expr<String> status,
        Expr<Color> itemColor,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<DialectItem>(
    this,
    (dialectItem, excluded) => updateBuilder(
      dialectItem,
      excluded,
      ({
        Expr<int>? itemId,
        Expr<String>? name,
        Expr<String>? category,
        Expr<String>? status,
        Expr<Color>? itemColor,
      }) => $ForGeneratedCode.buildUpdate<DialectItem>([
        itemId,
        name,
        category,
        status,
        itemColor,
      ]),
    ),
  );
}

extension InsertSingleDialectItemExt on InsertSingle<DialectItem> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((dialectItem, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflictSingle<DialectItem> onConflict(DialectItemConflict target) =>
      $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleDialectItemExt
    on InsertOnConflictSingle<DialectItem> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `dialectItem` an [Expr] representing the existing row in
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
  UpsertSingle<DialectItem> update(
    UpdateSet<DialectItem> Function(
      Expr<DialectItem> dialectItem,
      Expr<DialectItem> excluded,
      UpdateSet<DialectItem> Function({
        Expr<int> itemId,
        Expr<String> name,
        Expr<String> category,
        Expr<String> status,
        Expr<Color> itemColor,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<DialectItem>(
    this,
    (dialectItem, excluded) => updateBuilder(
      dialectItem,
      excluded,
      ({
        Expr<int>? itemId,
        Expr<String>? name,
        Expr<String>? category,
        Expr<String>? status,
        Expr<Color>? itemColor,
      }) => $ForGeneratedCode.buildUpdate<DialectItem>([
        itemId,
        name,
        category,
        status,
        itemColor,
      ]),
    ),
  );
}

final class _$DialectLog extends DialectLog {
  _$DialectLog._(this.logId, this.refItemId);

  @override
  final int logId;

  @override
  final int refItemId;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'dialectLogs',
    columns: <String>['logId', 'refItemId'],
    columnInfo: [
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.integer,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: true,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.integer,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
    ],
    primaryKey: <String>['logId'],
    unique: <List<String>>[],
    foreignKeys: [
      $ForGeneratedCode.foreignKeyDefinition(
        name: 'null',
        columns: ['refItemId'],
        referencedTable: 'dialectItems',
        referencedColumns: ['itemId'],
        onDelete: .noAction,
        onUpdate: .noAction,
      ),
    ],
    readRow: _$DialectLog._$fromDatabase,
  );

  static DialectLog? _$fromDatabase(RowReader row) {
    final logId = row.readInt();
    final refItemId = row.readInt();
    if (logId == null && refItemId == null) {
      return null;
    }
    return _$DialectLog._(logId!, refItemId!);
  }

  @override
  String toString() => 'DialectLog(logId: "$logId", refItemId: "$refItemId")';
}

/// Extension methods for table defined in [DialectLog].
extension TableDialectLogExt on Table<DialectLog> {
  /// Insert row into the `dialectLogs` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<DialectLog> insert({
    Expr<int>? logId,
    required Expr<int> refItemId,
  }) => $ForGeneratedCode.insertInto(table: this, values: [logId, refItemId]);

  /// Insert row into the `dialectLogs` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<DialectLog> insertValue({int? logId, required int refItemId}) =>
      $ForGeneratedCode.insertInto(
        table: this,
        values: [logId?.asExpr, refItemId.asExpr],
      );

  /// Bulk insert rows into the `dialectLogs` table.
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
  Insert<DialectLog> insertValuesMapped<T>(
    Iterable<T> rows, {
    int Function(T row)? logId,
    required int Function(T row) refItemId,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mappings: [logId, refItemId],
  );

  /// Delete a single row from the `dialectLogs` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<DialectLog> delete(int logId) =>
      $ForGeneratedCode.deleteSingle(byKey(logId), _$DialectLog._$table);
}

/// Extension methods for building queries against the `dialectLogs` table.
extension QueryDialectLogExt on Query<(Expr<DialectLog>,)> {
  /// Lookup a single row in `dialectLogs` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<DialectLog>,)> byKey(int logId) =>
      where((dialectLog) => dialectLog.logId.equalsValue(logId)).first;

  /// Update all rows in the `dialectLogs` table matching this [Query].
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
  Update<DialectLog> update(
    UpdateSet<DialectLog> Function(
      Expr<DialectLog> dialectLog,
      UpdateSet<DialectLog> Function({Expr<int> logId, Expr<int> refItemId})
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<DialectLog>(
    this,
    _$DialectLog._$table,
    (dialectLog) => updateBuilder(
      dialectLog,
      ({Expr<int>? logId, Expr<int>? refItemId}) =>
          $ForGeneratedCode.buildUpdate<DialectLog>([logId, refItemId]),
    ),
  );

  /// Delete all rows in the `dialectLogs` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<DialectLog> delete() =>
      $ForGeneratedCode.delete(this, _$DialectLog._$table);
}

/// Extension methods for building point queries against the `dialectLogs` table.
extension QuerySingleDialectLogExt on QuerySingle<(Expr<DialectLog>,)> {
  /// Update the row (if any) in the `dialectLogs` table matching this
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
  UpdateSingle<DialectLog> update(
    UpdateSet<DialectLog> Function(
      Expr<DialectLog> dialectLog,
      UpdateSet<DialectLog> Function({Expr<int> logId, Expr<int> refItemId})
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<DialectLog>(
    this,
    _$DialectLog._$table,
    (dialectLog) => updateBuilder(
      dialectLog,
      ({Expr<int>? logId, Expr<int>? refItemId}) =>
          $ForGeneratedCode.buildUpdate<DialectLog>([logId, refItemId]),
    ),
  );

  /// Delete the row (if any) in the `dialectLogs` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<DialectLog> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$DialectLog._$table);
}

/// Extension methods for expressions on a row in the `dialectLogs` table.
extension ExpressionDialectLogExt on Expr<DialectLog> {
  Expr<int> get logId =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<int> get refItemId =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.integer);
}

extension ExpressionNullableDialectLogExt on Expr<DialectLog?> {
  Expr<int?> get logId =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<int?> get refItemId =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.integer);

  /// Check if the row is not `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNotNull() => logId.isNotNull();

  /// Check if the row is `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNull() => isNotNull().not();
}

/// `Table<DialectLog>` conflict targets for use with `.onConflict`.
enum DialectLogConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `logId`.
  primaryKey(['logId']);

  const DialectLogConflict(this._fields);

  final List<String> _fields;
}

extension InsertDialectLogExt on Insert<DialectLog> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((dialectLog, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflict<DialectLog> onConflict(DialectLogConflict target) =>
      $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictDialectLogExt on InsertOnConflict<DialectLog> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `dialectLog` an [Expr] representing the existing row in
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
  Upsert<DialectLog> update(
    UpdateSet<DialectLog> Function(
      Expr<DialectLog> dialectLog,
      Expr<DialectLog> excluded,
      UpdateSet<DialectLog> Function({Expr<int> logId, Expr<int> refItemId})
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<DialectLog>(
    this,
    (dialectLog, excluded) => updateBuilder(
      dialectLog,
      excluded,
      ({Expr<int>? logId, Expr<int>? refItemId}) =>
          $ForGeneratedCode.buildUpdate<DialectLog>([logId, refItemId]),
    ),
  );
}

extension InsertSingleDialectLogExt on InsertSingle<DialectLog> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((dialectLog, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflictSingle<DialectLog> onConflict(DialectLogConflict target) =>
      $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleDialectLogExt
    on InsertOnConflictSingle<DialectLog> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `dialectLog` an [Expr] representing the existing row in
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
  UpsertSingle<DialectLog> update(
    UpdateSet<DialectLog> Function(
      Expr<DialectLog> dialectLog,
      Expr<DialectLog> excluded,
      UpdateSet<DialectLog> Function({Expr<int> logId, Expr<int> refItemId})
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<DialectLog>(
    this,
    (dialectLog, excluded) => updateBuilder(
      dialectLog,
      excluded,
      ({Expr<int>? logId, Expr<int>? refItemId}) =>
          $ForGeneratedCode.buildUpdate<DialectLog>([logId, refItemId]),
    ),
  );
}

/// Wrap this [Color] as [Expr<Color>] for use queries with
/// `package:typed_sql`.
extension ColorExt on Color {
  static final _exprType = $ForGeneratedCode.customDataType(
    $ForGeneratedCode.integer,
    Color.fromDatabase,
  );

  /// Wrap this [Color] as [Expr<Color>] for use queries with
  /// `package:typed_sql`.
  ///
  /// Using [asExpr] will inject this value as an SQL parameter,
  /// use [asExprLiteral] if you wish to inject as SQL literal instead.
  Expr<Color> get asExpr =>
      $ForGeneratedCode.customDataTypeAsExpr(this, _exprType).asNotNull();

  /// Wrap this [Color] as [Expr<Color>] for use queries with
  /// `package:typed_sql`.
  ///
  /// Using [asExprLiteral] will inject this value as an SQL literal,
  /// use [asExpr] if you wish to inject as SQL parameter instead.
  Expr<Color> get asExprLiteral => $ForGeneratedCode
      .customDataTypeAsExprLiteral(this, _exprType)
      .asNotNull();
}

/// Wrap this [Color] as [Expr<Color>] for use queries with
/// `package:typed_sql`.
extension ColorNullableExt on Color? {
  /// Wrap this [Color] as [Expr<Color?>] for use queries with
  /// `package:typed_sql`.
  ///
  /// Using [asExpr] will inject this value as an SQL parameter,
  /// use [asExprLiteral] if you wish to inject as SQL literal instead.
  Expr<Color?> get asExpr =>
      $ForGeneratedCode.customDataTypeAsExpr(this, ColorExt._exprType);

  /// Wrap this [Color] as [Expr<Color?>] for use queries with
  /// `package:typed_sql`.
  ///
  /// Using [asExprLiteral] will inject this value as an SQL literal,
  /// use [asExpr] if you wish to inject as SQL parameter instead.
  Expr<Color?> get asExprLiteral =>
      $ForGeneratedCode.customDataTypeAsExprLiteral(this, ColorExt._exprType);
}

/// Extension methods for assertions on [DialectItem] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension DialectItemChecks on Subject<DialectItem> {
  /// Create assertions on [DialectItem.itemId].
  Subject<int> get itemId => has((m) => m.itemId, 'itemId');

  /// Create assertions on [DialectItem.name].
  Subject<String> get name => has((m) => m.name, 'name');

  /// Create assertions on [DialectItem.category].
  Subject<String> get category => has((m) => m.category, 'category');

  /// Create assertions on [DialectItem.status].
  Subject<String> get status => has((m) => m.status, 'status');

  /// Create assertions on [DialectItem.itemColor].
  Subject<Color> get itemColor => has((m) => m.itemColor, 'itemColor');
}

/// Extension methods for assertions on [DialectLog] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension DialectLogChecks on Subject<DialectLog> {
  /// Create assertions on [DialectLog.logId].
  Subject<int> get logId => has((m) => m.logId, 'logId');

  /// Create assertions on [DialectLog.refItemId].
  Subject<int> get refItemId => has((m) => m.refItemId, 'refItemId');
}
