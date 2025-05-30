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
import 'dart:typed_data' show Uint8List;

import 'package:collection/collection.dart';

import 'adapter/adapter.dart';
import 'dialect/dialect.dart';
import 'types/json_value.dart' show JsonValue;

part 'typed_sql.annotations.dart';
part 'typed_sql.database.dart';
part 'typed_sql.expr.dart';
part 'typed_sql.expr_ext.dart';
part 'typed_sql.g.dart';
part 'typed_sql.mutation.dart';
part 'typed_sql.query.dart';
part 'typed_sql.query_ext.dart';
part 'typed_sql.statements.dart';

/// Marker class which all schema definitions must extend.
///
/// {@category schema}
/// {@category migrations}
abstract base class Schema {
  Schema() {
    throw UnsupportedError(
      'Schema classes cannot be instantiated, '
      'the Schema type and all subclasses only exists to be used as '
      'type-argument on Database<T>.',
    );
  }
}

/// Marker class which all _row_ classes must extend.
///
/// {@category schema}
abstract base class Row {}

typedef TableDefinition<T extends Row> = ({
  String tableName,
  List<String> columns,
  List<
      ({
        ColumnType type,
        bool isNotNull,
        Object? defaultValue,
        bool autoIncrement,
        List<SqlOverride> overrides,
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
  T? Function(RowReader) readRow,
});

/// Parsed the encoding from table defintion to [Expr].
Expr<Object>? _defaultValueAsExpr(Object? defaultValue) {
  if (defaultValue == null) {
    return null;
  }

  // WARNING:
  // It's important that the Expr<T> objects returned here can be rendered as
  // literals by the dialects. Because it is not possible for dialects to return
  // parameters along with the `CREATE TABLE` statements. This is intentional
  // because parameters don't work well with schema migration tools.

  if (defaultValue case (kind: 'raw', value: final String value)) {
    return toExpr(value);
  }
  if (defaultValue case (kind: 'raw', value: final bool value)) {
    return toExpr(value);
  }
  if (defaultValue case (kind: 'raw', value: final int value)) {
    return toExpr(value);
  }
  if (defaultValue case (kind: 'raw', value: final double value)) {
    return toExpr(value);
  }

  if (defaultValue case (kind: 'datetime', value: 'epoch')) {
    return toExpr(DateTime.fromMillisecondsSinceEpoch(0, isUtc: true));
  }

  if (defaultValue case (kind: 'datetime', value: 'now')) {
    return Expr.currentTimestamp;
  }

  if (defaultValue
      case (
        kind: 'datetime',
        value: (
          final int year,
          final int month,
          final int day,
          final int hour,
          final int minute,
          final int second,
          final int millisecond,
          final int microsecond,
        )
      )) {
    return toExpr(DateTime.utc(
      year,
      month,
      day,
      hour,
      minute,
      second,
      millisecond,
      microsecond,
    ));
  }

  throw AssertionError(
    'Unable to understand generated code from @DefaultValue annotation, '
    'try: `dart run build_runner build` or file a bug',
  );
}

/// Methods exclusively exposed for use by generated code.
///
/// @nodoc
final class $ForGeneratedCode {
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
                          type: t.columnInfo[i].type,
                          isNotNull: t.columnInfo[i].isNotNull,
                          defaultValue:
                              _defaultValueAsExpr(t.columnInfo[i].defaultValue),
                          autoIncrement: t.columnInfo[i].autoIncrement,
                          overrides: t.columnInfo[i].overrides,
                        ))
                    .toList(),
                unique: t.unique,
                foreignKeys: t.foreignKeys,
              ))
          .toList(),
    );
  }

  static Future<void> createTables({
    required Database context,
    required List<TableDefinition> tables,
  }) async {
    final sql = createTableSchema(dialect: context._dialect, tables: tables);
    await context._executor.script(sql);
  }

  /// Create [Table] object.
  ///
  /// @nodoc
  static Table<T> declareTable<T extends Row>(
    Database context,
    TableDefinition<T> table,
  ) =>
      Table._(
        context,
        TableClause._(table),
        table,
      );

  static InsertSingle<T> insertInto<T extends Row>({
    required Table<T> table,
    required List<Expr?> values,
  }) =>
      InsertSingle._(table, values);

  static Update<T> update<T extends Row>(
    Query<(Expr<T>,)> query,
    TableDefinition<T> table,
    UpdateSet<T> Function(Expr<T> row) updateBuilder,
  ) {
    final handle = Object();
    final row = query._expressions.$1._standin(0, handle);

    return Update._(
      query,
      table,
      handle,
      updateBuilder(row),
    );
  }

  static UpdateSingle<T> updateSingle<T extends Row>(
    QuerySingle<(Expr<T>,)> query,
    TableDefinition<T> table,
    UpdateSet<T> Function(Expr<T> row) updateBuilder,
  ) {
    final q = query.asQuery;

    final handle = Object();
    final row = q._expressions.$1._standin(0, handle);

    return UpdateSingle._(Update._(
      q,
      table,
      handle,
      updateBuilder(row),
    ));
  }

  static Delete<T> delete<T extends Row>(
    Query<(Expr<T>,)> query,
    TableDefinition<T> table,
  ) =>
      Delete._(query, table);

  static DeleteSingle<T> deleteSingle<T extends Row>(
    QuerySingle<(Expr<T>,)> query,
    TableDefinition<T> table,
  ) =>
      DeleteSingle._(Delete._(query.asQuery, table));

  static UpdateSet<T> buildUpdate<T extends Row>(List<Expr?> values) =>
      UpdateSet._(values);

  static Expr<T> field<T extends Object?, M extends Row?>(
    Expr<M> row,
    int index,
    FieldType<T> type,
  ) =>
      row._field(index, type);

  static Query<S> renamedRecord<T extends Record, S extends Record>(
    Query<T> query,
    S Function(T) fn,
  ) {
    return Query._(
      query._context,
      fn(query._expressions),
      query._from,
    );
  }

  static SubQuery<(Expr<T>,)> subqueryTable<T extends Row, S extends Row?>(
    TableDefinition<T> table,
  ) {
    return SubQuery._(
      (RowExpression._(0, table, Object()),),
      (_) => TableClause._(table),
    );
  }

  static T? customDataTypeOrNull<S, T extends CustomDataType<S>>(
    S? value,
    T Function(S) fromDatabase,
  ) {
    if (value != null) {
      return fromDatabase(value);
    }
    return null;
  }

  static CustomExprType<S, T> customDataType<S, T extends CustomDataType<S>>(
    ColumnType<S> backingType,
    T Function(S) fromDatabase,
  ) =>
      CustomExprType<S, T>._(backingType, fromDatabase);

  static Expr<T?> literalCustomDataType<S, T extends CustomDataType<S>>(
    T? value,
    CustomExprType<S, T> type,
  ) =>
      Literal<T?>._(value, type);

  static const ColumnType<Uint8List> blob = ColumnType.blob;
  static const ColumnType<bool> boolean = ColumnType.boolean;
  static const ColumnType<DateTime> dateTime = ColumnType.dateTime;
  static const ColumnType<int> integer = ColumnType.integer;
  static const ColumnType<double> real = ColumnType.real;
  static const ColumnType<String> text = ColumnType.text;
  static const ColumnType<Null> nullType = ColumnType.nullType;
  static const ColumnType<JsonValue> jsonValue = ColumnType.jsonValue;
}
