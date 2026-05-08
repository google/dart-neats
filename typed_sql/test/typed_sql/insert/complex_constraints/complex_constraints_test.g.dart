// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complex_constraints_test.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

/// Extension methods for a [Database] operating on [ComplexConstraintsDatabase].
extension ComplexConstraintsDatabaseSchema
    on Database<ComplexConstraintsDatabase> {
  static final _$tables = [
    _$CompositePkItem._$table,
    _$MultiUniqueItem._$table,
    _$ForeignKeyItem._$table,
  ];

  Table<CompositePkItem> get compositePkItems =>
      $ForGeneratedCode.declareTable(this, _$CompositePkItem._$table);

  Table<MultiUniqueItem> get multiUniqueItems =>
      $ForGeneratedCode.declareTable(this, _$MultiUniqueItem._$table);

  Table<ForeignKeyItem> get foreignKeyItems =>
      $ForGeneratedCode.declareTable(this, _$ForeignKeyItem._$table);

  /// Create tables defined in [ComplexConstraintsDatabase].
  ///
  /// Calling this on an empty database will create the tables
  /// defined in [ComplexConstraintsDatabase]. In production it's often better to
  /// use [createComplexConstraintsDatabaseTables] and manage migrations using
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

/// Get SQL [DDL statements][1] for tables defined in [ComplexConstraintsDatabase].
///
/// This returns a SQL script with multiple DDL statements separated by `;`
/// using the specified [dialect].
///
/// Executing these statements in an empty database will create the tables
/// defined in [ComplexConstraintsDatabase]. In practice, this method is often used for
/// printing the DDL statements, such that migrations can be managed by
/// external tools.
///
/// [1]: https://en.wikipedia.org/wiki/Data_definition_language
String createComplexConstraintsDatabaseTables(SqlDialect dialect) =>
    $ForGeneratedCode.createTableSchema(
      dialect: dialect,
      tables: ComplexConstraintsDatabaseSchema._$tables,
    );

final class _$CompositePkItem extends CompositePkItem {
  _$CompositePkItem._(this.pkA, this.pkB, this.data);

  @override
  final int pkA;

  @override
  final String pkB;

  @override
  final String data;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'compositePkItems',
    columns: <String>['pkA', 'pkB', 'data'],
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
          const SqlOverride(dialect: 'mysql', columnType: 'VARCHAR(255)'),
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
    primaryKey: <String>['pkA', 'pkB'],
    unique: <List<String>>[],
    foreignKeys: [],
    readRow: _$CompositePkItem._$fromDatabase,
  );

  static CompositePkItem? _$fromDatabase(RowReader row) {
    final pkA = row.readInt();
    final pkB = row.readString();
    final data = row.readString();
    if (pkA == null && pkB == null && data == null) {
      return null;
    }
    return _$CompositePkItem._(pkA!, pkB!, data!);
  }

  @override
  String toString() =>
      'CompositePkItem(pkA: "$pkA", pkB: "$pkB", data: "$data")';
}

/// Extension methods for table defined in [CompositePkItem].
extension TableCompositePkItemExt on Table<CompositePkItem> {
  /// Insert row into the `compositePkItems` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<CompositePkItem> insert({
    required Expr<int> pkA,
    required Expr<String> pkB,
    required Expr<String> data,
  }) => $ForGeneratedCode.insertInto(table: this, values: [pkA, pkB, data]);

  /// Insert row into the `compositePkItems` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<CompositePkItem> insertValue({
    required int pkA,
    required String pkB,
    required String data,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [pkA.asExpr, pkB.asExpr, data.asExpr],
  );

  /// Bulk insert rows into the `compositePkItems` table.
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
  Insert<CompositePkItem> insertValuesMapped<T>(
    Iterable<T> rows, {
    required int Function(T row) pkA,
    required String Function(T row) pkB,
    required String Function(T row) data,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mapping: {'pkA': pkA, 'pkB': pkB, 'data': data},
  );

  /// Delete a single row from the `compositePkItems` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<CompositePkItem> delete(int pkA, String pkB) => $ForGeneratedCode
      .deleteSingle(byKey(pkA, pkB), _$CompositePkItem._$table);
}

/// Extension methods for building queries against the `compositePkItems` table.
extension QueryCompositePkItemExt on Query<(Expr<CompositePkItem>,)> {
  /// Lookup a single row in `compositePkItems` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<CompositePkItem>,)> byKey(int pkA, String pkB) => where(
    (compositePkItem) =>
        compositePkItem.pkA.equalsValue(pkA) &
        compositePkItem.pkB.equalsValue(pkB),
  ).first;

  /// Update all rows in the `compositePkItems` table matching this [Query].
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
  Update<CompositePkItem> update(
    UpdateSet<CompositePkItem> Function(
      Expr<CompositePkItem> compositePkItem,
      UpdateSet<CompositePkItem> Function({
        Expr<int> pkA,
        Expr<String> pkB,
        Expr<String> data,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<CompositePkItem>(
    this,
    _$CompositePkItem._$table,
    (compositePkItem) => updateBuilder(
      compositePkItem,
      ({Expr<int>? pkA, Expr<String>? pkB, Expr<String>? data}) =>
          $ForGeneratedCode.buildUpdate<CompositePkItem>([pkA, pkB, data]),
    ),
  );

  /// Delete all rows in the `compositePkItems` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<CompositePkItem> delete() =>
      $ForGeneratedCode.delete(this, _$CompositePkItem._$table);
}

/// Extension methods for building point queries against the `compositePkItems` table.
extension QuerySingleCompositePkItemExt
    on QuerySingle<(Expr<CompositePkItem>,)> {
  /// Update the row (if any) in the `compositePkItems` table matching this
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
  UpdateSingle<CompositePkItem> update(
    UpdateSet<CompositePkItem> Function(
      Expr<CompositePkItem> compositePkItem,
      UpdateSet<CompositePkItem> Function({
        Expr<int> pkA,
        Expr<String> pkB,
        Expr<String> data,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<CompositePkItem>(
    this,
    _$CompositePkItem._$table,
    (compositePkItem) => updateBuilder(
      compositePkItem,
      ({Expr<int>? pkA, Expr<String>? pkB, Expr<String>? data}) =>
          $ForGeneratedCode.buildUpdate<CompositePkItem>([pkA, pkB, data]),
    ),
  );

  /// Delete the row (if any) in the `compositePkItems` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<CompositePkItem> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$CompositePkItem._$table);
}

/// Extension methods for expressions on a row in the `compositePkItems` table.
extension ExpressionCompositePkItemExt on Expr<CompositePkItem> {
  Expr<int> get pkA =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String> get pkB =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<String> get data =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);
}

extension ExpressionNullableCompositePkItemExt on Expr<CompositePkItem?> {
  Expr<int?> get pkA =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String?> get pkB =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<String?> get data =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  /// Check if the row is not `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNotNull() => pkA.isNotNull() & pkB.isNotNull();

  /// Check if the row is `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNull() => isNotNull().not();
}

/// `Table<CompositePkItem>` conflict targets for use with `.onConflict`.
enum CompositePkItemConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `pkA`, `pkB`.
  primaryKey(['pkA', 'pkB']);

  const CompositePkItemConflict(this._fields);

  final List<String> _fields;
}

extension InsertCompositePkItemExt on Insert<CompositePkItem> {
  InsertOnConflict<CompositePkItem> onConflict(
    CompositePkItemConflict target,
  ) => $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictCompositePkItemExt
    on InsertOnConflict<CompositePkItem> {
  Upsert<CompositePkItem> update(
    UpdateSet<CompositePkItem> Function(
      Expr<CompositePkItem> compositePkItem,
      Expr<CompositePkItem> excluded,
      UpdateSet<CompositePkItem> Function({
        Expr<int> pkA,
        Expr<String> pkB,
        Expr<String> data,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<CompositePkItem>(
    this,
    (compositePkItem, excluded) => updateBuilder(
      compositePkItem,
      excluded,
      ({Expr<int>? pkA, Expr<String>? pkB, Expr<String>? data}) =>
          $ForGeneratedCode.buildUpdate<CompositePkItem>([pkA, pkB, data]),
    ),
  );
}

extension InsertSingleCompositePkItemExt on InsertSingle<CompositePkItem> {
  InsertOnConflictSingle<CompositePkItem> onConflict(
    CompositePkItemConflict target,
  ) => $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleCompositePkItemExt
    on InsertOnConflictSingle<CompositePkItem> {
  UpsertSingle<CompositePkItem> update(
    UpdateSet<CompositePkItem> Function(
      Expr<CompositePkItem> compositePkItem,
      Expr<CompositePkItem> excluded,
      UpdateSet<CompositePkItem> Function({
        Expr<int> pkA,
        Expr<String> pkB,
        Expr<String> data,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<CompositePkItem>(
    this,
    (compositePkItem, excluded) => updateBuilder(
      compositePkItem,
      excluded,
      ({Expr<int>? pkA, Expr<String>? pkB, Expr<String>? data}) =>
          $ForGeneratedCode.buildUpdate<CompositePkItem>([pkA, pkB, data]),
    ),
  );
}

final class _$MultiUniqueItem extends MultiUniqueItem {
  _$MultiUniqueItem._(this.id, this.fieldA, this.fieldB, this.data);

  @override
  final int id;

  @override
  final String fieldA;

  @override
  final int fieldB;

  @override
  final String data;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'multiUniqueItems',
    columns: <String>['id', 'fieldA', 'fieldB', 'data'],
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
      ['fieldA', 'fieldB'],
    ],
    foreignKeys: [],
    readRow: _$MultiUniqueItem._$fromDatabase,
  );

  static MultiUniqueItem? _$fromDatabase(RowReader row) {
    final id = row.readInt();
    final fieldA = row.readString();
    final fieldB = row.readInt();
    final data = row.readString();
    if (id == null && fieldA == null && fieldB == null && data == null) {
      return null;
    }
    return _$MultiUniqueItem._(id!, fieldA!, fieldB!, data!);
  }

  @override
  String toString() =>
      'MultiUniqueItem(id: "$id", fieldA: "$fieldA", fieldB: "$fieldB", data: "$data")';
}

/// Extension methods for table defined in [MultiUniqueItem].
extension TableMultiUniqueItemExt on Table<MultiUniqueItem> {
  /// Insert row into the `multiUniqueItems` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<MultiUniqueItem> insert({
    Expr<int>? id,
    required Expr<String> fieldA,
    required Expr<int> fieldB,
    required Expr<String> data,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [id, fieldA, fieldB, data],
  );

  /// Insert row into the `multiUniqueItems` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<MultiUniqueItem> insertValue({
    int? id,
    required String fieldA,
    required int fieldB,
    required String data,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [id?.asExpr, fieldA.asExpr, fieldB.asExpr, data.asExpr],
  );

  /// Bulk insert rows into the `multiUniqueItems` table.
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
  Insert<MultiUniqueItem> insertValuesMapped<T>(
    Iterable<T> rows, {
    int Function(T row)? id,
    required String Function(T row) fieldA,
    required int Function(T row) fieldB,
    required String Function(T row) data,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mapping: {'id': id, 'fieldA': fieldA, 'fieldB': fieldB, 'data': data},
  );

  /// Delete a single row from the `multiUniqueItems` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<MultiUniqueItem> delete(int id) =>
      $ForGeneratedCode.deleteSingle(byKey(id), _$MultiUniqueItem._$table);
}

/// Extension methods for building queries against the `multiUniqueItems` table.
extension QueryMultiUniqueItemExt on Query<(Expr<MultiUniqueItem>,)> {
  /// Lookup a single row in `multiUniqueItems` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<MultiUniqueItem>,)> byKey(int id) =>
      where((multiUniqueItem) => multiUniqueItem.id.equalsValue(id)).first;

  /// Update all rows in the `multiUniqueItems` table matching this [Query].
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
  Update<MultiUniqueItem> update(
    UpdateSet<MultiUniqueItem> Function(
      Expr<MultiUniqueItem> multiUniqueItem,
      UpdateSet<MultiUniqueItem> Function({
        Expr<int> id,
        Expr<String> fieldA,
        Expr<int> fieldB,
        Expr<String> data,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<MultiUniqueItem>(
    this,
    _$MultiUniqueItem._$table,
    (multiUniqueItem) => updateBuilder(
      multiUniqueItem,
      ({
        Expr<int>? id,
        Expr<String>? fieldA,
        Expr<int>? fieldB,
        Expr<String>? data,
      }) => $ForGeneratedCode.buildUpdate<MultiUniqueItem>([
        id,
        fieldA,
        fieldB,
        data,
      ]),
    ),
  );

  /// Lookup a single row in `multiUniqueItems` table using the
  /// `fieldA`, `fieldB` fields
  ///
  /// We know that lookup by the `fieldA`, `fieldB` fields returns
  /// at-most one row because the [Unique] annotation in [MultiUniqueItem].
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<MultiUniqueItem>,)> byMultiUnique(
    String fieldA,
    int fieldB,
  ) => where(
    (multiUniqueItem) =>
        multiUniqueItem.fieldA.equalsValue(fieldA) &
        multiUniqueItem.fieldB.equalsValue(fieldB),
  ).first;

  /// Delete all rows in the `multiUniqueItems` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<MultiUniqueItem> delete() =>
      $ForGeneratedCode.delete(this, _$MultiUniqueItem._$table);
}

/// Extension methods for building point queries against the `multiUniqueItems` table.
extension QuerySingleMultiUniqueItemExt
    on QuerySingle<(Expr<MultiUniqueItem>,)> {
  /// Update the row (if any) in the `multiUniqueItems` table matching this
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
  UpdateSingle<MultiUniqueItem> update(
    UpdateSet<MultiUniqueItem> Function(
      Expr<MultiUniqueItem> multiUniqueItem,
      UpdateSet<MultiUniqueItem> Function({
        Expr<int> id,
        Expr<String> fieldA,
        Expr<int> fieldB,
        Expr<String> data,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<MultiUniqueItem>(
    this,
    _$MultiUniqueItem._$table,
    (multiUniqueItem) => updateBuilder(
      multiUniqueItem,
      ({
        Expr<int>? id,
        Expr<String>? fieldA,
        Expr<int>? fieldB,
        Expr<String>? data,
      }) => $ForGeneratedCode.buildUpdate<MultiUniqueItem>([
        id,
        fieldA,
        fieldB,
        data,
      ]),
    ),
  );

  /// Delete the row (if any) in the `multiUniqueItems` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<MultiUniqueItem> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$MultiUniqueItem._$table);
}

/// Extension methods for expressions on a row in the `multiUniqueItems` table.
extension ExpressionMultiUniqueItemExt on Expr<MultiUniqueItem> {
  Expr<int> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String> get fieldA =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<int> get fieldB =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.integer);

  Expr<String> get data =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.text);
}

extension ExpressionNullableMultiUniqueItemExt on Expr<MultiUniqueItem?> {
  Expr<int?> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String?> get fieldA =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<int?> get fieldB =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.integer);

  Expr<String?> get data =>
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

/// `Table<MultiUniqueItem>` conflict targets for use with `.onConflict`.
enum MultiUniqueItemConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `id`.
  primaryKey(['id']),

  /// `fieldA`, `fieldB` conflict.
  ///
  /// Due to violation of the `UNIQUE` constraint on
  /// `fieldA`, `fieldB`.
  ///
  /// Thus, the conflicting row has matching values for these fields.
  multiUnique(['fieldA', 'fieldB']);

  const MultiUniqueItemConflict(this._fields);

  final List<String> _fields;
}

extension InsertMultiUniqueItemExt on Insert<MultiUniqueItem> {
  InsertOnConflict<MultiUniqueItem> onConflict(
    MultiUniqueItemConflict target,
  ) => $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictMultiUniqueItemExt
    on InsertOnConflict<MultiUniqueItem> {
  Upsert<MultiUniqueItem> update(
    UpdateSet<MultiUniqueItem> Function(
      Expr<MultiUniqueItem> multiUniqueItem,
      Expr<MultiUniqueItem> excluded,
      UpdateSet<MultiUniqueItem> Function({
        Expr<int> id,
        Expr<String> fieldA,
        Expr<int> fieldB,
        Expr<String> data,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<MultiUniqueItem>(
    this,
    (multiUniqueItem, excluded) => updateBuilder(
      multiUniqueItem,
      excluded,
      ({
        Expr<int>? id,
        Expr<String>? fieldA,
        Expr<int>? fieldB,
        Expr<String>? data,
      }) => $ForGeneratedCode.buildUpdate<MultiUniqueItem>([
        id,
        fieldA,
        fieldB,
        data,
      ]),
    ),
  );
}

extension InsertSingleMultiUniqueItemExt on InsertSingle<MultiUniqueItem> {
  InsertOnConflictSingle<MultiUniqueItem> onConflict(
    MultiUniqueItemConflict target,
  ) => $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleMultiUniqueItemExt
    on InsertOnConflictSingle<MultiUniqueItem> {
  UpsertSingle<MultiUniqueItem> update(
    UpdateSet<MultiUniqueItem> Function(
      Expr<MultiUniqueItem> multiUniqueItem,
      Expr<MultiUniqueItem> excluded,
      UpdateSet<MultiUniqueItem> Function({
        Expr<int> id,
        Expr<String> fieldA,
        Expr<int> fieldB,
        Expr<String> data,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<MultiUniqueItem>(
    this,
    (multiUniqueItem, excluded) => updateBuilder(
      multiUniqueItem,
      excluded,
      ({
        Expr<int>? id,
        Expr<String>? fieldA,
        Expr<int>? fieldB,
        Expr<String>? data,
      }) => $ForGeneratedCode.buildUpdate<MultiUniqueItem>([
        id,
        fieldA,
        fieldB,
        data,
      ]),
    ),
  );
}

final class _$ForeignKeyItem extends ForeignKeyItem {
  _$ForeignKeyItem._(this.id, this.refPkA, this.refPkB, this.data);

  @override
  final int id;

  @override
  final int refPkA;

  @override
  final String refPkB;

  @override
  final String data;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'foreignKeyItems',
    columns: <String>['id', 'refPkA', 'refPkB', 'data'],
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
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
    ],
    primaryKey: <String>['id'],
    unique: <List<String>>[],
    foreignKeys: [
      $ForGeneratedCode.foreignKeyDefinition(
        name: 'compositeRef',
        columns: ['refPkA', 'refPkB'],
        referencedTable: 'compositePkItems',
        referencedColumns: ['pkA', 'pkB'],
        onDelete: .noAction,
        onUpdate: .noAction,
      ),
    ],
    readRow: _$ForeignKeyItem._$fromDatabase,
  );

  static ForeignKeyItem? _$fromDatabase(RowReader row) {
    final id = row.readInt();
    final refPkA = row.readInt();
    final refPkB = row.readString();
    final data = row.readString();
    if (id == null && refPkA == null && refPkB == null && data == null) {
      return null;
    }
    return _$ForeignKeyItem._(id!, refPkA!, refPkB!, data!);
  }

  @override
  String toString() =>
      'ForeignKeyItem(id: "$id", refPkA: "$refPkA", refPkB: "$refPkB", data: "$data")';
}

/// Extension methods for table defined in [ForeignKeyItem].
extension TableForeignKeyItemExt on Table<ForeignKeyItem> {
  /// Insert row into the `foreignKeyItems` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<ForeignKeyItem> insert({
    Expr<int>? id,
    required Expr<int> refPkA,
    required Expr<String> refPkB,
    required Expr<String> data,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [id, refPkA, refPkB, data],
  );

  /// Insert row into the `foreignKeyItems` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<ForeignKeyItem> insertValue({
    int? id,
    required int refPkA,
    required String refPkB,
    required String data,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [id?.asExpr, refPkA.asExpr, refPkB.asExpr, data.asExpr],
  );

  /// Bulk insert rows into the `foreignKeyItems` table.
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
  Insert<ForeignKeyItem> insertValuesMapped<T>(
    Iterable<T> rows, {
    int Function(T row)? id,
    required int Function(T row) refPkA,
    required String Function(T row) refPkB,
    required String Function(T row) data,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mapping: {'id': id, 'refPkA': refPkA, 'refPkB': refPkB, 'data': data},
  );

  /// Delete a single row from the `foreignKeyItems` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<ForeignKeyItem> delete(int id) =>
      $ForGeneratedCode.deleteSingle(byKey(id), _$ForeignKeyItem._$table);
}

/// Extension methods for building queries against the `foreignKeyItems` table.
extension QueryForeignKeyItemExt on Query<(Expr<ForeignKeyItem>,)> {
  /// Lookup a single row in `foreignKeyItems` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<ForeignKeyItem>,)> byKey(int id) =>
      where((foreignKeyItem) => foreignKeyItem.id.equalsValue(id)).first;

  /// Update all rows in the `foreignKeyItems` table matching this [Query].
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
  Update<ForeignKeyItem> update(
    UpdateSet<ForeignKeyItem> Function(
      Expr<ForeignKeyItem> foreignKeyItem,
      UpdateSet<ForeignKeyItem> Function({
        Expr<int> id,
        Expr<int> refPkA,
        Expr<String> refPkB,
        Expr<String> data,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<ForeignKeyItem>(
    this,
    _$ForeignKeyItem._$table,
    (foreignKeyItem) => updateBuilder(
      foreignKeyItem,
      ({
        Expr<int>? id,
        Expr<int>? refPkA,
        Expr<String>? refPkB,
        Expr<String>? data,
      }) => $ForGeneratedCode.buildUpdate<ForeignKeyItem>([
        id,
        refPkA,
        refPkB,
        data,
      ]),
    ),
  );

  /// Delete all rows in the `foreignKeyItems` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<ForeignKeyItem> delete() =>
      $ForGeneratedCode.delete(this, _$ForeignKeyItem._$table);
}

/// Extension methods for building point queries against the `foreignKeyItems` table.
extension QuerySingleForeignKeyItemExt on QuerySingle<(Expr<ForeignKeyItem>,)> {
  /// Update the row (if any) in the `foreignKeyItems` table matching this
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
  UpdateSingle<ForeignKeyItem> update(
    UpdateSet<ForeignKeyItem> Function(
      Expr<ForeignKeyItem> foreignKeyItem,
      UpdateSet<ForeignKeyItem> Function({
        Expr<int> id,
        Expr<int> refPkA,
        Expr<String> refPkB,
        Expr<String> data,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<ForeignKeyItem>(
    this,
    _$ForeignKeyItem._$table,
    (foreignKeyItem) => updateBuilder(
      foreignKeyItem,
      ({
        Expr<int>? id,
        Expr<int>? refPkA,
        Expr<String>? refPkB,
        Expr<String>? data,
      }) => $ForGeneratedCode.buildUpdate<ForeignKeyItem>([
        id,
        refPkA,
        refPkB,
        data,
      ]),
    ),
  );

  /// Delete the row (if any) in the `foreignKeyItems` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<ForeignKeyItem> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$ForeignKeyItem._$table);
}

/// Extension methods for expressions on a row in the `foreignKeyItems` table.
extension ExpressionForeignKeyItemExt on Expr<ForeignKeyItem> {
  Expr<int> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<int> get refPkA =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.integer);

  Expr<String> get refPkB =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  Expr<String> get data =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.text);

  /// Do a subquery lookup of the row from table
  /// `compositePkItems` referenced in
  /// [refPkA], [refPkB].
  ///
  /// The gets the row from table `compositePkItems` where
  /// [CompositePkItem.pkA], [CompositePkItem.pkB]
  /// is equal to [refPkA], [refPkB].
  Expr<CompositePkItem> get compositeRef => $ForGeneratedCode
      .subqueryTable(_$CompositePkItem._$table)
      .where((r) => r.pkA.equals(refPkA) & r.pkB.equals(refPkB))
      .first
      .asNotNull();
}

extension ExpressionNullableForeignKeyItemExt on Expr<ForeignKeyItem?> {
  Expr<int?> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<int?> get refPkA =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.integer);

  Expr<String?> get refPkB =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  Expr<String?> get data =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.text);

  /// Do a subquery lookup of the row from table
  /// `compositePkItems` referenced in
  /// [refPkA], [refPkB].
  ///
  /// The gets the row from table `compositePkItems` where
  /// [CompositePkItem.pkA], [CompositePkItem.pkB]
  /// is equal to [refPkA], [refPkB], if any.
  ///
  /// If this row is `NULL` the subquery is always return `NULL`.
  Expr<CompositePkItem?> get compositeRef => $ForGeneratedCode
      .subqueryTable(_$CompositePkItem._$table)
      .where(
        (r) =>
            r.pkA.equalsUnlessNull(refPkA).asNotNull() &
            r.pkB.equalsUnlessNull(refPkB).asNotNull(),
      )
      .first;

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

extension InnerJoinForeignKeyItemCompositePkItemExt
    on InnerJoin<(Expr<ForeignKeyItem>,), (Expr<CompositePkItem>,)> {
  /// Join using the `compositeRef` _foreign key_.
  ///
  /// This will match rows where [ForeignKeyItem.refPkA] = [CompositePkItem.pkA] and [ForeignKeyItem.refPkB] = [CompositePkItem.pkB].
  Query<(Expr<ForeignKeyItem>, Expr<CompositePkItem>)> usingCompositeRef() =>
      on((a, b) => b.pkA.equals(a.refPkA) & b.pkB.equals(a.refPkB));
}

extension LeftJoinForeignKeyItemCompositePkItemExt
    on LeftJoin<(Expr<ForeignKeyItem>,), (Expr<CompositePkItem>,)> {
  /// Join using the `compositeRef` _foreign key_.
  ///
  /// This will match rows where [ForeignKeyItem.refPkA] = [CompositePkItem.pkA] and [ForeignKeyItem.refPkB] = [CompositePkItem.pkB].
  Query<(Expr<ForeignKeyItem>, Expr<CompositePkItem?>)> usingCompositeRef() =>
      on((a, b) => b.pkA.equals(a.refPkA) & b.pkB.equals(a.refPkB));
}

extension RightJoinForeignKeyItemCompositePkItemExt
    on RightJoin<(Expr<ForeignKeyItem>,), (Expr<CompositePkItem>,)> {
  /// Join using the `compositeRef` _foreign key_.
  ///
  /// This will match rows where [ForeignKeyItem.refPkA] = [CompositePkItem.pkA] and [ForeignKeyItem.refPkB] = [CompositePkItem.pkB].
  Query<(Expr<ForeignKeyItem?>, Expr<CompositePkItem>)> usingCompositeRef() =>
      on((a, b) => b.pkA.equals(a.refPkA) & b.pkB.equals(a.refPkB));
}

/// `Table<ForeignKeyItem>` conflict targets for use with `.onConflict`.
enum ForeignKeyItemConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `id`.
  primaryKey(['id']);

  const ForeignKeyItemConflict(this._fields);

  final List<String> _fields;
}

extension InsertForeignKeyItemExt on Insert<ForeignKeyItem> {
  InsertOnConflict<ForeignKeyItem> onConflict(ForeignKeyItemConflict target) =>
      $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictForeignKeyItemExt
    on InsertOnConflict<ForeignKeyItem> {
  Upsert<ForeignKeyItem> update(
    UpdateSet<ForeignKeyItem> Function(
      Expr<ForeignKeyItem> foreignKeyItem,
      Expr<ForeignKeyItem> excluded,
      UpdateSet<ForeignKeyItem> Function({
        Expr<int> id,
        Expr<int> refPkA,
        Expr<String> refPkB,
        Expr<String> data,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<ForeignKeyItem>(
    this,
    (foreignKeyItem, excluded) => updateBuilder(
      foreignKeyItem,
      excluded,
      ({
        Expr<int>? id,
        Expr<int>? refPkA,
        Expr<String>? refPkB,
        Expr<String>? data,
      }) => $ForGeneratedCode.buildUpdate<ForeignKeyItem>([
        id,
        refPkA,
        refPkB,
        data,
      ]),
    ),
  );
}

extension InsertSingleForeignKeyItemExt on InsertSingle<ForeignKeyItem> {
  InsertOnConflictSingle<ForeignKeyItem> onConflict(
    ForeignKeyItemConflict target,
  ) => $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleForeignKeyItemExt
    on InsertOnConflictSingle<ForeignKeyItem> {
  UpsertSingle<ForeignKeyItem> update(
    UpdateSet<ForeignKeyItem> Function(
      Expr<ForeignKeyItem> foreignKeyItem,
      Expr<ForeignKeyItem> excluded,
      UpdateSet<ForeignKeyItem> Function({
        Expr<int> id,
        Expr<int> refPkA,
        Expr<String> refPkB,
        Expr<String> data,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<ForeignKeyItem>(
    this,
    (foreignKeyItem, excluded) => updateBuilder(
      foreignKeyItem,
      excluded,
      ({
        Expr<int>? id,
        Expr<int>? refPkA,
        Expr<String>? refPkB,
        Expr<String>? data,
      }) => $ForGeneratedCode.buildUpdate<ForeignKeyItem>([
        id,
        refPkA,
        refPkB,
        data,
      ]),
    ),
  );
}

/// Extension methods for assertions on [CompositePkItem] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension CompositePkItemChecks on Subject<CompositePkItem> {
  /// Create assertions on [CompositePkItem.pkA].
  Subject<int> get pkA => has((m) => m.pkA, 'pkA');

  /// Create assertions on [CompositePkItem.pkB].
  Subject<String> get pkB => has((m) => m.pkB, 'pkB');

  /// Create assertions on [CompositePkItem.data].
  Subject<String> get data => has((m) => m.data, 'data');
}

/// Extension methods for assertions on [ForeignKeyItem] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension ForeignKeyItemChecks on Subject<ForeignKeyItem> {
  /// Create assertions on [ForeignKeyItem.id].
  Subject<int> get id => has((m) => m.id, 'id');

  /// Create assertions on [ForeignKeyItem.refPkA].
  Subject<int> get refPkA => has((m) => m.refPkA, 'refPkA');

  /// Create assertions on [ForeignKeyItem.refPkB].
  Subject<String> get refPkB => has((m) => m.refPkB, 'refPkB');

  /// Create assertions on [ForeignKeyItem.data].
  Subject<String> get data => has((m) => m.data, 'data');
}

/// Extension methods for assertions on [MultiUniqueItem] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension MultiUniqueItemChecks on Subject<MultiUniqueItem> {
  /// Create assertions on [MultiUniqueItem.id].
  Subject<int> get id => has((m) => m.id, 'id');

  /// Create assertions on [MultiUniqueItem.fieldA].
  Subject<String> get fieldA => has((m) => m.fieldA, 'fieldA');

  /// Create assertions on [MultiUniqueItem.fieldB].
  Subject<int> get fieldB => has((m) => m.fieldB, 'fieldB');

  /// Create assertions on [MultiUniqueItem.data].
  Subject<String> get data => has((m) => m.data, 'data');
}
