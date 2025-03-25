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
  Expr<T?> get asExpr => SubQueryExpression._(
        _query._from(_query._expressions.toList()),
        _query._expressions.$1,
      );
}

extension SubQuery1AsExpr<T> on SubQuery<(Expr<T>,)> {
  Expr<T?> get first => SubQueryExpression._(
        LimitClause._(_from(_expressions.toList()), 1),
        _expressions.$1,
      );
}


extension QueryInteger on Query<(Expr<int?>,)> {
  QuerySingle<(Expr<int>,)> sum() => select((a) => (SumExpression._(a),)).first;

  QuerySingle<(Expr<double?>,)> avg() =>
      select((a) => (AvgExpression._(a),)).first;

  QuerySingle<(Expr<int?>,)> min() =>
      select((a) => (MinExpression._(a),)).first;

  QuerySingle<(Expr<int?>,)> max() =>
      select((a) => (MaxExpression._(a),)).first;
}

extension QueryReal on Query<(Expr<double?>,)> {
  QuerySingle<(Expr<double>,)> sum() =>
      select((a) => (SumExpression._(a),)).first;

  QuerySingle<(Expr<double?>,)> avg() =>
      select((a) => (AvgExpression._(a),)).first;

  QuerySingle<(Expr<double?>,)> min() =>
      select((a) => (MinExpression._(a),)).first;

  QuerySingle<(Expr<double?>,)> max() =>
      select((a) => (MaxExpression._(a),)).first;
}

extension QueryDateTime on Query<(Expr<DateTime?>,)> {
  QuerySingle<(Expr<DateTime?>,)> min() =>
      select((a) => (MinExpression._(a),)).first;

  QuerySingle<(Expr<DateTime?>,)> max() =>
      select((a) => (MaxExpression._(a),)).first;
}

extension QueryString on Query<(Expr<String?>,)> {
  QuerySingle<(Expr<String?>,)> min() =>
      select((a) => (MinExpression._(a),)).first;

  QuerySingle<(Expr<String?>,)> max() =>
      select((a) => (MaxExpression._(a),)).first;
}

extension SubQueryInteger on SubQuery<(Expr<int?>,)> {
  Expr<int> sum() => select((a) => (SumExpression._(a),)).first.assertNotNull();

  Expr<double?> avg() => select((a) => (AvgExpression._(a),)).first;

  Expr<int?> min() => select((a) => (MinExpression._(a),)).first;

  Expr<int?> max() => select((a) => (MaxExpression._(a),)).first;
}

extension SubQueryReal on SubQuery<(Expr<double?>,)> {
  Expr<double> sum() =>
      select((a) => (SumExpression._(a),)).first.assertNotNull();

  Expr<double?> avg() => select((a) => (AvgExpression._(a),)).first;

  Expr<double?> min() => select((a) => (MinExpression._(a),)).first;

  Expr<double?> max() => select((a) => (MaxExpression._(a),)).first;
}

extension SubQueryDateTime on SubQuery<(Expr<DateTime?>,)> {
  Expr<DateTime?> min() => select((a) => (MinExpression._(a),)).first;

  Expr<DateTime?> max() => select((a) => (MaxExpression._(a),)).first;
}

extension SubQueryString on SubQuery<(Expr<String?>,)> {
  Expr<String?> min() => select((a) => (MinExpression._(a),)).first;

  Expr<String?> max() => select((a) => (MaxExpression._(a),)).first;
}

extension QueryAny<T extends Record> on Query<T> {
  Query<T> distinct() =>
      _Query(_context, _expressions, (e) => DistinctClause._(_from(e)));

  SubQuery<T> get asSubQuery => SubQuery._(_expressions, _from);
}
