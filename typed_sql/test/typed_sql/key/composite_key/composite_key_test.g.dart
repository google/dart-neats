// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'composite_key_test.dart';

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
    this.name,
  );

  @override
  final int id;

  @override
  final String name;

  static const _$table = (
    tableName: 'items',
    columns: <String>['id', 'name'],
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
        autoIncrement: false,
      ),
      (
        type: ExposedForCodeGen.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
      )
    ],
    primaryKey: <String>['id', 'name'],
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
    final name = row.readString();
    if (id == null && name == null) {
      return null;
    }
    return _$Item._(id!, name!);
  }

  @override
  String toString() => 'Item(id: "$id", name: "$name")';
}

extension TableItemExt on Table<Item> {
  /// TODO: document insertLiteral (this cannot explicitly insert NULL for nullable fields with a default value)
  Future<Item> insertLiteral({
    required int id,
    required String name,
  }) =>
      ExposedForCodeGen.insertInto(
        table: this,
        values: [
          literal(id),
          literal(name),
        ],
      );

  /// TODO: document insert
  Future<Item> insert({
    required Expr<int> id,
    required Expr<String> name,
  }) =>
      ExposedForCodeGen.insertInto(
        table: this,
        values: [
          id,
          name,
        ],
      );

  /// TODO: document delete
  Future<void> delete({
    required int id,
    required String name,
  }) =>
      byKey(
        id: id,
        name: name,
      ).delete();
}

extension QueryItemExt on Query<(Expr<Item>,)> {
  /// TODO: document lookup by PrimaryKey
  QuerySingle<(Expr<Item>,)> byKey({
    required int id,
    required String name,
  }) =>
      where((item) =>
          item.id.equalsLiteral(id).and(item.name.equalsLiteral(name))).first;

  /// TODO: document updateAll()
  Future<void> updateAll(
          Update<Item> Function(
            Expr<Item> item,
            Update<Item> Function({
              Expr<int> id,
              Expr<String> name,
            }) set,
          ) updateBuilder) =>
      ExposedForCodeGen.update<Item>(
        this,
        _$Item._$table,
        (item) => updateBuilder(
          item,
          ({
            Expr<int>? id,
            Expr<String>? name,
          }) =>
              ExposedForCodeGen.buildUpdate<Item>([
            id,
            name,
          ]),
        ),
      );

  /// TODO: document updateAllLiteral()
  /// WARNING: This cannot set properties to `null`!
  Future<void> updateAllLiteral({
    int? id,
    String? name,
  }) =>
      ExposedForCodeGen.update<Item>(
        this,
        _$Item._$table,
        (item) => ExposedForCodeGen.buildUpdate<Item>([
          id != null ? literal(id) : null,
          name != null ? literal(name) : null,
        ]),
      );

  /// TODO: document delete()}
  Future<int> delete() => ExposedForCodeGen.delete(this, _$Item._$table);
}

extension QuerySingleItemExt on QuerySingle<(Expr<Item>,)> {
  /// TODO: document update()
  Future<void> update(
          Update<Item> Function(
            Expr<Item> item,
            Update<Item> Function({
              Expr<int> id,
              Expr<String> name,
            }) set,
          ) updateBuilder) =>
      ExposedForCodeGen.update<Item>(
        asQuery,
        _$Item._$table,
        (item) => updateBuilder(
          item,
          ({
            Expr<int>? id,
            Expr<String>? name,
          }) =>
              ExposedForCodeGen.buildUpdate<Item>([
            id,
            name,
          ]),
        ),
      );

  /// TODO: document updateLiteral()
  /// WARNING: This cannot set properties to `null`!
  Future<void> updateLiteral({
    int? id,
    String? name,
  }) =>
      ExposedForCodeGen.update<Item>(
        asQuery,
        _$Item._$table,
        (item) => ExposedForCodeGen.buildUpdate<Item>([
          id != null ? literal(id) : null,
          name != null ? literal(name) : null,
        ]),
      );

  /// TODO: document delete()
  Future<int> delete() => asQuery.delete();
}

extension ExpressionItemExt on Expr<Item> {
  /// TODO: document id
  Expr<int> get id =>
      ExposedForCodeGen.field(this, 0, ExposedForCodeGen.integer);

  /// TODO: document name
  Expr<String> get name =>
      ExposedForCodeGen.field(this, 1, ExposedForCodeGen.text);
}

extension ItemChecks on Subject<Item> {
  Subject<int> get id => has((m) => m.id, 'id');
  Subject<String> get name => has((m) => m.name, 'name');
}
