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

// TODO: QuerySingle should be renamed QueryExpr and subclass Expr
//       This means we need to support subqueries in ALL expressions!
//       This isn't actually too hard in sqlite and postgres it's entirely
//       possible to do:
//         WHERE userId = (SELECT userId FROM ... WHERE ... LIMIT 1)
//       So long as there is a LIMIT 1 clause (required for postgres), while
//       sqlite will just compare to the first row in the subquery.
//       Probably this should use CTEs, in case a QueryExpr is referenced more
//       than once.
//       If the subquery returns no rows, both sqlite and postgres will take
//       that to mean NULL.

/// A [Query] on the database from which results can be fetched.
abstract final class Query<T extends Record> {
  final DatabaseContext _context;

  T get _expressions;
  QueryClause Function(List<Expr> expressions) get _from;

  Query._(this._context);

  // TODO: Consider a toString method!
}

// TODO: Consider making this an instance of Query
final class _Query<T extends Record> extends Query<T> {
  @override
  final T _expressions;

  @override
  final QueryClause Function(List<Expr> expressions) _from;

  _Query(super._context, this._expressions, this._from) : super._();
}

final class Join<T extends Record, S extends Record> {
  final Query<T> _from;
  final Query<S> _join;

  Join._(this._from, this._join);
}

/*
final class View<T extends Record> extends Query<T> {
  @override
  T get _expressions => throw UnimplementedError();

  @override
  QueryClause Function(List<Expr<Object?>> expressions) get _from =>
      throw UnimplementedError();

  View._(super._context) : super._();
}*/

final class Table<T extends Model> extends Query<(Expr<T>,)> {
  @override
  late final (Expr<T>,) _expressions =
      (ModelFieldExpression(0, this, Object()),);

  @override
  final QueryClause Function(List<Expr> expressions) _from;

  final T Function(RowReader) _deserialize;
  final TableClause _tableClause;

  Table._(super.context, this._tableClause, this._deserialize)
      : _from = ((_) => _tableClause),
        super._();
}

final class QuerySingle<T extends Record> {
  final Query<T> _query;

  QuerySingle._(this._query);
}

/// A [Query] which can only be used as a subquery.
final class SubQuery<T extends Record> {
  final T _expressions;
  final QueryClause Function(List<Expr> expressions) _from;

  SubQuery._(this._expressions, this._from);
}

/* --------------------- Query clauses ---------------------- */

sealed class QueryClause {}

final class TableClause extends QueryClause {
  /// Name of table
  final String name;
  final List<String> columns;
  final List<String> primaryKey;
  TableClause._(this.name, this.columns, this.primaryKey);
}

final class SelectClause extends QueryClause {
  final List<Expr> expressions;
  SelectClause._(this.expressions);
}

/*
final class ViewClause extends QueryClause {
  /// Name of view
  final String name;
  final List<String> columns;
  ViewClause(this.name, this.columns);
}*/

sealed class FromClause extends QueryClause {
  final QueryClause from;
  FromClause._(this.from);
}

/// Interface implemented by object with-in which expressions may exist.
///
/// Expressions can be bound to context, that is the context from which they
/// are referencing fields.
abstract final class ExpressionContext {
  Object get _handle;
}

final class SelectFromClause extends FromClause implements ExpressionContext {
  @override
  final Object _handle;
  final List<Expr> projection;
  SelectFromClause._(super.from, this._handle, this.projection) : super._();
}

final class WhereClause extends FromClause implements ExpressionContext {
  @override
  final Object _handle;
  final Expr<bool> where;
  WhereClause._(super.from, this._handle, this.where) : super._();
}

final class OrderByClause extends FromClause implements ExpressionContext {
  @override
  final Object _handle;
  final Expr orderBy;
  final bool descending;
  OrderByClause._(super.from, this._handle, this.orderBy, this.descending)
      : super._();
}

final class JoinClause extends FromClause {
  final QueryClause join;
  JoinClause._(super.from, this.join) : super._();
}

final class LimitClause extends FromClause {
  final int limit;
  LimitClause._(super.from, this.limit) : super._();
}

final class OffsetClause extends FromClause {
  final int offset;
  OffsetClause._(super.from, this.offset) : super._();
}

final class DistinctClause extends FromClause {
  DistinctClause._(super.from) : super._();
}

sealed class CompositeQueryClause extends QueryClause {
  final QueryClause left;
  final QueryClause right;
  CompositeQueryClause._(this.left, this.right);
}

// make these subclass of composite queryclause
final class UnionClause extends CompositeQueryClause {
  UnionClause._(super.left, super.right) : super._();
}

final class UnionAllClause extends CompositeQueryClause {
  UnionAllClause._(super.left, super.right) : super._();
}

final class IntersectClause extends CompositeQueryClause {
  IntersectClause._(super.left, super.right) : super._();
}

final class ExceptClause extends CompositeQueryClause {
  ExceptClause._(super.left, super.right) : super._();
}

/* --------------------- Query extensions ---------------------- */

extension QuerySingleModel1AsExpr<T extends Model> on QuerySingle<(Expr<T>,)> {
  Expr<T?> get asExpr => ModelSubQueryExpression._(
        _query._from(_query._expressions.toList()),
        _query.table,
      );
}

extension QuerySingle1AsExpr<T> on QuerySingle<(Expr<T>,)> {
  Expr<T?> get asExpr => SubQueryExpression._(
        _query._from(_query._expressions.toList()),
      );
}

extension QueryModel<T extends Model> on Query<(Expr<T>,)> {
  Future<int> delete() async {
    final table = switch (_expressions.$1) {
      final ModelFieldExpression e => e.table,
      _ => throw AssertionError('Expr<Model> must be a ModelExpression'),
    };

    final from = _from(_expressions.toList());
    final (sql, params) = _context._dialect.delete(
      DeleteStatement._(table._tableClause, from),
    );

    final rs = await _context._execute(sql, params);
    return rs.affectedRows;
  }
}

extension QuerySingleModel<T extends Model> on QuerySingle<(Expr<T>,)> {
  Future<int> delete() async => await asQuery.delete();
}

extension SubQueryModel1AsExpr<T extends Model> on SubQuery<(Expr<T>,)> {
  Expr<T?> get first => ModelSubQueryExpression._(
        _from(_expressions.toList()),
        table,
      );
}

extension SubQuery1AsExpr<T> on SubQuery<(Expr<T>,)> {
  Expr<T?> get first => SubQueryExpression._(
        _from(_expressions.toList()),
      );
}

/* --------------------- Query aggregations ---------------------- */

extension QueryNumber<T extends num> on Query<(Expr<T>,)> {
  QuerySingle<(Expr<T>,)> sum() =>
      select<(Expr<T>,)>((a) => (SumExpression._(a),)).first;

  QuerySingle<(Expr<double>,)> avg() =>
      select<(Expr<double>,)>((a) => (AvgExpression._(a),)).first;

  QuerySingle<(Expr<T>,)> min() =>
      select<(Expr<T>,)>((a) => (MinExpression._(a),)).first;

  QuerySingle<(Expr<T>,)> max() =>
      select<(Expr<T>,)>((a) => (MaxExpression._(a),)).first;
}

extension QueryDateTime on Query<(Expr<DateTime>,)> {
  QuerySingle<(Expr<DateTime>,)> min() =>
      select((a) => (MinExpression._(a),)).first;

  QuerySingle<(Expr<DateTime>,)> max() =>
      select((a) => (MaxExpression._(a),)).first;
}

extension QueryString on Query<(Expr<String>,)> {
  QuerySingle<(Expr<String>,)> min() =>
      select((a) => (MinExpression._(a),)).first;

  QuerySingle<(Expr<String>,)> max() =>
      select((a) => (MaxExpression._(a),)).first;
}

extension SubQueryNumber<T extends num> on SubQuery<(Expr<T>,)> {
  Expr<T> sum() =>
      select<(Expr<T>,)>((a) => (SumExpression._(a),)).first.assertNotNull();

  Expr<double> avg() => select<(Expr<double>,)>((a) => (AvgExpression._(a),))
      .first
      .assertNotNull();

  Expr<T> min() =>
      select<(Expr<T>,)>((a) => (MinExpression._(a),)).first.assertNotNull();

  Expr<T> max() =>
      select<(Expr<T>,)>((a) => (MaxExpression._(a),)).first.assertNotNull();
}

extension SubQueryDateTime on SubQuery<(Expr<DateTime>,)> {
  Expr<DateTime> min() =>
      select((a) => (MinExpression._(a),)).first.assertNotNull();

  Expr<DateTime> max() =>
      select((a) => (MaxExpression._(a),)).first.assertNotNull();
}

extension SubQueryString on SubQuery<(Expr<String>,)> {
  Expr<String> min() =>
      select((a) => (MinExpression._(a),)).first.assertNotNull();

  Expr<String> max() =>
      select((a) => (MaxExpression._(a),)).first.assertNotNull();
}

extension QueryAny<T extends Record> on Query<T> {
  Query<T> distinct() =>
      _Query(_context, _expressions, (e) => DistinctClause._(_from(e)));

  Query<T> union(Query<T> other) => _Query(
        _context,
        _expressions,
        (e) => UnionClause._(_from(e), other._from(e)),
      );

  Query<T> unionAll(Query<T> other) => _Query(
        _context,
        _expressions,
        (e) => UnionAllClause._(_from(e), other._from(e)),
      );

  Query<T> intersect(Query<T> other) => _Query(
        _context,
        _expressions,
        (e) => IntersectClause._(_from(e), other._from(e)),
      );

  Query<T> except(Query<T> other) => _Query(
        _context,
        _expressions,
        (e) => ExceptClause._(_from(e), other._from(e)),
      );

  Query<T> operator +(Query<T> other) => unionAll(other);
  Query<T> operator -(Query<T> other) => except(other);
  Query<T> operator &(Query<T> other) => intersect(other);
  Query<T> operator |(Query<T> other) => union(other);

  SubQuery<T> get asSubQuery => SubQuery._(_expressions, _from);
}

/* --------------------- Auxiliary utils for SQL rendering------------------- */

abstract final class QueryContext {
  final int _depth;
  final List<Object?> _parameters;

  static (List<Object?> parameters, QueryContext context) create() {
    final c = _RootQueryContext();
    return (c._parameters, c);
  }

  QueryContext._(this._depth, this._parameters);

  int param(Object? value) {
    _parameters.add(value);
    return _parameters.length;
  }

  String field(FieldExpression field);

  (String alias, QueryContext ctx) alias(
    ExpressionContext clause,
    List<String> columns,
  ) {
    return (
      't${_depth + 1}',
      _AliasedQueryContext(
        this,
        clause._handle,
        columns,
        _depth + 1,
        _parameters,
      ),
    );
  }
}

final class _AliasedQueryContext extends QueryContext {
  final QueryContext _parent;
  final Object _handle;
  final List<String> _columns;

  _AliasedQueryContext(
    this._parent,
    this._handle,
    this._columns,
    super._depth,
    super._parameters,
  ) : super._();

  @override
  String field(FieldExpression field) {
    if (field.handle == _handle) {
      return 't$_depth.${_columns[field.index]}';
    }
    return _parent.field(field);
  }
}

final class _RootQueryContext extends QueryContext {
  _RootQueryContext() : super._(0, []);

  @override
  String field(FieldExpression field) {
    throw ArgumentError.value(
      field,
      'field',
      'cannot be resolved in the given context',
    );
  }
}

/* --------------------- sqlite dialect! ---------------------- */
