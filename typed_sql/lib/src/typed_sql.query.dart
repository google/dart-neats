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
abstract final class Query<T extends Record> {
  final DatabaseContext _context;

  T get _expressions;
  QueryClause Function(List<Expr> expressions) get _from;

  Query._(this._context);
}

final class _Query<T extends Record> extends Query<T> {
  @override
  final T _expressions;

  @override
  final QueryClause Function(List<Expr> expressions) _from;

  _Query(super._context, this._expressions, this._from) : super._();
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
  late final (Expr<T>,) _expressions = (ModelExpression(0, this, Object()),);

  @override
  final QueryClause Function(List<Expr> expressions) _from;

  final String _tableName;
  final List<String> _columns;
  final T Function(Object? Function(int index) get) _deserialize;

  Table._(
    super._context,
    this._tableName,
    this._columns,
    this._deserialize,
  )   : _from = ((_) => TableClause._(_tableName, _columns)),
        super._();
}

final class QuerySingle<T extends Record> {
  final Query<T> _query;

  QuerySingle._(this._query);
}

/* --------------------- Query clauses ---------------------- */

sealed class Statement {}

final class SelectStatement extends Statement {
  final QueryClause query;
  SelectStatement._(this.query);
}

final class InsertStatement extends Statement {
  final String table;
  final List<String> columns;
  final List<Expr> values;
  final List<String> returning;

  InsertStatement._(this.table, this.columns, this.values, this.returning);
}

final class UpdateStatement extends Statement implements ExpressionContext {
  @override
  final Object _handle;
  final TableClause table;
  final List<String> columns;
  final List<Expr> values;
  final QueryClause where;

  UpdateStatement._(
    this.table,
    this.columns,
    this.values,
    this._handle,
    this.where,
  );
}

final class DeleteStatement extends Statement {
  final TableClause table;
  final QueryClause where;

  DeleteStatement._(
    this.table,
    this.where,
  );
}

sealed class QueryClause {}

final class TableClause extends QueryClause {
  /// Name of table
  final String name;
  final List<String> columns;
  TableClause._(this.name, this.columns);
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

final class SelectClause extends FromClause implements ExpressionContext {
  @override
  final Object _handle;
  final List<Expr> projection;
  SelectClause._(super.from, this._handle, this.projection) : super._();
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

final class LimitClause extends FromClause {
  final int limit;
  LimitClause._(super.from, this.limit) : super._();
}

final class OffsetClause extends FromClause {
  final int offset;
  OffsetClause._(super.from, this.offset) : super._();
}

/* --------------------- Query extensions ---------------------- */

extension QueryA<A> on Query<(Expr<A>,)> {
  (Object, T) _build<T>(T Function(Expr<A> row) builder) {
    final handle = Object();
    var offset = 0;
    final a = _expressions.$1._standin(offset, handle);
    return (handle, builder(a));
  }

  Query<(Expr<A>,)> where(
    Expr<bool> Function(Expr<A> row) conditionBuilder,
  ) {
    final (handle, where) = _build(conditionBuilder);
    return _Query(
      _context,
      _expressions,
      (e) => WhereClause._(_from(e), handle, where),
    );
  }

  Query<(Expr<A>,)> orderBy<T extends Object?>(
    Expr<T> Function(Expr<A> row) expressionBuilder, {
    bool descending = false,
  }) {
    final (handle, orderBy) = _build(expressionBuilder);
    return _Query(
      _context,
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy, descending),
    );
  }

  Query<(Expr<A>,)> offset(int offset) => _Query(
        _context,
        _expressions,
        (e) => OffsetClause._(_from(e), offset),
      );

  Query<(Expr<A>,)> limit(int limit) => _Query(
        _context,
        _expressions,
        (e) => LimitClause._(_from(e), limit),
      );

  QuerySingle<(Expr<A>,)> get first => QuerySingle._(limit(1));

  Query<T> select<T extends Record>(
    T Function(Expr<A> row) projectionBuilder,
  ) {
    final (handle, projection) = _build(projectionBuilder);
    return _Query(
      _context,
      projection,
      (e) => SelectClause._(_from(_expressions.toList()), handle, e),
    );
  }

  Stream<A> fetch() async* {
    final from = _from(_expressions.toList());
    final offset1 = 0;
    final decode1 = _expressions.$1._decode;

    final (sql, columns, params) = _context._dialect.select(
      SelectStatement._(from),
    );

    await for (final row in _context._db.query(sql, params)) {
      yield decode1((i) => row[offset1 + i]);
    }
  }
}

extension QueryAB<A, B> on Query<(Expr<A>, Expr<B>)> {
  (Object, T) _build<T>(T Function(Expr<A> a, Expr<B> b) builder) {
    final handle = Object();
    var offset = 0;
    final a = _expressions.$1._standin(offset, handle);
    offset += _expressions.$1._columns;
    final b = _expressions.$2._standin(offset, handle);
    return (handle, builder(a, b));
  }

  Query<(Expr<A>, Expr<B>)> where(
    Expr<bool> Function(Expr<A> a, Expr<B> b) conditionBuilder,
  ) {
    final (handle, where) = _build(conditionBuilder);
    return _Query(
      _context,
      _expressions,
      (e) => WhereClause._(_from(e), handle, where),
    );
  }

  Query<(Expr<A>, Expr<B>)> orderBy<T extends Object?>(
    Expr<T> Function(Expr<A> a, Expr<B> b) expressionBuilder, {
    bool descending = false,
  }) {
    final (handle, orderBy) = _build(expressionBuilder);
    return _Query(
      _context,
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy, descending),
    );
  }

  Query<(Expr<A>, Expr<B>)> offset(int offset) => _Query(
        _context,
        _expressions,
        (e) => OffsetClause._(_from(e), offset),
      );

  Query<(Expr<A>, Expr<B>)> limit(int limit) => _Query(
        _context,
        _expressions,
        (e) => LimitClause._(_from(e), limit),
      );

  QuerySingle<(Expr<A>, Expr<B>)> get first => QuerySingle._(limit(1));

  Query<T> select<T extends Record>(
    T Function(Expr<A> a, Expr<B> b) projectionBuilder,
  ) {
    final (handle, projection) = _build(projectionBuilder);
    return _Query(
      _context,
      projection,
      (e) => SelectClause._(_from(_expressions.toList()), handle, e),
    );
  }

  Stream<(A, B)> fetch() async* {
    final from = _from(_expressions.toList());
    final offset1 = 0;
    final decode1 = _expressions.$1._decode;
    final offset2 = offset1 + _expressions.$1._columns;
    final decode2 = _expressions.$2._decode;

    final (sql, columns, params) = _context._dialect.select(
      SelectStatement._(from),
    );

    await for (final row in _context._db.query(sql, params)) {
      yield (
        decode1((i) => row[offset1 + i]),
        decode2((i) => row[offset2 + i]),
      );
    }
  }
}

extension QueryABC<A, B, C> on Query<(Expr<A>, Expr<B>, Expr<C>)> {
  (Object, T) _build<T>(T Function(Expr<A> a, Expr<B> b, Expr<C> c) builder) {
    final handle = Object();
    var offset = 0;
    final a = _expressions.$1._standin(offset, handle);
    offset += _expressions.$1._columns;
    final b = _expressions.$2._standin(offset, handle);
    offset += _expressions.$2._columns;
    final c = _expressions.$3._standin(offset, handle);
    return (handle, builder(a, b, c));
  }

  Query<(Expr<A>, Expr<B>, Expr<C>)> where(
    Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c) conditionBuilder,
  ) {
    final (handle, where) = _build(conditionBuilder);
    return _Query(
      _context,
      _expressions,
      (e) => WhereClause._(_from(e), handle, where),
    );
  }

  Query<(Expr<A>, Expr<B>, Expr<C>)> orderBy<T extends Object?>(
    Expr<T> Function(Expr<A> a, Expr<B> b, Expr<C> c) expressionBuilder, {
    bool descending = false,
  }) {
    final (handle, orderBy) = _build(expressionBuilder);
    return _Query(
      _context,
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy, descending),
    );
  }

  Query<(Expr<A>, Expr<B>, Expr<C>)> offset(int offset) => _Query(
        _context,
        _expressions,
        (e) => OffsetClause._(_from(e), offset),
      );

  Query<(Expr<A>, Expr<B>, Expr<C>)> limit(int limit) => _Query(
        _context,
        _expressions,
        (e) => LimitClause._(_from(e), limit),
      );

  QuerySingle<(Expr<A>, Expr<B>, Expr<C>)> get first => QuerySingle._(limit(1));

  Query<T> select<T extends Record>(
    T Function(Expr<A> a, Expr<B> b, Expr<C> c) projectionBuilder,
  ) {
    final (handle, projection) = _build(projectionBuilder);
    return _Query(
      _context,
      projection,
      (e) => SelectClause._(_from(_expressions.toList()), handle, e),
    );
  }

  Stream<(A, B, C)> fetch() async* {
    final from = _from(_expressions.toList());
    final offset1 = 0;
    final decode1 = _expressions.$1._decode;
    final offset2 = offset1 + _expressions.$1._columns;
    final decode2 = _expressions.$2._decode;
    final offset3 = offset2 + _expressions.$2._columns;
    final decode3 = _expressions.$3._decode;

    final (sql, columns, params) = _context._dialect.select(
      SelectStatement._(from),
    );

    await for (final row in _context._db.query(sql, params)) {
      yield (
        decode1((i) => row[offset1 + i]),
        decode2((i) => row[offset2 + i]),
        decode3((i) => row[offset3 + i]),
      );
    }
  }
}

extension QuerySingleA<A> on QuerySingle<(Expr<A>,)> {
  Query<(Expr<A>,)> get asQuery => _query;

  QuerySingle<(Expr<A>,)> where(
    Expr<bool> Function(Expr<A> row) conditionBuilder,
  ) =>
      asQuery.where(conditionBuilder).first;

  QuerySingle<T> select<T extends Record>(
    T Function(Expr<A> row) projectionBuilder,
  ) =>
      QuerySingle._(asQuery.select(projectionBuilder));

  Future<A?> fetch() async => (await asQuery.fetch().toList()).firstOrNull;
}

extension QuerySingleAB<A, B> on QuerySingle<(Expr<A>, Expr<B>)> {
  Query<(Expr<A>, Expr<B>)> get asQuery => _query;

  QuerySingle<(Expr<A>, Expr<B>)> where(
    Expr<bool> Function(Expr<A> a, Expr<B> b) conditionBuilder,
  ) =>
      asQuery.where(conditionBuilder).first;

  QuerySingle<T> select<T extends Record>(
    T Function(Expr<A> a, Expr<B> b) projectionBuilder,
  ) =>
      QuerySingle._(asQuery.select(projectionBuilder));

  Future<(A, B)?> fetch() async => (await asQuery.fetch().toList()).firstOrNull;
}

extension QuerySingleABC<A, B, C> on QuerySingle<(Expr<A>, Expr<B>, Expr<C>)> {
  Query<(Expr<A>, Expr<B>, Expr<C>)> get asQuery => _query;

  QuerySingle<(Expr<A>, Expr<B>, Expr<C>)> where(
    Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c) conditionBuilder,
  ) =>
      asQuery.where(conditionBuilder).first;

  QuerySingle<T> select<T extends Record>(
    T Function(Expr<A> a, Expr<B> b, Expr<C> c) projectionBuilder,
  ) =>
      QuerySingle._(asQuery.select(projectionBuilder));

  Future<(A, B, C)?> fetch() async =>
      (await asQuery.fetch().toList()).firstOrNull;
}

// DELETE and UPDATE is only possible for a single column, where the columns is
// model!
extension QueryModel<A extends Model> on Query<(Expr<A>,)> {
  Future<void> delete() async {
    final table = switch (_expressions.$1) {
      final ModelExpression e => e.table,
      _ => throw AssertionError('Expr<Model> must be a ModelExpression'),
    };

    final from = _from(_expressions.toList());
    final (sql, params) = _context._dialect.delete(
      DeleteStatement._(TableClause._(table._tableName, table._columns), from),
    );

    await _context._db.query(sql, params).drain();
  }
}

extension QuerySingleModel<A extends Model> on QuerySingle<(Expr<A>,)> {
  Future<void> delete() async => await asQuery.delete();
}

/* --------------------- Auxiliary toList ---------------------- */

extension<A> on (Expr<A>,) {
  List<Expr> toList() => [$1];
}

extension<A, B> on (Expr<A>, Expr<B>) {
  List<Expr> toList() => [$1, $2];
}

extension<A, B, C> on (Expr<A>, Expr<B>, Expr<C>) {
  List<Expr> toList() => [$1, $2, $3];
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

  List<String> model(ModelExpression model);

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
  List<String> model(ModelExpression model) {
    throw UnimplementedError();
  }

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

  @override
  List<String> model(ModelExpression<Model> model) {
    throw ArgumentError.value(
      model,
      'model',
      'cannot be resolved in the given context',
    );
  }
}

/* --------------------- sqlite dialect! ---------------------- */
