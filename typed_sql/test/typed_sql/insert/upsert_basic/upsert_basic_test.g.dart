// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upsert_basic_test.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

/// Extension methods for a [Database] operating on [BasicDatabase].
extension BasicDatabaseSchema on Database<BasicDatabase> {
  static final _$tables = [_$BasicItem._$table];

  Table<BasicItem> get basicItems =>
      $ForGeneratedCode.declareTable(this, _$BasicItem._$table);

  /// Create tables defined in [BasicDatabase].
  ///
  /// Calling this on an empty database will create the tables
  /// defined in [BasicDatabase]. In production it's often better to
  /// use [createBasicDatabaseTables] and manage migrations using
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

/// Get SQL [DDL statements][1] for tables defined in [BasicDatabase].
///
/// This returns a SQL script with multiple DDL statements separated by `;`
/// using the specified [dialect].
///
/// Executing these statements in an empty database will create the tables
/// defined in [BasicDatabase]. In practice, this method is often used for
/// printing the DDL statements, such that migrations can be managed by
/// external tools.
///
/// [1]: https://en.wikipedia.org/wiki/Data_definition_language
String createBasicDatabaseTables(SqlDialect dialect) => $ForGeneratedCode
    .createTableSchema(dialect: dialect, tables: BasicDatabaseSchema._$tables);

final class _$BasicItem extends BasicItem {
  _$BasicItem._(this.id, this.name, this.value);

  @override
  final int id;

  @override
  final String name;

  @override
  final int value;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'basicItems',
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
          const SqlOverride(dialect: 'mysql', columnType: 'VARCHAR(255)'),
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
    readRow: _$BasicItem._$fromDatabase,
  );

  static BasicItem? _$fromDatabase(RowReader row) {
    final id = row.readInt();
    final name = row.readString();
    final value = row.readInt();
    if (id == null && name == null && value == null) {
      return null;
    }
    return _$BasicItem._(id!, name!, value!);
  }

  @override
  String toString() => 'BasicItem(id: "$id", name: "$name", value: "$value")';
}

/// Extension methods for table defined in [BasicItem].
extension TableBasicItemExt on Table<BasicItem> {
  /// Insert row into the `basicItems` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<BasicItem> insert({
    Expr<int>? id,
    required Expr<String> name,
    required Expr<int> value,
  }) => $ForGeneratedCode.insertInto(table: this, values: [id, name, value]);

  /// Insert row into the `basicItems` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<BasicItem> insertValue({
    int? id,
    required String name,
    required int value,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [id?.asExpr, name.asExpr, value.asExpr],
  );

  /// Bulk insert rows into the `basicItems` table.
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
  Insert<BasicItem> insertValuesMapped<T>(
    Iterable<T> rows, {
    int Function(T row)? id,
    required String Function(T row) name,
    required int Function(T row) value,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mapping: {'id': id, 'name': name, 'value': value},
  );

  /// Delete a single row from the `basicItems` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<BasicItem> delete(int id) =>
      $ForGeneratedCode.deleteSingle(byKey(id), _$BasicItem._$table);
}

/// Extension methods for building queries against the `basicItems` table.
extension QueryBasicItemExt on Query<(Expr<BasicItem>,)> {
  /// Lookup a single row in `basicItems` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<BasicItem>,)> byKey(int id) =>
      where((basicItem) => basicItem.id.equalsValue(id)).first;

  /// Update all rows in the `basicItems` table matching this [Query].
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
  Update<BasicItem> update(
    UpdateSet<BasicItem> Function(
      Expr<BasicItem> basicItem,
      UpdateSet<BasicItem> Function({
        Expr<int> id,
        Expr<String> name,
        Expr<int> value,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<BasicItem>(
    this,
    _$BasicItem._$table,
    (basicItem) => updateBuilder(
      basicItem,
      ({Expr<int>? id, Expr<String>? name, Expr<int>? value}) =>
          $ForGeneratedCode.buildUpdate<BasicItem>([id, name, value]),
    ),
  );

  /// Lookup a single row in `basicItems` table using the
  /// `name` field
  ///
  /// We know that lookup by the `name` field returns
  /// at-most one row because the [Unique] annotation in [BasicItem].
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<BasicItem>,)> byName(String name) =>
      where((basicItem) => basicItem.name.equalsValue(name)).first;

  /// Delete all rows in the `basicItems` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<BasicItem> delete() =>
      $ForGeneratedCode.delete(this, _$BasicItem._$table);
}

/// Extension methods for building point queries against the `basicItems` table.
extension QuerySingleBasicItemExt on QuerySingle<(Expr<BasicItem>,)> {
  /// Update the row (if any) in the `basicItems` table matching this
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
  UpdateSingle<BasicItem> update(
    UpdateSet<BasicItem> Function(
      Expr<BasicItem> basicItem,
      UpdateSet<BasicItem> Function({
        Expr<int> id,
        Expr<String> name,
        Expr<int> value,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<BasicItem>(
    this,
    _$BasicItem._$table,
    (basicItem) => updateBuilder(
      basicItem,
      ({Expr<int>? id, Expr<String>? name, Expr<int>? value}) =>
          $ForGeneratedCode.buildUpdate<BasicItem>([id, name, value]),
    ),
  );

  /// Delete the row (if any) in the `basicItems` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<BasicItem> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$BasicItem._$table);
}

/// Extension methods for expressions on a row in the `basicItems` table.
extension ExpressionBasicItemExt on Expr<BasicItem> {
  Expr<int> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String> get name =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<int> get value =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.integer);
}

extension ExpressionNullableBasicItemExt on Expr<BasicItem?> {
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

/// `Table<BasicItem>` conflict targets for use with `.onConflict`.
enum BasicItemConflict {
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
  name(['name'])
  ;

  const BasicItemConflict(this._fields);

  final List<String> _fields;
}

extension InsertBasicItemExt on Insert<BasicItem> {
  InsertOnConflict<BasicItem> onConflict(BasicItemConflict target) =>
      $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictBasicItemExt on InsertOnConflict<BasicItem> {
  Upsert<BasicItem> update(
    UpdateSet<BasicItem> Function(
      Expr<BasicItem> basicItem,
      Expr<BasicItem> excluded,
      UpdateSet<BasicItem> Function({
        Expr<int> id,
        Expr<String> name,
        Expr<int> value,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<BasicItem>(
    this,
    (basicItem, excluded) => updateBuilder(
      basicItem,
      excluded,
      ({Expr<int>? id, Expr<String>? name, Expr<int>? value}) =>
          $ForGeneratedCode.buildUpdate<BasicItem>([id, name, value]),
    ),
  );
}

extension InsertSingleBasicItemExt on InsertSingle<BasicItem> {
  InsertOnConflictSingle<BasicItem> onConflict(BasicItemConflict target) =>
      $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleBasicItemExt
    on InsertOnConflictSingle<BasicItem> {
  UpsertSingle<BasicItem> update(
    UpdateSet<BasicItem> Function(
      Expr<BasicItem> basicItem,
      Expr<BasicItem> excluded,
      UpdateSet<BasicItem> Function({
        Expr<int> id,
        Expr<String> name,
        Expr<int> value,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<BasicItem>(
    this,
    (basicItem, excluded) => updateBuilder(
      basicItem,
      excluded,
      ({Expr<int>? id, Expr<String>? name, Expr<int>? value}) =>
          $ForGeneratedCode.buildUpdate<BasicItem>([id, name, value]),
    ),
  );
}

/// Extension methods for assertions on [BasicItem] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension BasicItemChecks on Subject<BasicItem> {
  /// Create assertions on [BasicItem.id].
  Subject<int> get id => has((m) => m.id, 'id');

  /// Create assertions on [BasicItem.name].
  Subject<String> get name => has((m) => m.name, 'name');

  /// Create assertions on [BasicItem.value].
  Subject<int> get value => has((m) => m.value, 'value');
}
