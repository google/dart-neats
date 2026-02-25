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

/// A [Query] on the database from which results can be fetched.
///
/// {@category writing_queries}
final class Query<T extends Record> {
  final Database _context;

  final T _expressions;
  final QueryClause Function(List<Expr> expressions) _from;

  Query._(this._context, this._expressions, this._from);

  // TODO: Consider a toString method!
}

/// {@category joins}
final class InnerJoin<T extends Record, S extends Record> {
  final Query<T> _from;
  final Query<S> _join;

  InnerJoin._(this._from, this._join);
}

/// {@category joins}
final class LeftJoin<T extends Record, S extends Record> {
  final Query<T> _from;
  final Query<S> _join;

  LeftJoin._(this._from, this._join);
}

/// {@category joins}
final class RightJoin<T extends Record, S extends Record> {
  final Query<T> _from;
  final Query<S> _join;

  RightJoin._(this._from, this._join);
}

/// A table of rows of type [T].
///
/// [Table] objects also implement [Query<(Expr<T>,)>], thus, they can be used
/// to query all rows in the table, in addition there will always be generated
/// _extension methods_ for:
///  * `.insert`,
///  * `.update`, and,
///  * `.delete`.
///
/// {@category inserting_rows}
/// {@category writing_queries}
/// {@category update_and_delete}
final class Table<T extends Row> extends Query<(Expr<T>,)> {
  final TableClause _tableClause;

  Table._(
    Database context,
    this._tableClause,
    TableDefinition<T> definition,
  ) : super._(
          context,
          (RowExpression._(0, definition, Object()),),
          (_) => _tableClause,
        );
}

/// A [Query] which can return at-most a single row.
///
/// A [QuerySingle] object may return zero or one row.
///
/// {@category writing_queries}
final class QuerySingle<T extends Record> {
  final Query<T> _query;

  QuerySingle._(this._query);
}

/// A [Query] which has an order imposed by `.orderBy`.
///
/// An [OrderedQuery] has the following _extension methods_ that preserve the
/// ordering:
///  * `.where`,
///  * `.limit`,
///  * `.offset`,
///  * `.select`, and,
///  * `.distinct`.
///
/// {@template advertize:OrderedQuery.asQuery}
/// > [!TIP]
/// > If you wish to use an _ordered query_ in manner that disregards the
/// > ordering you can convert to an _unordered_ [Query] using [asQuery].
/// > This is necessary for certain operations (like `JOIN`, `UNION`, etc.)
/// > becauses SQL disregards the order of rows in subqueries.
/// {@endtemplate}
///
/// As an example, SQL disregards the ordering when using a query in a `UNION`
/// or `JOIN`, thus, you must use [asQuery], if you wish to do such operations.
///
/// {@category writing_queries}
final class OrderedQuery<T extends Record> {
  final Query<T> _query;

  OrderedQuery._(this._query);
}

/// A [Query] which has an order imposed by `.orderBy` and is limited to a
/// range by `.limit` or `.offset`.
///
/// An [OrderedQueryRange] has the following _extension methods_ that preserve
/// the ordering:
///  * `.limit`,
///  * `.offset`, and,
///  * `.select`.
///
/// {@macro advertize:OrderedQuery.asQuery}
///
/// To use `.where` after imposing a range with `.limit` or `.offset` you must
/// use [asQuery], because `.where` will create a subquery which discards the
/// ordering.
///
/// {@category writing_queries}
final class OrderedQueryRange<T extends Record> {
  final Query<T> _query;

  OrderedQueryRange._(this._query);
}

/// A [Query] which has an order imposed by `.orderBy` and is projected to a
/// new set of columns using `.select` (or `.distinct`).
///
/// A [ProjectedOrderedQuery] has the following _extension methods_ that
/// preserve the ordering:
///  * `.limit`,
///  * `.offset`, and,
///  * `.distinct`.
///
/// {@macro advertize:OrderedQuery.asQuery}
///
/// To use `.where` or `.select` after imposing a projection you must use
/// [asQuery], because these must create subqueries which discards the ordering.
///
/// {@category writing_queries}
final class ProjectedOrderedQuery<T extends Record> {
  final Query<T> _query;

  ProjectedOrderedQuery._(this._query);
}

/// A [Query] which has an order imposed by `.orderBy`, is projected to a
/// new set of columns using `.select` (or `.distinct`), and is limited to a
/// range by `.limit` or `.offset`.
///
/// A [ProjectedOrderedQuery] has the following _extension methods_ that
/// preserve the ordering:
///  * `.limit`, and,
///  * `.offset`.
///
/// {@macro advertize:OrderedQuery.asQuery}
///
/// To use other _extension methods_ such as`.where` or `.select` you must use
/// [asQuery], because these must create subqueries which discards the ordering.
///
/// {@category writing_queries}
final class ProjectedOrderedQueryRange<T extends Record> {
  final Query<T> _query;

  ProjectedOrderedQueryRange._(this._query);
}

/// A [Query] which can only be used as a subquery.
///
/// {@category writing_queries}
final class SubQuery<T extends Record> {
  final T _expressions;
  final QueryClause Function(List<Expr> expressions) _from;

  SubQuery._(this._expressions, this._from);
}

/// A [SubQuery] which has an order imposed by `.orderBy`.
///
/// An [OrderedSubQuery] has the following _extension methods_ that preserve the
/// ordering:
///  * `.where`,
///  * `.limit`,
///  * `.offset`,
///  * `.select`, and,
///  * `.distinct`.
///
/// {@template advertize:OrderedSubQuery.asSubQuery}
/// > [!TIP]
/// > If you wish to use an _ordered query_ in manner that disregards the
/// > ordering you can convert to an _unordered_ [SubQuery] using [asSubQuery].
/// > This is necessary for certain operations (like `JOIN`, `UNION`, etc.)
/// > becauses SQL disregards the order of rows in subqueries.
/// {@endtemplate}
///
/// As an example, SQL disregards the ordering when using a query in a `UNION`
/// or `JOIN`, thus, you must use [asSubQuery], if you wish to do such
/// operations.
///
/// {@category writing_queries}
final class OrderedSubQuery<T extends Record> {
  final SubQuery<T> _query;

  OrderedSubQuery._(this._query);
}

/// A [SubQuery] which has an order imposed by `.orderBy` and is limited to a
/// range by `.limit` or `.offset`.
///
/// An [OrderedSubQueryRange] has the following _extension methods_ that preserve
/// the ordering:
///  * `.limit`,
///  * `.offset`, and,
///  * `.select`.
///
/// {@macro advertize:OrderedSubQuery.asSubQuery}
///
/// To use `.where` after imposing a range with `.limit` or `.offset` you must
/// use [asSubQuery], because `.where` will create a subquery which discards the
/// ordering.
///
/// {@category writing_queries}
final class OrderedSubQueryRange<T extends Record> {
  final SubQuery<T> _query;

  OrderedSubQueryRange._(this._query);
}

/// A [SubQuery] which has an order imposed by `.orderBy` and is projected to a
/// new set of columns using `.select` (or `.distinct`).
///
/// A [ProjectedOrderedSubQuery] has the following _extension methods_ that
/// preserve the ordering:
///  * `.limit`,
///  * `.offset`, and,
///  * `.distinct`.
///
/// {@macro advertize:OrderedSubQuery.asSubQuery}
///
/// To use `.where` or `.select` after imposing a projection you must use
/// [asSubQuery], because these must create subqueries which discards the
/// ordering.
///
/// {@category writing_queries}
final class ProjectedOrderedSubQuery<T extends Record> {
  final SubQuery<T> _query;

  ProjectedOrderedSubQuery._(this._query);
}

/// A [SubQuery] which has an order imposed by `.orderBy`, is projected to a
/// new set of columns using `.select` (or `.distinct`), and is limited to a
/// range by `.limit` or `.offset`.
///
/// A [ProjectedOrderedSubQuery] has the following _extension methods_ that
/// preserve the ordering:
///  * `.limit`, and,
///  * `.offset`.
///
/// {@macro advertize:OrderedSubQuery.asSubQuery}
///
/// To use other _extension methods_ such as`.where` or `.select` you must use
/// [asSubQuery], because these must create subqueries which discards the
/// ordering.
///
/// {@category writing_queries}
final class ProjectedOrderedSubQueryRange<T extends Record> {
  final SubQuery<T> _query;

  ProjectedOrderedSubQueryRange._(this._query);
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

sealed class FromClause extends QueryClause {
  final QueryClause from;
  FromClause._(this.from);
}

/// Interface implemented by object with-in which expressions may exist.
///
/// Expressions can be bound to this context, that is the context from which
/// they are referencing fields.
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
        'In Expr<T extends Row> T may not implement Comparable<T>, '
        'using Expr<Row> in .orderBy is not supported!',
      );
    }
  }
}

/// {@category writing_queries}
enum Order {
  ascending,
  descending,
}

final class JoinClause extends FromClause implements ExpressionContext {
  @override
  final Object _handle;
  final JoinType type;
  final QueryClause join;
  final Expr<bool> on;

  JoinClause._(
    this._handle,
    this.type,
    super.from,
    this.join,
    this.on,
  ) : super._();
}

enum JoinType {
  inner,
  left,
  right,
  // Note: postgres can't do a FULL JOIN ON <arbitrary boolean expression>
  // instead postgres will require that the expression uses '=' and is either
  // merge-joinable or hash-joinable.
  // Otherwise, postgres will return the following error:
  //   0A000: FULL JOIN is only supported with merge-joinable or hash-joinable
  //          join conditions
  // We want queries that work when they are correctly typed, so instead we're
  // opting not to support 'FULL JOIN'. It's better to have fewer features, but
  // offer those features reliably.
  // If users critically need a 'FULL JOIN', then this can be emulated with
  //   (.. LEFT JOIN .. ON ..) UNION ALL (NULL, .. WHERE NOT EXISTS (..))
  // It's not pretty or efficient, but possible, or users could simply opt to
  // write such SQL queries manually as SQL.
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

  final List<Expr> _group;
  final List<Expr> _aggregation;

  /// The grouped columns (exploded).
  late final List<Expr> groupBy = _group.expand((e) => e._explode()).toList();

  /// The projection is made up of the grouped columns followed by the
  /// aggregations.
  ///
  /// We promise that [groupBy] is a prefix of [projection].
  late final List<Expr> projection = [
    ...groupBy,
    ..._aggregation.expand((e) => e._explode()),
  ];

  GroupByClause._(
    super.from,
    this._handle,
    this._group,
    this._aggregation,
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

/* --------------------- Auxiliary utils for SQL rendering------------------- */

final class ExpressionResolver<T> {
  final ExpressionResolver? _parent;
  final Object _handle;
  final List<(String?, String)> _columns;
  final T context;

  /// Depth of the scope in the query tree.
  final int depth;

  ExpressionResolver._(
    this.context,
    this._parent,
    this._handle,
    this._columns,
    this.depth,
  );

  ExpressionResolver(T context) : this._(context, null, Object(), [], 0);

  ExpressionResolver<T> withScope(
    ExpressionContext ctx,
    List<(String?, String)> columns,
  ) =>
      ExpressionResolver._(
        context,
        this,
        ctx._handle,
        columns,
        depth + 1,
      );

  (String?, String) resolve(FieldExpression field) {
    if (_handle == field._handle) {
      return _columns[field._index];
    }
    if (_parent != null) {
      return _parent.resolve(field);
    }
    throw ArgumentError.value(
      field,
      'field',
      'cannot be resolved in the given context',
    );
  }
}

/* --------------------- GroupBy / Aggregation ------------------- */

/// {@category aggregate_functions}
final class Group<S extends Record, T extends Record> {
  final Query<T> _from;
  final Object _handle;
  final S _group;
  final T _standins;

  Group._(this._from, this._handle, this._group, this._standins);
}

/// {@category aggregate_functions}
final class Aggregation<T extends Record, S extends Record> {
  /// Expressions that can be used in the aggregations.
  final T _standins;

  /// Projection that has been made.
  final S _projection;

  Aggregation._(this._standins, this._projection);
}
