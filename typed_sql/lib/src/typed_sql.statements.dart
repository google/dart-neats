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

part of 'typed_sql.dart';

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
      List<SqlOverride> overrides,
    })
  >
  columns;
  final List<List<String>> unique;
  final List<ForeignKeyDefinition> foreignKeys;

  CreateTableStatement._({
    required this.tableName,
    required this.primaryKey,
    required this.columns,
    required this.unique,
    required this.foreignKeys,
  });
}

final class SelectStatement extends SqlStatement {
  final QueryClause query;
  SelectStatement._(this.query);
}

final class InsertStatement extends SqlStatement {
  final String table;
  final ValuesSource values;
  final ConflictClause? onConflict;
  final ReturningClause? returning;

  InsertStatement._(
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

  ExprValuesSource._(this.columns, this.values);
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

  BulkValuesSource._(this.columns, this.types, this.columnValues);
}

sealed class ConflictClause {
  final List<String> conflictTarget;

  ConflictClause._(this.conflictTarget);
}

final class DoNothingOnConflictClause extends ConflictClause {
  DoNothingOnConflictClause._(super.conflictTarget) : super._();
}

final class UpdateOnConflictClause extends ConflictClause
    implements ExpressionContext {
  @override
  final Object _handle;

  final TableClause table;
  final ExpressionContext excluded;
  final List<String> columns;
  final List<Expr> values;
  final Expr<bool> where;

  UpdateOnConflictClause._(
    this._handle,
    super.conflictTarget,
    this.table,
    this.excluded,
    this.columns,
    this.values,
    this.where,
  ) : super._();
}

final class ReturningClause implements ExpressionContext {
  @override
  final Object _handle;
  final List<String> columns;
  final List<Expr> _projection;

  Iterable<Expr> get projection => _projection.expand((e) => e._explode());

  ReturningClause._(this._handle, this.columns, this._projection);
}

final class UpdateStatement extends SqlStatement implements ExpressionContext {
  @override
  final Object _handle;
  final TableClause table;
  final List<String> columns;
  final List<Expr> values;
  final QueryClause where;
  final ReturningClause? returning;

  UpdateStatement._(
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

  DeleteStatement._(this.table, this.where, this.returning);
}
