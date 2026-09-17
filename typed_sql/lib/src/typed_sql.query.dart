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
        (RowExpression.internal(0, definition, Object()),),
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

/// {@category writing_queries}
enum Order {
  ascending,
  descending,
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
