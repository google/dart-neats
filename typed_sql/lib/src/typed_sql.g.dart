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

  Query<(Expr<A>,)> orderBy(
      List<(Expr<Comparable?>, Order)> Function(Expr<A> a) expressionBuilder) {
    final (handle, orderBy) = _build(expressionBuilder);
    return _Query(
      _context,
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy),
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
  QueryClause _castAs(Query<(Expr<A>,)> as) {
    final (handle, projection) = _build((a) => [
          if (a._type is _ExprType<Null>)
            ..._NullExprType._explodedCastAs(a, as._expressions.$1._type)
          else
            a
        ]);
    return SelectFromClause._(
      _from(_expressions.toList()),
      handle,
      projection,
    );
  }

  Query<(Expr<A>,)> union(Query<(Expr<A>,)> other) => _Query(
        _context,
        // What if this was implicitly cast from Query<(Expr<A>,)> to
        // Query<(Expr<A?>,)> which doesn't require a cast!
        // Now, it can't return null, but also I can't know this!
        _expressions, // TODO: Unclear if this right!
        (e) => UnionClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );
  Query<(Expr<A>,)> unionAll(Query<(Expr<A>,)> other) => _Query(
        _context,
        // What if this was implicitly cast from Query<(Expr<A>,)> to
        // Query<(Expr<A?>,)> which doesn't require a cast!
        // Now, it can't return null, but also I can't know this!
        _expressions, // TODO: Unclear if this right!
        (e) => UnionAllClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );
  Query<(Expr<A>,)> intersect(Query<(Expr<A>,)> other) => _Query(
        _context,
        // What if this was implicitly cast from Query<(Expr<A>,)> to
        // Query<(Expr<A?>,)> which doesn't require a cast!
        // Now, it can't return null, but also I can't know this!
        _expressions, // TODO: Unclear if this right!
        (e) => IntersectClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );
  Query<(Expr<A>,)> except(Query<(Expr<A>,)> other) => _Query(
        _context,
        // What if this was implicitly cast from Query<(Expr<A>,)> to
        // Query<(Expr<A?>,)> which doesn't require a cast!
        // Now, it can't return null, but also I can't know this!
        _expressions, // TODO: Unclear if this right!
        (e) => ExceptClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );
  Query<(Expr<A>,)> operator +(Query<(Expr<A>,)> other) => unionAll(other);
  Query<(Expr<A>,)> operator -(Query<(Expr<A>,)> other) => except(other);
  Query<(Expr<A>,)> operator &(Query<(Expr<A>,)> other) => intersect(other);
  Query<(Expr<A>,)> operator |(Query<(Expr<A>,)> other) => union(other);
  Group<T, (Expr<A>,)> groupBy<T extends Record>(
      T Function(Expr<A> a) groupBuilder) {
    final (handle, (group, standins)) = _build((a) {
      return (groupBuilder(a), (a,));
    });
    return Group._(this, handle, group, standins);
  }

  Stream<A> stream() async* {
    final from = _from(_expressions.toList());
    final decode1 = _expressions.$1._decode;
    final (sql, columns, params) =
        _context._dialect.select(SelectStatement._(from));
    await for (final row in _context._query(sql, params)) {
      yield decode1(row) as A;
    }
  }

  Future<List<A>> fetch() async => await stream().toList();
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

  SubQuery<(Expr<A>,)> orderBy(
      List<(Expr<Comparable?>, Order)> Function(Expr<A> a) expressionBuilder) {
    final (handle, orderBy) = _build(expressionBuilder);
    return SubQuery._(
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy),
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

  Query<(Expr<A>, Expr<B>)> orderBy(
      List<(Expr<Comparable?>, Order)> Function(Expr<A> a, Expr<B> b)
          expressionBuilder) {
    final (handle, orderBy) = _build(expressionBuilder);
    return _Query(
      _context,
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy),
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
  QueryClause _castAs(Query<(Expr<A>, Expr<B>)> as) {
    final (handle, projection) = _build((a, b) => [
          if (a._type is _ExprType<Null>)
            ..._NullExprType._explodedCastAs(a, as._expressions.$1._type)
          else
            a,
          if (b._type is _ExprType<Null>)
            ..._NullExprType._explodedCastAs(b, as._expressions.$2._type)
          else
            b
        ]);
    return SelectFromClause._(
      _from(_expressions.toList()),
      handle,
      projection,
    );
  }

  Query<(Expr<A>, Expr<B>)> union(Query<(Expr<A>, Expr<B>)> other) => _Query(
        _context,
        // What if this was implicitly cast from Query<(Expr<A>,)> to
        // Query<(Expr<A?>,)> which doesn't require a cast!
        // Now, it can't return null, but also I can't know this!
        _expressions, // TODO: Unclear if this right!
        (e) => UnionClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );
  Query<(Expr<A>, Expr<B>)> unionAll(Query<(Expr<A>, Expr<B>)> other) => _Query(
        _context,
        // What if this was implicitly cast from Query<(Expr<A>,)> to
        // Query<(Expr<A?>,)> which doesn't require a cast!
        // Now, it can't return null, but also I can't know this!
        _expressions, // TODO: Unclear if this right!
        (e) => UnionAllClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );
  Query<(Expr<A>, Expr<B>)> intersect(Query<(Expr<A>, Expr<B>)> other) =>
      _Query(
        _context,
        // What if this was implicitly cast from Query<(Expr<A>,)> to
        // Query<(Expr<A?>,)> which doesn't require a cast!
        // Now, it can't return null, but also I can't know this!
        _expressions, // TODO: Unclear if this right!
        (e) => IntersectClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );
  Query<(Expr<A>, Expr<B>)> except(Query<(Expr<A>, Expr<B>)> other) => _Query(
        _context,
        // What if this was implicitly cast from Query<(Expr<A>,)> to
        // Query<(Expr<A?>,)> which doesn't require a cast!
        // Now, it can't return null, but also I can't know this!
        _expressions, // TODO: Unclear if this right!
        (e) => ExceptClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );
  Query<(Expr<A>, Expr<B>)> operator +(Query<(Expr<A>, Expr<B>)> other) =>
      unionAll(other);
  Query<(Expr<A>, Expr<B>)> operator -(Query<(Expr<A>, Expr<B>)> other) =>
      except(other);
  Query<(Expr<A>, Expr<B>)> operator &(Query<(Expr<A>, Expr<B>)> other) =>
      intersect(other);
  Query<(Expr<A>, Expr<B>)> operator |(Query<(Expr<A>, Expr<B>)> other) =>
      union(other);
  Group<T, (Expr<A>, Expr<B>)> groupBy<T extends Record>(
      T Function(Expr<A> a, Expr<B> b) groupBuilder) {
    final (handle, (group, standins)) = _build((a, b) {
      return (
        groupBuilder(a, b),
        (
          a,
          b,
        )
      );
    });
    return Group._(this, handle, group, standins);
  }

  Stream<(A, B)> stream() async* {
    final from = _from(_expressions.toList());
    final decode1 = _expressions.$1._decode;
    final decode2 = _expressions.$2._decode;
    final (sql, columns, params) =
        _context._dialect.select(SelectStatement._(from));
    await for (final row in _context._query(sql, params)) {
      yield (decode1(row) as A, decode2(row) as B);
    }
  }

  Future<List<(A, B)>> fetch() async => await stream().toList();
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

  SubQuery<(Expr<A>, Expr<B>)> orderBy(
      List<(Expr<Comparable?>, Order)> Function(Expr<A> a, Expr<B> b)
          expressionBuilder) {
    final (handle, orderBy) = _build(expressionBuilder);
    return SubQuery._(
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy),
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

  Query<(Expr<A>, Expr<B>, Expr<C>)> orderBy(
      List<(Expr<Comparable?>, Order)> Function(Expr<A> a, Expr<B> b, Expr<C> c)
          expressionBuilder) {
    final (handle, orderBy) = _build(expressionBuilder);
    return _Query(
      _context,
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy),
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
  QueryClause _castAs(Query<(Expr<A>, Expr<B>, Expr<C>)> as) {
    final (handle, projection) = _build((a, b, c) => [
          if (a._type is _ExprType<Null>)
            ..._NullExprType._explodedCastAs(a, as._expressions.$1._type)
          else
            a,
          if (b._type is _ExprType<Null>)
            ..._NullExprType._explodedCastAs(b, as._expressions.$2._type)
          else
            b,
          if (c._type is _ExprType<Null>)
            ..._NullExprType._explodedCastAs(c, as._expressions.$3._type)
          else
            c
        ]);
    return SelectFromClause._(
      _from(_expressions.toList()),
      handle,
      projection,
    );
  }

  Query<(Expr<A>, Expr<B>, Expr<C>)> union(
          Query<(Expr<A>, Expr<B>, Expr<C>)> other) =>
      _Query(
        _context,
        // What if this was implicitly cast from Query<(Expr<A>,)> to
        // Query<(Expr<A?>,)> which doesn't require a cast!
        // Now, it can't return null, but also I can't know this!
        _expressions, // TODO: Unclear if this right!
        (e) => UnionClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );
  Query<(Expr<A>, Expr<B>, Expr<C>)> unionAll(
          Query<(Expr<A>, Expr<B>, Expr<C>)> other) =>
      _Query(
        _context,
        // What if this was implicitly cast from Query<(Expr<A>,)> to
        // Query<(Expr<A?>,)> which doesn't require a cast!
        // Now, it can't return null, but also I can't know this!
        _expressions, // TODO: Unclear if this right!
        (e) => UnionAllClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );
  Query<(Expr<A>, Expr<B>, Expr<C>)> intersect(
          Query<(Expr<A>, Expr<B>, Expr<C>)> other) =>
      _Query(
        _context,
        // What if this was implicitly cast from Query<(Expr<A>,)> to
        // Query<(Expr<A?>,)> which doesn't require a cast!
        // Now, it can't return null, but also I can't know this!
        _expressions, // TODO: Unclear if this right!
        (e) => IntersectClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );
  Query<(Expr<A>, Expr<B>, Expr<C>)> except(
          Query<(Expr<A>, Expr<B>, Expr<C>)> other) =>
      _Query(
        _context,
        // What if this was implicitly cast from Query<(Expr<A>,)> to
        // Query<(Expr<A?>,)> which doesn't require a cast!
        // Now, it can't return null, but also I can't know this!
        _expressions, // TODO: Unclear if this right!
        (e) => ExceptClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );
  Query<(Expr<A>, Expr<B>, Expr<C>)> operator +(
          Query<(Expr<A>, Expr<B>, Expr<C>)> other) =>
      unionAll(other);
  Query<(Expr<A>, Expr<B>, Expr<C>)> operator -(
          Query<(Expr<A>, Expr<B>, Expr<C>)> other) =>
      except(other);
  Query<(Expr<A>, Expr<B>, Expr<C>)> operator &(
          Query<(Expr<A>, Expr<B>, Expr<C>)> other) =>
      intersect(other);
  Query<(Expr<A>, Expr<B>, Expr<C>)> operator |(
          Query<(Expr<A>, Expr<B>, Expr<C>)> other) =>
      union(other);
  Group<T, (Expr<A>, Expr<B>, Expr<C>)> groupBy<T extends Record>(
      T Function(Expr<A> a, Expr<B> b, Expr<C> c) groupBuilder) {
    final (handle, (group, standins)) = _build((a, b, c) {
      return (
        groupBuilder(a, b, c),
        (
          a,
          b,
          c,
        )
      );
    });
    return Group._(this, handle, group, standins);
  }

  Stream<(A, B, C)> stream() async* {
    final from = _from(_expressions.toList());
    final decode1 = _expressions.$1._decode;
    final decode2 = _expressions.$2._decode;
    final decode3 = _expressions.$3._decode;
    final (sql, columns, params) =
        _context._dialect.select(SelectStatement._(from));
    await for (final row in _context._query(sql, params)) {
      yield (decode1(row) as A, decode2(row) as B, decode3(row) as C);
    }
  }

  Future<List<(A, B, C)>> fetch() async => await stream().toList();
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

  SubQuery<(Expr<A>, Expr<B>, Expr<C>)> orderBy(
      List<(Expr<Comparable?>, Order)> Function(Expr<A> a, Expr<B> b, Expr<C> c)
          expressionBuilder) {
    final (handle, orderBy) = _build(expressionBuilder);
    return SubQuery._(
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy),
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

  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> orderBy(
      List<(Expr<Comparable?>, Order)> Function(
              Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
          expressionBuilder) {
    final (handle, orderBy) = _build(expressionBuilder);
    return _Query(
      _context,
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy),
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
  QueryClause _castAs(Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> as) {
    final (handle, projection) = _build((a, b, c, d) => [
          if (a._type is _ExprType<Null>)
            ..._NullExprType._explodedCastAs(a, as._expressions.$1._type)
          else
            a,
          if (b._type is _ExprType<Null>)
            ..._NullExprType._explodedCastAs(b, as._expressions.$2._type)
          else
            b,
          if (c._type is _ExprType<Null>)
            ..._NullExprType._explodedCastAs(c, as._expressions.$3._type)
          else
            c,
          if (d._type is _ExprType<Null>)
            ..._NullExprType._explodedCastAs(d, as._expressions.$4._type)
          else
            d
        ]);
    return SelectFromClause._(
      _from(_expressions.toList()),
      handle,
      projection,
    );
  }

  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> union(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> other) =>
      _Query(
        _context,
        // What if this was implicitly cast from Query<(Expr<A>,)> to
        // Query<(Expr<A?>,)> which doesn't require a cast!
        // Now, it can't return null, but also I can't know this!
        _expressions, // TODO: Unclear if this right!
        (e) => UnionClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> unionAll(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> other) =>
      _Query(
        _context,
        // What if this was implicitly cast from Query<(Expr<A>,)> to
        // Query<(Expr<A?>,)> which doesn't require a cast!
        // Now, it can't return null, but also I can't know this!
        _expressions, // TODO: Unclear if this right!
        (e) => UnionAllClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> intersect(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> other) =>
      _Query(
        _context,
        // What if this was implicitly cast from Query<(Expr<A>,)> to
        // Query<(Expr<A?>,)> which doesn't require a cast!
        // Now, it can't return null, but also I can't know this!
        _expressions, // TODO: Unclear if this right!
        (e) => IntersectClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> except(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> other) =>
      _Query(
        _context,
        // What if this was implicitly cast from Query<(Expr<A>,)> to
        // Query<(Expr<A?>,)> which doesn't require a cast!
        // Now, it can't return null, but also I can't know this!
        _expressions, // TODO: Unclear if this right!
        (e) => ExceptClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> operator +(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> other) =>
      unionAll(other);
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> operator -(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> other) =>
      except(other);
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> operator &(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> other) =>
      intersect(other);
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> operator |(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> other) =>
      union(other);
  Group<T, (Expr<A>, Expr<B>, Expr<C>, Expr<D>)> groupBy<T extends Record>(
      T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d) groupBuilder) {
    final (handle, (group, standins)) = _build((a, b, c, d) {
      return (
        groupBuilder(a, b, c, d),
        (
          a,
          b,
          c,
          d,
        )
      );
    });
    return Group._(this, handle, group, standins);
  }

  Stream<(A, B, C, D)> stream() async* {
    final from = _from(_expressions.toList());
    final decode1 = _expressions.$1._decode;
    final decode2 = _expressions.$2._decode;
    final decode3 = _expressions.$3._decode;
    final decode4 = _expressions.$4._decode;
    final (sql, columns, params) =
        _context._dialect.select(SelectStatement._(from));
    await for (final row in _context._query(sql, params)) {
      yield (
        decode1(row) as A,
        decode2(row) as B,
        decode3(row) as C,
        decode4(row) as D
      );
    }
  }

  Future<List<(A, B, C, D)>> fetch() async => await stream().toList();
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

  SubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> orderBy(
      List<(Expr<Comparable?>, Order)> Function(
              Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
          expressionBuilder) {
    final (handle, orderBy) = _build(expressionBuilder);
    return SubQuery._(
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy),
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

  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> orderBy(
      List<(Expr<Comparable?>, Order)> Function(
              Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
          expressionBuilder) {
    final (handle, orderBy) = _build(expressionBuilder);
    return _Query(
      _context,
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy),
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
  QueryClause _castAs(Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> as) {
    final (handle, projection) = _build((a, b, c, d, e) => [
          if (a._type is _ExprType<Null>)
            ..._NullExprType._explodedCastAs(a, as._expressions.$1._type)
          else
            a,
          if (b._type is _ExprType<Null>)
            ..._NullExprType._explodedCastAs(b, as._expressions.$2._type)
          else
            b,
          if (c._type is _ExprType<Null>)
            ..._NullExprType._explodedCastAs(c, as._expressions.$3._type)
          else
            c,
          if (d._type is _ExprType<Null>)
            ..._NullExprType._explodedCastAs(d, as._expressions.$4._type)
          else
            d,
          if (e._type is _ExprType<Null>)
            ..._NullExprType._explodedCastAs(e, as._expressions.$5._type)
          else
            e
        ]);
    return SelectFromClause._(
      _from(_expressions.toList()),
      handle,
      projection,
    );
  }

  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> union(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> other) =>
      _Query(
        _context,
        // What if this was implicitly cast from Query<(Expr<A>,)> to
        // Query<(Expr<A?>,)> which doesn't require a cast!
        // Now, it can't return null, but also I can't know this!
        _expressions, // TODO: Unclear if this right!
        (e) => UnionClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> unionAll(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> other) =>
      _Query(
        _context,
        // What if this was implicitly cast from Query<(Expr<A>,)> to
        // Query<(Expr<A?>,)> which doesn't require a cast!
        // Now, it can't return null, but also I can't know this!
        _expressions, // TODO: Unclear if this right!
        (e) => UnionAllClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> intersect(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> other) =>
      _Query(
        _context,
        // What if this was implicitly cast from Query<(Expr<A>,)> to
        // Query<(Expr<A?>,)> which doesn't require a cast!
        // Now, it can't return null, but also I can't know this!
        _expressions, // TODO: Unclear if this right!
        (e) => IntersectClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> except(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> other) =>
      _Query(
        _context,
        // What if this was implicitly cast from Query<(Expr<A>,)> to
        // Query<(Expr<A?>,)> which doesn't require a cast!
        // Now, it can't return null, but also I can't know this!
        _expressions, // TODO: Unclear if this right!
        (e) => ExceptClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> operator +(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> other) =>
      unionAll(other);
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> operator -(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> other) =>
      except(other);
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> operator &(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> other) =>
      intersect(other);
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> operator |(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> other) =>
      union(other);
  Group<T, (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)>
      groupBy<T extends Record>(
          T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
              groupBuilder) {
    final (handle, (group, standins)) = _build((a, b, c, d, e) {
      return (
        groupBuilder(a, b, c, d, e),
        (
          a,
          b,
          c,
          d,
          e,
        )
      );
    });
    return Group._(this, handle, group, standins);
  }

  Stream<(A, B, C, D, E)> stream() async* {
    final from = _from(_expressions.toList());
    final decode1 = _expressions.$1._decode;
    final decode2 = _expressions.$2._decode;
    final decode3 = _expressions.$3._decode;
    final decode4 = _expressions.$4._decode;
    final decode5 = _expressions.$5._decode;
    final (sql, columns, params) =
        _context._dialect.select(SelectStatement._(from));
    await for (final row in _context._query(sql, params)) {
      yield (
        decode1(row) as A,
        decode2(row) as B,
        decode3(row) as C,
        decode4(row) as D,
        decode5(row) as E
      );
    }
  }

  Future<List<(A, B, C, D, E)>> fetch() async => await stream().toList();
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

  SubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> orderBy(
      List<(Expr<Comparable?>, Order)> Function(
              Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
          expressionBuilder) {
    final (handle, orderBy) = _build(expressionBuilder);
    return SubQuery._(
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy),
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

  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> orderBy(
      List<(Expr<Comparable?>, Order)> Function(
              Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f)
          expressionBuilder) {
    final (handle, orderBy) = _build(expressionBuilder);
    return _Query(
      _context,
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy),
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
  QueryClause _castAs(
      Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> as) {
    final (handle, projection) = _build((a, b, c, d, e, f) => [
          if (a._type is _ExprType<Null>)
            ..._NullExprType._explodedCastAs(a, as._expressions.$1._type)
          else
            a,
          if (b._type is _ExprType<Null>)
            ..._NullExprType._explodedCastAs(b, as._expressions.$2._type)
          else
            b,
          if (c._type is _ExprType<Null>)
            ..._NullExprType._explodedCastAs(c, as._expressions.$3._type)
          else
            c,
          if (d._type is _ExprType<Null>)
            ..._NullExprType._explodedCastAs(d, as._expressions.$4._type)
          else
            d,
          if (e._type is _ExprType<Null>)
            ..._NullExprType._explodedCastAs(e, as._expressions.$5._type)
          else
            e,
          if (f._type is _ExprType<Null>)
            ..._NullExprType._explodedCastAs(f, as._expressions.$6._type)
          else
            f
        ]);
    return SelectFromClause._(
      _from(_expressions.toList()),
      handle,
      projection,
    );
  }

  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> union(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)>
              other) =>
      _Query(
        _context,
        // What if this was implicitly cast from Query<(Expr<A>,)> to
        // Query<(Expr<A?>,)> which doesn't require a cast!
        // Now, it can't return null, but also I can't know this!
        _expressions, // TODO: Unclear if this right!
        (e) => UnionClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> unionAll(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)>
              other) =>
      _Query(
        _context,
        // What if this was implicitly cast from Query<(Expr<A>,)> to
        // Query<(Expr<A?>,)> which doesn't require a cast!
        // Now, it can't return null, but also I can't know this!
        _expressions, // TODO: Unclear if this right!
        (e) => UnionAllClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> intersect(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)>
              other) =>
      _Query(
        _context,
        // What if this was implicitly cast from Query<(Expr<A>,)> to
        // Query<(Expr<A?>,)> which doesn't require a cast!
        // Now, it can't return null, but also I can't know this!
        _expressions, // TODO: Unclear if this right!
        (e) => IntersectClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> except(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)>
              other) =>
      _Query(
        _context,
        // What if this was implicitly cast from Query<(Expr<A>,)> to
        // Query<(Expr<A?>,)> which doesn't require a cast!
        // Now, it can't return null, but also I can't know this!
        _expressions, // TODO: Unclear if this right!
        (e) => ExceptClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> operator +(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)>
              other) =>
      unionAll(other);
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> operator -(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)>
              other) =>
      except(other);
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> operator &(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)>
              other) =>
      intersect(other);
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> operator |(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)>
              other) =>
      union(other);
  Group<T, (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)>
      groupBy<T extends Record>(
          T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
                  Expr<F> f)
              groupBuilder) {
    final (handle, (group, standins)) = _build((a, b, c, d, e, f) {
      return (
        groupBuilder(a, b, c, d, e, f),
        (
          a,
          b,
          c,
          d,
          e,
          f,
        )
      );
    });
    return Group._(this, handle, group, standins);
  }

  Stream<(A, B, C, D, E, F)> stream() async* {
    final from = _from(_expressions.toList());
    final decode1 = _expressions.$1._decode;
    final decode2 = _expressions.$2._decode;
    final decode3 = _expressions.$3._decode;
    final decode4 = _expressions.$4._decode;
    final decode5 = _expressions.$5._decode;
    final decode6 = _expressions.$6._decode;
    final (sql, columns, params) =
        _context._dialect.select(SelectStatement._(from));
    await for (final row in _context._query(sql, params)) {
      yield (
        decode1(row) as A,
        decode2(row) as B,
        decode3(row) as C,
        decode4(row) as D,
        decode5(row) as E,
        decode6(row) as F
      );
    }
  }

  Future<List<(A, B, C, D, E, F)>> fetch() async => await stream().toList();
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

  SubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> orderBy(
      List<(Expr<Comparable?>, Order)> Function(
              Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f)
          expressionBuilder) {
    final (handle, orderBy) = _build(expressionBuilder);
    return SubQuery._(
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy),
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
      orderBy(
          List<(Expr<Comparable?>, Order)> Function(Expr<A> a, Expr<B> b,
                  Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f, Expr<G> g)
              expressionBuilder) {
    final (handle, orderBy) = _build(expressionBuilder);
    return _Query(
      _context,
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy),
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
  QueryClause _castAs(
      Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
          as) {
    final (handle, projection) = _build((a, b, c, d, e, f, g) => [
          if (a._type is _ExprType<Null>)
            ..._NullExprType._explodedCastAs(a, as._expressions.$1._type)
          else
            a,
          if (b._type is _ExprType<Null>)
            ..._NullExprType._explodedCastAs(b, as._expressions.$2._type)
          else
            b,
          if (c._type is _ExprType<Null>)
            ..._NullExprType._explodedCastAs(c, as._expressions.$3._type)
          else
            c,
          if (d._type is _ExprType<Null>)
            ..._NullExprType._explodedCastAs(d, as._expressions.$4._type)
          else
            d,
          if (e._type is _ExprType<Null>)
            ..._NullExprType._explodedCastAs(e, as._expressions.$5._type)
          else
            e,
          if (f._type is _ExprType<Null>)
            ..._NullExprType._explodedCastAs(f, as._expressions.$6._type)
          else
            f,
          if (g._type is _ExprType<Null>)
            ..._NullExprType._explodedCastAs(g, as._expressions.$7._type)
          else
            g
        ]);
    return SelectFromClause._(
      _from(_expressions.toList()),
      handle,
      projection,
    );
  }

  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> union(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
              other) =>
      _Query(
        _context,
        // What if this was implicitly cast from Query<(Expr<A>,)> to
        // Query<(Expr<A?>,)> which doesn't require a cast!
        // Now, it can't return null, but also I can't know this!
        _expressions, // TODO: Unclear if this right!
        (e) => UnionClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );
  Query<
      (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> unionAll(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
              other) =>
      _Query(
        _context,
        // What if this was implicitly cast from Query<(Expr<A>,)> to
        // Query<(Expr<A?>,)> which doesn't require a cast!
        // Now, it can't return null, but also I can't know this!
        _expressions, // TODO: Unclear if this right!
        (e) => UnionAllClause._(
          _from(_expressions.toList()),
          other._castAs(this),
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
        Expr<G>
      )> intersect(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
              other) =>
      _Query(
        _context,
        // What if this was implicitly cast from Query<(Expr<A>,)> to
        // Query<(Expr<A?>,)> which doesn't require a cast!
        // Now, it can't return null, but also I can't know this!
        _expressions, // TODO: Unclear if this right!
        (e) => IntersectClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> except(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
              other) =>
      _Query(
        _context,
        // What if this was implicitly cast from Query<(Expr<A>,)> to
        // Query<(Expr<A?>,)> which doesn't require a cast!
        // Now, it can't return null, but also I can't know this!
        _expressions, // TODO: Unclear if this right!
        (e) => ExceptClause._(
          _from(_expressions.toList()),
          other._castAs(this),
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
        Expr<G>
      )> operator +(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
              other) =>
      unionAll(other);
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>
      )> operator -(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
              other) =>
      except(other);
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>
      )> operator &(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
              other) =>
      intersect(other);
  Query<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>
      )> operator |(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
              other) =>
      union(other);
  Group<T, (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
      groupBy<T extends Record>(
          T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
                  Expr<F> f, Expr<G> g)
              groupBuilder) {
    final (handle, (group, standins)) = _build((a, b, c, d, e, f, g) {
      return (
        groupBuilder(a, b, c, d, e, f, g),
        (
          a,
          b,
          c,
          d,
          e,
          f,
          g,
        )
      );
    });
    return Group._(this, handle, group, standins);
  }

  Stream<(A, B, C, D, E, F, G)> stream() async* {
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
    await for (final row in _context._query(sql, params)) {
      yield (
        decode1(row) as A,
        decode2(row) as B,
        decode3(row) as C,
        decode4(row) as D,
        decode5(row) as E,
        decode6(row) as F,
        decode7(row) as G
      );
    }
  }

  Future<List<(A, B, C, D, E, F, G)>> fetch() async => await stream().toList();
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
      orderBy(
          List<(Expr<Comparable?>, Order)> Function(Expr<A> a, Expr<B> b,
                  Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f, Expr<G> g)
              expressionBuilder) {
    final (handle, orderBy) = _build(expressionBuilder);
    return SubQuery._(
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy),
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
          )>
      orderBy(
          List<(Expr<Comparable?>, Order)> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h)
              expressionBuilder) {
    final (handle, orderBy) = _build(expressionBuilder);
    return _Query(
      _context,
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy),
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
  QueryClause _castAs(
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
          as) {
    final (handle, projection) = _build((a, b, c, d, e, f, g, h) => [
          if (a._type is _ExprType<Null>)
            ..._NullExprType._explodedCastAs(a, as._expressions.$1._type)
          else
            a,
          if (b._type is _ExprType<Null>)
            ..._NullExprType._explodedCastAs(b, as._expressions.$2._type)
          else
            b,
          if (c._type is _ExprType<Null>)
            ..._NullExprType._explodedCastAs(c, as._expressions.$3._type)
          else
            c,
          if (d._type is _ExprType<Null>)
            ..._NullExprType._explodedCastAs(d, as._expressions.$4._type)
          else
            d,
          if (e._type is _ExprType<Null>)
            ..._NullExprType._explodedCastAs(e, as._expressions.$5._type)
          else
            e,
          if (f._type is _ExprType<Null>)
            ..._NullExprType._explodedCastAs(f, as._expressions.$6._type)
          else
            f,
          if (g._type is _ExprType<Null>)
            ..._NullExprType._explodedCastAs(g, as._expressions.$7._type)
          else
            g,
          if (h._type is _ExprType<Null>)
            ..._NullExprType._explodedCastAs(h, as._expressions.$8._type)
          else
            h
        ]);
    return SelectFromClause._(
      _from(_expressions.toList()),
      handle,
      projection,
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
      )> union(
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
              other) =>
      _Query(
        _context,
        // What if this was implicitly cast from Query<(Expr<A>,)> to
        // Query<(Expr<A?>,)> which doesn't require a cast!
        // Now, it can't return null, but also I can't know this!
        _expressions, // TODO: Unclear if this right!
        (e) => UnionClause._(
          _from(_expressions.toList()),
          other._castAs(this),
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
      )> unionAll(
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
              other) =>
      _Query(
        _context,
        // What if this was implicitly cast from Query<(Expr<A>,)> to
        // Query<(Expr<A?>,)> which doesn't require a cast!
        // Now, it can't return null, but also I can't know this!
        _expressions, // TODO: Unclear if this right!
        (e) => UnionAllClause._(
          _from(_expressions.toList()),
          other._castAs(this),
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
      )> intersect(
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
              other) =>
      _Query(
        _context,
        // What if this was implicitly cast from Query<(Expr<A>,)> to
        // Query<(Expr<A?>,)> which doesn't require a cast!
        // Now, it can't return null, but also I can't know this!
        _expressions, // TODO: Unclear if this right!
        (e) => IntersectClause._(
          _from(_expressions.toList()),
          other._castAs(this),
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
      )> except(
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
              other) =>
      _Query(
        _context,
        // What if this was implicitly cast from Query<(Expr<A>,)> to
        // Query<(Expr<A?>,)> which doesn't require a cast!
        // Now, it can't return null, but also I can't know this!
        _expressions, // TODO: Unclear if this right!
        (e) => ExceptClause._(
          _from(_expressions.toList()),
          other._castAs(this),
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
      )> operator +(
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
              other) =>
      unionAll(other);
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
      )> operator -(
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
              other) =>
      except(other);
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
      )> operator &(
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
              other) =>
      intersect(other);
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
      )> operator |(
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
              other) =>
      union(other);
  Group<
          T,
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
      groupBy<T extends Record>(
          T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
                  Expr<F> f, Expr<G> g, Expr<H> h)
              groupBuilder) {
    final (handle, (group, standins)) = _build((a, b, c, d, e, f, g, h) {
      return (
        groupBuilder(a, b, c, d, e, f, g, h),
        (
          a,
          b,
          c,
          d,
          e,
          f,
          g,
          h,
        )
      );
    });
    return Group._(this, handle, group, standins);
  }

  Stream<(A, B, C, D, E, F, G, H)> stream() async* {
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
    await for (final row in _context._query(sql, params)) {
      yield (
        decode1(row) as A,
        decode2(row) as B,
        decode3(row) as C,
        decode4(row) as D,
        decode5(row) as E,
        decode6(row) as F,
        decode7(row) as G,
        decode8(row) as H
      );
    }
  }

  Future<List<(A, B, C, D, E, F, G, H)>> fetch() async =>
      await stream().toList();
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
          )>
      orderBy(
          List<(Expr<Comparable?>, Order)> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h)
              expressionBuilder) {
    final (handle, orderBy) = _build(expressionBuilder);
    return SubQuery._(
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy),
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

extension Group1By1<A, B> on Group<(Expr<A>,), (Expr<B>,)> {
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<B>,), T> Function(
              Aggregation<(Expr<B>,), (Expr<A>,)> agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return _Query(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        _group.toList(),
        e,
      ),
    );
  }
}

extension Aggregate1Project1<A, B> on Aggregation<(Expr<A>,), (Expr<B>,)> {
  Aggregation<(Expr<A>,), (Expr<B>, Expr<C>)> _build<C, T>(
    Expr<T> Function(Expr<A> a) aggregateBuilder,
    Expr<C> Function(Expr<T> e) wrap,
  ) =>
      Aggregation._(
        _standins,
        (
          _projection.$1,
          wrap(aggregateBuilder(
            _standins.$1,
          )),
        ),
      );
  Aggregation<(Expr<A>,), (Expr<B>, Expr<C>)> sum<C extends num>(
          Expr<C?> Function(Expr<A> a) aggregateBuilder) =>
      _build(aggregateBuilder, SumExpression._);
  Aggregation<(Expr<A>,), (Expr<B>, Expr<double?>)> avg<C extends num>(
          Expr<C?> Function(Expr<A> a) aggregateBuilder) =>
      _build(aggregateBuilder, AvgExpression._);
  Aggregation<(Expr<A>,), (Expr<B>, Expr<C?>)> min<C extends Comparable>(
          Expr<C?> Function(Expr<A> a) aggregateBuilder) =>
      _build(aggregateBuilder, MinExpression._);
  Aggregation<(Expr<A>,), (Expr<B>, Expr<C?>)> max<C extends Comparable>(
          Expr<C?> Function(Expr<A> a) aggregateBuilder) =>
      _build(aggregateBuilder, MaxExpression._);
  Aggregation<(Expr<A>,), (Expr<B>, Expr<int>)> count() =>
      _build((a) => CountAllExpression._(), (a) => a);
}

extension Group2By1<A, B, C> on Group<(Expr<A>,), (Expr<B>, Expr<C>)> {
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<B>, Expr<C>), T> Function(
              Aggregation<(Expr<B>, Expr<C>), (Expr<A>,)> agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return _Query(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        _group.toList(),
        e,
      ),
    );
  }
}

extension Aggregate1Project2<A, B, C>
    on Aggregation<(Expr<A>,), (Expr<B>, Expr<C>)> {
  Aggregation<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D>)> _build<D, T>(
    Expr<T> Function(Expr<A> a) aggregateBuilder,
    Expr<D> Function(Expr<T> e) wrap,
  ) =>
      Aggregation._(
        _standins,
        (
          _projection.$1,
          _projection.$2,
          wrap(aggregateBuilder(
            _standins.$1,
          )),
        ),
      );
  Aggregation<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D>)> sum<D extends num>(
          Expr<D?> Function(Expr<A> a) aggregateBuilder) =>
      _build(aggregateBuilder, SumExpression._);
  Aggregation<(Expr<A>,), (Expr<B>, Expr<C>, Expr<double?>)> avg<D extends num>(
          Expr<D?> Function(Expr<A> a) aggregateBuilder) =>
      _build(aggregateBuilder, AvgExpression._);
  Aggregation<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D?>)>
      min<D extends Comparable>(
              Expr<D?> Function(Expr<A> a) aggregateBuilder) =>
          _build(aggregateBuilder, MinExpression._);
  Aggregation<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D?>)>
      max<D extends Comparable>(
              Expr<D?> Function(Expr<A> a) aggregateBuilder) =>
          _build(aggregateBuilder, MaxExpression._);
  Aggregation<(Expr<A>,), (Expr<B>, Expr<C>, Expr<int>)> count() =>
      _build((a) => CountAllExpression._(), (a) => a);
}

extension Group3By1<A, B, C, D>
    on Group<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D>)> {
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<B>, Expr<C>, Expr<D>), T> Function(
              Aggregation<(Expr<B>, Expr<C>, Expr<D>), (Expr<A>,)> agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return _Query(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        _group.toList(),
        e,
      ),
    );
  }
}

extension Aggregate1Project3<A, B, C, D>
    on Aggregation<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D>)> {
  Aggregation<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D>, Expr<E>)> _build<E, T>(
    Expr<T> Function(Expr<A> a) aggregateBuilder,
    Expr<E> Function(Expr<T> e) wrap,
  ) =>
      Aggregation._(
        _standins,
        (
          _projection.$1,
          _projection.$2,
          _projection.$3,
          wrap(aggregateBuilder(
            _standins.$1,
          )),
        ),
      );
  Aggregation<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D>, Expr<E>)>
      sum<E extends num>(Expr<E?> Function(Expr<A> a) aggregateBuilder) =>
          _build(aggregateBuilder, SumExpression._);
  Aggregation<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D>, Expr<double?>)>
      avg<E extends num>(Expr<E?> Function(Expr<A> a) aggregateBuilder) =>
          _build(aggregateBuilder, AvgExpression._);
  Aggregation<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D>, Expr<E?>)>
      min<E extends Comparable>(
              Expr<E?> Function(Expr<A> a) aggregateBuilder) =>
          _build(aggregateBuilder, MinExpression._);
  Aggregation<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D>, Expr<E?>)>
      max<E extends Comparable>(
              Expr<E?> Function(Expr<A> a) aggregateBuilder) =>
          _build(aggregateBuilder, MaxExpression._);
  Aggregation<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D>, Expr<int>)> count() =>
      _build((a) => CountAllExpression._(), (a) => a);
}

extension Group4By1<A, B, C, D, E>
    on Group<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D>, Expr<E>)> {
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<B>, Expr<C>, Expr<D>, Expr<E>), T> Function(
              Aggregation<(Expr<B>, Expr<C>, Expr<D>, Expr<E>), (Expr<A>,)> agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return _Query(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        _group.toList(),
        e,
      ),
    );
  }
}

extension Aggregate1Project4<A, B, C, D, E>
    on Aggregation<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D>, Expr<E>)> {
  Aggregation<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)>
      _build<F, T>(
    Expr<T> Function(Expr<A> a) aggregateBuilder,
    Expr<F> Function(Expr<T> e) wrap,
  ) =>
          Aggregation._(
            _standins,
            (
              _projection.$1,
              _projection.$2,
              _projection.$3,
              _projection.$4,
              wrap(aggregateBuilder(
                _standins.$1,
              )),
            ),
          );
  Aggregation<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)>
      sum<F extends num>(Expr<F?> Function(Expr<A> a) aggregateBuilder) =>
          _build(aggregateBuilder, SumExpression._);
  Aggregation<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<double?>)>
      avg<F extends num>(Expr<F?> Function(Expr<A> a) aggregateBuilder) =>
          _build(aggregateBuilder, AvgExpression._);
  Aggregation<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F?>)>
      min<F extends Comparable>(
              Expr<F?> Function(Expr<A> a) aggregateBuilder) =>
          _build(aggregateBuilder, MinExpression._);
  Aggregation<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F?>)>
      max<F extends Comparable>(
              Expr<F?> Function(Expr<A> a) aggregateBuilder) =>
          _build(aggregateBuilder, MaxExpression._);
  Aggregation<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<int>)>
      count() => _build((a) => CountAllExpression._(), (a) => a);
}

extension Group5By1<A, B, C, D, E, F>
    on Group<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> {
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>), T> Function(
              Aggregation<(Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>),
                      (Expr<A>,)>
                  agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return _Query(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        _group.toList(),
        e,
      ),
    );
  }
}

extension Aggregate1Project5<A, B, C, D, E, F>
    on Aggregation<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> {
  Aggregation<(Expr<A>,),
      (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> _build<G, T>(
    Expr<T> Function(Expr<A> a) aggregateBuilder,
    Expr<G> Function(Expr<T> e) wrap,
  ) =>
      Aggregation._(
        _standins,
        (
          _projection.$1,
          _projection.$2,
          _projection.$3,
          _projection.$4,
          _projection.$5,
          wrap(aggregateBuilder(
            _standins.$1,
          )),
        ),
      );
  Aggregation<(Expr<A>,),
          (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
      sum<G extends num>(Expr<G?> Function(Expr<A> a) aggregateBuilder) =>
          _build(aggregateBuilder, SumExpression._);
  Aggregation<(Expr<A>,),
          (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<double?>)>
      avg<G extends num>(Expr<G?> Function(Expr<A> a) aggregateBuilder) =>
          _build(aggregateBuilder, AvgExpression._);
  Aggregation<(Expr<A>,),
          (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G?>)>
      min<G extends Comparable>(
              Expr<G?> Function(Expr<A> a) aggregateBuilder) =>
          _build(aggregateBuilder, MinExpression._);
  Aggregation<(Expr<A>,),
          (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G?>)>
      max<G extends Comparable>(
              Expr<G?> Function(Expr<A> a) aggregateBuilder) =>
          _build(aggregateBuilder, MaxExpression._);
  Aggregation<(Expr<A>,),
          (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<int>)>
      count() => _build((a) => CountAllExpression._(), (a) => a);
}

extension Group6By1<A, B, C, D, E, F, G> on Group<(Expr<A>,),
    (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> {
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>), T> Function(
              Aggregation<
                      (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>),
                      (Expr<A>,)>
                  agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return _Query(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        _group.toList(),
        e,
      ),
    );
  }
}

extension Aggregate1Project6<A, B, C, D, E, F, G> on Aggregation<(Expr<A>,),
    (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> {
  Aggregation<(Expr<A>,),
          (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)>
      _build<H, T>(
    Expr<T> Function(Expr<A> a) aggregateBuilder,
    Expr<H> Function(Expr<T> e) wrap,
  ) =>
          Aggregation._(
            _standins,
            (
              _projection.$1,
              _projection.$2,
              _projection.$3,
              _projection.$4,
              _projection.$5,
              _projection.$6,
              wrap(aggregateBuilder(
                _standins.$1,
              )),
            ),
          );
  Aggregation<(Expr<A>,),
          (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)>
      sum<H extends num>(Expr<H?> Function(Expr<A> a) aggregateBuilder) =>
          _build(aggregateBuilder, SumExpression._);
  Aggregation<(Expr<A>,),
          (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<double?>)>
      avg<H extends num>(Expr<H?> Function(Expr<A> a) aggregateBuilder) =>
          _build(aggregateBuilder, AvgExpression._);
  Aggregation<(Expr<A>,),
          (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H?>)>
      min<H extends Comparable>(
              Expr<H?> Function(Expr<A> a) aggregateBuilder) =>
          _build(aggregateBuilder, MinExpression._);
  Aggregation<(Expr<A>,),
          (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H?>)>
      max<H extends Comparable>(
              Expr<H?> Function(Expr<A> a) aggregateBuilder) =>
          _build(aggregateBuilder, MaxExpression._);
  Aggregation<(Expr<A>,),
          (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<int>)>
      count() => _build((a) => CountAllExpression._(), (a) => a);
}

extension Group7By1<A, B, C, D, E, F, G, H> on Group<(Expr<A>,),
    (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)> {
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>), T> Function(
              Aggregation<
                      (
                        Expr<B>,
                        Expr<C>,
                        Expr<D>,
                        Expr<E>,
                        Expr<F>,
                        Expr<G>,
                        Expr<H>
                      ),
                      (Expr<A>,)>
                  agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return _Query(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        _group.toList(),
        e,
      ),
    );
  }
}

extension Aggregate1Project7<A, B, C, D, E, F, G, H> on Aggregation<(Expr<A>,),
    (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)> {
  Aggregation<
      (Expr<A>,),
      (
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>
      )> _build<I, T>(
    Expr<T> Function(Expr<A> a) aggregateBuilder,
    Expr<I> Function(Expr<T> e) wrap,
  ) =>
      Aggregation._(
        _standins,
        (
          _projection.$1,
          _projection.$2,
          _projection.$3,
          _projection.$4,
          _projection.$5,
          _projection.$6,
          _projection.$7,
          wrap(aggregateBuilder(
            _standins.$1,
          )),
        ),
      );
  Aggregation<
      (Expr<A>,),
      (
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I>
      )> sum<I extends num>(
          Expr<I?> Function(Expr<A> a) aggregateBuilder) =>
      _build(aggregateBuilder, SumExpression._);
  Aggregation<
      (Expr<A>,),
      (
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<double?>
      )> avg<I extends num>(
          Expr<I?> Function(Expr<A> a) aggregateBuilder) =>
      _build(aggregateBuilder, AvgExpression._);
  Aggregation<
      (Expr<A>,),
      (
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I?>
      )> min<I extends Comparable>(
          Expr<I?> Function(Expr<A> a) aggregateBuilder) =>
      _build(aggregateBuilder, MinExpression._);
  Aggregation<
      (Expr<A>,),
      (
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<I?>
      )> max<I extends Comparable>(
          Expr<I?> Function(Expr<A> a) aggregateBuilder) =>
      _build(aggregateBuilder, MaxExpression._);
  Aggregation<
      (Expr<A>,),
      (
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>,
        Expr<int>
      )> count() => _build((a) => CountAllExpression._(), (a) => a);
}

extension Group1By2<A, B, C> on Group<(Expr<A>, Expr<B>), (Expr<C>,)> {
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<C>,), T> Function(
              Aggregation<(Expr<C>,), (Expr<A>, Expr<B>)> agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return _Query(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        _group.toList(),
        e,
      ),
    );
  }
}

extension Aggregate2Project1<A, B, C>
    on Aggregation<(Expr<A>, Expr<B>), (Expr<C>,)> {
  Aggregation<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>)> _build<D, T>(
    Expr<T> Function(Expr<A> a, Expr<B> b) aggregateBuilder,
    Expr<D> Function(Expr<T> e) wrap,
  ) =>
      Aggregation._(
        _standins,
        (
          _projection.$1,
          wrap(aggregateBuilder(
            _standins.$1,
            _standins.$2,
          )),
        ),
      );
  Aggregation<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>)> sum<D extends num>(
          Expr<D?> Function(Expr<A> a, Expr<B> b) aggregateBuilder) =>
      _build(aggregateBuilder, SumExpression._);
  Aggregation<(Expr<A>, Expr<B>), (Expr<C>, Expr<double?>)> avg<D extends num>(
          Expr<D?> Function(Expr<A> a, Expr<B> b) aggregateBuilder) =>
      _build(aggregateBuilder, AvgExpression._);
  Aggregation<(Expr<A>, Expr<B>), (Expr<C>, Expr<D?>)>
      min<D extends Comparable>(
              Expr<D?> Function(Expr<A> a, Expr<B> b) aggregateBuilder) =>
          _build(aggregateBuilder, MinExpression._);
  Aggregation<(Expr<A>, Expr<B>), (Expr<C>, Expr<D?>)>
      max<D extends Comparable>(
              Expr<D?> Function(Expr<A> a, Expr<B> b) aggregateBuilder) =>
          _build(aggregateBuilder, MaxExpression._);
  Aggregation<(Expr<A>, Expr<B>), (Expr<C>, Expr<int>)> count() =>
      _build((a, b) => CountAllExpression._(), (a) => a);
}

extension Group2By2<A, B, C, D>
    on Group<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>)> {
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<C>, Expr<D>), T> Function(
              Aggregation<(Expr<C>, Expr<D>), (Expr<A>, Expr<B>)> agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return _Query(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        _group.toList(),
        e,
      ),
    );
  }
}

extension Aggregate2Project2<A, B, C, D>
    on Aggregation<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>)> {
  Aggregation<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>, Expr<E>)> _build<E, T>(
    Expr<T> Function(Expr<A> a, Expr<B> b) aggregateBuilder,
    Expr<E> Function(Expr<T> e) wrap,
  ) =>
      Aggregation._(
        _standins,
        (
          _projection.$1,
          _projection.$2,
          wrap(aggregateBuilder(
            _standins.$1,
            _standins.$2,
          )),
        ),
      );
  Aggregation<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>, Expr<E>)>
      sum<E extends num>(
              Expr<E?> Function(Expr<A> a, Expr<B> b) aggregateBuilder) =>
          _build(aggregateBuilder, SumExpression._);
  Aggregation<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>, Expr<double?>)>
      avg<E extends num>(
              Expr<E?> Function(Expr<A> a, Expr<B> b) aggregateBuilder) =>
          _build(aggregateBuilder, AvgExpression._);
  Aggregation<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>, Expr<E?>)>
      min<E extends Comparable>(
              Expr<E?> Function(Expr<A> a, Expr<B> b) aggregateBuilder) =>
          _build(aggregateBuilder, MinExpression._);
  Aggregation<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>, Expr<E?>)>
      max<E extends Comparable>(
              Expr<E?> Function(Expr<A> a, Expr<B> b) aggregateBuilder) =>
          _build(aggregateBuilder, MaxExpression._);
  Aggregation<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>, Expr<int>)> count() =>
      _build((a, b) => CountAllExpression._(), (a) => a);
}

extension Group3By2<A, B, C, D, E>
    on Group<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>, Expr<E>)> {
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<C>, Expr<D>, Expr<E>), T> Function(
              Aggregation<(Expr<C>, Expr<D>, Expr<E>), (Expr<A>, Expr<B>)> agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return _Query(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        _group.toList(),
        e,
      ),
    );
  }
}

extension Aggregate2Project3<A, B, C, D, E>
    on Aggregation<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>, Expr<E>)> {
  Aggregation<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>, Expr<E>, Expr<F>)>
      _build<F, T>(
    Expr<T> Function(Expr<A> a, Expr<B> b) aggregateBuilder,
    Expr<F> Function(Expr<T> e) wrap,
  ) =>
          Aggregation._(
            _standins,
            (
              _projection.$1,
              _projection.$2,
              _projection.$3,
              wrap(aggregateBuilder(
                _standins.$1,
                _standins.$2,
              )),
            ),
          );
  Aggregation<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>, Expr<E>, Expr<F>)>
      sum<F extends num>(
              Expr<F?> Function(Expr<A> a, Expr<B> b) aggregateBuilder) =>
          _build(aggregateBuilder, SumExpression._);
  Aggregation<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>, Expr<E>, Expr<double?>)>
      avg<F extends num>(
              Expr<F?> Function(Expr<A> a, Expr<B> b) aggregateBuilder) =>
          _build(aggregateBuilder, AvgExpression._);
  Aggregation<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>, Expr<E>, Expr<F?>)>
      min<F extends Comparable>(
              Expr<F?> Function(Expr<A> a, Expr<B> b) aggregateBuilder) =>
          _build(aggregateBuilder, MinExpression._);
  Aggregation<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>, Expr<E>, Expr<F?>)>
      max<F extends Comparable>(
              Expr<F?> Function(Expr<A> a, Expr<B> b) aggregateBuilder) =>
          _build(aggregateBuilder, MaxExpression._);
  Aggregation<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>, Expr<E>, Expr<int>)>
      count() => _build((a, b) => CountAllExpression._(), (a) => a);
}

extension Group4By2<A, B, C, D, E, F>
    on Group<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>, Expr<E>, Expr<F>)> {
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<C>, Expr<D>, Expr<E>, Expr<F>), T> Function(
              Aggregation<(Expr<C>, Expr<D>, Expr<E>, Expr<F>),
                      (Expr<A>, Expr<B>)>
                  agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return _Query(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        _group.toList(),
        e,
      ),
    );
  }
}

extension Aggregate2Project4<A, B, C, D, E, F>
    on Aggregation<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>, Expr<E>, Expr<F>)> {
  Aggregation<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
      _build<G, T>(
    Expr<T> Function(Expr<A> a, Expr<B> b) aggregateBuilder,
    Expr<G> Function(Expr<T> e) wrap,
  ) =>
          Aggregation._(
            _standins,
            (
              _projection.$1,
              _projection.$2,
              _projection.$3,
              _projection.$4,
              wrap(aggregateBuilder(
                _standins.$1,
                _standins.$2,
              )),
            ),
          );
  Aggregation<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
      sum<G extends num>(
              Expr<G?> Function(Expr<A> a, Expr<B> b) aggregateBuilder) =>
          _build(aggregateBuilder, SumExpression._);
  Aggregation<(Expr<A>, Expr<B>),
      (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<double?>)> avg<G extends num>(
          Expr<G?> Function(Expr<A> a, Expr<B> b) aggregateBuilder) =>
      _build(aggregateBuilder, AvgExpression._);
  Aggregation<(Expr<A>, Expr<B>),
      (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G?>)> min<G extends Comparable>(
          Expr<G?> Function(Expr<A> a, Expr<B> b) aggregateBuilder) =>
      _build(aggregateBuilder, MinExpression._);
  Aggregation<(Expr<A>, Expr<B>),
      (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G?>)> max<G extends Comparable>(
          Expr<G?> Function(Expr<A> a, Expr<B> b) aggregateBuilder) =>
      _build(aggregateBuilder, MaxExpression._);
  Aggregation<(Expr<A>, Expr<B>),
          (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<int>)>
      count() => _build((a, b) => CountAllExpression._(), (a) => a);
}

extension Group5By2<A, B, C, D, E, F, G> on Group<(Expr<A>, Expr<B>),
    (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> {
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>), T> Function(
              Aggregation<(Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>),
                      (Expr<A>, Expr<B>)>
                  agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return _Query(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        _group.toList(),
        e,
      ),
    );
  }
}

extension Aggregate2Project5<A, B, C, D, E, F, G> on Aggregation<
    (Expr<A>, Expr<B>), (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> {
  Aggregation<(Expr<A>, Expr<B>),
      (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)> _build<H, T>(
    Expr<T> Function(Expr<A> a, Expr<B> b) aggregateBuilder,
    Expr<H> Function(Expr<T> e) wrap,
  ) =>
      Aggregation._(
        _standins,
        (
          _projection.$1,
          _projection.$2,
          _projection.$3,
          _projection.$4,
          _projection.$5,
          wrap(aggregateBuilder(
            _standins.$1,
            _standins.$2,
          )),
        ),
      );
  Aggregation<(Expr<A>, Expr<B>),
          (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)>
      sum<H extends num>(
              Expr<H?> Function(Expr<A> a, Expr<B> b) aggregateBuilder) =>
          _build(aggregateBuilder, SumExpression._);
  Aggregation<(Expr<A>, Expr<B>),
          (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<double?>)>
      avg<H extends num>(
              Expr<H?> Function(Expr<A> a, Expr<B> b) aggregateBuilder) =>
          _build(aggregateBuilder, AvgExpression._);
  Aggregation<(Expr<A>, Expr<B>),
          (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H?>)>
      min<H extends Comparable>(
              Expr<H?> Function(Expr<A> a, Expr<B> b) aggregateBuilder) =>
          _build(aggregateBuilder, MinExpression._);
  Aggregation<(Expr<A>, Expr<B>),
          (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H?>)>
      max<H extends Comparable>(
              Expr<H?> Function(Expr<A> a, Expr<B> b) aggregateBuilder) =>
          _build(aggregateBuilder, MaxExpression._);
  Aggregation<(Expr<A>, Expr<B>),
          (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<int>)>
      count() => _build((a, b) => CountAllExpression._(), (a) => a);
}

extension Group6By2<A, B, C, D, E, F, G, H> on Group<(Expr<A>, Expr<B>),
    (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)> {
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>), T> Function(
              Aggregation<
                      (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>),
                      (Expr<A>, Expr<B>)>
                  agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return _Query(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        _group.toList(),
        e,
      ),
    );
  }
}

extension Aggregate2Project6<A, B, C, D, E, F, G, H> on Aggregation<
    (Expr<A>, Expr<B>),
    (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)> {
  Aggregation<(Expr<A>, Expr<B>),
          (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<I>)>
      _build<I, T>(
    Expr<T> Function(Expr<A> a, Expr<B> b) aggregateBuilder,
    Expr<I> Function(Expr<T> e) wrap,
  ) =>
          Aggregation._(
            _standins,
            (
              _projection.$1,
              _projection.$2,
              _projection.$3,
              _projection.$4,
              _projection.$5,
              _projection.$6,
              wrap(aggregateBuilder(
                _standins.$1,
                _standins.$2,
              )),
            ),
          );
  Aggregation<(Expr<A>, Expr<B>),
          (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<I>)>
      sum<I extends num>(
              Expr<I?> Function(Expr<A> a, Expr<B> b) aggregateBuilder) =>
          _build(aggregateBuilder, SumExpression._);
  Aggregation<(Expr<A>, Expr<B>),
          (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<double?>)>
      avg<I extends num>(
              Expr<I?> Function(Expr<A> a, Expr<B> b) aggregateBuilder) =>
          _build(aggregateBuilder, AvgExpression._);
  Aggregation<(Expr<A>, Expr<B>),
          (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<I?>)>
      min<I extends Comparable>(
              Expr<I?> Function(Expr<A> a, Expr<B> b) aggregateBuilder) =>
          _build(aggregateBuilder, MinExpression._);
  Aggregation<(Expr<A>, Expr<B>),
          (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<I?>)>
      max<I extends Comparable>(
              Expr<I?> Function(Expr<A> a, Expr<B> b) aggregateBuilder) =>
          _build(aggregateBuilder, MaxExpression._);
  Aggregation<(Expr<A>, Expr<B>),
          (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<int>)>
      count() => _build((a, b) => CountAllExpression._(), (a) => a);
}

extension Group1By3<A, B, C, D>
    on Group<(Expr<A>, Expr<B>, Expr<C>), (Expr<D>,)> {
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<D>,), T> Function(
              Aggregation<(Expr<D>,), (Expr<A>, Expr<B>, Expr<C>)> agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return _Query(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        _group.toList(),
        e,
      ),
    );
  }
}

extension Aggregate3Project1<A, B, C, D>
    on Aggregation<(Expr<A>, Expr<B>, Expr<C>), (Expr<D>,)> {
  Aggregation<(Expr<A>, Expr<B>, Expr<C>), (Expr<D>, Expr<E>)> _build<E, T>(
    Expr<T> Function(Expr<A> a, Expr<B> b, Expr<C> c) aggregateBuilder,
    Expr<E> Function(Expr<T> e) wrap,
  ) =>
      Aggregation._(
        _standins,
        (
          _projection.$1,
          wrap(aggregateBuilder(
            _standins.$1,
            _standins.$2,
            _standins.$3,
          )),
        ),
      );
  Aggregation<(Expr<A>, Expr<B>, Expr<C>), (Expr<D>, Expr<E>)>
      sum<E extends num>(
              Expr<E?> Function(Expr<A> a, Expr<B> b, Expr<C> c)
                  aggregateBuilder) =>
          _build(aggregateBuilder, SumExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>), (Expr<D>, Expr<double?>)>
      avg<E extends num>(
              Expr<E?> Function(Expr<A> a, Expr<B> b, Expr<C> c)
                  aggregateBuilder) =>
          _build(aggregateBuilder, AvgExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>), (Expr<D>, Expr<E?>)>
      min<E extends Comparable>(
              Expr<E?> Function(Expr<A> a, Expr<B> b, Expr<C> c)
                  aggregateBuilder) =>
          _build(aggregateBuilder, MinExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>), (Expr<D>, Expr<E?>)>
      max<E extends Comparable>(
              Expr<E?> Function(Expr<A> a, Expr<B> b, Expr<C> c)
                  aggregateBuilder) =>
          _build(aggregateBuilder, MaxExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>), (Expr<D>, Expr<int>)> count() =>
      _build((a, b, c) => CountAllExpression._(), (a) => a);
}

extension Group2By3<A, B, C, D, E>
    on Group<(Expr<A>, Expr<B>, Expr<C>), (Expr<D>, Expr<E>)> {
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<D>, Expr<E>), T> Function(
              Aggregation<(Expr<D>, Expr<E>), (Expr<A>, Expr<B>, Expr<C>)> agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return _Query(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        _group.toList(),
        e,
      ),
    );
  }
}

extension Aggregate3Project2<A, B, C, D, E>
    on Aggregation<(Expr<A>, Expr<B>, Expr<C>), (Expr<D>, Expr<E>)> {
  Aggregation<(Expr<A>, Expr<B>, Expr<C>), (Expr<D>, Expr<E>, Expr<F>)>
      _build<F, T>(
    Expr<T> Function(Expr<A> a, Expr<B> b, Expr<C> c) aggregateBuilder,
    Expr<F> Function(Expr<T> e) wrap,
  ) =>
          Aggregation._(
            _standins,
            (
              _projection.$1,
              _projection.$2,
              wrap(aggregateBuilder(
                _standins.$1,
                _standins.$2,
                _standins.$3,
              )),
            ),
          );
  Aggregation<(Expr<A>, Expr<B>, Expr<C>), (Expr<D>, Expr<E>, Expr<F>)>
      sum<F extends num>(
              Expr<F?> Function(Expr<A> a, Expr<B> b, Expr<C> c)
                  aggregateBuilder) =>
          _build(aggregateBuilder, SumExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>), (Expr<D>, Expr<E>, Expr<double?>)>
      avg<F extends num>(
              Expr<F?> Function(Expr<A> a, Expr<B> b, Expr<C> c)
                  aggregateBuilder) =>
          _build(aggregateBuilder, AvgExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>), (Expr<D>, Expr<E>, Expr<F?>)>
      min<F extends Comparable>(
              Expr<F?> Function(Expr<A> a, Expr<B> b, Expr<C> c)
                  aggregateBuilder) =>
          _build(aggregateBuilder, MinExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>), (Expr<D>, Expr<E>, Expr<F?>)>
      max<F extends Comparable>(
              Expr<F?> Function(Expr<A> a, Expr<B> b, Expr<C> c)
                  aggregateBuilder) =>
          _build(aggregateBuilder, MaxExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>), (Expr<D>, Expr<E>, Expr<int>)>
      count() => _build((a, b, c) => CountAllExpression._(), (a) => a);
}

extension Group3By3<A, B, C, D, E, F>
    on Group<(Expr<A>, Expr<B>, Expr<C>), (Expr<D>, Expr<E>, Expr<F>)> {
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<D>, Expr<E>, Expr<F>), T> Function(
              Aggregation<(Expr<D>, Expr<E>, Expr<F>),
                      (Expr<A>, Expr<B>, Expr<C>)>
                  agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return _Query(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        _group.toList(),
        e,
      ),
    );
  }
}

extension Aggregate3Project3<A, B, C, D, E, F>
    on Aggregation<(Expr<A>, Expr<B>, Expr<C>), (Expr<D>, Expr<E>, Expr<F>)> {
  Aggregation<(Expr<A>, Expr<B>, Expr<C>), (Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
      _build<G, T>(
    Expr<T> Function(Expr<A> a, Expr<B> b, Expr<C> c) aggregateBuilder,
    Expr<G> Function(Expr<T> e) wrap,
  ) =>
          Aggregation._(
            _standins,
            (
              _projection.$1,
              _projection.$2,
              _projection.$3,
              wrap(aggregateBuilder(
                _standins.$1,
                _standins.$2,
                _standins.$3,
              )),
            ),
          );
  Aggregation<(Expr<A>, Expr<B>, Expr<C>), (Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
      sum<G extends num>(
              Expr<G?> Function(Expr<A> a, Expr<B> b, Expr<C> c)
                  aggregateBuilder) =>
          _build(aggregateBuilder, SumExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>),
      (Expr<D>, Expr<E>, Expr<F>, Expr<double?>)> avg<G extends num>(
          Expr<G?> Function(Expr<A> a, Expr<B> b, Expr<C> c)
              aggregateBuilder) =>
      _build(aggregateBuilder, AvgExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>),
      (Expr<D>, Expr<E>, Expr<F>, Expr<G?>)> min<G extends Comparable>(
          Expr<G?> Function(Expr<A> a, Expr<B> b, Expr<C> c)
              aggregateBuilder) =>
      _build(aggregateBuilder, MinExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>),
      (Expr<D>, Expr<E>, Expr<F>, Expr<G?>)> max<G extends Comparable>(
          Expr<G?> Function(Expr<A> a, Expr<B> b, Expr<C> c)
              aggregateBuilder) =>
      _build(aggregateBuilder, MaxExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>),
          (Expr<D>, Expr<E>, Expr<F>, Expr<int>)>
      count() => _build((a, b, c) => CountAllExpression._(), (a) => a);
}

extension Group4By3<A, B, C, D, E, F, G> on Group<(Expr<A>, Expr<B>, Expr<C>),
    (Expr<D>, Expr<E>, Expr<F>, Expr<G>)> {
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<D>, Expr<E>, Expr<F>, Expr<G>), T> Function(
              Aggregation<(Expr<D>, Expr<E>, Expr<F>, Expr<G>),
                      (Expr<A>, Expr<B>, Expr<C>)>
                  agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return _Query(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        _group.toList(),
        e,
      ),
    );
  }
}

extension Aggregate3Project4<A, B, C, D, E, F, G> on Aggregation<
    (Expr<A>, Expr<B>, Expr<C>), (Expr<D>, Expr<E>, Expr<F>, Expr<G>)> {
  Aggregation<(Expr<A>, Expr<B>, Expr<C>),
      (Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)> _build<H, T>(
    Expr<T> Function(Expr<A> a, Expr<B> b, Expr<C> c) aggregateBuilder,
    Expr<H> Function(Expr<T> e) wrap,
  ) =>
      Aggregation._(
        _standins,
        (
          _projection.$1,
          _projection.$2,
          _projection.$3,
          _projection.$4,
          wrap(aggregateBuilder(
            _standins.$1,
            _standins.$2,
            _standins.$3,
          )),
        ),
      );
  Aggregation<(Expr<A>, Expr<B>, Expr<C>),
      (Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)> sum<H extends num>(
          Expr<H?> Function(Expr<A> a, Expr<B> b, Expr<C> c)
              aggregateBuilder) =>
      _build(aggregateBuilder, SumExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>),
      (Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<double?>)> avg<H extends num>(
          Expr<H?> Function(Expr<A> a, Expr<B> b, Expr<C> c)
              aggregateBuilder) =>
      _build(aggregateBuilder, AvgExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>),
      (Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H?>)> min<H extends Comparable>(
          Expr<H?> Function(Expr<A> a, Expr<B> b, Expr<C> c)
              aggregateBuilder) =>
      _build(aggregateBuilder, MinExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>),
      (Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H?>)> max<H extends Comparable>(
          Expr<H?> Function(Expr<A> a, Expr<B> b, Expr<C> c)
              aggregateBuilder) =>
      _build(aggregateBuilder, MaxExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>),
          (Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<int>)>
      count() => _build((a, b, c) => CountAllExpression._(), (a) => a);
}

extension Group5By3<A, B, C, D, E, F, G, H> on Group<
    (Expr<A>, Expr<B>, Expr<C>),
    (Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)> {
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>), T> Function(
              Aggregation<(Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>),
                      (Expr<A>, Expr<B>, Expr<C>)>
                  agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return _Query(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        _group.toList(),
        e,
      ),
    );
  }
}

extension Aggregate3Project5<A, B, C, D, E, F, G, H> on Aggregation<
    (Expr<A>, Expr<B>, Expr<C>),
    (Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)> {
  Aggregation<(Expr<A>, Expr<B>, Expr<C>),
      (Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<I>)> _build<I, T>(
    Expr<T> Function(Expr<A> a, Expr<B> b, Expr<C> c) aggregateBuilder,
    Expr<I> Function(Expr<T> e) wrap,
  ) =>
      Aggregation._(
        _standins,
        (
          _projection.$1,
          _projection.$2,
          _projection.$3,
          _projection.$4,
          _projection.$5,
          wrap(aggregateBuilder(
            _standins.$1,
            _standins.$2,
            _standins.$3,
          )),
        ),
      );
  Aggregation<(Expr<A>, Expr<B>, Expr<C>),
          (Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<I>)>
      sum<I extends num>(
              Expr<I?> Function(Expr<A> a, Expr<B> b, Expr<C> c)
                  aggregateBuilder) =>
          _build(aggregateBuilder, SumExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>),
          (Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<double?>)>
      avg<I extends num>(
              Expr<I?> Function(Expr<A> a, Expr<B> b, Expr<C> c)
                  aggregateBuilder) =>
          _build(aggregateBuilder, AvgExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>),
          (Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<I?>)>
      min<I extends Comparable>(
              Expr<I?> Function(Expr<A> a, Expr<B> b, Expr<C> c)
                  aggregateBuilder) =>
          _build(aggregateBuilder, MinExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>),
          (Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<I?>)>
      max<I extends Comparable>(
              Expr<I?> Function(Expr<A> a, Expr<B> b, Expr<C> c)
                  aggregateBuilder) =>
          _build(aggregateBuilder, MaxExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>),
          (Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<int>)>
      count() => _build((a, b, c) => CountAllExpression._(), (a) => a);
}

extension Group1By4<A, B, C, D, E>
    on Group<(Expr<A>, Expr<B>, Expr<C>, Expr<D>), (Expr<E>,)> {
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<E>,), T> Function(
              Aggregation<(Expr<E>,), (Expr<A>, Expr<B>, Expr<C>, Expr<D>)> agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return _Query(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        _group.toList(),
        e,
      ),
    );
  }
}

extension Aggregate4Project1<A, B, C, D, E>
    on Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>), (Expr<E>,)> {
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>), (Expr<E>, Expr<F>)>
      _build<F, T>(
    Expr<T> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
        aggregateBuilder,
    Expr<F> Function(Expr<T> e) wrap,
  ) =>
          Aggregation._(
            _standins,
            (
              _projection.$1,
              wrap(aggregateBuilder(
                _standins.$1,
                _standins.$2,
                _standins.$3,
                _standins.$4,
              )),
            ),
          );
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>), (Expr<E>, Expr<F>)>
      sum<F extends num>(
              Expr<F?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
                  aggregateBuilder) =>
          _build(aggregateBuilder, SumExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>), (Expr<E>, Expr<double?>)>
      avg<F extends num>(
              Expr<F?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
                  aggregateBuilder) =>
          _build(aggregateBuilder, AvgExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>), (Expr<E>, Expr<F?>)>
      min<F extends Comparable>(
              Expr<F?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
                  aggregateBuilder) =>
          _build(aggregateBuilder, MinExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>), (Expr<E>, Expr<F?>)>
      max<F extends Comparable>(
              Expr<F?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
                  aggregateBuilder) =>
          _build(aggregateBuilder, MaxExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>), (Expr<E>, Expr<int>)>
      count() => _build((a, b, c, d) => CountAllExpression._(), (a) => a);
}

extension Group2By4<A, B, C, D, E, F>
    on Group<(Expr<A>, Expr<B>, Expr<C>, Expr<D>), (Expr<E>, Expr<F>)> {
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<E>, Expr<F>), T> Function(
              Aggregation<(Expr<E>, Expr<F>),
                      (Expr<A>, Expr<B>, Expr<C>, Expr<D>)>
                  agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return _Query(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        _group.toList(),
        e,
      ),
    );
  }
}

extension Aggregate4Project2<A, B, C, D, E, F>
    on Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>), (Expr<E>, Expr<F>)> {
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>), (Expr<E>, Expr<F>, Expr<G>)>
      _build<G, T>(
    Expr<T> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
        aggregateBuilder,
    Expr<G> Function(Expr<T> e) wrap,
  ) =>
          Aggregation._(
            _standins,
            (
              _projection.$1,
              _projection.$2,
              wrap(aggregateBuilder(
                _standins.$1,
                _standins.$2,
                _standins.$3,
                _standins.$4,
              )),
            ),
          );
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>), (Expr<E>, Expr<F>, Expr<G>)>
      sum<G extends num>(
              Expr<G?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
                  aggregateBuilder) =>
          _build(aggregateBuilder, SumExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>),
      (Expr<E>, Expr<F>, Expr<double?>)> avg<G extends num>(
          Expr<G?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
              aggregateBuilder) =>
      _build(aggregateBuilder, AvgExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>),
      (Expr<E>, Expr<F>, Expr<G?>)> min<G extends Comparable>(
          Expr<G?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
              aggregateBuilder) =>
      _build(aggregateBuilder, MinExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>),
      (Expr<E>, Expr<F>, Expr<G?>)> max<G extends Comparable>(
          Expr<G?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
              aggregateBuilder) =>
      _build(aggregateBuilder, MaxExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>),
          (Expr<E>, Expr<F>, Expr<int>)>
      count() => _build((a, b, c, d) => CountAllExpression._(), (a) => a);
}

extension Group3By4<A, B, C, D, E, F, G> on Group<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>), (Expr<E>, Expr<F>, Expr<G>)> {
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<E>, Expr<F>, Expr<G>), T> Function(
              Aggregation<(Expr<E>, Expr<F>, Expr<G>),
                      (Expr<A>, Expr<B>, Expr<C>, Expr<D>)>
                  agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return _Query(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        _group.toList(),
        e,
      ),
    );
  }
}

extension Aggregate4Project3<A, B, C, D, E, F, G> on Aggregation<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>), (Expr<E>, Expr<F>, Expr<G>)> {
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>),
      (Expr<E>, Expr<F>, Expr<G>, Expr<H>)> _build<H, T>(
    Expr<T> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
        aggregateBuilder,
    Expr<H> Function(Expr<T> e) wrap,
  ) =>
      Aggregation._(
        _standins,
        (
          _projection.$1,
          _projection.$2,
          _projection.$3,
          wrap(aggregateBuilder(
            _standins.$1,
            _standins.$2,
            _standins.$3,
            _standins.$4,
          )),
        ),
      );
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>),
      (Expr<E>, Expr<F>, Expr<G>, Expr<H>)> sum<H extends num>(
          Expr<H?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
              aggregateBuilder) =>
      _build(aggregateBuilder, SumExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>),
      (Expr<E>, Expr<F>, Expr<G>, Expr<double?>)> avg<H extends num>(
          Expr<H?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
              aggregateBuilder) =>
      _build(aggregateBuilder, AvgExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>),
      (Expr<E>, Expr<F>, Expr<G>, Expr<H?>)> min<H extends Comparable>(
          Expr<H?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
              aggregateBuilder) =>
      _build(aggregateBuilder, MinExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>),
      (Expr<E>, Expr<F>, Expr<G>, Expr<H?>)> max<H extends Comparable>(
          Expr<H?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
              aggregateBuilder) =>
      _build(aggregateBuilder, MaxExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>),
          (Expr<E>, Expr<F>, Expr<G>, Expr<int>)>
      count() => _build((a, b, c, d) => CountAllExpression._(), (a) => a);
}

extension Group4By4<A, B, C, D, E, F, G, H> on Group<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>),
    (Expr<E>, Expr<F>, Expr<G>, Expr<H>)> {
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<E>, Expr<F>, Expr<G>, Expr<H>), T> Function(
              Aggregation<(Expr<E>, Expr<F>, Expr<G>, Expr<H>),
                      (Expr<A>, Expr<B>, Expr<C>, Expr<D>)>
                  agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return _Query(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        _group.toList(),
        e,
      ),
    );
  }
}

extension Aggregate4Project4<A, B, C, D, E, F, G, H> on Aggregation<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>),
    (Expr<E>, Expr<F>, Expr<G>, Expr<H>)> {
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>),
      (Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<I>)> _build<I, T>(
    Expr<T> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
        aggregateBuilder,
    Expr<I> Function(Expr<T> e) wrap,
  ) =>
      Aggregation._(
        _standins,
        (
          _projection.$1,
          _projection.$2,
          _projection.$3,
          _projection.$4,
          wrap(aggregateBuilder(
            _standins.$1,
            _standins.$2,
            _standins.$3,
            _standins.$4,
          )),
        ),
      );
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>),
      (Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<I>)> sum<I extends num>(
          Expr<I?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
              aggregateBuilder) =>
      _build(aggregateBuilder, SumExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>),
      (Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<double?>)> avg<I extends num>(
          Expr<I?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
              aggregateBuilder) =>
      _build(aggregateBuilder, AvgExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>),
      (Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<I?>)> min<I extends Comparable>(
          Expr<I?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
              aggregateBuilder) =>
      _build(aggregateBuilder, MinExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>),
      (Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<I?>)> max<I extends Comparable>(
          Expr<I?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
              aggregateBuilder) =>
      _build(aggregateBuilder, MaxExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>),
          (Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<int>)>
      count() => _build((a, b, c, d) => CountAllExpression._(), (a) => a);
}

extension Group1By5<A, B, C, D, E, F>
    on Group<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>), (Expr<F>,)> {
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<F>,), T> Function(
              Aggregation<(Expr<F>,),
                      (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)>
                  agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return _Query(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        _group.toList(),
        e,
      ),
    );
  }
}

extension Aggregate5Project1<A, B, C, D, E, F>
    on Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>), (Expr<F>,)> {
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>), (Expr<F>, Expr<G>)>
      _build<G, T>(
    Expr<T> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
        aggregateBuilder,
    Expr<G> Function(Expr<T> e) wrap,
  ) =>
          Aggregation._(
            _standins,
            (
              _projection.$1,
              wrap(aggregateBuilder(
                _standins.$1,
                _standins.$2,
                _standins.$3,
                _standins.$4,
                _standins.$5,
              )),
            ),
          );
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>), (Expr<F>, Expr<G>)>
      sum<G extends num>(
              Expr<G?> Function(
                      Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
                  aggregateBuilder) =>
          _build(aggregateBuilder, SumExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>),
      (Expr<F>, Expr<double?>)> avg<G extends num>(
          Expr<G?> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
              aggregateBuilder) =>
      _build(aggregateBuilder, AvgExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>),
      (Expr<F>, Expr<G?>)> min<G extends Comparable>(
          Expr<G?> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
              aggregateBuilder) =>
      _build(aggregateBuilder, MinExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>),
      (Expr<F>, Expr<G?>)> max<G extends Comparable>(
          Expr<G?> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
              aggregateBuilder) =>
      _build(aggregateBuilder, MaxExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>),
          (Expr<F>, Expr<int>)>
      count() => _build((a, b, c, d, e) => CountAllExpression._(), (a) => a);
}

extension Group2By5<A, B, C, D, E, F, G> on Group<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>), (Expr<F>, Expr<G>)> {
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<F>, Expr<G>), T> Function(
              Aggregation<(Expr<F>, Expr<G>),
                      (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)>
                  agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return _Query(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        _group.toList(),
        e,
      ),
    );
  }
}

extension Aggregate5Project2<A, B, C, D, E, F, G> on Aggregation<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>), (Expr<F>, Expr<G>)> {
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>),
      (Expr<F>, Expr<G>, Expr<H>)> _build<H, T>(
    Expr<T> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
        aggregateBuilder,
    Expr<H> Function(Expr<T> e) wrap,
  ) =>
      Aggregation._(
        _standins,
        (
          _projection.$1,
          _projection.$2,
          wrap(aggregateBuilder(
            _standins.$1,
            _standins.$2,
            _standins.$3,
            _standins.$4,
            _standins.$5,
          )),
        ),
      );
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>),
      (Expr<F>, Expr<G>, Expr<H>)> sum<H extends num>(
          Expr<H?> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
              aggregateBuilder) =>
      _build(aggregateBuilder, SumExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>),
      (Expr<F>, Expr<G>, Expr<double?>)> avg<H extends num>(
          Expr<H?> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
              aggregateBuilder) =>
      _build(aggregateBuilder, AvgExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>),
      (Expr<F>, Expr<G>, Expr<H?>)> min<H extends Comparable>(
          Expr<H?> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
              aggregateBuilder) =>
      _build(aggregateBuilder, MinExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>),
      (Expr<F>, Expr<G>, Expr<H?>)> max<H extends Comparable>(
          Expr<H?> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
              aggregateBuilder) =>
      _build(aggregateBuilder, MaxExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>),
          (Expr<F>, Expr<G>, Expr<int>)>
      count() => _build((a, b, c, d, e) => CountAllExpression._(), (a) => a);
}

extension Group3By5<A, B, C, D, E, F, G, H> on Group<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>),
    (Expr<F>, Expr<G>, Expr<H>)> {
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<F>, Expr<G>, Expr<H>), T> Function(
              Aggregation<(Expr<F>, Expr<G>, Expr<H>),
                      (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)>
                  agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return _Query(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        _group.toList(),
        e,
      ),
    );
  }
}

extension Aggregate5Project3<A, B, C, D, E, F, G, H> on Aggregation<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>),
    (Expr<F>, Expr<G>, Expr<H>)> {
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>),
      (Expr<F>, Expr<G>, Expr<H>, Expr<I>)> _build<I, T>(
    Expr<T> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
        aggregateBuilder,
    Expr<I> Function(Expr<T> e) wrap,
  ) =>
      Aggregation._(
        _standins,
        (
          _projection.$1,
          _projection.$2,
          _projection.$3,
          wrap(aggregateBuilder(
            _standins.$1,
            _standins.$2,
            _standins.$3,
            _standins.$4,
            _standins.$5,
          )),
        ),
      );
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>),
      (Expr<F>, Expr<G>, Expr<H>, Expr<I>)> sum<I extends num>(
          Expr<I?> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
              aggregateBuilder) =>
      _build(aggregateBuilder, SumExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>),
      (Expr<F>, Expr<G>, Expr<H>, Expr<double?>)> avg<I extends num>(
          Expr<I?> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
              aggregateBuilder) =>
      _build(aggregateBuilder, AvgExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>),
      (Expr<F>, Expr<G>, Expr<H>, Expr<I?>)> min<I extends Comparable>(
          Expr<I?> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
              aggregateBuilder) =>
      _build(aggregateBuilder, MinExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>),
      (Expr<F>, Expr<G>, Expr<H>, Expr<I?>)> max<I extends Comparable>(
          Expr<I?> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
              aggregateBuilder) =>
      _build(aggregateBuilder, MaxExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>),
          (Expr<F>, Expr<G>, Expr<H>, Expr<int>)>
      count() => _build((a, b, c, d, e) => CountAllExpression._(), (a) => a);
}

extension Group1By6<A, B, C, D, E, F, G> on Group<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>), (Expr<G>,)> {
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<G>,), T> Function(
              Aggregation<(Expr<G>,),
                      (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)>
                  agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return _Query(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        _group.toList(),
        e,
      ),
    );
  }
}

extension Aggregate6Project1<A, B, C, D, E, F, G> on Aggregation<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>), (Expr<G>,)> {
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>),
      (Expr<G>, Expr<H>)> _build<H, T>(
    Expr<T> Function(
            Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f)
        aggregateBuilder,
    Expr<H> Function(Expr<T> e) wrap,
  ) =>
      Aggregation._(
        _standins,
        (
          _projection.$1,
          wrap(aggregateBuilder(
            _standins.$1,
            _standins.$2,
            _standins.$3,
            _standins.$4,
            _standins.$5,
            _standins.$6,
          )),
        ),
      );
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>),
      (Expr<G>, Expr<H>)> sum<H extends num>(
          Expr<H?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f)
              aggregateBuilder) =>
      _build(aggregateBuilder, SumExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>),
      (Expr<G>, Expr<double?>)> avg<H extends num>(
          Expr<H?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f)
              aggregateBuilder) =>
      _build(aggregateBuilder, AvgExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>),
      (Expr<G>, Expr<H?>)> min<H extends Comparable>(
          Expr<H?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f)
              aggregateBuilder) =>
      _build(aggregateBuilder, MinExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>),
      (Expr<G>, Expr<H?>)> max<H extends Comparable>(
          Expr<H?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f)
              aggregateBuilder) =>
      _build(aggregateBuilder, MaxExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>),
          (Expr<G>, Expr<int>)>
      count() => _build((a, b, c, d, e, f) => CountAllExpression._(), (a) => a);
}

extension Group2By6<A, B, C, D, E, F, G, H> on Group<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>),
    (Expr<G>, Expr<H>)> {
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<G>, Expr<H>), T> Function(
              Aggregation<(Expr<G>, Expr<H>),
                      (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)>
                  agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return _Query(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        _group.toList(),
        e,
      ),
    );
  }
}

extension Aggregate6Project2<A, B, C, D, E, F, G, H> on Aggregation<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>),
    (Expr<G>, Expr<H>)> {
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>),
      (Expr<G>, Expr<H>, Expr<I>)> _build<I, T>(
    Expr<T> Function(
            Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f)
        aggregateBuilder,
    Expr<I> Function(Expr<T> e) wrap,
  ) =>
      Aggregation._(
        _standins,
        (
          _projection.$1,
          _projection.$2,
          wrap(aggregateBuilder(
            _standins.$1,
            _standins.$2,
            _standins.$3,
            _standins.$4,
            _standins.$5,
            _standins.$6,
          )),
        ),
      );
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>),
      (Expr<G>, Expr<H>, Expr<I>)> sum<I extends num>(
          Expr<I?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f)
              aggregateBuilder) =>
      _build(aggregateBuilder, SumExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>),
      (Expr<G>, Expr<H>, Expr<double?>)> avg<I extends num>(
          Expr<I?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f)
              aggregateBuilder) =>
      _build(aggregateBuilder, AvgExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>),
      (Expr<G>, Expr<H>, Expr<I?>)> min<I extends Comparable>(
          Expr<I?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f)
              aggregateBuilder) =>
      _build(aggregateBuilder, MinExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>),
      (Expr<G>, Expr<H>, Expr<I?>)> max<I extends Comparable>(
          Expr<I?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f)
              aggregateBuilder) =>
      _build(aggregateBuilder, MaxExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>),
          (Expr<G>, Expr<H>, Expr<int>)>
      count() => _build((a, b, c, d, e, f) => CountAllExpression._(), (a) => a);
}

extension Group1By7<A, B, C, D, E, F, G, H> on Group<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>),
    (Expr<H>,)> {
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<H>,), T> Function(
              Aggregation<
                      (Expr<H>,),
                      (
                        Expr<A>,
                        Expr<B>,
                        Expr<C>,
                        Expr<D>,
                        Expr<E>,
                        Expr<F>,
                        Expr<G>
                      )>
                  agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return _Query(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        _group.toList(),
        e,
      ),
    );
  }
}

extension Aggregate7Project1<A, B, C, D, E, F, G, H> on Aggregation<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>),
    (Expr<H>,)> {
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>),
      (Expr<H>, Expr<I>)> _build<I, T>(
    Expr<T> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
            Expr<F> f, Expr<G> g)
        aggregateBuilder,
    Expr<I> Function(Expr<T> e) wrap,
  ) =>
      Aggregation._(
        _standins,
        (
          _projection.$1,
          wrap(aggregateBuilder(
            _standins.$1,
            _standins.$2,
            _standins.$3,
            _standins.$4,
            _standins.$5,
            _standins.$6,
            _standins.$7,
          )),
        ),
      );
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>),
      (Expr<H>, Expr<I>)> sum<I extends num>(
          Expr<I?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g)
              aggregateBuilder) =>
      _build(aggregateBuilder, SumExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>),
      (Expr<H>, Expr<double?>)> avg<I extends num>(
          Expr<I?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g)
              aggregateBuilder) =>
      _build(aggregateBuilder, AvgExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>),
      (Expr<H>, Expr<I?>)> min<I extends Comparable>(
          Expr<I?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g)
              aggregateBuilder) =>
      _build(aggregateBuilder, MinExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>),
      (Expr<H>, Expr<I?>)> max<I extends Comparable>(
          Expr<I?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g)
              aggregateBuilder) =>
      _build(aggregateBuilder, MaxExpression._);
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>),
          (Expr<H>, Expr<int>)>
      count() =>
          _build((a, b, c, d, e, f, g) => CountAllExpression._(), (a) => a);
}

extension QuerySingle1<A> on QuerySingle<(Expr<A>,)> {
  Query<(Expr<A>,)> get asQuery => _query;
  QuerySingle<(Expr<A>,)> where(
          Expr<bool> Function(Expr<A> a) conditionBuilder) =>
      asQuery.where(conditionBuilder).first;
  QuerySingle<T> select<T extends Record>(
          T Function(Expr<A> a) projectionBuilder) =>
      QuerySingle._(asQuery.select(projectionBuilder));
  Future<A?> fetch() async => (await asQuery.fetch()).firstOrNull;
}

extension QuerySingle2<A, B> on QuerySingle<(Expr<A>, Expr<B>)> {
  Query<(Expr<A>, Expr<B>)> get asQuery => _query;
  QuerySingle<(Expr<A>, Expr<B>)> where(
          Expr<bool> Function(Expr<A> a, Expr<B> b) conditionBuilder) =>
      asQuery.where(conditionBuilder).first;
  QuerySingle<T> select<T extends Record>(
          T Function(Expr<A> a, Expr<B> b) projectionBuilder) =>
      QuerySingle._(asQuery.select(projectionBuilder));
  Future<(A, B)?> fetch() async => (await asQuery.fetch()).firstOrNull;
  Future<(A?, B?)> fetchOrNulls() async => await fetch() ?? (null, null);
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
  Future<(A, B, C)?> fetch() async => (await asQuery.fetch()).firstOrNull;
  Future<(A?, B?, C?)> fetchOrNulls() async =>
      await fetch() ?? (null, null, null);
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
  Future<(A, B, C, D)?> fetch() async => (await asQuery.fetch()).firstOrNull;
  Future<(A?, B?, C?, D?)> fetchOrNulls() async =>
      await fetch() ?? (null, null, null, null);
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
  Future<(A, B, C, D, E)?> fetch() async => (await asQuery.fetch()).firstOrNull;
  Future<(A?, B?, C?, D?, E?)> fetchOrNulls() async =>
      await fetch() ?? (null, null, null, null, null);
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
      (await asQuery.fetch()).firstOrNull;
  Future<(A?, B?, C?, D?, E?, F?)> fetchOrNulls() async =>
      await fetch() ?? (null, null, null, null, null, null);
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
      (await asQuery.fetch()).firstOrNull;
  Future<(A?, B?, C?, D?, E?, F?, G?)> fetchOrNulls() async =>
      await fetch() ?? (null, null, null, null, null, null, null);
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
      (await asQuery.fetch()).firstOrNull;
  Future<(A?, B?, C?, D?, E?, F?, G?, H?)> fetchOrNulls() async =>
      await fetch() ?? (null, null, null, null, null, null, null, null);
}

extension Return1<A> on Return<(Expr<A>,)> {
  Stream<A> executeAndStream() async* {
    final (sql, params) = _render(_expressions.toList());
    await for (final r in _context._query(sql, params)) {
      yield _expressions.$1._decode(r) as A;
    }
  }

  Future<List<A>> executeAndFetch() async => await executeAndStream().toList();
}

extension ReturnSingle1<A> on ReturnSingle<(Expr<A>,)> {
  Future<A?> executeAndFetch() async =>
      (await _return.executeAndFetch()).firstOrNull;
}

extension Return2<A, B> on Return<(Expr<A>, Expr<B>)> {
  Stream<(A, B)> executeAndStream() async* {
    final (sql, params) = _render(_expressions.toList());
    await for (final r in _context._query(sql, params)) {
      yield (_expressions.$1._decode(r) as A, _expressions.$2._decode(r) as B);
    }
  }

  Future<List<(A, B)>> executeAndFetch() async =>
      await executeAndStream().toList();
}

extension ReturnSingle2<A, B> on ReturnSingle<(Expr<A>, Expr<B>)> {
  Future<(A, B)?> executeAndFetch() async =>
      (await _return.executeAndFetch()).firstOrNull;
  Future<(A?, B?)> executeAndFetchOrNulls() async =>
      await executeAndFetch() ?? (null, null);
}

extension Return3<A, B, C> on Return<(Expr<A>, Expr<B>, Expr<C>)> {
  Stream<(A, B, C)> executeAndStream() async* {
    final (sql, params) = _render(_expressions.toList());
    await for (final r in _context._query(sql, params)) {
      yield (
        _expressions.$1._decode(r) as A,
        _expressions.$2._decode(r) as B,
        _expressions.$3._decode(r) as C
      );
    }
  }

  Future<List<(A, B, C)>> executeAndFetch() async =>
      await executeAndStream().toList();
}

extension ReturnSingle3<A, B, C> on ReturnSingle<(Expr<A>, Expr<B>, Expr<C>)> {
  Future<(A, B, C)?> executeAndFetch() async =>
      (await _return.executeAndFetch()).firstOrNull;
  Future<(A?, B?, C?)> executeAndFetchOrNulls() async =>
      await executeAndFetch() ?? (null, null, null);
}

extension Return4<A, B, C, D> on Return<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> {
  Stream<(A, B, C, D)> executeAndStream() async* {
    final (sql, params) = _render(_expressions.toList());
    await for (final r in _context._query(sql, params)) {
      yield (
        _expressions.$1._decode(r) as A,
        _expressions.$2._decode(r) as B,
        _expressions.$3._decode(r) as C,
        _expressions.$4._decode(r) as D
      );
    }
  }

  Future<List<(A, B, C, D)>> executeAndFetch() async =>
      await executeAndStream().toList();
}

extension ReturnSingle4<A, B, C, D>
    on ReturnSingle<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> {
  Future<(A, B, C, D)?> executeAndFetch() async =>
      (await _return.executeAndFetch()).firstOrNull;
  Future<(A?, B?, C?, D?)> executeAndFetchOrNulls() async =>
      await executeAndFetch() ?? (null, null, null, null);
}

extension Return5<A, B, C, D, E>
    on Return<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> {
  Stream<(A, B, C, D, E)> executeAndStream() async* {
    final (sql, params) = _render(_expressions.toList());
    await for (final r in _context._query(sql, params)) {
      yield (
        _expressions.$1._decode(r) as A,
        _expressions.$2._decode(r) as B,
        _expressions.$3._decode(r) as C,
        _expressions.$4._decode(r) as D,
        _expressions.$5._decode(r) as E
      );
    }
  }

  Future<List<(A, B, C, D, E)>> executeAndFetch() async =>
      await executeAndStream().toList();
}

extension ReturnSingle5<A, B, C, D, E>
    on ReturnSingle<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> {
  Future<(A, B, C, D, E)?> executeAndFetch() async =>
      (await _return.executeAndFetch()).firstOrNull;
  Future<(A?, B?, C?, D?, E?)> executeAndFetchOrNulls() async =>
      await executeAndFetch() ?? (null, null, null, null, null);
}

extension Return6<A, B, C, D, E, F>
    on Return<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> {
  Stream<(A, B, C, D, E, F)> executeAndStream() async* {
    final (sql, params) = _render(_expressions.toList());
    await for (final r in _context._query(sql, params)) {
      yield (
        _expressions.$1._decode(r) as A,
        _expressions.$2._decode(r) as B,
        _expressions.$3._decode(r) as C,
        _expressions.$4._decode(r) as D,
        _expressions.$5._decode(r) as E,
        _expressions.$6._decode(r) as F
      );
    }
  }

  Future<List<(A, B, C, D, E, F)>> executeAndFetch() async =>
      await executeAndStream().toList();
}

extension ReturnSingle6<A, B, C, D, E, F>
    on ReturnSingle<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> {
  Future<(A, B, C, D, E, F)?> executeAndFetch() async =>
      (await _return.executeAndFetch()).firstOrNull;
  Future<(A?, B?, C?, D?, E?, F?)> executeAndFetchOrNulls() async =>
      await executeAndFetch() ?? (null, null, null, null, null, null);
}

extension Return7<A, B, C, D, E, F, G>
    on Return<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> {
  Stream<(A, B, C, D, E, F, G)> executeAndStream() async* {
    final (sql, params) = _render(_expressions.toList());
    await for (final r in _context._query(sql, params)) {
      yield (
        _expressions.$1._decode(r) as A,
        _expressions.$2._decode(r) as B,
        _expressions.$3._decode(r) as C,
        _expressions.$4._decode(r) as D,
        _expressions.$5._decode(r) as E,
        _expressions.$6._decode(r) as F,
        _expressions.$7._decode(r) as G
      );
    }
  }

  Future<List<(A, B, C, D, E, F, G)>> executeAndFetch() async =>
      await executeAndStream().toList();
}

extension ReturnSingle7<A, B, C, D, E, F, G> on ReturnSingle<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> {
  Future<(A, B, C, D, E, F, G)?> executeAndFetch() async =>
      (await _return.executeAndFetch()).firstOrNull;
  Future<(A?, B?, C?, D?, E?, F?, G?)> executeAndFetchOrNulls() async =>
      await executeAndFetch() ?? (null, null, null, null, null, null, null);
}

extension Return8<A, B, C, D, E, F, G, H> on Return<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)> {
  Stream<(A, B, C, D, E, F, G, H)> executeAndStream() async* {
    final (sql, params) = _render(_expressions.toList());
    await for (final r in _context._query(sql, params)) {
      yield (
        _expressions.$1._decode(r) as A,
        _expressions.$2._decode(r) as B,
        _expressions.$3._decode(r) as C,
        _expressions.$4._decode(r) as D,
        _expressions.$5._decode(r) as E,
        _expressions.$6._decode(r) as F,
        _expressions.$7._decode(r) as G,
        _expressions.$8._decode(r) as H
      );
    }
  }

  Future<List<(A, B, C, D, E, F, G, H)>> executeAndFetch() async =>
      await executeAndStream().toList();
}

extension ReturnSingle8<A, B, C, D, E, F, G, H> on ReturnSingle<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)> {
  Future<(A, B, C, D, E, F, G, H)?> executeAndFetch() async =>
      (await _return.executeAndFetch()).firstOrNull;
  Future<(A?, B?, C?, D?, E?, F?, G?, H?)> executeAndFetchOrNulls() async =>
      await executeAndFetch() ??
      (null, null, null, null, null, null, null, null);
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
