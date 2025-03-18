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
        Aggregation,
        AvgExpression,
        BinaryOperationExpression,
        CastExpression,
        ColumnType,
        CompositeQueryClause,
        CountAllExpression,
        CreateTableStatement,
        CustomDataType,
        DeleteStatement,
        DistinctClause,
        ExceptClause,
        ExistsExpression,
        Expr,
        ExpressionBoolAnd,
        ExpressionBoolNot,
        ExpressionBoolOr,
        ExpressionContext,
        ExpressionDateTimeEquals,
        ExpressionDateTimeGreaterThan,
        ExpressionDateTimeGreaterThanOrEqual,
        ExpressionDateTimeLessThan,
        ExpressionDateTimeLessThanOrEqual,
        ExpressionNumAdd,
        ExpressionNumDivide,
        ExpressionNumEquals,
        ExpressionNumGreaterThan,
        ExpressionNumGreaterThanOrEqual,
        ExpressionNumLessThan,
        ExpressionNumLessThanOrEqual,
        ExpressionNumMultiply,
        ExpressionNumSubtract,
        ExpressionStringContains,
        ExpressionStringEndsWith,
        ExpressionStringEquals,
        ExpressionStringGreaterThan,
        ExpressionStringGreaterThanOrEqual,
        ExpressionStringIsEmpty,
        ExpressionStringLength,
        ExpressionStringLessThan,
        ExpressionStringLessThanOrEqual,
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
        LimitClause,
        Literal,
        MaxExpression,
        MinExpression,
        Model,
        ModelExpression,
        NullAssertionExpression,
        OffsetClause,
        OrElseExpression,
        OrderByClause,
        QueryClause,
        QueryContext,
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

abstract base class SqlDialect {
  static SqlDialect sqlite() => sqliteDialect();
  static SqlDialect postgres() => postgresDialect();

  String createTables(List<CreateTableStatement> statement);

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

  // TODO: Document rendering method!
  (String sql, List<String> columns, List<Object?> params) select(
    SelectStatement statement,
  );
}

// NOTE: All Expression subclasses are sealed, so we can do exhaustive switching
//       over them.
