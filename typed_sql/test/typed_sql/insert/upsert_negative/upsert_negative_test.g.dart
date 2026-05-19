// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upsert_negative_test.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

/// Extension methods for a [Database] operating on [NegativeDatabase].
extension NegativeDatabaseSchema on Database<NegativeDatabase> {
  static final _$tables = [_$NotNullItem._$table];

  Table<NotNullItem> get notNullItems =>
      $ForGeneratedCode.declareTable(this, _$NotNullItem._$table);

  /// Create tables defined in [NegativeDatabase].
  ///
  /// Calling this on an empty database will create the tables
  /// defined in [NegativeDatabase]. In production it's often better to
  /// use [createNegativeDatabaseTables] and manage migrations using
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

/// Get SQL [DDL statements][1] for tables defined in [NegativeDatabase].
///
/// This returns a SQL script with multiple DDL statements separated by `;`
/// using the specified [dialect].
///
/// Executing these statements in an empty database will create the tables
/// defined in [NegativeDatabase]. In practice, this method is often used for
/// printing the DDL statements, such that migrations can be managed by
/// external tools.
///
/// [1]: https://en.wikipedia.org/wiki/Data_definition_language
String createNegativeDatabaseTables(SqlDialect dialect) =>
    $ForGeneratedCode.createTableSchema(
      dialect: dialect,
      tables: NegativeDatabaseSchema._$tables,
    );

final class _$NotNullItem extends NotNullItem {
  _$NotNullItem._(this.id, this.name);

  @override
  final int id;

  @override
  final String name;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'notNullItems',
    columns: <String>['id', 'name'],
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
    readRow: _$NotNullItem._$fromDatabase,
  );

  static NotNullItem? _$fromDatabase(RowReader row) {
    final id = row.readInt();
    final name = row.readString();
    if (id == null && name == null) {
      return null;
    }
    return _$NotNullItem._(id!, name!);
  }

  @override
  String toString() => 'NotNullItem(id: "$id", name: "$name")';
}

/// Extension methods for table defined in [NotNullItem].
extension TableNotNullItemExt on Table<NotNullItem> {
  /// Insert row into the `notNullItems` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<NotNullItem> insert({
    Expr<int>? id,
    required Expr<String> name,
  }) => $ForGeneratedCode.insertInto(table: this, values: [id, name]);

  /// Insert row into the `notNullItems` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<NotNullItem> insertValue({int? id, required String name}) =>
      $ForGeneratedCode.insertInto(
        table: this,
        values: [id?.asExpr, name.asExpr],
      );

  /// Bulk insert rows into the `notNullItems` table.
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
  Insert<NotNullItem> insertValuesMapped<T>(
    Iterable<T> rows, {
    int Function(T row)? id,
    required String Function(T row) name,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mappings: [id, name],
  );

  /// Delete a single row from the `notNullItems` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<NotNullItem> delete(int id) =>
      $ForGeneratedCode.deleteSingle(byKey(id), _$NotNullItem._$table);
}

/// Extension methods for building queries against the `notNullItems` table.
extension QueryNotNullItemExt on Query<(Expr<NotNullItem>,)> {
  /// Lookup a single row in `notNullItems` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<NotNullItem>,)> byKey(int id) =>
      where((notNullItem) => notNullItem.id.equalsValue(id)).first;

  /// Update all rows in the `notNullItems` table matching this [Query].
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
  Update<NotNullItem> update(
    UpdateSet<NotNullItem> Function(
      Expr<NotNullItem> notNullItem,
      UpdateSet<NotNullItem> Function({Expr<int> id, Expr<String> name}) set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<NotNullItem>(
    this,
    _$NotNullItem._$table,
    (notNullItem) => updateBuilder(
      notNullItem,
      ({Expr<int>? id, Expr<String>? name}) =>
          $ForGeneratedCode.buildUpdate<NotNullItem>([id, name]),
    ),
  );

  /// Delete all rows in the `notNullItems` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<NotNullItem> delete() =>
      $ForGeneratedCode.delete(this, _$NotNullItem._$table);
}

/// Extension methods for building point queries against the `notNullItems` table.
extension QuerySingleNotNullItemExt on QuerySingle<(Expr<NotNullItem>,)> {
  /// Update the row (if any) in the `notNullItems` table matching this
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
  UpdateSingle<NotNullItem> update(
    UpdateSet<NotNullItem> Function(
      Expr<NotNullItem> notNullItem,
      UpdateSet<NotNullItem> Function({Expr<int> id, Expr<String> name}) set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<NotNullItem>(
    this,
    _$NotNullItem._$table,
    (notNullItem) => updateBuilder(
      notNullItem,
      ({Expr<int>? id, Expr<String>? name}) =>
          $ForGeneratedCode.buildUpdate<NotNullItem>([id, name]),
    ),
  );

  /// Delete the row (if any) in the `notNullItems` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<NotNullItem> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$NotNullItem._$table);
}

/// Extension methods for expressions on a row in the `notNullItems` table.
extension ExpressionNotNullItemExt on Expr<NotNullItem> {
  Expr<int> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String> get name =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);
}

extension ExpressionNullableNotNullItemExt on Expr<NotNullItem?> {
  Expr<int?> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String?> get name =>
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

/// `Table<NotNullItem>` conflict targets for use with `.onConflict`.
enum NotNullItemConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `id`.
  primaryKey(['id']);

  const NotNullItemConflict(this._fields);

  final List<String> _fields;
}

extension InsertNotNullItemExt on Insert<NotNullItem> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((notNullItem, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflict<NotNullItem> onConflict(NotNullItemConflict target) =>
      $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictNotNullItemExt on InsertOnConflict<NotNullItem> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `notNullItem` an [Expr] representing the existing row in
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
  Upsert<NotNullItem> update(
    UpdateSet<NotNullItem> Function(
      Expr<NotNullItem> notNullItem,
      Expr<NotNullItem> excluded,
      UpdateSet<NotNullItem> Function({Expr<int> id, Expr<String> name}) set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<NotNullItem>(
    this,
    (notNullItem, excluded) => updateBuilder(
      notNullItem,
      excluded,
      ({Expr<int>? id, Expr<String>? name}) =>
          $ForGeneratedCode.buildUpdate<NotNullItem>([id, name]),
    ),
  );
}

extension InsertSingleNotNullItemExt on InsertSingle<NotNullItem> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((notNullItem, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflictSingle<NotNullItem> onConflict(NotNullItemConflict target) =>
      $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleNotNullItemExt
    on InsertOnConflictSingle<NotNullItem> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `notNullItem` an [Expr] representing the existing row in
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
  UpsertSingle<NotNullItem> update(
    UpdateSet<NotNullItem> Function(
      Expr<NotNullItem> notNullItem,
      Expr<NotNullItem> excluded,
      UpdateSet<NotNullItem> Function({Expr<int> id, Expr<String> name}) set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<NotNullItem>(
    this,
    (notNullItem, excluded) => updateBuilder(
      notNullItem,
      excluded,
      ({Expr<int>? id, Expr<String>? name}) =>
          $ForGeneratedCode.buildUpdate<NotNullItem>([id, name]),
    ),
  );
}

/// Extension methods for assertions on [NotNullItem] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension NotNullItemChecks on Subject<NotNullItem> {
  /// Create assertions on [NotNullItem.id].
  Subject<int> get id => has((m) => m.id, 'id');

  /// Create assertions on [NotNullItem.name].
  Subject<String> get name => has((m) => m.name, 'name');
}
