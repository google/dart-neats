// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spgist_index_test.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

/// Extension methods for a [Database] operating on [DirectoryDatabase].
extension DirectoryDatabaseSchema on Database<DirectoryDatabase> {
  static final _$tables = [_$Entry._$table];

  Table<Entry> get entries =>
      $ForGeneratedCode.declareTable(this, _$Entry._$table);

  /// Create tables defined in [DirectoryDatabase].
  ///
  /// Calling this on an empty database will create the tables
  /// defined in [DirectoryDatabase]. In production it's often better to
  /// use [createDirectoryDatabaseTables] and manage migrations using
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

/// Get SQL [DDL statements][1] for tables defined in [DirectoryDatabase].
///
/// This returns a SQL script with multiple DDL statements separated by `;`
/// using the specified [dialect].
///
/// Executing these statements in an empty database will create the tables
/// defined in [DirectoryDatabase]. In practice, this method is often used for
/// printing the DDL statements, such that migrations can be managed by
/// external tools.
///
/// [1]: https://en.wikipedia.org/wiki/Data_definition_language
String createDirectoryDatabaseTables(SqlDialect dialect) =>
    $ForGeneratedCode.createTableSchema(
      dialect: dialect,
      tables: DirectoryDatabaseSchema._$tables,
    );

final class _$Entry extends Entry {
  _$Entry._(this.id, this.name);

  @override
  final int id;

  @override
  final String name;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'entries',
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
    unique: <List<String>>[],
    foreignKeys: [],
    indexes: [
      $ForGeneratedCode.indexDefinition(
        name: null,
        sqlName: null,
        columns: ['name'],
        method: .spgist,
        covering: [],
      ),
    ],
    readRow: _$Entry._$fromDatabase,
  );

  static Entry? _$fromDatabase(RowReader row) {
    final id = row.readInt();
    final name = row.readString();
    if (id == null && name == null) {
      return null;
    }
    return _$Entry._(id!, name!);
  }

  @override
  String toString() => 'Entry(id: "$id", name: "$name")';
}

/// Extension methods for table defined in [Entry].
extension TableEntryExt on Table<Entry> {
  /// Insert row into the `entries` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<Entry> insert({Expr<int>? id, required Expr<String> name}) =>
      $ForGeneratedCode.insertInto(table: this, values: [id, name]);

  /// Insert row into the `entries` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<Entry> insertValue({int? id, required String name}) =>
      $ForGeneratedCode.insertInto(
        table: this,
        values: [id?.asExpr, name.asExpr],
      );

  /// Bulk insert rows into the `entries` table.
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
  Insert<Entry> insertValuesMapped<T>(
    Iterable<T> rows, {
    int Function(T row)? id,
    required String Function(T row) name,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mappings: [id, name],
  );

  /// Delete a single row from the `entries` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<Entry> delete(int id) =>
      $ForGeneratedCode.deleteSingle(byKey(id), _$Entry._$table);
}

/// Extension methods for building queries against the `entries` table.
extension QueryEntryExt on Query<(Expr<Entry>,)> {
  /// Lookup a single row in `entries` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<Entry>,)> byKey(int id) =>
      where((entry) => entry.id.equalsValue(id)).first;

  /// Update all rows in the `entries` table matching this [Query].
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
  Update<Entry> update(
    UpdateSet<Entry> Function(
      Expr<Entry> entry,
      UpdateSet<Entry> Function({Expr<int> id, Expr<String> name}) set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<Entry>(
    this,
    _$Entry._$table,
    (entry) => updateBuilder(
      entry,
      ({Expr<int>? id, Expr<String>? name}) =>
          $ForGeneratedCode.buildUpdate<Entry>([id, name]),
    ),
  );

  /// Delete all rows in the `entries` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<Entry> delete() => $ForGeneratedCode.delete(this, _$Entry._$table);
}

/// Extension methods for building point queries against the `entries` table.
extension QuerySingleEntryExt on QuerySingle<(Expr<Entry>,)> {
  /// Update the row (if any) in the `entries` table matching this
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
  UpdateSingle<Entry> update(
    UpdateSet<Entry> Function(
      Expr<Entry> entry,
      UpdateSet<Entry> Function({Expr<int> id, Expr<String> name}) set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<Entry>(
    this,
    _$Entry._$table,
    (entry) => updateBuilder(
      entry,
      ({Expr<int>? id, Expr<String>? name}) =>
          $ForGeneratedCode.buildUpdate<Entry>([id, name]),
    ),
  );

  /// Delete the row (if any) in the `entries` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<Entry> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$Entry._$table);
}

/// Extension methods for expressions on a row in the `entries` table.
extension ExpressionEntryExt on Expr<Entry> {
  Expr<int> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String> get name =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);
}

extension ExpressionNullableEntryExt on Expr<Entry?> {
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

/// `Table<Entry>` conflict targets for use with `.onConflict`.
enum EntryConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `id`.
  primaryKey(['id']);

  const EntryConflict(this._fields);

  final List<String> _fields;
}

extension InsertEntryExt on Insert<Entry> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((entry, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflict<Entry> onConflict(EntryConflict target) =>
      $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictEntryExt on InsertOnConflict<Entry> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `entry` an [Expr] representing the existing row in
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
  Upsert<Entry> update(
    UpdateSet<Entry> Function(
      Expr<Entry> entry,
      Expr<Entry> excluded,
      UpdateSet<Entry> Function({Expr<int> id, Expr<String> name}) set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<Entry>(
    this,
    (entry, excluded) => updateBuilder(
      entry,
      excluded,
      ({Expr<int>? id, Expr<String>? name}) =>
          $ForGeneratedCode.buildUpdate<Entry>([id, name]),
    ),
  );
}

extension InsertSingleEntryExt on InsertSingle<Entry> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((entry, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflictSingle<Entry> onConflict(EntryConflict target) =>
      $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleEntryExt on InsertOnConflictSingle<Entry> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `entry` an [Expr] representing the existing row in
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
  UpsertSingle<Entry> update(
    UpdateSet<Entry> Function(
      Expr<Entry> entry,
      Expr<Entry> excluded,
      UpdateSet<Entry> Function({Expr<int> id, Expr<String> name}) set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<Entry>(
    this,
    (entry, excluded) => updateBuilder(
      entry,
      excluded,
      ({Expr<int>? id, Expr<String>? name}) =>
          $ForGeneratedCode.buildUpdate<Entry>([id, name]),
    ),
  );
}

/// Extension methods for assertions on [Entry] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension EntryChecks on Subject<Entry> {
  /// Create assertions on [Entry.id].
  Subject<int> get id => has((m) => m.id, 'id');

  /// Create assertions on [Entry.name].
  Subject<String> get name => has((m) => m.name, 'name');
}
