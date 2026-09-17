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

/// The SQL query-clause / statement AST shared between the query-builder
/// (`typed_sql.dart`) and the SQL dialects (`dialect/`).
///
/// This library is never exported from `package:typed_sql/typed_sql.dart`.
library;

import 'ast.expr.dart'
    show Expr, ExprInternal, FieldExpression, FieldExpressionInternal;
import 'ast.expr_types.dart' show ColumnType;
import 'typed_sql.dart'
    show
        ColumnDefinition,
        ForeignKeyDefinition,
        IndexDefinition,
        JoinType,
        Order,
        TableDefinition;

part 'ast.statements.dart';

/* --------------------- Query clauses ---------------------- */

sealed class QueryClause {}

final class TableClause extends QueryClause {
  final TableDefinition _definition;

  /// Name of table
  String get name => _definition.tableName;
  List<String> get columns => _definition.columns;
  List<String> get primaryKey => _definition.primaryKey;
  List<ColumnDefinition> get columnInfo => _definition.columnInfo;

  TableClause.internal(this._definition);
}

final class SelectClause extends QueryClause {
  final List<Expr> _expressions;

  Iterable<Expr> get expressions => _expressions.expand((e) => e.$explode());

  SelectClause.internal(this._expressions);
}

sealed class FromClause extends QueryClause {
  final QueryClause from;
  FromClause.internal(this.from);
}

/// Interface implemented by object with-in which expressions may exist.
///
/// Expressions can be bound to this context, that is the context from which
/// they are referencing fields.
final class ExpressionContext {
  final Object _handle;

  ExpressionContext.internal(this._handle);
}

final class SelectFromClause extends FromClause implements ExpressionContext {
  @override
  final Object _handle;
  final List<Expr> _projection;

  Iterable<Expr> get projection => _projection.expand((e) => e.$explode());

  SelectFromClause.internal(super.from, this._handle, this._projection)
    : super.internal();
}

final class WhereClause extends FromClause implements ExpressionContext {
  @override
  final Object _handle;
  final Expr<bool?> where;
  WhereClause.internal(super.from, this._handle, this.where) : super.internal();
}

final class OrderByClause extends FromClause implements ExpressionContext {
  @override
  final Object _handle;
  final List<(Expr<Comparable?>, Order)> orderBy;

  OrderByClause.internal(
    super.from,
    this._handle,
    this.orderBy,
  ) : super.internal() {
    if (orderBy.any((e) => e.$1.$columnCount > 1)) {
      // This shouldn't be possible!
      throw AssertionError(
        'In Expr<T extends Row> T may not implement Comparable<T>, '
        'using Expr<Row> in .orderBy is not supported!',
      );
    }
  }
}

final class JoinClause extends FromClause implements ExpressionContext {
  @override
  final Object _handle;
  final JoinType type;
  final QueryClause join;
  final Expr<bool?> on;

  JoinClause.internal(
    this._handle,
    this.type,
    super.from,
    this.join,
    this.on,
  ) : super.internal();
}

final class LimitClause extends FromClause {
  final int limit;
  LimitClause.internal(super.from, this.limit) : super.internal();
}

final class OffsetClause extends FromClause {
  final int offset;
  OffsetClause.internal(super.from, this.offset) : super.internal();
}

final class DistinctClause extends FromClause {
  DistinctClause.internal(super.from) : super.internal();
}

final class GroupByClause extends FromClause implements ExpressionContext {
  @override
  final Object _handle;

  final List<Expr> _group;
  final List<Expr> _aggregation;

  /// The grouped columns (exploded).
  late final List<Expr> groupBy = _group.expand((e) => e.$explode()).toList();

  /// The projection is made up of the grouped columns followed by the
  /// aggregations.
  ///
  /// We promise that [groupBy] is a prefix of [projection].
  late final List<Expr> projection = [
    ...groupBy,
    ..._aggregation.expand((e) => e.$explode()),
  ];

  GroupByClause.internal(
    super.from,
    this._handle,
    this._group,
    this._aggregation,
  ) : super.internal();
}

sealed class CompositeQueryClause extends QueryClause {
  final QueryClause left;
  final QueryClause right;
  CompositeQueryClause.internal(this.left, this.right);
}

// make these subclass of composite queryclause
final class UnionClause extends CompositeQueryClause {
  UnionClause.internal(super.left, super.right) : super.internal();
}

final class UnionAllClause extends CompositeQueryClause {
  UnionAllClause.internal(super.left, super.right) : super.internal();
}

final class IntersectClause extends CompositeQueryClause {
  IntersectClause.internal(super.left, super.right) : super.internal();
}

final class ExceptClause extends CompositeQueryClause {
  ExceptClause.internal(super.left, super.right) : super.internal();
}

/* --------------------- Auxiliary utils for SQL rendering------------------- */

final class ExpressionResolver<T> {
  final ExpressionResolver? _parent;
  final Object _handle;
  final List<(String?, String)> _columns;
  final T context;

  /// Depth of the scope in the query tree.
  final int depth;

  ExpressionResolver.internal(
    this.context,
    this._parent,
    this._handle,
    this._columns,
    this.depth,
  );

  ExpressionResolver(T context) : this.internal(context, null, Object(), [], 0);

  ExpressionResolver<T> withScope(
    ExpressionContext ctx,
    List<(String?, String)> columns,
  ) => ExpressionResolver.internal(
    context,
    this,
    ctx._handle,
    columns,
    depth + 1,
  );

  (String?, String) resolve(FieldExpression field) {
    if (_handle == field.$handle) {
      return _columns[field.$index];
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

/// Package-internal view of [ExpressionContext], exposing members used by
/// the query-builder without making them part of [ExpressionContext]'s own
/// (still private) API.
///
/// Members are prefixed with `$` (matching the `$ForGeneratedCode`
/// convention) so they can't collide with a generated per-model extension
/// member named after a user's column.
extension ExpressionContextInternal on ExpressionContext {
  Object get $handle => _handle;
}
