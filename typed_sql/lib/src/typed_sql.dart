// Copyright 2025 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:async';

import 'package:collection/collection.dart';

import 'adaptor/adaptor.dart';
import 'dialect/sql_dialect.dart';

part 'typed_sql.annotations.dart';
part 'typed_sql.database.dart';
part 'typed_sql.expression.dart';
part 'typed_sql.g.dart';
part 'typed_sql.query.dart';
part 'typed_sql.statements.dart';

abstract base class Schema {
  Schema() {
    throw UnsupportedError(
      'Schema classes cannot be instantiated, '
      'the Schema type and all subclasses only exists to be used as '
      'type-argument on Database<T>.',
    );
  }
}

//final class View<T> extends Query<T> {}

/// Class from which all model classes must implement.
abstract base class Model {}

final class Update<T extends Model> {
  final List<Expr?> _values;

  Update._(this._values);
}

typedef TableDefinition<T extends Model> = ({
  String tableName,
  List<String> columns,
  List<
      ({
        Type type,
        bool isNotNull,
        Object? defaultValue,
        bool autoIncrement,
      })> columnInfo,
  List<String> primaryKey,
  List<List<String>> unique,
  List<
      ({
        String name,
        List<String> columns,
        String referencedTable,
        List<String> referencedColumns,
      })> foreignKeys,
  T Function(RowReader) readModel,
});

/// Methods exclusively exposed for use by generated code.
///
/// @nodoc
final class ExposedForCodeGen {
  static String createTableSchema({
    required SqlDialect dialect,
    required List<TableDefinition> tables,
  }) {
    return dialect.createTables(
      tables
          .map((t) => CreateTableStatement._(
                tableName: t.tableName,
                primaryKey: t.primaryKey,
                columns: t.columns
                    .mapIndexed((i, c) => (
                          name: c,
                          type: switch (t.columnInfo[i].type) {
                            const (int) => ColumnType.integer,
                            const (double) => ColumnType.real,
                            const (String) => ColumnType.text,
                            const (bool) => ColumnType.boolean,
                            const (DateTime) => ColumnType.datetime,
                            _ => throw UnsupportedError(
                                'Unsupported type: ${t.columnInfo[i].type}'),
                          },
                          isNotNull: t.columnInfo[i].isNotNull,
                          defaultValue: t.columnInfo[i].defaultValue,
                          autoIncrement: t.columnInfo[i].autoIncrement,
                        ))
                    .toList(),
                unique: t.unique,
                foreignKeys: t.foreignKeys,
              ))
          .toList(),
    );
  }

  static Future<void> createTables({
    required DatabaseContext context,
    required List<TableDefinition> tables,
  }) async {
    final sql = createTableSchema(dialect: context._dialect, tables: tables);
    await context._db.script(sql);
  }

  static Future<void> execute({
    required DatabaseContext context,
    required String sql,
    required List<Object?> params,
  }) async {}

  /// Create [Table] object.
  ///
  /// @nodoc
  static Table<T> declareTable<T extends Model>(
    DatabaseContext context,
    TableDefinition<T> table,
  ) =>
      Table._(
        context,
        TableClause._(table),
        table.readModel,
        table,
      );

  static Future<T> insertInto<T extends Model>({
    required Table<T> table,
    required List<Expr> values,
  }) async {
    final (sql, params) = table._context._dialect.insertInto(InsertStatement._(
      table._tableClause.name,
      table._tableClause.columns,
      values,
      table._tableClause.columns,
    ));
    final returned = await table._context._query(sql, params).first;
    return table._deserialize(returned);
  }

  static Future<void> update<T extends Model>(
    Query<(Expr<T>,)> query,
    TableDefinition<T> table,
    Update<T> Function(Expr<T> row) updateBuilder,
  ) async {
    final handle = Object();
    final row = query._expressions.$1._standin(0, handle);
    final values = updateBuilder(row)._values;

    final (sql, params) = query._context._dialect.update(
      UpdateStatement._(
        TableClause._(table),
        table.columns
            .whereIndexed((index, value) => values[index] != null)
            .toList(),
        values.nonNulls.toList(),
        handle,
        query._from(query._expressions.toList()),
      ),
    );

    await query._context._query(sql, params).drain<void>();
  }

  static Future<int> delete<T extends Model>(
    Query<(Expr<T>,)> query,
    TableDefinition<T> table,
  ) async {
    final from = query._from(query._expressions.toList());
    final (sql, params) = query._context._dialect.delete(
      DeleteStatement._(TableClause._(table), from),
    );

    final rs = await query._context._execute(sql, params);
    return rs.affectedRows;
  }

  // TODO: Design a solution for migrations using atlas creating dialect
  //       specific migraiton files in a folder, such that we just have to
  //       apply the migrations.
  static Future<void> applyMigration(
    DatabaseContext context,
    String migration,
  ) async {
    await context._query(migration, const []).drain<void>();
  }

  static Update<T> buildUpdate<T extends Model>(List<Expr?> values) =>
      Update._(values);

  static Expr<T> field<T extends Object?, M extends Model>(
    Expr<M> row,
    int index,
  ) =>
      row._field(index);

  static Query<S> renamedRecord<T extends Record, S extends Record>(
    Query<T> query,
    S Function(T) fn,
  ) {
    return _Query(
      query._context,
      fn(query._expressions),
      query._from,
    );
  }

  static SubQuery<(Expr<T>,)> subqueryTable<T extends Model, S extends Model>(
    Expr<S> reference, // TODO: Remove reference!
    TableDefinition<T> table,
  ) {
    return SubQuery._(
      (ModelExpression(0, table, Object()),),
      (_) => TableClause._(table),
    );
  }
}
