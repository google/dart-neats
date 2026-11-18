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

import '../ast.query.dart';
import '../sql_task.dart';
import 'postgres_dialect.dart';
import 'sqlite_dialect.dart';

export '../ast.expr.dart'
    show
        AvgExpression,
        BinaryOperationExpression,
        CastExpression,
        CountAllExpression,
        CurrentTimestampExpression,
        EncodedCustomDataTypeExpression,
        ExistsExpression,
        Expr,
        ExpressionBlobConcat,
        ExpressionBlobDecodeUtf8,
        ExpressionBlobLength,
        ExpressionBlobSublist,
        ExpressionBlobToHex,
        ExpressionBoolAnd,
        ExpressionBoolNot,
        ExpressionBoolOr,
        ExpressionEquals,
        ExpressionGreaterThan,
        ExpressionGreaterThanOrEqual,
        ExpressionIsFalse,
        ExpressionIsNotDistinctFrom,
        ExpressionIsTrue,
        ExpressionJsonExtract,
        ExpressionJsonRef,
        ExpressionJsonRefIndex,
        ExpressionJsonRefKey,
        ExpressionJsonRefRoot,
        ExpressionLessThan,
        ExpressionLessThanOrEqual,
        ExpressionNotEquals,
        ExpressionNumAdd,
        ExpressionNumDivide,
        ExpressionNumMultiply,
        ExpressionNumSubtract,
        ExpressionStringContains,
        ExpressionStringEndsWith,
        ExpressionStringIsEmpty,
        ExpressionStringLength,
        ExpressionStringLike,
        ExpressionStringStartsWith,
        ExpressionStringToLowerCase,
        ExpressionStringToUpperCase,
        FieldExpression,
        LiteralExpression,
        MaxExpression,
        MinExpression,
        NotNullExpression,
        OrElseExpression,
        RowExpression,
        SubQueryExpression,
        SumExpression,
        ValueExpression;
export '../ast.expr_types.dart' show ColumnType;
export '../ast.query.dart'
    show
        BulkValuesSource,
        CompositeQueryClause,
        ConflictClause,
        CreateTableStatement,
        DeleteStatement,
        DistinctClause,
        DoNothingOnConflictClause,
        ExceptClause,
        ExprValuesSource,
        ExpressionContext,
        ExpressionResolver,
        FromClause,
        GroupByClause,
        InsertStatement,
        IntersectClause,
        JoinClause,
        LimitClause,
        OffsetClause,
        OrderByClause,
        QueryClause,
        SelectClause,
        SelectFromClause,
        SelectStatement,
        SqlStatement,
        TableClause,
        UnionAllClause,
        UnionClause,
        UpdateOnConflictClause,
        UpdateStatement,
        ValuesSource,
        WhereClause;
export '../sql_task.dart';
export '../typed_sql.dart' show JoinType, Order, Row;
export '../types/custom_data_type.dart' show CustomDataType;
export '../types/json_value.dart' show JsonValue;

/// Interface for implementation of custom SQL dialects for `package:typed_sql`.
///
/// > [!WARNING]
/// > This interface is NOT stable yet, while subclasses of [SqlDialect]
/// > is possible outside `package:typed_sql`, newer versions of this package
/// > may add new methods (remove existing) without a major version bump!
abstract base class SqlDialect {
  /// [SqlDialect] for talking to an SQLite3 database.
  static SqlDialect sqlite() => sqliteDialect();

  /// [SqlDialect] for talking to a PostgreSQL database.
  static SqlDialect postgres() => postgresDialect();

  /// Create an SQL DDL script from [statements] separated by `;`.
  ///
  /// ```sql
  /// CREATE TABLE [table] ([columns])
  /// ```
  ScriptSqlTask createTables(List<CreateTableStatement> statements);

  /// Insert [InsertStatement.values] into [InsertStatement.table] returning
  /// columns from [InsertStatement.returning].
  ///
  /// ```sql
  /// INSERT INTO [table] ([columns]) VALUES ($1, ...)
  /// ```
  SqlTask insertInto(InsertStatement statement);

  /// Update [UpdateStatement.columns] from [UpdateStatement.table] with
  /// [UpdateStatement.values].
  ///
  /// This updates rows satisfying the [UpdateStatement.where] expression.
  SqlTask update(UpdateStatement statement);

  /// Delete from [DeleteStatement.table].
  ///
  /// Delete rows satisfying the [DeleteStatement.where] expression.
  ///
  /// This SQL statement should not return any rows,
  /// all return values are read but ignored.
  SqlTask delete(DeleteStatement statement);

  /// Create select statment from [statement].
  SqlTask select(SelectStatement statement);
}
