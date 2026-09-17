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

part of 'ast.query.dart';

sealed class SqlStatement {}

final class CreateTableStatement extends SqlStatement {
  final String tableName;
  final List<String> primaryKey;
  final List<
    ({
      String name,
      ColumnType type,
      bool isNotNull,
      Expr<Object>? defaultValue,
      bool autoIncrement,
      List<
        ({
          String? dialect,
          String? columnType,
          String? defaultValue,
          String? collation,
        })
      >
      overrides,
    })
  >
  columns;
  final List<List<String>> unique;
  final List<ForeignKeyDefinition> foreignKeys;
  final List<IndexDefinition> indexes;

  CreateTableStatement.internal({
    required this.tableName,
    required this.primaryKey,
    required this.columns,
    required this.unique,
    required this.foreignKeys,
    required this.indexes,
  });
}

final class SelectStatement extends SqlStatement {
  final QueryClause query;
  SelectStatement.internal(this.query);
}

final class InsertStatement extends SqlStatement {
  final String table;
  final ValuesSource values;
  final ConflictClause? onConflict;
  final ReturningClause? returning;

  InsertStatement.internal(
    this.table,
    this.values,
    this.onConflict,
    this.returning,
  );
}

/// Source of values in an [InsertStatement].
sealed class ValuesSource {
  List<String> get columns;
}

/// Source of values for an [InsertStatement] that inserts a single row from
/// [Expr] objects.
final class ExprValuesSource extends ValuesSource {
  @override
  final List<String> columns;
  final List<Expr> values;

  ExprValuesSource.internal(this.columns, this.values);
}

/// Source of values for an [InsertStatement] that inserts multiple rows from
/// a list of values for each column.
final class BulkValuesSource extends ValuesSource {
  @override
  final List<String> columns;
  final List<ColumnType> types;

  /// A list with values for each column.
  ///
  /// The `j` row for `columns[i]` has the value `columnValues[i][j]`.
  final List<Iterable<Object?>> columnValues;

  BulkValuesSource.internal(this.columns, this.types, this.columnValues);
}

sealed class ConflictClause {
  final List<String> conflictTarget;

  ConflictClause.internal(this.conflictTarget);
}

final class DoNothingOnConflictClause extends ConflictClause {
  DoNothingOnConflictClause.internal(super.conflictTarget) : super.internal();
}

final class UpdateOnConflictClause extends ConflictClause
    implements ExpressionContext {
  @override
  final Object _handle;

  final TableClause table;
  final ExpressionContext excluded;
  final List<String> columns;
  final List<Expr> values;
  final Expr<bool?> where;

  UpdateOnConflictClause.internal(
    this._handle,
    super.conflictTarget,
    this.table,
    this.excluded,
    this.columns,
    this.values,
    this.where,
  ) : super.internal();
}

final class ReturningClause implements ExpressionContext {
  @override
  final Object _handle;
  final List<String> columns;
  final List<Expr> _projection;

  Iterable<Expr> get projection => _projection.expand((e) => e.$explode());

  ReturningClause.internal(this._handle, this.columns, this._projection);
}

final class UpdateStatement extends SqlStatement implements ExpressionContext {
  @override
  final Object _handle;
  final TableClause table;
  final List<String> columns;
  final List<Expr> values;
  final QueryClause where;
  final ReturningClause? returning;

  UpdateStatement.internal(
    this.table,
    this.columns,
    this.values,
    this._handle,
    this.where,
    this.returning,
  );
}

final class DeleteStatement extends SqlStatement {
  final TableClause table;
  final QueryClause where;
  final ReturningClause? returning;

  DeleteStatement.internal(this.table, this.where, this.returning);
}
