// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_key_test.dart';

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
    this.key,
    this.value,
  );

  @override
  final String key;

  @override
  final String value;

  static const _$table = (
    tableName: 'items',
    columns: <String>['key', 'value'],
    columnInfo: <({
      ColumnType type,
      bool isNotNull,
      Object? defaultValue,
      bool autoIncrement,
    })>[
      (
        type: ExposedForCodeGen.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
      ),
      (
        type: ExposedForCodeGen.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
      )
    ],
    primaryKey: <String>['key'],
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
    final key = row.readString();
    final value = row.readString();
    if (key == null && value == null) {
      return null;
    }
    return _$Item._(key!, value!);
  }

  @override
  String toString() => 'Item(key: "$key", value: "$value")';
}

extension TableItemExt on Table<Item> {
  /// TODO: document insertLiteral (this cannot explicitly insert NULL for nullable fields with a default value)
  InsertSingle<Item> insertLiteral({
    required String key,
    required String value,
  }) =>
      ExposedForCodeGen.insertInto(
        table: this,
        values: [
          literal(key),
          literal(value),
        ],
      );

  /// TODO: document insert
  InsertSingle<Item> insert({
    required Expr<String> key,
    required Expr<String> value,
  }) =>
      ExposedForCodeGen.insertInto(
        table: this,
        values: [
          key,
          value,
        ],
      );

  /// TODO: document delete
  DeleteSingle<Item> delete({required String key}) =>
      ExposedForCodeGen.deleteSingle(
        byKey(key: key),
        _$Item._$table,
      );
}

extension QueryItemExt on Query<(Expr<Item>,)> {
  /// TODO: document lookup by PrimaryKey
  QuerySingle<(Expr<Item>,)> byKey({required String key}) =>
      where((item) => item.key.equalsLiteral(key)).first;

  /// TODO: document updateAll()
  Update<Item> updateAll(
          UpdateSet<Item> Function(
            Expr<Item> item,
            UpdateSet<Item> Function({
              Expr<String> key,
              Expr<String> value,
            }) set,
          ) updateBuilder) =>
      ExposedForCodeGen.update<Item>(
        this,
        _$Item._$table,
        (item) => updateBuilder(
          item,
          ({
            Expr<String>? key,
            Expr<String>? value,
          }) =>
              ExposedForCodeGen.buildUpdate<Item>([
            key,
            value,
          ]),
        ),
      );

  /// TODO: document updateAllLiteral()
  /// WARNING: This cannot set properties to `null`!
  Update<Item> updateAllLiteral({
    String? key,
    String? value,
  }) =>
      ExposedForCodeGen.update<Item>(
        this,
        _$Item._$table,
        (item) => ExposedForCodeGen.buildUpdate<Item>([
          key != null ? literal(key) : null,
          value != null ? literal(value) : null,
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
              Expr<String> key,
              Expr<String> value,
            }) set,
          ) updateBuilder) =>
      ExposedForCodeGen.updateSingle<Item>(
        this,
        _$Item._$table,
        (item) => updateBuilder(
          item,
          ({
            Expr<String>? key,
            Expr<String>? value,
          }) =>
              ExposedForCodeGen.buildUpdate<Item>([
            key,
            value,
          ]),
        ),
      );

  /// TODO: document updateLiteral()
  /// WARNING: This cannot set properties to `null`!
  UpdateSingle<Item> updateLiteral({
    String? key,
    String? value,
  }) =>
      ExposedForCodeGen.updateSingle<Item>(
        this,
        _$Item._$table,
        (item) => ExposedForCodeGen.buildUpdate<Item>([
          key != null ? literal(key) : null,
          value != null ? literal(value) : null,
        ]),
      );

  /// TODO: document delete()
  DeleteSingle<Item> delete() =>
      ExposedForCodeGen.deleteSingle(this, _$Item._$table);
}

extension ExpressionItemExt on Expr<Item> {
  /// TODO: document key
  Expr<String> get key =>
      ExposedForCodeGen.field(this, 0, ExposedForCodeGen.text);

  /// TODO: document value
  Expr<String> get value =>
      ExposedForCodeGen.field(this, 1, ExposedForCodeGen.text);
}

extension ExpressionNullableItemExt on Expr<Item?> {
  /// TODO: document key
  Expr<String?> get key =>
      ExposedForCodeGen.field(this, 0, ExposedForCodeGen.text);

  /// TODO: document value
  Expr<String?> get value =>
      ExposedForCodeGen.field(this, 1, ExposedForCodeGen.text);
}

extension ItemChecks on Subject<Item> {
  Subject<String> get key => has((m) => m.key, 'key');
  Subject<String> get value => has((m) => m.value, 'value');
}
