// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'typed_sql.dart';

// **************************************************************************
// Generator: _TypedSqlExtensionBuilder
// **************************************************************************

extension Query1<A> on Query<(Expr<A>,)> {
  (Object, T) _build<T>(T Function(Expr<A> a) builder) {
    final handle = Object();
    var offset = 0;
    final a = _expressions.$1._standin(offset, handle);
    return (handle, builder(a));
  }

  Query<(Expr<A>,)> where(Expr<bool> Function(Expr<A> a) conditionBuilder) {
    final (handle, where) = _build(conditionBuilder);
    return _Query(
      _context,
      _expressions,
      (e) => WhereClause._(_from(e), handle, where),
    );
  }

  Query<(Expr<A>,)> orderBy<T>(
    Expr<T> Function(Expr<A> a) expressionBuilder, {
    bool descending = false,
  }) {
    final (handle, orderBy) = _build(expressionBuilder);
    return _Query(
      _context,
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy, descending),
    );
  }

  Query<(Expr<A>,)> limit(int limit) => _Query(
        _context,
        _expressions,
        (e) => LimitClause._(_from(e), limit),
      );
  Query<(Expr<A>,)> offset(int offset) => _Query(
        _context,
        _expressions,
        (e) => OffsetClause._(_from(e), offset),
      );
  QuerySingle<(Expr<A>,)> get first => QuerySingle._(limit(1));
  QuerySingle<(Expr<int>,)> count() =>
      select((a) => (CountAllExpression._(),)).first;
  Query<T> select<T extends Record>(T Function(Expr<A> a) projectionBuilder) {
    final (handle, projection) = _build(projectionBuilder);
    return _Query(
      _context,
      projection,
      (e) => SelectFromClause._(_from(_expressions.toList()), handle, e),
    );
  }

  Join<(Expr<A>,), T> join<T extends Record>(Query<T> query) =>
      Join._(this, query);
  QuerySingle<(Expr<bool>,)> exists() => QuerySingle._(_Query(
        _context,
        (ExistsExpression._(_from(_expressions.toList())),),
        SelectClause._,
      ));
  Stream<A> fetch() async* {
    final from = _from(_expressions.toList());
    final decode1 = _expressions.$1._decode;
    final (sql, columns, params) =
        _context._dialect.select(SelectStatement._(from));
    await for (final row in _context._db.query(sql, params)) {
      yield decode1(row);
    }
  }
}

extension SubQuery1<A> on SubQuery<(Expr<A>,)> {
  (Object, T) _build<T>(T Function(Expr<A> a) builder) {
    final handle = Object();
    var offset = 0;
    final a = _expressions.$1._standin(offset, handle);
    return (handle, builder(a));
  }

  SubQuery<(Expr<A>,)> where(Expr<bool> Function(Expr<A> a) conditionBuilder) {
    final (handle, where) = _build(conditionBuilder);
    return SubQuery._(
      _expressions,
      (e) => WhereClause._(_from(e), handle, where),
    );
  }

  SubQuery<(Expr<A>,)> orderBy<T>(
    Expr<T> Function(Expr<A> a) expressionBuilder, {
    bool descending = false,
  }) {
    final (handle, orderBy) = _build(expressionBuilder);
    return SubQuery._(
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy, descending),
    );
  }

  SubQuery<(Expr<A>,)> limit(int limit) => SubQuery._(
        _expressions,
        (e) => LimitClause._(_from(e), limit),
      );
  SubQuery<(Expr<A>,)> offset(int offset) => SubQuery._(
        _expressions,
        (e) => OffsetClause._(_from(e), offset),
      );
  Expr<int> count() =>
      select((a) => (CountAllExpression._(),)).first.assertNotNull();
  SubQuery<T> select<T extends Record>(
      T Function(Expr<A> a) projectionBuilder) {
    final (handle, projection) = _build(projectionBuilder);
    return SubQuery._(
      projection,
      (e) => SelectFromClause._(_from(_expressions.toList()), handle, e),
    );
  }

  Expr<bool> exists() => ExistsExpression._(_from(_expressions.toList()));
}

extension Query2<A, B> on Query<(Expr<A>, Expr<B>)> {
  (Object, T) _build<T>(T Function(Expr<A> a, Expr<B> b) builder) {
    final handle = Object();
    var offset = 0;
    final a = _expressions.$1._standin(offset, handle);
    offset += _expressions.$1._columns;
    final b = _expressions.$2._standin(offset, handle);
    return (handle, builder(a, b));
  }

  Query<(Expr<A>, Expr<B>)> where(
      Expr<bool> Function(Expr<A> a, Expr<B> b) conditionBuilder) {
    final (handle, where) = _build(conditionBuilder);
    return _Query(
      _context,
      _expressions,
      (e) => WhereClause._(_from(e), handle, where),
    );
  }

  Query<(Expr<A>, Expr<B>)> orderBy<T>(
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

  Query<(Expr<A>, Expr<B>)> limit(int limit) => _Query(
        _context,
        _expressions,
        (e) => LimitClause._(_from(e), limit),
      );
  Query<(Expr<A>, Expr<B>)> offset(int offset) => _Query(
        _context,
        _expressions,
        (e) => OffsetClause._(_from(e), offset),
      );
  QuerySingle<(Expr<A>, Expr<B>)> get first => QuerySingle._(limit(1));
  QuerySingle<(Expr<int>,)> count() =>
      select((a, b) => (CountAllExpression._(),)).first;
  Query<T> select<T extends Record>(
      T Function(Expr<A> a, Expr<B> b) projectionBuilder) {
    final (handle, projection) = _build(projectionBuilder);
    return _Query(
      _context,
      projection,
      (e) => SelectFromClause._(_from(_expressions.toList()), handle, e),
    );
  }

  Join<(Expr<A>, Expr<B>), T> join<T extends Record>(Query<T> query) =>
      Join._(this, query);
  QuerySingle<(Expr<bool>,)> exists() => QuerySingle._(_Query(
        _context,
        (ExistsExpression._(_from(_expressions.toList())),),
        SelectClause._,
      ));
  Stream<(A, B)> fetch() async* {
    final from = _from(_expressions.toList());
    final decode1 = _expressions.$1._decode;
    final decode2 = _expressions.$2._decode;
    final (sql, columns, params) =
        _context._dialect.select(SelectStatement._(from));
    await for (final row in _context._db.query(sql, params)) {
      yield (decode1(row), decode2(row));
    }
  }
}

extension SubQuery2<A, B> on SubQuery<(Expr<A>, Expr<B>)> {
  (Object, T) _build<T>(T Function(Expr<A> a, Expr<B> b) builder) {
    final handle = Object();
    var offset = 0;
    final a = _expressions.$1._standin(offset, handle);
    offset += _expressions.$1._columns;
    final b = _expressions.$2._standin(offset, handle);
    return (handle, builder(a, b));
  }

  SubQuery<(Expr<A>, Expr<B>)> where(
      Expr<bool> Function(Expr<A> a, Expr<B> b) conditionBuilder) {
    final (handle, where) = _build(conditionBuilder);
    return SubQuery._(
      _expressions,
      (e) => WhereClause._(_from(e), handle, where),
    );
  }

  SubQuery<(Expr<A>, Expr<B>)> orderBy<T>(
    Expr<T> Function(Expr<A> a, Expr<B> b) expressionBuilder, {
    bool descending = false,
  }) {
    final (handle, orderBy) = _build(expressionBuilder);
    return SubQuery._(
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy, descending),
    );
  }

  SubQuery<(Expr<A>, Expr<B>)> limit(int limit) => SubQuery._(
        _expressions,
        (e) => LimitClause._(_from(e), limit),
      );
  SubQuery<(Expr<A>, Expr<B>)> offset(int offset) => SubQuery._(
        _expressions,
        (e) => OffsetClause._(_from(e), offset),
      );
  Expr<int> count() =>
      select((a, b) => (CountAllExpression._(),)).first.assertNotNull();
  SubQuery<T> select<T extends Record>(
      T Function(Expr<A> a, Expr<B> b) projectionBuilder) {
    final (handle, projection) = _build(projectionBuilder);
    return SubQuery._(
      projection,
      (e) => SelectFromClause._(_from(_expressions.toList()), handle, e),
    );
  }

  Expr<bool> exists() => ExistsExpression._(_from(_expressions.toList()));
}

extension Query3<A, B, C> on Query<(Expr<A>, Expr<B>, Expr<C>)> {
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
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c) conditionBuilder) {
    final (handle, where) = _build(conditionBuilder);
    return _Query(
      _context,
      _expressions,
      (e) => WhereClause._(_from(e), handle, where),
    );
  }

  Query<(Expr<A>, Expr<B>, Expr<C>)> orderBy<T>(
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

  Query<(Expr<A>, Expr<B>, Expr<C>)> limit(int limit) => _Query(
        _context,
        _expressions,
        (e) => LimitClause._(_from(e), limit),
      );
  Query<(Expr<A>, Expr<B>, Expr<C>)> offset(int offset) => _Query(
        _context,
        _expressions,
        (e) => OffsetClause._(_from(e), offset),
      );
  QuerySingle<(Expr<A>, Expr<B>, Expr<C>)> get first => QuerySingle._(limit(1));
  QuerySingle<(Expr<int>,)> count() =>
      select((a, b, c) => (CountAllExpression._(),)).first;
  Query<T> select<T extends Record>(
      T Function(Expr<A> a, Expr<B> b, Expr<C> c) projectionBuilder) {
    final (handle, projection) = _build(projectionBuilder);
    return _Query(
      _context,
      projection,
      (e) => SelectFromClause._(_from(_expressions.toList()), handle, e),
    );
  }

  Join<(Expr<A>, Expr<B>, Expr<C>), T> join<T extends Record>(Query<T> query) =>
      Join._(this, query);
  QuerySingle<(Expr<bool>,)> exists() => QuerySingle._(_Query(
        _context,
        (ExistsExpression._(_from(_expressions.toList())),),
        SelectClause._,
      ));
  Stream<(A, B, C)> fetch() async* {
    final from = _from(_expressions.toList());
    final decode1 = _expressions.$1._decode;
    final decode2 = _expressions.$2._decode;
    final decode3 = _expressions.$3._decode;
    final (sql, columns, params) =
        _context._dialect.select(SelectStatement._(from));
    await for (final row in _context._db.query(sql, params)) {
      yield (decode1(row), decode2(row), decode3(row));
    }
  }
}

extension SubQuery3<A, B, C> on SubQuery<(Expr<A>, Expr<B>, Expr<C>)> {
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

  SubQuery<(Expr<A>, Expr<B>, Expr<C>)> where(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c) conditionBuilder) {
    final (handle, where) = _build(conditionBuilder);
    return SubQuery._(
      _expressions,
      (e) => WhereClause._(_from(e), handle, where),
    );
  }

  SubQuery<(Expr<A>, Expr<B>, Expr<C>)> orderBy<T>(
    Expr<T> Function(Expr<A> a, Expr<B> b, Expr<C> c) expressionBuilder, {
    bool descending = false,
  }) {
    final (handle, orderBy) = _build(expressionBuilder);
    return SubQuery._(
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy, descending),
    );
  }

  SubQuery<(Expr<A>, Expr<B>, Expr<C>)> limit(int limit) => SubQuery._(
        _expressions,
        (e) => LimitClause._(_from(e), limit),
      );
  SubQuery<(Expr<A>, Expr<B>, Expr<C>)> offset(int offset) => SubQuery._(
        _expressions,
        (e) => OffsetClause._(_from(e), offset),
      );
  Expr<int> count() =>
      select((a, b, c) => (CountAllExpression._(),)).first.assertNotNull();
  SubQuery<T> select<T extends Record>(
      T Function(Expr<A> a, Expr<B> b, Expr<C> c) projectionBuilder) {
    final (handle, projection) = _build(projectionBuilder);
    return SubQuery._(
      projection,
      (e) => SelectFromClause._(_from(_expressions.toList()), handle, e),
    );
  }

  Expr<bool> exists() => ExistsExpression._(_from(_expressions.toList()));
}

extension Query4<A, B, C, D> on Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> {
  (Object, T) _build<T>(
      T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d) builder) {
    final handle = Object();
    var offset = 0;
    final a = _expressions.$1._standin(offset, handle);
    offset += _expressions.$1._columns;
    final b = _expressions.$2._standin(offset, handle);
    offset += _expressions.$2._columns;
    final c = _expressions.$3._standin(offset, handle);
    offset += _expressions.$3._columns;
    final d = _expressions.$4._standin(offset, handle);
    return (handle, builder(a, b, c, d));
  }

  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> where(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
          conditionBuilder) {
    final (handle, where) = _build(conditionBuilder);
    return _Query(
      _context,
      _expressions,
      (e) => WhereClause._(_from(e), handle, where),
    );
  }

  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> orderBy<T>(
    Expr<T> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
        expressionBuilder, {
    bool descending = false,
  }) {
    final (handle, orderBy) = _build(expressionBuilder);
    return _Query(
      _context,
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy, descending),
    );
  }

  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> limit(int limit) => _Query(
        _context,
        _expressions,
        (e) => LimitClause._(_from(e), limit),
      );
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> offset(int offset) => _Query(
        _context,
        _expressions,
        (e) => OffsetClause._(_from(e), offset),
      );
  QuerySingle<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> get first =>
      QuerySingle._(limit(1));
  QuerySingle<(Expr<int>,)> count() =>
      select((a, b, c, d) => (CountAllExpression._(),)).first;
  Query<T> select<T extends Record>(
      T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
          projectionBuilder) {
    final (handle, projection) = _build(projectionBuilder);
    return _Query(
      _context,
      projection,
      (e) => SelectFromClause._(_from(_expressions.toList()), handle, e),
    );
  }

  Join<(Expr<A>, Expr<B>, Expr<C>, Expr<D>), T> join<T extends Record>(
          Query<T> query) =>
      Join._(this, query);
  QuerySingle<(Expr<bool>,)> exists() => QuerySingle._(_Query(
        _context,
        (ExistsExpression._(_from(_expressions.toList())),),
        SelectClause._,
      ));
  Stream<(A, B, C, D)> fetch() async* {
    final from = _from(_expressions.toList());
    final decode1 = _expressions.$1._decode;
    final decode2 = _expressions.$2._decode;
    final decode3 = _expressions.$3._decode;
    final decode4 = _expressions.$4._decode;
    final (sql, columns, params) =
        _context._dialect.select(SelectStatement._(from));
    await for (final row in _context._db.query(sql, params)) {
      yield (decode1(row), decode2(row), decode3(row), decode4(row));
    }
  }
}

extension SubQuery4<A, B, C, D>
    on SubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> {
  (Object, T) _build<T>(
      T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d) builder) {
    final handle = Object();
    var offset = 0;
    final a = _expressions.$1._standin(offset, handle);
    offset += _expressions.$1._columns;
    final b = _expressions.$2._standin(offset, handle);
    offset += _expressions.$2._columns;
    final c = _expressions.$3._standin(offset, handle);
    offset += _expressions.$3._columns;
    final d = _expressions.$4._standin(offset, handle);
    return (handle, builder(a, b, c, d));
  }

  SubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> where(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
          conditionBuilder) {
    final (handle, where) = _build(conditionBuilder);
    return SubQuery._(
      _expressions,
      (e) => WhereClause._(_from(e), handle, where),
    );
  }

  SubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> orderBy<T>(
    Expr<T> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
        expressionBuilder, {
    bool descending = false,
  }) {
    final (handle, orderBy) = _build(expressionBuilder);
    return SubQuery._(
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy, descending),
    );
  }

  SubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> limit(int limit) => SubQuery._(
        _expressions,
        (e) => LimitClause._(_from(e), limit),
      );
  SubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> offset(int offset) =>
      SubQuery._(
        _expressions,
        (e) => OffsetClause._(_from(e), offset),
      );
  Expr<int> count() =>
      select((a, b, c, d) => (CountAllExpression._(),)).first.assertNotNull();
  SubQuery<T> select<T extends Record>(
      T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
          projectionBuilder) {
    final (handle, projection) = _build(projectionBuilder);
    return SubQuery._(
      projection,
      (e) => SelectFromClause._(_from(_expressions.toList()), handle, e),
    );
  }

  Expr<bool> exists() => ExistsExpression._(_from(_expressions.toList()));
}

extension Query5<A, B, C, D, E>
    on Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> {
  (Object, T) _build<T>(
      T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
          builder) {
    final handle = Object();
    var offset = 0;
    final a = _expressions.$1._standin(offset, handle);
    offset += _expressions.$1._columns;
    final b = _expressions.$2._standin(offset, handle);
    offset += _expressions.$2._columns;
    final c = _expressions.$3._standin(offset, handle);
    offset += _expressions.$3._columns;
    final d = _expressions.$4._standin(offset, handle);
    offset += _expressions.$4._columns;
    final e = _expressions.$5._standin(offset, handle);
    return (handle, builder(a, b, c, d, e));
  }

  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> where(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
          conditionBuilder) {
    final (handle, where) = _build(conditionBuilder);
    return _Query(
      _context,
      _expressions,
      (e) => WhereClause._(_from(e), handle, where),
    );
  }

  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> orderBy<T>(
    Expr<T> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
        expressionBuilder, {
    bool descending = false,
  }) {
    final (handle, orderBy) = _build(expressionBuilder);
    return _Query(
      _context,
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy, descending),
    );
  }

  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> limit(int limit) =>
      _Query(
        _context,
        _expressions,
        (e) => LimitClause._(_from(e), limit),
      );
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> offset(int offset) =>
      _Query(
        _context,
        _expressions,
        (e) => OffsetClause._(_from(e), offset),
      );
  QuerySingle<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> get first =>
      QuerySingle._(limit(1));
  QuerySingle<(Expr<int>,)> count() =>
      select((a, b, c, d, e) => (CountAllExpression._(),)).first;
  Query<T> select<T extends Record>(
      T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
          projectionBuilder) {
    final (handle, projection) = _build(projectionBuilder);
    return _Query(
      _context,
      projection,
      (e) => SelectFromClause._(_from(_expressions.toList()), handle, e),
    );
  }

  Join<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>), T> join<T extends Record>(
          Query<T> query) =>
      Join._(this, query);
  QuerySingle<(Expr<bool>,)> exists() => QuerySingle._(_Query(
        _context,
        (ExistsExpression._(_from(_expressions.toList())),),
        SelectClause._,
      ));
  Stream<(A, B, C, D, E)> fetch() async* {
    final from = _from(_expressions.toList());
    final decode1 = _expressions.$1._decode;
    final decode2 = _expressions.$2._decode;
    final decode3 = _expressions.$3._decode;
    final decode4 = _expressions.$4._decode;
    final decode5 = _expressions.$5._decode;
    final (sql, columns, params) =
        _context._dialect.select(SelectStatement._(from));
    await for (final row in _context._db.query(sql, params)) {
      yield (
        decode1(row),
        decode2(row),
        decode3(row),
        decode4(row),
        decode5(row)
      );
    }
  }
}

extension SubQuery5<A, B, C, D, E>
    on SubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> {
  (Object, T) _build<T>(
      T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
          builder) {
    final handle = Object();
    var offset = 0;
    final a = _expressions.$1._standin(offset, handle);
    offset += _expressions.$1._columns;
    final b = _expressions.$2._standin(offset, handle);
    offset += _expressions.$2._columns;
    final c = _expressions.$3._standin(offset, handle);
    offset += _expressions.$3._columns;
    final d = _expressions.$4._standin(offset, handle);
    offset += _expressions.$4._columns;
    final e = _expressions.$5._standin(offset, handle);
    return (handle, builder(a, b, c, d, e));
  }

  SubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> where(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
          conditionBuilder) {
    final (handle, where) = _build(conditionBuilder);
    return SubQuery._(
      _expressions,
      (e) => WhereClause._(_from(e), handle, where),
    );
  }

  SubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> orderBy<T>(
    Expr<T> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
        expressionBuilder, {
    bool descending = false,
  }) {
    final (handle, orderBy) = _build(expressionBuilder);
    return SubQuery._(
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy, descending),
    );
  }

  SubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> limit(int limit) =>
      SubQuery._(
        _expressions,
        (e) => LimitClause._(_from(e), limit),
      );
  SubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> offset(int offset) =>
      SubQuery._(
        _expressions,
        (e) => OffsetClause._(_from(e), offset),
      );
  Expr<int> count() => select((a, b, c, d, e) => (CountAllExpression._(),))
      .first
      .assertNotNull();
  SubQuery<T> select<T extends Record>(
      T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
          projectionBuilder) {
    final (handle, projection) = _build(projectionBuilder);
    return SubQuery._(
      projection,
      (e) => SelectFromClause._(_from(_expressions.toList()), handle, e),
    );
  }

  Expr<bool> exists() => ExistsExpression._(_from(_expressions.toList()));
}

extension Query6<A, B, C, D, E, F>
    on Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> {
  (Object, T) _build<T>(
      T Function(
              Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f)
          builder) {
    final handle = Object();
    var offset = 0;
    final a = _expressions.$1._standin(offset, handle);
    offset += _expressions.$1._columns;
    final b = _expressions.$2._standin(offset, handle);
    offset += _expressions.$2._columns;
    final c = _expressions.$3._standin(offset, handle);
    offset += _expressions.$3._columns;
    final d = _expressions.$4._standin(offset, handle);
    offset += _expressions.$4._columns;
    final e = _expressions.$5._standin(offset, handle);
    offset += _expressions.$5._columns;
    final f = _expressions.$6._standin(offset, handle);
    return (handle, builder(a, b, c, d, e, f));
  }

  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> where(
      Expr<bool> Function(
              Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f)
          conditionBuilder) {
    final (handle, where) = _build(conditionBuilder);
    return _Query(
      _context,
      _expressions,
      (e) => WhereClause._(_from(e), handle, where),
    );
  }

  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> orderBy<T>(
    Expr<T> Function(
            Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f)
        expressionBuilder, {
    bool descending = false,
  }) {
    final (handle, orderBy) = _build(expressionBuilder);
    return _Query(
      _context,
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy, descending),
    );
  }

  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> limit(
          int limit) =>
      _Query(
        _context,
        _expressions,
        (e) => LimitClause._(_from(e), limit),
      );
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> offset(
          int offset) =>
      _Query(
        _context,
        _expressions,
        (e) => OffsetClause._(_from(e), offset),
      );
  QuerySingle<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)>
      get first => QuerySingle._(limit(1));
  QuerySingle<(Expr<int>,)> count() =>
      select((a, b, c, d, e, f) => (CountAllExpression._(),)).first;
  Query<T> select<T extends Record>(
      T Function(
              Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f)
          projectionBuilder) {
    final (handle, projection) = _build(projectionBuilder);
    return _Query(
      _context,
      projection,
      (e) => SelectFromClause._(_from(_expressions.toList()), handle, e),
    );
  }

  Join<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>), T>
      join<T extends Record>(Query<T> query) => Join._(this, query);
  QuerySingle<(Expr<bool>,)> exists() => QuerySingle._(_Query(
        _context,
        (ExistsExpression._(_from(_expressions.toList())),),
        SelectClause._,
      ));
  Stream<(A, B, C, D, E, F)> fetch() async* {
    final from = _from(_expressions.toList());
    final decode1 = _expressions.$1._decode;
    final decode2 = _expressions.$2._decode;
    final decode3 = _expressions.$3._decode;
    final decode4 = _expressions.$4._decode;
    final decode5 = _expressions.$5._decode;
    final decode6 = _expressions.$6._decode;
    final (sql, columns, params) =
        _context._dialect.select(SelectStatement._(from));
    await for (final row in _context._db.query(sql, params)) {
      yield (
        decode1(row),
        decode2(row),
        decode3(row),
        decode4(row),
        decode5(row),
        decode6(row)
      );
    }
  }
}

extension SubQuery6<A, B, C, D, E, F>
    on SubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> {
  (Object, T) _build<T>(
      T Function(
              Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f)
          builder) {
    final handle = Object();
    var offset = 0;
    final a = _expressions.$1._standin(offset, handle);
    offset += _expressions.$1._columns;
    final b = _expressions.$2._standin(offset, handle);
    offset += _expressions.$2._columns;
    final c = _expressions.$3._standin(offset, handle);
    offset += _expressions.$3._columns;
    final d = _expressions.$4._standin(offset, handle);
    offset += _expressions.$4._columns;
    final e = _expressions.$5._standin(offset, handle);
    offset += _expressions.$5._columns;
    final f = _expressions.$6._standin(offset, handle);
    return (handle, builder(a, b, c, d, e, f));
  }

  SubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> where(
      Expr<bool> Function(
              Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f)
          conditionBuilder) {
    final (handle, where) = _build(conditionBuilder);
    return SubQuery._(
      _expressions,
      (e) => WhereClause._(_from(e), handle, where),
    );
  }

  SubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> orderBy<T>(
    Expr<T> Function(
            Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f)
        expressionBuilder, {
    bool descending = false,
  }) {
    final (handle, orderBy) = _build(expressionBuilder);
    return SubQuery._(
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy, descending),
    );
  }

  SubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> limit(
          int limit) =>
      SubQuery._(
        _expressions,
        (e) => LimitClause._(_from(e), limit),
      );
  SubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> offset(
          int offset) =>
      SubQuery._(
        _expressions,
        (e) => OffsetClause._(_from(e), offset),
      );
  Expr<int> count() => select((a, b, c, d, e, f) => (CountAllExpression._(),))
      .first
      .assertNotNull();
  SubQuery<T> select<T extends Record>(
      T Function(
              Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f)
          projectionBuilder) {
    final (handle, projection) = _build(projectionBuilder);
    return SubQuery._(
      projection,
      (e) => SelectFromClause._(_from(_expressions.toList()), handle, e),
    );
  }

  Expr<bool> exists() => ExistsExpression._(_from(_expressions.toList()));
}

extension Query7<A, B, C, D, E, F, G>
    on Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> {
  (Object, T) _build<T>(
      T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
              Expr<F> f, Expr<G> g)
          builder) {
    final handle = Object();
    var offset = 0;
    final a = _expressions.$1._standin(offset, handle);
    offset += _expressions.$1._columns;
    final b = _expressions.$2._standin(offset, handle);
    offset += _expressions.$2._columns;
    final c = _expressions.$3._standin(offset, handle);
    offset += _expressions.$3._columns;
    final d = _expressions.$4._standin(offset, handle);
    offset += _expressions.$4._columns;
    final e = _expressions.$5._standin(offset, handle);
    offset += _expressions.$5._columns;
    final f = _expressions.$6._standin(offset, handle);
    offset += _expressions.$6._columns;
    final g = _expressions.$7._standin(offset, handle);
    return (handle, builder(a, b, c, d, e, f, g));
  }

  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> where(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
              Expr<F> f, Expr<G> g)
          conditionBuilder) {
    final (handle, where) = _build(conditionBuilder);
    return _Query(
      _context,
      _expressions,
      (e) => WhereClause._(_from(e), handle, where),
    );
  }

  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
      orderBy<T>(
    Expr<T> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
            Expr<F> f, Expr<G> g)
        expressionBuilder, {
    bool descending = false,
  }) {
    final (handle, orderBy) = _build(expressionBuilder);
    return _Query(
      _context,
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy, descending),
    );
  }

  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> limit(
          int limit) =>
      _Query(
        _context,
        _expressions,
        (e) => LimitClause._(_from(e), limit),
      );
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> offset(
          int offset) =>
      _Query(
        _context,
        _expressions,
        (e) => OffsetClause._(_from(e), offset),
      );
  QuerySingle<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
      get first => QuerySingle._(limit(1));
  QuerySingle<(Expr<int>,)> count() =>
      select((a, b, c, d, e, f, g) => (CountAllExpression._(),)).first;
  Query<T> select<T extends Record>(
      T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
              Expr<F> f, Expr<G> g)
          projectionBuilder) {
    final (handle, projection) = _build(projectionBuilder);
    return _Query(
      _context,
      projection,
      (e) => SelectFromClause._(_from(_expressions.toList()), handle, e),
    );
  }

  Join<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>), T>
      join<T extends Record>(Query<T> query) => Join._(this, query);
  QuerySingle<(Expr<bool>,)> exists() => QuerySingle._(_Query(
        _context,
        (ExistsExpression._(_from(_expressions.toList())),),
        SelectClause._,
      ));
  Stream<(A, B, C, D, E, F, G)> fetch() async* {
    final from = _from(_expressions.toList());
    final decode1 = _expressions.$1._decode;
    final decode2 = _expressions.$2._decode;
    final decode3 = _expressions.$3._decode;
    final decode4 = _expressions.$4._decode;
    final decode5 = _expressions.$5._decode;
    final decode6 = _expressions.$6._decode;
    final decode7 = _expressions.$7._decode;
    final (sql, columns, params) =
        _context._dialect.select(SelectStatement._(from));
    await for (final row in _context._db.query(sql, params)) {
      yield (
        decode1(row),
        decode2(row),
        decode3(row),
        decode4(row),
        decode5(row),
        decode6(row),
        decode7(row)
      );
    }
  }
}

extension SubQuery7<A, B, C, D, E, F, G> on SubQuery<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> {
  (Object, T) _build<T>(
      T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
              Expr<F> f, Expr<G> g)
          builder) {
    final handle = Object();
    var offset = 0;
    final a = _expressions.$1._standin(offset, handle);
    offset += _expressions.$1._columns;
    final b = _expressions.$2._standin(offset, handle);
    offset += _expressions.$2._columns;
    final c = _expressions.$3._standin(offset, handle);
    offset += _expressions.$3._columns;
    final d = _expressions.$4._standin(offset, handle);
    offset += _expressions.$4._columns;
    final e = _expressions.$5._standin(offset, handle);
    offset += _expressions.$5._columns;
    final f = _expressions.$6._standin(offset, handle);
    offset += _expressions.$6._columns;
    final g = _expressions.$7._standin(offset, handle);
    return (handle, builder(a, b, c, d, e, f, g));
  }

  SubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
      where(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g)
              conditionBuilder) {
    final (handle, where) = _build(conditionBuilder);
    return SubQuery._(
      _expressions,
      (e) => WhereClause._(_from(e), handle, where),
    );
  }

  SubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
      orderBy<T>(
    Expr<T> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
            Expr<F> f, Expr<G> g)
        expressionBuilder, {
    bool descending = false,
  }) {
    final (handle, orderBy) = _build(expressionBuilder);
    return SubQuery._(
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy, descending),
    );
  }

  SubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
      limit(int limit) => SubQuery._(
            _expressions,
            (e) => LimitClause._(_from(e), limit),
          );
  SubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
      offset(int offset) => SubQuery._(
            _expressions,
            (e) => OffsetClause._(_from(e), offset),
          );
  Expr<int> count() =>
      select((a, b, c, d, e, f, g) => (CountAllExpression._(),))
          .first
          .assertNotNull();
  SubQuery<T> select<T extends Record>(
      T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
              Expr<F> f, Expr<G> g)
          projectionBuilder) {
    final (handle, projection) = _build(projectionBuilder);
    return SubQuery._(
      projection,
      (e) => SelectFromClause._(_from(_expressions.toList()), handle, e),
    );
  }

  Expr<bool> exists() => ExistsExpression._(_from(_expressions.toList()));
}

extension Query8<A, B, C, D, E, F, G, H> on Query<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)> {
  (Object, T) _build<T>(
      T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
              Expr<F> f, Expr<G> g, Expr<H> h)
          builder) {
    final handle = Object();
    var offset = 0;
    final a = _expressions.$1._standin(offset, handle);
    offset += _expressions.$1._columns;
    final b = _expressions.$2._standin(offset, handle);
    offset += _expressions.$2._columns;
    final c = _expressions.$3._standin(offset, handle);
    offset += _expressions.$3._columns;
    final d = _expressions.$4._standin(offset, handle);
    offset += _expressions.$4._columns;
    final e = _expressions.$5._standin(offset, handle);
    offset += _expressions.$5._columns;
    final f = _expressions.$6._standin(offset, handle);
    offset += _expressions.$6._columns;
    final g = _expressions.$7._standin(offset, handle);
    offset += _expressions.$7._columns;
    final h = _expressions.$8._standin(offset, handle);
    return (handle, builder(a, b, c, d, e, f, g, h));
  }

  Query<
          (
            Expr<A>,
            Expr<B>,
            Expr<C>,
            Expr<D>,
            Expr<E>,
            Expr<F>,
            Expr<G>,
            Expr<H>
          )>
      where(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g, Expr<H> h)
              conditionBuilder) {
    final (handle, where) = _build(conditionBuilder);
    return _Query(
      _context,
      _expressions,
      (e) => WhereClause._(_from(e), handle, where),
    );
  }

  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>
      )> orderBy<T>(
    Expr<T> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
            Expr<F> f, Expr<G> g, Expr<H> h)
        expressionBuilder, {
    bool descending = false,
  }) {
    final (handle, orderBy) = _build(expressionBuilder);
    return _Query(
      _context,
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy, descending),
    );
  }

  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)>
      limit(int limit) => _Query(
            _context,
            _expressions,
            (e) => LimitClause._(_from(e), limit),
          );
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)>
      offset(int offset) => _Query(
            _context,
            _expressions,
            (e) => OffsetClause._(_from(e), offset),
          );
  QuerySingle<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>
      )> get first => QuerySingle._(limit(1));
  QuerySingle<(Expr<int>,)> count() =>
      select((a, b, c, d, e, f, g, h) => (CountAllExpression._(),)).first;
  Query<T> select<T extends Record>(
      T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
              Expr<F> f, Expr<G> g, Expr<H> h)
          projectionBuilder) {
    final (handle, projection) = _build(projectionBuilder);
    return _Query(
      _context,
      projection,
      (e) => SelectFromClause._(_from(_expressions.toList()), handle, e),
    );
  }

  Join<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>),
      T> join<T extends Record>(Query<T> query) => Join._(this, query);
  QuerySingle<(Expr<bool>,)> exists() => QuerySingle._(_Query(
        _context,
        (ExistsExpression._(_from(_expressions.toList())),),
        SelectClause._,
      ));
  Stream<(A, B, C, D, E, F, G, H)> fetch() async* {
    final from = _from(_expressions.toList());
    final decode1 = _expressions.$1._decode;
    final decode2 = _expressions.$2._decode;
    final decode3 = _expressions.$3._decode;
    final decode4 = _expressions.$4._decode;
    final decode5 = _expressions.$5._decode;
    final decode6 = _expressions.$6._decode;
    final decode7 = _expressions.$7._decode;
    final decode8 = _expressions.$8._decode;
    final (sql, columns, params) =
        _context._dialect.select(SelectStatement._(from));
    await for (final row in _context._db.query(sql, params)) {
      yield (
        decode1(row),
        decode2(row),
        decode3(row),
        decode4(row),
        decode5(row),
        decode6(row),
        decode7(row),
        decode8(row)
      );
    }
  }
}

extension SubQuery8<A, B, C, D, E, F, G, H> on SubQuery<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)> {
  (Object, T) _build<T>(
      T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
              Expr<F> f, Expr<G> g, Expr<H> h)
          builder) {
    final handle = Object();
    var offset = 0;
    final a = _expressions.$1._standin(offset, handle);
    offset += _expressions.$1._columns;
    final b = _expressions.$2._standin(offset, handle);
    offset += _expressions.$2._columns;
    final c = _expressions.$3._standin(offset, handle);
    offset += _expressions.$3._columns;
    final d = _expressions.$4._standin(offset, handle);
    offset += _expressions.$4._columns;
    final e = _expressions.$5._standin(offset, handle);
    offset += _expressions.$5._columns;
    final f = _expressions.$6._standin(offset, handle);
    offset += _expressions.$6._columns;
    final g = _expressions.$7._standin(offset, handle);
    offset += _expressions.$7._columns;
    final h = _expressions.$8._standin(offset, handle);
    return (handle, builder(a, b, c, d, e, f, g, h));
  }

  SubQuery<
          (
            Expr<A>,
            Expr<B>,
            Expr<C>,
            Expr<D>,
            Expr<E>,
            Expr<F>,
            Expr<G>,
            Expr<H>
          )>
      where(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g, Expr<H> h)
              conditionBuilder) {
    final (handle, where) = _build(conditionBuilder);
    return SubQuery._(
      _expressions,
      (e) => WhereClause._(_from(e), handle, where),
    );
  }

  SubQuery<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>
      )> orderBy<T>(
    Expr<T> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
            Expr<F> f, Expr<G> g, Expr<H> h)
        expressionBuilder, {
    bool descending = false,
  }) {
    final (handle, orderBy) = _build(expressionBuilder);
    return SubQuery._(
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy, descending),
    );
  }

  SubQuery<
          (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)>
      limit(int limit) => SubQuery._(
            _expressions,
            (e) => LimitClause._(_from(e), limit),
          );
  SubQuery<
          (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)>
      offset(int offset) => SubQuery._(
            _expressions,
            (e) => OffsetClause._(_from(e), offset),
          );
  Expr<int> count() =>
      select((a, b, c, d, e, f, g, h) => (CountAllExpression._(),))
          .first
          .assertNotNull();
  SubQuery<T> select<T extends Record>(
      T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
              Expr<F> f, Expr<G> g, Expr<H> h)
          projectionBuilder) {
    final (handle, projection) = _build(projectionBuilder);
    return SubQuery._(
      projection,
      (e) => SelectFromClause._(_from(_expressions.toList()), handle, e),
    );
  }

  Expr<bool> exists() => ExistsExpression._(_from(_expressions.toList()));
}

extension Join1On1<A, B> on Join<(Expr<A>,), (Expr<B>,)> {
  Query<(Expr<A>, Expr<B>)> get all => _Query(
        _from._context,
        (
          _from._expressions.$1,
          _join._expressions.$1,
        ),
        (_) => JoinClause._(
          _from._from(_from._expressions.toList()),
          _join._from(_join._expressions.toList()),
        ),
      );
  Query<(Expr<A>, Expr<B>)> on(
          Expr<bool> Function(Expr<A> a, Expr<B> b) conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join1On2<A, B, C> on Join<(Expr<A>,), (Expr<B>, Expr<C>)> {
  Query<(Expr<A>, Expr<B>, Expr<C>)> get all => _Query(
        _from._context,
        (
          _from._expressions.$1,
          _join._expressions.$1,
          _join._expressions.$2,
        ),
        (_) => JoinClause._(
          _from._from(_from._expressions.toList()),
          _join._from(_join._expressions.toList()),
        ),
      );
  Query<(Expr<A>, Expr<B>, Expr<C>)> on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join1On3<A, B, C, D>
    on Join<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D>)> {
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> get all => _Query(
        _from._context,
        (
          _from._expressions.$1,
          _join._expressions.$1,
          _join._expressions.$2,
          _join._expressions.$3,
        ),
        (_) => JoinClause._(
          _from._from(_from._expressions.toList()),
          _join._from(_join._expressions.toList()),
        ),
      );
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join1On4<A, B, C, D, E>
    on Join<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D>, Expr<E>)> {
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> get all => _Query(
        _from._context,
        (
          _from._expressions.$1,
          _join._expressions.$1,
          _join._expressions.$2,
          _join._expressions.$3,
          _join._expressions.$4,
        ),
        (_) => JoinClause._(
          _from._from(_from._expressions.toList()),
          _join._from(_join._expressions.toList()),
        ),
      );
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> on(
          Expr<bool> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join1On5<A, B, C, D, E, F>
    on Join<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> {
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> get all =>
      _Query(
        _from._context,
        (
          _from._expressions.$1,
          _join._expressions.$1,
          _join._expressions.$2,
          _join._expressions.$3,
          _join._expressions.$4,
          _join._expressions.$5,
        ),
        (_) => JoinClause._(
          _from._from(_from._expressions.toList()),
          _join._from(_join._expressions.toList()),
        ),
      );
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join1On6<A, B, C, D, E, F, G> on Join<(Expr<A>,),
    (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> {
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
      get all => _Query(
            _from._context,
            (
              _from._expressions.$1,
              _join._expressions.$1,
              _join._expressions.$2,
              _join._expressions.$3,
              _join._expressions.$4,
              _join._expressions.$5,
              _join._expressions.$6,
            ),
            (_) => JoinClause._(
              _from._from(_from._expressions.toList()),
              _join._from(_join._expressions.toList()),
            ),
          );
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join1On7<A, B, C, D, E, F, G, H> on Join<(Expr<A>,),
    (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)> {
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)>
      get all => _Query(
            _from._context,
            (
              _from._expressions.$1,
              _join._expressions.$1,
              _join._expressions.$2,
              _join._expressions.$3,
              _join._expressions.$4,
              _join._expressions.$5,
              _join._expressions.$6,
              _join._expressions.$7,
            ),
            (_) => JoinClause._(
              _from._from(_from._expressions.toList()),
              _join._from(_join._expressions.toList()),
            ),
          );
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>
      )> on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g, Expr<H> h)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join2On1<A, B, C> on Join<(Expr<A>, Expr<B>), (Expr<C>,)> {
  Query<(Expr<A>, Expr<B>, Expr<C>)> get all => _Query(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _join._expressions.$1,
        ),
        (_) => JoinClause._(
          _from._from(_from._expressions.toList()),
          _join._from(_join._expressions.toList()),
        ),
      );
  Query<(Expr<A>, Expr<B>, Expr<C>)> on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join2On2<A, B, C, D> on Join<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>)> {
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> get all => _Query(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _join._expressions.$1,
          _join._expressions.$2,
        ),
        (_) => JoinClause._(
          _from._from(_from._expressions.toList()),
          _join._from(_join._expressions.toList()),
        ),
      );
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join2On3<A, B, C, D, E>
    on Join<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>, Expr<E>)> {
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> get all => _Query(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _join._expressions.$1,
          _join._expressions.$2,
          _join._expressions.$3,
        ),
        (_) => JoinClause._(
          _from._from(_from._expressions.toList()),
          _join._from(_join._expressions.toList()),
        ),
      );
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> on(
          Expr<bool> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join2On4<A, B, C, D, E, F>
    on Join<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>, Expr<E>, Expr<F>)> {
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> get all =>
      _Query(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _join._expressions.$1,
          _join._expressions.$2,
          _join._expressions.$3,
          _join._expressions.$4,
        ),
        (_) => JoinClause._(
          _from._from(_from._expressions.toList()),
          _join._from(_join._expressions.toList()),
        ),
      );
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join2On5<A, B, C, D, E, F, G>
    on Join<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> {
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
      get all => _Query(
            _from._context,
            (
              _from._expressions.$1,
              _from._expressions.$2,
              _join._expressions.$1,
              _join._expressions.$2,
              _join._expressions.$3,
              _join._expressions.$4,
              _join._expressions.$5,
            ),
            (_) => JoinClause._(
              _from._from(_from._expressions.toList()),
              _join._from(_join._expressions.toList()),
            ),
          );
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join2On6<A, B, C, D, E, F, G, H> on Join<(Expr<A>, Expr<B>),
    (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)> {
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)>
      get all => _Query(
            _from._context,
            (
              _from._expressions.$1,
              _from._expressions.$2,
              _join._expressions.$1,
              _join._expressions.$2,
              _join._expressions.$3,
              _join._expressions.$4,
              _join._expressions.$5,
              _join._expressions.$6,
            ),
            (_) => JoinClause._(
              _from._from(_from._expressions.toList()),
              _join._from(_join._expressions.toList()),
            ),
          );
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>
      )> on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g, Expr<H> h)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join3On1<A, B, C, D>
    on Join<(Expr<A>, Expr<B>, Expr<C>), (Expr<D>,)> {
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> get all => _Query(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _from._expressions.$3,
          _join._expressions.$1,
        ),
        (_) => JoinClause._(
          _from._from(_from._expressions.toList()),
          _join._from(_join._expressions.toList()),
        ),
      );
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join3On2<A, B, C, D, E>
    on Join<(Expr<A>, Expr<B>, Expr<C>), (Expr<D>, Expr<E>)> {
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> get all => _Query(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _from._expressions.$3,
          _join._expressions.$1,
          _join._expressions.$2,
        ),
        (_) => JoinClause._(
          _from._from(_from._expressions.toList()),
          _join._from(_join._expressions.toList()),
        ),
      );
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> on(
          Expr<bool> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join3On3<A, B, C, D, E, F>
    on Join<(Expr<A>, Expr<B>, Expr<C>), (Expr<D>, Expr<E>, Expr<F>)> {
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> get all =>
      _Query(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _from._expressions.$3,
          _join._expressions.$1,
          _join._expressions.$2,
          _join._expressions.$3,
        ),
        (_) => JoinClause._(
          _from._from(_from._expressions.toList()),
          _join._from(_join._expressions.toList()),
        ),
      );
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join3On4<A, B, C, D, E, F, G>
    on Join<(Expr<A>, Expr<B>, Expr<C>), (Expr<D>, Expr<E>, Expr<F>, Expr<G>)> {
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
      get all => _Query(
            _from._context,
            (
              _from._expressions.$1,
              _from._expressions.$2,
              _from._expressions.$3,
              _join._expressions.$1,
              _join._expressions.$2,
              _join._expressions.$3,
              _join._expressions.$4,
            ),
            (_) => JoinClause._(
              _from._from(_from._expressions.toList()),
              _join._from(_join._expressions.toList()),
            ),
          );
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join3On5<A, B, C, D, E, F, G, H> on Join<(Expr<A>, Expr<B>, Expr<C>),
    (Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)> {
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)>
      get all => _Query(
            _from._context,
            (
              _from._expressions.$1,
              _from._expressions.$2,
              _from._expressions.$3,
              _join._expressions.$1,
              _join._expressions.$2,
              _join._expressions.$3,
              _join._expressions.$4,
              _join._expressions.$5,
            ),
            (_) => JoinClause._(
              _from._from(_from._expressions.toList()),
              _join._from(_join._expressions.toList()),
            ),
          );
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>
      )> on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g, Expr<H> h)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join4On1<A, B, C, D, E>
    on Join<(Expr<A>, Expr<B>, Expr<C>, Expr<D>), (Expr<E>,)> {
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> get all => _Query(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _from._expressions.$3,
          _from._expressions.$4,
          _join._expressions.$1,
        ),
        (_) => JoinClause._(
          _from._from(_from._expressions.toList()),
          _join._from(_join._expressions.toList()),
        ),
      );
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> on(
          Expr<bool> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join4On2<A, B, C, D, E, F>
    on Join<(Expr<A>, Expr<B>, Expr<C>, Expr<D>), (Expr<E>, Expr<F>)> {
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> get all =>
      _Query(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _from._expressions.$3,
          _from._expressions.$4,
          _join._expressions.$1,
          _join._expressions.$2,
        ),
        (_) => JoinClause._(
          _from._from(_from._expressions.toList()),
          _join._from(_join._expressions.toList()),
        ),
      );
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join4On3<A, B, C, D, E, F, G>
    on Join<(Expr<A>, Expr<B>, Expr<C>, Expr<D>), (Expr<E>, Expr<F>, Expr<G>)> {
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
      get all => _Query(
            _from._context,
            (
              _from._expressions.$1,
              _from._expressions.$2,
              _from._expressions.$3,
              _from._expressions.$4,
              _join._expressions.$1,
              _join._expressions.$2,
              _join._expressions.$3,
            ),
            (_) => JoinClause._(
              _from._from(_from._expressions.toList()),
              _join._from(_join._expressions.toList()),
            ),
          );
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join4On4<A, B, C, D, E, F, G, H> on Join<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>),
    (Expr<E>, Expr<F>, Expr<G>, Expr<H>)> {
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)>
      get all => _Query(
            _from._context,
            (
              _from._expressions.$1,
              _from._expressions.$2,
              _from._expressions.$3,
              _from._expressions.$4,
              _join._expressions.$1,
              _join._expressions.$2,
              _join._expressions.$3,
              _join._expressions.$4,
            ),
            (_) => JoinClause._(
              _from._from(_from._expressions.toList()),
              _join._from(_join._expressions.toList()),
            ),
          );
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>
      )> on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g, Expr<H> h)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join5On1<A, B, C, D, E, F>
    on Join<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>), (Expr<F>,)> {
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> get all =>
      _Query(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _from._expressions.$3,
          _from._expressions.$4,
          _from._expressions.$5,
          _join._expressions.$1,
        ),
        (_) => JoinClause._(
          _from._from(_from._expressions.toList()),
          _join._from(_join._expressions.toList()),
        ),
      );
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join5On2<A, B, C, D, E, F, G>
    on Join<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>), (Expr<F>, Expr<G>)> {
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
      get all => _Query(
            _from._context,
            (
              _from._expressions.$1,
              _from._expressions.$2,
              _from._expressions.$3,
              _from._expressions.$4,
              _from._expressions.$5,
              _join._expressions.$1,
              _join._expressions.$2,
            ),
            (_) => JoinClause._(
              _from._from(_from._expressions.toList()),
              _join._from(_join._expressions.toList()),
            ),
          );
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join5On3<A, B, C, D, E, F, G, H> on Join<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>),
    (Expr<F>, Expr<G>, Expr<H>)> {
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)>
      get all => _Query(
            _from._context,
            (
              _from._expressions.$1,
              _from._expressions.$2,
              _from._expressions.$3,
              _from._expressions.$4,
              _from._expressions.$5,
              _join._expressions.$1,
              _join._expressions.$2,
              _join._expressions.$3,
            ),
            (_) => JoinClause._(
              _from._from(_from._expressions.toList()),
              _join._from(_join._expressions.toList()),
            ),
          );
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>
      )> on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g, Expr<H> h)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join6On1<A, B, C, D, E, F, G> on Join<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>), (Expr<G>,)> {
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
      get all => _Query(
            _from._context,
            (
              _from._expressions.$1,
              _from._expressions.$2,
              _from._expressions.$3,
              _from._expressions.$4,
              _from._expressions.$5,
              _from._expressions.$6,
              _join._expressions.$1,
            ),
            (_) => JoinClause._(
              _from._from(_from._expressions.toList()),
              _join._from(_join._expressions.toList()),
            ),
          );
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join6On2<A, B, C, D, E, F, G, H> on Join<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>),
    (Expr<G>, Expr<H>)> {
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)>
      get all => _Query(
            _from._context,
            (
              _from._expressions.$1,
              _from._expressions.$2,
              _from._expressions.$3,
              _from._expressions.$4,
              _from._expressions.$5,
              _from._expressions.$6,
              _join._expressions.$1,
              _join._expressions.$2,
            ),
            (_) => JoinClause._(
              _from._from(_from._expressions.toList()),
              _join._from(_join._expressions.toList()),
            ),
          );
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>
      )> on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g, Expr<H> h)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join7On1<A, B, C, D, E, F, G, H> on Join<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>),
    (Expr<H>,)> {
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)>
      get all => _Query(
            _from._context,
            (
              _from._expressions.$1,
              _from._expressions.$2,
              _from._expressions.$3,
              _from._expressions.$4,
              _from._expressions.$5,
              _from._expressions.$6,
              _from._expressions.$7,
              _join._expressions.$1,
            ),
            (_) => JoinClause._(
              _from._from(_from._expressions.toList()),
              _join._from(_join._expressions.toList()),
            ),
          );
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>
      )> on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g, Expr<H> h)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension QuerySingle1<A> on QuerySingle<(Expr<A>,)> {
  Query<(Expr<A>,)> get asQuery => _query;
  QuerySingle<(Expr<A>,)> where(
          Expr<bool> Function(Expr<A> a) conditionBuilder) =>
      asQuery.where(conditionBuilder).first;
  QuerySingle<T> select<T extends Record>(
          T Function(Expr<A> a) projectionBuilder) =>
      QuerySingle._(asQuery.select(projectionBuilder));
  Future<A?> fetch() async => (await asQuery.fetch().toList()).firstOrNull;
}

extension QuerySingle2<A, B> on QuerySingle<(Expr<A>, Expr<B>)> {
  Query<(Expr<A>, Expr<B>)> get asQuery => _query;
  QuerySingle<(Expr<A>, Expr<B>)> where(
          Expr<bool> Function(Expr<A> a, Expr<B> b) conditionBuilder) =>
      asQuery.where(conditionBuilder).first;
  QuerySingle<T> select<T extends Record>(
          T Function(Expr<A> a, Expr<B> b) projectionBuilder) =>
      QuerySingle._(asQuery.select(projectionBuilder));
  Future<(A, B)?> fetch() async => (await asQuery.fetch().toList()).firstOrNull;
}

extension QuerySingle3<A, B, C> on QuerySingle<(Expr<A>, Expr<B>, Expr<C>)> {
  Query<(Expr<A>, Expr<B>, Expr<C>)> get asQuery => _query;
  QuerySingle<(Expr<A>, Expr<B>, Expr<C>)> where(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c)
              conditionBuilder) =>
      asQuery.where(conditionBuilder).first;
  QuerySingle<T> select<T extends Record>(
          T Function(Expr<A> a, Expr<B> b, Expr<C> c) projectionBuilder) =>
      QuerySingle._(asQuery.select(projectionBuilder));
  Future<(A, B, C)?> fetch() async =>
      (await asQuery.fetch().toList()).firstOrNull;
}

extension QuerySingle4<A, B, C, D>
    on QuerySingle<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> {
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> get asQuery => _query;
  QuerySingle<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> where(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
              conditionBuilder) =>
      asQuery.where(conditionBuilder).first;
  QuerySingle<T> select<T extends Record>(
          T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
              projectionBuilder) =>
      QuerySingle._(asQuery.select(projectionBuilder));
  Future<(A, B, C, D)?> fetch() async =>
      (await asQuery.fetch().toList()).firstOrNull;
}

extension QuerySingle5<A, B, C, D, E>
    on QuerySingle<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> {
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> get asQuery => _query;
  QuerySingle<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> where(
          Expr<bool> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
              conditionBuilder) =>
      asQuery.where(conditionBuilder).first;
  QuerySingle<T> select<T extends Record>(
          T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
              projectionBuilder) =>
      QuerySingle._(asQuery.select(projectionBuilder));
  Future<(A, B, C, D, E)?> fetch() async =>
      (await asQuery.fetch().toList()).firstOrNull;
}

extension QuerySingle6<A, B, C, D, E, F>
    on QuerySingle<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> {
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> get asQuery =>
      _query;
  QuerySingle<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> where(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f)
              conditionBuilder) =>
      asQuery.where(conditionBuilder).first;
  QuerySingle<T> select<T extends Record>(
          T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
                  Expr<F> f)
              projectionBuilder) =>
      QuerySingle._(asQuery.select(projectionBuilder));
  Future<(A, B, C, D, E, F)?> fetch() async =>
      (await asQuery.fetch().toList()).firstOrNull;
}

extension QuerySingle7<A, B, C, D, E, F, G> on QuerySingle<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> {
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
      get asQuery => _query;
  QuerySingle<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
      where(
              Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                      Expr<E> e, Expr<F> f, Expr<G> g)
                  conditionBuilder) =>
          asQuery.where(conditionBuilder).first;
  QuerySingle<T> select<T extends Record>(
          T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
                  Expr<F> f, Expr<G> g)
              projectionBuilder) =>
      QuerySingle._(asQuery.select(projectionBuilder));
  Future<(A, B, C, D, E, F, G)?> fetch() async =>
      (await asQuery.fetch().toList()).firstOrNull;
}

extension QuerySingle8<A, B, C, D, E, F, G, H> on QuerySingle<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>
      )> get asQuery => _query;
  QuerySingle<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>
      )> where(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g, Expr<H> h)
              conditionBuilder) =>
      asQuery.where(conditionBuilder).first;
  QuerySingle<T> select<T extends Record>(
          T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
                  Expr<F> f, Expr<G> g, Expr<H> h)
              projectionBuilder) =>
      QuerySingle._(asQuery.select(projectionBuilder));
  Future<(A, B, C, D, E, F, G, H)?> fetch() async =>
      (await asQuery.fetch().toList()).firstOrNull;
}

extension<A> on (Expr<A>,) {
  List<Expr> toList() => [$1];
}

extension<A, B> on (Expr<A>, Expr<B>) {
  List<Expr> toList() => [$1, $2];
}

extension<A, B, C> on (Expr<A>, Expr<B>, Expr<C>) {
  List<Expr> toList() => [$1, $2, $3];
}

extension<A, B, C, D> on (Expr<A>, Expr<B>, Expr<C>, Expr<D>) {
  List<Expr> toList() => [$1, $2, $3, $4];
}

extension<A, B, C, D, E> on (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>) {
  List<Expr> toList() => [$1, $2, $3, $4, $5];
}

extension<A, B, C, D, E, F> on (
  Expr<A>,
  Expr<B>,
  Expr<C>,
  Expr<D>,
  Expr<E>,
  Expr<F>
) {
  List<Expr> toList() => [$1, $2, $3, $4, $5, $6];
}

extension<A, B, C, D, E, F, G> on (
  Expr<A>,
  Expr<B>,
  Expr<C>,
  Expr<D>,
  Expr<E>,
  Expr<F>,
  Expr<G>
) {
  List<Expr> toList() => [$1, $2, $3, $4, $5, $6, $7];
}

extension<A, B, C, D, E, F, G, H> on (
  Expr<A>,
  Expr<B>,
  Expr<C>,
  Expr<D>,
  Expr<E>,
  Expr<F>,
  Expr<G>,
  Expr<H>
) {
  List<Expr> toList() => [$1, $2, $3, $4, $5, $6, $7, $8];
}
