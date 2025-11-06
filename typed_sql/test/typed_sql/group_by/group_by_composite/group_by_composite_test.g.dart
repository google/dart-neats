// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_by_composite_test.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

/// Extension methods for a [Database] operating on [TestDatabase].
extension TestDatabaseSchema on Database<TestDatabase> {
  static const _$tables = [_$Item._$table];

  Table<Item> get items => ExposedForCodeGen.declareTable(
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
  Future<void> createTables() async => ExposedForCodeGen.createTables(
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
    ExposedForCodeGen.createTableSchema(
      dialect: dialect,
      tables: TestDatabaseSchema._$tables,
    );

final class _$Item extends Item {
  _$Item._(
    this.id,
    this.text,
    this.real,
    this.integer,
    this.timestamp,
    this.optText,
    this.optReal,
    this.optInteger,
    this.optTimestamp,
  );

  @override
  final int id;

  @override
  final String text;

  @override
  final double real;

  @override
  final int integer;

  @override
  final DateTime timestamp;

  @override
  final String? optText;

  @override
  final double? optReal;

  @override
  final int? optInteger;

  @override
  final DateTime? optTimestamp;

  static const _$table = (
    tableName: 'items',
    columns: <String>[
      'id',
      'text',
      'real',
      'integer',
      'timestamp',
      'optText',
      'optReal',
      'optInteger',
      'optTimestamp'
    ],
    columnInfo: <({
      ColumnType type,
      bool isNotNull,
      Object? defaultValue,
      bool autoIncrement,
      List<SqlOverride> overrides,
    })>[
      (
        type: ExposedForCodeGen.integer,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: true,
        overrides: <SqlOverride>[],
      ),
      (
        type: ExposedForCodeGen.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: <SqlOverride>[],
      ),
      (
        type: ExposedForCodeGen.real,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: <SqlOverride>[],
      ),
      (
        type: ExposedForCodeGen.integer,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: <SqlOverride>[],
      ),
      (
        type: ExposedForCodeGen.dateTime,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: <SqlOverride>[],
      ),
      (
        type: ExposedForCodeGen.text,
        isNotNull: false,
        defaultValue: null,
        autoIncrement: false,
        overrides: <SqlOverride>[],
      ),
      (
        type: ExposedForCodeGen.real,
        isNotNull: false,
        defaultValue: null,
        autoIncrement: false,
        overrides: <SqlOverride>[],
      ),
      (
        type: ExposedForCodeGen.integer,
        isNotNull: false,
        defaultValue: null,
        autoIncrement: false,
        overrides: <SqlOverride>[],
      ),
      (
        type: ExposedForCodeGen.dateTime,
        isNotNull: false,
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
    final text = row.readString();
    final real = row.readDouble();
    final integer = row.readInt();
    final timestamp = row.readDateTime();
    final optText = row.readString();
    final optReal = row.readDouble();
    final optInteger = row.readInt();
    final optTimestamp = row.readDateTime();
    if (id == null &&
        text == null &&
        real == null &&
        integer == null &&
        timestamp == null &&
        optText == null &&
        optReal == null &&
        optInteger == null &&
        optTimestamp == null) {
      return null;
    }
    return _$Item._(id!, text!, real!, integer!, timestamp!, optText, optReal,
        optInteger, optTimestamp);
  }

  @override
  String toString() =>
      'Item(id: "$id", text: "$text", real: "$real", integer: "$integer", timestamp: "$timestamp", optText: "$optText", optReal: "$optReal", optInteger: "$optInteger", optTimestamp: "$optTimestamp")';
}

/// Extension methods for table defined in [Item].
extension TableItemExt on Table<Item> {
  /// Insert row into the `items` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<Item> insert({
    Expr<int>? id,
    required Expr<String> text,
    required Expr<double> real,
    required Expr<int> integer,
    required Expr<DateTime> timestamp,
    Expr<String?>? optText,
    Expr<double?>? optReal,
    Expr<int?>? optInteger,
    Expr<DateTime?>? optTimestamp,
  }) =>
      ExposedForCodeGen.insertInto(
        table: this,
        values: [
          id,
          text,
          real,
          integer,
          timestamp,
          optText,
          optReal,
          optInteger,
          optTimestamp,
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
  DeleteSingle<Item> delete(int id) => ExposedForCodeGen.deleteSingle(
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
              Expr<String> text,
              Expr<double> real,
              Expr<int> integer,
              Expr<DateTime> timestamp,
              Expr<String?> optText,
              Expr<double?> optReal,
              Expr<int?> optInteger,
              Expr<DateTime?> optTimestamp,
            }) set,
          ) updateBuilder) =>
      ExposedForCodeGen.update<Item>(
        this,
        _$Item._$table,
        (item) => updateBuilder(
          item,
          ({
            Expr<int>? id,
            Expr<String>? text,
            Expr<double>? real,
            Expr<int>? integer,
            Expr<DateTime>? timestamp,
            Expr<String?>? optText,
            Expr<double?>? optReal,
            Expr<int?>? optInteger,
            Expr<DateTime?>? optTimestamp,
          }) =>
              ExposedForCodeGen.buildUpdate<Item>([
            id,
            text,
            real,
            integer,
            timestamp,
            optText,
            optReal,
            optInteger,
            optTimestamp,
          ]),
        ),
      );

  /// Delete all rows in the `items` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<Item> delete() => ExposedForCodeGen.delete(this, _$Item._$table);
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
              Expr<String> text,
              Expr<double> real,
              Expr<int> integer,
              Expr<DateTime> timestamp,
              Expr<String?> optText,
              Expr<double?> optReal,
              Expr<int?> optInteger,
              Expr<DateTime?> optTimestamp,
            }) set,
          ) updateBuilder) =>
      ExposedForCodeGen.updateSingle<Item>(
        this,
        _$Item._$table,
        (item) => updateBuilder(
          item,
          ({
            Expr<int>? id,
            Expr<String>? text,
            Expr<double>? real,
            Expr<int>? integer,
            Expr<DateTime>? timestamp,
            Expr<String?>? optText,
            Expr<double?>? optReal,
            Expr<int?>? optInteger,
            Expr<DateTime?>? optTimestamp,
          }) =>
              ExposedForCodeGen.buildUpdate<Item>([
            id,
            text,
            real,
            integer,
            timestamp,
            optText,
            optReal,
            optInteger,
            optTimestamp,
          ]),
        ),
      );

  /// Delete the row (if any) in the `items` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<Item> delete() =>
      ExposedForCodeGen.deleteSingle(this, _$Item._$table);
}

/// Extension methods for expressions on a row in the `items` table.
extension ExpressionItemExt on Expr<Item> {
  Expr<int> get id =>
      ExposedForCodeGen.field(this, 0, ExposedForCodeGen.integer);

  Expr<String> get text =>
      ExposedForCodeGen.field(this, 1, ExposedForCodeGen.text);

  Expr<double> get real =>
      ExposedForCodeGen.field(this, 2, ExposedForCodeGen.real);

  Expr<int> get integer =>
      ExposedForCodeGen.field(this, 3, ExposedForCodeGen.integer);

  Expr<DateTime> get timestamp =>
      ExposedForCodeGen.field(this, 4, ExposedForCodeGen.dateTime);

  Expr<String?> get optText =>
      ExposedForCodeGen.field(this, 5, ExposedForCodeGen.text);

  Expr<double?> get optReal =>
      ExposedForCodeGen.field(this, 6, ExposedForCodeGen.real);

  Expr<int?> get optInteger =>
      ExposedForCodeGen.field(this, 7, ExposedForCodeGen.integer);

  Expr<DateTime?> get optTimestamp =>
      ExposedForCodeGen.field(this, 8, ExposedForCodeGen.dateTime);
}

extension ExpressionNullableItemExt on Expr<Item?> {
  Expr<int?> get id =>
      ExposedForCodeGen.field(this, 0, ExposedForCodeGen.integer);

  Expr<String?> get text =>
      ExposedForCodeGen.field(this, 1, ExposedForCodeGen.text);

  Expr<double?> get real =>
      ExposedForCodeGen.field(this, 2, ExposedForCodeGen.real);

  Expr<int?> get integer =>
      ExposedForCodeGen.field(this, 3, ExposedForCodeGen.integer);

  Expr<DateTime?> get timestamp =>
      ExposedForCodeGen.field(this, 4, ExposedForCodeGen.dateTime);

  Expr<String?> get optText =>
      ExposedForCodeGen.field(this, 5, ExposedForCodeGen.text);

  Expr<double?> get optReal =>
      ExposedForCodeGen.field(this, 6, ExposedForCodeGen.real);

  Expr<int?> get optInteger =>
      ExposedForCodeGen.field(this, 7, ExposedForCodeGen.integer);

  Expr<DateTime?> get optTimestamp =>
      ExposedForCodeGen.field(this, 8, ExposedForCodeGen.dateTime);

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

  /// Create assertions on [Item.text].
  Subject<String> get text => has((m) => m.text, 'text');

  /// Create assertions on [Item.real].
  Subject<double> get real => has((m) => m.real, 'real');

  /// Create assertions on [Item.integer].
  Subject<int> get integer => has((m) => m.integer, 'integer');

  /// Create assertions on [Item.timestamp].
  Subject<DateTime> get timestamp => has((m) => m.timestamp, 'timestamp');

  /// Create assertions on [Item.optText].
  Subject<String?> get optText => has((m) => m.optText, 'optText');

  /// Create assertions on [Item.optReal].
  Subject<double?> get optReal => has((m) => m.optReal, 'optReal');

  /// Create assertions on [Item.optInteger].
  Subject<int?> get optInteger => has((m) => m.optInteger, 'optInteger');

  /// Create assertions on [Item.optTimestamp].
  Subject<DateTime?> get optTimestamp =>
      has((m) => m.optTimestamp, 'optTimestamp');
}
