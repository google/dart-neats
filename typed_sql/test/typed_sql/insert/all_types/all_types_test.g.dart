// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_types_test.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

/// Extension methods for a [Database] operating on [AllTypesDatabase].
extension AllTypesDatabaseSchema on Database<AllTypesDatabase> {
  static final _$tables = [_$AllTypesItem._$table];

  Table<AllTypesItem> get allTypesItems =>
      $ForGeneratedCode.declareTable(this, _$AllTypesItem._$table);

  /// Create tables defined in [AllTypesDatabase].
  ///
  /// Calling this on an empty database will create the tables
  /// defined in [AllTypesDatabase]. In production it's often better to
  /// use [createAllTypesDatabaseTables] and manage migrations using
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

/// Get SQL [DDL statements][1] for tables defined in [AllTypesDatabase].
///
/// This returns a SQL script with multiple DDL statements separated by `;`
/// using the specified [dialect].
///
/// Executing these statements in an empty database will create the tables
/// defined in [AllTypesDatabase]. In practice, this method is often used for
/// printing the DDL statements, such that migrations can be managed by
/// external tools.
///
/// [1]: https://en.wikipedia.org/wiki/Data_definition_language
String createAllTypesDatabaseTables(SqlDialect dialect) =>
    $ForGeneratedCode.createTableSchema(
      dialect: dialect,
      tables: AllTypesDatabaseSchema._$tables,
    );

final class _$AllTypesItem extends AllTypesItem {
  _$AllTypesItem._(
    this.id,
    this.b,
    this.i,
    this.d,
    this.s,
    this.dt,
    this.blob,
    this.json,
    this.custom,
    this.nb,
    this.ni,
    this.nd,
    this.ns,
    this.ndt,
    this.nblob,
    this.njson,
    this.ncustom,
    this.db,
    this.di,
    this.dd,
    this.ds,
    this.ddt,
    this.djson,
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
  final DateTime dt;

  @override
  final Uint8List blob;

  @override
  final JsonValue json;

  @override
  final MyCustomType custom;

  @override
  final bool? nb;

  @override
  final int? ni;

  @override
  final double? nd;

  @override
  final String? ns;

  @override
  final DateTime? ndt;

  @override
  final Uint8List? nblob;

  @override
  final JsonValue? njson;

  @override
  final MyCustomType? ncustom;

  @override
  final bool db;

  @override
  final int di;

  @override
  final double dd;

  @override
  final String ds;

  @override
  final DateTime ddt;

  @override
  final JsonValue djson;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'allTypesItems',
    columns: <String>[
      'id',
      'b',
      'i',
      'd',
      's',
      'dt',
      'blob',
      'json',
      'custom',
      'nb',
      'ni',
      'nd',
      'ns',
      'ndt',
      'nblob',
      'njson',
      'ncustom',
      'db',
      'di',
      'dd',
      'ds',
      'ddt',
      'djson',
    ],
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
        type: $ForGeneratedCode.real,
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
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.dateTime,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.blob,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.jsonValue,
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
        type: $ForGeneratedCode.boolean,
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
        type: $ForGeneratedCode.real,
        isNotNull: false,
        defaultValue: null,
        autoIncrement: false,
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
        type: $ForGeneratedCode.jsonValue,
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
        type: $ForGeneratedCode.jsonValue,
        isNotNull: true,
        defaultValue: (kind: 'raw', value: const JsonValue({})),
        autoIncrement: false,
        overrides: [],
      ),
    ],
    primaryKey: <String>['id'],
    unique: <List<String>>[],
    foreignKeys: [],
    readRow: _$AllTypesItem._$fromDatabase,
  );

  static AllTypesItem? _$fromDatabase(RowReader row) {
    final id = row.readInt();
    final b = row.readBool();
    final i = row.readInt();
    final d = row.readDouble();
    final s = row.readString();
    final dt = row.readDateTime();
    final blob = row.readUint8List();
    final json = row.readJsonValue();
    final custom = $ForGeneratedCode.customDataTypeOrNull(
      row.readInt(),
      MyCustomType.fromDatabase,
    );
    final nb = row.readBool();
    final ni = row.readInt();
    final nd = row.readDouble();
    final ns = row.readString();
    final ndt = row.readDateTime();
    final nblob = row.readUint8List();
    final njson = row.readJsonValue();
    final ncustom = $ForGeneratedCode.customDataTypeOrNull(
      row.readInt(),
      MyCustomType.fromDatabase,
    );
    final db = row.readBool();
    final di = row.readInt();
    final dd = row.readDouble();
    final ds = row.readString();
    final ddt = row.readDateTime();
    final djson = row.readJsonValue();
    if (id == null &&
        b == null &&
        i == null &&
        d == null &&
        s == null &&
        dt == null &&
        blob == null &&
        json == null &&
        custom == null &&
        nb == null &&
        ni == null &&
        nd == null &&
        ns == null &&
        ndt == null &&
        nblob == null &&
        njson == null &&
        ncustom == null &&
        db == null &&
        di == null &&
        dd == null &&
        ds == null &&
        ddt == null &&
        djson == null) {
      return null;
    }
    return _$AllTypesItem._(
      id!,
      b!,
      i!,
      d!,
      s!,
      dt!,
      blob!,
      json!,
      custom!,
      nb,
      ni,
      nd,
      ns,
      ndt,
      nblob,
      njson,
      ncustom,
      db!,
      di!,
      dd!,
      ds!,
      ddt!,
      djson!,
    );
  }

  @override
  String toString() =>
      'AllTypesItem(id: "$id", b: "$b", i: "$i", d: "$d", s: "$s", dt: "$dt", blob: "$blob", json: "$json", custom: "$custom", nb: "$nb", ni: "$ni", nd: "$nd", ns: "$ns", ndt: "$ndt", nblob: "$nblob", njson: "$njson", ncustom: "$ncustom", db: "$db", di: "$di", dd: "$dd", ds: "$ds", ddt: "$ddt", djson: "$djson")';
}

/// Extension methods for table defined in [AllTypesItem].
extension TableAllTypesItemExt on Table<AllTypesItem> {
  /// Insert row into the `allTypesItems` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<AllTypesItem> insert({
    Expr<int>? id,
    required Expr<bool> b,
    required Expr<int> i,
    required Expr<double> d,
    required Expr<String> s,
    required Expr<DateTime> dt,
    required Expr<Uint8List> blob,
    required Expr<JsonValue> json,
    required Expr<MyCustomType> custom,
    Expr<bool?>? nb,
    Expr<int?>? ni,
    Expr<double?>? nd,
    Expr<String?>? ns,
    Expr<DateTime?>? ndt,
    Expr<Uint8List?>? nblob,
    Expr<JsonValue?>? njson,
    Expr<MyCustomType?>? ncustom,
    Expr<bool>? db,
    Expr<int>? di,
    Expr<double>? dd,
    Expr<String>? ds,
    Expr<DateTime>? ddt,
    Expr<JsonValue>? djson,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [
      id,
      b,
      i,
      d,
      s,
      dt,
      blob,
      json,
      custom,
      nb,
      ni,
      nd,
      ns,
      ndt,
      nblob,
      njson,
      ncustom,
      db,
      di,
      dd,
      ds,
      ddt,
      djson,
    ],
  );

  /// Insert row into the `allTypesItems` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<AllTypesItem> insertValue({
    int? id,
    required bool b,
    required int i,
    required double d,
    required String s,
    required DateTime dt,
    required Uint8List blob,
    required JsonValue json,
    required MyCustomType custom,
    bool? nb,
    int? ni,
    double? nd,
    String? ns,
    DateTime? ndt,
    Uint8List? nblob,
    JsonValue? njson,
    MyCustomType? ncustom,
    bool? db,
    int? di,
    double? dd,
    String? ds,
    DateTime? ddt,
    JsonValue? djson,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [
      id?.asExpr,
      b.asExpr,
      i.asExpr,
      d.asExpr,
      s.asExpr,
      dt.asExpr,
      blob.asExpr,
      json.asExpr,
      custom.asExpr,
      nb.asExpr,
      ni.asExpr,
      nd.asExpr,
      ns.asExpr,
      ndt.asExpr,
      nblob.asExpr,
      njson.asExpr,
      ncustom.asExpr,
      db?.asExpr,
      di?.asExpr,
      dd?.asExpr,
      ds?.asExpr,
      ddt?.asExpr,
      djson?.asExpr,
    ],
  );

  /// Bulk insert rows into the `allTypesItems` table.
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
  Insert<AllTypesItem> insertValuesMapped<T>(
    Iterable<T> rows, {
    int Function(T row)? id,
    required bool Function(T row) b,
    required int Function(T row) i,
    required double Function(T row) d,
    required String Function(T row) s,
    required DateTime Function(T row) dt,
    required Uint8List Function(T row) blob,
    required JsonValue Function(T row) json,
    required MyCustomType Function(T row) custom,
    bool? Function(T row)? nb,
    int? Function(T row)? ni,
    double? Function(T row)? nd,
    String? Function(T row)? ns,
    DateTime? Function(T row)? ndt,
    Uint8List? Function(T row)? nblob,
    JsonValue? Function(T row)? njson,
    MyCustomType? Function(T row)? ncustom,
    bool Function(T row)? db,
    int Function(T row)? di,
    double Function(T row)? dd,
    String Function(T row)? ds,
    DateTime Function(T row)? ddt,
    JsonValue Function(T row)? djson,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mappings: [
      id,
      b,
      i,
      d,
      s,
      dt,
      blob,
      json,
      (T v) => custom(v).toDatabase(),
      nb,
      ni,
      nd,
      ns,
      ndt,
      nblob,
      njson,
      ncustom != null ? (T v) => ncustom(v)?.toDatabase() : null,
      db,
      di,
      dd,
      ds,
      ddt,
      djson,
    ],
  );

  /// Delete a single row from the `allTypesItems` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<AllTypesItem> delete(int id) =>
      $ForGeneratedCode.deleteSingle(byKey(id), _$AllTypesItem._$table);
}

/// Extension methods for building queries against the `allTypesItems` table.
extension QueryAllTypesItemExt on Query<(Expr<AllTypesItem>,)> {
  /// Lookup a single row in `allTypesItems` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<AllTypesItem>,)> byKey(int id) =>
      where((allTypesItem) => allTypesItem.id.equalsValue(id)).first;

  /// Update all rows in the `allTypesItems` table matching this [Query].
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
  Update<AllTypesItem> update(
    UpdateSet<AllTypesItem> Function(
      Expr<AllTypesItem> allTypesItem,
      UpdateSet<AllTypesItem> Function({
        Expr<int> id,
        Expr<bool> b,
        Expr<int> i,
        Expr<double> d,
        Expr<String> s,
        Expr<DateTime> dt,
        Expr<Uint8List> blob,
        Expr<JsonValue> json,
        Expr<MyCustomType> custom,
        Expr<bool?> nb,
        Expr<int?> ni,
        Expr<double?> nd,
        Expr<String?> ns,
        Expr<DateTime?> ndt,
        Expr<Uint8List?> nblob,
        Expr<JsonValue?> njson,
        Expr<MyCustomType?> ncustom,
        Expr<bool> db,
        Expr<int> di,
        Expr<double> dd,
        Expr<String> ds,
        Expr<DateTime> ddt,
        Expr<JsonValue> djson,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<AllTypesItem>(
    this,
    _$AllTypesItem._$table,
    (allTypesItem) => updateBuilder(
      allTypesItem,
      ({
        Expr<int>? id,
        Expr<bool>? b,
        Expr<int>? i,
        Expr<double>? d,
        Expr<String>? s,
        Expr<DateTime>? dt,
        Expr<Uint8List>? blob,
        Expr<JsonValue>? json,
        Expr<MyCustomType>? custom,
        Expr<bool?>? nb,
        Expr<int?>? ni,
        Expr<double?>? nd,
        Expr<String?>? ns,
        Expr<DateTime?>? ndt,
        Expr<Uint8List?>? nblob,
        Expr<JsonValue?>? njson,
        Expr<MyCustomType?>? ncustom,
        Expr<bool>? db,
        Expr<int>? di,
        Expr<double>? dd,
        Expr<String>? ds,
        Expr<DateTime>? ddt,
        Expr<JsonValue>? djson,
      }) => $ForGeneratedCode.buildUpdate<AllTypesItem>([
        id,
        b,
        i,
        d,
        s,
        dt,
        blob,
        json,
        custom,
        nb,
        ni,
        nd,
        ns,
        ndt,
        nblob,
        njson,
        ncustom,
        db,
        di,
        dd,
        ds,
        ddt,
        djson,
      ]),
    ),
  );

  /// Delete all rows in the `allTypesItems` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<AllTypesItem> delete() =>
      $ForGeneratedCode.delete(this, _$AllTypesItem._$table);
}

/// Extension methods for building point queries against the `allTypesItems` table.
extension QuerySingleAllTypesItemExt on QuerySingle<(Expr<AllTypesItem>,)> {
  /// Update the row (if any) in the `allTypesItems` table matching this
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
  UpdateSingle<AllTypesItem> update(
    UpdateSet<AllTypesItem> Function(
      Expr<AllTypesItem> allTypesItem,
      UpdateSet<AllTypesItem> Function({
        Expr<int> id,
        Expr<bool> b,
        Expr<int> i,
        Expr<double> d,
        Expr<String> s,
        Expr<DateTime> dt,
        Expr<Uint8List> blob,
        Expr<JsonValue> json,
        Expr<MyCustomType> custom,
        Expr<bool?> nb,
        Expr<int?> ni,
        Expr<double?> nd,
        Expr<String?> ns,
        Expr<DateTime?> ndt,
        Expr<Uint8List?> nblob,
        Expr<JsonValue?> njson,
        Expr<MyCustomType?> ncustom,
        Expr<bool> db,
        Expr<int> di,
        Expr<double> dd,
        Expr<String> ds,
        Expr<DateTime> ddt,
        Expr<JsonValue> djson,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<AllTypesItem>(
    this,
    _$AllTypesItem._$table,
    (allTypesItem) => updateBuilder(
      allTypesItem,
      ({
        Expr<int>? id,
        Expr<bool>? b,
        Expr<int>? i,
        Expr<double>? d,
        Expr<String>? s,
        Expr<DateTime>? dt,
        Expr<Uint8List>? blob,
        Expr<JsonValue>? json,
        Expr<MyCustomType>? custom,
        Expr<bool?>? nb,
        Expr<int?>? ni,
        Expr<double?>? nd,
        Expr<String?>? ns,
        Expr<DateTime?>? ndt,
        Expr<Uint8List?>? nblob,
        Expr<JsonValue?>? njson,
        Expr<MyCustomType?>? ncustom,
        Expr<bool>? db,
        Expr<int>? di,
        Expr<double>? dd,
        Expr<String>? ds,
        Expr<DateTime>? ddt,
        Expr<JsonValue>? djson,
      }) => $ForGeneratedCode.buildUpdate<AllTypesItem>([
        id,
        b,
        i,
        d,
        s,
        dt,
        blob,
        json,
        custom,
        nb,
        ni,
        nd,
        ns,
        ndt,
        nblob,
        njson,
        ncustom,
        db,
        di,
        dd,
        ds,
        ddt,
        djson,
      ]),
    ),
  );

  /// Delete the row (if any) in the `allTypesItems` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<AllTypesItem> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$AllTypesItem._$table);
}

/// Extension methods for expressions on a row in the `allTypesItems` table.
extension ExpressionAllTypesItemExt on Expr<AllTypesItem> {
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

  Expr<DateTime> get dt =>
      $ForGeneratedCode.field(this, 5, $ForGeneratedCode.dateTime);

  Expr<Uint8List> get blob =>
      $ForGeneratedCode.field(this, 6, $ForGeneratedCode.blob);

  Expr<JsonValue> get json =>
      $ForGeneratedCode.field(this, 7, $ForGeneratedCode.jsonValue);

  Expr<MyCustomType> get custom =>
      $ForGeneratedCode.field(this, 8, MyCustomTypeExt._exprType);

  Expr<bool?> get nb =>
      $ForGeneratedCode.field(this, 9, $ForGeneratedCode.boolean);

  Expr<int?> get ni =>
      $ForGeneratedCode.field(this, 10, $ForGeneratedCode.integer);

  Expr<double?> get nd =>
      $ForGeneratedCode.field(this, 11, $ForGeneratedCode.real);

  Expr<String?> get ns =>
      $ForGeneratedCode.field(this, 12, $ForGeneratedCode.text);

  Expr<DateTime?> get ndt =>
      $ForGeneratedCode.field(this, 13, $ForGeneratedCode.dateTime);

  Expr<Uint8List?> get nblob =>
      $ForGeneratedCode.field(this, 14, $ForGeneratedCode.blob);

  Expr<JsonValue?> get njson =>
      $ForGeneratedCode.field(this, 15, $ForGeneratedCode.jsonValue);

  Expr<MyCustomType?> get ncustom =>
      $ForGeneratedCode.field(this, 16, MyCustomTypeExt._exprType);

  Expr<bool> get db =>
      $ForGeneratedCode.field(this, 17, $ForGeneratedCode.boolean);

  Expr<int> get di =>
      $ForGeneratedCode.field(this, 18, $ForGeneratedCode.integer);

  Expr<double> get dd =>
      $ForGeneratedCode.field(this, 19, $ForGeneratedCode.real);

  Expr<String> get ds =>
      $ForGeneratedCode.field(this, 20, $ForGeneratedCode.text);

  Expr<DateTime> get ddt =>
      $ForGeneratedCode.field(this, 21, $ForGeneratedCode.dateTime);

  Expr<JsonValue> get djson =>
      $ForGeneratedCode.field(this, 22, $ForGeneratedCode.jsonValue);
}

extension ExpressionNullableAllTypesItemExt on Expr<AllTypesItem?> {
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

  Expr<DateTime?> get dt =>
      $ForGeneratedCode.field(this, 5, $ForGeneratedCode.dateTime);

  Expr<Uint8List?> get blob =>
      $ForGeneratedCode.field(this, 6, $ForGeneratedCode.blob);

  Expr<JsonValue?> get json =>
      $ForGeneratedCode.field(this, 7, $ForGeneratedCode.jsonValue);

  Expr<MyCustomType?> get custom =>
      $ForGeneratedCode.field(this, 8, MyCustomTypeExt._exprType);

  Expr<bool?> get nb =>
      $ForGeneratedCode.field(this, 9, $ForGeneratedCode.boolean);

  Expr<int?> get ni =>
      $ForGeneratedCode.field(this, 10, $ForGeneratedCode.integer);

  Expr<double?> get nd =>
      $ForGeneratedCode.field(this, 11, $ForGeneratedCode.real);

  Expr<String?> get ns =>
      $ForGeneratedCode.field(this, 12, $ForGeneratedCode.text);

  Expr<DateTime?> get ndt =>
      $ForGeneratedCode.field(this, 13, $ForGeneratedCode.dateTime);

  Expr<Uint8List?> get nblob =>
      $ForGeneratedCode.field(this, 14, $ForGeneratedCode.blob);

  Expr<JsonValue?> get njson =>
      $ForGeneratedCode.field(this, 15, $ForGeneratedCode.jsonValue);

  Expr<MyCustomType?> get ncustom =>
      $ForGeneratedCode.field(this, 16, MyCustomTypeExt._exprType);

  Expr<bool?> get db =>
      $ForGeneratedCode.field(this, 17, $ForGeneratedCode.boolean);

  Expr<int?> get di =>
      $ForGeneratedCode.field(this, 18, $ForGeneratedCode.integer);

  Expr<double?> get dd =>
      $ForGeneratedCode.field(this, 19, $ForGeneratedCode.real);

  Expr<String?> get ds =>
      $ForGeneratedCode.field(this, 20, $ForGeneratedCode.text);

  Expr<DateTime?> get ddt =>
      $ForGeneratedCode.field(this, 21, $ForGeneratedCode.dateTime);

  Expr<JsonValue?> get djson =>
      $ForGeneratedCode.field(this, 22, $ForGeneratedCode.jsonValue);

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

/// `Table<AllTypesItem>` conflict targets for use with `.onConflict`.
enum AllTypesItemConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `id`.
  primaryKey(['id']);

  const AllTypesItemConflict(this._fields);

  final List<String> _fields;
}

extension InsertAllTypesItemExt on Insert<AllTypesItem> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((allTypesItem, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflict<AllTypesItem> onConflict(AllTypesItemConflict target) =>
      $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictAllTypesItemExt on InsertOnConflict<AllTypesItem> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `allTypesItem` an [Expr] representing the existing row in
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
  Upsert<AllTypesItem> update(
    UpdateSet<AllTypesItem> Function(
      Expr<AllTypesItem> allTypesItem,
      Expr<AllTypesItem> excluded,
      UpdateSet<AllTypesItem> Function({
        Expr<int> id,
        Expr<bool> b,
        Expr<int> i,
        Expr<double> d,
        Expr<String> s,
        Expr<DateTime> dt,
        Expr<Uint8List> blob,
        Expr<JsonValue> json,
        Expr<MyCustomType> custom,
        Expr<bool?> nb,
        Expr<int?> ni,
        Expr<double?> nd,
        Expr<String?> ns,
        Expr<DateTime?> ndt,
        Expr<Uint8List?> nblob,
        Expr<JsonValue?> njson,
        Expr<MyCustomType?> ncustom,
        Expr<bool> db,
        Expr<int> di,
        Expr<double> dd,
        Expr<String> ds,
        Expr<DateTime> ddt,
        Expr<JsonValue> djson,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<AllTypesItem>(
    this,
    (allTypesItem, excluded) => updateBuilder(
      allTypesItem,
      excluded,
      ({
        Expr<int>? id,
        Expr<bool>? b,
        Expr<int>? i,
        Expr<double>? d,
        Expr<String>? s,
        Expr<DateTime>? dt,
        Expr<Uint8List>? blob,
        Expr<JsonValue>? json,
        Expr<MyCustomType>? custom,
        Expr<bool?>? nb,
        Expr<int?>? ni,
        Expr<double?>? nd,
        Expr<String?>? ns,
        Expr<DateTime?>? ndt,
        Expr<Uint8List?>? nblob,
        Expr<JsonValue?>? njson,
        Expr<MyCustomType?>? ncustom,
        Expr<bool>? db,
        Expr<int>? di,
        Expr<double>? dd,
        Expr<String>? ds,
        Expr<DateTime>? ddt,
        Expr<JsonValue>? djson,
      }) => $ForGeneratedCode.buildUpdate<AllTypesItem>([
        id,
        b,
        i,
        d,
        s,
        dt,
        blob,
        json,
        custom,
        nb,
        ni,
        nd,
        ns,
        ndt,
        nblob,
        njson,
        ncustom,
        db,
        di,
        dd,
        ds,
        ddt,
        djson,
      ]),
    ),
  );
}

extension InsertSingleAllTypesItemExt on InsertSingle<AllTypesItem> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((allTypesItem, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflictSingle<AllTypesItem> onConflict(
    AllTypesItemConflict target,
  ) => $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleAllTypesItemExt
    on InsertOnConflictSingle<AllTypesItem> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `allTypesItem` an [Expr] representing the existing row in
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
  UpsertSingle<AllTypesItem> update(
    UpdateSet<AllTypesItem> Function(
      Expr<AllTypesItem> allTypesItem,
      Expr<AllTypesItem> excluded,
      UpdateSet<AllTypesItem> Function({
        Expr<int> id,
        Expr<bool> b,
        Expr<int> i,
        Expr<double> d,
        Expr<String> s,
        Expr<DateTime> dt,
        Expr<Uint8List> blob,
        Expr<JsonValue> json,
        Expr<MyCustomType> custom,
        Expr<bool?> nb,
        Expr<int?> ni,
        Expr<double?> nd,
        Expr<String?> ns,
        Expr<DateTime?> ndt,
        Expr<Uint8List?> nblob,
        Expr<JsonValue?> njson,
        Expr<MyCustomType?> ncustom,
        Expr<bool> db,
        Expr<int> di,
        Expr<double> dd,
        Expr<String> ds,
        Expr<DateTime> ddt,
        Expr<JsonValue> djson,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<AllTypesItem>(
    this,
    (allTypesItem, excluded) => updateBuilder(
      allTypesItem,
      excluded,
      ({
        Expr<int>? id,
        Expr<bool>? b,
        Expr<int>? i,
        Expr<double>? d,
        Expr<String>? s,
        Expr<DateTime>? dt,
        Expr<Uint8List>? blob,
        Expr<JsonValue>? json,
        Expr<MyCustomType>? custom,
        Expr<bool?>? nb,
        Expr<int?>? ni,
        Expr<double?>? nd,
        Expr<String?>? ns,
        Expr<DateTime?>? ndt,
        Expr<Uint8List?>? nblob,
        Expr<JsonValue?>? njson,
        Expr<MyCustomType?>? ncustom,
        Expr<bool>? db,
        Expr<int>? di,
        Expr<double>? dd,
        Expr<String>? ds,
        Expr<DateTime>? ddt,
        Expr<JsonValue>? djson,
      }) => $ForGeneratedCode.buildUpdate<AllTypesItem>([
        id,
        b,
        i,
        d,
        s,
        dt,
        blob,
        json,
        custom,
        nb,
        ni,
        nd,
        ns,
        ndt,
        nblob,
        njson,
        ncustom,
        db,
        di,
        dd,
        ds,
        ddt,
        djson,
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
  ///
  /// Using [asExpr] will inject this value as an SQL parameter,
  /// use [asExprLiteral] if you wish to inject as SQL literal instead.
  Expr<MyCustomType> get asExpr =>
      $ForGeneratedCode.customDataTypeAsExpr(this, _exprType).asNotNull();

  /// Wrap this [MyCustomType] as [Expr<MyCustomType>] for use queries with
  /// `package:typed_sql`.
  ///
  /// Using [asExprLiteral] will inject this value as an SQL literal,
  /// use [asExpr] if you wish to inject as SQL parameter instead.
  Expr<MyCustomType> get asExprLiteral => $ForGeneratedCode
      .customDataTypeAsExprLiteral(this, _exprType)
      .asNotNull();
}

/// Wrap this [MyCustomType] as [Expr<MyCustomType>] for use queries with
/// `package:typed_sql`.
extension MyCustomTypeNullableExt on MyCustomType? {
  /// Wrap this [MyCustomType] as [Expr<MyCustomType?>] for use queries with
  /// `package:typed_sql`.
  ///
  /// Using [asExpr] will inject this value as an SQL parameter,
  /// use [asExprLiteral] if you wish to inject as SQL literal instead.
  Expr<MyCustomType?> get asExpr =>
      $ForGeneratedCode.customDataTypeAsExpr(this, MyCustomTypeExt._exprType);

  /// Wrap this [MyCustomType] as [Expr<MyCustomType?>] for use queries with
  /// `package:typed_sql`.
  ///
  /// Using [asExprLiteral] will inject this value as an SQL literal,
  /// use [asExpr] if you wish to inject as SQL parameter instead.
  Expr<MyCustomType?> get asExprLiteral => $ForGeneratedCode
      .customDataTypeAsExprLiteral(this, MyCustomTypeExt._exprType);
}

/// Extension methods for assertions on [AllTypesItem] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension AllTypesItemChecks on Subject<AllTypesItem> {
  /// Create assertions on [AllTypesItem.id].
  Subject<int> get id => has((m) => m.id, 'id');

  /// Create assertions on [AllTypesItem.b].
  Subject<bool> get b => has((m) => m.b, 'b');

  /// Create assertions on [AllTypesItem.i].
  Subject<int> get i => has((m) => m.i, 'i');

  /// Create assertions on [AllTypesItem.d].
  Subject<double> get d => has((m) => m.d, 'd');

  /// Create assertions on [AllTypesItem.s].
  Subject<String> get s => has((m) => m.s, 's');

  /// Create assertions on [AllTypesItem.dt].
  Subject<DateTime> get dt => has((m) => m.dt, 'dt');

  /// Create assertions on [AllTypesItem.blob].
  Subject<Uint8List> get blob => has((m) => m.blob, 'blob');

  /// Create assertions on [AllTypesItem.json].
  Subject<JsonValue> get json => has((m) => m.json, 'json');

  /// Create assertions on [AllTypesItem.custom].
  Subject<MyCustomType> get custom => has((m) => m.custom, 'custom');

  /// Create assertions on [AllTypesItem.nb].
  Subject<bool?> get nb => has((m) => m.nb, 'nb');

  /// Create assertions on [AllTypesItem.ni].
  Subject<int?> get ni => has((m) => m.ni, 'ni');

  /// Create assertions on [AllTypesItem.nd].
  Subject<double?> get nd => has((m) => m.nd, 'nd');

  /// Create assertions on [AllTypesItem.ns].
  Subject<String?> get ns => has((m) => m.ns, 'ns');

  /// Create assertions on [AllTypesItem.ndt].
  Subject<DateTime?> get ndt => has((m) => m.ndt, 'ndt');

  /// Create assertions on [AllTypesItem.nblob].
  Subject<Uint8List?> get nblob => has((m) => m.nblob, 'nblob');

  /// Create assertions on [AllTypesItem.njson].
  Subject<JsonValue?> get njson => has((m) => m.njson, 'njson');

  /// Create assertions on [AllTypesItem.ncustom].
  Subject<MyCustomType?> get ncustom => has((m) => m.ncustom, 'ncustom');

  /// Create assertions on [AllTypesItem.db].
  Subject<bool> get db => has((m) => m.db, 'db');

  /// Create assertions on [AllTypesItem.di].
  Subject<int> get di => has((m) => m.di, 'di');

  /// Create assertions on [AllTypesItem.dd].
  Subject<double> get dd => has((m) => m.dd, 'dd');

  /// Create assertions on [AllTypesItem.ds].
  Subject<String> get ds => has((m) => m.ds, 'ds');

  /// Create assertions on [AllTypesItem.ddt].
  Subject<DateTime> get ddt => has((m) => m.ddt, 'ddt');

  /// Create assertions on [AllTypesItem.djson].
  Subject<JsonValue> get djson => has((m) => m.djson, 'djson');
}
