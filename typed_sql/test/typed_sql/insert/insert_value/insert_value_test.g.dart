// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insert_value_test.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

/// Extension methods for a [Database] operating on [ValueDatabase].
extension ValueDatabaseSchema on Database<ValueDatabase> {
  static final _$tables = [_$ValueItem._$table];

  Table<ValueItem> get valueItems =>
      $ForGeneratedCode.declareTable(this, _$ValueItem._$table);

  /// Create tables defined in [ValueDatabase].
  ///
  /// Calling this on an empty database will create the tables
  /// defined in [ValueDatabase]. In production it's often better to
  /// use [createValueDatabaseTables] and manage migrations using
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

/// Get SQL [DDL statements][1] for tables defined in [ValueDatabase].
///
/// This returns a SQL script with multiple DDL statements separated by `;`
/// using the specified [dialect].
///
/// Executing these statements in an empty database will create the tables
/// defined in [ValueDatabase]. In practice, this method is often used for
/// printing the DDL statements, such that migrations can be managed by
/// external tools.
///
/// [1]: https://en.wikipedia.org/wiki/Data_definition_language
String createValueDatabaseTables(SqlDialect dialect) => $ForGeneratedCode
    .createTableSchema(dialect: dialect, tables: ValueDatabaseSchema._$tables);

final class _$ValueItem extends ValueItem {
  _$ValueItem._(this.id, this.value);

  @override
  final int id;

  @override
  final String value;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'valueItems',
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
    readRow: _$ValueItem._$fromDatabase,
  );

  static ValueItem? _$fromDatabase(RowReader row) {
    final id = row.readInt();
    final value = row.readString();
    if (id == null && value == null) {
      return null;
    }
    return _$ValueItem._(id!, value!);
  }

  @override
  String toString() => 'ValueItem(id: "$id", value: "$value")';
}

/// Extension methods for table defined in [ValueItem].
extension TableValueItemExt on Table<ValueItem> {
  /// Insert row into the `valueItems` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<ValueItem> insert({
    Expr<int>? id,
    required Expr<String> value,
  }) => $ForGeneratedCode.insertInto(table: this, values: [id, value]);

  /// Insert row into the `valueItems` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<ValueItem> insertValue({int? id, required String value}) =>
      $ForGeneratedCode.insertInto(
        table: this,
        values: [id?.asExpr, value.asExpr],
      );

  /// Delete a single row from the `valueItems` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<ValueItem> delete(int id) =>
      $ForGeneratedCode.deleteSingle(byKey(id), _$ValueItem._$table);
}

/// Extension methods for building queries against the `valueItems` table.
extension QueryValueItemExt on Query<(Expr<ValueItem>,)> {
  /// Lookup a single row in `valueItems` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<ValueItem>,)> byKey(int id) =>
      where((valueItem) => valueItem.id.equalsValue(id)).first;

  /// Update all rows in the `valueItems` table matching this [Query].
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
  Update<ValueItem> update(
    UpdateSet<ValueItem> Function(
      Expr<ValueItem> valueItem,
      UpdateSet<ValueItem> Function({Expr<int> id, Expr<String> value}) set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<ValueItem>(
    this,
    _$ValueItem._$table,
    (valueItem) => updateBuilder(
      valueItem,
      ({Expr<int>? id, Expr<String>? value}) =>
          $ForGeneratedCode.buildUpdate<ValueItem>([id, value]),
    ),
  );

  /// Delete all rows in the `valueItems` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<ValueItem> delete() =>
      $ForGeneratedCode.delete(this, _$ValueItem._$table);
}

/// Extension methods for building point queries against the `valueItems` table.
extension QuerySingleValueItemExt on QuerySingle<(Expr<ValueItem>,)> {
  /// Update the row (if any) in the `valueItems` table matching this
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
  UpdateSingle<ValueItem> update(
    UpdateSet<ValueItem> Function(
      Expr<ValueItem> valueItem,
      UpdateSet<ValueItem> Function({Expr<int> id, Expr<String> value}) set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<ValueItem>(
    this,
    _$ValueItem._$table,
    (valueItem) => updateBuilder(
      valueItem,
      ({Expr<int>? id, Expr<String>? value}) =>
          $ForGeneratedCode.buildUpdate<ValueItem>([id, value]),
    ),
  );

  /// Delete the row (if any) in the `valueItems` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<ValueItem> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$ValueItem._$table);
}

/// Extension methods for expressions on a row in the `valueItems` table.
extension ExpressionValueItemExt on Expr<ValueItem> {
  Expr<int> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String> get value =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);
}

extension ExpressionNullableValueItemExt on Expr<ValueItem?> {
  Expr<int?> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String?> get value =>
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

/// `Table<ValueItem>` conflict targets for use with `.onConflict`.
enum ValueItemConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `id`.
  primaryKey(['id']);

  const ValueItemConflict(this._fields);

  final List<String> _fields;
}

extension InsertSingleValueItemExt on InsertSingle<ValueItem> {
  InsertOnConflictSingle<ValueItem> onConflict(ValueItemConflict target) =>
      $ForGeneratedCode.insertSingleOnConflict(this, target._fields);
}

extension InsertOnConflictSingleValueItemExt
    on InsertOnConflictSingle<ValueItem> {
  UpsertOne<ValueItem> update(
    UpdateSet<ValueItem> Function(
      Expr<ValueItem> valueItem,
      Expr<ValueItem> excluded,
      UpdateSet<ValueItem> Function({Expr<int> id, Expr<String> value}) set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<ValueItem>(
    this,
    (valueItem, excluded) => updateBuilder(
      valueItem,
      excluded,
      ({Expr<int>? id, Expr<String>? value}) =>
          $ForGeneratedCode.buildUpdate<ValueItem>([id, value]),
    ),
  );
}

/// Extension methods for assertions on [ValueItem] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension ValueItemChecks on Subject<ValueItem> {
  /// Create assertions on [ValueItem.id].
  Subject<int> get id => has((m) => m.id, 'id');

  /// Create assertions on [ValueItem.value].
  Subject<String> get value => has((m) => m.value, 'value');
}
