// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'distinct_model_test.dart';

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
    this.integer,
    this.real,
  );

  @override
  final int id;

  @override
  final String text;

  @override
  final int integer;

  @override
  final double real;

  static const _$table = (
    tableName: 'items',
    columns: <String>['id', 'text', 'integer', 'real'],
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
        type: ExposedForCodeGen.integer,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
      ),
      (
        type: ExposedForCodeGen.real,
        isNotNull: true,
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
    final integer = row.readInt();
    final real = row.readDouble();
    if (id == null && text == null && integer == null && real == null) {
      return null;
    }
    return _$Item._(id!, text!, integer!, real!);
  }

  @override
  String toString() =>
      'Item(id: "$id", text: "$text", integer: "$integer", real: "$real")';
}

extension TableItemExt on Table<Item> {
  /// TODO: document insertLiteral (this cannot explicitly insert NULL for nullable fields with a default value)
  InsertSingle<Item> insertLiteral({
    int? id,
    required String text,
    required int integer,
    required double real,
  }) =>
      ExposedForCodeGen.insertInto(
        table: this,
        values: [
          id != null ? literal(id) : null,
          literal(text),
          literal(integer),
          literal(real),
        ],
      );

  /// TODO: document insert
  InsertSingle<Item> insert({
    Expr<int>? id,
    required Expr<String> text,
    required Expr<int> integer,
    required Expr<double> real,
  }) =>
      ExposedForCodeGen.insertInto(
        table: this,
        values: [
          id,
          text,
          integer,
          real,
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
              Expr<int> integer,
              Expr<double> real,
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
            Expr<int>? integer,
            Expr<double>? real,
          }) =>
              ExposedForCodeGen.buildUpdate<Item>([
            id,
            text,
            integer,
            real,
          ]),
        ),
      );

  /// TODO: document updateAllLiteral()
  /// WARNING: This cannot set properties to `null`!
  Update<Item> updateAllLiteral({
    int? id,
    String? text,
    int? integer,
    double? real,
  }) =>
      ExposedForCodeGen.update<Item>(
        this,
        _$Item._$table,
        (item) => ExposedForCodeGen.buildUpdate<Item>([
          id != null ? literal(id) : null,
          text != null ? literal(text) : null,
          integer != null ? literal(integer) : null,
          real != null ? literal(real) : null,
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
              Expr<int> integer,
              Expr<double> real,
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
            Expr<int>? integer,
            Expr<double>? real,
          }) =>
              ExposedForCodeGen.buildUpdate<Item>([
            id,
            text,
            integer,
            real,
          ]),
        ),
      );

  /// TODO: document updateLiteral()
  /// WARNING: This cannot set properties to `null`!
  UpdateSingle<Item> updateLiteral({
    int? id,
    String? text,
    int? integer,
    double? real,
  }) =>
      ExposedForCodeGen.updateSingle<Item>(
        this,
        _$Item._$table,
        (item) => ExposedForCodeGen.buildUpdate<Item>([
          id != null ? literal(id) : null,
          text != null ? literal(text) : null,
          integer != null ? literal(integer) : null,
          real != null ? literal(real) : null,
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

  /// TODO: document integer
  Expr<int> get integer =>
      ExposedForCodeGen.field(this, 2, ExposedForCodeGen.integer);

  /// TODO: document real
  Expr<double> get real =>
      ExposedForCodeGen.field(this, 3, ExposedForCodeGen.real);
}

extension ExpressionNullableItemExt on Expr<Item?> {
  /// TODO: document id
  Expr<int?> get id =>
      ExposedForCodeGen.field(this, 0, ExposedForCodeGen.integer);

  /// TODO: document text
  Expr<String?> get text =>
      ExposedForCodeGen.field(this, 1, ExposedForCodeGen.text);

  /// TODO: document integer
  Expr<int?> get integer =>
      ExposedForCodeGen.field(this, 2, ExposedForCodeGen.integer);

  /// TODO: document real
  Expr<double?> get real =>
      ExposedForCodeGen.field(this, 3, ExposedForCodeGen.real);
}

extension ItemChecks on Subject<Item> {
  Subject<int> get id => has((m) => m.id, 'id');
  Subject<String> get text => has((m) => m.text, 'text');
  Subject<int> get integer => has((m) => m.integer, 'integer');
  Subject<double> get real => has((m) => m.real, 'real');
}
