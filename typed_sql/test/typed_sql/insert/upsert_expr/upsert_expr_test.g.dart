// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upsert_expr_test.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

/// Extension methods for a [Database] operating on [UpsertExprDatabase].
extension UpsertExprDatabaseSchema on Database<UpsertExprDatabase> {
  static final _$tables = [_$UpsertExprItem._$table, _$UpsertExprLink._$table];

  Table<UpsertExprItem> get items =>
      $ForGeneratedCode.declareTable(this, _$UpsertExprItem._$table);

  Table<UpsertExprLink> get links =>
      $ForGeneratedCode.declareTable(this, _$UpsertExprLink._$table);

  /// Create tables defined in [UpsertExprDatabase].
  ///
  /// Calling this on an empty database will create the tables
  /// defined in [UpsertExprDatabase]. In production it's often better to
  /// use [createUpsertExprDatabaseTables] and manage migrations using
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

/// Get SQL [DDL statements][1] for tables defined in [UpsertExprDatabase].
///
/// This returns a SQL script with multiple DDL statements separated by `;`
/// using the specified [dialect].
///
/// Executing these statements in an empty database will create the tables
/// defined in [UpsertExprDatabase]. In practice, this method is often used for
/// printing the DDL statements, such that migrations can be managed by
/// external tools.
///
/// [1]: https://en.wikipedia.org/wiki/Data_definition_language
String createUpsertExprDatabaseTables(SqlDialect dialect) =>
    $ForGeneratedCode.createTableSchema(
      dialect: dialect,
      tables: UpsertExprDatabaseSchema._$tables,
    );

final class _$UpsertExprItem extends UpsertExprItem {
  _$UpsertExprItem._(this.id, this.name, this.value, this.note);

  @override
  final int id;

  @override
  final String name;

  @override
  final int value;

  @override
  final String note;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'items',
    columns: <String>['id', 'name', 'value', 'note'],
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
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: (kind: 'raw', value: 'none'),
        autoIncrement: false,
        overrides: [],
      ),
    ],
    primaryKey: <String>['id'],
    unique: <List<String>>[],
    foreignKeys: [],
    indexes: [],
    readRow: _$UpsertExprItem._$fromDatabase,
  );

  static UpsertExprItem? _$fromDatabase(RowReader row) {
    final id = row.readInt();
    final name = row.readString();
    final value = row.readInt();
    final note = row.readString();
    if (id == null && name == null && value == null && note == null) {
      return null;
    }
    return _$UpsertExprItem._(id!, name!, value!, note!);
  }

  @override
  String toString() =>
      'UpsertExprItem(id: "$id", name: "$name", value: "$value", note: "$note")';
}

/// Extension methods for table defined in [UpsertExprItem].
extension TableUpsertExprItemExt on Table<UpsertExprItem> {
  /// Insert row into the `items` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<UpsertExprItem> insert({
    Expr<int>? id,
    required Expr<String> name,
    required Expr<int> value,
    Expr<String>? note,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [id, name, value, note],
  );

  /// Insert row into the `items` table, or update the
  /// existing row if it conflicts with the _primary key_.
  ///
  /// This is a shorthand for calling `.insert(...)` followed by
  /// `.onConflict(.primaryKey)` and `.update(...)` to overwrite
  /// the fields `name`, `value`, `note`,
  /// with the values given, leaving the _primary key_ untouched.
  ///
  /// Returns an [UpsertSingle] statement on which `.execute()` must be
  /// called for the row to be inserted or updated.
  UpsertSingle<UpsertExprItem> upsert({
    Expr<int>? id,
    required Expr<String> name,
    required Expr<int> value,
    Expr<String>? note,
  }) => insert(id: id, name: name, value: value, note: note)
      .onConflict(.primaryKey)
      .update(
        (_, excluded, set) => set(
          name: excluded.name,
          value: excluded.value,
          note: excluded.note,
        ),
      );

  /// Insert row into the `items` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<UpsertExprItem> insertValue({
    int? id,
    required String name,
    required int value,
    String? note,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [id?.asExpr, name.asExpr, value.asExpr, note?.asExpr],
  );

  /// Insert row into the `items` table, or update the
  /// existing row if it conflicts with the _primary key_.
  ///
  /// This is a shorthand for calling `.insertValue(...)` followed by
  /// `.onConflict(.primaryKey)` and `.update(...)` to overwrite
  /// the fields `name`, `value`, `note`,
  /// with the values given, leaving the _primary key_ untouched.
  ///
  /// Returns an [UpsertSingle] statement on which `.execute()` must be
  /// called for the row to be inserted or updated.
  UpsertSingle<UpsertExprItem> upsertValue({
    int? id,
    required String name,
    required int value,
    String? note,
  }) => insertValue(id: id, name: name, value: value, note: note)
      .onConflict(.primaryKey)
      .update(
        (_, excluded, set) => set(
          name: excluded.name,
          value: excluded.value,
          note: excluded.note,
        ),
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
  Insert<UpsertExprItem> insertValuesMapped<T>(
    Iterable<T> rows, {
    int Function(T row)? id,
    required String Function(T row) name,
    required int Function(T row) value,
    String Function(T row)? note,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mappings: [id, name, value, note],
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
  DeleteSingle<UpsertExprItem> delete(int id) =>
      $ForGeneratedCode.deleteSingle(byKey(id), _$UpsertExprItem._$table);
}

/// Extension methods for building queries against the `items` table.
extension QueryUpsertExprItemExt on Query<(Expr<UpsertExprItem>,)> {
  /// Lookup a single row in `items` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<UpsertExprItem>,)> byKey(int id) =>
      where((upsertExprItem) => upsertExprItem.id.equalsValue(id)).first;

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
  Update<UpsertExprItem> update(
    UpdateSet<UpsertExprItem> Function(
      Expr<UpsertExprItem> upsertExprItem,
      UpdateSet<UpsertExprItem> Function({
        Expr<int> id,
        Expr<String> name,
        Expr<int> value,
        Expr<String> note,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<UpsertExprItem>(
    this,
    _$UpsertExprItem._$table,
    (upsertExprItem) => updateBuilder(
      upsertExprItem,
      ({
        Expr<int>? id,
        Expr<String>? name,
        Expr<int>? value,
        Expr<String>? note,
      }) => $ForGeneratedCode.buildUpdate<UpsertExprItem>([
        id,
        name,
        value,
        note,
      ]),
    ),
  );

  /// Delete all rows in the `items` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<UpsertExprItem> delete() =>
      $ForGeneratedCode.delete(this, _$UpsertExprItem._$table);
}

/// Extension methods for building point queries against the `items` table.
extension QuerySingleUpsertExprItemExt on QuerySingle<(Expr<UpsertExprItem>,)> {
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
  UpdateSingle<UpsertExprItem> update(
    UpdateSet<UpsertExprItem> Function(
      Expr<UpsertExprItem> upsertExprItem,
      UpdateSet<UpsertExprItem> Function({
        Expr<int> id,
        Expr<String> name,
        Expr<int> value,
        Expr<String> note,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<UpsertExprItem>(
    this,
    _$UpsertExprItem._$table,
    (upsertExprItem) => updateBuilder(
      upsertExprItem,
      ({
        Expr<int>? id,
        Expr<String>? name,
        Expr<int>? value,
        Expr<String>? note,
      }) => $ForGeneratedCode.buildUpdate<UpsertExprItem>([
        id,
        name,
        value,
        note,
      ]),
    ),
  );

  /// Delete the row (if any) in the `items` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<UpsertExprItem> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$UpsertExprItem._$table);
}

/// Extension methods for expressions on a row in the `items` table.
extension ExpressionUpsertExprItemExt on Expr<UpsertExprItem> {
  Expr<int> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String> get name =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<int> get value =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.integer);

  Expr<String> get note =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.text);
}

extension ExpressionNullableUpsertExprItemExt on Expr<UpsertExprItem?> {
  Expr<int?> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String?> get name =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<int?> get value =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.integer);

  Expr<String?> get note =>
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

/// `Table<UpsertExprItem>` conflict targets for use with `.onConflict`.
enum UpsertExprItemConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `id`.
  primaryKey(['id']);

  const UpsertExprItemConflict(this._fields);

  final List<String> _fields;
}

extension InsertUpsertExprItemExt on Insert<UpsertExprItem> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((upsertExprItem, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflict<UpsertExprItem> onConflict(UpsertExprItemConflict target) =>
      $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictUpsertExprItemExt
    on InsertOnConflict<UpsertExprItem> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `upsertExprItem` an [Expr] representing the existing row in
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
  Upsert<UpsertExprItem> update(
    UpdateSet<UpsertExprItem> Function(
      Expr<UpsertExprItem> upsertExprItem,
      Expr<UpsertExprItem> excluded,
      UpdateSet<UpsertExprItem> Function({
        Expr<int> id,
        Expr<String> name,
        Expr<int> value,
        Expr<String> note,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<UpsertExprItem>(
    this,
    (upsertExprItem, excluded) => updateBuilder(
      upsertExprItem,
      excluded,
      ({
        Expr<int>? id,
        Expr<String>? name,
        Expr<int>? value,
        Expr<String>? note,
      }) => $ForGeneratedCode.buildUpdate<UpsertExprItem>([
        id,
        name,
        value,
        note,
      ]),
    ),
  );
}

extension InsertSingleUpsertExprItemExt on InsertSingle<UpsertExprItem> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((upsertExprItem, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflictSingle<UpsertExprItem> onConflict(
    UpsertExprItemConflict target,
  ) => $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleUpsertExprItemExt
    on InsertOnConflictSingle<UpsertExprItem> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `upsertExprItem` an [Expr] representing the existing row in
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
  UpsertSingle<UpsertExprItem> update(
    UpdateSet<UpsertExprItem> Function(
      Expr<UpsertExprItem> upsertExprItem,
      Expr<UpsertExprItem> excluded,
      UpdateSet<UpsertExprItem> Function({
        Expr<int> id,
        Expr<String> name,
        Expr<int> value,
        Expr<String> note,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<UpsertExprItem>(
    this,
    (upsertExprItem, excluded) => updateBuilder(
      upsertExprItem,
      excluded,
      ({
        Expr<int>? id,
        Expr<String>? name,
        Expr<int>? value,
        Expr<String>? note,
      }) => $ForGeneratedCode.buildUpdate<UpsertExprItem>([
        id,
        name,
        value,
        note,
      ]),
    ),
  );
}

final class _$UpsertExprLink extends UpsertExprLink {
  _$UpsertExprLink._(this.a, this.b);

  @override
  final int a;

  @override
  final int b;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'links',
    columns: <String>['a', 'b'],
    columnInfo: [
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
    primaryKey: <String>['a', 'b'],
    unique: <List<String>>[],
    foreignKeys: [],
    indexes: [],
    readRow: _$UpsertExprLink._$fromDatabase,
  );

  static UpsertExprLink? _$fromDatabase(RowReader row) {
    final a = row.readInt();
    final b = row.readInt();
    if (a == null && b == null) {
      return null;
    }
    return _$UpsertExprLink._(a!, b!);
  }

  @override
  String toString() => 'UpsertExprLink(a: "$a", b: "$b")';
}

/// Extension methods for table defined in [UpsertExprLink].
extension TableUpsertExprLinkExt on Table<UpsertExprLink> {
  /// Insert row into the `links` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<UpsertExprLink> insert({
    required Expr<int> a,
    required Expr<int> b,
  }) => $ForGeneratedCode.insertInto(table: this, values: [a, b]);

  /// Insert row into the `links` table, or update the
  /// existing row if it conflicts with the _primary key_.
  ///
  /// This is a shorthand for calling `.insert(...)` followed by
  /// `.onConflict(.primaryKey)` and `.update(...)` to overwrite
  /// nothing, as all fields are part of the _primary key_,
  /// with the values given, leaving the _primary key_ untouched.
  ///
  /// Returns an [UpsertSingle] statement on which `.execute()` must be
  /// called for the row to be inserted or updated.
  UpsertSingle<UpsertExprLink> upsert({
    required Expr<int> a,
    required Expr<int> b,
  }) => insert(
    a: a,
    b: b,
  ).onConflict(.primaryKey).update((_, excluded, set) => set());

  /// Insert row into the `links` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<UpsertExprLink> insertValue({required int a, required int b}) =>
      $ForGeneratedCode.insertInto(table: this, values: [a.asExpr, b.asExpr]);

  /// Insert row into the `links` table, or update the
  /// existing row if it conflicts with the _primary key_.
  ///
  /// This is a shorthand for calling `.insertValue(...)` followed by
  /// `.onConflict(.primaryKey)` and `.update(...)` to overwrite
  /// nothing, as all fields are part of the _primary key_,
  /// with the values given, leaving the _primary key_ untouched.
  ///
  /// Returns an [UpsertSingle] statement on which `.execute()` must be
  /// called for the row to be inserted or updated.
  UpsertSingle<UpsertExprLink> upsertValue({required int a, required int b}) =>
      insertValue(
        a: a,
        b: b,
      ).onConflict(.primaryKey).update((_, excluded, set) => set());

  /// Bulk insert rows into the `links` table.
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
  Insert<UpsertExprLink> insertValuesMapped<T>(
    Iterable<T> rows, {
    required int Function(T row) a,
    required int Function(T row) b,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mappings: [a, b],
  );

  /// Delete a single row from the `links` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<UpsertExprLink> delete(int a, int b) =>
      $ForGeneratedCode.deleteSingle(byKey(a, b), _$UpsertExprLink._$table);
}

/// Extension methods for building queries against the `links` table.
extension QueryUpsertExprLinkExt on Query<(Expr<UpsertExprLink>,)> {
  /// Lookup a single row in `links` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<UpsertExprLink>,)> byKey(int a, int b) => where(
    (upsertExprLink) =>
        upsertExprLink.a.equalsValue(a) & upsertExprLink.b.equalsValue(b),
  ).first;

  /// Update all rows in the `links` table matching this [Query].
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
  Update<UpsertExprLink> update(
    UpdateSet<UpsertExprLink> Function(
      Expr<UpsertExprLink> upsertExprLink,
      UpdateSet<UpsertExprLink> Function({Expr<int> a, Expr<int> b}) set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<UpsertExprLink>(
    this,
    _$UpsertExprLink._$table,
    (upsertExprLink) => updateBuilder(
      upsertExprLink,
      ({Expr<int>? a, Expr<int>? b}) =>
          $ForGeneratedCode.buildUpdate<UpsertExprLink>([a, b]),
    ),
  );

  /// Delete all rows in the `links` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<UpsertExprLink> delete() =>
      $ForGeneratedCode.delete(this, _$UpsertExprLink._$table);
}

/// Extension methods for building point queries against the `links` table.
extension QuerySingleUpsertExprLinkExt on QuerySingle<(Expr<UpsertExprLink>,)> {
  /// Update the row (if any) in the `links` table matching this
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
  UpdateSingle<UpsertExprLink> update(
    UpdateSet<UpsertExprLink> Function(
      Expr<UpsertExprLink> upsertExprLink,
      UpdateSet<UpsertExprLink> Function({Expr<int> a, Expr<int> b}) set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<UpsertExprLink>(
    this,
    _$UpsertExprLink._$table,
    (upsertExprLink) => updateBuilder(
      upsertExprLink,
      ({Expr<int>? a, Expr<int>? b}) =>
          $ForGeneratedCode.buildUpdate<UpsertExprLink>([a, b]),
    ),
  );

  /// Delete the row (if any) in the `links` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<UpsertExprLink> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$UpsertExprLink._$table);
}

/// Extension methods for expressions on a row in the `links` table.
extension ExpressionUpsertExprLinkExt on Expr<UpsertExprLink> {
  Expr<int> get a =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<int> get b =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.integer);
}

extension ExpressionNullableUpsertExprLinkExt on Expr<UpsertExprLink?> {
  Expr<int?> get a =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<int?> get b =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.integer);

  /// Check if the row is not `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNotNull() => a.isNotNull() & b.isNotNull();

  /// Check if the row is `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNull() => isNotNull().not();
}

/// `Table<UpsertExprLink>` conflict targets for use with `.onConflict`.
enum UpsertExprLinkConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `a`, `b`.
  primaryKey(['a', 'b']);

  const UpsertExprLinkConflict(this._fields);

  final List<String> _fields;
}

extension InsertUpsertExprLinkExt on Insert<UpsertExprLink> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((upsertExprLink, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflict<UpsertExprLink> onConflict(UpsertExprLinkConflict target) =>
      $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictUpsertExprLinkExt
    on InsertOnConflict<UpsertExprLink> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `upsertExprLink` an [Expr] representing the existing row in
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
  Upsert<UpsertExprLink> update(
    UpdateSet<UpsertExprLink> Function(
      Expr<UpsertExprLink> upsertExprLink,
      Expr<UpsertExprLink> excluded,
      UpdateSet<UpsertExprLink> Function({Expr<int> a, Expr<int> b}) set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<UpsertExprLink>(
    this,
    (upsertExprLink, excluded) => updateBuilder(
      upsertExprLink,
      excluded,
      ({Expr<int>? a, Expr<int>? b}) =>
          $ForGeneratedCode.buildUpdate<UpsertExprLink>([a, b]),
    ),
  );
}

extension InsertSingleUpsertExprLinkExt on InsertSingle<UpsertExprLink> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((upsertExprLink, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflictSingle<UpsertExprLink> onConflict(
    UpsertExprLinkConflict target,
  ) => $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleUpsertExprLinkExt
    on InsertOnConflictSingle<UpsertExprLink> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `upsertExprLink` an [Expr] representing the existing row in
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
  UpsertSingle<UpsertExprLink> update(
    UpdateSet<UpsertExprLink> Function(
      Expr<UpsertExprLink> upsertExprLink,
      Expr<UpsertExprLink> excluded,
      UpdateSet<UpsertExprLink> Function({Expr<int> a, Expr<int> b}) set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<UpsertExprLink>(
    this,
    (upsertExprLink, excluded) => updateBuilder(
      upsertExprLink,
      excluded,
      ({Expr<int>? a, Expr<int>? b}) =>
          $ForGeneratedCode.buildUpdate<UpsertExprLink>([a, b]),
    ),
  );
}

/// Extension methods for assertions on [UpsertExprItem] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension UpsertExprItemChecks on Subject<UpsertExprItem> {
  /// Create assertions on [UpsertExprItem.id].
  Subject<int> get id => has((m) => m.id, 'id');

  /// Create assertions on [UpsertExprItem.name].
  Subject<String> get name => has((m) => m.name, 'name');

  /// Create assertions on [UpsertExprItem.value].
  Subject<int> get value => has((m) => m.value, 'value');

  /// Create assertions on [UpsertExprItem.note].
  Subject<String> get note => has((m) => m.note, 'note');
}

/// Extension methods for assertions on [UpsertExprLink] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension UpsertExprLinkChecks on Subject<UpsertExprLink> {
  /// Create assertions on [UpsertExprLink.a].
  Subject<int> get a => has((m) => m.a, 'a');

  /// Create assertions on [UpsertExprLink.b].
  Subject<int> get b => has((m) => m.b, 'b');
}
