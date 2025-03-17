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

sealed class Statement {}

final class CreateTableStatement extends Statement {
  final String tableName;
  final List<String> primaryKey;
  final List<
      ({
        String name,
        ColumnType type,
        bool isNotNull,
        Object? defaultValue,
        bool autoIncrement,
      })> columns;
  final List<List<String>> unique;
  final List<
      ({
        List<String> columns,
        String referencedTable,
        List<String> referencedColumns,
        String name,
      })> foreignKeys;

  CreateTableStatement._({
    required this.tableName,
    required this.primaryKey,
    required this.columns,
    required this.unique,
    required this.foreignKeys,
  });
}

final class SelectStatement extends Statement {
  final QueryClause query;
  SelectStatement._(this.query);
}

final class InsertStatement extends Statement {
  final String table;
  final List<String> columns;
  final List<Expr> values;
  final List<String> returning;

  InsertStatement._(this.table, this.columns, this.values, this.returning);
}

final class UpdateStatement extends Statement implements ExpressionContext {
  @override
  final Object _handle;
  final TableClause table;
  final List<String> columns;
  final List<Expr> values;
  final QueryClause where;

  UpdateStatement._(
    this.table,
    this.columns,
    this.values,
    this._handle,
    this.where,
  );
}

final class DeleteStatement extends Statement {
  final TableClause table;
  final QueryClause where;

  DeleteStatement._(this.table, this.where);
}
