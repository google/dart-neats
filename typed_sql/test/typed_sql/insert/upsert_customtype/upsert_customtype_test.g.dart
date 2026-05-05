// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upsert_customtype_test.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

/// Extension methods for a [Database] operating on [CustomTypeDatabase].
extension CustomTypeDatabaseSchema on Database<CustomTypeDatabase> {
  static final _$tables = [_$CustomTypeItem._$table];

  Table<CustomTypeItem> get customTypeItems =>
      $ForGeneratedCode.declareTable(this, _$CustomTypeItem._$table);

  /// Create tables defined in [CustomTypeDatabase].
  ///
  /// Calling this on an empty database will create the tables
  /// defined in [CustomTypeDatabase]. In production it's often better to
  /// use [createCustomTypeDatabaseTables] and manage migrations using
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

/// Get SQL [DDL statements][1] for tables defined in [CustomTypeDatabase].
///
/// This returns a SQL script with multiple DDL statements separated by `;`
/// using the specified [dialect].
///
/// Executing these statements in an empty database will create the tables
/// defined in [CustomTypeDatabase]. In practice, this method is often used for
/// printing the DDL statements, such that migrations can be managed by
/// external tools.
///
/// [1]: https://en.wikipedia.org/wiki/Data_definition_language
String createCustomTypeDatabaseTables(SqlDialect dialect) =>
    $ForGeneratedCode.createTableSchema(
      dialect: dialect,
      tables: CustomTypeDatabaseSchema._$tables,
    );

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
  value(['value'])
  ;

  const CustomTypeItemConflict(this._fields);

  final List<String> _fields;
}

extension InsertSingleCustomTypeItemExt on InsertSingle<CustomTypeItem> {
  InsertOnConflictSingle<CustomTypeItem> onConflict(
    CustomTypeItemConflict target,
  ) => $ForGeneratedCode.insertSingleOnConflict(this, target._fields);
}

extension InsertOnConflictSingleCustomTypeItemExt
    on InsertOnConflictSingle<CustomTypeItem> {
  UpsertOne<CustomTypeItem> update(
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

/// Wrap this [MyCustomType] as [Expr<MyCustomType>] for use queries with
/// `package:typed_sql`.
extension MyCustomTypeExt on MyCustomType {
  static final _exprType = $ForGeneratedCode.customDataType(
    $ForGeneratedCode.integer,
    MyCustomType.fromDatabase,
  );

  /// Wrap this [MyCustomType] as [Expr<MyCustomType>] for use queries with
  /// `package:typed_sql`.
  Expr<MyCustomType> get asExpr =>
      $ForGeneratedCode.literalCustomDataType(this, _exprType).asNotNull();
}

/// Wrap this [MyCustomType] as [Expr<MyCustomType>] for use queries with
/// `package:typed_sql`.
extension MyCustomTypeNullableExt on MyCustomType? {
  /// Wrap this [MyCustomType] as [Expr<MyCustomType?>] for use queries with
  /// `package:typed_sql`.
  Expr<MyCustomType?> get asExpr =>
      $ForGeneratedCode.literalCustomDataType(this, MyCustomTypeExt._exprType);
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
