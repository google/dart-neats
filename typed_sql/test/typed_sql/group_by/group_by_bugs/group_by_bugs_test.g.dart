// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_by_bugs_test.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

/// Extension methods for a [Database] operating on [TestDatabase].
extension TestDatabaseSchema on Database<TestDatabase> {
  static const _$tables = [_$Item._$table];

  Table<Item> get items => $ForGeneratedCode.declareTable(
        this,
        _$Item._$table,
      );

  /// Create tables defined in [TestDatabase].
  ///
  /// Calling this on an empty database will create the tables
  /// defined in [TestDatabase]. In production it's often better to
  /// use [createTestDatabaseTables] and manage migrations using
  /// external tools.
  ///
  /// This method is mostly useful for testing.
  ///
  /// > [!WARNING]
  /// > If the database is **not empty** behavior is undefined, most
  /// > likely this operation will fail.
  Future<void> createTables() async => $ForGeneratedCode.createTables(
        context: this,
        tables: _$tables,
      );
}

/// Get SQL [DDL statements][1] for tables defined in [TestDatabase].
///
/// This returns a SQL script with multiple DDL statements separated by `;`
/// using the specified [dialect].
///
/// Executing these statements in an empty database will create the tables
/// defined in [TestDatabase]. In practice, this method is often used for
/// printing the DDL statements, such that migrations can be managed by
/// external tools.
///
/// [1]: https://en.wikipedia.org/wiki/Data_definition_language
String createTestDatabaseTables(SqlDialect dialect) =>
    $ForGeneratedCode.createTableSchema(
      dialect: dialect,
      tables: TestDatabaseSchema._$tables,
    );

final class _$Item extends Item {
  _$Item._(
    this.id,
    this.category,
    this.data,
    this.score,
  );

  @override
  final int id;

  @override
  final String category;

  @override
  final JsonValue data;

  @override
  final int score;

  static const _$table = (
    tableName: 'items',
    columns: <String>['id', 'category', 'data', 'score'],
    columnInfo: <({
      ColumnType type,
      bool isNotNull,
      Object? defaultValue,
      bool autoIncrement,
      List<SqlOverride> overrides,
    })>[
      (
        type: $ForGeneratedCode.integer,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: true,
        overrides: <SqlOverride>[],
      ),
      (
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: <SqlOverride>[],
      ),
      (
        type: $ForGeneratedCode.jsonValue,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: <SqlOverride>[],
      ),
      (
        type: $ForGeneratedCode.integer,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: <SqlOverride>[],
      )
    ],
    primaryKey: <String>['id'],
    unique: <List<String>>[],
    foreignKeys: <({
      String name,
      List<String> columns,
      String referencedTable,
      List<String> referencedColumns,
    })>[],
    readRow: _$Item._$fromDatabase,
  );

  static Item? _$fromDatabase(RowReader row) {
    final id = row.readInt();
    final category = row.readString();
    final data = row.readJsonValue();
    final score = row.readInt();
    if (id == null && category == null && data == null && score == null) {
      return null;
    }
    return _$Item._(id!, category!, data!, score!);
  }

  @override
  String toString() =>
      'Item(id: "$id", category: "$category", data: "$data", score: "$score")';
}

/// Extension methods for table defined in [Item].
extension TableItemExt on Table<Item> {
  /// Insert row into the `items` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<Item> insert({
    Expr<int>? id,
    required Expr<String> category,
    required Expr<JsonValue> data,
    required Expr<int> score,
  }) =>
      $ForGeneratedCode.insertInto(
        table: this,
        values: [
          id,
          category,
          data,
          score,
        ],
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
  DeleteSingle<Item> delete(int id) => $ForGeneratedCode.deleteSingle(
        byKey(id),
        _$Item._$table,
      );
}

/// Extension methods for building queries against the `items` table.
extension QueryItemExt on Query<(Expr<Item>,)> {
  /// Lookup a single row in `items` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<Item>,)> byKey(int id) =>
      where((item) => item.id.equalsValue(id)).first;

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
  Update<Item> update(
          UpdateSet<Item> Function(
            Expr<Item> item,
            UpdateSet<Item> Function({
              Expr<int> id,
              Expr<String> category,
              Expr<JsonValue> data,
              Expr<int> score,
            }) set,
          ) updateBuilder) =>
      $ForGeneratedCode.update<Item>(
        this,
        _$Item._$table,
        (item) => updateBuilder(
          item,
          ({
            Expr<int>? id,
            Expr<String>? category,
            Expr<JsonValue>? data,
            Expr<int>? score,
          }) =>
              $ForGeneratedCode.buildUpdate<Item>([
            id,
            category,
            data,
            score,
          ]),
        ),
      );

  /// Delete all rows in the `items` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<Item> delete() => $ForGeneratedCode.delete(this, _$Item._$table);
}

/// Extension methods for building point queries against the `items` table.
extension QuerySingleItemExt on QuerySingle<(Expr<Item>,)> {
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
  UpdateSingle<Item> update(
          UpdateSet<Item> Function(
            Expr<Item> item,
            UpdateSet<Item> Function({
              Expr<int> id,
              Expr<String> category,
              Expr<JsonValue> data,
              Expr<int> score,
            }) set,
          ) updateBuilder) =>
      $ForGeneratedCode.updateSingle<Item>(
        this,
        _$Item._$table,
        (item) => updateBuilder(
          item,
          ({
            Expr<int>? id,
            Expr<String>? category,
            Expr<JsonValue>? data,
            Expr<int>? score,
          }) =>
              $ForGeneratedCode.buildUpdate<Item>([
            id,
            category,
            data,
            score,
          ]),
        ),
      );

  /// Delete the row (if any) in the `items` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<Item> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$Item._$table);
}

/// Extension methods for expressions on a row in the `items` table.
extension ExpressionItemExt on Expr<Item> {
  Expr<int> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String> get category =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<JsonValue> get data =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.jsonValue);

  Expr<int> get score =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.integer);
}

extension ExpressionNullableItemExt on Expr<Item?> {
  Expr<int?> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String?> get category =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<JsonValue?> get data =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.jsonValue);

  Expr<int?> get score =>
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

/// Extension methods for assertions on [Item] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension ItemChecks on Subject<Item> {
  /// Create assertions on [Item.id].
  Subject<int> get id => has((m) => m.id, 'id');

  /// Create assertions on [Item.category].
  Subject<String> get category => has((m) => m.category, 'category');

  /// Create assertions on [Item.data].
  Subject<JsonValue> get data => has((m) => m.data, 'data');

  /// Create assertions on [Item.score].
  Subject<int> get score => has((m) => m.score, 'score');
}
