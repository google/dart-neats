// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_default_values_test.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

/// Extension methods for a [Database] operating on [MySchema].
extension MySchemaSchema on Database<MySchema> {
  static const _$tables = [_$Item._$table];

  Table<Item> get items => $ForGeneratedCode.declareTable(
        this,
        _$Item._$table,
      );

  /// Create tables defined in [MySchema].
  ///
  /// Calling this on an empty database will create the tables
  /// defined in [MySchema]. In production it's often better to
  /// use [createMySchemaTables] and manage migrations using
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

/// Get SQL [DDL statements][1] for tables defined in [MySchema].
///
/// This returns a SQL script with multiple DDL statements separated by `;`
/// using the specified [dialect].
///
/// Executing these statements in an empty database will create the tables
/// defined in [MySchema]. In practice, this method is often used for
/// printing the DDL statements, such that migrations can be managed by
/// external tools.
///
/// [1]: https://en.wikipedia.org/wiki/Data_definition_language
String createMySchemaTables(SqlDialect dialect) =>
    $ForGeneratedCode.createTableSchema(
      dialect: dialect,
      tables: MySchemaSchema._$tables,
    );

final class _$Item extends Item {
  _$Item._(
    this.id,
    this.name,
    this.birthday,
    this.createdAt,
    this.expires,
  );

  @override
  final int id;

  @override
  final String name;

  @override
  final DateTime birthday;

  @override
  final DateTime createdAt;

  @override
  final DateTime expires;

  static const _$table = (
    tableName: 'items',
    columns: <String>['id', 'name', 'birthday', 'createdAt', 'expires'],
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
        defaultValue: (kind: 'raw', value: 'Bob'),
        autoIncrement: false,
        overrides: <SqlOverride>[],
      ),
      (
        type: $ForGeneratedCode.dateTime,
        isNotNull: true,
        defaultValue: (kind: 'datetime', value: 'epoch'),
        autoIncrement: false,
        overrides: <SqlOverride>[],
      ),
      (
        type: $ForGeneratedCode.dateTime,
        isNotNull: true,
        defaultValue: (kind: 'datetime', value: 'now'),
        autoIncrement: false,
        overrides: <SqlOverride>[],
      ),
      (
        type: $ForGeneratedCode.dateTime,
        isNotNull: true,
        defaultValue: (kind: 'datetime', value: (2035, 11, 17, 0, 0, 0, 0, 0)),
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
    final name = row.readString();
    final birthday = row.readDateTime();
    final createdAt = row.readDateTime();
    final expires = row.readDateTime();
    if (id == null &&
        name == null &&
        birthday == null &&
        createdAt == null &&
        expires == null) {
      return null;
    }
    return _$Item._(id!, name!, birthday!, createdAt!, expires!);
  }

  @override
  String toString() =>
      'Item(id: "$id", name: "$name", birthday: "$birthday", createdAt: "$createdAt", expires: "$expires")';
}

/// Extension methods for table defined in [Item].
extension TableItemExt on Table<Item> {
  /// Insert row into the `items` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<Item> insert({
    Expr<int>? id,
    Expr<String>? name,
    Expr<DateTime>? birthday,
    Expr<DateTime>? createdAt,
    Expr<DateTime>? expires,
  }) =>
      $ForGeneratedCode.insertInto(
        table: this,
        values: [
          id,
          name,
          birthday,
          createdAt,
          expires,
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
              Expr<String> name,
              Expr<DateTime> birthday,
              Expr<DateTime> createdAt,
              Expr<DateTime> expires,
            }) set,
          ) updateBuilder) =>
      $ForGeneratedCode.update<Item>(
        this,
        _$Item._$table,
        (item) => updateBuilder(
          item,
          ({
            Expr<int>? id,
            Expr<String>? name,
            Expr<DateTime>? birthday,
            Expr<DateTime>? createdAt,
            Expr<DateTime>? expires,
          }) =>
              $ForGeneratedCode.buildUpdate<Item>([
            id,
            name,
            birthday,
            createdAt,
            expires,
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
              Expr<String> name,
              Expr<DateTime> birthday,
              Expr<DateTime> createdAt,
              Expr<DateTime> expires,
            }) set,
          ) updateBuilder) =>
      $ForGeneratedCode.updateSingle<Item>(
        this,
        _$Item._$table,
        (item) => updateBuilder(
          item,
          ({
            Expr<int>? id,
            Expr<String>? name,
            Expr<DateTime>? birthday,
            Expr<DateTime>? createdAt,
            Expr<DateTime>? expires,
          }) =>
              $ForGeneratedCode.buildUpdate<Item>([
            id,
            name,
            birthday,
            createdAt,
            expires,
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

  Expr<String> get name =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<DateTime> get birthday =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.dateTime);

  Expr<DateTime> get createdAt =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.dateTime);

  Expr<DateTime> get expires =>
      $ForGeneratedCode.field(this, 4, $ForGeneratedCode.dateTime);
}

extension ExpressionNullableItemExt on Expr<Item?> {
  Expr<int?> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String?> get name =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<DateTime?> get birthday =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.dateTime);

  Expr<DateTime?> get createdAt =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.dateTime);

  Expr<DateTime?> get expires =>
      $ForGeneratedCode.field(this, 4, $ForGeneratedCode.dateTime);

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

  /// Create assertions on [Item.name].
  Subject<String> get name => has((m) => m.name, 'name');

  /// Create assertions on [Item.birthday].
  Subject<DateTime> get birthday => has((m) => m.birthday, 'birthday');

  /// Create assertions on [Item.createdAt].
  Subject<DateTime> get createdAt => has((m) => m.createdAt, 'createdAt');

  /// Create assertions on [Item.expires].
  Subject<DateTime> get expires => has((m) => m.expires, 'expires');
}
