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

/// Extension methods for queries projected to a single expression.
extension QuerySingle1AsExpr<T> on QuerySingle<(Expr<T>,)> {
  /// Use this [QuerySingle] as subquery expression.
  ///
  /// This is equivalent to `(SELECT * FROM this LIMIT 1)` in SQL.
  Expr<T?> get asExpr => SubQueryExpression._(
        _query._from(_query._expressions.toList()),
        _query._expressions.$1,
      );
}

/// {@template SubQuery1Ext}
/// Extension methods for subqueries projected to a single expression.
/// {@endtemplate}
extension SubQuery1Ext<T> on SubQuery<(Expr<T>,)> {
  /// {@template first-subquery}
  /// Use the first row of this query as subquery expression.
  ///
  /// This is equivalent to `(SELECT * FROM this LIMIT 1)` in SQL.
  /// {@endtemplate}
  Expr<T?> get first => SubQueryExpression._(
        LimitClause._(_from(_expressions.toList()), 1),
        _expressions.$1,
      );
}

/// {@macro SubQuery1Ext}
extension OrderedSubQuery1Ext<T> on OrderedSubQuery<(Expr<T>,)> {
  /// {@macro first-subquery}
  Expr<T?> get first => _query.first;
}

/// {@macro SubQuery1Ext}
extension OrderedSubQueryRange1Ext<T> on OrderedSubQueryRange<(Expr<T>,)> {
  /// {@macro first-subquery}
  Expr<T?> get first => _query.first;
}

/// {@macro SubQuery1Ext}
extension ProjectedOrderedSubQuery1Ext<T>
    on ProjectedOrderedSubQuery<(Expr<T>,)> {
  /// {@macro first-subquery}
  Expr<T?> get first => _query.first;
}

/// {@macro SubQuery1Ext}
extension ProjectedOrderedSubQueryRange1Ext<T>
    on ProjectedOrderedSubQueryRange<(Expr<T>,)> {
  /// {@macro first-subquery}
  Expr<T?> get first => _query.first;
}

/// Extension methods for queries projected to an [int] expression.
extension QueryInteger on Query<(Expr<int?>,)> {
  /// {@template sum-query}
  /// Take the sum of the rows in this query using the `SUM`
  /// _aggregate function_.
  ///
  /// This is equivalent to `SELECT SUM(column1) FROM this,` in SQL.
  ///
  /// > [!NOTE]
  /// > Unlike the `SUM` _aggregate function_ in SQL, this method will return
  /// > zero, if there are no rows, or all if all rows are `NULL`.
  /// > Where as `SUM` in SQL would return `NULL`.
  /// {@endtemplate}
  QuerySingle<(Expr<int>,)> sum() => select((a) => (SumExpression._(a),)).first;

  /// {@template avg-query}
  /// Take the average of the rows in this query using the `AVG`
  /// _aggregate function_.
  ///
  /// This is equivalent to `SELECT AVG(column1) FROM this` in SQL.
  ///
  /// > [!NOTE]
  /// > Like the `AVG` _aggregate function_ in SQL, this method will return
  /// > `NULL` if there are no rows, or if all rows are `NULL`.
  /// > Similarly, `NULL` rows will not figure in the average value.
  /// {@endtemplate}
  QuerySingle<(Expr<double?>,)> avg() =>
      select((a) => (AvgExpression._(a),)).first;

  /// {@template min-query}
  /// Take the smallest row of the rows in this query using the `MIN`
  /// _aggregate function_.
  ///
  /// This is equivalent to `SELECT MIN(column1) FROM this` in SQL.
  ///
  /// > [!NOTE]
  /// > Like the `MIN` _aggregate function_ in SQL, this method will return
  /// > `NULL` if there are no rows or if all rows are `NULL`.
  /// {@endtemplate}
  QuerySingle<(Expr<int?>,)> min() =>
      select((a) => (MinExpression._(a),)).first;

  /// {@template max-query}
  /// Take the largest row of the rows in this query using the `MAX`
  /// _aggregate function_.
  ///
  /// This is equivalent to `SELECT MAX(column1) FROM this` in SQL.
  ///
  /// > [!NOTE]
  /// > Like the `MAX` _aggregate function_ in SQL, this method will return
  /// > `NULL` if there are no rows or if all rows are `NULL`.
  /// {@endtemplate}
  QuerySingle<(Expr<int?>,)> max() =>
      select((a) => (MaxExpression._(a),)).first;
}

/// Extension methods for queries projected to a [double] expression.
extension QueryReal on Query<(Expr<double?>,)> {
  /// {@macro sum-query}
  QuerySingle<(Expr<double>,)> sum() =>
      select((a) => (SumExpression._(a),)).first;

  /// {@macro avg-query}
  QuerySingle<(Expr<double?>,)> avg() =>
      select((a) => (AvgExpression._(a),)).first;

  /// {@macro min-query}
  QuerySingle<(Expr<double?>,)> min() =>
      select((a) => (MinExpression._(a),)).first;

  /// {@macro max-query}
  QuerySingle<(Expr<double?>,)> max() =>
      select((a) => (MaxExpression._(a),)).first;
}

/// Extension methods for queries projected to a [DateTime] expression.
extension QueryDateTime on Query<(Expr<DateTime?>,)> {
  /// {@macro min-query}
  QuerySingle<(Expr<DateTime?>,)> min() =>
      select((a) => (MinExpression._(a),)).first;

  /// {@macro max-query}
  QuerySingle<(Expr<DateTime?>,)> max() =>
      select((a) => (MaxExpression._(a),)).first;
}

/// Extension methods for queries projected to a [String] expression.
extension QueryString on Query<(Expr<String?>,)> {
  /// {@macro min-query}
  QuerySingle<(Expr<String?>,)> min() =>
      select((a) => (MinExpression._(a),)).first;

  /// {@macro max-query}
  QuerySingle<(Expr<String?>,)> max() =>
      select((a) => (MaxExpression._(a),)).first;
}

/// Extension methods for subqueries projected to an [int] expression.
extension SubQueryInteger on SubQuery<(Expr<int?>,)> {
  /// {@macro sum-query}
  Expr<int> sum() => select((a) => (SumExpression._(a),)).first.asNotNull();

  /// {@macro avg-query}
  Expr<double?> avg() => select((a) => (AvgExpression._(a),)).first;

  /// {@macro min-query}
  Expr<int?> min() => select((a) => (MinExpression._(a),)).first;

  /// {@macro max-query}
  Expr<int?> max() => select((a) => (MaxExpression._(a),)).first;
}

/// Extension methods for subqueries projected to a [double] expression.
extension SubQueryReal on SubQuery<(Expr<double?>,)> {
  /// {@macro sum-query}
  Expr<double> sum() => select((a) => (SumExpression._(a),)).first.asNotNull();

  /// {@macro avg-query}
  Expr<double?> avg() => select((a) => (AvgExpression._(a),)).first;

  /// {@macro min-query}
  Expr<double?> min() => select((a) => (MinExpression._(a),)).first;

  /// {@macro max-query}
  Expr<double?> max() => select((a) => (MaxExpression._(a),)).first;
}

/// Extension methods for subqueries projected to a [DateTime] expression.
extension SubQueryDateTime on SubQuery<(Expr<DateTime?>,)> {
  /// {@macro min-query}
  Expr<DateTime?> min() => select((a) => (MinExpression._(a),)).first;

  /// {@macro max-query}
  Expr<DateTime?> max() => select((a) => (MaxExpression._(a),)).first;
}

/// Extension methods for subqueries projected to a [String] expression.
extension SubQueryString on SubQuery<(Expr<String?>,)> {
  /// {@macro min-query}
  Expr<String?> min() => select((a) => (MinExpression._(a),)).first;

  /// {@macro max-query}
  Expr<String?> max() => select((a) => (MaxExpression._(a),)).first;
}

/// Extension methods for all queries.
extension QueryExt<T extends Record> on Query<T> {
  /// {@template distinct-query}
  /// Create a query with distinct rows from this query using the `DISTINCT`
  /// _keyword_.
  ///
  /// This is equivalent to `SELECT DISTINCT * FROM this` in SQL.
  /// {@endtemplate}
  Query<T> distinct() =>
      Query._(_context, _expressions, (e) => DistinctClause._(_from(e)));

  /// Use this [Query] as a [SubQuery].
  ///
  /// > [!TIP]
  /// > When using a [Query] to create subquery expressions it can be preferable
  /// > to convert it to a [SubQuery], as methods like `.first`, `.sum`, `.avg`,
  /// > `.min`, `.max`, `.exists` and `.count` on a [SubQuery] returns [Expr]
  /// > instead of [QuerySingle].
  SubQuery<T> get asSubQuery => SubQuery._(_expressions, _from);
}

/// {@template OrderedQueryExt}
/// Extension methods for all _ordered queries_.
/// {@endtemplate}
extension OrderedQueryExt<T extends Record> on OrderedQuery<T> {
  /// {@macro distinct-query}
  ProjectedOrderedQuery<T> distinct() =>
      ProjectedOrderedQuery._(asQuery.distinct());

  /// {@template OrderedQuery.asQuery}
  /// Wrap this as **unordered** [Query].
  ///
  /// This will allow you to use this query in places where the ordering cannot
  /// not be preserved in the result. This can necessary as SQL disregards
  /// ordering from subqueries (after imposing `LIMIT` and `OFFSET`, if present).
  ///
  /// > [!WARNING]
  /// > This will discard the ordering imposed by `.orderBy`.
  /// {@endtemplate}
  Query<T> get asQuery => _query;
}

/// {@macro OrderedQueryExt}
extension OrderedQueryRangeExt<T extends Record> on OrderedQueryRange<T> {
  /// {@macro OrderedQuery.asQuery}
  Query<T> get asQuery => _query;
}

/// {@macro OrderedQueryExt}
extension ProjectedOrderedQueryExt<T extends Record>
    on ProjectedOrderedQuery<T> {
  /// {@macro distinct-query}
  ProjectedOrderedQuery<T> distinct() =>
      ProjectedOrderedQuery._(asQuery.distinct());

  /// {@macro OrderedQuery.asQuery}
  Query<T> get asQuery => _query;
}

/// {@macro OrderedQueryExt}
extension ProjectedOrderedQueryRangeExt<T extends Record>
    on ProjectedOrderedQueryRange<T> {
  /// {@macro OrderedQuery.asQuery}
  Query<T> get asQuery => _query;
}

/// Extension methods for all subqueries.
extension QuerySubExt<T extends Record> on SubQuery<T> {
  /// {@macro distinct-query}
  SubQuery<T> distinct() =>
      SubQuery._(_expressions, (e) => DistinctClause._(_from(e)));
}

/// {@template OrderedSubQueryExt}
/// Extension methods for all _ordered_ subqueries.
/// {@endtemplate}
extension OrderedSubQueryExt<T extends Record> on OrderedSubQuery<T> {
  /// {@macro distinct-query}
  ProjectedOrderedSubQuery<T> distinct() =>
      ProjectedOrderedSubQuery._(_query.distinct());

  /// {@template OrderedSubQuery.asSubQuery}
  /// Wrap this as **unordered** [SubQuery].
  ///
  /// This will allow you to use this query in places where the ordering cannot
  /// not be preserved in the result. This can necessary as SQL disregards
  /// ordering from subqueries (after imposing `LIMIT` and `OFFSET`, if present).
  ///
  /// > [!WARNING]
  /// > This will discard the ordering imposed by `.orderBy`.
  /// {@endtemplate}
  SubQuery<T> get asSubQuery => _query;
}

/// {@macro OrderedSubQueryExt}
extension OrderedSubQueryRangeExt<T extends Record> on OrderedSubQueryRange<T> {
  /// {@macro OrderedSubQuery.asSubQuery}
  SubQuery<T> get asSubQuery => _query;
}

/// {@macro OrderedSubQueryExt}
extension ProjectedOrderedSubQueryExt<T extends Record>
    on ProjectedOrderedSubQuery<T> {
  /// {@macro distinct-query}
  ProjectedOrderedSubQuery<T> distinct() =>
      ProjectedOrderedSubQuery._(_query.distinct());

  /// {@macro OrderedSubQuery.asSubQuery}
  SubQuery<T> get asSubQuery => _query;
}

/// {@macro OrderedSubQueryExt}
extension ProjectedOrderedSubQueryRangeExt<T extends Record>
    on ProjectedOrderedSubQueryRange<T> {
  /// {@macro OrderedSubQuery.asSubQuery}
  SubQuery<T> get asSubQuery => _query;
}
