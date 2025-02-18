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
    Expr<T> Function(Expr<A> a) expressionBuilder, [
    bool descending = false,
  ]) {
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
  Query<T> select<T extends Record>(T Function(Expr<A> a) projectionBuilder) {
    final (handle, projection) = _build(projectionBuilder);
    return _Query(
      _context,
      projection,
      (e) => SelectClause._(_from(_expressions.toList()), handle, e),
    );
  }

  Join<(Expr<A>,), T> join<T extends Record>(Query<T> query) =>
      Join._(this, query);
  Stream<A> fetch() async* {
    final from = _from(_expressions.toList());
    final offset1 = 0;
    final decode1 = _expressions.$1._decode;
    final (sql, columns, params) =
        _context._dialect.select(SelectStatement._(from));
    await for (final row in _context._db.query(sql, params)) {
      yield (decode1((i) => row[offset1 + i]));
    }
  }
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
    Expr<T> Function(Expr<A> a, Expr<B> b) expressionBuilder, [
    bool descending = false,
  ]) {
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
  Query<T> select<T extends Record>(
      T Function(Expr<A> a, Expr<B> b) projectionBuilder) {
    final (handle, projection) = _build(projectionBuilder);
    return _Query(
      _context,
      projection,
      (e) => SelectClause._(_from(_expressions.toList()), handle, e),
    );
  }

  Join<(Expr<A>, Expr<B>), T> join<T extends Record>(Query<T> query) =>
      Join._(this, query);
  Stream<(A, B)> fetch() async* {
    final from = _from(_expressions.toList());
    final offset1 = 0;
    final decode1 = _expressions.$1._decode;
    final offset2 = offset1 + _expressions.$1._columns;
    final decode2 = _expressions.$2._decode;
    final (sql, columns, params) =
        _context._dialect.select(SelectStatement._(from));
    await for (final row in _context._db.query(sql, params)) {
      yield (
        decode1((i) => row[offset1 + i]),
        decode2((i) => row[offset2 + i])
      );
    }
  }
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
    Expr<T> Function(Expr<A> a, Expr<B> b, Expr<C> c) expressionBuilder, [
    bool descending = false,
  ]) {
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
  Query<T> select<T extends Record>(
      T Function(Expr<A> a, Expr<B> b, Expr<C> c) projectionBuilder) {
    final (handle, projection) = _build(projectionBuilder);
    return _Query(
      _context,
      projection,
      (e) => SelectClause._(_from(_expressions.toList()), handle, e),
    );
  }

  Join<(Expr<A>, Expr<B>, Expr<C>), T> join<T extends Record>(Query<T> query) =>
      Join._(this, query);
  Stream<(A, B, C)> fetch() async* {
    final from = _from(_expressions.toList());
    final offset1 = 0;
    final decode1 = _expressions.$1._decode;
    final offset2 = offset1 + _expressions.$1._columns;
    final decode2 = _expressions.$2._decode;
    final offset3 = offset2 + _expressions.$2._columns;
    final decode3 = _expressions.$3._decode;
    final (sql, columns, params) =
        _context._dialect.select(SelectStatement._(from));
    await for (final row in _context._db.query(sql, params)) {
      yield (
        decode1((i) => row[offset1 + i]),
        decode2((i) => row[offset2 + i]),
        decode3((i) => row[offset3 + i])
      );
    }
  }
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
        expressionBuilder, [
    bool descending = false,
  ]) {
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
  Query<T> select<T extends Record>(
      T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
          projectionBuilder) {
    final (handle, projection) = _build(projectionBuilder);
    return _Query(
      _context,
      projection,
      (e) => SelectClause._(_from(_expressions.toList()), handle, e),
    );
  }

  Join<(Expr<A>, Expr<B>, Expr<C>, Expr<D>), T> join<T extends Record>(
          Query<T> query) =>
      Join._(this, query);
  Stream<(A, B, C, D)> fetch() async* {
    final from = _from(_expressions.toList());
    final offset1 = 0;
    final decode1 = _expressions.$1._decode;
    final offset2 = offset1 + _expressions.$1._columns;
    final decode2 = _expressions.$2._decode;
    final offset3 = offset2 + _expressions.$2._columns;
    final decode3 = _expressions.$3._decode;
    final offset4 = offset3 + _expressions.$3._columns;
    final decode4 = _expressions.$4._decode;
    final (sql, columns, params) =
        _context._dialect.select(SelectStatement._(from));
    await for (final row in _context._db.query(sql, params)) {
      yield (
        decode1((i) => row[offset1 + i]),
        decode2((i) => row[offset2 + i]),
        decode3((i) => row[offset3 + i]),
        decode4((i) => row[offset4 + i])
      );
    }
  }
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
        expressionBuilder, [
    bool descending = false,
  ]) {
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
  Query<T> select<T extends Record>(
      T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
          projectionBuilder) {
    final (handle, projection) = _build(projectionBuilder);
    return _Query(
      _context,
      projection,
      (e) => SelectClause._(_from(_expressions.toList()), handle, e),
    );
  }

  Join<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>), T> join<T extends Record>(
          Query<T> query) =>
      Join._(this, query);
  Stream<(A, B, C, D, E)> fetch() async* {
    final from = _from(_expressions.toList());
    final offset1 = 0;
    final decode1 = _expressions.$1._decode;
    final offset2 = offset1 + _expressions.$1._columns;
    final decode2 = _expressions.$2._decode;
    final offset3 = offset2 + _expressions.$2._columns;
    final decode3 = _expressions.$3._decode;
    final offset4 = offset3 + _expressions.$3._columns;
    final decode4 = _expressions.$4._decode;
    final offset5 = offset4 + _expressions.$4._columns;
    final decode5 = _expressions.$5._decode;
    final (sql, columns, params) =
        _context._dialect.select(SelectStatement._(from));
    await for (final row in _context._db.query(sql, params)) {
      yield (
        decode1((i) => row[offset1 + i]),
        decode2((i) => row[offset2 + i]),
        decode3((i) => row[offset3 + i]),
        decode4((i) => row[offset4 + i]),
        decode5((i) => row[offset5 + i])
      );
    }
  }
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
        expressionBuilder, [
    bool descending = false,
  ]) {
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
  Query<T> select<T extends Record>(
      T Function(
              Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f)
          projectionBuilder) {
    final (handle, projection) = _build(projectionBuilder);
    return _Query(
      _context,
      projection,
      (e) => SelectClause._(_from(_expressions.toList()), handle, e),
    );
  }

  Join<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>), T>
      join<T extends Record>(Query<T> query) => Join._(this, query);
  Stream<(A, B, C, D, E, F)> fetch() async* {
    final from = _from(_expressions.toList());
    final offset1 = 0;
    final decode1 = _expressions.$1._decode;
    final offset2 = offset1 + _expressions.$1._columns;
    final decode2 = _expressions.$2._decode;
    final offset3 = offset2 + _expressions.$2._columns;
    final decode3 = _expressions.$3._decode;
    final offset4 = offset3 + _expressions.$3._columns;
    final decode4 = _expressions.$4._decode;
    final offset5 = offset4 + _expressions.$4._columns;
    final decode5 = _expressions.$5._decode;
    final offset6 = offset5 + _expressions.$5._columns;
    final decode6 = _expressions.$6._decode;
    final (sql, columns, params) =
        _context._dialect.select(SelectStatement._(from));
    await for (final row in _context._db.query(sql, params)) {
      yield (
        decode1((i) => row[offset1 + i]),
        decode2((i) => row[offset2 + i]),
        decode3((i) => row[offset3 + i]),
        decode4((i) => row[offset4 + i]),
        decode5((i) => row[offset5 + i]),
        decode6((i) => row[offset6 + i])
      );
    }
  }
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
        expressionBuilder, [
    bool descending = false,
  ]) {
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
  Query<T> select<T extends Record>(
      T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
              Expr<F> f, Expr<G> g)
          projectionBuilder) {
    final (handle, projection) = _build(projectionBuilder);
    return _Query(
      _context,
      projection,
      (e) => SelectClause._(_from(_expressions.toList()), handle, e),
    );
  }

  Join<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>), T>
      join<T extends Record>(Query<T> query) => Join._(this, query);
  Stream<(A, B, C, D, E, F, G)> fetch() async* {
    final from = _from(_expressions.toList());
    final offset1 = 0;
    final decode1 = _expressions.$1._decode;
    final offset2 = offset1 + _expressions.$1._columns;
    final decode2 = _expressions.$2._decode;
    final offset3 = offset2 + _expressions.$2._columns;
    final decode3 = _expressions.$3._decode;
    final offset4 = offset3 + _expressions.$3._columns;
    final decode4 = _expressions.$4._decode;
    final offset5 = offset4 + _expressions.$4._columns;
    final decode5 = _expressions.$5._decode;
    final offset6 = offset5 + _expressions.$5._columns;
    final decode6 = _expressions.$6._decode;
    final offset7 = offset6 + _expressions.$6._columns;
    final decode7 = _expressions.$7._decode;
    final (sql, columns, params) =
        _context._dialect.select(SelectStatement._(from));
    await for (final row in _context._db.query(sql, params)) {
      yield (
        decode1((i) => row[offset1 + i]),
        decode2((i) => row[offset2 + i]),
        decode3((i) => row[offset3 + i]),
        decode4((i) => row[offset4 + i]),
        decode5((i) => row[offset5 + i]),
        decode6((i) => row[offset6 + i]),
        decode7((i) => row[offset7 + i])
      );
    }
  }
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
        expressionBuilder, [
    bool descending = false,
  ]) {
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
  Query<T> select<T extends Record>(
      T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
              Expr<F> f, Expr<G> g, Expr<H> h)
          projectionBuilder) {
    final (handle, projection) = _build(projectionBuilder);
    return _Query(
      _context,
      projection,
      (e) => SelectClause._(_from(_expressions.toList()), handle, e),
    );
  }

  Join<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>),
      T> join<T extends Record>(Query<T> query) => Join._(this, query);
  Stream<(A, B, C, D, E, F, G, H)> fetch() async* {
    final from = _from(_expressions.toList());
    final offset1 = 0;
    final decode1 = _expressions.$1._decode;
    final offset2 = offset1 + _expressions.$1._columns;
    final decode2 = _expressions.$2._decode;
    final offset3 = offset2 + _expressions.$2._columns;
    final decode3 = _expressions.$3._decode;
    final offset4 = offset3 + _expressions.$3._columns;
    final decode4 = _expressions.$4._decode;
    final offset5 = offset4 + _expressions.$4._columns;
    final decode5 = _expressions.$5._decode;
    final offset6 = offset5 + _expressions.$5._columns;
    final decode6 = _expressions.$6._decode;
    final offset7 = offset6 + _expressions.$6._columns;
    final decode7 = _expressions.$7._decode;
    final offset8 = offset7 + _expressions.$7._columns;
    final decode8 = _expressions.$8._decode;
    final (sql, columns, params) =
        _context._dialect.select(SelectStatement._(from));
    await for (final row in _context._db.query(sql, params)) {
      yield (
        decode1((i) => row[offset1 + i]),
        decode2((i) => row[offset2 + i]),
        decode3((i) => row[offset3 + i]),
        decode4((i) => row[offset4 + i]),
        decode5((i) => row[offset5 + i]),
        decode6((i) => row[offset6 + i]),
        decode7((i) => row[offset7 + i]),
        decode8((i) => row[offset8 + i])
      );
    }
  }
}

extension Query9<A, B, C, D, E, F, G, H, I> on Query<
    (
      Expr<A>,
      Expr<B>,
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>
    )> {
  (Object, T) _build<T>(
      T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
              Expr<F> f, Expr<G> g, Expr<H> h, Expr<I> i)
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
    offset += _expressions.$8._columns;
    final i = _expressions.$9._standin(offset, handle);
    return (handle, builder(a, b, c, d, e, f, g, h, i));
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
            Expr<H>,
            Expr<I>
          )>
      where(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g, Expr<H> h, Expr<I> i)
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
        Expr<H>,
        Expr<I>
      )> orderBy<T>(
    Expr<T> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
            Expr<F> f, Expr<G> g, Expr<H> h, Expr<I> i)
        expressionBuilder, [
    bool descending = false,
  ]) {
    final (handle, orderBy) = _build(expressionBuilder);
    return _Query(
      _context,
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy, descending),
    );
  }

  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<I>)>
      limit(int limit) => _Query(
            _context,
            _expressions,
            (e) => LimitClause._(_from(e), limit),
          );
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<I>)>
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
        Expr<H>,
        Expr<I>
      )> get first => QuerySingle._(limit(1));
  Query<T> select<T extends Record>(
      T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
              Expr<F> f, Expr<G> g, Expr<H> h, Expr<I> i)
          projectionBuilder) {
    final (handle, projection) = _build(projectionBuilder);
    return _Query(
      _context,
      projection,
      (e) => SelectClause._(_from(_expressions.toList()), handle, e),
    );
  }

  Join<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>
      ),
      T> join<T extends Record>(Query<T> query) => Join._(this, query);
  Stream<(A, B, C, D, E, F, G, H, I)> fetch() async* {
    final from = _from(_expressions.toList());
    final offset1 = 0;
    final decode1 = _expressions.$1._decode;
    final offset2 = offset1 + _expressions.$1._columns;
    final decode2 = _expressions.$2._decode;
    final offset3 = offset2 + _expressions.$2._columns;
    final decode3 = _expressions.$3._decode;
    final offset4 = offset3 + _expressions.$3._columns;
    final decode4 = _expressions.$4._decode;
    final offset5 = offset4 + _expressions.$4._columns;
    final decode5 = _expressions.$5._decode;
    final offset6 = offset5 + _expressions.$5._columns;
    final decode6 = _expressions.$6._decode;
    final offset7 = offset6 + _expressions.$6._columns;
    final decode7 = _expressions.$7._decode;
    final offset8 = offset7 + _expressions.$7._columns;
    final decode8 = _expressions.$8._decode;
    final offset9 = offset8 + _expressions.$8._columns;
    final decode9 = _expressions.$9._decode;
    final (sql, columns, params) =
        _context._dialect.select(SelectStatement._(from));
    await for (final row in _context._db.query(sql, params)) {
      yield (
        decode1((i) => row[offset1 + i]),
        decode2((i) => row[offset2 + i]),
        decode3((i) => row[offset3 + i]),
        decode4((i) => row[offset4 + i]),
        decode5((i) => row[offset5 + i]),
        decode6((i) => row[offset6 + i]),
        decode7((i) => row[offset7 + i]),
        decode8((i) => row[offset8 + i]),
        decode9((i) => row[offset9 + i])
      );
    }
  }
}

extension Query10<A, B, C, D, E, F, G, H, I, J> on Query<
    (
      Expr<A>,
      Expr<B>,
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>
    )> {
  (Object, T) _build<T>(
      T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
              Expr<F> f, Expr<G> g, Expr<H> h, Expr<I> i, Expr<J> j)
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
    offset += _expressions.$8._columns;
    final i = _expressions.$9._standin(offset, handle);
    offset += _expressions.$9._columns;
    final j = _expressions.$10._standin(offset, handle);
    return (handle, builder(a, b, c, d, e, f, g, h, i, j));
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
            Expr<H>,
            Expr<I>,
            Expr<J>
          )>
      where(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j)
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
        Expr<H>,
        Expr<I>,
        Expr<J>
      )> orderBy<T>(
    Expr<T> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
            Expr<F> f, Expr<G> g, Expr<H> h, Expr<I> i, Expr<J> j)
        expressionBuilder, [
    bool descending = false,
  ]) {
    final (handle, orderBy) = _build(expressionBuilder);
    return _Query(
      _context,
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy, descending),
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
        Expr<H>,
        Expr<I>,
        Expr<J>
      )> limit(int limit) => _Query(
        _context,
        _expressions,
        (e) => LimitClause._(_from(e), limit),
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
        Expr<H>,
        Expr<I>,
        Expr<J>
      )> offset(int offset) => _Query(
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
        Expr<H>,
        Expr<I>,
        Expr<J>
      )> get first => QuerySingle._(limit(1));
  Query<T> select<T extends Record>(
      T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
              Expr<F> f, Expr<G> g, Expr<H> h, Expr<I> i, Expr<J> j)
          projectionBuilder) {
    final (handle, projection) = _build(projectionBuilder);
    return _Query(
      _context,
      projection,
      (e) => SelectClause._(_from(_expressions.toList()), handle, e),
    );
  }

  Join<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>
      ),
      T> join<T extends Record>(Query<T> query) => Join._(this, query);
  Stream<(A, B, C, D, E, F, G, H, I, J)> fetch() async* {
    final from = _from(_expressions.toList());
    final offset1 = 0;
    final decode1 = _expressions.$1._decode;
    final offset2 = offset1 + _expressions.$1._columns;
    final decode2 = _expressions.$2._decode;
    final offset3 = offset2 + _expressions.$2._columns;
    final decode3 = _expressions.$3._decode;
    final offset4 = offset3 + _expressions.$3._columns;
    final decode4 = _expressions.$4._decode;
    final offset5 = offset4 + _expressions.$4._columns;
    final decode5 = _expressions.$5._decode;
    final offset6 = offset5 + _expressions.$5._columns;
    final decode6 = _expressions.$6._decode;
    final offset7 = offset6 + _expressions.$6._columns;
    final decode7 = _expressions.$7._decode;
    final offset8 = offset7 + _expressions.$7._columns;
    final decode8 = _expressions.$8._decode;
    final offset9 = offset8 + _expressions.$8._columns;
    final decode9 = _expressions.$9._decode;
    final offset10 = offset9 + _expressions.$9._columns;
    final decode10 = _expressions.$10._decode;
    final (sql, columns, params) =
        _context._dialect.select(SelectStatement._(from));
    await for (final row in _context._db.query(sql, params)) {
      yield (
        decode1((i) => row[offset1 + i]),
        decode2((i) => row[offset2 + i]),
        decode3((i) => row[offset3 + i]),
        decode4((i) => row[offset4 + i]),
        decode5((i) => row[offset5 + i]),
        decode6((i) => row[offset6 + i]),
        decode7((i) => row[offset7 + i]),
        decode8((i) => row[offset8 + i]),
        decode9((i) => row[offset9 + i]),
        decode10((i) => row[offset10 + i])
      );
    }
  }
}

extension Query11<A, B, C, D, E, F, G, H, I, J, K> on Query<
    (
      Expr<A>,
      Expr<B>,
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>
    )> {
  (Object, T) _build<T>(
      T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
              Expr<F> f, Expr<G> g, Expr<H> h, Expr<I> i, Expr<J> j, Expr<K> k)
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
    offset += _expressions.$8._columns;
    final i = _expressions.$9._standin(offset, handle);
    offset += _expressions.$9._columns;
    final j = _expressions.$10._standin(offset, handle);
    offset += _expressions.$10._columns;
    final k = _expressions.$11._standin(offset, handle);
    return (handle, builder(a, b, c, d, e, f, g, h, i, j, k));
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
            Expr<H>,
            Expr<I>,
            Expr<J>,
            Expr<K>
          )>
      where(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k)
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>
      )> orderBy<T>(
    Expr<T> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
            Expr<F> f, Expr<G> g, Expr<H> h, Expr<I> i, Expr<J> j, Expr<K> k)
        expressionBuilder, [
    bool descending = false,
  ]) {
    final (handle, orderBy) = _build(expressionBuilder);
    return _Query(
      _context,
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy, descending),
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>
      )> limit(int limit) => _Query(
        _context,
        _expressions,
        (e) => LimitClause._(_from(e), limit),
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>
      )> offset(int offset) => _Query(
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>
      )> get first => QuerySingle._(limit(1));
  Query<T> select<T extends Record>(
      T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
              Expr<F> f, Expr<G> g, Expr<H> h, Expr<I> i, Expr<J> j, Expr<K> k)
          projectionBuilder) {
    final (handle, projection) = _build(projectionBuilder);
    return _Query(
      _context,
      projection,
      (e) => SelectClause._(_from(_expressions.toList()), handle, e),
    );
  }

  Join<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>
      ),
      T> join<T extends Record>(Query<T> query) => Join._(this, query);
  Stream<(A, B, C, D, E, F, G, H, I, J, K)> fetch() async* {
    final from = _from(_expressions.toList());
    final offset1 = 0;
    final decode1 = _expressions.$1._decode;
    final offset2 = offset1 + _expressions.$1._columns;
    final decode2 = _expressions.$2._decode;
    final offset3 = offset2 + _expressions.$2._columns;
    final decode3 = _expressions.$3._decode;
    final offset4 = offset3 + _expressions.$3._columns;
    final decode4 = _expressions.$4._decode;
    final offset5 = offset4 + _expressions.$4._columns;
    final decode5 = _expressions.$5._decode;
    final offset6 = offset5 + _expressions.$5._columns;
    final decode6 = _expressions.$6._decode;
    final offset7 = offset6 + _expressions.$6._columns;
    final decode7 = _expressions.$7._decode;
    final offset8 = offset7 + _expressions.$7._columns;
    final decode8 = _expressions.$8._decode;
    final offset9 = offset8 + _expressions.$8._columns;
    final decode9 = _expressions.$9._decode;
    final offset10 = offset9 + _expressions.$9._columns;
    final decode10 = _expressions.$10._decode;
    final offset11 = offset10 + _expressions.$10._columns;
    final decode11 = _expressions.$11._decode;
    final (sql, columns, params) =
        _context._dialect.select(SelectStatement._(from));
    await for (final row in _context._db.query(sql, params)) {
      yield (
        decode1((i) => row[offset1 + i]),
        decode2((i) => row[offset2 + i]),
        decode3((i) => row[offset3 + i]),
        decode4((i) => row[offset4 + i]),
        decode5((i) => row[offset5 + i]),
        decode6((i) => row[offset6 + i]),
        decode7((i) => row[offset7 + i]),
        decode8((i) => row[offset8 + i]),
        decode9((i) => row[offset9 + i]),
        decode10((i) => row[offset10 + i]),
        decode11((i) => row[offset11 + i])
      );
    }
  }
}

extension Query12<A, B, C, D, E, F, G, H, I, J, K, L> on Query<
    (
      Expr<A>,
      Expr<B>,
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>,
      Expr<L>
    )> {
  (Object, T) _build<T>(
      T Function(
              Expr<A> a,
              Expr<B> b,
              Expr<C> c,
              Expr<D> d,
              Expr<E> e,
              Expr<F> f,
              Expr<G> g,
              Expr<H> h,
              Expr<I> i,
              Expr<J> j,
              Expr<K> k,
              Expr<L> l)
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
    offset += _expressions.$8._columns;
    final i = _expressions.$9._standin(offset, handle);
    offset += _expressions.$9._columns;
    final j = _expressions.$10._standin(offset, handle);
    offset += _expressions.$10._columns;
    final k = _expressions.$11._standin(offset, handle);
    offset += _expressions.$11._columns;
    final l = _expressions.$12._standin(offset, handle);
    return (handle, builder(a, b, c, d, e, f, g, h, i, j, k, l));
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
            Expr<H>,
            Expr<I>,
            Expr<J>,
            Expr<K>,
            Expr<L>
          )>
      where(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l)
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>
      )> orderBy<T>(
    Expr<T> Function(
            Expr<A> a,
            Expr<B> b,
            Expr<C> c,
            Expr<D> d,
            Expr<E> e,
            Expr<F> f,
            Expr<G> g,
            Expr<H> h,
            Expr<I> i,
            Expr<J> j,
            Expr<K> k,
            Expr<L> l)
        expressionBuilder, [
    bool descending = false,
  ]) {
    final (handle, orderBy) = _build(expressionBuilder);
    return _Query(
      _context,
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy, descending),
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>
      )> limit(int limit) => _Query(
        _context,
        _expressions,
        (e) => LimitClause._(_from(e), limit),
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>
      )> offset(int offset) => _Query(
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>
      )> get first => QuerySingle._(limit(1));
  Query<T> select<T extends Record>(
      T Function(
              Expr<A> a,
              Expr<B> b,
              Expr<C> c,
              Expr<D> d,
              Expr<E> e,
              Expr<F> f,
              Expr<G> g,
              Expr<H> h,
              Expr<I> i,
              Expr<J> j,
              Expr<K> k,
              Expr<L> l)
          projectionBuilder) {
    final (handle, projection) = _build(projectionBuilder);
    return _Query(
      _context,
      projection,
      (e) => SelectClause._(_from(_expressions.toList()), handle, e),
    );
  }

  Join<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>
      ),
      T> join<T extends Record>(Query<T> query) => Join._(this, query);
  Stream<(A, B, C, D, E, F, G, H, I, J, K, L)> fetch() async* {
    final from = _from(_expressions.toList());
    final offset1 = 0;
    final decode1 = _expressions.$1._decode;
    final offset2 = offset1 + _expressions.$1._columns;
    final decode2 = _expressions.$2._decode;
    final offset3 = offset2 + _expressions.$2._columns;
    final decode3 = _expressions.$3._decode;
    final offset4 = offset3 + _expressions.$3._columns;
    final decode4 = _expressions.$4._decode;
    final offset5 = offset4 + _expressions.$4._columns;
    final decode5 = _expressions.$5._decode;
    final offset6 = offset5 + _expressions.$5._columns;
    final decode6 = _expressions.$6._decode;
    final offset7 = offset6 + _expressions.$6._columns;
    final decode7 = _expressions.$7._decode;
    final offset8 = offset7 + _expressions.$7._columns;
    final decode8 = _expressions.$8._decode;
    final offset9 = offset8 + _expressions.$8._columns;
    final decode9 = _expressions.$9._decode;
    final offset10 = offset9 + _expressions.$9._columns;
    final decode10 = _expressions.$10._decode;
    final offset11 = offset10 + _expressions.$10._columns;
    final decode11 = _expressions.$11._decode;
    final offset12 = offset11 + _expressions.$11._columns;
    final decode12 = _expressions.$12._decode;
    final (sql, columns, params) =
        _context._dialect.select(SelectStatement._(from));
    await for (final row in _context._db.query(sql, params)) {
      yield (
        decode1((i) => row[offset1 + i]),
        decode2((i) => row[offset2 + i]),
        decode3((i) => row[offset3 + i]),
        decode4((i) => row[offset4 + i]),
        decode5((i) => row[offset5 + i]),
        decode6((i) => row[offset6 + i]),
        decode7((i) => row[offset7 + i]),
        decode8((i) => row[offset8 + i]),
        decode9((i) => row[offset9 + i]),
        decode10((i) => row[offset10 + i]),
        decode11((i) => row[offset11 + i]),
        decode12((i) => row[offset12 + i])
      );
    }
  }
}

extension Query13<A, B, C, D, E, F, G, H, I, J, K, L, M> on Query<
    (
      Expr<A>,
      Expr<B>,
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>,
      Expr<L>,
      Expr<M>
    )> {
  (Object, T) _build<T>(
      T Function(
              Expr<A> a,
              Expr<B> b,
              Expr<C> c,
              Expr<D> d,
              Expr<E> e,
              Expr<F> f,
              Expr<G> g,
              Expr<H> h,
              Expr<I> i,
              Expr<J> j,
              Expr<K> k,
              Expr<L> l,
              Expr<M> m)
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
    offset += _expressions.$8._columns;
    final i = _expressions.$9._standin(offset, handle);
    offset += _expressions.$9._columns;
    final j = _expressions.$10._standin(offset, handle);
    offset += _expressions.$10._columns;
    final k = _expressions.$11._standin(offset, handle);
    offset += _expressions.$11._columns;
    final l = _expressions.$12._standin(offset, handle);
    offset += _expressions.$12._columns;
    final m = _expressions.$13._standin(offset, handle);
    return (handle, builder(a, b, c, d, e, f, g, h, i, j, k, l, m));
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
            Expr<H>,
            Expr<I>,
            Expr<J>,
            Expr<K>,
            Expr<L>,
            Expr<M>
          )>
      where(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m)
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>
      )> orderBy<T>(
    Expr<T> Function(
            Expr<A> a,
            Expr<B> b,
            Expr<C> c,
            Expr<D> d,
            Expr<E> e,
            Expr<F> f,
            Expr<G> g,
            Expr<H> h,
            Expr<I> i,
            Expr<J> j,
            Expr<K> k,
            Expr<L> l,
            Expr<M> m)
        expressionBuilder, [
    bool descending = false,
  ]) {
    final (handle, orderBy) = _build(expressionBuilder);
    return _Query(
      _context,
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy, descending),
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>
      )> limit(int limit) => _Query(
        _context,
        _expressions,
        (e) => LimitClause._(_from(e), limit),
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>
      )> offset(int offset) => _Query(
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>
      )> get first => QuerySingle._(limit(1));
  Query<T> select<T extends Record>(
      T Function(
              Expr<A> a,
              Expr<B> b,
              Expr<C> c,
              Expr<D> d,
              Expr<E> e,
              Expr<F> f,
              Expr<G> g,
              Expr<H> h,
              Expr<I> i,
              Expr<J> j,
              Expr<K> k,
              Expr<L> l,
              Expr<M> m)
          projectionBuilder) {
    final (handle, projection) = _build(projectionBuilder);
    return _Query(
      _context,
      projection,
      (e) => SelectClause._(_from(_expressions.toList()), handle, e),
    );
  }

  Join<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>
      ),
      T> join<T extends Record>(Query<T> query) => Join._(this, query);
  Stream<(A, B, C, D, E, F, G, H, I, J, K, L, M)> fetch() async* {
    final from = _from(_expressions.toList());
    final offset1 = 0;
    final decode1 = _expressions.$1._decode;
    final offset2 = offset1 + _expressions.$1._columns;
    final decode2 = _expressions.$2._decode;
    final offset3 = offset2 + _expressions.$2._columns;
    final decode3 = _expressions.$3._decode;
    final offset4 = offset3 + _expressions.$3._columns;
    final decode4 = _expressions.$4._decode;
    final offset5 = offset4 + _expressions.$4._columns;
    final decode5 = _expressions.$5._decode;
    final offset6 = offset5 + _expressions.$5._columns;
    final decode6 = _expressions.$6._decode;
    final offset7 = offset6 + _expressions.$6._columns;
    final decode7 = _expressions.$7._decode;
    final offset8 = offset7 + _expressions.$7._columns;
    final decode8 = _expressions.$8._decode;
    final offset9 = offset8 + _expressions.$8._columns;
    final decode9 = _expressions.$9._decode;
    final offset10 = offset9 + _expressions.$9._columns;
    final decode10 = _expressions.$10._decode;
    final offset11 = offset10 + _expressions.$10._columns;
    final decode11 = _expressions.$11._decode;
    final offset12 = offset11 + _expressions.$11._columns;
    final decode12 = _expressions.$12._decode;
    final offset13 = offset12 + _expressions.$12._columns;
    final decode13 = _expressions.$13._decode;
    final (sql, columns, params) =
        _context._dialect.select(SelectStatement._(from));
    await for (final row in _context._db.query(sql, params)) {
      yield (
        decode1((i) => row[offset1 + i]),
        decode2((i) => row[offset2 + i]),
        decode3((i) => row[offset3 + i]),
        decode4((i) => row[offset4 + i]),
        decode5((i) => row[offset5 + i]),
        decode6((i) => row[offset6 + i]),
        decode7((i) => row[offset7 + i]),
        decode8((i) => row[offset8 + i]),
        decode9((i) => row[offset9 + i]),
        decode10((i) => row[offset10 + i]),
        decode11((i) => row[offset11 + i]),
        decode12((i) => row[offset12 + i]),
        decode13((i) => row[offset13 + i])
      );
    }
  }
}

extension Query14<A, B, C, D, E, F, G, H, I, J, K, L, M, N> on Query<
    (
      Expr<A>,
      Expr<B>,
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>,
      Expr<L>,
      Expr<M>,
      Expr<N>
    )> {
  (Object, T) _build<T>(
      T Function(
              Expr<A> a,
              Expr<B> b,
              Expr<C> c,
              Expr<D> d,
              Expr<E> e,
              Expr<F> f,
              Expr<G> g,
              Expr<H> h,
              Expr<I> i,
              Expr<J> j,
              Expr<K> k,
              Expr<L> l,
              Expr<M> m,
              Expr<N> n)
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
    offset += _expressions.$8._columns;
    final i = _expressions.$9._standin(offset, handle);
    offset += _expressions.$9._columns;
    final j = _expressions.$10._standin(offset, handle);
    offset += _expressions.$10._columns;
    final k = _expressions.$11._standin(offset, handle);
    offset += _expressions.$11._columns;
    final l = _expressions.$12._standin(offset, handle);
    offset += _expressions.$12._columns;
    final m = _expressions.$13._standin(offset, handle);
    offset += _expressions.$13._columns;
    final n = _expressions.$14._standin(offset, handle);
    return (handle, builder(a, b, c, d, e, f, g, h, i, j, k, l, m, n));
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
            Expr<H>,
            Expr<I>,
            Expr<J>,
            Expr<K>,
            Expr<L>,
            Expr<M>,
            Expr<N>
          )>
      where(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n)
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>
      )> orderBy<T>(
    Expr<T> Function(
            Expr<A> a,
            Expr<B> b,
            Expr<C> c,
            Expr<D> d,
            Expr<E> e,
            Expr<F> f,
            Expr<G> g,
            Expr<H> h,
            Expr<I> i,
            Expr<J> j,
            Expr<K> k,
            Expr<L> l,
            Expr<M> m,
            Expr<N> n)
        expressionBuilder, [
    bool descending = false,
  ]) {
    final (handle, orderBy) = _build(expressionBuilder);
    return _Query(
      _context,
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy, descending),
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>
      )> limit(int limit) => _Query(
        _context,
        _expressions,
        (e) => LimitClause._(_from(e), limit),
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>
      )> offset(int offset) => _Query(
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>
      )> get first => QuerySingle._(limit(1));
  Query<T> select<T extends Record>(
      T Function(
              Expr<A> a,
              Expr<B> b,
              Expr<C> c,
              Expr<D> d,
              Expr<E> e,
              Expr<F> f,
              Expr<G> g,
              Expr<H> h,
              Expr<I> i,
              Expr<J> j,
              Expr<K> k,
              Expr<L> l,
              Expr<M> m,
              Expr<N> n)
          projectionBuilder) {
    final (handle, projection) = _build(projectionBuilder);
    return _Query(
      _context,
      projection,
      (e) => SelectClause._(_from(_expressions.toList()), handle, e),
    );
  }

  Join<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>
      ),
      T> join<T extends Record>(Query<T> query) => Join._(this, query);
  Stream<(A, B, C, D, E, F, G, H, I, J, K, L, M, N)> fetch() async* {
    final from = _from(_expressions.toList());
    final offset1 = 0;
    final decode1 = _expressions.$1._decode;
    final offset2 = offset1 + _expressions.$1._columns;
    final decode2 = _expressions.$2._decode;
    final offset3 = offset2 + _expressions.$2._columns;
    final decode3 = _expressions.$3._decode;
    final offset4 = offset3 + _expressions.$3._columns;
    final decode4 = _expressions.$4._decode;
    final offset5 = offset4 + _expressions.$4._columns;
    final decode5 = _expressions.$5._decode;
    final offset6 = offset5 + _expressions.$5._columns;
    final decode6 = _expressions.$6._decode;
    final offset7 = offset6 + _expressions.$6._columns;
    final decode7 = _expressions.$7._decode;
    final offset8 = offset7 + _expressions.$7._columns;
    final decode8 = _expressions.$8._decode;
    final offset9 = offset8 + _expressions.$8._columns;
    final decode9 = _expressions.$9._decode;
    final offset10 = offset9 + _expressions.$9._columns;
    final decode10 = _expressions.$10._decode;
    final offset11 = offset10 + _expressions.$10._columns;
    final decode11 = _expressions.$11._decode;
    final offset12 = offset11 + _expressions.$11._columns;
    final decode12 = _expressions.$12._decode;
    final offset13 = offset12 + _expressions.$12._columns;
    final decode13 = _expressions.$13._decode;
    final offset14 = offset13 + _expressions.$13._columns;
    final decode14 = _expressions.$14._decode;
    final (sql, columns, params) =
        _context._dialect.select(SelectStatement._(from));
    await for (final row in _context._db.query(sql, params)) {
      yield (
        decode1((i) => row[offset1 + i]),
        decode2((i) => row[offset2 + i]),
        decode3((i) => row[offset3 + i]),
        decode4((i) => row[offset4 + i]),
        decode5((i) => row[offset5 + i]),
        decode6((i) => row[offset6 + i]),
        decode7((i) => row[offset7 + i]),
        decode8((i) => row[offset8 + i]),
        decode9((i) => row[offset9 + i]),
        decode10((i) => row[offset10 + i]),
        decode11((i) => row[offset11 + i]),
        decode12((i) => row[offset12 + i]),
        decode13((i) => row[offset13 + i]),
        decode14((i) => row[offset14 + i])
      );
    }
  }
}

extension Query15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> on Query<
    (
      Expr<A>,
      Expr<B>,
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>,
      Expr<L>,
      Expr<M>,
      Expr<N>,
      Expr<O>
    )> {
  (Object, T) _build<T>(
      T Function(
              Expr<A> a,
              Expr<B> b,
              Expr<C> c,
              Expr<D> d,
              Expr<E> e,
              Expr<F> f,
              Expr<G> g,
              Expr<H> h,
              Expr<I> i,
              Expr<J> j,
              Expr<K> k,
              Expr<L> l,
              Expr<M> m,
              Expr<N> n,
              Expr<O> o)
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
    offset += _expressions.$8._columns;
    final i = _expressions.$9._standin(offset, handle);
    offset += _expressions.$9._columns;
    final j = _expressions.$10._standin(offset, handle);
    offset += _expressions.$10._columns;
    final k = _expressions.$11._standin(offset, handle);
    offset += _expressions.$11._columns;
    final l = _expressions.$12._standin(offset, handle);
    offset += _expressions.$12._columns;
    final m = _expressions.$13._standin(offset, handle);
    offset += _expressions.$13._columns;
    final n = _expressions.$14._standin(offset, handle);
    offset += _expressions.$14._columns;
    final o = _expressions.$15._standin(offset, handle);
    return (handle, builder(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o));
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
            Expr<H>,
            Expr<I>,
            Expr<J>,
            Expr<K>,
            Expr<L>,
            Expr<M>,
            Expr<N>,
            Expr<O>
          )>
      where(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n,
                  Expr<O> o)
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>
      )> orderBy<T>(
    Expr<T> Function(
            Expr<A> a,
            Expr<B> b,
            Expr<C> c,
            Expr<D> d,
            Expr<E> e,
            Expr<F> f,
            Expr<G> g,
            Expr<H> h,
            Expr<I> i,
            Expr<J> j,
            Expr<K> k,
            Expr<L> l,
            Expr<M> m,
            Expr<N> n,
            Expr<O> o)
        expressionBuilder, [
    bool descending = false,
  ]) {
    final (handle, orderBy) = _build(expressionBuilder);
    return _Query(
      _context,
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy, descending),
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>
      )> limit(int limit) => _Query(
        _context,
        _expressions,
        (e) => LimitClause._(_from(e), limit),
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>
      )> offset(int offset) => _Query(
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>
      )> get first => QuerySingle._(limit(1));
  Query<T> select<T extends Record>(
      T Function(
              Expr<A> a,
              Expr<B> b,
              Expr<C> c,
              Expr<D> d,
              Expr<E> e,
              Expr<F> f,
              Expr<G> g,
              Expr<H> h,
              Expr<I> i,
              Expr<J> j,
              Expr<K> k,
              Expr<L> l,
              Expr<M> m,
              Expr<N> n,
              Expr<O> o)
          projectionBuilder) {
    final (handle, projection) = _build(projectionBuilder);
    return _Query(
      _context,
      projection,
      (e) => SelectClause._(_from(_expressions.toList()), handle, e),
    );
  }

  Join<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>
      ),
      T> join<T extends Record>(Query<T> query) => Join._(this, query);
  Stream<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O)> fetch() async* {
    final from = _from(_expressions.toList());
    final offset1 = 0;
    final decode1 = _expressions.$1._decode;
    final offset2 = offset1 + _expressions.$1._columns;
    final decode2 = _expressions.$2._decode;
    final offset3 = offset2 + _expressions.$2._columns;
    final decode3 = _expressions.$3._decode;
    final offset4 = offset3 + _expressions.$3._columns;
    final decode4 = _expressions.$4._decode;
    final offset5 = offset4 + _expressions.$4._columns;
    final decode5 = _expressions.$5._decode;
    final offset6 = offset5 + _expressions.$5._columns;
    final decode6 = _expressions.$6._decode;
    final offset7 = offset6 + _expressions.$6._columns;
    final decode7 = _expressions.$7._decode;
    final offset8 = offset7 + _expressions.$7._columns;
    final decode8 = _expressions.$8._decode;
    final offset9 = offset8 + _expressions.$8._columns;
    final decode9 = _expressions.$9._decode;
    final offset10 = offset9 + _expressions.$9._columns;
    final decode10 = _expressions.$10._decode;
    final offset11 = offset10 + _expressions.$10._columns;
    final decode11 = _expressions.$11._decode;
    final offset12 = offset11 + _expressions.$11._columns;
    final decode12 = _expressions.$12._decode;
    final offset13 = offset12 + _expressions.$12._columns;
    final decode13 = _expressions.$13._decode;
    final offset14 = offset13 + _expressions.$13._columns;
    final decode14 = _expressions.$14._decode;
    final offset15 = offset14 + _expressions.$14._columns;
    final decode15 = _expressions.$15._decode;
    final (sql, columns, params) =
        _context._dialect.select(SelectStatement._(from));
    await for (final row in _context._db.query(sql, params)) {
      yield (
        decode1((i) => row[offset1 + i]),
        decode2((i) => row[offset2 + i]),
        decode3((i) => row[offset3 + i]),
        decode4((i) => row[offset4 + i]),
        decode5((i) => row[offset5 + i]),
        decode6((i) => row[offset6 + i]),
        decode7((i) => row[offset7 + i]),
        decode8((i) => row[offset8 + i]),
        decode9((i) => row[offset9 + i]),
        decode10((i) => row[offset10 + i]),
        decode11((i) => row[offset11 + i]),
        decode12((i) => row[offset12 + i]),
        decode13((i) => row[offset13 + i]),
        decode14((i) => row[offset14 + i]),
        decode15((i) => row[offset15 + i])
      );
    }
  }
}

extension Query16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> on Query<
    (
      Expr<A>,
      Expr<B>,
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>,
      Expr<L>,
      Expr<M>,
      Expr<N>,
      Expr<O>,
      Expr<P>
    )> {
  (Object, T) _build<T>(
      T Function(
              Expr<A> a,
              Expr<B> b,
              Expr<C> c,
              Expr<D> d,
              Expr<E> e,
              Expr<F> f,
              Expr<G> g,
              Expr<H> h,
              Expr<I> i,
              Expr<J> j,
              Expr<K> k,
              Expr<L> l,
              Expr<M> m,
              Expr<N> n,
              Expr<O> o,
              Expr<P> p)
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
    offset += _expressions.$8._columns;
    final i = _expressions.$9._standin(offset, handle);
    offset += _expressions.$9._columns;
    final j = _expressions.$10._standin(offset, handle);
    offset += _expressions.$10._columns;
    final k = _expressions.$11._standin(offset, handle);
    offset += _expressions.$11._columns;
    final l = _expressions.$12._standin(offset, handle);
    offset += _expressions.$12._columns;
    final m = _expressions.$13._standin(offset, handle);
    offset += _expressions.$13._columns;
    final n = _expressions.$14._standin(offset, handle);
    offset += _expressions.$14._columns;
    final o = _expressions.$15._standin(offset, handle);
    offset += _expressions.$15._columns;
    final p = _expressions.$16._standin(offset, handle);
    return (handle, builder(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p));
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
            Expr<H>,
            Expr<I>,
            Expr<J>,
            Expr<K>,
            Expr<L>,
            Expr<M>,
            Expr<N>,
            Expr<O>,
            Expr<P>
          )>
      where(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n,
                  Expr<O> o,
                  Expr<P> p)
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>,
        Expr<P>
      )> orderBy<T>(
    Expr<T> Function(
            Expr<A> a,
            Expr<B> b,
            Expr<C> c,
            Expr<D> d,
            Expr<E> e,
            Expr<F> f,
            Expr<G> g,
            Expr<H> h,
            Expr<I> i,
            Expr<J> j,
            Expr<K> k,
            Expr<L> l,
            Expr<M> m,
            Expr<N> n,
            Expr<O> o,
            Expr<P> p)
        expressionBuilder, [
    bool descending = false,
  ]) {
    final (handle, orderBy) = _build(expressionBuilder);
    return _Query(
      _context,
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy, descending),
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>,
        Expr<P>
      )> limit(int limit) => _Query(
        _context,
        _expressions,
        (e) => LimitClause._(_from(e), limit),
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>,
        Expr<P>
      )> offset(int offset) => _Query(
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>,
        Expr<P>
      )> get first => QuerySingle._(limit(1));
  Query<T> select<T extends Record>(
      T Function(
              Expr<A> a,
              Expr<B> b,
              Expr<C> c,
              Expr<D> d,
              Expr<E> e,
              Expr<F> f,
              Expr<G> g,
              Expr<H> h,
              Expr<I> i,
              Expr<J> j,
              Expr<K> k,
              Expr<L> l,
              Expr<M> m,
              Expr<N> n,
              Expr<O> o,
              Expr<P> p)
          projectionBuilder) {
    final (handle, projection) = _build(projectionBuilder);
    return _Query(
      _context,
      projection,
      (e) => SelectClause._(_from(_expressions.toList()), handle, e),
    );
  }

  Join<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>,
        Expr<P>
      ),
      T> join<T extends Record>(Query<T> query) => Join._(this, query);
  Stream<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P)> fetch() async* {
    final from = _from(_expressions.toList());
    final offset1 = 0;
    final decode1 = _expressions.$1._decode;
    final offset2 = offset1 + _expressions.$1._columns;
    final decode2 = _expressions.$2._decode;
    final offset3 = offset2 + _expressions.$2._columns;
    final decode3 = _expressions.$3._decode;
    final offset4 = offset3 + _expressions.$3._columns;
    final decode4 = _expressions.$4._decode;
    final offset5 = offset4 + _expressions.$4._columns;
    final decode5 = _expressions.$5._decode;
    final offset6 = offset5 + _expressions.$5._columns;
    final decode6 = _expressions.$6._decode;
    final offset7 = offset6 + _expressions.$6._columns;
    final decode7 = _expressions.$7._decode;
    final offset8 = offset7 + _expressions.$7._columns;
    final decode8 = _expressions.$8._decode;
    final offset9 = offset8 + _expressions.$8._columns;
    final decode9 = _expressions.$9._decode;
    final offset10 = offset9 + _expressions.$9._columns;
    final decode10 = _expressions.$10._decode;
    final offset11 = offset10 + _expressions.$10._columns;
    final decode11 = _expressions.$11._decode;
    final offset12 = offset11 + _expressions.$11._columns;
    final decode12 = _expressions.$12._decode;
    final offset13 = offset12 + _expressions.$12._columns;
    final decode13 = _expressions.$13._decode;
    final offset14 = offset13 + _expressions.$13._columns;
    final decode14 = _expressions.$14._decode;
    final offset15 = offset14 + _expressions.$14._columns;
    final decode15 = _expressions.$15._decode;
    final offset16 = offset15 + _expressions.$15._columns;
    final decode16 = _expressions.$16._decode;
    final (sql, columns, params) =
        _context._dialect.select(SelectStatement._(from));
    await for (final row in _context._db.query(sql, params)) {
      yield (
        decode1((i) => row[offset1 + i]),
        decode2((i) => row[offset2 + i]),
        decode3((i) => row[offset3 + i]),
        decode4((i) => row[offset4 + i]),
        decode5((i) => row[offset5 + i]),
        decode6((i) => row[offset6 + i]),
        decode7((i) => row[offset7 + i]),
        decode8((i) => row[offset8 + i]),
        decode9((i) => row[offset9 + i]),
        decode10((i) => row[offset10 + i]),
        decode11((i) => row[offset11 + i]),
        decode12((i) => row[offset12 + i]),
        decode13((i) => row[offset13 + i]),
        decode14((i) => row[offset14 + i]),
        decode15((i) => row[offset15 + i]),
        decode16((i) => row[offset16 + i])
      );
    }
  }
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

extension Join1On8<A, B, C, D, E, F, G, H, I> on Join<(Expr<A>,),
    (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<I>)> {
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<I>)>
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
              _join._expressions.$8,
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
        Expr<H>,
        Expr<I>
      )> on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g, Expr<H> h, Expr<I> i)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join1On9<A, B, C, D, E, F, G, H, I, J> on Join<
    (Expr<A>,),
    (
      Expr<B>,
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>
    )> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>
      )> get all => _Query(
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
          _join._expressions.$8,
          _join._expressions.$9,
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
        Expr<H>,
        Expr<I>,
        Expr<J>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join1On10<A, B, C, D, E, F, G, H, I, J, K> on Join<
    (Expr<A>,),
    (
      Expr<B>,
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>
    )> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>
      )> get all => _Query(
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
          _join._expressions.$8,
          _join._expressions.$9,
          _join._expressions.$10,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join1On11<A, B, C, D, E, F, G, H, I, J, K, L> on Join<
    (Expr<A>,),
    (
      Expr<B>,
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>,
      Expr<L>
    )> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>
      )> get all => _Query(
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
          _join._expressions.$8,
          _join._expressions.$9,
          _join._expressions.$10,
          _join._expressions.$11,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join1On12<A, B, C, D, E, F, G, H, I, J, K, L, M> on Join<
    (Expr<A>,),
    (
      Expr<B>,
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>,
      Expr<L>,
      Expr<M>
    )> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>
      )> get all => _Query(
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
          _join._expressions.$8,
          _join._expressions.$9,
          _join._expressions.$10,
          _join._expressions.$11,
          _join._expressions.$12,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join1On13<A, B, C, D, E, F, G, H, I, J, K, L, M, N> on Join<
    (Expr<A>,),
    (
      Expr<B>,
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>,
      Expr<L>,
      Expr<M>,
      Expr<N>
    )> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>
      )> get all => _Query(
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
          _join._expressions.$8,
          _join._expressions.$9,
          _join._expressions.$10,
          _join._expressions.$11,
          _join._expressions.$12,
          _join._expressions.$13,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join1On14<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> on Join<
    (Expr<A>,),
    (
      Expr<B>,
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>,
      Expr<L>,
      Expr<M>,
      Expr<N>,
      Expr<O>
    )> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>
      )> get all => _Query(
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
          _join._expressions.$8,
          _join._expressions.$9,
          _join._expressions.$10,
          _join._expressions.$11,
          _join._expressions.$12,
          _join._expressions.$13,
          _join._expressions.$14,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n,
                  Expr<O> o)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join1On15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> on Join<
    (Expr<A>,),
    (
      Expr<B>,
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>,
      Expr<L>,
      Expr<M>,
      Expr<N>,
      Expr<O>,
      Expr<P>
    )> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>,
        Expr<P>
      )> get all => _Query(
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
          _join._expressions.$8,
          _join._expressions.$9,
          _join._expressions.$10,
          _join._expressions.$11,
          _join._expressions.$12,
          _join._expressions.$13,
          _join._expressions.$14,
          _join._expressions.$15,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>,
        Expr<P>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n,
                  Expr<O> o,
                  Expr<P> p)
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

extension Join2On7<A, B, C, D, E, F, G, H, I> on Join<(Expr<A>, Expr<B>),
    (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<I>)> {
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<I>)>
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
        Expr<H>,
        Expr<I>
      )> on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g, Expr<H> h, Expr<I> i)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join2On8<A, B, C, D, E, F, G, H, I, J> on Join<(Expr<A>, Expr<B>),
    (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<I>, Expr<J>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>
      )> get all => _Query(
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
          _join._expressions.$7,
          _join._expressions.$8,
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
        Expr<H>,
        Expr<I>,
        Expr<J>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join2On9<A, B, C, D, E, F, G, H, I, J, K> on Join<
    (Expr<A>, Expr<B>),
    (
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>
    )> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>
      )> get all => _Query(
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
          _join._expressions.$7,
          _join._expressions.$8,
          _join._expressions.$9,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join2On10<A, B, C, D, E, F, G, H, I, J, K, L> on Join<
    (Expr<A>, Expr<B>),
    (
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>,
      Expr<L>
    )> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>
      )> get all => _Query(
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
          _join._expressions.$7,
          _join._expressions.$8,
          _join._expressions.$9,
          _join._expressions.$10,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join2On11<A, B, C, D, E, F, G, H, I, J, K, L, M> on Join<
    (Expr<A>, Expr<B>),
    (
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>,
      Expr<L>,
      Expr<M>
    )> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>
      )> get all => _Query(
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
          _join._expressions.$7,
          _join._expressions.$8,
          _join._expressions.$9,
          _join._expressions.$10,
          _join._expressions.$11,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join2On12<A, B, C, D, E, F, G, H, I, J, K, L, M, N> on Join<
    (Expr<A>, Expr<B>),
    (
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>,
      Expr<L>,
      Expr<M>,
      Expr<N>
    )> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>
      )> get all => _Query(
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
          _join._expressions.$7,
          _join._expressions.$8,
          _join._expressions.$9,
          _join._expressions.$10,
          _join._expressions.$11,
          _join._expressions.$12,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join2On13<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> on Join<
    (Expr<A>, Expr<B>),
    (
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>,
      Expr<L>,
      Expr<M>,
      Expr<N>,
      Expr<O>
    )> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>
      )> get all => _Query(
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
          _join._expressions.$7,
          _join._expressions.$8,
          _join._expressions.$9,
          _join._expressions.$10,
          _join._expressions.$11,
          _join._expressions.$12,
          _join._expressions.$13,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n,
                  Expr<O> o)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join2On14<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> on Join<
    (Expr<A>, Expr<B>),
    (
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>,
      Expr<L>,
      Expr<M>,
      Expr<N>,
      Expr<O>,
      Expr<P>
    )> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>,
        Expr<P>
      )> get all => _Query(
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
          _join._expressions.$7,
          _join._expressions.$8,
          _join._expressions.$9,
          _join._expressions.$10,
          _join._expressions.$11,
          _join._expressions.$12,
          _join._expressions.$13,
          _join._expressions.$14,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>,
        Expr<P>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n,
                  Expr<O> o,
                  Expr<P> p)
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

extension Join3On6<A, B, C, D, E, F, G, H, I> on Join<
    (Expr<A>, Expr<B>, Expr<C>),
    (Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<I>)> {
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<I>)>
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
        Expr<H>,
        Expr<I>
      )> on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g, Expr<H> h, Expr<I> i)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join3On7<A, B, C, D, E, F, G, H, I, J> on Join<
    (Expr<A>, Expr<B>, Expr<C>),
    (Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<I>, Expr<J>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>
      )> get all => _Query(
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
        Expr<H>,
        Expr<I>,
        Expr<J>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join3On8<A, B, C, D, E, F, G, H, I, J, K> on Join<
    (Expr<A>, Expr<B>, Expr<C>),
    (Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<I>, Expr<J>, Expr<K>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>
      )> get all => _Query(
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
          _join._expressions.$6,
          _join._expressions.$7,
          _join._expressions.$8,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join3On9<A, B, C, D, E, F, G, H, I, J, K, L> on Join<
    (Expr<A>, Expr<B>, Expr<C>),
    (
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>,
      Expr<L>
    )> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>
      )> get all => _Query(
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
          _join._expressions.$6,
          _join._expressions.$7,
          _join._expressions.$8,
          _join._expressions.$9,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join3On10<A, B, C, D, E, F, G, H, I, J, K, L, M> on Join<
    (Expr<A>, Expr<B>, Expr<C>),
    (
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>,
      Expr<L>,
      Expr<M>
    )> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>
      )> get all => _Query(
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
          _join._expressions.$6,
          _join._expressions.$7,
          _join._expressions.$8,
          _join._expressions.$9,
          _join._expressions.$10,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join3On11<A, B, C, D, E, F, G, H, I, J, K, L, M, N> on Join<
    (Expr<A>, Expr<B>, Expr<C>),
    (
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>,
      Expr<L>,
      Expr<M>,
      Expr<N>
    )> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>
      )> get all => _Query(
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
          _join._expressions.$6,
          _join._expressions.$7,
          _join._expressions.$8,
          _join._expressions.$9,
          _join._expressions.$10,
          _join._expressions.$11,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join3On12<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> on Join<
    (Expr<A>, Expr<B>, Expr<C>),
    (
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>,
      Expr<L>,
      Expr<M>,
      Expr<N>,
      Expr<O>
    )> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>
      )> get all => _Query(
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
          _join._expressions.$6,
          _join._expressions.$7,
          _join._expressions.$8,
          _join._expressions.$9,
          _join._expressions.$10,
          _join._expressions.$11,
          _join._expressions.$12,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n,
                  Expr<O> o)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join3On13<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> on Join<
    (Expr<A>, Expr<B>, Expr<C>),
    (
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>,
      Expr<L>,
      Expr<M>,
      Expr<N>,
      Expr<O>,
      Expr<P>
    )> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>,
        Expr<P>
      )> get all => _Query(
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
          _join._expressions.$6,
          _join._expressions.$7,
          _join._expressions.$8,
          _join._expressions.$9,
          _join._expressions.$10,
          _join._expressions.$11,
          _join._expressions.$12,
          _join._expressions.$13,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>,
        Expr<P>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n,
                  Expr<O> o,
                  Expr<P> p)
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

extension Join4On5<A, B, C, D, E, F, G, H, I> on Join<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>),
    (Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<I>)> {
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<I>)>
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
        Expr<H>,
        Expr<I>
      )> on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g, Expr<H> h, Expr<I> i)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join4On6<A, B, C, D, E, F, G, H, I, J> on Join<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>),
    (Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<I>, Expr<J>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>
      )> get all => _Query(
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
        Expr<H>,
        Expr<I>,
        Expr<J>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join4On7<A, B, C, D, E, F, G, H, I, J, K> on Join<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>),
    (Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<I>, Expr<J>, Expr<K>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>
      )> get all => _Query(
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join4On8<A, B, C, D, E, F, G, H, I, J, K, L> on Join<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>),
    (Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<I>, Expr<J>, Expr<K>, Expr<L>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>
      )> get all => _Query(
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
          _join._expressions.$5,
          _join._expressions.$6,
          _join._expressions.$7,
          _join._expressions.$8,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join4On9<A, B, C, D, E, F, G, H, I, J, K, L, M> on Join<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>),
    (
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>,
      Expr<L>,
      Expr<M>
    )> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>
      )> get all => _Query(
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
          _join._expressions.$5,
          _join._expressions.$6,
          _join._expressions.$7,
          _join._expressions.$8,
          _join._expressions.$9,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join4On10<A, B, C, D, E, F, G, H, I, J, K, L, M, N> on Join<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>),
    (
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>,
      Expr<L>,
      Expr<M>,
      Expr<N>
    )> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>
      )> get all => _Query(
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
          _join._expressions.$5,
          _join._expressions.$6,
          _join._expressions.$7,
          _join._expressions.$8,
          _join._expressions.$9,
          _join._expressions.$10,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join4On11<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> on Join<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>),
    (
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>,
      Expr<L>,
      Expr<M>,
      Expr<N>,
      Expr<O>
    )> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>
      )> get all => _Query(
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
          _join._expressions.$5,
          _join._expressions.$6,
          _join._expressions.$7,
          _join._expressions.$8,
          _join._expressions.$9,
          _join._expressions.$10,
          _join._expressions.$11,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n,
                  Expr<O> o)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join4On12<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> on Join<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>),
    (
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>,
      Expr<L>,
      Expr<M>,
      Expr<N>,
      Expr<O>,
      Expr<P>
    )> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>,
        Expr<P>
      )> get all => _Query(
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
          _join._expressions.$5,
          _join._expressions.$6,
          _join._expressions.$7,
          _join._expressions.$8,
          _join._expressions.$9,
          _join._expressions.$10,
          _join._expressions.$11,
          _join._expressions.$12,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>,
        Expr<P>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n,
                  Expr<O> o,
                  Expr<P> p)
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

extension Join5On4<A, B, C, D, E, F, G, H, I> on Join<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>),
    (Expr<F>, Expr<G>, Expr<H>, Expr<I>)> {
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<I>)>
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
        Expr<H>,
        Expr<I>
      )> on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g, Expr<H> h, Expr<I> i)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join5On5<A, B, C, D, E, F, G, H, I, J> on Join<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>),
    (Expr<F>, Expr<G>, Expr<H>, Expr<I>, Expr<J>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>
      )> get all => _Query(
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
        Expr<H>,
        Expr<I>,
        Expr<J>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join5On6<A, B, C, D, E, F, G, H, I, J, K> on Join<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>),
    (Expr<F>, Expr<G>, Expr<H>, Expr<I>, Expr<J>, Expr<K>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>
      )> get all => _Query(
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join5On7<A, B, C, D, E, F, G, H, I, J, K, L> on Join<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>),
    (Expr<F>, Expr<G>, Expr<H>, Expr<I>, Expr<J>, Expr<K>, Expr<L>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>
      )> get all => _Query(
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join5On8<A, B, C, D, E, F, G, H, I, J, K, L, M> on Join<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>),
    (Expr<F>, Expr<G>, Expr<H>, Expr<I>, Expr<J>, Expr<K>, Expr<L>, Expr<M>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>
      )> get all => _Query(
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
          _join._expressions.$4,
          _join._expressions.$5,
          _join._expressions.$6,
          _join._expressions.$7,
          _join._expressions.$8,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join5On9<A, B, C, D, E, F, G, H, I, J, K, L, M, N> on Join<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>),
    (
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>,
      Expr<L>,
      Expr<M>,
      Expr<N>
    )> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>
      )> get all => _Query(
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
          _join._expressions.$4,
          _join._expressions.$5,
          _join._expressions.$6,
          _join._expressions.$7,
          _join._expressions.$8,
          _join._expressions.$9,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join5On10<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> on Join<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>),
    (
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>,
      Expr<L>,
      Expr<M>,
      Expr<N>,
      Expr<O>
    )> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>
      )> get all => _Query(
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
          _join._expressions.$4,
          _join._expressions.$5,
          _join._expressions.$6,
          _join._expressions.$7,
          _join._expressions.$8,
          _join._expressions.$9,
          _join._expressions.$10,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n,
                  Expr<O> o)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join5On11<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> on Join<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>),
    (
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>,
      Expr<L>,
      Expr<M>,
      Expr<N>,
      Expr<O>,
      Expr<P>
    )> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>,
        Expr<P>
      )> get all => _Query(
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
          _join._expressions.$4,
          _join._expressions.$5,
          _join._expressions.$6,
          _join._expressions.$7,
          _join._expressions.$8,
          _join._expressions.$9,
          _join._expressions.$10,
          _join._expressions.$11,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>,
        Expr<P>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n,
                  Expr<O> o,
                  Expr<P> p)
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

extension Join6On3<A, B, C, D, E, F, G, H, I> on Join<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>),
    (Expr<G>, Expr<H>, Expr<I>)> {
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<I>)>
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
        Expr<H>,
        Expr<I>
      )> on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g, Expr<H> h, Expr<I> i)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join6On4<A, B, C, D, E, F, G, H, I, J> on Join<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>),
    (Expr<G>, Expr<H>, Expr<I>, Expr<J>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>
      )> get all => _Query(
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
        Expr<H>,
        Expr<I>,
        Expr<J>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join6On5<A, B, C, D, E, F, G, H, I, J, K> on Join<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>),
    (Expr<G>, Expr<H>, Expr<I>, Expr<J>, Expr<K>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>
      )> get all => _Query(
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join6On6<A, B, C, D, E, F, G, H, I, J, K, L> on Join<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>),
    (Expr<G>, Expr<H>, Expr<I>, Expr<J>, Expr<K>, Expr<L>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>
      )> get all => _Query(
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join6On7<A, B, C, D, E, F, G, H, I, J, K, L, M> on Join<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>),
    (Expr<G>, Expr<H>, Expr<I>, Expr<J>, Expr<K>, Expr<L>, Expr<M>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>
      )> get all => _Query(
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join6On8<A, B, C, D, E, F, G, H, I, J, K, L, M, N> on Join<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>),
    (Expr<G>, Expr<H>, Expr<I>, Expr<J>, Expr<K>, Expr<L>, Expr<M>, Expr<N>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>
      )> get all => _Query(
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
          _join._expressions.$3,
          _join._expressions.$4,
          _join._expressions.$5,
          _join._expressions.$6,
          _join._expressions.$7,
          _join._expressions.$8,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join6On9<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> on Join<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>),
    (
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>,
      Expr<L>,
      Expr<M>,
      Expr<N>,
      Expr<O>
    )> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>
      )> get all => _Query(
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
          _join._expressions.$3,
          _join._expressions.$4,
          _join._expressions.$5,
          _join._expressions.$6,
          _join._expressions.$7,
          _join._expressions.$8,
          _join._expressions.$9,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n,
                  Expr<O> o)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join6On10<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> on Join<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>),
    (
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>,
      Expr<L>,
      Expr<M>,
      Expr<N>,
      Expr<O>,
      Expr<P>
    )> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>,
        Expr<P>
      )> get all => _Query(
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
          _join._expressions.$3,
          _join._expressions.$4,
          _join._expressions.$5,
          _join._expressions.$6,
          _join._expressions.$7,
          _join._expressions.$8,
          _join._expressions.$9,
          _join._expressions.$10,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>,
        Expr<P>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n,
                  Expr<O> o,
                  Expr<P> p)
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

extension Join7On2<A, B, C, D, E, F, G, H, I> on Join<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>),
    (Expr<H>, Expr<I>)> {
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<I>)>
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
        Expr<H>,
        Expr<I>
      )> on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g, Expr<H> h, Expr<I> i)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join7On3<A, B, C, D, E, F, G, H, I, J> on Join<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>),
    (Expr<H>, Expr<I>, Expr<J>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>
      )> get all => _Query(
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
        Expr<H>,
        Expr<I>,
        Expr<J>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join7On4<A, B, C, D, E, F, G, H, I, J, K> on Join<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>),
    (Expr<H>, Expr<I>, Expr<J>, Expr<K>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>
      )> get all => _Query(
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join7On5<A, B, C, D, E, F, G, H, I, J, K, L> on Join<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>),
    (Expr<H>, Expr<I>, Expr<J>, Expr<K>, Expr<L>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>
      )> get all => _Query(
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join7On6<A, B, C, D, E, F, G, H, I, J, K, L, M> on Join<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>),
    (Expr<H>, Expr<I>, Expr<J>, Expr<K>, Expr<L>, Expr<M>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>
      )> get all => _Query(
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join7On7<A, B, C, D, E, F, G, H, I, J, K, L, M, N> on Join<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>),
    (Expr<H>, Expr<I>, Expr<J>, Expr<K>, Expr<L>, Expr<M>, Expr<N>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>
      )> get all => _Query(
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join7On8<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> on Join<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>),
    (Expr<H>, Expr<I>, Expr<J>, Expr<K>, Expr<L>, Expr<M>, Expr<N>, Expr<O>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>
      )> get all => _Query(
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
          _join._expressions.$2,
          _join._expressions.$3,
          _join._expressions.$4,
          _join._expressions.$5,
          _join._expressions.$6,
          _join._expressions.$7,
          _join._expressions.$8,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n,
                  Expr<O> o)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join7On9<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> on Join<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>),
    (
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>,
      Expr<L>,
      Expr<M>,
      Expr<N>,
      Expr<O>,
      Expr<P>
    )> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>,
        Expr<P>
      )> get all => _Query(
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
          _join._expressions.$2,
          _join._expressions.$3,
          _join._expressions.$4,
          _join._expressions.$5,
          _join._expressions.$6,
          _join._expressions.$7,
          _join._expressions.$8,
          _join._expressions.$9,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>,
        Expr<P>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n,
                  Expr<O> o,
                  Expr<P> p)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join8On1<A, B, C, D, E, F, G, H, I> on Join<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>),
    (Expr<I>,)> {
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<I>)>
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
              _from._expressions.$8,
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
        Expr<H>,
        Expr<I>
      )> on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g, Expr<H> h, Expr<I> i)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join8On2<A, B, C, D, E, F, G, H, I, J> on Join<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>),
    (Expr<I>, Expr<J>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>
      )> get all => _Query(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _from._expressions.$3,
          _from._expressions.$4,
          _from._expressions.$5,
          _from._expressions.$6,
          _from._expressions.$7,
          _from._expressions.$8,
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
        Expr<H>,
        Expr<I>,
        Expr<J>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join8On3<A, B, C, D, E, F, G, H, I, J, K> on Join<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>),
    (Expr<I>, Expr<J>, Expr<K>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>
      )> get all => _Query(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _from._expressions.$3,
          _from._expressions.$4,
          _from._expressions.$5,
          _from._expressions.$6,
          _from._expressions.$7,
          _from._expressions.$8,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join8On4<A, B, C, D, E, F, G, H, I, J, K, L> on Join<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>),
    (Expr<I>, Expr<J>, Expr<K>, Expr<L>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>
      )> get all => _Query(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _from._expressions.$3,
          _from._expressions.$4,
          _from._expressions.$5,
          _from._expressions.$6,
          _from._expressions.$7,
          _from._expressions.$8,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join8On5<A, B, C, D, E, F, G, H, I, J, K, L, M> on Join<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>),
    (Expr<I>, Expr<J>, Expr<K>, Expr<L>, Expr<M>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>
      )> get all => _Query(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _from._expressions.$3,
          _from._expressions.$4,
          _from._expressions.$5,
          _from._expressions.$6,
          _from._expressions.$7,
          _from._expressions.$8,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join8On6<A, B, C, D, E, F, G, H, I, J, K, L, M, N> on Join<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>),
    (Expr<I>, Expr<J>, Expr<K>, Expr<L>, Expr<M>, Expr<N>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>
      )> get all => _Query(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _from._expressions.$3,
          _from._expressions.$4,
          _from._expressions.$5,
          _from._expressions.$6,
          _from._expressions.$7,
          _from._expressions.$8,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join8On7<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> on Join<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>),
    (Expr<I>, Expr<J>, Expr<K>, Expr<L>, Expr<M>, Expr<N>, Expr<O>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>
      )> get all => _Query(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _from._expressions.$3,
          _from._expressions.$4,
          _from._expressions.$5,
          _from._expressions.$6,
          _from._expressions.$7,
          _from._expressions.$8,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n,
                  Expr<O> o)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join8On8<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> on Join<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>),
    (Expr<I>, Expr<J>, Expr<K>, Expr<L>, Expr<M>, Expr<N>, Expr<O>, Expr<P>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>,
        Expr<P>
      )> get all => _Query(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _from._expressions.$3,
          _from._expressions.$4,
          _from._expressions.$5,
          _from._expressions.$6,
          _from._expressions.$7,
          _from._expressions.$8,
          _join._expressions.$1,
          _join._expressions.$2,
          _join._expressions.$3,
          _join._expressions.$4,
          _join._expressions.$5,
          _join._expressions.$6,
          _join._expressions.$7,
          _join._expressions.$8,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>,
        Expr<P>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n,
                  Expr<O> o,
                  Expr<P> p)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join9On1<A, B, C, D, E, F, G, H, I, J> on Join<
    (
      Expr<A>,
      Expr<B>,
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>
    ),
    (Expr<J>,)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>
      )> get all => _Query(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _from._expressions.$3,
          _from._expressions.$4,
          _from._expressions.$5,
          _from._expressions.$6,
          _from._expressions.$7,
          _from._expressions.$8,
          _from._expressions.$9,
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
        Expr<H>,
        Expr<I>,
        Expr<J>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join9On2<A, B, C, D, E, F, G, H, I, J, K> on Join<
    (
      Expr<A>,
      Expr<B>,
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>
    ),
    (Expr<J>, Expr<K>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>
      )> get all => _Query(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _from._expressions.$3,
          _from._expressions.$4,
          _from._expressions.$5,
          _from._expressions.$6,
          _from._expressions.$7,
          _from._expressions.$8,
          _from._expressions.$9,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join9On3<A, B, C, D, E, F, G, H, I, J, K, L> on Join<
    (
      Expr<A>,
      Expr<B>,
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>
    ),
    (Expr<J>, Expr<K>, Expr<L>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>
      )> get all => _Query(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _from._expressions.$3,
          _from._expressions.$4,
          _from._expressions.$5,
          _from._expressions.$6,
          _from._expressions.$7,
          _from._expressions.$8,
          _from._expressions.$9,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join9On4<A, B, C, D, E, F, G, H, I, J, K, L, M> on Join<
    (
      Expr<A>,
      Expr<B>,
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>
    ),
    (Expr<J>, Expr<K>, Expr<L>, Expr<M>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>
      )> get all => _Query(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _from._expressions.$3,
          _from._expressions.$4,
          _from._expressions.$5,
          _from._expressions.$6,
          _from._expressions.$7,
          _from._expressions.$8,
          _from._expressions.$9,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join9On5<A, B, C, D, E, F, G, H, I, J, K, L, M, N> on Join<
    (
      Expr<A>,
      Expr<B>,
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>
    ),
    (Expr<J>, Expr<K>, Expr<L>, Expr<M>, Expr<N>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>
      )> get all => _Query(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _from._expressions.$3,
          _from._expressions.$4,
          _from._expressions.$5,
          _from._expressions.$6,
          _from._expressions.$7,
          _from._expressions.$8,
          _from._expressions.$9,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join9On6<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> on Join<
    (
      Expr<A>,
      Expr<B>,
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>
    ),
    (Expr<J>, Expr<K>, Expr<L>, Expr<M>, Expr<N>, Expr<O>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>
      )> get all => _Query(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _from._expressions.$3,
          _from._expressions.$4,
          _from._expressions.$5,
          _from._expressions.$6,
          _from._expressions.$7,
          _from._expressions.$8,
          _from._expressions.$9,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n,
                  Expr<O> o)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join9On7<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> on Join<
    (
      Expr<A>,
      Expr<B>,
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>
    ),
    (Expr<J>, Expr<K>, Expr<L>, Expr<M>, Expr<N>, Expr<O>, Expr<P>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>,
        Expr<P>
      )> get all => _Query(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _from._expressions.$3,
          _from._expressions.$4,
          _from._expressions.$5,
          _from._expressions.$6,
          _from._expressions.$7,
          _from._expressions.$8,
          _from._expressions.$9,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>,
        Expr<P>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n,
                  Expr<O> o,
                  Expr<P> p)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join10On1<A, B, C, D, E, F, G, H, I, J, K> on Join<
    (
      Expr<A>,
      Expr<B>,
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>
    ),
    (Expr<K>,)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>
      )> get all => _Query(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _from._expressions.$3,
          _from._expressions.$4,
          _from._expressions.$5,
          _from._expressions.$6,
          _from._expressions.$7,
          _from._expressions.$8,
          _from._expressions.$9,
          _from._expressions.$10,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join10On2<A, B, C, D, E, F, G, H, I, J, K, L> on Join<
    (
      Expr<A>,
      Expr<B>,
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>
    ),
    (Expr<K>, Expr<L>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>
      )> get all => _Query(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _from._expressions.$3,
          _from._expressions.$4,
          _from._expressions.$5,
          _from._expressions.$6,
          _from._expressions.$7,
          _from._expressions.$8,
          _from._expressions.$9,
          _from._expressions.$10,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join10On3<A, B, C, D, E, F, G, H, I, J, K, L, M> on Join<
    (
      Expr<A>,
      Expr<B>,
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>
    ),
    (Expr<K>, Expr<L>, Expr<M>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>
      )> get all => _Query(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _from._expressions.$3,
          _from._expressions.$4,
          _from._expressions.$5,
          _from._expressions.$6,
          _from._expressions.$7,
          _from._expressions.$8,
          _from._expressions.$9,
          _from._expressions.$10,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join10On4<A, B, C, D, E, F, G, H, I, J, K, L, M, N> on Join<
    (
      Expr<A>,
      Expr<B>,
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>
    ),
    (Expr<K>, Expr<L>, Expr<M>, Expr<N>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>
      )> get all => _Query(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _from._expressions.$3,
          _from._expressions.$4,
          _from._expressions.$5,
          _from._expressions.$6,
          _from._expressions.$7,
          _from._expressions.$8,
          _from._expressions.$9,
          _from._expressions.$10,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join10On5<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> on Join<
    (
      Expr<A>,
      Expr<B>,
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>
    ),
    (Expr<K>, Expr<L>, Expr<M>, Expr<N>, Expr<O>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>
      )> get all => _Query(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _from._expressions.$3,
          _from._expressions.$4,
          _from._expressions.$5,
          _from._expressions.$6,
          _from._expressions.$7,
          _from._expressions.$8,
          _from._expressions.$9,
          _from._expressions.$10,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n,
                  Expr<O> o)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join10On6<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> on Join<
    (
      Expr<A>,
      Expr<B>,
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>
    ),
    (Expr<K>, Expr<L>, Expr<M>, Expr<N>, Expr<O>, Expr<P>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>,
        Expr<P>
      )> get all => _Query(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _from._expressions.$3,
          _from._expressions.$4,
          _from._expressions.$5,
          _from._expressions.$6,
          _from._expressions.$7,
          _from._expressions.$8,
          _from._expressions.$9,
          _from._expressions.$10,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>,
        Expr<P>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n,
                  Expr<O> o,
                  Expr<P> p)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join11On1<A, B, C, D, E, F, G, H, I, J, K, L> on Join<
    (
      Expr<A>,
      Expr<B>,
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>
    ),
    (Expr<L>,)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>
      )> get all => _Query(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _from._expressions.$3,
          _from._expressions.$4,
          _from._expressions.$5,
          _from._expressions.$6,
          _from._expressions.$7,
          _from._expressions.$8,
          _from._expressions.$9,
          _from._expressions.$10,
          _from._expressions.$11,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join11On2<A, B, C, D, E, F, G, H, I, J, K, L, M> on Join<
    (
      Expr<A>,
      Expr<B>,
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>
    ),
    (Expr<L>, Expr<M>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>
      )> get all => _Query(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _from._expressions.$3,
          _from._expressions.$4,
          _from._expressions.$5,
          _from._expressions.$6,
          _from._expressions.$7,
          _from._expressions.$8,
          _from._expressions.$9,
          _from._expressions.$10,
          _from._expressions.$11,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join11On3<A, B, C, D, E, F, G, H, I, J, K, L, M, N> on Join<
    (
      Expr<A>,
      Expr<B>,
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>
    ),
    (Expr<L>, Expr<M>, Expr<N>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>
      )> get all => _Query(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _from._expressions.$3,
          _from._expressions.$4,
          _from._expressions.$5,
          _from._expressions.$6,
          _from._expressions.$7,
          _from._expressions.$8,
          _from._expressions.$9,
          _from._expressions.$10,
          _from._expressions.$11,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join11On4<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> on Join<
    (
      Expr<A>,
      Expr<B>,
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>
    ),
    (Expr<L>, Expr<M>, Expr<N>, Expr<O>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>
      )> get all => _Query(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _from._expressions.$3,
          _from._expressions.$4,
          _from._expressions.$5,
          _from._expressions.$6,
          _from._expressions.$7,
          _from._expressions.$8,
          _from._expressions.$9,
          _from._expressions.$10,
          _from._expressions.$11,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n,
                  Expr<O> o)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join11On5<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> on Join<
    (
      Expr<A>,
      Expr<B>,
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>
    ),
    (Expr<L>, Expr<M>, Expr<N>, Expr<O>, Expr<P>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>,
        Expr<P>
      )> get all => _Query(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _from._expressions.$3,
          _from._expressions.$4,
          _from._expressions.$5,
          _from._expressions.$6,
          _from._expressions.$7,
          _from._expressions.$8,
          _from._expressions.$9,
          _from._expressions.$10,
          _from._expressions.$11,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>,
        Expr<P>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n,
                  Expr<O> o,
                  Expr<P> p)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join12On1<A, B, C, D, E, F, G, H, I, J, K, L, M> on Join<
    (
      Expr<A>,
      Expr<B>,
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>,
      Expr<L>
    ),
    (Expr<M>,)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>
      )> get all => _Query(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _from._expressions.$3,
          _from._expressions.$4,
          _from._expressions.$5,
          _from._expressions.$6,
          _from._expressions.$7,
          _from._expressions.$8,
          _from._expressions.$9,
          _from._expressions.$10,
          _from._expressions.$11,
          _from._expressions.$12,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join12On2<A, B, C, D, E, F, G, H, I, J, K, L, M, N> on Join<
    (
      Expr<A>,
      Expr<B>,
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>,
      Expr<L>
    ),
    (Expr<M>, Expr<N>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>
      )> get all => _Query(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _from._expressions.$3,
          _from._expressions.$4,
          _from._expressions.$5,
          _from._expressions.$6,
          _from._expressions.$7,
          _from._expressions.$8,
          _from._expressions.$9,
          _from._expressions.$10,
          _from._expressions.$11,
          _from._expressions.$12,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join12On3<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> on Join<
    (
      Expr<A>,
      Expr<B>,
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>,
      Expr<L>
    ),
    (Expr<M>, Expr<N>, Expr<O>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>
      )> get all => _Query(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _from._expressions.$3,
          _from._expressions.$4,
          _from._expressions.$5,
          _from._expressions.$6,
          _from._expressions.$7,
          _from._expressions.$8,
          _from._expressions.$9,
          _from._expressions.$10,
          _from._expressions.$11,
          _from._expressions.$12,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n,
                  Expr<O> o)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join12On4<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> on Join<
    (
      Expr<A>,
      Expr<B>,
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>,
      Expr<L>
    ),
    (Expr<M>, Expr<N>, Expr<O>, Expr<P>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>,
        Expr<P>
      )> get all => _Query(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _from._expressions.$3,
          _from._expressions.$4,
          _from._expressions.$5,
          _from._expressions.$6,
          _from._expressions.$7,
          _from._expressions.$8,
          _from._expressions.$9,
          _from._expressions.$10,
          _from._expressions.$11,
          _from._expressions.$12,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>,
        Expr<P>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n,
                  Expr<O> o,
                  Expr<P> p)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join13On1<A, B, C, D, E, F, G, H, I, J, K, L, M, N> on Join<
    (
      Expr<A>,
      Expr<B>,
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>,
      Expr<L>,
      Expr<M>
    ),
    (Expr<N>,)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>
      )> get all => _Query(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _from._expressions.$3,
          _from._expressions.$4,
          _from._expressions.$5,
          _from._expressions.$6,
          _from._expressions.$7,
          _from._expressions.$8,
          _from._expressions.$9,
          _from._expressions.$10,
          _from._expressions.$11,
          _from._expressions.$12,
          _from._expressions.$13,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join13On2<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> on Join<
    (
      Expr<A>,
      Expr<B>,
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>,
      Expr<L>,
      Expr<M>
    ),
    (Expr<N>, Expr<O>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>
      )> get all => _Query(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _from._expressions.$3,
          _from._expressions.$4,
          _from._expressions.$5,
          _from._expressions.$6,
          _from._expressions.$7,
          _from._expressions.$8,
          _from._expressions.$9,
          _from._expressions.$10,
          _from._expressions.$11,
          _from._expressions.$12,
          _from._expressions.$13,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n,
                  Expr<O> o)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join13On3<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> on Join<
    (
      Expr<A>,
      Expr<B>,
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>,
      Expr<L>,
      Expr<M>
    ),
    (Expr<N>, Expr<O>, Expr<P>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>,
        Expr<P>
      )> get all => _Query(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _from._expressions.$3,
          _from._expressions.$4,
          _from._expressions.$5,
          _from._expressions.$6,
          _from._expressions.$7,
          _from._expressions.$8,
          _from._expressions.$9,
          _from._expressions.$10,
          _from._expressions.$11,
          _from._expressions.$12,
          _from._expressions.$13,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>,
        Expr<P>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n,
                  Expr<O> o,
                  Expr<P> p)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join14On1<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> on Join<
    (
      Expr<A>,
      Expr<B>,
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>,
      Expr<L>,
      Expr<M>,
      Expr<N>
    ),
    (Expr<O>,)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>
      )> get all => _Query(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _from._expressions.$3,
          _from._expressions.$4,
          _from._expressions.$5,
          _from._expressions.$6,
          _from._expressions.$7,
          _from._expressions.$8,
          _from._expressions.$9,
          _from._expressions.$10,
          _from._expressions.$11,
          _from._expressions.$12,
          _from._expressions.$13,
          _from._expressions.$14,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n,
                  Expr<O> o)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join14On2<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> on Join<
    (
      Expr<A>,
      Expr<B>,
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>,
      Expr<L>,
      Expr<M>,
      Expr<N>
    ),
    (Expr<O>, Expr<P>)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>,
        Expr<P>
      )> get all => _Query(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _from._expressions.$3,
          _from._expressions.$4,
          _from._expressions.$5,
          _from._expressions.$6,
          _from._expressions.$7,
          _from._expressions.$8,
          _from._expressions.$9,
          _from._expressions.$10,
          _from._expressions.$11,
          _from._expressions.$12,
          _from._expressions.$13,
          _from._expressions.$14,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>,
        Expr<P>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n,
                  Expr<O> o,
                  Expr<P> p)
              conditionBuilder) =>
      all.where(conditionBuilder);
}

extension Join15On1<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> on Join<
    (
      Expr<A>,
      Expr<B>,
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>,
      Expr<L>,
      Expr<M>,
      Expr<N>,
      Expr<O>
    ),
    (Expr<P>,)> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>,
        Expr<P>
      )> get all => _Query(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _from._expressions.$3,
          _from._expressions.$4,
          _from._expressions.$5,
          _from._expressions.$6,
          _from._expressions.$7,
          _from._expressions.$8,
          _from._expressions.$9,
          _from._expressions.$10,
          _from._expressions.$11,
          _from._expressions.$12,
          _from._expressions.$13,
          _from._expressions.$14,
          _from._expressions.$15,
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>,
        Expr<P>
      )> on(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n,
                  Expr<O> o,
                  Expr<P> p)
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

extension QuerySingle9<A, B, C, D, E, F, G, H, I> on QuerySingle<
    (
      Expr<A>,
      Expr<B>,
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>
    )> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>
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
        Expr<H>,
        Expr<I>
      )> where(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g, Expr<H> h, Expr<I> i)
              conditionBuilder) =>
      asQuery.where(conditionBuilder).first;
  QuerySingle<T> select<T extends Record>(
          T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
                  Expr<F> f, Expr<G> g, Expr<H> h, Expr<I> i)
              projectionBuilder) =>
      QuerySingle._(asQuery.select(projectionBuilder));
  Future<(A, B, C, D, E, F, G, H, I)?> fetch() async =>
      (await asQuery.fetch().toList()).firstOrNull;
}

extension QuerySingle10<A, B, C, D, E, F, G, H, I, J> on QuerySingle<
    (
      Expr<A>,
      Expr<B>,
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>
    )> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>
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
        Expr<H>,
        Expr<I>,
        Expr<J>
      )> where(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j)
              conditionBuilder) =>
      asQuery.where(conditionBuilder).first;
  QuerySingle<T> select<T extends Record>(
          T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
                  Expr<F> f, Expr<G> g, Expr<H> h, Expr<I> i, Expr<J> j)
              projectionBuilder) =>
      QuerySingle._(asQuery.select(projectionBuilder));
  Future<(A, B, C, D, E, F, G, H, I, J)?> fetch() async =>
      (await asQuery.fetch().toList()).firstOrNull;
}

extension QuerySingle11<A, B, C, D, E, F, G, H, I, J, K> on QuerySingle<
    (
      Expr<A>,
      Expr<B>,
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>
    )> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>
      )> where(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k)
              conditionBuilder) =>
      asQuery.where(conditionBuilder).first;
  QuerySingle<T> select<T extends Record>(
          T Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k)
              projectionBuilder) =>
      QuerySingle._(asQuery.select(projectionBuilder));
  Future<(A, B, C, D, E, F, G, H, I, J, K)?> fetch() async =>
      (await asQuery.fetch().toList()).firstOrNull;
}

extension QuerySingle12<A, B, C, D, E, F, G, H, I, J, K, L> on QuerySingle<
    (
      Expr<A>,
      Expr<B>,
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>,
      Expr<L>
    )> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>
      )> where(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l)
              conditionBuilder) =>
      asQuery.where(conditionBuilder).first;
  QuerySingle<T> select<T extends Record>(
          T Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l)
              projectionBuilder) =>
      QuerySingle._(asQuery.select(projectionBuilder));
  Future<(A, B, C, D, E, F, G, H, I, J, K, L)?> fetch() async =>
      (await asQuery.fetch().toList()).firstOrNull;
}

extension QuerySingle13<A, B, C, D, E, F, G, H, I, J, K, L, M> on QuerySingle<
    (
      Expr<A>,
      Expr<B>,
      Expr<C>,
      Expr<D>,
      Expr<E>,
      Expr<F>,
      Expr<G>,
      Expr<H>,
      Expr<I>,
      Expr<J>,
      Expr<K>,
      Expr<L>,
      Expr<M>
    )> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>
      )> where(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m)
              conditionBuilder) =>
      asQuery.where(conditionBuilder).first;
  QuerySingle<T> select<T extends Record>(
          T Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m)
              projectionBuilder) =>
      QuerySingle._(asQuery.select(projectionBuilder));
  Future<(A, B, C, D, E, F, G, H, I, J, K, L, M)?> fetch() async =>
      (await asQuery.fetch().toList()).firstOrNull;
}

extension QuerySingle14<A, B, C, D, E, F, G, H, I, J, K, L, M, N>
    on QuerySingle<
        (
          Expr<A>,
          Expr<B>,
          Expr<C>,
          Expr<D>,
          Expr<E>,
          Expr<F>,
          Expr<G>,
          Expr<H>,
          Expr<I>,
          Expr<J>,
          Expr<K>,
          Expr<L>,
          Expr<M>,
          Expr<N>
        )> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>
      )> where(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n)
              conditionBuilder) =>
      asQuery.where(conditionBuilder).first;
  QuerySingle<T> select<T extends Record>(
          T Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n)
              projectionBuilder) =>
      QuerySingle._(asQuery.select(projectionBuilder));
  Future<(A, B, C, D, E, F, G, H, I, J, K, L, M, N)?> fetch() async =>
      (await asQuery.fetch().toList()).firstOrNull;
}

extension QuerySingle15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>
    on QuerySingle<
        (
          Expr<A>,
          Expr<B>,
          Expr<C>,
          Expr<D>,
          Expr<E>,
          Expr<F>,
          Expr<G>,
          Expr<H>,
          Expr<I>,
          Expr<J>,
          Expr<K>,
          Expr<L>,
          Expr<M>,
          Expr<N>,
          Expr<O>
        )> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>
      )> where(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n,
                  Expr<O> o)
              conditionBuilder) =>
      asQuery.where(conditionBuilder).first;
  QuerySingle<T> select<T extends Record>(
          T Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n,
                  Expr<O> o)
              projectionBuilder) =>
      QuerySingle._(asQuery.select(projectionBuilder));
  Future<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O)?> fetch() async =>
      (await asQuery.fetch().toList()).firstOrNull;
}

extension QuerySingle16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>
    on QuerySingle<
        (
          Expr<A>,
          Expr<B>,
          Expr<C>,
          Expr<D>,
          Expr<E>,
          Expr<F>,
          Expr<G>,
          Expr<H>,
          Expr<I>,
          Expr<J>,
          Expr<K>,
          Expr<L>,
          Expr<M>,
          Expr<N>,
          Expr<O>,
          Expr<P>
        )> {
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>,
        Expr<P>
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
        Expr<H>,
        Expr<I>,
        Expr<J>,
        Expr<K>,
        Expr<L>,
        Expr<M>,
        Expr<N>,
        Expr<O>,
        Expr<P>
      )> where(
          Expr<bool> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n,
                  Expr<O> o,
                  Expr<P> p)
              conditionBuilder) =>
      asQuery.where(conditionBuilder).first;
  QuerySingle<T> select<T extends Record>(
          T Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h,
                  Expr<I> i,
                  Expr<J> j,
                  Expr<K> k,
                  Expr<L> l,
                  Expr<M> m,
                  Expr<N> n,
                  Expr<O> o,
                  Expr<P> p)
              projectionBuilder) =>
      QuerySingle._(asQuery.select(projectionBuilder));
  Future<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P)?> fetch() async =>
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

extension<A, B, C, D, E, F, G, H, I> on (
  Expr<A>,
  Expr<B>,
  Expr<C>,
  Expr<D>,
  Expr<E>,
  Expr<F>,
  Expr<G>,
  Expr<H>,
  Expr<I>
) {
  List<Expr> toList() => [$1, $2, $3, $4, $5, $6, $7, $8, $9];
}

extension<A, B, C, D, E, F, G, H, I, J> on (
  Expr<A>,
  Expr<B>,
  Expr<C>,
  Expr<D>,
  Expr<E>,
  Expr<F>,
  Expr<G>,
  Expr<H>,
  Expr<I>,
  Expr<J>
) {
  List<Expr> toList() => [$1, $2, $3, $4, $5, $6, $7, $8, $9, $10];
}

extension<A, B, C, D, E, F, G, H, I, J, K> on (
  Expr<A>,
  Expr<B>,
  Expr<C>,
  Expr<D>,
  Expr<E>,
  Expr<F>,
  Expr<G>,
  Expr<H>,
  Expr<I>,
  Expr<J>,
  Expr<K>
) {
  List<Expr> toList() => [$1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11];
}

extension<A, B, C, D, E, F, G, H, I, J, K, L> on (
  Expr<A>,
  Expr<B>,
  Expr<C>,
  Expr<D>,
  Expr<E>,
  Expr<F>,
  Expr<G>,
  Expr<H>,
  Expr<I>,
  Expr<J>,
  Expr<K>,
  Expr<L>
) {
  List<Expr> toList() => [$1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12];
}

extension<A, B, C, D, E, F, G, H, I, J, K, L, M> on (
  Expr<A>,
  Expr<B>,
  Expr<C>,
  Expr<D>,
  Expr<E>,
  Expr<F>,
  Expr<G>,
  Expr<H>,
  Expr<I>,
  Expr<J>,
  Expr<K>,
  Expr<L>,
  Expr<M>
) {
  List<Expr> toList() =>
      [$1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13];
}

extension<A, B, C, D, E, F, G, H, I, J, K, L, M, N> on (
  Expr<A>,
  Expr<B>,
  Expr<C>,
  Expr<D>,
  Expr<E>,
  Expr<F>,
  Expr<G>,
  Expr<H>,
  Expr<I>,
  Expr<J>,
  Expr<K>,
  Expr<L>,
  Expr<M>,
  Expr<N>
) {
  List<Expr> toList() =>
      [$1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14];
}

extension<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> on (
  Expr<A>,
  Expr<B>,
  Expr<C>,
  Expr<D>,
  Expr<E>,
  Expr<F>,
  Expr<G>,
  Expr<H>,
  Expr<I>,
  Expr<J>,
  Expr<K>,
  Expr<L>,
  Expr<M>,
  Expr<N>,
  Expr<O>
) {
  List<Expr> toList() =>
      [$1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15];
}

extension<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> on (
  Expr<A>,
  Expr<B>,
  Expr<C>,
  Expr<D>,
  Expr<E>,
  Expr<F>,
  Expr<G>,
  Expr<H>,
  Expr<I>,
  Expr<J>,
  Expr<K>,
  Expr<L>,
  Expr<M>,
  Expr<N>,
  Expr<O>,
  Expr<P>
) {
  List<Expr> toList() =>
      [$1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16];
}
