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

import '../typed_sql.dart';
import 'postgres_dialect.dart';
import 'sqlite_dialect.dart';

export '../typed_sql.dart'
    show
        AvgExpression,
        BinaryOperationExpression,
        CastExpression,
        ColumnType,
        CompositeQueryClause,
        CountAllExpression,
        CreateTableStatement,
        CurrentTimestampExpression,
        DeleteStatement,
        DistinctClause,
        EncodedCustomDataTypeExpression,
        ExceptClause,
        ExistsExpression,
        Expr,
        ExpressionBoolAnd,
        ExpressionBoolNot,
        ExpressionBoolOr,
        ExpressionContext,
        ExpressionEquals,
        ExpressionGreaterThan,
        ExpressionGreaterThanOrEqual,
        ExpressionIsNotDistinctFrom,
        ExpressionLessThan,
        ExpressionLessThanOrEqual,
        ExpressionNumAdd,
        ExpressionNumDivide,
        ExpressionNumMultiply,
        ExpressionNumSubtract,
        ExpressionResolver,
        ExpressionStringContains,
        ExpressionStringEndsWith,
        ExpressionStringIsEmpty,
        ExpressionStringLength,
        ExpressionStringLike,
        ExpressionStringStartsWith,
        ExpressionStringToLowerCase,
        ExpressionStringToUpperCase,
        FieldExpression,
        FromClause,
        GroupByClause,
        InsertStatement,
        IntersectClause,
        JoinClause,
        JoinType,
        LimitClause,
        Literal,
        MaxExpression,
        MinExpression,
        NotNullExpression,
        OffsetClause,
        OrElseExpression,
        Order,
        OrderByClause,
        QueryClause,
        Row,
        RowExpression,
        SelectClause,
        SelectFromClause,
        SelectStatement,
        SqlStatement,
        SubQueryExpression,
        SumExpression,
        TableClause,
        UnionAllClause,
        UnionClause,
        UpdateStatement,
        WhereClause;
export '../types/custom_data_types.dart' show CustomDataType;
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
  String createTables(List<CreateTableStatement> statements);

  /// Insert [InsertStatement.columns] into [InsertStatement.table] returning
  /// columns from [InsertStatement.returning].
  ///
  /// ```sql
  /// INSERT INTO [table] ([columns]) VALUES ($1, ...)
  /// ```
  (String, List<Object?>) insertInto(InsertStatement statement);

  /// Update [UpdateStatement.columns] from [UpdateStatement.table] with
  /// [UpdateStatement.values].
  ///
  /// This updates rows satisfying the [UpdateStatement.where] expression.
  (String, List<Object?>) update(UpdateStatement statement);

  /// Delete from [DeleteStatement.table].
  ///
  /// Delete rows satisfying the [DeleteStatement.where] expression.
  ///
  /// This SQL statement should not return any rows,
  /// all return values are read but ignored.
  (String, List<Object?>) delete(DeleteStatement statement);

  /// Create select statment from [statement].
  (String sql, List<Object?> params) select(
    SelectStatement statement,
  );
}
