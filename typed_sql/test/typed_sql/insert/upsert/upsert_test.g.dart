// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upsert_test.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

/// Extension methods for a [Database] operating on [UpsertDatabase].
extension UpsertDatabaseSchema on Database<UpsertDatabase> {
  static final _$tables = [
    _$SimpleItem._$table,
    _$CompositeItem._$table,
    _$NullableUniqueItem._$table,
    _$SubQueryItem._$table,
    _$ComplexItem._$table,
    _$CustomTypeItem._$table,
  ];

  Table<SimpleItem> get simpleItems =>
      $ForGeneratedCode.declareTable(this, _$SimpleItem._$table);

  Table<CompositeItem> get compositeItems =>
      $ForGeneratedCode.declareTable(this, _$CompositeItem._$table);

  Table<NullableUniqueItem> get nullableUniqueItems =>
      $ForGeneratedCode.declareTable(this, _$NullableUniqueItem._$table);

  Table<SubQueryItem> get subQueryItems =>
      $ForGeneratedCode.declareTable(this, _$SubQueryItem._$table);

  Table<ComplexItem> get complexItems =>
      $ForGeneratedCode.declareTable(this, _$ComplexItem._$table);

  Table<CustomTypeItem> get customTypeItems =>
      $ForGeneratedCode.declareTable(this, _$CustomTypeItem._$table);

  /// Create tables defined in [UpsertDatabase].
  ///
  /// Calling this on an empty database will create the tables
  /// defined in [UpsertDatabase]. In production it's often better to
  /// use [createUpsertDatabaseTables] and manage migrations using
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

/// Get SQL [DDL statements][1] for tables defined in [UpsertDatabase].
///
/// This returns a SQL script with multiple DDL statements separated by `;`
/// using the specified [dialect].
///
/// Executing these statements in an empty database will create the tables
/// defined in [UpsertDatabase]. In practice, this method is often used for
/// printing the DDL statements, such that migrations can be managed by
/// external tools.
///
/// [1]: https://en.wikipedia.org/wiki/Data_definition_language
String createUpsertDatabaseTables(SqlDialect dialect) => $ForGeneratedCode
    .createTableSchema(dialect: dialect, tables: UpsertDatabaseSchema._$tables);

final class _$SimpleItem extends SimpleItem {
  _$SimpleItem._(this.id, this.name, this.value);

  @override
  final int id;

  @override
  final String name;

  @override
  final int value;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'simpleItems',
    columns: <String>['id', 'name', 'value'],
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
    ],
    foreignKeys: [],
    readRow: _$SimpleItem._$fromDatabase,
  );

  static SimpleItem? _$fromDatabase(RowReader row) {
    final id = row.readInt();
    final name = row.readString();
    final value = row.readInt();
    if (id == null && name == null && value == null) {
      return null;
    }
    return _$SimpleItem._(id!, name!, value!);
  }

  @override
  String toString() => 'SimpleItem(id: "$id", name: "$name", value: "$value")';
}

/// Extension methods for table defined in [SimpleItem].
extension TableSimpleItemExt on Table<SimpleItem> {
  /// Insert row into the `simpleItems` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<SimpleItem> insert({
    Expr<int>? id,
    required Expr<String> name,
    required Expr<int> value,
  }) => $ForGeneratedCode.insertInto(table: this, values: [id, name, value]);

  /// Insert row into the `simpleItems` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<SimpleItem> insertValue({
    int? id,
    required String name,
    required int value,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [id?.asExpr, name.asExpr, value.asExpr],
  );

  /// Bulk insert rows into the `simpleItems` table.
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
  Insert<SimpleItem> insertValuesMapped<T>(
    Iterable<T> rows, {
    int Function(T row)? id,
    required String Function(T row) name,
    required int Function(T row) value,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mappings: [id, name, value],
  );

  /// Delete a single row from the `simpleItems` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<SimpleItem> delete(int id) =>
      $ForGeneratedCode.deleteSingle(byKey(id), _$SimpleItem._$table);
}

/// Extension methods for building queries against the `simpleItems` table.
extension QuerySimpleItemExt on Query<(Expr<SimpleItem>,)> {
  /// Lookup a single row in `simpleItems` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<SimpleItem>,)> byKey(int id) =>
      where((simpleItem) => simpleItem.id.equalsValue(id)).first;

  /// Update all rows in the `simpleItems` table matching this [Query].
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
  Update<SimpleItem> update(
    UpdateSet<SimpleItem> Function(
      Expr<SimpleItem> simpleItem,
      UpdateSet<SimpleItem> Function({
        Expr<int> id,
        Expr<String> name,
        Expr<int> value,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<SimpleItem>(
    this,
    _$SimpleItem._$table,
    (simpleItem) => updateBuilder(
      simpleItem,
      ({Expr<int>? id, Expr<String>? name, Expr<int>? value}) =>
          $ForGeneratedCode.buildUpdate<SimpleItem>([id, name, value]),
    ),
  );

  /// Lookup a single row in `simpleItems` table using the
  /// `name` field
  ///
  /// We know that lookup by the `name` field returns
  /// at-most one row because the [Unique] annotation in [SimpleItem].
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<SimpleItem>,)> byName(String name) =>
      where((simpleItem) => simpleItem.name.equalsValue(name)).first;

  /// Delete all rows in the `simpleItems` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<SimpleItem> delete() =>
      $ForGeneratedCode.delete(this, _$SimpleItem._$table);
}

/// Extension methods for building point queries against the `simpleItems` table.
extension QuerySingleSimpleItemExt on QuerySingle<(Expr<SimpleItem>,)> {
  /// Update the row (if any) in the `simpleItems` table matching this
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
  UpdateSingle<SimpleItem> update(
    UpdateSet<SimpleItem> Function(
      Expr<SimpleItem> simpleItem,
      UpdateSet<SimpleItem> Function({
        Expr<int> id,
        Expr<String> name,
        Expr<int> value,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<SimpleItem>(
    this,
    _$SimpleItem._$table,
    (simpleItem) => updateBuilder(
      simpleItem,
      ({Expr<int>? id, Expr<String>? name, Expr<int>? value}) =>
          $ForGeneratedCode.buildUpdate<SimpleItem>([id, name, value]),
    ),
  );

  /// Delete the row (if any) in the `simpleItems` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<SimpleItem> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$SimpleItem._$table);
}

/// Extension methods for expressions on a row in the `simpleItems` table.
extension ExpressionSimpleItemExt on Expr<SimpleItem> {
  Expr<int> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String> get name =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<int> get value =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.integer);
}

extension ExpressionNullableSimpleItemExt on Expr<SimpleItem?> {
  Expr<int?> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String?> get name =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<int?> get value =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.integer);

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

/// `Table<SimpleItem>` conflict targets for use with `.onConflict`.
enum SimpleItemConflict {
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
  name(['name']);

  const SimpleItemConflict(this._fields);

  final List<String> _fields;
}

extension InsertSimpleItemExt on Insert<SimpleItem> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((simpleItem, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflict<SimpleItem> onConflict(SimpleItemConflict target) =>
      $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictSimpleItemExt on InsertOnConflict<SimpleItem> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `simpleItem` an [Expr] representing the existing row in
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
  Upsert<SimpleItem> update(
    UpdateSet<SimpleItem> Function(
      Expr<SimpleItem> simpleItem,
      Expr<SimpleItem> excluded,
      UpdateSet<SimpleItem> Function({
        Expr<int> id,
        Expr<String> name,
        Expr<int> value,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<SimpleItem>(
    this,
    (simpleItem, excluded) => updateBuilder(
      simpleItem,
      excluded,
      ({Expr<int>? id, Expr<String>? name, Expr<int>? value}) =>
          $ForGeneratedCode.buildUpdate<SimpleItem>([id, name, value]),
    ),
  );
}

extension InsertSingleSimpleItemExt on InsertSingle<SimpleItem> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((simpleItem, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflictSingle<SimpleItem> onConflict(SimpleItemConflict target) =>
      $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleSimpleItemExt
    on InsertOnConflictSingle<SimpleItem> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `simpleItem` an [Expr] representing the existing row in
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
  UpsertSingle<SimpleItem> update(
    UpdateSet<SimpleItem> Function(
      Expr<SimpleItem> simpleItem,
      Expr<SimpleItem> excluded,
      UpdateSet<SimpleItem> Function({
        Expr<int> id,
        Expr<String> name,
        Expr<int> value,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<SimpleItem>(
    this,
    (simpleItem, excluded) => updateBuilder(
      simpleItem,
      excluded,
      ({Expr<int>? id, Expr<String>? name, Expr<int>? value}) =>
          $ForGeneratedCode.buildUpdate<SimpleItem>([id, name, value]),
    ),
  );
}

final class _$CompositeItem extends CompositeItem {
  _$CompositeItem._(
    this.partA,
    this.partB,
    this.firstName,
    this.lastName,
    this.data,
  );

  @override
  final String partA;

  @override
  final int partB;

  @override
  final String firstName;

  @override
  final String lastName;

  @override
  final String data;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'compositeItems',
    columns: <String>['partA', 'partB', 'firstName', 'lastName', 'data'],
    columnInfo: [
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
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
    ],
    primaryKey: <String>['partA', 'partB'],
    unique: <List<String>>[
      ['firstName', 'lastName'],
    ],
    foreignKeys: [],
    readRow: _$CompositeItem._$fromDatabase,
  );

  static CompositeItem? _$fromDatabase(RowReader row) {
    final partA = row.readString();
    final partB = row.readInt();
    final firstName = row.readString();
    final lastName = row.readString();
    final data = row.readString();
    if (partA == null &&
        partB == null &&
        firstName == null &&
        lastName == null &&
        data == null) {
      return null;
    }
    return _$CompositeItem._(partA!, partB!, firstName!, lastName!, data!);
  }

  @override
  String toString() =>
      'CompositeItem(partA: "$partA", partB: "$partB", firstName: "$firstName", lastName: "$lastName", data: "$data")';
}

/// Extension methods for table defined in [CompositeItem].
extension TableCompositeItemExt on Table<CompositeItem> {
  /// Insert row into the `compositeItems` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<CompositeItem> insert({
    required Expr<String> partA,
    required Expr<int> partB,
    required Expr<String> firstName,
    required Expr<String> lastName,
    required Expr<String> data,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [partA, partB, firstName, lastName, data],
  );

  /// Insert row into the `compositeItems` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<CompositeItem> insertValue({
    required String partA,
    required int partB,
    required String firstName,
    required String lastName,
    required String data,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [
      partA.asExpr,
      partB.asExpr,
      firstName.asExpr,
      lastName.asExpr,
      data.asExpr,
    ],
  );

  /// Bulk insert rows into the `compositeItems` table.
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
  Insert<CompositeItem> insertValuesMapped<T>(
    Iterable<T> rows, {
    required String Function(T row) partA,
    required int Function(T row) partB,
    required String Function(T row) firstName,
    required String Function(T row) lastName,
    required String Function(T row) data,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mappings: [partA, partB, firstName, lastName, data],
  );

  /// Delete a single row from the `compositeItems` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<CompositeItem> delete(String partA, int partB) =>
      $ForGeneratedCode.deleteSingle(
        byKey(partA, partB),
        _$CompositeItem._$table,
      );
}

/// Extension methods for building queries against the `compositeItems` table.
extension QueryCompositeItemExt on Query<(Expr<CompositeItem>,)> {
  /// Lookup a single row in `compositeItems` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<CompositeItem>,)> byKey(String partA, int partB) => where(
    (compositeItem) =>
        compositeItem.partA.equalsValue(partA) &
        compositeItem.partB.equalsValue(partB),
  ).first;

  /// Update all rows in the `compositeItems` table matching this [Query].
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
  Update<CompositeItem> update(
    UpdateSet<CompositeItem> Function(
      Expr<CompositeItem> compositeItem,
      UpdateSet<CompositeItem> Function({
        Expr<String> partA,
        Expr<int> partB,
        Expr<String> firstName,
        Expr<String> lastName,
        Expr<String> data,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<CompositeItem>(
    this,
    _$CompositeItem._$table,
    (compositeItem) => updateBuilder(
      compositeItem,
      ({
        Expr<String>? partA,
        Expr<int>? partB,
        Expr<String>? firstName,
        Expr<String>? lastName,
        Expr<String>? data,
      }) => $ForGeneratedCode.buildUpdate<CompositeItem>([
        partA,
        partB,
        firstName,
        lastName,
        data,
      ]),
    ),
  );

  /// Lookup a single row in `compositeItems` table using the
  /// `firstName`, `lastName` fields
  ///
  /// We know that lookup by the `firstName`, `lastName` fields returns
  /// at-most one row because the [Unique] annotation in [CompositeItem].
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<CompositeItem>,)> byFullname(
    String firstName,
    String lastName,
  ) => where(
    (compositeItem) =>
        compositeItem.firstName.equalsValue(firstName) &
        compositeItem.lastName.equalsValue(lastName),
  ).first;

  /// Delete all rows in the `compositeItems` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<CompositeItem> delete() =>
      $ForGeneratedCode.delete(this, _$CompositeItem._$table);
}

/// Extension methods for building point queries against the `compositeItems` table.
extension QuerySingleCompositeItemExt on QuerySingle<(Expr<CompositeItem>,)> {
  /// Update the row (if any) in the `compositeItems` table matching this
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
  UpdateSingle<CompositeItem> update(
    UpdateSet<CompositeItem> Function(
      Expr<CompositeItem> compositeItem,
      UpdateSet<CompositeItem> Function({
        Expr<String> partA,
        Expr<int> partB,
        Expr<String> firstName,
        Expr<String> lastName,
        Expr<String> data,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<CompositeItem>(
    this,
    _$CompositeItem._$table,
    (compositeItem) => updateBuilder(
      compositeItem,
      ({
        Expr<String>? partA,
        Expr<int>? partB,
        Expr<String>? firstName,
        Expr<String>? lastName,
        Expr<String>? data,
      }) => $ForGeneratedCode.buildUpdate<CompositeItem>([
        partA,
        partB,
        firstName,
        lastName,
        data,
      ]),
    ),
  );

  /// Delete the row (if any) in the `compositeItems` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<CompositeItem> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$CompositeItem._$table);
}

/// Extension methods for expressions on a row in the `compositeItems` table.
extension ExpressionCompositeItemExt on Expr<CompositeItem> {
  Expr<String> get partA =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.text);

  Expr<int> get partB =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.integer);

  Expr<String> get firstName =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  Expr<String> get lastName =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.text);

  Expr<String> get data =>
      $ForGeneratedCode.field(this, 4, $ForGeneratedCode.text);
}

extension ExpressionNullableCompositeItemExt on Expr<CompositeItem?> {
  Expr<String?> get partA =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.text);

  Expr<int?> get partB =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.integer);

  Expr<String?> get firstName =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  Expr<String?> get lastName =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.text);

  Expr<String?> get data =>
      $ForGeneratedCode.field(this, 4, $ForGeneratedCode.text);

  /// Check if the row is not `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNotNull() => partA.isNotNull() & partB.isNotNull();

  /// Check if the row is `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNull() => isNotNull().not();
}

/// `Table<CompositeItem>` conflict targets for use with `.onConflict`.
enum CompositeItemConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `partA`, `partB`.
  primaryKey(['partA', 'partB']),

  /// `firstName`, `lastName` conflict.
  ///
  /// Due to violation of the `UNIQUE` constraint on
  /// `firstName`, `lastName`.
  ///
  /// Thus, the conflicting row has matching values for these fields.
  fullname(['firstName', 'lastName']);

  const CompositeItemConflict(this._fields);

  final List<String> _fields;
}

extension InsertCompositeItemExt on Insert<CompositeItem> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((compositeItem, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflict<CompositeItem> onConflict(CompositeItemConflict target) =>
      $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictCompositeItemExt on InsertOnConflict<CompositeItem> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `compositeItem` an [Expr] representing the existing row in
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
  Upsert<CompositeItem> update(
    UpdateSet<CompositeItem> Function(
      Expr<CompositeItem> compositeItem,
      Expr<CompositeItem> excluded,
      UpdateSet<CompositeItem> Function({
        Expr<String> partA,
        Expr<int> partB,
        Expr<String> firstName,
        Expr<String> lastName,
        Expr<String> data,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<CompositeItem>(
    this,
    (compositeItem, excluded) => updateBuilder(
      compositeItem,
      excluded,
      ({
        Expr<String>? partA,
        Expr<int>? partB,
        Expr<String>? firstName,
        Expr<String>? lastName,
        Expr<String>? data,
      }) => $ForGeneratedCode.buildUpdate<CompositeItem>([
        partA,
        partB,
        firstName,
        lastName,
        data,
      ]),
    ),
  );
}

extension InsertSingleCompositeItemExt on InsertSingle<CompositeItem> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((compositeItem, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflictSingle<CompositeItem> onConflict(
    CompositeItemConflict target,
  ) => $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleCompositeItemExt
    on InsertOnConflictSingle<CompositeItem> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `compositeItem` an [Expr] representing the existing row in
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
  UpsertSingle<CompositeItem> update(
    UpdateSet<CompositeItem> Function(
      Expr<CompositeItem> compositeItem,
      Expr<CompositeItem> excluded,
      UpdateSet<CompositeItem> Function({
        Expr<String> partA,
        Expr<int> partB,
        Expr<String> firstName,
        Expr<String> lastName,
        Expr<String> data,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<CompositeItem>(
    this,
    (compositeItem, excluded) => updateBuilder(
      compositeItem,
      excluded,
      ({
        Expr<String>? partA,
        Expr<int>? partB,
        Expr<String>? firstName,
        Expr<String>? lastName,
        Expr<String>? data,
      }) => $ForGeneratedCode.buildUpdate<CompositeItem>([
        partA,
        partB,
        firstName,
        lastName,
        data,
      ]),
    ),
  );
}

final class _$NullableUniqueItem extends NullableUniqueItem {
  _$NullableUniqueItem._(this.id, this.code, this.description);

  @override
  final int id;

  @override
  final String? code;

  @override
  final String description;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'nullableUniqueItems',
    columns: <String>['id', 'code', 'description'],
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
        isNotNull: false,
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
        overrides: [],
      ),
    ],
    primaryKey: <String>['id'],
    unique: <List<String>>[
      ['code'],
    ],
    foreignKeys: [],
    readRow: _$NullableUniqueItem._$fromDatabase,
  );

  static NullableUniqueItem? _$fromDatabase(RowReader row) {
    final id = row.readInt();
    final code = row.readString();
    final description = row.readString();
    if (id == null && code == null && description == null) {
      return null;
    }
    return _$NullableUniqueItem._(id!, code, description!);
  }

  @override
  String toString() =>
      'NullableUniqueItem(id: "$id", code: "$code", description: "$description")';
}

/// Extension methods for table defined in [NullableUniqueItem].
extension TableNullableUniqueItemExt on Table<NullableUniqueItem> {
  /// Insert row into the `nullableUniqueItems` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<NullableUniqueItem> insert({
    Expr<int>? id,
    Expr<String?>? code,
    required Expr<String> description,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [id, code, description],
  );

  /// Insert row into the `nullableUniqueItems` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<NullableUniqueItem> insertValue({
    int? id,
    String? code,
    required String description,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [id?.asExpr, code.asExpr, description.asExpr],
  );

  /// Bulk insert rows into the `nullableUniqueItems` table.
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
  Insert<NullableUniqueItem> insertValuesMapped<T>(
    Iterable<T> rows, {
    int Function(T row)? id,
    String? Function(T row)? code,
    required String Function(T row) description,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mappings: [id, code, description],
  );

  /// Delete a single row from the `nullableUniqueItems` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<NullableUniqueItem> delete(int id) =>
      $ForGeneratedCode.deleteSingle(byKey(id), _$NullableUniqueItem._$table);
}

/// Extension methods for building queries against the `nullableUniqueItems` table.
extension QueryNullableUniqueItemExt on Query<(Expr<NullableUniqueItem>,)> {
  /// Lookup a single row in `nullableUniqueItems` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<NullableUniqueItem>,)> byKey(int id) => where(
    (nullableUniqueItem) => nullableUniqueItem.id.equalsValue(id),
  ).first;

  /// Update all rows in the `nullableUniqueItems` table matching this [Query].
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
  Update<NullableUniqueItem> update(
    UpdateSet<NullableUniqueItem> Function(
      Expr<NullableUniqueItem> nullableUniqueItem,
      UpdateSet<NullableUniqueItem> Function({
        Expr<int> id,
        Expr<String?> code,
        Expr<String> description,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<NullableUniqueItem>(
    this,
    _$NullableUniqueItem._$table,
    (nullableUniqueItem) => updateBuilder(
      nullableUniqueItem,
      ({Expr<int>? id, Expr<String?>? code, Expr<String>? description}) =>
          $ForGeneratedCode.buildUpdate<NullableUniqueItem>([
            id,
            code,
            description,
          ]),
    ),
  );

  /// Lookup a single row in `nullableUniqueItems` table using the
  /// `code` field
  ///
  /// We know that lookup by the `code` field returns
  /// at-most one row because the [Unique] annotation in [NullableUniqueItem].
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<NullableUniqueItem>,)> byCode(String code) => where(
    (nullableUniqueItem) =>
        nullableUniqueItem.code.equalsUnlessNull(toExpr(code)),
  ).first;

  /// Delete all rows in the `nullableUniqueItems` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<NullableUniqueItem> delete() =>
      $ForGeneratedCode.delete(this, _$NullableUniqueItem._$table);
}

/// Extension methods for building point queries against the `nullableUniqueItems` table.
extension QuerySingleNullableUniqueItemExt
    on QuerySingle<(Expr<NullableUniqueItem>,)> {
  /// Update the row (if any) in the `nullableUniqueItems` table matching this
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
  UpdateSingle<NullableUniqueItem> update(
    UpdateSet<NullableUniqueItem> Function(
      Expr<NullableUniqueItem> nullableUniqueItem,
      UpdateSet<NullableUniqueItem> Function({
        Expr<int> id,
        Expr<String?> code,
        Expr<String> description,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<NullableUniqueItem>(
    this,
    _$NullableUniqueItem._$table,
    (nullableUniqueItem) => updateBuilder(
      nullableUniqueItem,
      ({Expr<int>? id, Expr<String?>? code, Expr<String>? description}) =>
          $ForGeneratedCode.buildUpdate<NullableUniqueItem>([
            id,
            code,
            description,
          ]),
    ),
  );

  /// Delete the row (if any) in the `nullableUniqueItems` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<NullableUniqueItem> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$NullableUniqueItem._$table);
}

/// Extension methods for expressions on a row in the `nullableUniqueItems` table.
extension ExpressionNullableUniqueItemExt on Expr<NullableUniqueItem> {
  Expr<int> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String?> get code =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<String> get description =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);
}

extension ExpressionNullableNullableUniqueItemExt on Expr<NullableUniqueItem?> {
  Expr<int?> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String?> get code =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<String?> get description =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

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

/// `Table<NullableUniqueItem>` conflict targets for use with `.onConflict`.
enum NullableUniqueItemConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `id`.
  primaryKey(['id']),

  /// `code` conflict.
  ///
  /// Due to violation of the `UNIQUE` constraint on
  /// `code`.
  ///
  /// Thus, the conflicting row has matching values for these fields.
  code(['code']);

  const NullableUniqueItemConflict(this._fields);

  final List<String> _fields;
}

extension InsertNullableUniqueItemExt on Insert<NullableUniqueItem> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((nullableUniqueItem, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflict<NullableUniqueItem> onConflict(
    NullableUniqueItemConflict target,
  ) => $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictNullableUniqueItemExt
    on InsertOnConflict<NullableUniqueItem> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `nullableUniqueItem` an [Expr] representing the existing row in
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
  Upsert<NullableUniqueItem> update(
    UpdateSet<NullableUniqueItem> Function(
      Expr<NullableUniqueItem> nullableUniqueItem,
      Expr<NullableUniqueItem> excluded,
      UpdateSet<NullableUniqueItem> Function({
        Expr<int> id,
        Expr<String?> code,
        Expr<String> description,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<NullableUniqueItem>(
    this,
    (nullableUniqueItem, excluded) => updateBuilder(
      nullableUniqueItem,
      excluded,
      ({Expr<int>? id, Expr<String?>? code, Expr<String>? description}) =>
          $ForGeneratedCode.buildUpdate<NullableUniqueItem>([
            id,
            code,
            description,
          ]),
    ),
  );
}

extension InsertSingleNullableUniqueItemExt
    on InsertSingle<NullableUniqueItem> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((nullableUniqueItem, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflictSingle<NullableUniqueItem> onConflict(
    NullableUniqueItemConflict target,
  ) => $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleNullableUniqueItemExt
    on InsertOnConflictSingle<NullableUniqueItem> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `nullableUniqueItem` an [Expr] representing the existing row in
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
  UpsertSingle<NullableUniqueItem> update(
    UpdateSet<NullableUniqueItem> Function(
      Expr<NullableUniqueItem> nullableUniqueItem,
      Expr<NullableUniqueItem> excluded,
      UpdateSet<NullableUniqueItem> Function({
        Expr<int> id,
        Expr<String?> code,
        Expr<String> description,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<NullableUniqueItem>(
    this,
    (nullableUniqueItem, excluded) => updateBuilder(
      nullableUniqueItem,
      excluded,
      ({Expr<int>? id, Expr<String?>? code, Expr<String>? description}) =>
          $ForGeneratedCode.buildUpdate<NullableUniqueItem>([
            id,
            code,
            description,
          ]),
    ),
  );
}

final class _$SubQueryItem extends SubQueryItem {
  _$SubQueryItem._(this.id, this.tag, this.refId, this.count);

  @override
  final int id;

  @override
  final String tag;

  @override
  final int refId;

  @override
  final int count;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'subQueryItems',
    columns: <String>['id', 'tag', 'refId', 'count'],
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
        type: $ForGeneratedCode.integer,
        isNotNull: true,
        defaultValue: null,
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
    primaryKey: <String>['id'],
    unique: <List<String>>[
      ['tag'],
    ],
    foreignKeys: [
      $ForGeneratedCode.foreignKeyDefinition(
        name: 'null',
        columns: ['refId'],
        referencedTable: 'simpleItems',
        referencedColumns: ['id'],
        onDelete: .noAction,
        onUpdate: .noAction,
      ),
    ],
    readRow: _$SubQueryItem._$fromDatabase,
  );

  static SubQueryItem? _$fromDatabase(RowReader row) {
    final id = row.readInt();
    final tag = row.readString();
    final refId = row.readInt();
    final count = row.readInt();
    if (id == null && tag == null && refId == null && count == null) {
      return null;
    }
    return _$SubQueryItem._(id!, tag!, refId!, count!);
  }

  @override
  String toString() =>
      'SubQueryItem(id: "$id", tag: "$tag", refId: "$refId", count: "$count")';
}

/// Extension methods for table defined in [SubQueryItem].
extension TableSubQueryItemExt on Table<SubQueryItem> {
  /// Insert row into the `subQueryItems` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<SubQueryItem> insert({
    Expr<int>? id,
    required Expr<String> tag,
    required Expr<int> refId,
    required Expr<int> count,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [id, tag, refId, count],
  );

  /// Insert row into the `subQueryItems` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<SubQueryItem> insertValue({
    int? id,
    required String tag,
    required int refId,
    required int count,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [id?.asExpr, tag.asExpr, refId.asExpr, count.asExpr],
  );

  /// Bulk insert rows into the `subQueryItems` table.
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
  Insert<SubQueryItem> insertValuesMapped<T>(
    Iterable<T> rows, {
    int Function(T row)? id,
    required String Function(T row) tag,
    required int Function(T row) refId,
    required int Function(T row) count,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mappings: [id, tag, refId, count],
  );

  /// Delete a single row from the `subQueryItems` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<SubQueryItem> delete(int id) =>
      $ForGeneratedCode.deleteSingle(byKey(id), _$SubQueryItem._$table);
}

/// Extension methods for building queries against the `subQueryItems` table.
extension QuerySubQueryItemExt on Query<(Expr<SubQueryItem>,)> {
  /// Lookup a single row in `subQueryItems` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<SubQueryItem>,)> byKey(int id) =>
      where((subQueryItem) => subQueryItem.id.equalsValue(id)).first;

  /// Update all rows in the `subQueryItems` table matching this [Query].
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
  Update<SubQueryItem> update(
    UpdateSet<SubQueryItem> Function(
      Expr<SubQueryItem> subQueryItem,
      UpdateSet<SubQueryItem> Function({
        Expr<int> id,
        Expr<String> tag,
        Expr<int> refId,
        Expr<int> count,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<SubQueryItem>(
    this,
    _$SubQueryItem._$table,
    (subQueryItem) => updateBuilder(
      subQueryItem,
      ({
        Expr<int>? id,
        Expr<String>? tag,
        Expr<int>? refId,
        Expr<int>? count,
      }) =>
          $ForGeneratedCode.buildUpdate<SubQueryItem>([id, tag, refId, count]),
    ),
  );

  /// Lookup a single row in `subQueryItems` table using the
  /// `tag` field
  ///
  /// We know that lookup by the `tag` field returns
  /// at-most one row because the [Unique] annotation in [SubQueryItem].
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<SubQueryItem>,)> byTag(String tag) =>
      where((subQueryItem) => subQueryItem.tag.equalsValue(tag)).first;

  /// Delete all rows in the `subQueryItems` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<SubQueryItem> delete() =>
      $ForGeneratedCode.delete(this, _$SubQueryItem._$table);
}

/// Extension methods for building point queries against the `subQueryItems` table.
extension QuerySingleSubQueryItemExt on QuerySingle<(Expr<SubQueryItem>,)> {
  /// Update the row (if any) in the `subQueryItems` table matching this
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
  UpdateSingle<SubQueryItem> update(
    UpdateSet<SubQueryItem> Function(
      Expr<SubQueryItem> subQueryItem,
      UpdateSet<SubQueryItem> Function({
        Expr<int> id,
        Expr<String> tag,
        Expr<int> refId,
        Expr<int> count,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<SubQueryItem>(
    this,
    _$SubQueryItem._$table,
    (subQueryItem) => updateBuilder(
      subQueryItem,
      ({
        Expr<int>? id,
        Expr<String>? tag,
        Expr<int>? refId,
        Expr<int>? count,
      }) =>
          $ForGeneratedCode.buildUpdate<SubQueryItem>([id, tag, refId, count]),
    ),
  );

  /// Delete the row (if any) in the `subQueryItems` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<SubQueryItem> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$SubQueryItem._$table);
}

/// Extension methods for expressions on a row in the `subQueryItems` table.
extension ExpressionSubQueryItemExt on Expr<SubQueryItem> {
  Expr<int> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String> get tag =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<int> get refId =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.integer);

  Expr<int> get count =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.integer);
}

extension ExpressionNullableSubQueryItemExt on Expr<SubQueryItem?> {
  Expr<int?> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String?> get tag =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<int?> get refId =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.integer);

  Expr<int?> get count =>
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

/// `Table<SubQueryItem>` conflict targets for use with `.onConflict`.
enum SubQueryItemConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `id`.
  primaryKey(['id']),

  /// `tag` conflict.
  ///
  /// Due to violation of the `UNIQUE` constraint on
  /// `tag`.
  ///
  /// Thus, the conflicting row has matching values for these fields.
  tag(['tag']);

  const SubQueryItemConflict(this._fields);

  final List<String> _fields;
}

extension InsertSubQueryItemExt on Insert<SubQueryItem> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((subQueryItem, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflict<SubQueryItem> onConflict(SubQueryItemConflict target) =>
      $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictSubQueryItemExt on InsertOnConflict<SubQueryItem> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `subQueryItem` an [Expr] representing the existing row in
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
  Upsert<SubQueryItem> update(
    UpdateSet<SubQueryItem> Function(
      Expr<SubQueryItem> subQueryItem,
      Expr<SubQueryItem> excluded,
      UpdateSet<SubQueryItem> Function({
        Expr<int> id,
        Expr<String> tag,
        Expr<int> refId,
        Expr<int> count,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<SubQueryItem>(
    this,
    (subQueryItem, excluded) => updateBuilder(
      subQueryItem,
      excluded,
      ({
        Expr<int>? id,
        Expr<String>? tag,
        Expr<int>? refId,
        Expr<int>? count,
      }) =>
          $ForGeneratedCode.buildUpdate<SubQueryItem>([id, tag, refId, count]),
    ),
  );
}

extension InsertSingleSubQueryItemExt on InsertSingle<SubQueryItem> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((subQueryItem, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflictSingle<SubQueryItem> onConflict(
    SubQueryItemConflict target,
  ) => $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleSubQueryItemExt
    on InsertOnConflictSingle<SubQueryItem> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `subQueryItem` an [Expr] representing the existing row in
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
  UpsertSingle<SubQueryItem> update(
    UpdateSet<SubQueryItem> Function(
      Expr<SubQueryItem> subQueryItem,
      Expr<SubQueryItem> excluded,
      UpdateSet<SubQueryItem> Function({
        Expr<int> id,
        Expr<String> tag,
        Expr<int> refId,
        Expr<int> count,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<SubQueryItem>(
    this,
    (subQueryItem, excluded) => updateBuilder(
      subQueryItem,
      excluded,
      ({
        Expr<int>? id,
        Expr<String>? tag,
        Expr<int>? refId,
        Expr<int>? count,
      }) =>
          $ForGeneratedCode.buildUpdate<SubQueryItem>([id, tag, refId, count]),
    ),
  );
}

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

final class _$CustomTypeItem extends CustomTypeItem {
  _$CustomTypeItem._(this.id, this.value);

  @override
  final int id;

  @override
  final MyCustomType value;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'customTypeItems',
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
        type: $ForGeneratedCode.integer,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
    ],
    primaryKey: <String>['id'],
    unique: <List<String>>[
      ['value'],
    ],
    foreignKeys: [],
    readRow: _$CustomTypeItem._$fromDatabase,
  );

  static CustomTypeItem? _$fromDatabase(RowReader row) {
    final id = row.readInt();
    final value = $ForGeneratedCode.customDataTypeOrNull(
      row.readInt(),
      MyCustomType.fromDatabase,
    );
    if (id == null && value == null) {
      return null;
    }
    return _$CustomTypeItem._(id!, value!);
  }

  @override
  String toString() => 'CustomTypeItem(id: "$id", value: "$value")';
}

/// Extension methods for table defined in [CustomTypeItem].
extension TableCustomTypeItemExt on Table<CustomTypeItem> {
  /// Insert row into the `customTypeItems` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<CustomTypeItem> insert({
    Expr<int>? id,
    required Expr<MyCustomType> value,
  }) => $ForGeneratedCode.insertInto(table: this, values: [id, value]);

  /// Insert row into the `customTypeItems` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<CustomTypeItem> insertValue({
    int? id,
    required MyCustomType value,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [id?.asExpr, value.asExpr],
  );

  /// Bulk insert rows into the `customTypeItems` table.
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
  Insert<CustomTypeItem> insertValuesMapped<T>(
    Iterable<T> rows, {
    int Function(T row)? id,
    required MyCustomType Function(T row) value,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mappings: [id, (T v) => value(v).toDatabase()],
  );

  /// Delete a single row from the `customTypeItems` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<CustomTypeItem> delete(int id) =>
      $ForGeneratedCode.deleteSingle(byKey(id), _$CustomTypeItem._$table);
}

/// Extension methods for building queries against the `customTypeItems` table.
extension QueryCustomTypeItemExt on Query<(Expr<CustomTypeItem>,)> {
  /// Lookup a single row in `customTypeItems` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<CustomTypeItem>,)> byKey(int id) =>
      where((customTypeItem) => customTypeItem.id.equalsValue(id)).first;

  /// Update all rows in the `customTypeItems` table matching this [Query].
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
  Update<CustomTypeItem> update(
    UpdateSet<CustomTypeItem> Function(
      Expr<CustomTypeItem> customTypeItem,
      UpdateSet<CustomTypeItem> Function({
        Expr<int> id,
        Expr<MyCustomType> value,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<CustomTypeItem>(
    this,
    _$CustomTypeItem._$table,
    (customTypeItem) => updateBuilder(
      customTypeItem,
      ({Expr<int>? id, Expr<MyCustomType>? value}) =>
          $ForGeneratedCode.buildUpdate<CustomTypeItem>([id, value]),
    ),
  );

  /// Lookup a single row in `customTypeItems` table using the
  /// `value` field
  ///
  /// We know that lookup by the `value` field returns
  /// at-most one row because the [Unique] annotation in [CustomTypeItem].
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<CustomTypeItem>,)> byValue(MyCustomType value) => where(
    (customTypeItem) =>
        customTypeItem.value.asEncoded().equalsValue(value.toDatabase()),
  ).first;

  /// Delete all rows in the `customTypeItems` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<CustomTypeItem> delete() =>
      $ForGeneratedCode.delete(this, _$CustomTypeItem._$table);
}

/// Extension methods for building point queries against the `customTypeItems` table.
extension QuerySingleCustomTypeItemExt on QuerySingle<(Expr<CustomTypeItem>,)> {
  /// Update the row (if any) in the `customTypeItems` table matching this
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
  UpdateSingle<CustomTypeItem> update(
    UpdateSet<CustomTypeItem> Function(
      Expr<CustomTypeItem> customTypeItem,
      UpdateSet<CustomTypeItem> Function({
        Expr<int> id,
        Expr<MyCustomType> value,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<CustomTypeItem>(
    this,
    _$CustomTypeItem._$table,
    (customTypeItem) => updateBuilder(
      customTypeItem,
      ({Expr<int>? id, Expr<MyCustomType>? value}) =>
          $ForGeneratedCode.buildUpdate<CustomTypeItem>([id, value]),
    ),
  );

  /// Delete the row (if any) in the `customTypeItems` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<CustomTypeItem> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$CustomTypeItem._$table);
}

/// Extension methods for expressions on a row in the `customTypeItems` table.
extension ExpressionCustomTypeItemExt on Expr<CustomTypeItem> {
  Expr<int> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<MyCustomType> get value =>
      $ForGeneratedCode.field(this, 1, MyCustomTypeExt._exprType);
}

extension ExpressionNullableCustomTypeItemExt on Expr<CustomTypeItem?> {
  Expr<int?> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<MyCustomType?> get value =>
      $ForGeneratedCode.field(this, 1, MyCustomTypeExt._exprType);

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

/// `Table<CustomTypeItem>` conflict targets for use with `.onConflict`.
enum CustomTypeItemConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `id`.
  primaryKey(['id']),

  /// `value` conflict.
  ///
  /// Due to violation of the `UNIQUE` constraint on
  /// `value`.
  ///
  /// Thus, the conflicting row has matching values for these fields.
  value(['value']);

  const CustomTypeItemConflict(this._fields);

  final List<String> _fields;
}

extension InsertCustomTypeItemExt on Insert<CustomTypeItem> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((customTypeItem, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflict<CustomTypeItem> onConflict(CustomTypeItemConflict target) =>
      $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictCustomTypeItemExt
    on InsertOnConflict<CustomTypeItem> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `customTypeItem` an [Expr] representing the existing row in
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
  Upsert<CustomTypeItem> update(
    UpdateSet<CustomTypeItem> Function(
      Expr<CustomTypeItem> customTypeItem,
      Expr<CustomTypeItem> excluded,
      UpdateSet<CustomTypeItem> Function({
        Expr<int> id,
        Expr<MyCustomType> value,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<CustomTypeItem>(
    this,
    (customTypeItem, excluded) => updateBuilder(
      customTypeItem,
      excluded,
      ({Expr<int>? id, Expr<MyCustomType>? value}) =>
          $ForGeneratedCode.buildUpdate<CustomTypeItem>([id, value]),
    ),
  );
}

extension InsertSingleCustomTypeItemExt on InsertSingle<CustomTypeItem> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((customTypeItem, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflictSingle<CustomTypeItem> onConflict(
    CustomTypeItemConflict target,
  ) => $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleCustomTypeItemExt
    on InsertOnConflictSingle<CustomTypeItem> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `customTypeItem` an [Expr] representing the existing row in
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
  UpsertSingle<CustomTypeItem> update(
    UpdateSet<CustomTypeItem> Function(
      Expr<CustomTypeItem> customTypeItem,
      Expr<CustomTypeItem> excluded,
      UpdateSet<CustomTypeItem> Function({
        Expr<int> id,
        Expr<MyCustomType> value,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<CustomTypeItem>(
    this,
    (customTypeItem, excluded) => updateBuilder(
      customTypeItem,
      excluded,
      ({Expr<int>? id, Expr<MyCustomType>? value}) =>
          $ForGeneratedCode.buildUpdate<CustomTypeItem>([id, value]),
    ),
  );
}

/// Wrap this [MyCustomType] as [Expr<MyCustomType>] for use queries with
/// `package:typed_sql`.
extension MyCustomTypeExt on MyCustomType {
  static final _exprType = $ForGeneratedCode.customDataType(
    $ForGeneratedCode.integer,
    MyCustomType.fromDatabase,
  );

  /// Wrap this [MyCustomType] as [Expr<MyCustomType>] for use queries with
  /// `package:typed_sql`.
  ///
  /// Using [asExpr] will inject this value as an SQL parameter,
  /// use [asExprLiteral] if you wish to inject as SQL literal instead.
  Expr<MyCustomType> get asExpr =>
      $ForGeneratedCode.customDataTypeAsExpr(this, _exprType).asNotNull();

  /// Wrap this [MyCustomType] as [Expr<MyCustomType>] for use queries with
  /// `package:typed_sql`.
  ///
  /// Using [asExprLiteral] will inject this value as an SQL literal,
  /// use [asExpr] if you wish to inject as SQL parameter instead.
  Expr<MyCustomType> get asExprLiteral => $ForGeneratedCode
      .customDataTypeAsExprLiteral(this, _exprType)
      .asNotNull();
}

/// Wrap this [MyCustomType] as [Expr<MyCustomType>] for use queries with
/// `package:typed_sql`.
extension MyCustomTypeNullableExt on MyCustomType? {
  /// Wrap this [MyCustomType] as [Expr<MyCustomType?>] for use queries with
  /// `package:typed_sql`.
  ///
  /// Using [asExpr] will inject this value as an SQL parameter,
  /// use [asExprLiteral] if you wish to inject as SQL literal instead.
  Expr<MyCustomType?> get asExpr =>
      $ForGeneratedCode.customDataTypeAsExpr(this, MyCustomTypeExt._exprType);

  /// Wrap this [MyCustomType] as [Expr<MyCustomType?>] for use queries with
  /// `package:typed_sql`.
  ///
  /// Using [asExprLiteral] will inject this value as an SQL literal,
  /// use [asExpr] if you wish to inject as SQL parameter instead.
  Expr<MyCustomType?> get asExprLiteral => $ForGeneratedCode
      .customDataTypeAsExprLiteral(this, MyCustomTypeExt._exprType);
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

/// Extension methods for assertions on [CompositeItem] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension CompositeItemChecks on Subject<CompositeItem> {
  /// Create assertions on [CompositeItem.partA].
  Subject<String> get partA => has((m) => m.partA, 'partA');

  /// Create assertions on [CompositeItem.partB].
  Subject<int> get partB => has((m) => m.partB, 'partB');

  /// Create assertions on [CompositeItem.firstName].
  Subject<String> get firstName => has((m) => m.firstName, 'firstName');

  /// Create assertions on [CompositeItem.lastName].
  Subject<String> get lastName => has((m) => m.lastName, 'lastName');

  /// Create assertions on [CompositeItem.data].
  Subject<String> get data => has((m) => m.data, 'data');
}

/// Extension methods for assertions on [CustomTypeItem] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension CustomTypeItemChecks on Subject<CustomTypeItem> {
  /// Create assertions on [CustomTypeItem.id].
  Subject<int> get id => has((m) => m.id, 'id');

  /// Create assertions on [CustomTypeItem.value].
  Subject<MyCustomType> get value => has((m) => m.value, 'value');
}

/// Extension methods for assertions on [NullableUniqueItem] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension NullableUniqueItemChecks on Subject<NullableUniqueItem> {
  /// Create assertions on [NullableUniqueItem.id].
  Subject<int> get id => has((m) => m.id, 'id');

  /// Create assertions on [NullableUniqueItem.code].
  Subject<String?> get code => has((m) => m.code, 'code');

  /// Create assertions on [NullableUniqueItem.description].
  Subject<String> get description => has((m) => m.description, 'description');
}

/// Extension methods for assertions on [SimpleItem] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension SimpleItemChecks on Subject<SimpleItem> {
  /// Create assertions on [SimpleItem.id].
  Subject<int> get id => has((m) => m.id, 'id');

  /// Create assertions on [SimpleItem.name].
  Subject<String> get name => has((m) => m.name, 'name');

  /// Create assertions on [SimpleItem.value].
  Subject<int> get value => has((m) => m.value, 'value');
}

/// Extension methods for assertions on [SubQueryItem] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension SubQueryItemChecks on Subject<SubQueryItem> {
  /// Create assertions on [SubQueryItem.id].
  Subject<int> get id => has((m) => m.id, 'id');

  /// Create assertions on [SubQueryItem.tag].
  Subject<String> get tag => has((m) => m.tag, 'tag');

  /// Create assertions on [SubQueryItem.refId].
  Subject<int> get refId => has((m) => m.refId, 'refId');

  /// Create assertions on [SubQueryItem.count].
  Subject<int> get count => has((m) => m.count, 'count');
}
