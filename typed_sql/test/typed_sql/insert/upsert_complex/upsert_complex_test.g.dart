// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upsert_complex_test.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

/// Extension methods for a [Database] operating on [ComplexDatabase].
extension ComplexDatabaseSchema on Database<ComplexDatabase> {
  static final _$tables = [_$ComplexItem._$table];

  Table<ComplexItem> get complexItems =>
      $ForGeneratedCode.declareTable(this, _$ComplexItem._$table);

  /// Create tables defined in [ComplexDatabase].
  ///
  /// Calling this on an empty database will create the tables
  /// defined in [ComplexDatabase]. In production it's often better to
  /// use [createComplexDatabaseTables] and manage migrations using
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

/// Get SQL [DDL statements][1] for tables defined in [ComplexDatabase].
///
/// This returns a SQL script with multiple DDL statements separated by `;`
/// using the specified [dialect].
///
/// Executing these statements in an empty database will create the tables
/// defined in [ComplexDatabase]. In practice, this method is often used for
/// printing the DDL statements, such that migrations can be managed by
/// external tools.
///
/// [1]: https://en.wikipedia.org/wiki/Data_definition_language
String createComplexDatabaseTables(SqlDialect dialect) =>
    $ForGeneratedCode.createTableSchema(
      dialect: dialect,
      tables: ComplexDatabaseSchema._$tables,
    );

final class _$ComplexItem extends ComplexItem {
  _$ComplexItem._(
    this.id,
    this.createdAt,
    this.name,
    this.doubleValue,
    this.boolValue,
    this.value,
  );

  @override
  final int id;

  @override
  final DateTime createdAt;

  @override
  final String name;

  @override
  final double doubleValue;

  @override
  final bool boolValue;

  @override
  final int value;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'complexItems',
    columns: <String>[
      'id',
      'createdAt',
      'name',
      'doubleValue',
      'boolValue',
      'value',
    ],
    columnInfo: [
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.integer,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.dateTime,
        isNotNull: true,
        defaultValue: (kind: 'datetime', value: 'now'),
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
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.real,
        isNotNull: true,
        defaultValue: (kind: 'raw', value: 0.0),
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.boolean,
        isNotNull: true,
        defaultValue: (kind: 'raw', value: false),
        autoIncrement: false,
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
    primaryKey: <String>['id', 'createdAt'],
    unique: <List<String>>[
      ['name', 'doubleValue', 'boolValue'],
    ],
    foreignKeys: [],
    readRow: _$ComplexItem._$fromDatabase,
  );

  static ComplexItem? _$fromDatabase(RowReader row) {
    final id = row.readInt();
    final createdAt = row.readDateTime();
    final name = row.readString();
    final doubleValue = row.readDouble();
    final boolValue = row.readBool();
    final value = row.readInt();
    if (id == null &&
        createdAt == null &&
        name == null &&
        doubleValue == null &&
        boolValue == null &&
        value == null) {
      return null;
    }
    return _$ComplexItem._(
      id!,
      createdAt!,
      name!,
      doubleValue!,
      boolValue!,
      value!,
    );
  }

  @override
  String toString() =>
      'ComplexItem(id: "$id", createdAt: "$createdAt", name: "$name", doubleValue: "$doubleValue", boolValue: "$boolValue", value: "$value")';
}

/// Extension methods for table defined in [ComplexItem].
extension TableComplexItemExt on Table<ComplexItem> {
  /// Insert row into the `complexItems` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<ComplexItem> insert({
    required Expr<int> id,
    Expr<DateTime>? createdAt,
    required Expr<String> name,
    Expr<double>? doubleValue,
    Expr<bool>? boolValue,
    required Expr<int> value,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [id, createdAt, name, doubleValue, boolValue, value],
  );

  /// Insert row into the `complexItems` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<ComplexItem> insertValue({
    required int id,
    DateTime? createdAt,
    required String name,
    double? doubleValue,
    bool? boolValue,
    required int value,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [
      id.asExpr,
      createdAt?.asExpr,
      name.asExpr,
      doubleValue?.asExpr,
      boolValue?.asExpr,
      value.asExpr,
    ],
  );

  /// Bulk insert rows into the `complexItems` table.
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
  Insert<ComplexItem> insertValuesMapped<T>(
    Iterable<T> rows, {
    required int Function(T row) id,
    DateTime Function(T row)? createdAt,
    required String Function(T row) name,
    double Function(T row)? doubleValue,
    bool Function(T row)? boolValue,
    required int Function(T row) value,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mappings: [id, createdAt, name, doubleValue, boolValue, value],
  );

  /// Delete a single row from the `complexItems` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<ComplexItem> delete(int id, DateTime createdAt) =>
      $ForGeneratedCode.deleteSingle(
        byKey(id, createdAt),
        _$ComplexItem._$table,
      );
}

/// Extension methods for building queries against the `complexItems` table.
extension QueryComplexItemExt on Query<(Expr<ComplexItem>,)> {
  /// Lookup a single row in `complexItems` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<ComplexItem>,)> byKey(int id, DateTime createdAt) => where(
    (complexItem) =>
        complexItem.id.equalsValue(id) &
        complexItem.createdAt.equalsValue(createdAt),
  ).first;

  /// Update all rows in the `complexItems` table matching this [Query].
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
  Update<ComplexItem> update(
    UpdateSet<ComplexItem> Function(
      Expr<ComplexItem> complexItem,
      UpdateSet<ComplexItem> Function({
        Expr<int> id,
        Expr<DateTime> createdAt,
        Expr<String> name,
        Expr<double> doubleValue,
        Expr<bool> boolValue,
        Expr<int> value,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<ComplexItem>(
    this,
    _$ComplexItem._$table,
    (complexItem) => updateBuilder(
      complexItem,
      ({
        Expr<int>? id,
        Expr<DateTime>? createdAt,
        Expr<String>? name,
        Expr<double>? doubleValue,
        Expr<bool>? boolValue,
        Expr<int>? value,
      }) => $ForGeneratedCode.buildUpdate<ComplexItem>([
        id,
        createdAt,
        name,
        doubleValue,
        boolValue,
        value,
      ]),
    ),
  );

  /// Lookup a single row in `complexItems` table using the
  /// `name`, `doubleValue`, `boolValue` fields
  ///
  /// We know that lookup by the `name`, `doubleValue`, `boolValue` fields returns
  /// at-most one row because the [Unique] annotation in [ComplexItem].
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<ComplexItem>,)> byComplexUnique(
    String name,
    double doubleValue,
    bool boolValue,
  ) => where(
    (complexItem) =>
        complexItem.name.equalsValue(name) &
        complexItem.doubleValue.equalsValue(doubleValue) &
        complexItem.boolValue.equalsValue(boolValue),
  ).first;

  /// Delete all rows in the `complexItems` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<ComplexItem> delete() =>
      $ForGeneratedCode.delete(this, _$ComplexItem._$table);
}

/// Extension methods for building point queries against the `complexItems` table.
extension QuerySingleComplexItemExt on QuerySingle<(Expr<ComplexItem>,)> {
  /// Update the row (if any) in the `complexItems` table matching this
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
  UpdateSingle<ComplexItem> update(
    UpdateSet<ComplexItem> Function(
      Expr<ComplexItem> complexItem,
      UpdateSet<ComplexItem> Function({
        Expr<int> id,
        Expr<DateTime> createdAt,
        Expr<String> name,
        Expr<double> doubleValue,
        Expr<bool> boolValue,
        Expr<int> value,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<ComplexItem>(
    this,
    _$ComplexItem._$table,
    (complexItem) => updateBuilder(
      complexItem,
      ({
        Expr<int>? id,
        Expr<DateTime>? createdAt,
        Expr<String>? name,
        Expr<double>? doubleValue,
        Expr<bool>? boolValue,
        Expr<int>? value,
      }) => $ForGeneratedCode.buildUpdate<ComplexItem>([
        id,
        createdAt,
        name,
        doubleValue,
        boolValue,
        value,
      ]),
    ),
  );

  /// Delete the row (if any) in the `complexItems` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<ComplexItem> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$ComplexItem._$table);
}

/// Extension methods for expressions on a row in the `complexItems` table.
extension ExpressionComplexItemExt on Expr<ComplexItem> {
  Expr<int> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<DateTime> get createdAt =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.dateTime);

  Expr<String> get name =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  Expr<double> get doubleValue =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.real);

  Expr<bool> get boolValue =>
      $ForGeneratedCode.field(this, 4, $ForGeneratedCode.boolean);

  Expr<int> get value =>
      $ForGeneratedCode.field(this, 5, $ForGeneratedCode.integer);
}

extension ExpressionNullableComplexItemExt on Expr<ComplexItem?> {
  Expr<int?> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<DateTime?> get createdAt =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.dateTime);

  Expr<String?> get name =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  Expr<double?> get doubleValue =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.real);

  Expr<bool?> get boolValue =>
      $ForGeneratedCode.field(this, 4, $ForGeneratedCode.boolean);

  Expr<int?> get value =>
      $ForGeneratedCode.field(this, 5, $ForGeneratedCode.integer);

  /// Check if the row is not `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNotNull() => id.isNotNull() & createdAt.isNotNull();

  /// Check if the row is `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNull() => isNotNull().not();
}

/// `Table<ComplexItem>` conflict targets for use with `.onConflict`.
enum ComplexItemConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `id`, `createdAt`.
  primaryKey(['id', 'createdAt']),

  /// `name`, `doubleValue`, `boolValue` conflict.
  ///
  /// Due to violation of the `UNIQUE` constraint on
  /// `name`, `doubleValue`, `boolValue`.
  ///
  /// Thus, the conflicting row has matching values for these fields.
  complexUnique(['name', 'doubleValue', 'boolValue']);

  const ComplexItemConflict(this._fields);

  final List<String> _fields;
}

extension InsertComplexItemExt on Insert<ComplexItem> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((complexItem, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflict<ComplexItem> onConflict(ComplexItemConflict target) =>
      $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictComplexItemExt on InsertOnConflict<ComplexItem> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `complexItem` an [Expr] representing the existing row in
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
  Upsert<ComplexItem> update(
    UpdateSet<ComplexItem> Function(
      Expr<ComplexItem> complexItem,
      Expr<ComplexItem> excluded,
      UpdateSet<ComplexItem> Function({
        Expr<int> id,
        Expr<DateTime> createdAt,
        Expr<String> name,
        Expr<double> doubleValue,
        Expr<bool> boolValue,
        Expr<int> value,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<ComplexItem>(
    this,
    (complexItem, excluded) => updateBuilder(
      complexItem,
      excluded,
      ({
        Expr<int>? id,
        Expr<DateTime>? createdAt,
        Expr<String>? name,
        Expr<double>? doubleValue,
        Expr<bool>? boolValue,
        Expr<int>? value,
      }) => $ForGeneratedCode.buildUpdate<ComplexItem>([
        id,
        createdAt,
        name,
        doubleValue,
        boolValue,
        value,
      ]),
    ),
  );
}

extension InsertSingleComplexItemExt on InsertSingle<ComplexItem> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((complexItem, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflictSingle<ComplexItem> onConflict(ComplexItemConflict target) =>
      $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleComplexItemExt
    on InsertOnConflictSingle<ComplexItem> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `complexItem` an [Expr] representing the existing row in
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
  UpsertSingle<ComplexItem> update(
    UpdateSet<ComplexItem> Function(
      Expr<ComplexItem> complexItem,
      Expr<ComplexItem> excluded,
      UpdateSet<ComplexItem> Function({
        Expr<int> id,
        Expr<DateTime> createdAt,
        Expr<String> name,
        Expr<double> doubleValue,
        Expr<bool> boolValue,
        Expr<int> value,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<ComplexItem>(
    this,
    (complexItem, excluded) => updateBuilder(
      complexItem,
      excluded,
      ({
        Expr<int>? id,
        Expr<DateTime>? createdAt,
        Expr<String>? name,
        Expr<double>? doubleValue,
        Expr<bool>? boolValue,
        Expr<int>? value,
      }) => $ForGeneratedCode.buildUpdate<ComplexItem>([
        id,
        createdAt,
        name,
        doubleValue,
        boolValue,
        value,
      ]),
    ),
  );
}

/// Extension methods for assertions on [ComplexItem] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension ComplexItemChecks on Subject<ComplexItem> {
  /// Create assertions on [ComplexItem.id].
  Subject<int> get id => has((m) => m.id, 'id');

  /// Create assertions on [ComplexItem.createdAt].
  Subject<DateTime> get createdAt => has((m) => m.createdAt, 'createdAt');

  /// Create assertions on [ComplexItem.name].
  Subject<String> get name => has((m) => m.name, 'name');

  /// Create assertions on [ComplexItem.doubleValue].
  Subject<double> get doubleValue => has((m) => m.doubleValue, 'doubleValue');

  /// Create assertions on [ComplexItem.boolValue].
  Subject<bool> get boolValue => has((m) => m.boolValue, 'boolValue');

  /// Create assertions on [ComplexItem.value].
  Subject<int> get value => has((m) => m.value, 'value');
}
