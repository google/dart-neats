// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insert_values_mapped_complex_test.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

/// Extension methods for a [Database] operating on [ComplexMappedDatabase].
extension ComplexMappedDatabaseSchema on Database<ComplexMappedDatabase> {
  static final _$tables = [_$ComplexMappedItem._$table];

  Table<ComplexMappedItem> get complexMappedItems =>
      $ForGeneratedCode.declareTable(this, _$ComplexMappedItem._$table);

  /// Create tables defined in [ComplexMappedDatabase].
  ///
  /// Calling this on an empty database will create the tables
  /// defined in [ComplexMappedDatabase]. In production it's often better to
  /// use [createComplexMappedDatabaseTables] and manage migrations using
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

/// Get SQL [DDL statements][1] for tables defined in [ComplexMappedDatabase].
///
/// This returns a SQL script with multiple DDL statements separated by `;`
/// using the specified [dialect].
///
/// Executing these statements in an empty database will create the tables
/// defined in [ComplexMappedDatabase]. In practice, this method is often used for
/// printing the DDL statements, such that migrations can be managed by
/// external tools.
///
/// [1]: https://en.wikipedia.org/wiki/Data_definition_language
String createComplexMappedDatabaseTables(SqlDialect dialect) =>
    $ForGeneratedCode.createTableSchema(
      dialect: dialect,
      tables: ComplexMappedDatabaseSchema._$tables,
    );

final class _$ComplexMappedItem extends ComplexMappedItem {
  _$ComplexMappedItem._(
    this.id,
    this.s,
    this.dt,
    this.blob,
    this.custom,
    this.i,
    this.json,
  );

  @override
  final int id;

  @override
  final String? s;

  @override
  final DateTime? dt;

  @override
  final Uint8List? blob;

  @override
  final MyCustomType? custom;

  @override
  final int? i;

  @override
  final JsonValue? json;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'complexMappedItems',
    columns: <String>['id', 's', 'dt', 'blob', 'custom', 'i', 'json'],
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
        isNotNull: false,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.dateTime,
        isNotNull: false,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.blob,
        isNotNull: false,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.integer,
        isNotNull: false,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.integer,
        isNotNull: false,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.jsonValue,
        isNotNull: false,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
    ],
    primaryKey: <String>['id'],
    unique: <List<String>>[],
    foreignKeys: [],
    readRow: _$ComplexMappedItem._$fromDatabase,
  );

  static ComplexMappedItem? _$fromDatabase(RowReader row) {
    final id = row.readInt();
    final s = row.readString();
    final dt = row.readDateTime();
    final blob = row.readUint8List();
    final custom = $ForGeneratedCode.customDataTypeOrNull(
      row.readInt(),
      MyCustomType.fromDatabase,
    );
    final i = row.readInt();
    final json = row.readJsonValue();
    if (id == null &&
        s == null &&
        dt == null &&
        blob == null &&
        custom == null &&
        i == null &&
        json == null) {
      return null;
    }
    return _$ComplexMappedItem._(id!, s, dt, blob, custom, i, json);
  }

  @override
  String toString() =>
      'ComplexMappedItem(id: "$id", s: "$s", dt: "$dt", blob: "$blob", custom: "$custom", i: "$i", json: "$json")';
}

/// Extension methods for table defined in [ComplexMappedItem].
extension TableComplexMappedItemExt on Table<ComplexMappedItem> {
  /// Insert row into the `complexMappedItems` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<ComplexMappedItem> insert({
    Expr<int>? id,
    Expr<String?>? s,
    Expr<DateTime?>? dt,
    Expr<Uint8List?>? blob,
    Expr<MyCustomType?>? custom,
    Expr<int?>? i,
    Expr<JsonValue?>? json,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [id, s, dt, blob, custom, i, json],
  );

  /// Insert row into the `complexMappedItems` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<ComplexMappedItem> insertValue({
    int? id,
    String? s,
    DateTime? dt,
    Uint8List? blob,
    MyCustomType? custom,
    int? i,
    JsonValue? json,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [
      id?.asExpr,
      s.asExpr,
      dt.asExpr,
      blob.asExpr,
      custom.asExpr,
      i.asExpr,
      json.asExpr,
    ],
  );

  /// Bulk insert rows into the `complexMappedItems` table.
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
  Insert<ComplexMappedItem> insertValuesMapped<T>(
    Iterable<T> rows, {
    int Function(T row)? id,
    String? Function(T row)? s,
    DateTime? Function(T row)? dt,
    Uint8List? Function(T row)? blob,
    MyCustomType? Function(T row)? custom,
    int? Function(T row)? i,
    JsonValue? Function(T row)? json,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mapping: {
      'id': id,
      's': s,
      'dt': dt,
      'blob': blob,
      'custom': custom != null ? (T v) => custom(v)?.toDatabase() : null,
      'i': i,
      'json': json,
    },
  );

  /// Delete a single row from the `complexMappedItems` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<ComplexMappedItem> delete(int id) =>
      $ForGeneratedCode.deleteSingle(byKey(id), _$ComplexMappedItem._$table);
}

/// Extension methods for building queries against the `complexMappedItems` table.
extension QueryComplexMappedItemExt on Query<(Expr<ComplexMappedItem>,)> {
  /// Lookup a single row in `complexMappedItems` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<ComplexMappedItem>,)> byKey(int id) =>
      where((complexMappedItem) => complexMappedItem.id.equalsValue(id)).first;

  /// Update all rows in the `complexMappedItems` table matching this [Query].
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
  Update<ComplexMappedItem> update(
    UpdateSet<ComplexMappedItem> Function(
      Expr<ComplexMappedItem> complexMappedItem,
      UpdateSet<ComplexMappedItem> Function({
        Expr<int> id,
        Expr<String?> s,
        Expr<DateTime?> dt,
        Expr<Uint8List?> blob,
        Expr<MyCustomType?> custom,
        Expr<int?> i,
        Expr<JsonValue?> json,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<ComplexMappedItem>(
    this,
    _$ComplexMappedItem._$table,
    (complexMappedItem) => updateBuilder(
      complexMappedItem,
      ({
        Expr<int>? id,
        Expr<String?>? s,
        Expr<DateTime?>? dt,
        Expr<Uint8List?>? blob,
        Expr<MyCustomType?>? custom,
        Expr<int?>? i,
        Expr<JsonValue?>? json,
      }) => $ForGeneratedCode.buildUpdate<ComplexMappedItem>([
        id,
        s,
        dt,
        blob,
        custom,
        i,
        json,
      ]),
    ),
  );

  /// Delete all rows in the `complexMappedItems` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<ComplexMappedItem> delete() =>
      $ForGeneratedCode.delete(this, _$ComplexMappedItem._$table);
}

/// Extension methods for building point queries against the `complexMappedItems` table.
extension QuerySingleComplexMappedItemExt
    on QuerySingle<(Expr<ComplexMappedItem>,)> {
  /// Update the row (if any) in the `complexMappedItems` table matching this
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
  UpdateSingle<ComplexMappedItem> update(
    UpdateSet<ComplexMappedItem> Function(
      Expr<ComplexMappedItem> complexMappedItem,
      UpdateSet<ComplexMappedItem> Function({
        Expr<int> id,
        Expr<String?> s,
        Expr<DateTime?> dt,
        Expr<Uint8List?> blob,
        Expr<MyCustomType?> custom,
        Expr<int?> i,
        Expr<JsonValue?> json,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<ComplexMappedItem>(
    this,
    _$ComplexMappedItem._$table,
    (complexMappedItem) => updateBuilder(
      complexMappedItem,
      ({
        Expr<int>? id,
        Expr<String?>? s,
        Expr<DateTime?>? dt,
        Expr<Uint8List?>? blob,
        Expr<MyCustomType?>? custom,
        Expr<int?>? i,
        Expr<JsonValue?>? json,
      }) => $ForGeneratedCode.buildUpdate<ComplexMappedItem>([
        id,
        s,
        dt,
        blob,
        custom,
        i,
        json,
      ]),
    ),
  );

  /// Delete the row (if any) in the `complexMappedItems` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<ComplexMappedItem> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$ComplexMappedItem._$table);
}

/// Extension methods for expressions on a row in the `complexMappedItems` table.
extension ExpressionComplexMappedItemExt on Expr<ComplexMappedItem> {
  Expr<int> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String?> get s =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<DateTime?> get dt =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.dateTime);

  Expr<Uint8List?> get blob =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.blob);

  Expr<MyCustomType?> get custom =>
      $ForGeneratedCode.field(this, 4, MyCustomTypeExt._exprType);

  Expr<int?> get i =>
      $ForGeneratedCode.field(this, 5, $ForGeneratedCode.integer);

  Expr<JsonValue?> get json =>
      $ForGeneratedCode.field(this, 6, $ForGeneratedCode.jsonValue);
}

extension ExpressionNullableComplexMappedItemExt on Expr<ComplexMappedItem?> {
  Expr<int?> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String?> get s =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<DateTime?> get dt =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.dateTime);

  Expr<Uint8List?> get blob =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.blob);

  Expr<MyCustomType?> get custom =>
      $ForGeneratedCode.field(this, 4, MyCustomTypeExt._exprType);

  Expr<int?> get i =>
      $ForGeneratedCode.field(this, 5, $ForGeneratedCode.integer);

  Expr<JsonValue?> get json =>
      $ForGeneratedCode.field(this, 6, $ForGeneratedCode.jsonValue);

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

/// `Table<ComplexMappedItem>` conflict targets for use with `.onConflict`.
enum ComplexMappedItemConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `id`.
  primaryKey(['id']);

  const ComplexMappedItemConflict(this._fields);

  final List<String> _fields;
}

extension InsertComplexMappedItemExt on Insert<ComplexMappedItem> {
  InsertOnConflict<ComplexMappedItem> onConflict(
    ComplexMappedItemConflict target,
  ) => $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictComplexMappedItemExt
    on InsertOnConflict<ComplexMappedItem> {
  Upsert<ComplexMappedItem> update(
    UpdateSet<ComplexMappedItem> Function(
      Expr<ComplexMappedItem> complexMappedItem,
      Expr<ComplexMappedItem> excluded,
      UpdateSet<ComplexMappedItem> Function({
        Expr<int> id,
        Expr<String?> s,
        Expr<DateTime?> dt,
        Expr<Uint8List?> blob,
        Expr<MyCustomType?> custom,
        Expr<int?> i,
        Expr<JsonValue?> json,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<ComplexMappedItem>(
    this,
    (complexMappedItem, excluded) => updateBuilder(
      complexMappedItem,
      excluded,
      ({
        Expr<int>? id,
        Expr<String?>? s,
        Expr<DateTime?>? dt,
        Expr<Uint8List?>? blob,
        Expr<MyCustomType?>? custom,
        Expr<int?>? i,
        Expr<JsonValue?>? json,
      }) => $ForGeneratedCode.buildUpdate<ComplexMappedItem>([
        id,
        s,
        dt,
        blob,
        custom,
        i,
        json,
      ]),
    ),
  );
}

extension InsertSingleComplexMappedItemExt on InsertSingle<ComplexMappedItem> {
  InsertOnConflictSingle<ComplexMappedItem> onConflict(
    ComplexMappedItemConflict target,
  ) => $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleComplexMappedItemExt
    on InsertOnConflictSingle<ComplexMappedItem> {
  UpsertSingle<ComplexMappedItem> update(
    UpdateSet<ComplexMappedItem> Function(
      Expr<ComplexMappedItem> complexMappedItem,
      Expr<ComplexMappedItem> excluded,
      UpdateSet<ComplexMappedItem> Function({
        Expr<int> id,
        Expr<String?> s,
        Expr<DateTime?> dt,
        Expr<Uint8List?> blob,
        Expr<MyCustomType?> custom,
        Expr<int?> i,
        Expr<JsonValue?> json,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<ComplexMappedItem>(
    this,
    (complexMappedItem, excluded) => updateBuilder(
      complexMappedItem,
      excluded,
      ({
        Expr<int>? id,
        Expr<String?>? s,
        Expr<DateTime?>? dt,
        Expr<Uint8List?>? blob,
        Expr<MyCustomType?>? custom,
        Expr<int?>? i,
        Expr<JsonValue?>? json,
      }) => $ForGeneratedCode.buildUpdate<ComplexMappedItem>([
        id,
        s,
        dt,
        blob,
        custom,
        i,
        json,
      ]),
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

/// Extension methods for assertions on [ComplexMappedItem] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension ComplexMappedItemChecks on Subject<ComplexMappedItem> {
  /// Create assertions on [ComplexMappedItem.id].
  Subject<int> get id => has((m) => m.id, 'id');

  /// Create assertions on [ComplexMappedItem.s].
  Subject<String?> get s => has((m) => m.s, 's');

  /// Create assertions on [ComplexMappedItem.dt].
  Subject<DateTime?> get dt => has((m) => m.dt, 'dt');

  /// Create assertions on [ComplexMappedItem.blob].
  Subject<Uint8List?> get blob => has((m) => m.blob, 'blob');

  /// Create assertions on [ComplexMappedItem.custom].
  Subject<MyCustomType?> get custom => has((m) => m.custom, 'custom');

  /// Create assertions on [ComplexMappedItem.i].
  Subject<int?> get i => has((m) => m.i, 'i');

  /// Create assertions on [ComplexMappedItem.json].
  Subject<JsonValue?> get json => has((m) => m.json, 'json');
}
