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
///
/// {@category Aggregate functions and group by}
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
  final TableDefinition<T> _definition;

  @override
  late final (Expr<T>,) _expressions =
      (ModelExpression._(0, _definition, Object()),);

  @override
  final QueryClause Function(List<Expr> expressions) _from;

  final TableClause _tableClause;

  Table._(super.context, this._tableClause, this._definition)
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
  final TableDefinition _definition;

  /// Name of table
  String get name => _definition.tableName;
  List<String> get columns => _definition.columns;
  List<String> get primaryKey => _definition.primaryKey;

  TableClause._(this._definition);
}

final class SelectClause extends QueryClause {
  final List<Expr> _expressions;

  Iterable<Expr> get expressions => _expressions.expand((e) => e._explode());

  SelectClause._(this._expressions);
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
  final List<Expr> _projection;

  Iterable<Expr> get projection => _projection.expand((e) => e._explode());

  SelectFromClause._(super.from, this._handle, this._projection) : super._();
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
  final List<(Expr<Comparable?>, Order)> orderBy;

  OrderByClause._(
    super.from,
    this._handle,
    this.orderBy,
  ) : super._() {
    if (orderBy.any((e) => e.$1._columns > 1)) {
      // This shouldn't be possible!
      throw AssertionError(
        'In Expr<T extends Model> T may not implement Comparable<T>, '
        'using Expr<Model> in .orderBy is not supported!',
      );
    }
  }
}

enum Order {
  ascending,
  descending,
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

final class GroupByClause extends FromClause implements ExpressionContext {
  @override
  final Object _handle;

  final List<Expr> _groupBy;
  final List<Expr> _projection;

  Iterable<Expr> get groupBy => _groupBy.expand((e) => e._explode());
  Iterable<Expr> get projection => _projection.expand((e) => e._explode());

  GroupByClause._(
    super.from,
    this._handle,
    this._groupBy,
    this._projection,
  ) : super._();
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

/* --------------------- Query aggregations ---------------------- */

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

/* --------------------- Auxiliary utils for SQL rendering------------------- */

// TODO: Rename this to ExpressionContext / Scope / SqlContext and move it to a
//       separate part file!
// TODO: Consider moving parameter logic out of this context!
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

  QueryContext scope(
    ExpressionContext clause,
    List<String> columns,
  ) {
    return _QueryContextScope(
      this,
      clause._handle,
      columns,
      _depth,
      _parameters,
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
    if (field._handle == _handle) {
      return 't$_depth.${_columns[field._index]}';
    }
    return _parent.field(field);
  }
}

final class _QueryContextScope extends QueryContext {
  final QueryContext _parent;
  final Object _handle;
  final List<String> _columns;

  _QueryContextScope(
    this._parent,
    this._handle,
    this._columns,
    super._depth,
    super._parameters,
  ) : super._();

  @override
  String field(FieldExpression field) {
    if (field._handle == _handle) {
      return _columns[field._index];
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

/* --------------------- GroupBy / Aggregation ------------------- */

final class Group<S extends Record, T extends Record> {
  final Query<T> _from;
  final Object _handle;
  final S _group;
  final T _standins;

  Group._(this._from, this._handle, this._group, this._standins);
}

final class Aggregation<T extends Record, S extends Record> {
  /// Expressions that can be used in the aggregations.
  final T _standins;

  /// Projection that has been made.
  final S _projection;

  Aggregation._(this._standins, this._projection);
}
