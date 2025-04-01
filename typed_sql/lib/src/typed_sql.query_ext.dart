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

extension QuerySingle1AsExpr<T> on QuerySingle<(Expr<T>,)> {
  /// Use this [QuerySingle] as subquery expression.
  ///
  /// This is equivalent to `(SELECT * FROM this LIMIT 1)` in SQL.
  Expr<T?> get asExpr => SubQueryExpression._(
        _query._from(_query._expressions.toList()),
        _query._expressions.$1,
      );
}

extension SubQuery1First<T> on SubQuery<(Expr<T>,)> {
  /// Use the first row of this [SubQuery] as subquery expression.
  ///
  /// This is equivalent to `(SELECT * FROM this LIMIT 1)` in SQL.
  Expr<T?> get first => SubQueryExpression._(
        LimitClause._(_from(_expressions.toList()), 1),
        _expressions.$1,
      );
}

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

extension QueryDateTime on Query<(Expr<DateTime?>,)> {
  /// {@macro min-query}
  QuerySingle<(Expr<DateTime?>,)> min() =>
      select((a) => (MinExpression._(a),)).first;

  /// {@macro max-query}
  QuerySingle<(Expr<DateTime?>,)> max() =>
      select((a) => (MaxExpression._(a),)).first;
}

extension QueryString on Query<(Expr<String?>,)> {
  /// {@macro min-query}
  QuerySingle<(Expr<String?>,)> min() =>
      select((a) => (MinExpression._(a),)).first;

  /// {@macro max-query}
  QuerySingle<(Expr<String?>,)> max() =>
      select((a) => (MaxExpression._(a),)).first;
}

extension SubQueryInteger on SubQuery<(Expr<int?>,)> {
  /// {@macro sum-query}
  Expr<int> sum() => select((a) => (SumExpression._(a),)).first.assertNotNull();

  /// {@macro avg-query}
  Expr<double?> avg() => select((a) => (AvgExpression._(a),)).first;

  /// {@macro min-query}
  Expr<int?> min() => select((a) => (MinExpression._(a),)).first;

  /// {@macro max-query}
  Expr<int?> max() => select((a) => (MaxExpression._(a),)).first;
}

extension SubQueryReal on SubQuery<(Expr<double?>,)> {
  /// {@macro sum-query}
  Expr<double> sum() =>
      select((a) => (SumExpression._(a),)).first.assertNotNull();

  /// {@macro avg-query}
  Expr<double?> avg() => select((a) => (AvgExpression._(a),)).first;

  /// {@macro min-query}
  Expr<double?> min() => select((a) => (MinExpression._(a),)).first;

  /// {@macro max-query}
  Expr<double?> max() => select((a) => (MaxExpression._(a),)).first;
}

extension SubQueryDateTime on SubQuery<(Expr<DateTime?>,)> {
  /// {@macro min-query}
  Expr<DateTime?> min() => select((a) => (MinExpression._(a),)).first;

  /// {@macro max-query}
  Expr<DateTime?> max() => select((a) => (MaxExpression._(a),)).first;
}

extension SubQueryString on SubQuery<(Expr<String?>,)> {
  /// {@macro min-query}
  Expr<String?> min() => select((a) => (MinExpression._(a),)).first;

  /// {@macro max-query}
  Expr<String?> max() => select((a) => (MaxExpression._(a),)).first;
}

extension QueryExt<T extends Record> on Query<T> {
  /// Create a query with distinct rows from this query using the `DISTINCT`
  /// _keyword_.
  ///
  /// This is equivalent to `SELECT DISTINCT * FROM this` in SQL.
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
