// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'defaults_test.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

/// Extension methods for a [Database] operating on [DefaultsDatabase].
extension DefaultsDatabaseSchema on Database<DefaultsDatabase> {
  static final _$tables = [_$DefaultsItem._$table];

  Table<DefaultsItem> get defaultsItems =>
      $ForGeneratedCode.declareTable(this, _$DefaultsItem._$table);

  /// Create tables defined in [DefaultsDatabase].
  ///
  /// Calling this on an empty database will create the tables
  /// defined in [DefaultsDatabase]. In production it's often better to
  /// use [createDefaultsDatabaseTables] and manage migrations using
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

/// Get SQL [DDL statements][1] for tables defined in [DefaultsDatabase].
///
/// This returns a SQL script with multiple DDL statements separated by `;`
/// using the specified [dialect].
///
/// Executing these statements in an empty database will create the tables
/// defined in [DefaultsDatabase]. In practice, this method is often used for
/// printing the DDL statements, such that migrations can be managed by
/// external tools.
///
/// [1]: https://en.wikipedia.org/wiki/Data_definition_language
String createDefaultsDatabaseTables(SqlDialect dialect) =>
    $ForGeneratedCode.createTableSchema(
      dialect: dialect,
      tables: DefaultsDatabaseSchema._$tables,
    );

final class _$DefaultsItem extends DefaultsItem {
  _$DefaultsItem._(
    this.id,
    this.b,
    this.i,
    this.d,
    this.s,
    this.dtNow,
    this.dtEpoch,
    this.json,
  );

  @override
  final int id;

  @override
  final bool b;

  @override
  final int i;

  @override
  final double d;

  @override
  final String s;

  @override
  final DateTime dtNow;

  @override
  final DateTime dtEpoch;

  @override
  final JsonValue json;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'defaultsItems',
    columns: <String>['id', 'b', 'i', 'd', 's', 'dtNow', 'dtEpoch', 'json'],
    columnInfo: [
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.integer,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: true,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.boolean,
        isNotNull: true,
        defaultValue: (kind: 'raw', value: true),
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.integer,
        isNotNull: true,
        defaultValue: (kind: 'raw', value: 42),
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.real,
        isNotNull: true,
        defaultValue: (kind: 'raw', value: 3.14),
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: (kind: 'raw', value: 'default'),
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.dateTime,
        isNotNull: true,
        defaultValue: (kind: 'datetime', value: 'now'),
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.dateTime,
        isNotNull: true,
        defaultValue: (kind: 'datetime', value: 'epoch'),
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.jsonValue,
        isNotNull: true,
        defaultValue: (kind: 'raw', value: const JsonValue({'key': 'value'})),
        autoIncrement: false,
        overrides: [],
      ),
    ],
    primaryKey: <String>['id'],
    unique: <List<String>>[],
    foreignKeys: [],
    readRow: _$DefaultsItem._$fromDatabase,
  );

  static DefaultsItem? _$fromDatabase(RowReader row) {
    final id = row.readInt();
    final b = row.readBool();
    final i = row.readInt();
    final d = row.readDouble();
    final s = row.readString();
    final dtNow = row.readDateTime();
    final dtEpoch = row.readDateTime();
    final json = row.readJsonValue();
    if (id == null &&
        b == null &&
        i == null &&
        d == null &&
        s == null &&
        dtNow == null &&
        dtEpoch == null &&
        json == null) {
      return null;
    }
    return _$DefaultsItem._(id!, b!, i!, d!, s!, dtNow!, dtEpoch!, json!);
  }

  @override
  String toString() =>
      'DefaultsItem(id: "$id", b: "$b", i: "$i", d: "$d", s: "$s", dtNow: "$dtNow", dtEpoch: "$dtEpoch", json: "$json")';
}

/// Extension methods for table defined in [DefaultsItem].
extension TableDefaultsItemExt on Table<DefaultsItem> {
  /// Insert row into the `defaultsItems` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<DefaultsItem> insert({
    Expr<int>? id,
    Expr<bool>? b,
    Expr<int>? i,
    Expr<double>? d,
    Expr<String>? s,
    Expr<DateTime>? dtNow,
    Expr<DateTime>? dtEpoch,
    Expr<JsonValue>? json,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [id, b, i, d, s, dtNow, dtEpoch, json],
  );

  /// Insert row into the `defaultsItems` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<DefaultsItem> insertValue({
    int? id,
    bool? b,
    int? i,
    double? d,
    String? s,
    DateTime? dtNow,
    DateTime? dtEpoch,
    JsonValue? json,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [
      id?.asExpr,
      b?.asExpr,
      i?.asExpr,
      d?.asExpr,
      s?.asExpr,
      dtNow?.asExpr,
      dtEpoch?.asExpr,
      json?.asExpr,
    ],
  );

  /// Bulk insert rows into the `defaultsItems` table.
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
  Insert<DefaultsItem> insertValuesMapped<T>(
    Iterable<T> rows, {
    int Function(T row)? id,
    bool Function(T row)? b,
    int Function(T row)? i,
    double Function(T row)? d,
    String Function(T row)? s,
    DateTime Function(T row)? dtNow,
    DateTime Function(T row)? dtEpoch,
    JsonValue Function(T row)? json,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mapping: {
      'id': id,
      'b': b,
      'i': i,
      'd': d,
      's': s,
      'dtNow': dtNow,
      'dtEpoch': dtEpoch,
      'json': json,
    },
  );

  /// Delete a single row from the `defaultsItems` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<DefaultsItem> delete(int id) =>
      $ForGeneratedCode.deleteSingle(byKey(id), _$DefaultsItem._$table);
}

/// Extension methods for building queries against the `defaultsItems` table.
extension QueryDefaultsItemExt on Query<(Expr<DefaultsItem>,)> {
  /// Lookup a single row in `defaultsItems` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<DefaultsItem>,)> byKey(int id) =>
      where((defaultsItem) => defaultsItem.id.equalsValue(id)).first;

  /// Update all rows in the `defaultsItems` table matching this [Query].
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
  Update<DefaultsItem> update(
    UpdateSet<DefaultsItem> Function(
      Expr<DefaultsItem> defaultsItem,
      UpdateSet<DefaultsItem> Function({
        Expr<int> id,
        Expr<bool> b,
        Expr<int> i,
        Expr<double> d,
        Expr<String> s,
        Expr<DateTime> dtNow,
        Expr<DateTime> dtEpoch,
        Expr<JsonValue> json,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<DefaultsItem>(
    this,
    _$DefaultsItem._$table,
    (defaultsItem) => updateBuilder(
      defaultsItem,
      ({
        Expr<int>? id,
        Expr<bool>? b,
        Expr<int>? i,
        Expr<double>? d,
        Expr<String>? s,
        Expr<DateTime>? dtNow,
        Expr<DateTime>? dtEpoch,
        Expr<JsonValue>? json,
      }) => $ForGeneratedCode.buildUpdate<DefaultsItem>([
        id,
        b,
        i,
        d,
        s,
        dtNow,
        dtEpoch,
        json,
      ]),
    ),
  );

  /// Delete all rows in the `defaultsItems` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<DefaultsItem> delete() =>
      $ForGeneratedCode.delete(this, _$DefaultsItem._$table);
}

/// Extension methods for building point queries against the `defaultsItems` table.
extension QuerySingleDefaultsItemExt on QuerySingle<(Expr<DefaultsItem>,)> {
  /// Update the row (if any) in the `defaultsItems` table matching this
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
  UpdateSingle<DefaultsItem> update(
    UpdateSet<DefaultsItem> Function(
      Expr<DefaultsItem> defaultsItem,
      UpdateSet<DefaultsItem> Function({
        Expr<int> id,
        Expr<bool> b,
        Expr<int> i,
        Expr<double> d,
        Expr<String> s,
        Expr<DateTime> dtNow,
        Expr<DateTime> dtEpoch,
        Expr<JsonValue> json,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<DefaultsItem>(
    this,
    _$DefaultsItem._$table,
    (defaultsItem) => updateBuilder(
      defaultsItem,
      ({
        Expr<int>? id,
        Expr<bool>? b,
        Expr<int>? i,
        Expr<double>? d,
        Expr<String>? s,
        Expr<DateTime>? dtNow,
        Expr<DateTime>? dtEpoch,
        Expr<JsonValue>? json,
      }) => $ForGeneratedCode.buildUpdate<DefaultsItem>([
        id,
        b,
        i,
        d,
        s,
        dtNow,
        dtEpoch,
        json,
      ]),
    ),
  );

  /// Delete the row (if any) in the `defaultsItems` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<DefaultsItem> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$DefaultsItem._$table);
}

/// Extension methods for expressions on a row in the `defaultsItems` table.
extension ExpressionDefaultsItemExt on Expr<DefaultsItem> {
  Expr<int> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<bool> get b =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.boolean);

  Expr<int> get i =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.integer);

  Expr<double> get d =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.real);

  Expr<String> get s =>
      $ForGeneratedCode.field(this, 4, $ForGeneratedCode.text);

  Expr<DateTime> get dtNow =>
      $ForGeneratedCode.field(this, 5, $ForGeneratedCode.dateTime);

  Expr<DateTime> get dtEpoch =>
      $ForGeneratedCode.field(this, 6, $ForGeneratedCode.dateTime);

  Expr<JsonValue> get json =>
      $ForGeneratedCode.field(this, 7, $ForGeneratedCode.jsonValue);
}

extension ExpressionNullableDefaultsItemExt on Expr<DefaultsItem?> {
  Expr<int?> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<bool?> get b =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.boolean);

  Expr<int?> get i =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.integer);

  Expr<double?> get d =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.real);

  Expr<String?> get s =>
      $ForGeneratedCode.field(this, 4, $ForGeneratedCode.text);

  Expr<DateTime?> get dtNow =>
      $ForGeneratedCode.field(this, 5, $ForGeneratedCode.dateTime);

  Expr<DateTime?> get dtEpoch =>
      $ForGeneratedCode.field(this, 6, $ForGeneratedCode.dateTime);

  Expr<JsonValue?> get json =>
      $ForGeneratedCode.field(this, 7, $ForGeneratedCode.jsonValue);

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

/// `Table<DefaultsItem>` conflict targets for use with `.onConflict`.
enum DefaultsItemConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `id`.
  primaryKey(['id']);

  const DefaultsItemConflict(this._fields);

  final List<String> _fields;
}

extension InsertDefaultsItemExt on Insert<DefaultsItem> {
  InsertOnConflict<DefaultsItem> onConflict(DefaultsItemConflict target) =>
      $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictDefaultsItemExt on InsertOnConflict<DefaultsItem> {
  Upsert<DefaultsItem> update(
    UpdateSet<DefaultsItem> Function(
      Expr<DefaultsItem> defaultsItem,
      Expr<DefaultsItem> excluded,
      UpdateSet<DefaultsItem> Function({
        Expr<int> id,
        Expr<bool> b,
        Expr<int> i,
        Expr<double> d,
        Expr<String> s,
        Expr<DateTime> dtNow,
        Expr<DateTime> dtEpoch,
        Expr<JsonValue> json,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<DefaultsItem>(
    this,
    (defaultsItem, excluded) => updateBuilder(
      defaultsItem,
      excluded,
      ({
        Expr<int>? id,
        Expr<bool>? b,
        Expr<int>? i,
        Expr<double>? d,
        Expr<String>? s,
        Expr<DateTime>? dtNow,
        Expr<DateTime>? dtEpoch,
        Expr<JsonValue>? json,
      }) => $ForGeneratedCode.buildUpdate<DefaultsItem>([
        id,
        b,
        i,
        d,
        s,
        dtNow,
        dtEpoch,
        json,
      ]),
    ),
  );
}

extension InsertSingleDefaultsItemExt on InsertSingle<DefaultsItem> {
  InsertOnConflictSingle<DefaultsItem> onConflict(
    DefaultsItemConflict target,
  ) => $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleDefaultsItemExt
    on InsertOnConflictSingle<DefaultsItem> {
  UpsertSingle<DefaultsItem> update(
    UpdateSet<DefaultsItem> Function(
      Expr<DefaultsItem> defaultsItem,
      Expr<DefaultsItem> excluded,
      UpdateSet<DefaultsItem> Function({
        Expr<int> id,
        Expr<bool> b,
        Expr<int> i,
        Expr<double> d,
        Expr<String> s,
        Expr<DateTime> dtNow,
        Expr<DateTime> dtEpoch,
        Expr<JsonValue> json,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<DefaultsItem>(
    this,
    (defaultsItem, excluded) => updateBuilder(
      defaultsItem,
      excluded,
      ({
        Expr<int>? id,
        Expr<bool>? b,
        Expr<int>? i,
        Expr<double>? d,
        Expr<String>? s,
        Expr<DateTime>? dtNow,
        Expr<DateTime>? dtEpoch,
        Expr<JsonValue>? json,
      }) => $ForGeneratedCode.buildUpdate<DefaultsItem>([
        id,
        b,
        i,
        d,
        s,
        dtNow,
        dtEpoch,
        json,
      ]),
    ),
  );
}

/// Extension methods for assertions on [DefaultsItem] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension DefaultsItemChecks on Subject<DefaultsItem> {
  /// Create assertions on [DefaultsItem.id].
  Subject<int> get id => has((m) => m.id, 'id');

  /// Create assertions on [DefaultsItem.b].
  Subject<bool> get b => has((m) => m.b, 'b');

  /// Create assertions on [DefaultsItem.i].
  Subject<int> get i => has((m) => m.i, 'i');

  /// Create assertions on [DefaultsItem.d].
  Subject<double> get d => has((m) => m.d, 'd');

  /// Create assertions on [DefaultsItem.s].
  Subject<String> get s => has((m) => m.s, 's');

  /// Create assertions on [DefaultsItem.dtNow].
  Subject<DateTime> get dtNow => has((m) => m.dtNow, 'dtNow');

  /// Create assertions on [DefaultsItem.dtEpoch].
  Subject<DateTime> get dtEpoch => has((m) => m.dtEpoch, 'dtEpoch');

  /// Create assertions on [DefaultsItem.json].
  Subject<JsonValue> get json => has((m) => m.json, 'json');
}
