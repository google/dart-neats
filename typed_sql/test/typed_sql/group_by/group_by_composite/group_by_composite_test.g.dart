// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_by_composite_test.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

extension TestDatabaseSchema on DatabaseContext<TestDatabase> {
  static const _$tables = [_$Item._$table];

  /// TODO: Propagate documentation for tables!
  Table<Item> get items => ExposedForCodeGen.declareTable(
        this,
        _$Item._$table,
      );
  Future<void> createTables() async => ExposedForCodeGen.createTables(
        context: this,
        tables: _$tables,
      );
}

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
    })>[
      (
        type: ExposedForCodeGen.integer,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: true,
      ),
      (
        type: ExposedForCodeGen.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
      ),
      (
        type: ExposedForCodeGen.real,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
      ),
      (
        type: ExposedForCodeGen.integer,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
      ),
      (
        type: ExposedForCodeGen.dateTime,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
      ),
      (
        type: ExposedForCodeGen.text,
        isNotNull: false,
        defaultValue: null,
        autoIncrement: false,
      ),
      (
        type: ExposedForCodeGen.real,
        isNotNull: false,
        defaultValue: null,
        autoIncrement: false,
      ),
      (
        type: ExposedForCodeGen.integer,
        isNotNull: false,
        defaultValue: null,
        autoIncrement: false,
      ),
      (
        type: ExposedForCodeGen.dateTime,
        isNotNull: false,
        defaultValue: null,
        autoIncrement: false,
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
    readModel: _$Item._$fromDatabase,
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

extension TableItemExt on Table<Item> {
  /// TODO: document insertLiteral (this cannot explicitly insert NULL for nullable fields with a default value)
  InsertSingle<Item> insertLiteral({
    int? id,
    required String text,
    required double real,
    required int integer,
    required DateTime timestamp,
    String? optText,
    double? optReal,
    int? optInteger,
    DateTime? optTimestamp,
  }) =>
      ExposedForCodeGen.insertInto(
        table: this,
        values: [
          id != null ? literal(id) : null,
          literal(text),
          literal(real),
          literal(integer),
          literal(timestamp),
          optText != null ? literal(optText) : null,
          optReal != null ? literal(optReal) : null,
          optInteger != null ? literal(optInteger) : null,
          optTimestamp != null ? literal(optTimestamp) : null,
        ],
      );

  /// TODO: document insert
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

  /// TODO: document delete
  DeleteSingle<Item> delete({required int id}) =>
      ExposedForCodeGen.deleteSingle(
        byKey(id: id),
        _$Item._$table,
      );
}

extension QueryItemExt on Query<(Expr<Item>,)> {
  /// TODO: document lookup by PrimaryKey
  QuerySingle<(Expr<Item>,)> byKey({required int id}) =>
      where((item) => item.id.equalsLiteral(id)).first;

  /// TODO: document updateAll()
  Update<Item> updateAll(
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

  /// TODO: document updateAllLiteral()
  /// WARNING: This cannot set properties to `null`!
  Update<Item> updateAllLiteral({
    int? id,
    String? text,
    double? real,
    int? integer,
    DateTime? timestamp,
    String? optText,
    double? optReal,
    int? optInteger,
    DateTime? optTimestamp,
  }) =>
      ExposedForCodeGen.update<Item>(
        this,
        _$Item._$table,
        (item) => ExposedForCodeGen.buildUpdate<Item>([
          id != null ? literal(id) : null,
          text != null ? literal(text) : null,
          real != null ? literal(real) : null,
          integer != null ? literal(integer) : null,
          timestamp != null ? literal(timestamp) : null,
          optText != null ? literal(optText) : null,
          optReal != null ? literal(optReal) : null,
          optInteger != null ? literal(optInteger) : null,
          optTimestamp != null ? literal(optTimestamp) : null,
        ]),
      );

  /// TODO: document delete()}
  Delete<Item> delete() => ExposedForCodeGen.delete(this, _$Item._$table);
}

extension QuerySingleItemExt on QuerySingle<(Expr<Item>,)> {
  /// TODO: document update()
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

  /// TODO: document updateLiteral()
  /// WARNING: This cannot set properties to `null`!
  UpdateSingle<Item> updateLiteral({
    int? id,
    String? text,
    double? real,
    int? integer,
    DateTime? timestamp,
    String? optText,
    double? optReal,
    int? optInteger,
    DateTime? optTimestamp,
  }) =>
      ExposedForCodeGen.updateSingle<Item>(
        this,
        _$Item._$table,
        (item) => ExposedForCodeGen.buildUpdate<Item>([
          id != null ? literal(id) : null,
          text != null ? literal(text) : null,
          real != null ? literal(real) : null,
          integer != null ? literal(integer) : null,
          timestamp != null ? literal(timestamp) : null,
          optText != null ? literal(optText) : null,
          optReal != null ? literal(optReal) : null,
          optInteger != null ? literal(optInteger) : null,
          optTimestamp != null ? literal(optTimestamp) : null,
        ]),
      );

  /// TODO: document delete()
  DeleteSingle<Item> delete() =>
      ExposedForCodeGen.deleteSingle(this, _$Item._$table);
}

extension ExpressionItemExt on Expr<Item> {
  /// TODO: document id
  Expr<int> get id =>
      ExposedForCodeGen.field(this, 0, ExposedForCodeGen.integer);

  /// TODO: document text
  Expr<String> get text =>
      ExposedForCodeGen.field(this, 1, ExposedForCodeGen.text);

  /// TODO: document real
  Expr<double> get real =>
      ExposedForCodeGen.field(this, 2, ExposedForCodeGen.real);

  /// TODO: document integer
  Expr<int> get integer =>
      ExposedForCodeGen.field(this, 3, ExposedForCodeGen.integer);

  /// TODO: document timestamp
  Expr<DateTime> get timestamp =>
      ExposedForCodeGen.field(this, 4, ExposedForCodeGen.dateTime);

  /// TODO: document optText
  Expr<String?> get optText =>
      ExposedForCodeGen.field(this, 5, ExposedForCodeGen.text);

  /// TODO: document optReal
  Expr<double?> get optReal =>
      ExposedForCodeGen.field(this, 6, ExposedForCodeGen.real);

  /// TODO: document optInteger
  Expr<int?> get optInteger =>
      ExposedForCodeGen.field(this, 7, ExposedForCodeGen.integer);

  /// TODO: document optTimestamp
  Expr<DateTime?> get optTimestamp =>
      ExposedForCodeGen.field(this, 8, ExposedForCodeGen.dateTime);
}

extension ExpressionNullableItemExt on Expr<Item?> {
  /// TODO: document id
  Expr<int?> get id =>
      ExposedForCodeGen.field(this, 0, ExposedForCodeGen.integer);

  /// TODO: document text
  Expr<String?> get text =>
      ExposedForCodeGen.field(this, 1, ExposedForCodeGen.text);

  /// TODO: document real
  Expr<double?> get real =>
      ExposedForCodeGen.field(this, 2, ExposedForCodeGen.real);

  /// TODO: document integer
  Expr<int?> get integer =>
      ExposedForCodeGen.field(this, 3, ExposedForCodeGen.integer);

  /// TODO: document timestamp
  Expr<DateTime?> get timestamp =>
      ExposedForCodeGen.field(this, 4, ExposedForCodeGen.dateTime);

  /// TODO: document optText
  Expr<String?> get optText =>
      ExposedForCodeGen.field(this, 5, ExposedForCodeGen.text);

  /// TODO: document optReal
  Expr<double?> get optReal =>
      ExposedForCodeGen.field(this, 6, ExposedForCodeGen.real);

  /// TODO: document optInteger
  Expr<int?> get optInteger =>
      ExposedForCodeGen.field(this, 7, ExposedForCodeGen.integer);

  /// TODO: document optTimestamp
  Expr<DateTime?> get optTimestamp =>
      ExposedForCodeGen.field(this, 8, ExposedForCodeGen.dateTime);
}

extension ItemChecks on Subject<Item> {
  Subject<int> get id => has((m) => m.id, 'id');
  Subject<String> get text => has((m) => m.text, 'text');
  Subject<double> get real => has((m) => m.real, 'real');
  Subject<int> get integer => has((m) => m.integer, 'integer');
  Subject<DateTime> get timestamp => has((m) => m.timestamp, 'timestamp');
  Subject<String?> get optText => has((m) => m.optText, 'optText');
  Subject<double?> get optReal => has((m) => m.optReal, 'optReal');
  Subject<int?> get optInteger => has((m) => m.optInteger, 'optInteger');
  Subject<DateTime?> get optTimestamp =>
      has((m) => m.optTimestamp, 'optTimestamp');
}
