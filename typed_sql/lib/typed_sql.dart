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

export 'src/adaptor/adaptor.dart' show DatabaseAdaptor, RowReader;
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
        ExpressionResolver,
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
        ModelExpression,
        NotNullExpression,
        OffsetClause,
        OrElseExpression,
        OrderByClause,
        QueryClause,
        ReturningClause,
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
