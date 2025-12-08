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

/// API for defining database schema and writing queries against generated code.
///
/// This library should be imported in the `model.dart` file where you define
/// you database schema, which is then augmented with generated code in a
/// `model.g.dart` file. For convenience, you may also wish to export this
/// library from your `model.dart` file.
///
/// See topic on _schema defintion_ for how to get started.
library;

export 'src/adapter/adapter.dart' show DatabaseAdapter, RowReader;
export 'src/dialect/dialect.dart' show SqlDialect;
export 'src/exceptions.dart' hide throwTransactionAbortedException;
export 'src/typed_sql.dart'
    hide
        AvgExpression,
        BinaryOperationExpression,
        CastExpression,
        CompositeQueryClause,
        CountAllExpression,
        CreateTableStatement,
        CustomExprType,
        DeleteStatement,
        DistinctClause,
        EncodedCustomDataTypeExpression,
        ExceptClause,
        ExistsExpression,
        ExpressionBoolAnd,
        ExpressionBoolNot,
        ExpressionBoolOr,
        ExpressionContext,
        ExpressionEquals,
        ExpressionGreaterThan,
        ExpressionGreaterThanOrEqual,
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
        FieldType,
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
        OrderByClause,
        QueryClause,
        ReturningClause,
        RowExpression,
        SelectClause,
        SelectFromClause,
        SelectStatement,
        SingleValueExpr,
        SqlStatement,
        SubQueryExpression,
        SumExpression,
        TableClause,
        TableDefinition,
        UnionAllClause,
        UnionClause,
        UpdateStatement,
        WhereClause;
export 'src/types/custom_data_type.dart' show CustomDataType;
export 'src/types/json_value.dart' show JsonValue;
