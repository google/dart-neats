// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insert_values_mapped_conflict_test.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

/// Extension methods for a [Database] operating on [ConflictMappedDatabase].
extension ConflictMappedDatabaseSchema on Database<ConflictMappedDatabase> {
  static final _$tables = [_$ConflictMappedItem._$table];

  Table<ConflictMappedItem> get conflictMappedItems =>
      $ForGeneratedCode.declareTable(this, _$ConflictMappedItem._$table);

  /// Create tables defined in [ConflictMappedDatabase].
  ///
  /// Calling this on an empty database will create the tables
  /// defined in [ConflictMappedDatabase]. In production it's often better to
  /// use [createConflictMappedDatabaseTables] and manage migrations using
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

/// Get SQL [DDL statements][1] for tables defined in [ConflictMappedDatabase].
///
/// This returns a SQL script with multiple DDL statements separated by `;`
/// using the specified [dialect].
///
/// Executing these statements in an empty database will create the tables
/// defined in [ConflictMappedDatabase]. In practice, this method is often used for
/// printing the DDL statements, such that migrations can be managed by
/// external tools.
///
/// [1]: https://en.wikipedia.org/wiki/Data_definition_language
String createConflictMappedDatabaseTables(SqlDialect dialect) =>
    $ForGeneratedCode.createTableSchema(
      dialect: dialect,
      tables: ConflictMappedDatabaseSchema._$tables,
    );

final class _$ConflictMappedItem extends ConflictMappedItem {
  _$ConflictMappedItem._(this.id, this.name, this.value);

  @override
  final int id;

  @override
  final String name;

  @override
  final int value;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'conflictMappedItems',
    columns: <String>['id', 'name', 'value'],
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
    readRow: _$ConflictMappedItem._$fromDatabase,
  );

  static ConflictMappedItem? _$fromDatabase(RowReader row) {
    final id = row.readInt();
    final name = row.readString();
    final value = row.readInt();
    if (id == null && name == null && value == null) {
      return null;
    }
    return _$ConflictMappedItem._(id!, name!, value!);
  }

  @override
  String toString() =>
      'ConflictMappedItem(id: "$id", name: "$name", value: "$value")';
}

/// Extension methods for table defined in [ConflictMappedItem].
extension TableConflictMappedItemExt on Table<ConflictMappedItem> {
  /// Insert row into the `conflictMappedItems` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<ConflictMappedItem> insert({
    required Expr<int> id,
    required Expr<String> name,
    required Expr<int> value,
  }) => $ForGeneratedCode.insertInto(table: this, values: [id, name, value]);

  /// Insert row into the `conflictMappedItems` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<ConflictMappedItem> insertValue({
    required int id,
    required String name,
    required int value,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [id.asExpr, name.asExpr, value.asExpr],
  );

  /// Bulk insert rows into the `conflictMappedItems` table.
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
  Insert<ConflictMappedItem> insertValuesMapped<T>(
    Iterable<T> rows, {
    required int Function(T row) id,
    required String Function(T row) name,
    required int Function(T row) value,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mapping: {'id': id, 'name': name, 'value': value},
  );

  /// Delete a single row from the `conflictMappedItems` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<ConflictMappedItem> delete(int id) =>
      $ForGeneratedCode.deleteSingle(byKey(id), _$ConflictMappedItem._$table);
}

/// Extension methods for building queries against the `conflictMappedItems` table.
extension QueryConflictMappedItemExt on Query<(Expr<ConflictMappedItem>,)> {
  /// Lookup a single row in `conflictMappedItems` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<ConflictMappedItem>,)> byKey(int id) => where(
    (conflictMappedItem) => conflictMappedItem.id.equalsValue(id),
  ).first;

  /// Update all rows in the `conflictMappedItems` table matching this [Query].
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
  Update<ConflictMappedItem> update(
    UpdateSet<ConflictMappedItem> Function(
      Expr<ConflictMappedItem> conflictMappedItem,
      UpdateSet<ConflictMappedItem> Function({
        Expr<int> id,
        Expr<String> name,
        Expr<int> value,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<ConflictMappedItem>(
    this,
    _$ConflictMappedItem._$table,
    (conflictMappedItem) => updateBuilder(
      conflictMappedItem,
      ({Expr<int>? id, Expr<String>? name, Expr<int>? value}) =>
          $ForGeneratedCode.buildUpdate<ConflictMappedItem>([id, name, value]),
    ),
  );

  /// Lookup a single row in `conflictMappedItems` table using the
  /// `name` field
  ///
  /// We know that lookup by the `name` field returns
  /// at-most one row because the [Unique] annotation in [ConflictMappedItem].
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<ConflictMappedItem>,)> byName(String name) => where(
    (conflictMappedItem) => conflictMappedItem.name.equalsValue(name),
  ).first;

  /// Delete all rows in the `conflictMappedItems` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<ConflictMappedItem> delete() =>
      $ForGeneratedCode.delete(this, _$ConflictMappedItem._$table);
}

/// Extension methods for building point queries against the `conflictMappedItems` table.
extension QuerySingleConflictMappedItemExt
    on QuerySingle<(Expr<ConflictMappedItem>,)> {
  /// Update the row (if any) in the `conflictMappedItems` table matching this
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
  UpdateSingle<ConflictMappedItem> update(
    UpdateSet<ConflictMappedItem> Function(
      Expr<ConflictMappedItem> conflictMappedItem,
      UpdateSet<ConflictMappedItem> Function({
        Expr<int> id,
        Expr<String> name,
        Expr<int> value,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<ConflictMappedItem>(
    this,
    _$ConflictMappedItem._$table,
    (conflictMappedItem) => updateBuilder(
      conflictMappedItem,
      ({Expr<int>? id, Expr<String>? name, Expr<int>? value}) =>
          $ForGeneratedCode.buildUpdate<ConflictMappedItem>([id, name, value]),
    ),
  );

  /// Delete the row (if any) in the `conflictMappedItems` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<ConflictMappedItem> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$ConflictMappedItem._$table);
}

/// Extension methods for expressions on a row in the `conflictMappedItems` table.
extension ExpressionConflictMappedItemExt on Expr<ConflictMappedItem> {
  Expr<int> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String> get name =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<int> get value =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.integer);
}

extension ExpressionNullableConflictMappedItemExt on Expr<ConflictMappedItem?> {
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

/// `Table<ConflictMappedItem>` conflict targets for use with `.onConflict`.
enum ConflictMappedItemConflict {
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

  const ConflictMappedItemConflict(this._fields);

  final List<String> _fields;
}

extension InsertConflictMappedItemExt on Insert<ConflictMappedItem> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((conflictMappedItem, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflict<ConflictMappedItem> onConflict(
    ConflictMappedItemConflict target,
  ) => $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictConflictMappedItemExt
    on InsertOnConflict<ConflictMappedItem> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `conflictMappedItem` an [Expr] representing the existing row in
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
  Upsert<ConflictMappedItem> update(
    UpdateSet<ConflictMappedItem> Function(
      Expr<ConflictMappedItem> conflictMappedItem,
      Expr<ConflictMappedItem> excluded,
      UpdateSet<ConflictMappedItem> Function({
        Expr<int> id,
        Expr<String> name,
        Expr<int> value,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<ConflictMappedItem>(
    this,
    (conflictMappedItem, excluded) => updateBuilder(
      conflictMappedItem,
      excluded,
      ({Expr<int>? id, Expr<String>? name, Expr<int>? value}) =>
          $ForGeneratedCode.buildUpdate<ConflictMappedItem>([id, name, value]),
    ),
  );
}

extension InsertSingleConflictMappedItemExt
    on InsertSingle<ConflictMappedItem> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((conflictMappedItem, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflictSingle<ConflictMappedItem> onConflict(
    ConflictMappedItemConflict target,
  ) => $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleConflictMappedItemExt
    on InsertOnConflictSingle<ConflictMappedItem> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `conflictMappedItem` an [Expr] representing the existing row in
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
  UpsertSingle<ConflictMappedItem> update(
    UpdateSet<ConflictMappedItem> Function(
      Expr<ConflictMappedItem> conflictMappedItem,
      Expr<ConflictMappedItem> excluded,
      UpdateSet<ConflictMappedItem> Function({
        Expr<int> id,
        Expr<String> name,
        Expr<int> value,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<ConflictMappedItem>(
    this,
    (conflictMappedItem, excluded) => updateBuilder(
      conflictMappedItem,
      excluded,
      ({Expr<int>? id, Expr<String>? name, Expr<int>? value}) =>
          $ForGeneratedCode.buildUpdate<ConflictMappedItem>([id, name, value]),
    ),
  );
}

/// Extension methods for assertions on [ConflictMappedItem] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension ConflictMappedItemChecks on Subject<ConflictMappedItem> {
  /// Create assertions on [ConflictMappedItem.id].
  Subject<int> get id => has((m) => m.id, 'id');

  /// Create assertions on [ConflictMappedItem.name].
  Subject<String> get name => has((m) => m.name, 'name');

  /// Create assertions on [ConflictMappedItem.value].
  Subject<int> get value => has((m) => m.value, 'value');
}
