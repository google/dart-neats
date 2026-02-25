// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'typed_sql.dart';

// **************************************************************************
// Generator: _TypedSqlExtensionBuilder
// **************************************************************************

/// Extension methods for a query returning zero or more rows with
/// 1 expression.
extension Query1<A> on Query<(Expr<A>,)> {
  (Object, T) _build<T>(T Function(Expr<A> a) builder) {
    final handle = Object();
    var offset = 0;
    final a = _expressions.$1._standin(offset, handle);
    return (handle, builder(a));
  }

  /// Filter [Query] using `WHERE` clause.
  ///
  /// Returns a [Query] retaining rows from this [Query] where the expression
  /// returned by [conditionBuilder] evaluates to `true`.
  Query<(Expr<A>,)> where(Expr<bool> Function(Expr<A> a) conditionBuilder) {
    final (handle, where) = _build(conditionBuilder);
    return Query._(
      _context,
      _expressions,
      (e) => WhereClause._(_from(e), handle, where),
    );
  }

  /// Order [Query] using `ORDER BY` clause.
  ///
  /// Returns a [Query] with the same rows as this [Query], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedQuery<(Expr<A>,)> orderBy(
      List<(Expr<Comparable?>, Order)> Function(Expr<A> a) builder) {
    final (handle, orderBy) = _build(builder);
    if (orderBy.isEmpty) {
      return OrderedQuery._(this);
    }
    return OrderedQuery._(Query._(
      _context,
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy),
    ));
  }

  /// Limit [Query] using `LIMIT` clause.
  ///
  /// The resulting [Query] will only return the first [limit] rows.
  Query<(Expr<A>,)> limit(int limit) => Query._(
        _context,
        _expressions,
        (e) => LimitClause._(_from(e), limit),
      );

  /// Offset [Query] using `OFFSET` clause.
  ///
  /// The resulting [Query] will skip the first [offset] rows.
  Query<(Expr<A>,)> offset(int offset) => Query._(
        _context,
        _expressions,
        (e) => OffsetClause._(_from(e), offset),
      );

  /// Limit [Query] to the first row using `LIMIT` clause.
  ///
  /// This returns a [QuerySingle] which contains at-most one row.
  QuerySingle<(Expr<A>,)> get first => QuerySingle._(limit(1));

  /// Count number of rows in this [Query] using `COUNT(*)` aggregate
  /// function.
  ///
  /// The resulting [QuerySingle] will have exactly one row, which is the
  /// number of rows in the this query.
  ///
  /// This will count all rows, including rows with `null` values. If you
  /// don't wish to count `null` values, use [where] to filter out such
  /// rows first.
  QuerySingle<(Expr<int>,)> count() =>
      select((a) => (CountAllExpression._(),)).first;

  /// Create a projection of this [Query] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [Query] object which doesn't have any methods!
  ///
  /// All methods and properties on [Query<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  Query<T> select<T extends Record>(T Function(Expr<A> a) projectionBuilder) {
    final (handle, projection) = _build(projectionBuilder);
    return Query._(
      _context,
      projection,
      (e) => SelectFromClause._(_from(_expressions.toList()), handle, e),
    );
  }

  /// Join this [Query] with another [Query] using `INNER JOIN` clause.
  ///
  /// This method returns an [InnerJoin] object on which you must call either
  ///  * `.all` to get the cartesian product of the two queries, or,
  ///  * `.on` to specify how the two queries should be joined.
  ///
  /// This always creates a `INNER JOIN`, where the `.on` condition can be
  /// used to control how the two queries are joined.
  InnerJoin<(Expr<A>,), T> join<T extends Record>(Query<T> query) =>
      InnerJoin._(this, query);

  /// Join this [Query] with another [Query] using `LEFT JOIN` clause.
  ///
  /// This method returns an [LeftJoin] object on which you must call
  /// `.on` to specify how the two queries should be joined.
  ///
  /// This always creates a `LEFT JOIN`, where the `.on` condition can be
  /// used to control how the two queries are joined.
  LeftJoin<(Expr<A>,), T> leftJoin<T extends Record>(Query<T> query) =>
      LeftJoin._(this, query);

  /// Join this [Query] with another [Query] using `RIGHT JOIN` clause.
  ///
  /// This method returns an [RightJoin] object on which you must call
  /// `.on` to specify how the two queries should be joined.
  ///
  /// This always creates a `RIGHT JOIN`, where the `.on` condition can be
  /// used to control how the two queries are joined.
  RightJoin<(Expr<A>,), T> rightJoin<T extends Record>(Query<T> query) =>
      RightJoin._(this, query);

  /// Check for existance of rows in this [Query] using `EXISTS` operator.
  ///
  /// This returns a [QuerySingle] which contains exactly one row.
  /// The value of this query will be `true`, if this [Query] contains
  /// any rows, even if those rows are entirely `null`s.
  ///
  /// > [!TIP]
  /// > If you wish to use `.exists()` in a subquery considering
  /// > using `.asSubQuery.exists()` which returns an [Expr<bool>].
  QuerySingle<(Expr<bool>,)> exists() => QuerySingle._(Query._(
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

  /// Combine this [Query] with [other] using `UNION` _set operator_.
  ///
  /// This returns a [Query] containing all the rows from this [Query]
  /// and [other] with duplicate rows appearing only once.
  Query<(Expr<A>,)> union(Query<(Expr<A>,)> other) => Query._(
        _context,
        _expressions,
        (e) => UnionClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );

  /// Combine this [Query] with [other] using `UNION ALL` _set operator_.
  ///
  /// This returns a [Query] containing all the rows from this [Query] and
  /// [other]. Unlike `.union` this retains duplicate rows.
  Query<(Expr<A>,)> unionAll(Query<(Expr<A>,)> other) => Query._(
        _context,
        _expressions,
        (e) => UnionAllClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );

  /// Combine this [Query] with [other] using `INTERSECT` _set operator_.
  ///
  /// This returns a [Query] containing all the rows that appear in both this
  /// [Query] and [other], with duplicate rows appearing only once.
  Query<(Expr<A>,)> intersect(Query<(Expr<A>,)> other) => Query._(
        _context,
        _expressions,
        (e) => IntersectClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );

  /// Combine this [Query] with [other] using `EXCEPT` _set operator_.
  ///
  /// This returns a [Query] containing all the rows that appear in this
  /// [Query] and does not appear in [other], with duplicate rows appearing
  /// only once.
  Query<(Expr<A>,)> except(Query<(Expr<A>,)> other) => Query._(
        _context,
        _expressions,
        (e) => ExceptClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );

  /// Combine this [Query] with [other] using `UNION` _set operator_.
  ///
  /// This returns a [Query] containing all the rows from this [Query]
  /// and [other] with duplicate rows appearing only once.
  Query<(Expr<A>,)> operator -(Query<(Expr<A>,)> other) => except(other);

  /// Combine this [Query] with [other] using `UNION ALL` _set operator_.
  ///
  /// This returns a [Query] containing all the rows from this [Query] and
  /// [other]. Unlike `.union` this retains duplicate rows.
  Query<(Expr<A>,)> operator +(Query<(Expr<A>,)> other) => unionAll(other);

  /// Combine this [Query] with [other] using `INTERSECT` _set operator_.
  ///
  /// This returns a [Query] containing all the rows that appear in both this
  /// [Query] and [other], with duplicate rows appearing only once.
  Query<(Expr<A>,)> operator &(Query<(Expr<A>,)> other) => intersect(other);

  /// Combine this [Query] with [other] using `EXCEPT` _set operator_.
  ///
  /// This returns a [Query] containing all the rows that appear in this
  /// [Query] and does not appear in [other], with duplicate rows appearing
  /// only once.
  Query<(Expr<A>,)> operator |(Query<(Expr<A>,)> other) => union(other);

  /// Create projection for `GROUP BY` clause.
  ///
  /// The [groupBuilder] must return a [Record] where all the values are [Expr]
  /// objects. If something else is returned you will get a [Group] object which
  /// doesn't have any methods!
  ///
  /// This returns a [Group] object which has an `.aggregate` method that returns
  /// a query with a row for each distinct value of the projetion created by
  /// [groupBuilder]. The `.aggregate` method is used to construct
  /// _aggregate functions_ over rows of this [Query] for each group.
  Group<T, (Expr<A>,)> groupBy<T extends Record>(
      T Function(Expr<A> a) groupBuilder) {
    final (handle, (group, standins)) = _build((a) {
      return (groupBuilder(a), (a,));
    });
    return Group._(this, handle, group, standins);
  }

  /// Query the database for rows in this [Query] as a [Stream].
  Stream<A> stream() async* {
    final from = _from(_expressions.toList());
    final decode1 = _expressions.$1._decode;
    final (sql, params) = _context._dialect.select(SelectStatement._(from));
    await for (final row in _context._query(sql, params)) {
      yield decode1(row) as A;
    }
  }

  /// Query the database for rows in this [Query] as a [List].
  Future<List<A>> fetch() async => await stream().toList();
}

/// Extension methods for a subquery returning zero or more rows with
/// 1 expression.
extension SubQuery1<A> on SubQuery<(Expr<A>,)> {
  (Object, T) _build<T>(T Function(Expr<A> a) builder) {
    final handle = Object();
    var offset = 0;
    final a = _expressions.$1._standin(offset, handle);
    return (handle, builder(a));
  }

  /// Filter [SubQuery] using `WHERE` clause.
  ///
  /// Returns a [SubQuery] retaining rows from this [SubQuery] where the expression
  /// returned by [conditionBuilder] evaluates to `true`.
  SubQuery<(Expr<A>,)> where(Expr<bool> Function(Expr<A> a) conditionBuilder) {
    final (handle, where) = _build(conditionBuilder);
    return SubQuery._(
      _expressions,
      (e) => WhereClause._(_from(e), handle, where),
    );
  }

  /// Order [SubQuery] using `ORDER BY` clause.
  ///
  /// Returns a [SubQuery] with the same rows as this [SubQuery], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedSubQuery<(Expr<A>,)> orderBy(
      List<(Expr<Comparable?>, Order)> Function(Expr<A> a) builder) {
    final (handle, orderBy) = _build(builder);
    if (orderBy.isEmpty) {
      return OrderedSubQuery._(this);
    }
    return OrderedSubQuery._(SubQuery._(
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy),
    ));
  }

  /// Limit [SubQuery] using `LIMIT` clause.
  ///
  /// The resulting [SubQuery] will only return the first [limit] rows.
  SubQuery<(Expr<A>,)> limit(int limit) => SubQuery._(
        _expressions,
        (e) => LimitClause._(_from(e), limit),
      );

  /// Offset [SubQuery] using `OFFSET` clause.
  ///
  /// The resulting [SubQuery] will skip the first [offset] rows.
  SubQuery<(Expr<A>,)> offset(int offset) => SubQuery._(
        _expressions,
        (e) => OffsetClause._(_from(e), offset),
      );

  /// Count number of rows in this [SubQuery] using `COUNT(*)` aggregate
  /// function.
  ///
  /// The resulting [Expr<int>] will evaluate to the number of rows in this
  /// [SubQuery].
  ///
  /// This will count all rows, including rows with `null` values. If you
  /// don't wish to count `null` values, use [where] to filter out such
  /// rows first.
  Expr<int> count() =>
      select((a) => (CountAllExpression._(),)).first.asNotNull();

  /// Create a projection of this [SubQuery] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [SubQuery] object which doesn't have any methods!
  ///
  /// All methods and properties on [SubQuery<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  SubQuery<T> select<T extends Record>(
      T Function(Expr<A> a) projectionBuilder) {
    final (handle, projection) = _build(projectionBuilder);
    return SubQuery._(
      projection,
      (e) => SelectFromClause._(_from(_expressions.toList()), handle, e),
    );
  }

  /// Check for existance of rows in this [SubQuery] using `EXISTS` operator.
  ///
  /// This returns an [Expr<bool>] that evaluates to `true`, if this [SubQuery]
  /// contains any rows, even if those rows are entirely `null`s.
  Expr<bool> exists() => ExistsExpression._(_from(_expressions.toList()));
}

/// Extension methods for a query returning zero or more rows with
/// 1 expression.
extension OrderedQuery1<A> on OrderedQuery<(Expr<A>,)> {
  /// Filter [OrderedQuery] using `WHERE` clause.
  ///
  /// Returns a [OrderedQuery] retaining rows from this [OrderedQuery] where the expression
  /// returned by [conditionBuilder] evaluates to `true`.
  OrderedQuery<(Expr<A>,)> where(
          Expr<bool> Function(Expr<A> a) conditionBuilder) =>
      OrderedQuery._(_query.where(conditionBuilder));

  /// Create a projection of this [OrderedQuery] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [OrderedQuery] object which doesn't have any methods!
  ///
  /// All methods and properties on [OrderedQuery<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  ProjectedOrderedQuery<T> select<T extends Record>(
          T Function(Expr<A> a) projectionBuilder) =>
      ProjectedOrderedQuery._(_query.select(projectionBuilder));

  /// Limit [OrderedQuery] using `LIMIT` clause.
  ///
  /// The resulting [OrderedQuery] will only return the first [limit] rows.
  OrderedQueryRange<(Expr<A>,)> limit(int limit) =>
      OrderedQueryRange._(_query.limit(limit));

  /// Offset [OrderedQuery] using `OFFSET` clause.
  ///
  /// The resulting [OrderedQuery] will skip the first [offset] rows.
  OrderedQueryRange<(Expr<A>,)> offset(int offset) =>
      OrderedQueryRange._(_query.offset(offset));

  /// Order [OrderedQuery] using `ORDER BY` clause.
  ///
  /// Returns a [OrderedQuery] with the same rows as this [OrderedQuery], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedQuery<(Expr<A>,)> orderBy(
          List<(Expr<Comparable?>, Order)> Function(Expr<A> a) builder) =>
      _query.orderBy(builder);

  /// Query the database for rows in this [Query] as a [List].
  Future<List<A>> fetch() => _query.fetch();

  /// Query the database for rows in this [Query] as a [Stream].
  Stream<A> stream() => _query.stream();

  /// Limit [Query] to the first row using `LIMIT` clause.
  ///
  /// This returns a [QuerySingle] which contains at-most one row.
  QuerySingle<(Expr<A>,)> get first => _query.first;
}

/// Extension methods for a query returning zero or more rows with
/// 1 expression.
extension OrderedQueryRange1<A> on OrderedQueryRange<(Expr<A>,)> {
  /// Create a projection of this [OrderedQueryRange] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [OrderedQueryRange] object which doesn't have any methods!
  ///
  /// All methods and properties on [OrderedQueryRange<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  ProjectedOrderedQueryRange<T> select<T extends Record>(
          T Function(Expr<A> a) projectionBuilder) =>
      ProjectedOrderedQueryRange._(_query.select(projectionBuilder));

  /// Limit [OrderedQueryRange] using `LIMIT` clause.
  ///
  /// The resulting [OrderedQueryRange] will only return the first [limit] rows.
  OrderedQueryRange<(Expr<A>,)> limit(int limit) =>
      OrderedQueryRange._(_query.limit(limit));

  /// Offset [OrderedQueryRange] using `OFFSET` clause.
  ///
  /// The resulting [OrderedQueryRange] will skip the first [offset] rows.
  OrderedQueryRange<(Expr<A>,)> offset(int offset) =>
      OrderedQueryRange._(_query.offset(offset));

  /// Order [OrderedQueryRange] using `ORDER BY` clause.
  ///
  /// Returns a [OrderedQueryRange] with the same rows as this [OrderedQueryRange], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedQuery<(Expr<A>,)> orderBy(
          List<(Expr<Comparable?>, Order)> Function(Expr<A> a) builder) =>
      _query.orderBy(builder);

  /// Query the database for rows in this [Query] as a [List].
  Future<List<A>> fetch() => _query.fetch();

  /// Query the database for rows in this [Query] as a [Stream].
  Stream<A> stream() => _query.stream();

  /// Limit [Query] to the first row using `LIMIT` clause.
  ///
  /// This returns a [QuerySingle] which contains at-most one row.
  QuerySingle<(Expr<A>,)> get first => _query.first;
}

/// Extension methods for a query returning zero or more rows with
/// 1 expression.
extension ProjectedOrderedQuery1<A> on ProjectedOrderedQuery<(Expr<A>,)> {
  /// Limit [ProjectedOrderedQuery] using `LIMIT` clause.
  ///
  /// The resulting [ProjectedOrderedQuery] will only return the first [limit] rows.
  ProjectedOrderedQueryRange<(Expr<A>,)> limit(int limit) =>
      ProjectedOrderedQueryRange._(_query.limit(limit));

  /// Offset [ProjectedOrderedQuery] using `OFFSET` clause.
  ///
  /// The resulting [ProjectedOrderedQuery] will skip the first [offset] rows.
  ProjectedOrderedQueryRange<(Expr<A>,)> offset(int offset) =>
      ProjectedOrderedQueryRange._(_query.offset(offset));

  /// Order [ProjectedOrderedQuery] using `ORDER BY` clause.
  ///
  /// Returns a [ProjectedOrderedQuery] with the same rows as this [ProjectedOrderedQuery], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedQuery<(Expr<A>,)> orderBy(
          List<(Expr<Comparable?>, Order)> Function(Expr<A> a) builder) =>
      _query.orderBy(builder);

  /// Query the database for rows in this [Query] as a [List].
  Future<List<A>> fetch() => _query.fetch();

  /// Query the database for rows in this [Query] as a [Stream].
  Stream<A> stream() => _query.stream();

  /// Limit [Query] to the first row using `LIMIT` clause.
  ///
  /// This returns a [QuerySingle] which contains at-most one row.
  QuerySingle<(Expr<A>,)> get first => _query.first;
}

/// Extension methods for a query returning zero or more rows with
/// 1 expression.
extension ProjectedOrderedQueryRange1<A>
    on ProjectedOrderedQueryRange<(Expr<A>,)> {
  /// Limit [ProjectedOrderedQueryRange] using `LIMIT` clause.
  ///
  /// The resulting [ProjectedOrderedQueryRange] will only return the first [limit] rows.
  ProjectedOrderedQueryRange<(Expr<A>,)> limit(int limit) =>
      ProjectedOrderedQueryRange._(_query.limit(limit));

  /// Offset [ProjectedOrderedQueryRange] using `OFFSET` clause.
  ///
  /// The resulting [ProjectedOrderedQueryRange] will skip the first [offset] rows.
  ProjectedOrderedQueryRange<(Expr<A>,)> offset(int offset) =>
      ProjectedOrderedQueryRange._(_query.offset(offset));

  /// Order [ProjectedOrderedQueryRange] using `ORDER BY` clause.
  ///
  /// Returns a [ProjectedOrderedQueryRange] with the same rows as this [ProjectedOrderedQueryRange], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedQuery<(Expr<A>,)> orderBy(
          List<(Expr<Comparable?>, Order)> Function(Expr<A> a) builder) =>
      _query.orderBy(builder);

  /// Query the database for rows in this [Query] as a [List].
  Future<List<A>> fetch() => _query.fetch();

  /// Query the database for rows in this [Query] as a [Stream].
  Stream<A> stream() => _query.stream();

  /// Limit [Query] to the first row using `LIMIT` clause.
  ///
  /// This returns a [QuerySingle] which contains at-most one row.
  QuerySingle<(Expr<A>,)> get first => _query.first;
}

/// Extension methods for a ordered subquery of zero or more rows with
/// 1 expression.
extension OrderedSubQuery1<A> on OrderedSubQuery<(Expr<A>,)> {
  /// Filter [OrderedSubQuery] using `WHERE` clause.
  ///
  /// Returns a [OrderedSubQuery] retaining rows from this [OrderedSubQuery] where the expression
  /// returned by [conditionBuilder] evaluates to `true`.
  OrderedSubQuery<(Expr<A>,)> where(
          Expr<bool> Function(Expr<A> a) conditionBuilder) =>
      OrderedSubQuery._(_query.where(conditionBuilder));

  /// Create a projection of this [OrderedSubQuery] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [OrderedSubQuery] object which doesn't have any methods!
  ///
  /// All methods and properties on [OrderedSubQuery<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  ProjectedOrderedSubQuery<T> select<T extends Record>(
          T Function(Expr<A> a) projectionBuilder) =>
      ProjectedOrderedSubQuery._(_query.select(projectionBuilder));

  /// Limit [OrderedSubQuery] using `LIMIT` clause.
  ///
  /// The resulting [OrderedSubQuery] will only return the first [limit] rows.
  OrderedSubQueryRange<(Expr<A>,)> limit(int limit) =>
      OrderedSubQueryRange._(_query.limit(limit));

  /// Offset [OrderedSubQuery] using `OFFSET` clause.
  ///
  /// The resulting [OrderedSubQuery] will skip the first [offset] rows.
  OrderedSubQueryRange<(Expr<A>,)> offset(int offset) =>
      OrderedSubQueryRange._(_query.offset(offset));

  /// Order [OrderedSubQuery] using `ORDER BY` clause.
  ///
  /// Returns a [OrderedSubQuery] with the same rows as this [OrderedSubQuery], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedSubQuery<(Expr<A>,)> orderBy(
          List<(Expr<Comparable?>, Order)> Function(Expr<A> a) builder) =>
      _query.orderBy(builder);
}

/// Extension methods for a ordered subquery of zero or more rows with
/// 1 expression.
extension OrderedSubQueryRange1<A> on OrderedSubQueryRange<(Expr<A>,)> {
  /// Create a projection of this [OrderedSubQueryRange] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [OrderedSubQueryRange] object which doesn't have any methods!
  ///
  /// All methods and properties on [OrderedSubQueryRange<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  ProjectedOrderedSubQueryRange<T> select<T extends Record>(
          T Function(Expr<A> a) projectionBuilder) =>
      ProjectedOrderedSubQueryRange._(_query.select(projectionBuilder));

  /// Limit [OrderedSubQueryRange] using `LIMIT` clause.
  ///
  /// The resulting [OrderedSubQueryRange] will only return the first [limit] rows.
  OrderedSubQueryRange<(Expr<A>,)> limit(int limit) =>
      OrderedSubQueryRange._(_query.limit(limit));

  /// Offset [OrderedSubQueryRange] using `OFFSET` clause.
  ///
  /// The resulting [OrderedSubQueryRange] will skip the first [offset] rows.
  OrderedSubQueryRange<(Expr<A>,)> offset(int offset) =>
      OrderedSubQueryRange._(_query.offset(offset));

  /// Order [OrderedSubQueryRange] using `ORDER BY` clause.
  ///
  /// Returns a [OrderedSubQueryRange] with the same rows as this [OrderedSubQueryRange], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedSubQuery<(Expr<A>,)> orderBy(
          List<(Expr<Comparable?>, Order)> Function(Expr<A> a) builder) =>
      _query.orderBy(builder);
}

/// Extension methods for a ordered subquery of zero or more rows with
/// 1 expression.
extension ProjectedOrderedSubQuery1<A> on ProjectedOrderedSubQuery<(Expr<A>,)> {
  /// Limit [ProjectedOrderedSubQuery] using `LIMIT` clause.
  ///
  /// The resulting [ProjectedOrderedSubQuery] will only return the first [limit] rows.
  ProjectedOrderedSubQueryRange<(Expr<A>,)> limit(int limit) =>
      ProjectedOrderedSubQueryRange._(_query.limit(limit));

  /// Offset [ProjectedOrderedSubQuery] using `OFFSET` clause.
  ///
  /// The resulting [ProjectedOrderedSubQuery] will skip the first [offset] rows.
  ProjectedOrderedSubQueryRange<(Expr<A>,)> offset(int offset) =>
      ProjectedOrderedSubQueryRange._(_query.offset(offset));

  /// Order [ProjectedOrderedSubQuery] using `ORDER BY` clause.
  ///
  /// Returns a [ProjectedOrderedSubQuery] with the same rows as this [ProjectedOrderedSubQuery], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedSubQuery<(Expr<A>,)> orderBy(
          List<(Expr<Comparable?>, Order)> Function(Expr<A> a) builder) =>
      _query.orderBy(builder);
}

/// Extension methods for a ordered subquery of zero or more rows with
/// 1 expression.
extension ProjectedOrderedSubQueryRange1<A>
    on ProjectedOrderedSubQueryRange<(Expr<A>,)> {
  /// Limit [ProjectedOrderedSubQueryRange] using `LIMIT` clause.
  ///
  /// The resulting [ProjectedOrderedSubQueryRange] will only return the first [limit] rows.
  ProjectedOrderedSubQueryRange<(Expr<A>,)> limit(int limit) =>
      ProjectedOrderedSubQueryRange._(_query.limit(limit));

  /// Offset [ProjectedOrderedSubQueryRange] using `OFFSET` clause.
  ///
  /// The resulting [ProjectedOrderedSubQueryRange] will skip the first [offset] rows.
  ProjectedOrderedSubQueryRange<(Expr<A>,)> offset(int offset) =>
      ProjectedOrderedSubQueryRange._(_query.offset(offset));

  /// Order [ProjectedOrderedSubQueryRange] using `ORDER BY` clause.
  ///
  /// Returns a [ProjectedOrderedSubQueryRange] with the same rows as this [ProjectedOrderedSubQueryRange], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedSubQuery<(Expr<A>,)> orderBy(
          List<(Expr<Comparable?>, Order)> Function(Expr<A> a) builder) =>
      _query.orderBy(builder);
}

/// Extension methods for a query returning zero or more rows with
/// 2 expressions.
extension Query2<A, B> on Query<(Expr<A>, Expr<B>)> {
  (Object, T) _build<T>(T Function(Expr<A> a, Expr<B> b) builder) {
    final handle = Object();
    var offset = 0;
    final a = _expressions.$1._standin(offset, handle);
    offset += _expressions.$1._columns;
    final b = _expressions.$2._standin(offset, handle);
    return (handle, builder(a, b));
  }

  /// Filter [Query] using `WHERE` clause.
  ///
  /// Returns a [Query] retaining rows from this [Query] where the expression
  /// returned by [conditionBuilder] evaluates to `true`.
  Query<(Expr<A>, Expr<B>)> where(
      Expr<bool> Function(Expr<A> a, Expr<B> b) conditionBuilder) {
    final (handle, where) = _build(conditionBuilder);
    return Query._(
      _context,
      _expressions,
      (e) => WhereClause._(_from(e), handle, where),
    );
  }

  /// Order [Query] using `ORDER BY` clause.
  ///
  /// Returns a [Query] with the same rows as this [Query], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedQuery<(Expr<A>, Expr<B>)> orderBy(
      List<(Expr<Comparable?>, Order)> Function(Expr<A> a, Expr<B> b) builder) {
    final (handle, orderBy) = _build(builder);
    if (orderBy.isEmpty) {
      return OrderedQuery._(this);
    }
    return OrderedQuery._(Query._(
      _context,
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy),
    ));
  }

  /// Limit [Query] using `LIMIT` clause.
  ///
  /// The resulting [Query] will only return the first [limit] rows.
  Query<(Expr<A>, Expr<B>)> limit(int limit) => Query._(
        _context,
        _expressions,
        (e) => LimitClause._(_from(e), limit),
      );

  /// Offset [Query] using `OFFSET` clause.
  ///
  /// The resulting [Query] will skip the first [offset] rows.
  Query<(Expr<A>, Expr<B>)> offset(int offset) => Query._(
        _context,
        _expressions,
        (e) => OffsetClause._(_from(e), offset),
      );

  /// Limit [Query] to the first row using `LIMIT` clause.
  ///
  /// This returns a [QuerySingle] which contains at-most one row.
  QuerySingle<(Expr<A>, Expr<B>)> get first => QuerySingle._(limit(1));

  /// Count number of rows in this [Query] using `COUNT(*)` aggregate
  /// function.
  ///
  /// The resulting [QuerySingle] will have exactly one row, which is the
  /// number of rows in the this query.
  ///
  /// This will count all rows, including rows with `null` values. If you
  /// don't wish to count `null` values, use [where] to filter out such
  /// rows first.
  QuerySingle<(Expr<int>,)> count() =>
      select((a, b) => (CountAllExpression._(),)).first;

  /// Create a projection of this [Query] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [Query] object which doesn't have any methods!
  ///
  /// All methods and properties on [Query<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  Query<T> select<T extends Record>(
      T Function(Expr<A> a, Expr<B> b) projectionBuilder) {
    final (handle, projection) = _build(projectionBuilder);
    return Query._(
      _context,
      projection,
      (e) => SelectFromClause._(_from(_expressions.toList()), handle, e),
    );
  }

  /// Join this [Query] with another [Query] using `INNER JOIN` clause.
  ///
  /// This method returns an [InnerJoin] object on which you must call either
  ///  * `.all` to get the cartesian product of the two queries, or,
  ///  * `.on` to specify how the two queries should be joined.
  ///
  /// This always creates a `INNER JOIN`, where the `.on` condition can be
  /// used to control how the two queries are joined.
  InnerJoin<(Expr<A>, Expr<B>), T> join<T extends Record>(Query<T> query) =>
      InnerJoin._(this, query);

  /// Join this [Query] with another [Query] using `LEFT JOIN` clause.
  ///
  /// This method returns an [LeftJoin] object on which you must call
  /// `.on` to specify how the two queries should be joined.
  ///
  /// This always creates a `LEFT JOIN`, where the `.on` condition can be
  /// used to control how the two queries are joined.
  LeftJoin<(Expr<A>, Expr<B>), T> leftJoin<T extends Record>(Query<T> query) =>
      LeftJoin._(this, query);

  /// Join this [Query] with another [Query] using `RIGHT JOIN` clause.
  ///
  /// This method returns an [RightJoin] object on which you must call
  /// `.on` to specify how the two queries should be joined.
  ///
  /// This always creates a `RIGHT JOIN`, where the `.on` condition can be
  /// used to control how the two queries are joined.
  RightJoin<(Expr<A>, Expr<B>), T> rightJoin<T extends Record>(
          Query<T> query) =>
      RightJoin._(this, query);

  /// Check for existance of rows in this [Query] using `EXISTS` operator.
  ///
  /// This returns a [QuerySingle] which contains exactly one row.
  /// The value of this query will be `true`, if this [Query] contains
  /// any rows, even if those rows are entirely `null`s.
  ///
  /// > [!TIP]
  /// > If you wish to use `.exists()` in a subquery considering
  /// > using `.asSubQuery.exists()` which returns an [Expr<bool>].
  QuerySingle<(Expr<bool>,)> exists() => QuerySingle._(Query._(
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

  /// Combine this [Query] with [other] using `UNION` _set operator_.
  ///
  /// This returns a [Query] containing all the rows from this [Query]
  /// and [other] with duplicate rows appearing only once.
  Query<(Expr<A>, Expr<B>)> union(Query<(Expr<A>, Expr<B>)> other) => Query._(
        _context,
        _expressions,
        (e) => UnionClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );

  /// Combine this [Query] with [other] using `UNION ALL` _set operator_.
  ///
  /// This returns a [Query] containing all the rows from this [Query] and
  /// [other]. Unlike `.union` this retains duplicate rows.
  Query<(Expr<A>, Expr<B>)> unionAll(Query<(Expr<A>, Expr<B>)> other) =>
      Query._(
        _context,
        _expressions,
        (e) => UnionAllClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );

  /// Combine this [Query] with [other] using `INTERSECT` _set operator_.
  ///
  /// This returns a [Query] containing all the rows that appear in both this
  /// [Query] and [other], with duplicate rows appearing only once.
  Query<(Expr<A>, Expr<B>)> intersect(Query<(Expr<A>, Expr<B>)> other) =>
      Query._(
        _context,
        _expressions,
        (e) => IntersectClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );

  /// Combine this [Query] with [other] using `EXCEPT` _set operator_.
  ///
  /// This returns a [Query] containing all the rows that appear in this
  /// [Query] and does not appear in [other], with duplicate rows appearing
  /// only once.
  Query<(Expr<A>, Expr<B>)> except(Query<(Expr<A>, Expr<B>)> other) => Query._(
        _context,
        _expressions,
        (e) => ExceptClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );

  /// Combine this [Query] with [other] using `UNION` _set operator_.
  ///
  /// This returns a [Query] containing all the rows from this [Query]
  /// and [other] with duplicate rows appearing only once.
  Query<(Expr<A>, Expr<B>)> operator -(Query<(Expr<A>, Expr<B>)> other) =>
      except(other);

  /// Combine this [Query] with [other] using `UNION ALL` _set operator_.
  ///
  /// This returns a [Query] containing all the rows from this [Query] and
  /// [other]. Unlike `.union` this retains duplicate rows.
  Query<(Expr<A>, Expr<B>)> operator +(Query<(Expr<A>, Expr<B>)> other) =>
      unionAll(other);

  /// Combine this [Query] with [other] using `INTERSECT` _set operator_.
  ///
  /// This returns a [Query] containing all the rows that appear in both this
  /// [Query] and [other], with duplicate rows appearing only once.
  Query<(Expr<A>, Expr<B>)> operator &(Query<(Expr<A>, Expr<B>)> other) =>
      intersect(other);

  /// Combine this [Query] with [other] using `EXCEPT` _set operator_.
  ///
  /// This returns a [Query] containing all the rows that appear in this
  /// [Query] and does not appear in [other], with duplicate rows appearing
  /// only once.
  Query<(Expr<A>, Expr<B>)> operator |(Query<(Expr<A>, Expr<B>)> other) =>
      union(other);

  /// Create projection for `GROUP BY` clause.
  ///
  /// The [groupBuilder] must return a [Record] where all the values are [Expr]
  /// objects. If something else is returned you will get a [Group] object which
  /// doesn't have any methods!
  ///
  /// This returns a [Group] object which has an `.aggregate` method that returns
  /// a query with a row for each distinct value of the projetion created by
  /// [groupBuilder]. The `.aggregate` method is used to construct
  /// _aggregate functions_ over rows of this [Query] for each group.
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

  /// Query the database for rows in this [Query] as a [Stream].
  Stream<(A, B)> stream() async* {
    final from = _from(_expressions.toList());
    final decode1 = _expressions.$1._decode;
    final decode2 = _expressions.$2._decode;
    final (sql, params) = _context._dialect.select(SelectStatement._(from));
    await for (final row in _context._query(sql, params)) {
      yield (decode1(row) as A, decode2(row) as B);
    }
  }

  /// Query the database for rows in this [Query] as a [List].
  Future<List<(A, B)>> fetch() async => await stream().toList();
}

/// Extension methods for a subquery returning zero or more rows with
/// 2 expressions.
extension SubQuery2<A, B> on SubQuery<(Expr<A>, Expr<B>)> {
  (Object, T) _build<T>(T Function(Expr<A> a, Expr<B> b) builder) {
    final handle = Object();
    var offset = 0;
    final a = _expressions.$1._standin(offset, handle);
    offset += _expressions.$1._columns;
    final b = _expressions.$2._standin(offset, handle);
    return (handle, builder(a, b));
  }

  /// Filter [SubQuery] using `WHERE` clause.
  ///
  /// Returns a [SubQuery] retaining rows from this [SubQuery] where the expression
  /// returned by [conditionBuilder] evaluates to `true`.
  SubQuery<(Expr<A>, Expr<B>)> where(
      Expr<bool> Function(Expr<A> a, Expr<B> b) conditionBuilder) {
    final (handle, where) = _build(conditionBuilder);
    return SubQuery._(
      _expressions,
      (e) => WhereClause._(_from(e), handle, where),
    );
  }

  /// Order [SubQuery] using `ORDER BY` clause.
  ///
  /// Returns a [SubQuery] with the same rows as this [SubQuery], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedSubQuery<(Expr<A>, Expr<B>)> orderBy(
      List<(Expr<Comparable?>, Order)> Function(Expr<A> a, Expr<B> b) builder) {
    final (handle, orderBy) = _build(builder);
    if (orderBy.isEmpty) {
      return OrderedSubQuery._(this);
    }
    return OrderedSubQuery._(SubQuery._(
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy),
    ));
  }

  /// Limit [SubQuery] using `LIMIT` clause.
  ///
  /// The resulting [SubQuery] will only return the first [limit] rows.
  SubQuery<(Expr<A>, Expr<B>)> limit(int limit) => SubQuery._(
        _expressions,
        (e) => LimitClause._(_from(e), limit),
      );

  /// Offset [SubQuery] using `OFFSET` clause.
  ///
  /// The resulting [SubQuery] will skip the first [offset] rows.
  SubQuery<(Expr<A>, Expr<B>)> offset(int offset) => SubQuery._(
        _expressions,
        (e) => OffsetClause._(_from(e), offset),
      );

  /// Count number of rows in this [SubQuery] using `COUNT(*)` aggregate
  /// function.
  ///
  /// The resulting [Expr<int>] will evaluate to the number of rows in this
  /// [SubQuery].
  ///
  /// This will count all rows, including rows with `null` values. If you
  /// don't wish to count `null` values, use [where] to filter out such
  /// rows first.
  Expr<int> count() =>
      select((a, b) => (CountAllExpression._(),)).first.asNotNull();

  /// Create a projection of this [SubQuery] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [SubQuery] object which doesn't have any methods!
  ///
  /// All methods and properties on [SubQuery<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  SubQuery<T> select<T extends Record>(
      T Function(Expr<A> a, Expr<B> b) projectionBuilder) {
    final (handle, projection) = _build(projectionBuilder);
    return SubQuery._(
      projection,
      (e) => SelectFromClause._(_from(_expressions.toList()), handle, e),
    );
  }

  /// Check for existance of rows in this [SubQuery] using `EXISTS` operator.
  ///
  /// This returns an [Expr<bool>] that evaluates to `true`, if this [SubQuery]
  /// contains any rows, even if those rows are entirely `null`s.
  Expr<bool> exists() => ExistsExpression._(_from(_expressions.toList()));
}

/// Extension methods for a query returning zero or more rows with
/// 2 expressions.
extension OrderedQuery2<A, B> on OrderedQuery<(Expr<A>, Expr<B>)> {
  /// Filter [OrderedQuery] using `WHERE` clause.
  ///
  /// Returns a [OrderedQuery] retaining rows from this [OrderedQuery] where the expression
  /// returned by [conditionBuilder] evaluates to `true`.
  OrderedQuery<(Expr<A>, Expr<B>)> where(
          Expr<bool> Function(Expr<A> a, Expr<B> b) conditionBuilder) =>
      OrderedQuery._(_query.where(conditionBuilder));

  /// Create a projection of this [OrderedQuery] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [OrderedQuery] object which doesn't have any methods!
  ///
  /// All methods and properties on [OrderedQuery<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  ProjectedOrderedQuery<T> select<T extends Record>(
          T Function(Expr<A> a, Expr<B> b) projectionBuilder) =>
      ProjectedOrderedQuery._(_query.select(projectionBuilder));

  /// Limit [OrderedQuery] using `LIMIT` clause.
  ///
  /// The resulting [OrderedQuery] will only return the first [limit] rows.
  OrderedQueryRange<(Expr<A>, Expr<B>)> limit(int limit) =>
      OrderedQueryRange._(_query.limit(limit));

  /// Offset [OrderedQuery] using `OFFSET` clause.
  ///
  /// The resulting [OrderedQuery] will skip the first [offset] rows.
  OrderedQueryRange<(Expr<A>, Expr<B>)> offset(int offset) =>
      OrderedQueryRange._(_query.offset(offset));

  /// Order [OrderedQuery] using `ORDER BY` clause.
  ///
  /// Returns a [OrderedQuery] with the same rows as this [OrderedQuery], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedQuery<(Expr<A>, Expr<B>)> orderBy(
          List<(Expr<Comparable?>, Order)> Function(Expr<A> a, Expr<B> b)
              builder) =>
      _query.orderBy(builder);

  /// Query the database for rows in this [Query] as a [List].
  Future<List<(A, B)>> fetch() => _query.fetch();

  /// Query the database for rows in this [Query] as a [Stream].
  Stream<(A, B)> stream() => _query.stream();

  /// Limit [Query] to the first row using `LIMIT` clause.
  ///
  /// This returns a [QuerySingle] which contains at-most one row.
  QuerySingle<(Expr<A>, Expr<B>)> get first => _query.first;
}

/// Extension methods for a query returning zero or more rows with
/// 2 expressions.
extension OrderedQueryRange2<A, B> on OrderedQueryRange<(Expr<A>, Expr<B>)> {
  /// Create a projection of this [OrderedQueryRange] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [OrderedQueryRange] object which doesn't have any methods!
  ///
  /// All methods and properties on [OrderedQueryRange<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  ProjectedOrderedQueryRange<T> select<T extends Record>(
          T Function(Expr<A> a, Expr<B> b) projectionBuilder) =>
      ProjectedOrderedQueryRange._(_query.select(projectionBuilder));

  /// Limit [OrderedQueryRange] using `LIMIT` clause.
  ///
  /// The resulting [OrderedQueryRange] will only return the first [limit] rows.
  OrderedQueryRange<(Expr<A>, Expr<B>)> limit(int limit) =>
      OrderedQueryRange._(_query.limit(limit));

  /// Offset [OrderedQueryRange] using `OFFSET` clause.
  ///
  /// The resulting [OrderedQueryRange] will skip the first [offset] rows.
  OrderedQueryRange<(Expr<A>, Expr<B>)> offset(int offset) =>
      OrderedQueryRange._(_query.offset(offset));

  /// Order [OrderedQueryRange] using `ORDER BY` clause.
  ///
  /// Returns a [OrderedQueryRange] with the same rows as this [OrderedQueryRange], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedQuery<(Expr<A>, Expr<B>)> orderBy(
          List<(Expr<Comparable?>, Order)> Function(Expr<A> a, Expr<B> b)
              builder) =>
      _query.orderBy(builder);

  /// Query the database for rows in this [Query] as a [List].
  Future<List<(A, B)>> fetch() => _query.fetch();

  /// Query the database for rows in this [Query] as a [Stream].
  Stream<(A, B)> stream() => _query.stream();

  /// Limit [Query] to the first row using `LIMIT` clause.
  ///
  /// This returns a [QuerySingle] which contains at-most one row.
  QuerySingle<(Expr<A>, Expr<B>)> get first => _query.first;
}

/// Extension methods for a query returning zero or more rows with
/// 2 expressions.
extension ProjectedOrderedQuery2<A, B>
    on ProjectedOrderedQuery<(Expr<A>, Expr<B>)> {
  /// Limit [ProjectedOrderedQuery] using `LIMIT` clause.
  ///
  /// The resulting [ProjectedOrderedQuery] will only return the first [limit] rows.
  ProjectedOrderedQueryRange<(Expr<A>, Expr<B>)> limit(int limit) =>
      ProjectedOrderedQueryRange._(_query.limit(limit));

  /// Offset [ProjectedOrderedQuery] using `OFFSET` clause.
  ///
  /// The resulting [ProjectedOrderedQuery] will skip the first [offset] rows.
  ProjectedOrderedQueryRange<(Expr<A>, Expr<B>)> offset(int offset) =>
      ProjectedOrderedQueryRange._(_query.offset(offset));

  /// Order [ProjectedOrderedQuery] using `ORDER BY` clause.
  ///
  /// Returns a [ProjectedOrderedQuery] with the same rows as this [ProjectedOrderedQuery], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedQuery<(Expr<A>, Expr<B>)> orderBy(
          List<(Expr<Comparable?>, Order)> Function(Expr<A> a, Expr<B> b)
              builder) =>
      _query.orderBy(builder);

  /// Query the database for rows in this [Query] as a [List].
  Future<List<(A, B)>> fetch() => _query.fetch();

  /// Query the database for rows in this [Query] as a [Stream].
  Stream<(A, B)> stream() => _query.stream();

  /// Limit [Query] to the first row using `LIMIT` clause.
  ///
  /// This returns a [QuerySingle] which contains at-most one row.
  QuerySingle<(Expr<A>, Expr<B>)> get first => _query.first;
}

/// Extension methods for a query returning zero or more rows with
/// 2 expressions.
extension ProjectedOrderedQueryRange2<A, B>
    on ProjectedOrderedQueryRange<(Expr<A>, Expr<B>)> {
  /// Limit [ProjectedOrderedQueryRange] using `LIMIT` clause.
  ///
  /// The resulting [ProjectedOrderedQueryRange] will only return the first [limit] rows.
  ProjectedOrderedQueryRange<(Expr<A>, Expr<B>)> limit(int limit) =>
      ProjectedOrderedQueryRange._(_query.limit(limit));

  /// Offset [ProjectedOrderedQueryRange] using `OFFSET` clause.
  ///
  /// The resulting [ProjectedOrderedQueryRange] will skip the first [offset] rows.
  ProjectedOrderedQueryRange<(Expr<A>, Expr<B>)> offset(int offset) =>
      ProjectedOrderedQueryRange._(_query.offset(offset));

  /// Order [ProjectedOrderedQueryRange] using `ORDER BY` clause.
  ///
  /// Returns a [ProjectedOrderedQueryRange] with the same rows as this [ProjectedOrderedQueryRange], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedQuery<(Expr<A>, Expr<B>)> orderBy(
          List<(Expr<Comparable?>, Order)> Function(Expr<A> a, Expr<B> b)
              builder) =>
      _query.orderBy(builder);

  /// Query the database for rows in this [Query] as a [List].
  Future<List<(A, B)>> fetch() => _query.fetch();

  /// Query the database for rows in this [Query] as a [Stream].
  Stream<(A, B)> stream() => _query.stream();

  /// Limit [Query] to the first row using `LIMIT` clause.
  ///
  /// This returns a [QuerySingle] which contains at-most one row.
  QuerySingle<(Expr<A>, Expr<B>)> get first => _query.first;
}

/// Extension methods for a ordered subquery of zero or more rows with
/// 2 expressions.
extension OrderedSubQuery2<A, B> on OrderedSubQuery<(Expr<A>, Expr<B>)> {
  /// Filter [OrderedSubQuery] using `WHERE` clause.
  ///
  /// Returns a [OrderedSubQuery] retaining rows from this [OrderedSubQuery] where the expression
  /// returned by [conditionBuilder] evaluates to `true`.
  OrderedSubQuery<(Expr<A>, Expr<B>)> where(
          Expr<bool> Function(Expr<A> a, Expr<B> b) conditionBuilder) =>
      OrderedSubQuery._(_query.where(conditionBuilder));

  /// Create a projection of this [OrderedSubQuery] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [OrderedSubQuery] object which doesn't have any methods!
  ///
  /// All methods and properties on [OrderedSubQuery<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  ProjectedOrderedSubQuery<T> select<T extends Record>(
          T Function(Expr<A> a, Expr<B> b) projectionBuilder) =>
      ProjectedOrderedSubQuery._(_query.select(projectionBuilder));

  /// Limit [OrderedSubQuery] using `LIMIT` clause.
  ///
  /// The resulting [OrderedSubQuery] will only return the first [limit] rows.
  OrderedSubQueryRange<(Expr<A>, Expr<B>)> limit(int limit) =>
      OrderedSubQueryRange._(_query.limit(limit));

  /// Offset [OrderedSubQuery] using `OFFSET` clause.
  ///
  /// The resulting [OrderedSubQuery] will skip the first [offset] rows.
  OrderedSubQueryRange<(Expr<A>, Expr<B>)> offset(int offset) =>
      OrderedSubQueryRange._(_query.offset(offset));

  /// Order [OrderedSubQuery] using `ORDER BY` clause.
  ///
  /// Returns a [OrderedSubQuery] with the same rows as this [OrderedSubQuery], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedSubQuery<(Expr<A>, Expr<B>)> orderBy(
          List<(Expr<Comparable?>, Order)> Function(Expr<A> a, Expr<B> b)
              builder) =>
      _query.orderBy(builder);
}

/// Extension methods for a ordered subquery of zero or more rows with
/// 2 expressions.
extension OrderedSubQueryRange2<A, B>
    on OrderedSubQueryRange<(Expr<A>, Expr<B>)> {
  /// Create a projection of this [OrderedSubQueryRange] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [OrderedSubQueryRange] object which doesn't have any methods!
  ///
  /// All methods and properties on [OrderedSubQueryRange<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  ProjectedOrderedSubQueryRange<T> select<T extends Record>(
          T Function(Expr<A> a, Expr<B> b) projectionBuilder) =>
      ProjectedOrderedSubQueryRange._(_query.select(projectionBuilder));

  /// Limit [OrderedSubQueryRange] using `LIMIT` clause.
  ///
  /// The resulting [OrderedSubQueryRange] will only return the first [limit] rows.
  OrderedSubQueryRange<(Expr<A>, Expr<B>)> limit(int limit) =>
      OrderedSubQueryRange._(_query.limit(limit));

  /// Offset [OrderedSubQueryRange] using `OFFSET` clause.
  ///
  /// The resulting [OrderedSubQueryRange] will skip the first [offset] rows.
  OrderedSubQueryRange<(Expr<A>, Expr<B>)> offset(int offset) =>
      OrderedSubQueryRange._(_query.offset(offset));

  /// Order [OrderedSubQueryRange] using `ORDER BY` clause.
  ///
  /// Returns a [OrderedSubQueryRange] with the same rows as this [OrderedSubQueryRange], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedSubQuery<(Expr<A>, Expr<B>)> orderBy(
          List<(Expr<Comparable?>, Order)> Function(Expr<A> a, Expr<B> b)
              builder) =>
      _query.orderBy(builder);
}

/// Extension methods for a ordered subquery of zero or more rows with
/// 2 expressions.
extension ProjectedOrderedSubQuery2<A, B>
    on ProjectedOrderedSubQuery<(Expr<A>, Expr<B>)> {
  /// Limit [ProjectedOrderedSubQuery] using `LIMIT` clause.
  ///
  /// The resulting [ProjectedOrderedSubQuery] will only return the first [limit] rows.
  ProjectedOrderedSubQueryRange<(Expr<A>, Expr<B>)> limit(int limit) =>
      ProjectedOrderedSubQueryRange._(_query.limit(limit));

  /// Offset [ProjectedOrderedSubQuery] using `OFFSET` clause.
  ///
  /// The resulting [ProjectedOrderedSubQuery] will skip the first [offset] rows.
  ProjectedOrderedSubQueryRange<(Expr<A>, Expr<B>)> offset(int offset) =>
      ProjectedOrderedSubQueryRange._(_query.offset(offset));

  /// Order [ProjectedOrderedSubQuery] using `ORDER BY` clause.
  ///
  /// Returns a [ProjectedOrderedSubQuery] with the same rows as this [ProjectedOrderedSubQuery], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedSubQuery<(Expr<A>, Expr<B>)> orderBy(
          List<(Expr<Comparable?>, Order)> Function(Expr<A> a, Expr<B> b)
              builder) =>
      _query.orderBy(builder);
}

/// Extension methods for a ordered subquery of zero or more rows with
/// 2 expressions.
extension ProjectedOrderedSubQueryRange2<A, B>
    on ProjectedOrderedSubQueryRange<(Expr<A>, Expr<B>)> {
  /// Limit [ProjectedOrderedSubQueryRange] using `LIMIT` clause.
  ///
  /// The resulting [ProjectedOrderedSubQueryRange] will only return the first [limit] rows.
  ProjectedOrderedSubQueryRange<(Expr<A>, Expr<B>)> limit(int limit) =>
      ProjectedOrderedSubQueryRange._(_query.limit(limit));

  /// Offset [ProjectedOrderedSubQueryRange] using `OFFSET` clause.
  ///
  /// The resulting [ProjectedOrderedSubQueryRange] will skip the first [offset] rows.
  ProjectedOrderedSubQueryRange<(Expr<A>, Expr<B>)> offset(int offset) =>
      ProjectedOrderedSubQueryRange._(_query.offset(offset));

  /// Order [ProjectedOrderedSubQueryRange] using `ORDER BY` clause.
  ///
  /// Returns a [ProjectedOrderedSubQueryRange] with the same rows as this [ProjectedOrderedSubQueryRange], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedSubQuery<(Expr<A>, Expr<B>)> orderBy(
          List<(Expr<Comparable?>, Order)> Function(Expr<A> a, Expr<B> b)
              builder) =>
      _query.orderBy(builder);
}

/// Extension methods for a query returning zero or more rows with
/// 3 expressions.
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

  /// Filter [Query] using `WHERE` clause.
  ///
  /// Returns a [Query] retaining rows from this [Query] where the expression
  /// returned by [conditionBuilder] evaluates to `true`.
  Query<(Expr<A>, Expr<B>, Expr<C>)> where(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c) conditionBuilder) {
    final (handle, where) = _build(conditionBuilder);
    return Query._(
      _context,
      _expressions,
      (e) => WhereClause._(_from(e), handle, where),
    );
  }

  /// Order [Query] using `ORDER BY` clause.
  ///
  /// Returns a [Query] with the same rows as this [Query], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedQuery<(Expr<A>, Expr<B>, Expr<C>)> orderBy(
      List<(Expr<Comparable?>, Order)> Function(Expr<A> a, Expr<B> b, Expr<C> c)
          builder) {
    final (handle, orderBy) = _build(builder);
    if (orderBy.isEmpty) {
      return OrderedQuery._(this);
    }
    return OrderedQuery._(Query._(
      _context,
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy),
    ));
  }

  /// Limit [Query] using `LIMIT` clause.
  ///
  /// The resulting [Query] will only return the first [limit] rows.
  Query<(Expr<A>, Expr<B>, Expr<C>)> limit(int limit) => Query._(
        _context,
        _expressions,
        (e) => LimitClause._(_from(e), limit),
      );

  /// Offset [Query] using `OFFSET` clause.
  ///
  /// The resulting [Query] will skip the first [offset] rows.
  Query<(Expr<A>, Expr<B>, Expr<C>)> offset(int offset) => Query._(
        _context,
        _expressions,
        (e) => OffsetClause._(_from(e), offset),
      );

  /// Limit [Query] to the first row using `LIMIT` clause.
  ///
  /// This returns a [QuerySingle] which contains at-most one row.
  QuerySingle<(Expr<A>, Expr<B>, Expr<C>)> get first => QuerySingle._(limit(1));

  /// Count number of rows in this [Query] using `COUNT(*)` aggregate
  /// function.
  ///
  /// The resulting [QuerySingle] will have exactly one row, which is the
  /// number of rows in the this query.
  ///
  /// This will count all rows, including rows with `null` values. If you
  /// don't wish to count `null` values, use [where] to filter out such
  /// rows first.
  QuerySingle<(Expr<int>,)> count() =>
      select((a, b, c) => (CountAllExpression._(),)).first;

  /// Create a projection of this [Query] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [Query] object which doesn't have any methods!
  ///
  /// All methods and properties on [Query<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  Query<T> select<T extends Record>(
      T Function(Expr<A> a, Expr<B> b, Expr<C> c) projectionBuilder) {
    final (handle, projection) = _build(projectionBuilder);
    return Query._(
      _context,
      projection,
      (e) => SelectFromClause._(_from(_expressions.toList()), handle, e),
    );
  }

  /// Join this [Query] with another [Query] using `INNER JOIN` clause.
  ///
  /// This method returns an [InnerJoin] object on which you must call either
  ///  * `.all` to get the cartesian product of the two queries, or,
  ///  * `.on` to specify how the two queries should be joined.
  ///
  /// This always creates a `INNER JOIN`, where the `.on` condition can be
  /// used to control how the two queries are joined.
  InnerJoin<(Expr<A>, Expr<B>, Expr<C>), T> join<T extends Record>(
          Query<T> query) =>
      InnerJoin._(this, query);

  /// Join this [Query] with another [Query] using `LEFT JOIN` clause.
  ///
  /// This method returns an [LeftJoin] object on which you must call
  /// `.on` to specify how the two queries should be joined.
  ///
  /// This always creates a `LEFT JOIN`, where the `.on` condition can be
  /// used to control how the two queries are joined.
  LeftJoin<(Expr<A>, Expr<B>, Expr<C>), T> leftJoin<T extends Record>(
          Query<T> query) =>
      LeftJoin._(this, query);

  /// Join this [Query] with another [Query] using `RIGHT JOIN` clause.
  ///
  /// This method returns an [RightJoin] object on which you must call
  /// `.on` to specify how the two queries should be joined.
  ///
  /// This always creates a `RIGHT JOIN`, where the `.on` condition can be
  /// used to control how the two queries are joined.
  RightJoin<(Expr<A>, Expr<B>, Expr<C>), T> rightJoin<T extends Record>(
          Query<T> query) =>
      RightJoin._(this, query);

  /// Check for existance of rows in this [Query] using `EXISTS` operator.
  ///
  /// This returns a [QuerySingle] which contains exactly one row.
  /// The value of this query will be `true`, if this [Query] contains
  /// any rows, even if those rows are entirely `null`s.
  ///
  /// > [!TIP]
  /// > If you wish to use `.exists()` in a subquery considering
  /// > using `.asSubQuery.exists()` which returns an [Expr<bool>].
  QuerySingle<(Expr<bool>,)> exists() => QuerySingle._(Query._(
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

  /// Combine this [Query] with [other] using `UNION` _set operator_.
  ///
  /// This returns a [Query] containing all the rows from this [Query]
  /// and [other] with duplicate rows appearing only once.
  Query<(Expr<A>, Expr<B>, Expr<C>)> union(
          Query<(Expr<A>, Expr<B>, Expr<C>)> other) =>
      Query._(
        _context,
        _expressions,
        (e) => UnionClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );

  /// Combine this [Query] with [other] using `UNION ALL` _set operator_.
  ///
  /// This returns a [Query] containing all the rows from this [Query] and
  /// [other]. Unlike `.union` this retains duplicate rows.
  Query<(Expr<A>, Expr<B>, Expr<C>)> unionAll(
          Query<(Expr<A>, Expr<B>, Expr<C>)> other) =>
      Query._(
        _context,
        _expressions,
        (e) => UnionAllClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );

  /// Combine this [Query] with [other] using `INTERSECT` _set operator_.
  ///
  /// This returns a [Query] containing all the rows that appear in both this
  /// [Query] and [other], with duplicate rows appearing only once.
  Query<(Expr<A>, Expr<B>, Expr<C>)> intersect(
          Query<(Expr<A>, Expr<B>, Expr<C>)> other) =>
      Query._(
        _context,
        _expressions,
        (e) => IntersectClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );

  /// Combine this [Query] with [other] using `EXCEPT` _set operator_.
  ///
  /// This returns a [Query] containing all the rows that appear in this
  /// [Query] and does not appear in [other], with duplicate rows appearing
  /// only once.
  Query<(Expr<A>, Expr<B>, Expr<C>)> except(
          Query<(Expr<A>, Expr<B>, Expr<C>)> other) =>
      Query._(
        _context,
        _expressions,
        (e) => ExceptClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );

  /// Combine this [Query] with [other] using `UNION` _set operator_.
  ///
  /// This returns a [Query] containing all the rows from this [Query]
  /// and [other] with duplicate rows appearing only once.
  Query<(Expr<A>, Expr<B>, Expr<C>)> operator -(
          Query<(Expr<A>, Expr<B>, Expr<C>)> other) =>
      except(other);

  /// Combine this [Query] with [other] using `UNION ALL` _set operator_.
  ///
  /// This returns a [Query] containing all the rows from this [Query] and
  /// [other]. Unlike `.union` this retains duplicate rows.
  Query<(Expr<A>, Expr<B>, Expr<C>)> operator +(
          Query<(Expr<A>, Expr<B>, Expr<C>)> other) =>
      unionAll(other);

  /// Combine this [Query] with [other] using `INTERSECT` _set operator_.
  ///
  /// This returns a [Query] containing all the rows that appear in both this
  /// [Query] and [other], with duplicate rows appearing only once.
  Query<(Expr<A>, Expr<B>, Expr<C>)> operator &(
          Query<(Expr<A>, Expr<B>, Expr<C>)> other) =>
      intersect(other);

  /// Combine this [Query] with [other] using `EXCEPT` _set operator_.
  ///
  /// This returns a [Query] containing all the rows that appear in this
  /// [Query] and does not appear in [other], with duplicate rows appearing
  /// only once.
  Query<(Expr<A>, Expr<B>, Expr<C>)> operator |(
          Query<(Expr<A>, Expr<B>, Expr<C>)> other) =>
      union(other);

  /// Create projection for `GROUP BY` clause.
  ///
  /// The [groupBuilder] must return a [Record] where all the values are [Expr]
  /// objects. If something else is returned you will get a [Group] object which
  /// doesn't have any methods!
  ///
  /// This returns a [Group] object which has an `.aggregate` method that returns
  /// a query with a row for each distinct value of the projetion created by
  /// [groupBuilder]. The `.aggregate` method is used to construct
  /// _aggregate functions_ over rows of this [Query] for each group.
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

  /// Query the database for rows in this [Query] as a [Stream].
  Stream<(A, B, C)> stream() async* {
    final from = _from(_expressions.toList());
    final decode1 = _expressions.$1._decode;
    final decode2 = _expressions.$2._decode;
    final decode3 = _expressions.$3._decode;
    final (sql, params) = _context._dialect.select(SelectStatement._(from));
    await for (final row in _context._query(sql, params)) {
      yield (decode1(row) as A, decode2(row) as B, decode3(row) as C);
    }
  }

  /// Query the database for rows in this [Query] as a [List].
  Future<List<(A, B, C)>> fetch() async => await stream().toList();
}

/// Extension methods for a subquery returning zero or more rows with
/// 3 expressions.
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

  /// Filter [SubQuery] using `WHERE` clause.
  ///
  /// Returns a [SubQuery] retaining rows from this [SubQuery] where the expression
  /// returned by [conditionBuilder] evaluates to `true`.
  SubQuery<(Expr<A>, Expr<B>, Expr<C>)> where(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c) conditionBuilder) {
    final (handle, where) = _build(conditionBuilder);
    return SubQuery._(
      _expressions,
      (e) => WhereClause._(_from(e), handle, where),
    );
  }

  /// Order [SubQuery] using `ORDER BY` clause.
  ///
  /// Returns a [SubQuery] with the same rows as this [SubQuery], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedSubQuery<(Expr<A>, Expr<B>, Expr<C>)> orderBy(
      List<(Expr<Comparable?>, Order)> Function(Expr<A> a, Expr<B> b, Expr<C> c)
          builder) {
    final (handle, orderBy) = _build(builder);
    if (orderBy.isEmpty) {
      return OrderedSubQuery._(this);
    }
    return OrderedSubQuery._(SubQuery._(
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy),
    ));
  }

  /// Limit [SubQuery] using `LIMIT` clause.
  ///
  /// The resulting [SubQuery] will only return the first [limit] rows.
  SubQuery<(Expr<A>, Expr<B>, Expr<C>)> limit(int limit) => SubQuery._(
        _expressions,
        (e) => LimitClause._(_from(e), limit),
      );

  /// Offset [SubQuery] using `OFFSET` clause.
  ///
  /// The resulting [SubQuery] will skip the first [offset] rows.
  SubQuery<(Expr<A>, Expr<B>, Expr<C>)> offset(int offset) => SubQuery._(
        _expressions,
        (e) => OffsetClause._(_from(e), offset),
      );

  /// Count number of rows in this [SubQuery] using `COUNT(*)` aggregate
  /// function.
  ///
  /// The resulting [Expr<int>] will evaluate to the number of rows in this
  /// [SubQuery].
  ///
  /// This will count all rows, including rows with `null` values. If you
  /// don't wish to count `null` values, use [where] to filter out such
  /// rows first.
  Expr<int> count() =>
      select((a, b, c) => (CountAllExpression._(),)).first.asNotNull();

  /// Create a projection of this [SubQuery] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [SubQuery] object which doesn't have any methods!
  ///
  /// All methods and properties on [SubQuery<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  SubQuery<T> select<T extends Record>(
      T Function(Expr<A> a, Expr<B> b, Expr<C> c) projectionBuilder) {
    final (handle, projection) = _build(projectionBuilder);
    return SubQuery._(
      projection,
      (e) => SelectFromClause._(_from(_expressions.toList()), handle, e),
    );
  }

  /// Check for existance of rows in this [SubQuery] using `EXISTS` operator.
  ///
  /// This returns an [Expr<bool>] that evaluates to `true`, if this [SubQuery]
  /// contains any rows, even if those rows are entirely `null`s.
  Expr<bool> exists() => ExistsExpression._(_from(_expressions.toList()));
}

/// Extension methods for a query returning zero or more rows with
/// 3 expressions.
extension OrderedQuery3<A, B, C> on OrderedQuery<(Expr<A>, Expr<B>, Expr<C>)> {
  /// Filter [OrderedQuery] using `WHERE` clause.
  ///
  /// Returns a [OrderedQuery] retaining rows from this [OrderedQuery] where the expression
  /// returned by [conditionBuilder] evaluates to `true`.
  OrderedQuery<(Expr<A>, Expr<B>, Expr<C>)> where(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c)
              conditionBuilder) =>
      OrderedQuery._(_query.where(conditionBuilder));

  /// Create a projection of this [OrderedQuery] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [OrderedQuery] object which doesn't have any methods!
  ///
  /// All methods and properties on [OrderedQuery<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  ProjectedOrderedQuery<T> select<T extends Record>(
          T Function(Expr<A> a, Expr<B> b, Expr<C> c) projectionBuilder) =>
      ProjectedOrderedQuery._(_query.select(projectionBuilder));

  /// Limit [OrderedQuery] using `LIMIT` clause.
  ///
  /// The resulting [OrderedQuery] will only return the first [limit] rows.
  OrderedQueryRange<(Expr<A>, Expr<B>, Expr<C>)> limit(int limit) =>
      OrderedQueryRange._(_query.limit(limit));

  /// Offset [OrderedQuery] using `OFFSET` clause.
  ///
  /// The resulting [OrderedQuery] will skip the first [offset] rows.
  OrderedQueryRange<(Expr<A>, Expr<B>, Expr<C>)> offset(int offset) =>
      OrderedQueryRange._(_query.offset(offset));

  /// Order [OrderedQuery] using `ORDER BY` clause.
  ///
  /// Returns a [OrderedQuery] with the same rows as this [OrderedQuery], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedQuery<(Expr<A>, Expr<B>, Expr<C>)> orderBy(
          List<(Expr<Comparable?>, Order)> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c)
              builder) =>
      _query.orderBy(builder);

  /// Query the database for rows in this [Query] as a [List].
  Future<List<(A, B, C)>> fetch() => _query.fetch();

  /// Query the database for rows in this [Query] as a [Stream].
  Stream<(A, B, C)> stream() => _query.stream();

  /// Limit [Query] to the first row using `LIMIT` clause.
  ///
  /// This returns a [QuerySingle] which contains at-most one row.
  QuerySingle<(Expr<A>, Expr<B>, Expr<C>)> get first => _query.first;
}

/// Extension methods for a query returning zero or more rows with
/// 3 expressions.
extension OrderedQueryRange3<A, B, C>
    on OrderedQueryRange<(Expr<A>, Expr<B>, Expr<C>)> {
  /// Create a projection of this [OrderedQueryRange] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [OrderedQueryRange] object which doesn't have any methods!
  ///
  /// All methods and properties on [OrderedQueryRange<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  ProjectedOrderedQueryRange<T> select<T extends Record>(
          T Function(Expr<A> a, Expr<B> b, Expr<C> c) projectionBuilder) =>
      ProjectedOrderedQueryRange._(_query.select(projectionBuilder));

  /// Limit [OrderedQueryRange] using `LIMIT` clause.
  ///
  /// The resulting [OrderedQueryRange] will only return the first [limit] rows.
  OrderedQueryRange<(Expr<A>, Expr<B>, Expr<C>)> limit(int limit) =>
      OrderedQueryRange._(_query.limit(limit));

  /// Offset [OrderedQueryRange] using `OFFSET` clause.
  ///
  /// The resulting [OrderedQueryRange] will skip the first [offset] rows.
  OrderedQueryRange<(Expr<A>, Expr<B>, Expr<C>)> offset(int offset) =>
      OrderedQueryRange._(_query.offset(offset));

  /// Order [OrderedQueryRange] using `ORDER BY` clause.
  ///
  /// Returns a [OrderedQueryRange] with the same rows as this [OrderedQueryRange], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedQuery<(Expr<A>, Expr<B>, Expr<C>)> orderBy(
          List<(Expr<Comparable?>, Order)> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c)
              builder) =>
      _query.orderBy(builder);

  /// Query the database for rows in this [Query] as a [List].
  Future<List<(A, B, C)>> fetch() => _query.fetch();

  /// Query the database for rows in this [Query] as a [Stream].
  Stream<(A, B, C)> stream() => _query.stream();

  /// Limit [Query] to the first row using `LIMIT` clause.
  ///
  /// This returns a [QuerySingle] which contains at-most one row.
  QuerySingle<(Expr<A>, Expr<B>, Expr<C>)> get first => _query.first;
}

/// Extension methods for a query returning zero or more rows with
/// 3 expressions.
extension ProjectedOrderedQuery3<A, B, C>
    on ProjectedOrderedQuery<(Expr<A>, Expr<B>, Expr<C>)> {
  /// Limit [ProjectedOrderedQuery] using `LIMIT` clause.
  ///
  /// The resulting [ProjectedOrderedQuery] will only return the first [limit] rows.
  ProjectedOrderedQueryRange<(Expr<A>, Expr<B>, Expr<C>)> limit(int limit) =>
      ProjectedOrderedQueryRange._(_query.limit(limit));

  /// Offset [ProjectedOrderedQuery] using `OFFSET` clause.
  ///
  /// The resulting [ProjectedOrderedQuery] will skip the first [offset] rows.
  ProjectedOrderedQueryRange<(Expr<A>, Expr<B>, Expr<C>)> offset(int offset) =>
      ProjectedOrderedQueryRange._(_query.offset(offset));

  /// Order [ProjectedOrderedQuery] using `ORDER BY` clause.
  ///
  /// Returns a [ProjectedOrderedQuery] with the same rows as this [ProjectedOrderedQuery], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedQuery<(Expr<A>, Expr<B>, Expr<C>)> orderBy(
          List<(Expr<Comparable?>, Order)> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c)
              builder) =>
      _query.orderBy(builder);

  /// Query the database for rows in this [Query] as a [List].
  Future<List<(A, B, C)>> fetch() => _query.fetch();

  /// Query the database for rows in this [Query] as a [Stream].
  Stream<(A, B, C)> stream() => _query.stream();

  /// Limit [Query] to the first row using `LIMIT` clause.
  ///
  /// This returns a [QuerySingle] which contains at-most one row.
  QuerySingle<(Expr<A>, Expr<B>, Expr<C>)> get first => _query.first;
}

/// Extension methods for a query returning zero or more rows with
/// 3 expressions.
extension ProjectedOrderedQueryRange3<A, B, C>
    on ProjectedOrderedQueryRange<(Expr<A>, Expr<B>, Expr<C>)> {
  /// Limit [ProjectedOrderedQueryRange] using `LIMIT` clause.
  ///
  /// The resulting [ProjectedOrderedQueryRange] will only return the first [limit] rows.
  ProjectedOrderedQueryRange<(Expr<A>, Expr<B>, Expr<C>)> limit(int limit) =>
      ProjectedOrderedQueryRange._(_query.limit(limit));

  /// Offset [ProjectedOrderedQueryRange] using `OFFSET` clause.
  ///
  /// The resulting [ProjectedOrderedQueryRange] will skip the first [offset] rows.
  ProjectedOrderedQueryRange<(Expr<A>, Expr<B>, Expr<C>)> offset(int offset) =>
      ProjectedOrderedQueryRange._(_query.offset(offset));

  /// Order [ProjectedOrderedQueryRange] using `ORDER BY` clause.
  ///
  /// Returns a [ProjectedOrderedQueryRange] with the same rows as this [ProjectedOrderedQueryRange], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedQuery<(Expr<A>, Expr<B>, Expr<C>)> orderBy(
          List<(Expr<Comparable?>, Order)> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c)
              builder) =>
      _query.orderBy(builder);

  /// Query the database for rows in this [Query] as a [List].
  Future<List<(A, B, C)>> fetch() => _query.fetch();

  /// Query the database for rows in this [Query] as a [Stream].
  Stream<(A, B, C)> stream() => _query.stream();

  /// Limit [Query] to the first row using `LIMIT` clause.
  ///
  /// This returns a [QuerySingle] which contains at-most one row.
  QuerySingle<(Expr<A>, Expr<B>, Expr<C>)> get first => _query.first;
}

/// Extension methods for a ordered subquery of zero or more rows with
/// 3 expressions.
extension OrderedSubQuery3<A, B, C>
    on OrderedSubQuery<(Expr<A>, Expr<B>, Expr<C>)> {
  /// Filter [OrderedSubQuery] using `WHERE` clause.
  ///
  /// Returns a [OrderedSubQuery] retaining rows from this [OrderedSubQuery] where the expression
  /// returned by [conditionBuilder] evaluates to `true`.
  OrderedSubQuery<(Expr<A>, Expr<B>, Expr<C>)> where(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c)
              conditionBuilder) =>
      OrderedSubQuery._(_query.where(conditionBuilder));

  /// Create a projection of this [OrderedSubQuery] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [OrderedSubQuery] object which doesn't have any methods!
  ///
  /// All methods and properties on [OrderedSubQuery<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  ProjectedOrderedSubQuery<T> select<T extends Record>(
          T Function(Expr<A> a, Expr<B> b, Expr<C> c) projectionBuilder) =>
      ProjectedOrderedSubQuery._(_query.select(projectionBuilder));

  /// Limit [OrderedSubQuery] using `LIMIT` clause.
  ///
  /// The resulting [OrderedSubQuery] will only return the first [limit] rows.
  OrderedSubQueryRange<(Expr<A>, Expr<B>, Expr<C>)> limit(int limit) =>
      OrderedSubQueryRange._(_query.limit(limit));

  /// Offset [OrderedSubQuery] using `OFFSET` clause.
  ///
  /// The resulting [OrderedSubQuery] will skip the first [offset] rows.
  OrderedSubQueryRange<(Expr<A>, Expr<B>, Expr<C>)> offset(int offset) =>
      OrderedSubQueryRange._(_query.offset(offset));

  /// Order [OrderedSubQuery] using `ORDER BY` clause.
  ///
  /// Returns a [OrderedSubQuery] with the same rows as this [OrderedSubQuery], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedSubQuery<(Expr<A>, Expr<B>, Expr<C>)> orderBy(
          List<(Expr<Comparable?>, Order)> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c)
              builder) =>
      _query.orderBy(builder);
}

/// Extension methods for a ordered subquery of zero or more rows with
/// 3 expressions.
extension OrderedSubQueryRange3<A, B, C>
    on OrderedSubQueryRange<(Expr<A>, Expr<B>, Expr<C>)> {
  /// Create a projection of this [OrderedSubQueryRange] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [OrderedSubQueryRange] object which doesn't have any methods!
  ///
  /// All methods and properties on [OrderedSubQueryRange<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  ProjectedOrderedSubQueryRange<T> select<T extends Record>(
          T Function(Expr<A> a, Expr<B> b, Expr<C> c) projectionBuilder) =>
      ProjectedOrderedSubQueryRange._(_query.select(projectionBuilder));

  /// Limit [OrderedSubQueryRange] using `LIMIT` clause.
  ///
  /// The resulting [OrderedSubQueryRange] will only return the first [limit] rows.
  OrderedSubQueryRange<(Expr<A>, Expr<B>, Expr<C>)> limit(int limit) =>
      OrderedSubQueryRange._(_query.limit(limit));

  /// Offset [OrderedSubQueryRange] using `OFFSET` clause.
  ///
  /// The resulting [OrderedSubQueryRange] will skip the first [offset] rows.
  OrderedSubQueryRange<(Expr<A>, Expr<B>, Expr<C>)> offset(int offset) =>
      OrderedSubQueryRange._(_query.offset(offset));

  /// Order [OrderedSubQueryRange] using `ORDER BY` clause.
  ///
  /// Returns a [OrderedSubQueryRange] with the same rows as this [OrderedSubQueryRange], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedSubQuery<(Expr<A>, Expr<B>, Expr<C>)> orderBy(
          List<(Expr<Comparable?>, Order)> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c)
              builder) =>
      _query.orderBy(builder);
}

/// Extension methods for a ordered subquery of zero or more rows with
/// 3 expressions.
extension ProjectedOrderedSubQuery3<A, B, C>
    on ProjectedOrderedSubQuery<(Expr<A>, Expr<B>, Expr<C>)> {
  /// Limit [ProjectedOrderedSubQuery] using `LIMIT` clause.
  ///
  /// The resulting [ProjectedOrderedSubQuery] will only return the first [limit] rows.
  ProjectedOrderedSubQueryRange<(Expr<A>, Expr<B>, Expr<C>)> limit(int limit) =>
      ProjectedOrderedSubQueryRange._(_query.limit(limit));

  /// Offset [ProjectedOrderedSubQuery] using `OFFSET` clause.
  ///
  /// The resulting [ProjectedOrderedSubQuery] will skip the first [offset] rows.
  ProjectedOrderedSubQueryRange<(Expr<A>, Expr<B>, Expr<C>)> offset(
          int offset) =>
      ProjectedOrderedSubQueryRange._(_query.offset(offset));

  /// Order [ProjectedOrderedSubQuery] using `ORDER BY` clause.
  ///
  /// Returns a [ProjectedOrderedSubQuery] with the same rows as this [ProjectedOrderedSubQuery], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedSubQuery<(Expr<A>, Expr<B>, Expr<C>)> orderBy(
          List<(Expr<Comparable?>, Order)> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c)
              builder) =>
      _query.orderBy(builder);
}

/// Extension methods for a ordered subquery of zero or more rows with
/// 3 expressions.
extension ProjectedOrderedSubQueryRange3<A, B, C>
    on ProjectedOrderedSubQueryRange<(Expr<A>, Expr<B>, Expr<C>)> {
  /// Limit [ProjectedOrderedSubQueryRange] using `LIMIT` clause.
  ///
  /// The resulting [ProjectedOrderedSubQueryRange] will only return the first [limit] rows.
  ProjectedOrderedSubQueryRange<(Expr<A>, Expr<B>, Expr<C>)> limit(int limit) =>
      ProjectedOrderedSubQueryRange._(_query.limit(limit));

  /// Offset [ProjectedOrderedSubQueryRange] using `OFFSET` clause.
  ///
  /// The resulting [ProjectedOrderedSubQueryRange] will skip the first [offset] rows.
  ProjectedOrderedSubQueryRange<(Expr<A>, Expr<B>, Expr<C>)> offset(
          int offset) =>
      ProjectedOrderedSubQueryRange._(_query.offset(offset));

  /// Order [ProjectedOrderedSubQueryRange] using `ORDER BY` clause.
  ///
  /// Returns a [ProjectedOrderedSubQueryRange] with the same rows as this [ProjectedOrderedSubQueryRange], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedSubQuery<(Expr<A>, Expr<B>, Expr<C>)> orderBy(
          List<(Expr<Comparable?>, Order)> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c)
              builder) =>
      _query.orderBy(builder);
}

/// Extension methods for a query returning zero or more rows with
/// 4 expressions.
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

  /// Filter [Query] using `WHERE` clause.
  ///
  /// Returns a [Query] retaining rows from this [Query] where the expression
  /// returned by [conditionBuilder] evaluates to `true`.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> where(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
          conditionBuilder) {
    final (handle, where) = _build(conditionBuilder);
    return Query._(
      _context,
      _expressions,
      (e) => WhereClause._(_from(e), handle, where),
    );
  }

  /// Order [Query] using `ORDER BY` clause.
  ///
  /// Returns a [Query] with the same rows as this [Query], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> orderBy(
      List<(Expr<Comparable?>, Order)> Function(
              Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
          builder) {
    final (handle, orderBy) = _build(builder);
    if (orderBy.isEmpty) {
      return OrderedQuery._(this);
    }
    return OrderedQuery._(Query._(
      _context,
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy),
    ));
  }

  /// Limit [Query] using `LIMIT` clause.
  ///
  /// The resulting [Query] will only return the first [limit] rows.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> limit(int limit) => Query._(
        _context,
        _expressions,
        (e) => LimitClause._(_from(e), limit),
      );

  /// Offset [Query] using `OFFSET` clause.
  ///
  /// The resulting [Query] will skip the first [offset] rows.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> offset(int offset) => Query._(
        _context,
        _expressions,
        (e) => OffsetClause._(_from(e), offset),
      );

  /// Limit [Query] to the first row using `LIMIT` clause.
  ///
  /// This returns a [QuerySingle] which contains at-most one row.
  QuerySingle<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> get first =>
      QuerySingle._(limit(1));

  /// Count number of rows in this [Query] using `COUNT(*)` aggregate
  /// function.
  ///
  /// The resulting [QuerySingle] will have exactly one row, which is the
  /// number of rows in the this query.
  ///
  /// This will count all rows, including rows with `null` values. If you
  /// don't wish to count `null` values, use [where] to filter out such
  /// rows first.
  QuerySingle<(Expr<int>,)> count() =>
      select((a, b, c, d) => (CountAllExpression._(),)).first;

  /// Create a projection of this [Query] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [Query] object which doesn't have any methods!
  ///
  /// All methods and properties on [Query<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  Query<T> select<T extends Record>(
      T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
          projectionBuilder) {
    final (handle, projection) = _build(projectionBuilder);
    return Query._(
      _context,
      projection,
      (e) => SelectFromClause._(_from(_expressions.toList()), handle, e),
    );
  }

  /// Join this [Query] with another [Query] using `INNER JOIN` clause.
  ///
  /// This method returns an [InnerJoin] object on which you must call either
  ///  * `.all` to get the cartesian product of the two queries, or,
  ///  * `.on` to specify how the two queries should be joined.
  ///
  /// This always creates a `INNER JOIN`, where the `.on` condition can be
  /// used to control how the two queries are joined.
  InnerJoin<(Expr<A>, Expr<B>, Expr<C>, Expr<D>), T> join<T extends Record>(
          Query<T> query) =>
      InnerJoin._(this, query);

  /// Join this [Query] with another [Query] using `LEFT JOIN` clause.
  ///
  /// This method returns an [LeftJoin] object on which you must call
  /// `.on` to specify how the two queries should be joined.
  ///
  /// This always creates a `LEFT JOIN`, where the `.on` condition can be
  /// used to control how the two queries are joined.
  LeftJoin<(Expr<A>, Expr<B>, Expr<C>, Expr<D>), T> leftJoin<T extends Record>(
          Query<T> query) =>
      LeftJoin._(this, query);

  /// Join this [Query] with another [Query] using `RIGHT JOIN` clause.
  ///
  /// This method returns an [RightJoin] object on which you must call
  /// `.on` to specify how the two queries should be joined.
  ///
  /// This always creates a `RIGHT JOIN`, where the `.on` condition can be
  /// used to control how the two queries are joined.
  RightJoin<(Expr<A>, Expr<B>, Expr<C>, Expr<D>), T>
      rightJoin<T extends Record>(Query<T> query) => RightJoin._(this, query);

  /// Check for existance of rows in this [Query] using `EXISTS` operator.
  ///
  /// This returns a [QuerySingle] which contains exactly one row.
  /// The value of this query will be `true`, if this [Query] contains
  /// any rows, even if those rows are entirely `null`s.
  ///
  /// > [!TIP]
  /// > If you wish to use `.exists()` in a subquery considering
  /// > using `.asSubQuery.exists()` which returns an [Expr<bool>].
  QuerySingle<(Expr<bool>,)> exists() => QuerySingle._(Query._(
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

  /// Combine this [Query] with [other] using `UNION` _set operator_.
  ///
  /// This returns a [Query] containing all the rows from this [Query]
  /// and [other] with duplicate rows appearing only once.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> union(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> other) =>
      Query._(
        _context,
        _expressions,
        (e) => UnionClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );

  /// Combine this [Query] with [other] using `UNION ALL` _set operator_.
  ///
  /// This returns a [Query] containing all the rows from this [Query] and
  /// [other]. Unlike `.union` this retains duplicate rows.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> unionAll(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> other) =>
      Query._(
        _context,
        _expressions,
        (e) => UnionAllClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );

  /// Combine this [Query] with [other] using `INTERSECT` _set operator_.
  ///
  /// This returns a [Query] containing all the rows that appear in both this
  /// [Query] and [other], with duplicate rows appearing only once.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> intersect(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> other) =>
      Query._(
        _context,
        _expressions,
        (e) => IntersectClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );

  /// Combine this [Query] with [other] using `EXCEPT` _set operator_.
  ///
  /// This returns a [Query] containing all the rows that appear in this
  /// [Query] and does not appear in [other], with duplicate rows appearing
  /// only once.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> except(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> other) =>
      Query._(
        _context,
        _expressions,
        (e) => ExceptClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );

  /// Combine this [Query] with [other] using `UNION` _set operator_.
  ///
  /// This returns a [Query] containing all the rows from this [Query]
  /// and [other] with duplicate rows appearing only once.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> operator -(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> other) =>
      except(other);

  /// Combine this [Query] with [other] using `UNION ALL` _set operator_.
  ///
  /// This returns a [Query] containing all the rows from this [Query] and
  /// [other]. Unlike `.union` this retains duplicate rows.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> operator +(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> other) =>
      unionAll(other);

  /// Combine this [Query] with [other] using `INTERSECT` _set operator_.
  ///
  /// This returns a [Query] containing all the rows that appear in both this
  /// [Query] and [other], with duplicate rows appearing only once.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> operator &(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> other) =>
      intersect(other);

  /// Combine this [Query] with [other] using `EXCEPT` _set operator_.
  ///
  /// This returns a [Query] containing all the rows that appear in this
  /// [Query] and does not appear in [other], with duplicate rows appearing
  /// only once.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> operator |(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> other) =>
      union(other);

  /// Create projection for `GROUP BY` clause.
  ///
  /// The [groupBuilder] must return a [Record] where all the values are [Expr]
  /// objects. If something else is returned you will get a [Group] object which
  /// doesn't have any methods!
  ///
  /// This returns a [Group] object which has an `.aggregate` method that returns
  /// a query with a row for each distinct value of the projetion created by
  /// [groupBuilder]. The `.aggregate` method is used to construct
  /// _aggregate functions_ over rows of this [Query] for each group.
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

  /// Query the database for rows in this [Query] as a [Stream].
  Stream<(A, B, C, D)> stream() async* {
    final from = _from(_expressions.toList());
    final decode1 = _expressions.$1._decode;
    final decode2 = _expressions.$2._decode;
    final decode3 = _expressions.$3._decode;
    final decode4 = _expressions.$4._decode;
    final (sql, params) = _context._dialect.select(SelectStatement._(from));
    await for (final row in _context._query(sql, params)) {
      yield (
        decode1(row) as A,
        decode2(row) as B,
        decode3(row) as C,
        decode4(row) as D
      );
    }
  }

  /// Query the database for rows in this [Query] as a [List].
  Future<List<(A, B, C, D)>> fetch() async => await stream().toList();
}

/// Extension methods for a subquery returning zero or more rows with
/// 4 expressions.
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

  /// Filter [SubQuery] using `WHERE` clause.
  ///
  /// Returns a [SubQuery] retaining rows from this [SubQuery] where the expression
  /// returned by [conditionBuilder] evaluates to `true`.
  SubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> where(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
          conditionBuilder) {
    final (handle, where) = _build(conditionBuilder);
    return SubQuery._(
      _expressions,
      (e) => WhereClause._(_from(e), handle, where),
    );
  }

  /// Order [SubQuery] using `ORDER BY` clause.
  ///
  /// Returns a [SubQuery] with the same rows as this [SubQuery], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedSubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> orderBy(
      List<(Expr<Comparable?>, Order)> Function(
              Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
          builder) {
    final (handle, orderBy) = _build(builder);
    if (orderBy.isEmpty) {
      return OrderedSubQuery._(this);
    }
    return OrderedSubQuery._(SubQuery._(
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy),
    ));
  }

  /// Limit [SubQuery] using `LIMIT` clause.
  ///
  /// The resulting [SubQuery] will only return the first [limit] rows.
  SubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> limit(int limit) => SubQuery._(
        _expressions,
        (e) => LimitClause._(_from(e), limit),
      );

  /// Offset [SubQuery] using `OFFSET` clause.
  ///
  /// The resulting [SubQuery] will skip the first [offset] rows.
  SubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> offset(int offset) =>
      SubQuery._(
        _expressions,
        (e) => OffsetClause._(_from(e), offset),
      );

  /// Count number of rows in this [SubQuery] using `COUNT(*)` aggregate
  /// function.
  ///
  /// The resulting [Expr<int>] will evaluate to the number of rows in this
  /// [SubQuery].
  ///
  /// This will count all rows, including rows with `null` values. If you
  /// don't wish to count `null` values, use [where] to filter out such
  /// rows first.
  Expr<int> count() =>
      select((a, b, c, d) => (CountAllExpression._(),)).first.asNotNull();

  /// Create a projection of this [SubQuery] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [SubQuery] object which doesn't have any methods!
  ///
  /// All methods and properties on [SubQuery<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  SubQuery<T> select<T extends Record>(
      T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
          projectionBuilder) {
    final (handle, projection) = _build(projectionBuilder);
    return SubQuery._(
      projection,
      (e) => SelectFromClause._(_from(_expressions.toList()), handle, e),
    );
  }

  /// Check for existance of rows in this [SubQuery] using `EXISTS` operator.
  ///
  /// This returns an [Expr<bool>] that evaluates to `true`, if this [SubQuery]
  /// contains any rows, even if those rows are entirely `null`s.
  Expr<bool> exists() => ExistsExpression._(_from(_expressions.toList()));
}

/// Extension methods for a query returning zero or more rows with
/// 4 expressions.
extension OrderedQuery4<A, B, C, D>
    on OrderedQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> {
  /// Filter [OrderedQuery] using `WHERE` clause.
  ///
  /// Returns a [OrderedQuery] retaining rows from this [OrderedQuery] where the expression
  /// returned by [conditionBuilder] evaluates to `true`.
  OrderedQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> where(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
              conditionBuilder) =>
      OrderedQuery._(_query.where(conditionBuilder));

  /// Create a projection of this [OrderedQuery] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [OrderedQuery] object which doesn't have any methods!
  ///
  /// All methods and properties on [OrderedQuery<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  ProjectedOrderedQuery<T> select<T extends Record>(
          T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
              projectionBuilder) =>
      ProjectedOrderedQuery._(_query.select(projectionBuilder));

  /// Limit [OrderedQuery] using `LIMIT` clause.
  ///
  /// The resulting [OrderedQuery] will only return the first [limit] rows.
  OrderedQueryRange<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> limit(int limit) =>
      OrderedQueryRange._(_query.limit(limit));

  /// Offset [OrderedQuery] using `OFFSET` clause.
  ///
  /// The resulting [OrderedQuery] will skip the first [offset] rows.
  OrderedQueryRange<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> offset(int offset) =>
      OrderedQueryRange._(_query.offset(offset));

  /// Order [OrderedQuery] using `ORDER BY` clause.
  ///
  /// Returns a [OrderedQuery] with the same rows as this [OrderedQuery], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> orderBy(
          List<(Expr<Comparable?>, Order)> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
              builder) =>
      _query.orderBy(builder);

  /// Query the database for rows in this [Query] as a [List].
  Future<List<(A, B, C, D)>> fetch() => _query.fetch();

  /// Query the database for rows in this [Query] as a [Stream].
  Stream<(A, B, C, D)> stream() => _query.stream();

  /// Limit [Query] to the first row using `LIMIT` clause.
  ///
  /// This returns a [QuerySingle] which contains at-most one row.
  QuerySingle<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> get first => _query.first;
}

/// Extension methods for a query returning zero or more rows with
/// 4 expressions.
extension OrderedQueryRange4<A, B, C, D>
    on OrderedQueryRange<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> {
  /// Create a projection of this [OrderedQueryRange] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [OrderedQueryRange] object which doesn't have any methods!
  ///
  /// All methods and properties on [OrderedQueryRange<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  ProjectedOrderedQueryRange<T> select<T extends Record>(
          T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
              projectionBuilder) =>
      ProjectedOrderedQueryRange._(_query.select(projectionBuilder));

  /// Limit [OrderedQueryRange] using `LIMIT` clause.
  ///
  /// The resulting [OrderedQueryRange] will only return the first [limit] rows.
  OrderedQueryRange<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> limit(int limit) =>
      OrderedQueryRange._(_query.limit(limit));

  /// Offset [OrderedQueryRange] using `OFFSET` clause.
  ///
  /// The resulting [OrderedQueryRange] will skip the first [offset] rows.
  OrderedQueryRange<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> offset(int offset) =>
      OrderedQueryRange._(_query.offset(offset));

  /// Order [OrderedQueryRange] using `ORDER BY` clause.
  ///
  /// Returns a [OrderedQueryRange] with the same rows as this [OrderedQueryRange], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> orderBy(
          List<(Expr<Comparable?>, Order)> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
              builder) =>
      _query.orderBy(builder);

  /// Query the database for rows in this [Query] as a [List].
  Future<List<(A, B, C, D)>> fetch() => _query.fetch();

  /// Query the database for rows in this [Query] as a [Stream].
  Stream<(A, B, C, D)> stream() => _query.stream();

  /// Limit [Query] to the first row using `LIMIT` clause.
  ///
  /// This returns a [QuerySingle] which contains at-most one row.
  QuerySingle<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> get first => _query.first;
}

/// Extension methods for a query returning zero or more rows with
/// 4 expressions.
extension ProjectedOrderedQuery4<A, B, C, D>
    on ProjectedOrderedQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> {
  /// Limit [ProjectedOrderedQuery] using `LIMIT` clause.
  ///
  /// The resulting [ProjectedOrderedQuery] will only return the first [limit] rows.
  ProjectedOrderedQueryRange<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> limit(
          int limit) =>
      ProjectedOrderedQueryRange._(_query.limit(limit));

  /// Offset [ProjectedOrderedQuery] using `OFFSET` clause.
  ///
  /// The resulting [ProjectedOrderedQuery] will skip the first [offset] rows.
  ProjectedOrderedQueryRange<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> offset(
          int offset) =>
      ProjectedOrderedQueryRange._(_query.offset(offset));

  /// Order [ProjectedOrderedQuery] using `ORDER BY` clause.
  ///
  /// Returns a [ProjectedOrderedQuery] with the same rows as this [ProjectedOrderedQuery], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> orderBy(
          List<(Expr<Comparable?>, Order)> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
              builder) =>
      _query.orderBy(builder);

  /// Query the database for rows in this [Query] as a [List].
  Future<List<(A, B, C, D)>> fetch() => _query.fetch();

  /// Query the database for rows in this [Query] as a [Stream].
  Stream<(A, B, C, D)> stream() => _query.stream();

  /// Limit [Query] to the first row using `LIMIT` clause.
  ///
  /// This returns a [QuerySingle] which contains at-most one row.
  QuerySingle<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> get first => _query.first;
}

/// Extension methods for a query returning zero or more rows with
/// 4 expressions.
extension ProjectedOrderedQueryRange4<A, B, C, D>
    on ProjectedOrderedQueryRange<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> {
  /// Limit [ProjectedOrderedQueryRange] using `LIMIT` clause.
  ///
  /// The resulting [ProjectedOrderedQueryRange] will only return the first [limit] rows.
  ProjectedOrderedQueryRange<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> limit(
          int limit) =>
      ProjectedOrderedQueryRange._(_query.limit(limit));

  /// Offset [ProjectedOrderedQueryRange] using `OFFSET` clause.
  ///
  /// The resulting [ProjectedOrderedQueryRange] will skip the first [offset] rows.
  ProjectedOrderedQueryRange<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> offset(
          int offset) =>
      ProjectedOrderedQueryRange._(_query.offset(offset));

  /// Order [ProjectedOrderedQueryRange] using `ORDER BY` clause.
  ///
  /// Returns a [ProjectedOrderedQueryRange] with the same rows as this [ProjectedOrderedQueryRange], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> orderBy(
          List<(Expr<Comparable?>, Order)> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
              builder) =>
      _query.orderBy(builder);

  /// Query the database for rows in this [Query] as a [List].
  Future<List<(A, B, C, D)>> fetch() => _query.fetch();

  /// Query the database for rows in this [Query] as a [Stream].
  Stream<(A, B, C, D)> stream() => _query.stream();

  /// Limit [Query] to the first row using `LIMIT` clause.
  ///
  /// This returns a [QuerySingle] which contains at-most one row.
  QuerySingle<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> get first => _query.first;
}

/// Extension methods for a ordered subquery of zero or more rows with
/// 4 expressions.
extension OrderedSubQuery4<A, B, C, D>
    on OrderedSubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> {
  /// Filter [OrderedSubQuery] using `WHERE` clause.
  ///
  /// Returns a [OrderedSubQuery] retaining rows from this [OrderedSubQuery] where the expression
  /// returned by [conditionBuilder] evaluates to `true`.
  OrderedSubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> where(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
              conditionBuilder) =>
      OrderedSubQuery._(_query.where(conditionBuilder));

  /// Create a projection of this [OrderedSubQuery] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [OrderedSubQuery] object which doesn't have any methods!
  ///
  /// All methods and properties on [OrderedSubQuery<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  ProjectedOrderedSubQuery<T> select<T extends Record>(
          T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
              projectionBuilder) =>
      ProjectedOrderedSubQuery._(_query.select(projectionBuilder));

  /// Limit [OrderedSubQuery] using `LIMIT` clause.
  ///
  /// The resulting [OrderedSubQuery] will only return the first [limit] rows.
  OrderedSubQueryRange<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> limit(int limit) =>
      OrderedSubQueryRange._(_query.limit(limit));

  /// Offset [OrderedSubQuery] using `OFFSET` clause.
  ///
  /// The resulting [OrderedSubQuery] will skip the first [offset] rows.
  OrderedSubQueryRange<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> offset(
          int offset) =>
      OrderedSubQueryRange._(_query.offset(offset));

  /// Order [OrderedSubQuery] using `ORDER BY` clause.
  ///
  /// Returns a [OrderedSubQuery] with the same rows as this [OrderedSubQuery], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedSubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> orderBy(
          List<(Expr<Comparable?>, Order)> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
              builder) =>
      _query.orderBy(builder);
}

/// Extension methods for a ordered subquery of zero or more rows with
/// 4 expressions.
extension OrderedSubQueryRange4<A, B, C, D>
    on OrderedSubQueryRange<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> {
  /// Create a projection of this [OrderedSubQueryRange] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [OrderedSubQueryRange] object which doesn't have any methods!
  ///
  /// All methods and properties on [OrderedSubQueryRange<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  ProjectedOrderedSubQueryRange<T> select<T extends Record>(
          T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
              projectionBuilder) =>
      ProjectedOrderedSubQueryRange._(_query.select(projectionBuilder));

  /// Limit [OrderedSubQueryRange] using `LIMIT` clause.
  ///
  /// The resulting [OrderedSubQueryRange] will only return the first [limit] rows.
  OrderedSubQueryRange<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> limit(int limit) =>
      OrderedSubQueryRange._(_query.limit(limit));

  /// Offset [OrderedSubQueryRange] using `OFFSET` clause.
  ///
  /// The resulting [OrderedSubQueryRange] will skip the first [offset] rows.
  OrderedSubQueryRange<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> offset(
          int offset) =>
      OrderedSubQueryRange._(_query.offset(offset));

  /// Order [OrderedSubQueryRange] using `ORDER BY` clause.
  ///
  /// Returns a [OrderedSubQueryRange] with the same rows as this [OrderedSubQueryRange], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedSubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> orderBy(
          List<(Expr<Comparable?>, Order)> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
              builder) =>
      _query.orderBy(builder);
}

/// Extension methods for a ordered subquery of zero or more rows with
/// 4 expressions.
extension ProjectedOrderedSubQuery4<A, B, C, D>
    on ProjectedOrderedSubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> {
  /// Limit [ProjectedOrderedSubQuery] using `LIMIT` clause.
  ///
  /// The resulting [ProjectedOrderedSubQuery] will only return the first [limit] rows.
  ProjectedOrderedSubQueryRange<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> limit(
          int limit) =>
      ProjectedOrderedSubQueryRange._(_query.limit(limit));

  /// Offset [ProjectedOrderedSubQuery] using `OFFSET` clause.
  ///
  /// The resulting [ProjectedOrderedSubQuery] will skip the first [offset] rows.
  ProjectedOrderedSubQueryRange<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> offset(
          int offset) =>
      ProjectedOrderedSubQueryRange._(_query.offset(offset));

  /// Order [ProjectedOrderedSubQuery] using `ORDER BY` clause.
  ///
  /// Returns a [ProjectedOrderedSubQuery] with the same rows as this [ProjectedOrderedSubQuery], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedSubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> orderBy(
          List<(Expr<Comparable?>, Order)> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
              builder) =>
      _query.orderBy(builder);
}

/// Extension methods for a ordered subquery of zero or more rows with
/// 4 expressions.
extension ProjectedOrderedSubQueryRange4<A, B, C, D>
    on ProjectedOrderedSubQueryRange<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> {
  /// Limit [ProjectedOrderedSubQueryRange] using `LIMIT` clause.
  ///
  /// The resulting [ProjectedOrderedSubQueryRange] will only return the first [limit] rows.
  ProjectedOrderedSubQueryRange<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> limit(
          int limit) =>
      ProjectedOrderedSubQueryRange._(_query.limit(limit));

  /// Offset [ProjectedOrderedSubQueryRange] using `OFFSET` clause.
  ///
  /// The resulting [ProjectedOrderedSubQueryRange] will skip the first [offset] rows.
  ProjectedOrderedSubQueryRange<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> offset(
          int offset) =>
      ProjectedOrderedSubQueryRange._(_query.offset(offset));

  /// Order [ProjectedOrderedSubQueryRange] using `ORDER BY` clause.
  ///
  /// Returns a [ProjectedOrderedSubQueryRange] with the same rows as this [ProjectedOrderedSubQueryRange], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedSubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> orderBy(
          List<(Expr<Comparable?>, Order)> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
              builder) =>
      _query.orderBy(builder);
}

/// Extension methods for a query returning zero or more rows with
/// 5 expressions.
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

  /// Filter [Query] using `WHERE` clause.
  ///
  /// Returns a [Query] retaining rows from this [Query] where the expression
  /// returned by [conditionBuilder] evaluates to `true`.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> where(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
          conditionBuilder) {
    final (handle, where) = _build(conditionBuilder);
    return Query._(
      _context,
      _expressions,
      (e) => WhereClause._(_from(e), handle, where),
    );
  }

  /// Order [Query] using `ORDER BY` clause.
  ///
  /// Returns a [Query] with the same rows as this [Query], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> orderBy(
      List<(Expr<Comparable?>, Order)> Function(
              Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
          builder) {
    final (handle, orderBy) = _build(builder);
    if (orderBy.isEmpty) {
      return OrderedQuery._(this);
    }
    return OrderedQuery._(Query._(
      _context,
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy),
    ));
  }

  /// Limit [Query] using `LIMIT` clause.
  ///
  /// The resulting [Query] will only return the first [limit] rows.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> limit(int limit) =>
      Query._(
        _context,
        _expressions,
        (e) => LimitClause._(_from(e), limit),
      );

  /// Offset [Query] using `OFFSET` clause.
  ///
  /// The resulting [Query] will skip the first [offset] rows.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> offset(int offset) =>
      Query._(
        _context,
        _expressions,
        (e) => OffsetClause._(_from(e), offset),
      );

  /// Limit [Query] to the first row using `LIMIT` clause.
  ///
  /// This returns a [QuerySingle] which contains at-most one row.
  QuerySingle<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> get first =>
      QuerySingle._(limit(1));

  /// Count number of rows in this [Query] using `COUNT(*)` aggregate
  /// function.
  ///
  /// The resulting [QuerySingle] will have exactly one row, which is the
  /// number of rows in the this query.
  ///
  /// This will count all rows, including rows with `null` values. If you
  /// don't wish to count `null` values, use [where] to filter out such
  /// rows first.
  QuerySingle<(Expr<int>,)> count() =>
      select((a, b, c, d, e) => (CountAllExpression._(),)).first;

  /// Create a projection of this [Query] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [Query] object which doesn't have any methods!
  ///
  /// All methods and properties on [Query<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  Query<T> select<T extends Record>(
      T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
          projectionBuilder) {
    final (handle, projection) = _build(projectionBuilder);
    return Query._(
      _context,
      projection,
      (e) => SelectFromClause._(_from(_expressions.toList()), handle, e),
    );
  }

  /// Join this [Query] with another [Query] using `INNER JOIN` clause.
  ///
  /// This method returns an [InnerJoin] object on which you must call either
  ///  * `.all` to get the cartesian product of the two queries, or,
  ///  * `.on` to specify how the two queries should be joined.
  ///
  /// This always creates a `INNER JOIN`, where the `.on` condition can be
  /// used to control how the two queries are joined.
  InnerJoin<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>), T>
      join<T extends Record>(Query<T> query) => InnerJoin._(this, query);

  /// Join this [Query] with another [Query] using `LEFT JOIN` clause.
  ///
  /// This method returns an [LeftJoin] object on which you must call
  /// `.on` to specify how the two queries should be joined.
  ///
  /// This always creates a `LEFT JOIN`, where the `.on` condition can be
  /// used to control how the two queries are joined.
  LeftJoin<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>), T>
      leftJoin<T extends Record>(Query<T> query) => LeftJoin._(this, query);

  /// Join this [Query] with another [Query] using `RIGHT JOIN` clause.
  ///
  /// This method returns an [RightJoin] object on which you must call
  /// `.on` to specify how the two queries should be joined.
  ///
  /// This always creates a `RIGHT JOIN`, where the `.on` condition can be
  /// used to control how the two queries are joined.
  RightJoin<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>), T>
      rightJoin<T extends Record>(Query<T> query) => RightJoin._(this, query);

  /// Check for existance of rows in this [Query] using `EXISTS` operator.
  ///
  /// This returns a [QuerySingle] which contains exactly one row.
  /// The value of this query will be `true`, if this [Query] contains
  /// any rows, even if those rows are entirely `null`s.
  ///
  /// > [!TIP]
  /// > If you wish to use `.exists()` in a subquery considering
  /// > using `.asSubQuery.exists()` which returns an [Expr<bool>].
  QuerySingle<(Expr<bool>,)> exists() => QuerySingle._(Query._(
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

  /// Combine this [Query] with [other] using `UNION` _set operator_.
  ///
  /// This returns a [Query] containing all the rows from this [Query]
  /// and [other] with duplicate rows appearing only once.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> union(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> other) =>
      Query._(
        _context,
        _expressions,
        (e) => UnionClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );

  /// Combine this [Query] with [other] using `UNION ALL` _set operator_.
  ///
  /// This returns a [Query] containing all the rows from this [Query] and
  /// [other]. Unlike `.union` this retains duplicate rows.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> unionAll(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> other) =>
      Query._(
        _context,
        _expressions,
        (e) => UnionAllClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );

  /// Combine this [Query] with [other] using `INTERSECT` _set operator_.
  ///
  /// This returns a [Query] containing all the rows that appear in both this
  /// [Query] and [other], with duplicate rows appearing only once.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> intersect(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> other) =>
      Query._(
        _context,
        _expressions,
        (e) => IntersectClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );

  /// Combine this [Query] with [other] using `EXCEPT` _set operator_.
  ///
  /// This returns a [Query] containing all the rows that appear in this
  /// [Query] and does not appear in [other], with duplicate rows appearing
  /// only once.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> except(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> other) =>
      Query._(
        _context,
        _expressions,
        (e) => ExceptClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );

  /// Combine this [Query] with [other] using `UNION` _set operator_.
  ///
  /// This returns a [Query] containing all the rows from this [Query]
  /// and [other] with duplicate rows appearing only once.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> operator -(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> other) =>
      except(other);

  /// Combine this [Query] with [other] using `UNION ALL` _set operator_.
  ///
  /// This returns a [Query] containing all the rows from this [Query] and
  /// [other]. Unlike `.union` this retains duplicate rows.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> operator +(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> other) =>
      unionAll(other);

  /// Combine this [Query] with [other] using `INTERSECT` _set operator_.
  ///
  /// This returns a [Query] containing all the rows that appear in both this
  /// [Query] and [other], with duplicate rows appearing only once.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> operator &(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> other) =>
      intersect(other);

  /// Combine this [Query] with [other] using `EXCEPT` _set operator_.
  ///
  /// This returns a [Query] containing all the rows that appear in this
  /// [Query] and does not appear in [other], with duplicate rows appearing
  /// only once.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> operator |(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> other) =>
      union(other);

  /// Create projection for `GROUP BY` clause.
  ///
  /// The [groupBuilder] must return a [Record] where all the values are [Expr]
  /// objects. If something else is returned you will get a [Group] object which
  /// doesn't have any methods!
  ///
  /// This returns a [Group] object which has an `.aggregate` method that returns
  /// a query with a row for each distinct value of the projetion created by
  /// [groupBuilder]. The `.aggregate` method is used to construct
  /// _aggregate functions_ over rows of this [Query] for each group.
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

  /// Query the database for rows in this [Query] as a [Stream].
  Stream<(A, B, C, D, E)> stream() async* {
    final from = _from(_expressions.toList());
    final decode1 = _expressions.$1._decode;
    final decode2 = _expressions.$2._decode;
    final decode3 = _expressions.$3._decode;
    final decode4 = _expressions.$4._decode;
    final decode5 = _expressions.$5._decode;
    final (sql, params) = _context._dialect.select(SelectStatement._(from));
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

  /// Query the database for rows in this [Query] as a [List].
  Future<List<(A, B, C, D, E)>> fetch() async => await stream().toList();
}

/// Extension methods for a subquery returning zero or more rows with
/// 5 expressions.
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

  /// Filter [SubQuery] using `WHERE` clause.
  ///
  /// Returns a [SubQuery] retaining rows from this [SubQuery] where the expression
  /// returned by [conditionBuilder] evaluates to `true`.
  SubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> where(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
          conditionBuilder) {
    final (handle, where) = _build(conditionBuilder);
    return SubQuery._(
      _expressions,
      (e) => WhereClause._(_from(e), handle, where),
    );
  }

  /// Order [SubQuery] using `ORDER BY` clause.
  ///
  /// Returns a [SubQuery] with the same rows as this [SubQuery], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedSubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> orderBy(
      List<(Expr<Comparable?>, Order)> Function(
              Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
          builder) {
    final (handle, orderBy) = _build(builder);
    if (orderBy.isEmpty) {
      return OrderedSubQuery._(this);
    }
    return OrderedSubQuery._(SubQuery._(
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy),
    ));
  }

  /// Limit [SubQuery] using `LIMIT` clause.
  ///
  /// The resulting [SubQuery] will only return the first [limit] rows.
  SubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> limit(int limit) =>
      SubQuery._(
        _expressions,
        (e) => LimitClause._(_from(e), limit),
      );

  /// Offset [SubQuery] using `OFFSET` clause.
  ///
  /// The resulting [SubQuery] will skip the first [offset] rows.
  SubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> offset(int offset) =>
      SubQuery._(
        _expressions,
        (e) => OffsetClause._(_from(e), offset),
      );

  /// Count number of rows in this [SubQuery] using `COUNT(*)` aggregate
  /// function.
  ///
  /// The resulting [Expr<int>] will evaluate to the number of rows in this
  /// [SubQuery].
  ///
  /// This will count all rows, including rows with `null` values. If you
  /// don't wish to count `null` values, use [where] to filter out such
  /// rows first.
  Expr<int> count() =>
      select((a, b, c, d, e) => (CountAllExpression._(),)).first.asNotNull();

  /// Create a projection of this [SubQuery] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [SubQuery] object which doesn't have any methods!
  ///
  /// All methods and properties on [SubQuery<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  SubQuery<T> select<T extends Record>(
      T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
          projectionBuilder) {
    final (handle, projection) = _build(projectionBuilder);
    return SubQuery._(
      projection,
      (e) => SelectFromClause._(_from(_expressions.toList()), handle, e),
    );
  }

  /// Check for existance of rows in this [SubQuery] using `EXISTS` operator.
  ///
  /// This returns an [Expr<bool>] that evaluates to `true`, if this [SubQuery]
  /// contains any rows, even if those rows are entirely `null`s.
  Expr<bool> exists() => ExistsExpression._(_from(_expressions.toList()));
}

/// Extension methods for a query returning zero or more rows with
/// 5 expressions.
extension OrderedQuery5<A, B, C, D, E>
    on OrderedQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> {
  /// Filter [OrderedQuery] using `WHERE` clause.
  ///
  /// Returns a [OrderedQuery] retaining rows from this [OrderedQuery] where the expression
  /// returned by [conditionBuilder] evaluates to `true`.
  OrderedQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> where(
          Expr<bool> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
              conditionBuilder) =>
      OrderedQuery._(_query.where(conditionBuilder));

  /// Create a projection of this [OrderedQuery] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [OrderedQuery] object which doesn't have any methods!
  ///
  /// All methods and properties on [OrderedQuery<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  ProjectedOrderedQuery<T> select<T extends Record>(
          T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
              projectionBuilder) =>
      ProjectedOrderedQuery._(_query.select(projectionBuilder));

  /// Limit [OrderedQuery] using `LIMIT` clause.
  ///
  /// The resulting [OrderedQuery] will only return the first [limit] rows.
  OrderedQueryRange<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> limit(
          int limit) =>
      OrderedQueryRange._(_query.limit(limit));

  /// Offset [OrderedQuery] using `OFFSET` clause.
  ///
  /// The resulting [OrderedQuery] will skip the first [offset] rows.
  OrderedQueryRange<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> offset(
          int offset) =>
      OrderedQueryRange._(_query.offset(offset));

  /// Order [OrderedQuery] using `ORDER BY` clause.
  ///
  /// Returns a [OrderedQuery] with the same rows as this [OrderedQuery], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> orderBy(
          List<(Expr<Comparable?>, Order)> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
              builder) =>
      _query.orderBy(builder);

  /// Query the database for rows in this [Query] as a [List].
  Future<List<(A, B, C, D, E)>> fetch() => _query.fetch();

  /// Query the database for rows in this [Query] as a [Stream].
  Stream<(A, B, C, D, E)> stream() => _query.stream();

  /// Limit [Query] to the first row using `LIMIT` clause.
  ///
  /// This returns a [QuerySingle] which contains at-most one row.
  QuerySingle<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> get first =>
      _query.first;
}

/// Extension methods for a query returning zero or more rows with
/// 5 expressions.
extension OrderedQueryRange5<A, B, C, D, E>
    on OrderedQueryRange<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> {
  /// Create a projection of this [OrderedQueryRange] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [OrderedQueryRange] object which doesn't have any methods!
  ///
  /// All methods and properties on [OrderedQueryRange<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  ProjectedOrderedQueryRange<T> select<T extends Record>(
          T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
              projectionBuilder) =>
      ProjectedOrderedQueryRange._(_query.select(projectionBuilder));

  /// Limit [OrderedQueryRange] using `LIMIT` clause.
  ///
  /// The resulting [OrderedQueryRange] will only return the first [limit] rows.
  OrderedQueryRange<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> limit(
          int limit) =>
      OrderedQueryRange._(_query.limit(limit));

  /// Offset [OrderedQueryRange] using `OFFSET` clause.
  ///
  /// The resulting [OrderedQueryRange] will skip the first [offset] rows.
  OrderedQueryRange<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> offset(
          int offset) =>
      OrderedQueryRange._(_query.offset(offset));

  /// Order [OrderedQueryRange] using `ORDER BY` clause.
  ///
  /// Returns a [OrderedQueryRange] with the same rows as this [OrderedQueryRange], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> orderBy(
          List<(Expr<Comparable?>, Order)> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
              builder) =>
      _query.orderBy(builder);

  /// Query the database for rows in this [Query] as a [List].
  Future<List<(A, B, C, D, E)>> fetch() => _query.fetch();

  /// Query the database for rows in this [Query] as a [Stream].
  Stream<(A, B, C, D, E)> stream() => _query.stream();

  /// Limit [Query] to the first row using `LIMIT` clause.
  ///
  /// This returns a [QuerySingle] which contains at-most one row.
  QuerySingle<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> get first =>
      _query.first;
}

/// Extension methods for a query returning zero or more rows with
/// 5 expressions.
extension ProjectedOrderedQuery5<A, B, C, D, E>
    on ProjectedOrderedQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> {
  /// Limit [ProjectedOrderedQuery] using `LIMIT` clause.
  ///
  /// The resulting [ProjectedOrderedQuery] will only return the first [limit] rows.
  ProjectedOrderedQueryRange<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)>
      limit(int limit) => ProjectedOrderedQueryRange._(_query.limit(limit));

  /// Offset [ProjectedOrderedQuery] using `OFFSET` clause.
  ///
  /// The resulting [ProjectedOrderedQuery] will skip the first [offset] rows.
  ProjectedOrderedQueryRange<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)>
      offset(int offset) => ProjectedOrderedQueryRange._(_query.offset(offset));

  /// Order [ProjectedOrderedQuery] using `ORDER BY` clause.
  ///
  /// Returns a [ProjectedOrderedQuery] with the same rows as this [ProjectedOrderedQuery], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> orderBy(
          List<(Expr<Comparable?>, Order)> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
              builder) =>
      _query.orderBy(builder);

  /// Query the database for rows in this [Query] as a [List].
  Future<List<(A, B, C, D, E)>> fetch() => _query.fetch();

  /// Query the database for rows in this [Query] as a [Stream].
  Stream<(A, B, C, D, E)> stream() => _query.stream();

  /// Limit [Query] to the first row using `LIMIT` clause.
  ///
  /// This returns a [QuerySingle] which contains at-most one row.
  QuerySingle<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> get first =>
      _query.first;
}

/// Extension methods for a query returning zero or more rows with
/// 5 expressions.
extension ProjectedOrderedQueryRange5<A, B, C, D, E>
    on ProjectedOrderedQueryRange<
        (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> {
  /// Limit [ProjectedOrderedQueryRange] using `LIMIT` clause.
  ///
  /// The resulting [ProjectedOrderedQueryRange] will only return the first [limit] rows.
  ProjectedOrderedQueryRange<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)>
      limit(int limit) => ProjectedOrderedQueryRange._(_query.limit(limit));

  /// Offset [ProjectedOrderedQueryRange] using `OFFSET` clause.
  ///
  /// The resulting [ProjectedOrderedQueryRange] will skip the first [offset] rows.
  ProjectedOrderedQueryRange<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)>
      offset(int offset) => ProjectedOrderedQueryRange._(_query.offset(offset));

  /// Order [ProjectedOrderedQueryRange] using `ORDER BY` clause.
  ///
  /// Returns a [ProjectedOrderedQueryRange] with the same rows as this [ProjectedOrderedQueryRange], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> orderBy(
          List<(Expr<Comparable?>, Order)> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
              builder) =>
      _query.orderBy(builder);

  /// Query the database for rows in this [Query] as a [List].
  Future<List<(A, B, C, D, E)>> fetch() => _query.fetch();

  /// Query the database for rows in this [Query] as a [Stream].
  Stream<(A, B, C, D, E)> stream() => _query.stream();

  /// Limit [Query] to the first row using `LIMIT` clause.
  ///
  /// This returns a [QuerySingle] which contains at-most one row.
  QuerySingle<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> get first =>
      _query.first;
}

/// Extension methods for a ordered subquery of zero or more rows with
/// 5 expressions.
extension OrderedSubQuery5<A, B, C, D, E>
    on OrderedSubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> {
  /// Filter [OrderedSubQuery] using `WHERE` clause.
  ///
  /// Returns a [OrderedSubQuery] retaining rows from this [OrderedSubQuery] where the expression
  /// returned by [conditionBuilder] evaluates to `true`.
  OrderedSubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> where(
          Expr<bool> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
              conditionBuilder) =>
      OrderedSubQuery._(_query.where(conditionBuilder));

  /// Create a projection of this [OrderedSubQuery] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [OrderedSubQuery] object which doesn't have any methods!
  ///
  /// All methods and properties on [OrderedSubQuery<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  ProjectedOrderedSubQuery<T> select<T extends Record>(
          T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
              projectionBuilder) =>
      ProjectedOrderedSubQuery._(_query.select(projectionBuilder));

  /// Limit [OrderedSubQuery] using `LIMIT` clause.
  ///
  /// The resulting [OrderedSubQuery] will only return the first [limit] rows.
  OrderedSubQueryRange<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> limit(
          int limit) =>
      OrderedSubQueryRange._(_query.limit(limit));

  /// Offset [OrderedSubQuery] using `OFFSET` clause.
  ///
  /// The resulting [OrderedSubQuery] will skip the first [offset] rows.
  OrderedSubQueryRange<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> offset(
          int offset) =>
      OrderedSubQueryRange._(_query.offset(offset));

  /// Order [OrderedSubQuery] using `ORDER BY` clause.
  ///
  /// Returns a [OrderedSubQuery] with the same rows as this [OrderedSubQuery], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedSubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> orderBy(
          List<(Expr<Comparable?>, Order)> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
              builder) =>
      _query.orderBy(builder);
}

/// Extension methods for a ordered subquery of zero or more rows with
/// 5 expressions.
extension OrderedSubQueryRange5<A, B, C, D, E>
    on OrderedSubQueryRange<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> {
  /// Create a projection of this [OrderedSubQueryRange] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [OrderedSubQueryRange] object which doesn't have any methods!
  ///
  /// All methods and properties on [OrderedSubQueryRange<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  ProjectedOrderedSubQueryRange<T> select<T extends Record>(
          T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
              projectionBuilder) =>
      ProjectedOrderedSubQueryRange._(_query.select(projectionBuilder));

  /// Limit [OrderedSubQueryRange] using `LIMIT` clause.
  ///
  /// The resulting [OrderedSubQueryRange] will only return the first [limit] rows.
  OrderedSubQueryRange<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> limit(
          int limit) =>
      OrderedSubQueryRange._(_query.limit(limit));

  /// Offset [OrderedSubQueryRange] using `OFFSET` clause.
  ///
  /// The resulting [OrderedSubQueryRange] will skip the first [offset] rows.
  OrderedSubQueryRange<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> offset(
          int offset) =>
      OrderedSubQueryRange._(_query.offset(offset));

  /// Order [OrderedSubQueryRange] using `ORDER BY` clause.
  ///
  /// Returns a [OrderedSubQueryRange] with the same rows as this [OrderedSubQueryRange], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedSubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> orderBy(
          List<(Expr<Comparable?>, Order)> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
              builder) =>
      _query.orderBy(builder);
}

/// Extension methods for a ordered subquery of zero or more rows with
/// 5 expressions.
extension ProjectedOrderedSubQuery5<A, B, C, D, E>
    on ProjectedOrderedSubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> {
  /// Limit [ProjectedOrderedSubQuery] using `LIMIT` clause.
  ///
  /// The resulting [ProjectedOrderedSubQuery] will only return the first [limit] rows.
  ProjectedOrderedSubQueryRange<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)>
      limit(int limit) => ProjectedOrderedSubQueryRange._(_query.limit(limit));

  /// Offset [ProjectedOrderedSubQuery] using `OFFSET` clause.
  ///
  /// The resulting [ProjectedOrderedSubQuery] will skip the first [offset] rows.
  ProjectedOrderedSubQueryRange<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)>
      offset(int offset) =>
          ProjectedOrderedSubQueryRange._(_query.offset(offset));

  /// Order [ProjectedOrderedSubQuery] using `ORDER BY` clause.
  ///
  /// Returns a [ProjectedOrderedSubQuery] with the same rows as this [ProjectedOrderedSubQuery], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedSubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> orderBy(
          List<(Expr<Comparable?>, Order)> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
              builder) =>
      _query.orderBy(builder);
}

/// Extension methods for a ordered subquery of zero or more rows with
/// 5 expressions.
extension ProjectedOrderedSubQueryRange5<A, B, C, D, E>
    on ProjectedOrderedSubQueryRange<
        (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> {
  /// Limit [ProjectedOrderedSubQueryRange] using `LIMIT` clause.
  ///
  /// The resulting [ProjectedOrderedSubQueryRange] will only return the first [limit] rows.
  ProjectedOrderedSubQueryRange<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)>
      limit(int limit) => ProjectedOrderedSubQueryRange._(_query.limit(limit));

  /// Offset [ProjectedOrderedSubQueryRange] using `OFFSET` clause.
  ///
  /// The resulting [ProjectedOrderedSubQueryRange] will skip the first [offset] rows.
  ProjectedOrderedSubQueryRange<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)>
      offset(int offset) =>
          ProjectedOrderedSubQueryRange._(_query.offset(offset));

  /// Order [ProjectedOrderedSubQueryRange] using `ORDER BY` clause.
  ///
  /// Returns a [ProjectedOrderedSubQueryRange] with the same rows as this [ProjectedOrderedSubQueryRange], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedSubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> orderBy(
          List<(Expr<Comparable?>, Order)> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
              builder) =>
      _query.orderBy(builder);
}

/// Extension methods for a query returning zero or more rows with
/// 6 expressions.
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

  /// Filter [Query] using `WHERE` clause.
  ///
  /// Returns a [Query] retaining rows from this [Query] where the expression
  /// returned by [conditionBuilder] evaluates to `true`.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> where(
      Expr<bool> Function(
              Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f)
          conditionBuilder) {
    final (handle, where) = _build(conditionBuilder);
    return Query._(
      _context,
      _expressions,
      (e) => WhereClause._(_from(e), handle, where),
    );
  }

  /// Order [Query] using `ORDER BY` clause.
  ///
  /// Returns a [Query] with the same rows as this [Query], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> orderBy(
      List<(Expr<Comparable?>, Order)> Function(
              Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f)
          builder) {
    final (handle, orderBy) = _build(builder);
    if (orderBy.isEmpty) {
      return OrderedQuery._(this);
    }
    return OrderedQuery._(Query._(
      _context,
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy),
    ));
  }

  /// Limit [Query] using `LIMIT` clause.
  ///
  /// The resulting [Query] will only return the first [limit] rows.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> limit(
          int limit) =>
      Query._(
        _context,
        _expressions,
        (e) => LimitClause._(_from(e), limit),
      );

  /// Offset [Query] using `OFFSET` clause.
  ///
  /// The resulting [Query] will skip the first [offset] rows.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> offset(
          int offset) =>
      Query._(
        _context,
        _expressions,
        (e) => OffsetClause._(_from(e), offset),
      );

  /// Limit [Query] to the first row using `LIMIT` clause.
  ///
  /// This returns a [QuerySingle] which contains at-most one row.
  QuerySingle<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)>
      get first => QuerySingle._(limit(1));

  /// Count number of rows in this [Query] using `COUNT(*)` aggregate
  /// function.
  ///
  /// The resulting [QuerySingle] will have exactly one row, which is the
  /// number of rows in the this query.
  ///
  /// This will count all rows, including rows with `null` values. If you
  /// don't wish to count `null` values, use [where] to filter out such
  /// rows first.
  QuerySingle<(Expr<int>,)> count() =>
      select((a, b, c, d, e, f) => (CountAllExpression._(),)).first;

  /// Create a projection of this [Query] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [Query] object which doesn't have any methods!
  ///
  /// All methods and properties on [Query<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  Query<T> select<T extends Record>(
      T Function(
              Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f)
          projectionBuilder) {
    final (handle, projection) = _build(projectionBuilder);
    return Query._(
      _context,
      projection,
      (e) => SelectFromClause._(_from(_expressions.toList()), handle, e),
    );
  }

  /// Join this [Query] with another [Query] using `INNER JOIN` clause.
  ///
  /// This method returns an [InnerJoin] object on which you must call either
  ///  * `.all` to get the cartesian product of the two queries, or,
  ///  * `.on` to specify how the two queries should be joined.
  ///
  /// This always creates a `INNER JOIN`, where the `.on` condition can be
  /// used to control how the two queries are joined.
  InnerJoin<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>), T>
      join<T extends Record>(Query<T> query) => InnerJoin._(this, query);

  /// Join this [Query] with another [Query] using `LEFT JOIN` clause.
  ///
  /// This method returns an [LeftJoin] object on which you must call
  /// `.on` to specify how the two queries should be joined.
  ///
  /// This always creates a `LEFT JOIN`, where the `.on` condition can be
  /// used to control how the two queries are joined.
  LeftJoin<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>), T>
      leftJoin<T extends Record>(Query<T> query) => LeftJoin._(this, query);

  /// Join this [Query] with another [Query] using `RIGHT JOIN` clause.
  ///
  /// This method returns an [RightJoin] object on which you must call
  /// `.on` to specify how the two queries should be joined.
  ///
  /// This always creates a `RIGHT JOIN`, where the `.on` condition can be
  /// used to control how the two queries are joined.
  RightJoin<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>), T>
      rightJoin<T extends Record>(Query<T> query) => RightJoin._(this, query);

  /// Check for existance of rows in this [Query] using `EXISTS` operator.
  ///
  /// This returns a [QuerySingle] which contains exactly one row.
  /// The value of this query will be `true`, if this [Query] contains
  /// any rows, even if those rows are entirely `null`s.
  ///
  /// > [!TIP]
  /// > If you wish to use `.exists()` in a subquery considering
  /// > using `.asSubQuery.exists()` which returns an [Expr<bool>].
  QuerySingle<(Expr<bool>,)> exists() => QuerySingle._(Query._(
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

  /// Combine this [Query] with [other] using `UNION` _set operator_.
  ///
  /// This returns a [Query] containing all the rows from this [Query]
  /// and [other] with duplicate rows appearing only once.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> union(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)>
              other) =>
      Query._(
        _context,
        _expressions,
        (e) => UnionClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );

  /// Combine this [Query] with [other] using `UNION ALL` _set operator_.
  ///
  /// This returns a [Query] containing all the rows from this [Query] and
  /// [other]. Unlike `.union` this retains duplicate rows.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> unionAll(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)>
              other) =>
      Query._(
        _context,
        _expressions,
        (e) => UnionAllClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );

  /// Combine this [Query] with [other] using `INTERSECT` _set operator_.
  ///
  /// This returns a [Query] containing all the rows that appear in both this
  /// [Query] and [other], with duplicate rows appearing only once.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> intersect(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)>
              other) =>
      Query._(
        _context,
        _expressions,
        (e) => IntersectClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );

  /// Combine this [Query] with [other] using `EXCEPT` _set operator_.
  ///
  /// This returns a [Query] containing all the rows that appear in this
  /// [Query] and does not appear in [other], with duplicate rows appearing
  /// only once.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> except(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)>
              other) =>
      Query._(
        _context,
        _expressions,
        (e) => ExceptClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );

  /// Combine this [Query] with [other] using `UNION` _set operator_.
  ///
  /// This returns a [Query] containing all the rows from this [Query]
  /// and [other] with duplicate rows appearing only once.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> operator -(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)>
              other) =>
      except(other);

  /// Combine this [Query] with [other] using `UNION ALL` _set operator_.
  ///
  /// This returns a [Query] containing all the rows from this [Query] and
  /// [other]. Unlike `.union` this retains duplicate rows.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> operator +(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)>
              other) =>
      unionAll(other);

  /// Combine this [Query] with [other] using `INTERSECT` _set operator_.
  ///
  /// This returns a [Query] containing all the rows that appear in both this
  /// [Query] and [other], with duplicate rows appearing only once.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> operator &(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)>
              other) =>
      intersect(other);

  /// Combine this [Query] with [other] using `EXCEPT` _set operator_.
  ///
  /// This returns a [Query] containing all the rows that appear in this
  /// [Query] and does not appear in [other], with duplicate rows appearing
  /// only once.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> operator |(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)>
              other) =>
      union(other);

  /// Create projection for `GROUP BY` clause.
  ///
  /// The [groupBuilder] must return a [Record] where all the values are [Expr]
  /// objects. If something else is returned you will get a [Group] object which
  /// doesn't have any methods!
  ///
  /// This returns a [Group] object which has an `.aggregate` method that returns
  /// a query with a row for each distinct value of the projetion created by
  /// [groupBuilder]. The `.aggregate` method is used to construct
  /// _aggregate functions_ over rows of this [Query] for each group.
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

  /// Query the database for rows in this [Query] as a [Stream].
  Stream<(A, B, C, D, E, F)> stream() async* {
    final from = _from(_expressions.toList());
    final decode1 = _expressions.$1._decode;
    final decode2 = _expressions.$2._decode;
    final decode3 = _expressions.$3._decode;
    final decode4 = _expressions.$4._decode;
    final decode5 = _expressions.$5._decode;
    final decode6 = _expressions.$6._decode;
    final (sql, params) = _context._dialect.select(SelectStatement._(from));
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

  /// Query the database for rows in this [Query] as a [List].
  Future<List<(A, B, C, D, E, F)>> fetch() async => await stream().toList();
}

/// Extension methods for a subquery returning zero or more rows with
/// 6 expressions.
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

  /// Filter [SubQuery] using `WHERE` clause.
  ///
  /// Returns a [SubQuery] retaining rows from this [SubQuery] where the expression
  /// returned by [conditionBuilder] evaluates to `true`.
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

  /// Order [SubQuery] using `ORDER BY` clause.
  ///
  /// Returns a [SubQuery] with the same rows as this [SubQuery], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedSubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)>
      orderBy(
          List<(Expr<Comparable?>, Order)> Function(Expr<A> a, Expr<B> b,
                  Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f)
              builder) {
    final (handle, orderBy) = _build(builder);
    if (orderBy.isEmpty) {
      return OrderedSubQuery._(this);
    }
    return OrderedSubQuery._(SubQuery._(
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy),
    ));
  }

  /// Limit [SubQuery] using `LIMIT` clause.
  ///
  /// The resulting [SubQuery] will only return the first [limit] rows.
  SubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> limit(
          int limit) =>
      SubQuery._(
        _expressions,
        (e) => LimitClause._(_from(e), limit),
      );

  /// Offset [SubQuery] using `OFFSET` clause.
  ///
  /// The resulting [SubQuery] will skip the first [offset] rows.
  SubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> offset(
          int offset) =>
      SubQuery._(
        _expressions,
        (e) => OffsetClause._(_from(e), offset),
      );

  /// Count number of rows in this [SubQuery] using `COUNT(*)` aggregate
  /// function.
  ///
  /// The resulting [Expr<int>] will evaluate to the number of rows in this
  /// [SubQuery].
  ///
  /// This will count all rows, including rows with `null` values. If you
  /// don't wish to count `null` values, use [where] to filter out such
  /// rows first.
  Expr<int> count() =>
      select((a, b, c, d, e, f) => (CountAllExpression._(),)).first.asNotNull();

  /// Create a projection of this [SubQuery] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [SubQuery] object which doesn't have any methods!
  ///
  /// All methods and properties on [SubQuery<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
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

  /// Check for existance of rows in this [SubQuery] using `EXISTS` operator.
  ///
  /// This returns an [Expr<bool>] that evaluates to `true`, if this [SubQuery]
  /// contains any rows, even if those rows are entirely `null`s.
  Expr<bool> exists() => ExistsExpression._(_from(_expressions.toList()));
}

/// Extension methods for a query returning zero or more rows with
/// 6 expressions.
extension OrderedQuery6<A, B, C, D, E, F>
    on OrderedQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> {
  /// Filter [OrderedQuery] using `WHERE` clause.
  ///
  /// Returns a [OrderedQuery] retaining rows from this [OrderedQuery] where the expression
  /// returned by [conditionBuilder] evaluates to `true`.
  OrderedQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> where(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f)
              conditionBuilder) =>
      OrderedQuery._(_query.where(conditionBuilder));

  /// Create a projection of this [OrderedQuery] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [OrderedQuery] object which doesn't have any methods!
  ///
  /// All methods and properties on [OrderedQuery<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  ProjectedOrderedQuery<T> select<T extends Record>(
          T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
                  Expr<F> f)
              projectionBuilder) =>
      ProjectedOrderedQuery._(_query.select(projectionBuilder));

  /// Limit [OrderedQuery] using `LIMIT` clause.
  ///
  /// The resulting [OrderedQuery] will only return the first [limit] rows.
  OrderedQueryRange<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)>
      limit(int limit) => OrderedQueryRange._(_query.limit(limit));

  /// Offset [OrderedQuery] using `OFFSET` clause.
  ///
  /// The resulting [OrderedQuery] will skip the first [offset] rows.
  OrderedQueryRange<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)>
      offset(int offset) => OrderedQueryRange._(_query.offset(offset));

  /// Order [OrderedQuery] using `ORDER BY` clause.
  ///
  /// Returns a [OrderedQuery] with the same rows as this [OrderedQuery], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> orderBy(
          List<(Expr<Comparable?>, Order)> Function(Expr<A> a, Expr<B> b,
                  Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f)
              builder) =>
      _query.orderBy(builder);

  /// Query the database for rows in this [Query] as a [List].
  Future<List<(A, B, C, D, E, F)>> fetch() => _query.fetch();

  /// Query the database for rows in this [Query] as a [Stream].
  Stream<(A, B, C, D, E, F)> stream() => _query.stream();

  /// Limit [Query] to the first row using `LIMIT` clause.
  ///
  /// This returns a [QuerySingle] which contains at-most one row.
  QuerySingle<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)>
      get first => _query.first;
}

/// Extension methods for a query returning zero or more rows with
/// 6 expressions.
extension OrderedQueryRange6<A, B, C, D, E, F> on OrderedQueryRange<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> {
  /// Create a projection of this [OrderedQueryRange] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [OrderedQueryRange] object which doesn't have any methods!
  ///
  /// All methods and properties on [OrderedQueryRange<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  ProjectedOrderedQueryRange<T> select<T extends Record>(
          T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
                  Expr<F> f)
              projectionBuilder) =>
      ProjectedOrderedQueryRange._(_query.select(projectionBuilder));

  /// Limit [OrderedQueryRange] using `LIMIT` clause.
  ///
  /// The resulting [OrderedQueryRange] will only return the first [limit] rows.
  OrderedQueryRange<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)>
      limit(int limit) => OrderedQueryRange._(_query.limit(limit));

  /// Offset [OrderedQueryRange] using `OFFSET` clause.
  ///
  /// The resulting [OrderedQueryRange] will skip the first [offset] rows.
  OrderedQueryRange<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)>
      offset(int offset) => OrderedQueryRange._(_query.offset(offset));

  /// Order [OrderedQueryRange] using `ORDER BY` clause.
  ///
  /// Returns a [OrderedQueryRange] with the same rows as this [OrderedQueryRange], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> orderBy(
          List<(Expr<Comparable?>, Order)> Function(Expr<A> a, Expr<B> b,
                  Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f)
              builder) =>
      _query.orderBy(builder);

  /// Query the database for rows in this [Query] as a [List].
  Future<List<(A, B, C, D, E, F)>> fetch() => _query.fetch();

  /// Query the database for rows in this [Query] as a [Stream].
  Stream<(A, B, C, D, E, F)> stream() => _query.stream();

  /// Limit [Query] to the first row using `LIMIT` clause.
  ///
  /// This returns a [QuerySingle] which contains at-most one row.
  QuerySingle<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)>
      get first => _query.first;
}

/// Extension methods for a query returning zero or more rows with
/// 6 expressions.
extension ProjectedOrderedQuery6<A, B, C, D, E, F> on ProjectedOrderedQuery<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> {
  /// Limit [ProjectedOrderedQuery] using `LIMIT` clause.
  ///
  /// The resulting [ProjectedOrderedQuery] will only return the first [limit] rows.
  ProjectedOrderedQueryRange<
      (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> limit(
          int limit) =>
      ProjectedOrderedQueryRange._(_query.limit(limit));

  /// Offset [ProjectedOrderedQuery] using `OFFSET` clause.
  ///
  /// The resulting [ProjectedOrderedQuery] will skip the first [offset] rows.
  ProjectedOrderedQueryRange<
      (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> offset(
          int offset) =>
      ProjectedOrderedQueryRange._(_query.offset(offset));

  /// Order [ProjectedOrderedQuery] using `ORDER BY` clause.
  ///
  /// Returns a [ProjectedOrderedQuery] with the same rows as this [ProjectedOrderedQuery], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> orderBy(
          List<(Expr<Comparable?>, Order)> Function(Expr<A> a, Expr<B> b,
                  Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f)
              builder) =>
      _query.orderBy(builder);

  /// Query the database for rows in this [Query] as a [List].
  Future<List<(A, B, C, D, E, F)>> fetch() => _query.fetch();

  /// Query the database for rows in this [Query] as a [Stream].
  Stream<(A, B, C, D, E, F)> stream() => _query.stream();

  /// Limit [Query] to the first row using `LIMIT` clause.
  ///
  /// This returns a [QuerySingle] which contains at-most one row.
  QuerySingle<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)>
      get first => _query.first;
}

/// Extension methods for a query returning zero or more rows with
/// 6 expressions.
extension ProjectedOrderedQueryRange6<A, B, C, D, E, F>
    on ProjectedOrderedQueryRange<
        (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> {
  /// Limit [ProjectedOrderedQueryRange] using `LIMIT` clause.
  ///
  /// The resulting [ProjectedOrderedQueryRange] will only return the first [limit] rows.
  ProjectedOrderedQueryRange<
      (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> limit(
          int limit) =>
      ProjectedOrderedQueryRange._(_query.limit(limit));

  /// Offset [ProjectedOrderedQueryRange] using `OFFSET` clause.
  ///
  /// The resulting [ProjectedOrderedQueryRange] will skip the first [offset] rows.
  ProjectedOrderedQueryRange<
      (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> offset(
          int offset) =>
      ProjectedOrderedQueryRange._(_query.offset(offset));

  /// Order [ProjectedOrderedQueryRange] using `ORDER BY` clause.
  ///
  /// Returns a [ProjectedOrderedQueryRange] with the same rows as this [ProjectedOrderedQueryRange], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> orderBy(
          List<(Expr<Comparable?>, Order)> Function(Expr<A> a, Expr<B> b,
                  Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f)
              builder) =>
      _query.orderBy(builder);

  /// Query the database for rows in this [Query] as a [List].
  Future<List<(A, B, C, D, E, F)>> fetch() => _query.fetch();

  /// Query the database for rows in this [Query] as a [Stream].
  Stream<(A, B, C, D, E, F)> stream() => _query.stream();

  /// Limit [Query] to the first row using `LIMIT` clause.
  ///
  /// This returns a [QuerySingle] which contains at-most one row.
  QuerySingle<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)>
      get first => _query.first;
}

/// Extension methods for a ordered subquery of zero or more rows with
/// 6 expressions.
extension OrderedSubQuery6<A, B, C, D, E, F>
    on OrderedSubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> {
  /// Filter [OrderedSubQuery] using `WHERE` clause.
  ///
  /// Returns a [OrderedSubQuery] retaining rows from this [OrderedSubQuery] where the expression
  /// returned by [conditionBuilder] evaluates to `true`.
  OrderedSubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> where(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f)
              conditionBuilder) =>
      OrderedSubQuery._(_query.where(conditionBuilder));

  /// Create a projection of this [OrderedSubQuery] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [OrderedSubQuery] object which doesn't have any methods!
  ///
  /// All methods and properties on [OrderedSubQuery<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  ProjectedOrderedSubQuery<T> select<T extends Record>(
          T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
                  Expr<F> f)
              projectionBuilder) =>
      ProjectedOrderedSubQuery._(_query.select(projectionBuilder));

  /// Limit [OrderedSubQuery] using `LIMIT` clause.
  ///
  /// The resulting [OrderedSubQuery] will only return the first [limit] rows.
  OrderedSubQueryRange<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)>
      limit(int limit) => OrderedSubQueryRange._(_query.limit(limit));

  /// Offset [OrderedSubQuery] using `OFFSET` clause.
  ///
  /// The resulting [OrderedSubQuery] will skip the first [offset] rows.
  OrderedSubQueryRange<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)>
      offset(int offset) => OrderedSubQueryRange._(_query.offset(offset));

  /// Order [OrderedSubQuery] using `ORDER BY` clause.
  ///
  /// Returns a [OrderedSubQuery] with the same rows as this [OrderedSubQuery], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedSubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)>
      orderBy(
              List<(Expr<Comparable?>, Order)> Function(Expr<A> a, Expr<B> b,
                      Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f)
                  builder) =>
          _query.orderBy(builder);
}

/// Extension methods for a ordered subquery of zero or more rows with
/// 6 expressions.
extension OrderedSubQueryRange6<A, B, C, D, E, F> on OrderedSubQueryRange<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> {
  /// Create a projection of this [OrderedSubQueryRange] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [OrderedSubQueryRange] object which doesn't have any methods!
  ///
  /// All methods and properties on [OrderedSubQueryRange<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  ProjectedOrderedSubQueryRange<T> select<T extends Record>(
          T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
                  Expr<F> f)
              projectionBuilder) =>
      ProjectedOrderedSubQueryRange._(_query.select(projectionBuilder));

  /// Limit [OrderedSubQueryRange] using `LIMIT` clause.
  ///
  /// The resulting [OrderedSubQueryRange] will only return the first [limit] rows.
  OrderedSubQueryRange<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)>
      limit(int limit) => OrderedSubQueryRange._(_query.limit(limit));

  /// Offset [OrderedSubQueryRange] using `OFFSET` clause.
  ///
  /// The resulting [OrderedSubQueryRange] will skip the first [offset] rows.
  OrderedSubQueryRange<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)>
      offset(int offset) => OrderedSubQueryRange._(_query.offset(offset));

  /// Order [OrderedSubQueryRange] using `ORDER BY` clause.
  ///
  /// Returns a [OrderedSubQueryRange] with the same rows as this [OrderedSubQueryRange], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedSubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)>
      orderBy(
              List<(Expr<Comparable?>, Order)> Function(Expr<A> a, Expr<B> b,
                      Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f)
                  builder) =>
          _query.orderBy(builder);
}

/// Extension methods for a ordered subquery of zero or more rows with
/// 6 expressions.
extension ProjectedOrderedSubQuery6<A, B, C, D, E, F>
    on ProjectedOrderedSubQuery<
        (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> {
  /// Limit [ProjectedOrderedSubQuery] using `LIMIT` clause.
  ///
  /// The resulting [ProjectedOrderedSubQuery] will only return the first [limit] rows.
  ProjectedOrderedSubQueryRange<
      (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> limit(
          int limit) =>
      ProjectedOrderedSubQueryRange._(_query.limit(limit));

  /// Offset [ProjectedOrderedSubQuery] using `OFFSET` clause.
  ///
  /// The resulting [ProjectedOrderedSubQuery] will skip the first [offset] rows.
  ProjectedOrderedSubQueryRange<
      (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> offset(
          int offset) =>
      ProjectedOrderedSubQueryRange._(_query.offset(offset));

  /// Order [ProjectedOrderedSubQuery] using `ORDER BY` clause.
  ///
  /// Returns a [ProjectedOrderedSubQuery] with the same rows as this [ProjectedOrderedSubQuery], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedSubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)>
      orderBy(
              List<(Expr<Comparable?>, Order)> Function(Expr<A> a, Expr<B> b,
                      Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f)
                  builder) =>
          _query.orderBy(builder);
}

/// Extension methods for a ordered subquery of zero or more rows with
/// 6 expressions.
extension ProjectedOrderedSubQueryRange6<A, B, C, D, E, F>
    on ProjectedOrderedSubQueryRange<
        (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> {
  /// Limit [ProjectedOrderedSubQueryRange] using `LIMIT` clause.
  ///
  /// The resulting [ProjectedOrderedSubQueryRange] will only return the first [limit] rows.
  ProjectedOrderedSubQueryRange<
      (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> limit(
          int limit) =>
      ProjectedOrderedSubQueryRange._(_query.limit(limit));

  /// Offset [ProjectedOrderedSubQueryRange] using `OFFSET` clause.
  ///
  /// The resulting [ProjectedOrderedSubQueryRange] will skip the first [offset] rows.
  ProjectedOrderedSubQueryRange<
      (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> offset(
          int offset) =>
      ProjectedOrderedSubQueryRange._(_query.offset(offset));

  /// Order [ProjectedOrderedSubQueryRange] using `ORDER BY` clause.
  ///
  /// Returns a [ProjectedOrderedSubQueryRange] with the same rows as this [ProjectedOrderedSubQueryRange], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedSubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)>
      orderBy(
              List<(Expr<Comparable?>, Order)> Function(Expr<A> a, Expr<B> b,
                      Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f)
                  builder) =>
          _query.orderBy(builder);
}

/// Extension methods for a query returning zero or more rows with
/// 7 expressions.
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

  /// Filter [Query] using `WHERE` clause.
  ///
  /// Returns a [Query] retaining rows from this [Query] where the expression
  /// returned by [conditionBuilder] evaluates to `true`.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> where(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
              Expr<F> f, Expr<G> g)
          conditionBuilder) {
    final (handle, where) = _build(conditionBuilder);
    return Query._(
      _context,
      _expressions,
      (e) => WhereClause._(_from(e), handle, where),
    );
  }

  /// Order [Query] using `ORDER BY` clause.
  ///
  /// Returns a [Query] with the same rows as this [Query], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
      orderBy(
          List<(Expr<Comparable?>, Order)> Function(Expr<A> a, Expr<B> b,
                  Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f, Expr<G> g)
              builder) {
    final (handle, orderBy) = _build(builder);
    if (orderBy.isEmpty) {
      return OrderedQuery._(this);
    }
    return OrderedQuery._(Query._(
      _context,
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy),
    ));
  }

  /// Limit [Query] using `LIMIT` clause.
  ///
  /// The resulting [Query] will only return the first [limit] rows.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> limit(
          int limit) =>
      Query._(
        _context,
        _expressions,
        (e) => LimitClause._(_from(e), limit),
      );

  /// Offset [Query] using `OFFSET` clause.
  ///
  /// The resulting [Query] will skip the first [offset] rows.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> offset(
          int offset) =>
      Query._(
        _context,
        _expressions,
        (e) => OffsetClause._(_from(e), offset),
      );

  /// Limit [Query] to the first row using `LIMIT` clause.
  ///
  /// This returns a [QuerySingle] which contains at-most one row.
  QuerySingle<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
      get first => QuerySingle._(limit(1));

  /// Count number of rows in this [Query] using `COUNT(*)` aggregate
  /// function.
  ///
  /// The resulting [QuerySingle] will have exactly one row, which is the
  /// number of rows in the this query.
  ///
  /// This will count all rows, including rows with `null` values. If you
  /// don't wish to count `null` values, use [where] to filter out such
  /// rows first.
  QuerySingle<(Expr<int>,)> count() =>
      select((a, b, c, d, e, f, g) => (CountAllExpression._(),)).first;

  /// Create a projection of this [Query] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [Query] object which doesn't have any methods!
  ///
  /// All methods and properties on [Query<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  Query<T> select<T extends Record>(
      T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
              Expr<F> f, Expr<G> g)
          projectionBuilder) {
    final (handle, projection) = _build(projectionBuilder);
    return Query._(
      _context,
      projection,
      (e) => SelectFromClause._(_from(_expressions.toList()), handle, e),
    );
  }

  /// Join this [Query] with another [Query] using `INNER JOIN` clause.
  ///
  /// This method returns an [InnerJoin] object on which you must call either
  ///  * `.all` to get the cartesian product of the two queries, or,
  ///  * `.on` to specify how the two queries should be joined.
  ///
  /// This always creates a `INNER JOIN`, where the `.on` condition can be
  /// used to control how the two queries are joined.
  InnerJoin<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>), T>
      join<T extends Record>(Query<T> query) => InnerJoin._(this, query);

  /// Join this [Query] with another [Query] using `LEFT JOIN` clause.
  ///
  /// This method returns an [LeftJoin] object on which you must call
  /// `.on` to specify how the two queries should be joined.
  ///
  /// This always creates a `LEFT JOIN`, where the `.on` condition can be
  /// used to control how the two queries are joined.
  LeftJoin<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>), T>
      leftJoin<T extends Record>(Query<T> query) => LeftJoin._(this, query);

  /// Join this [Query] with another [Query] using `RIGHT JOIN` clause.
  ///
  /// This method returns an [RightJoin] object on which you must call
  /// `.on` to specify how the two queries should be joined.
  ///
  /// This always creates a `RIGHT JOIN`, where the `.on` condition can be
  /// used to control how the two queries are joined.
  RightJoin<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>), T>
      rightJoin<T extends Record>(Query<T> query) => RightJoin._(this, query);

  /// Check for existance of rows in this [Query] using `EXISTS` operator.
  ///
  /// This returns a [QuerySingle] which contains exactly one row.
  /// The value of this query will be `true`, if this [Query] contains
  /// any rows, even if those rows are entirely `null`s.
  ///
  /// > [!TIP]
  /// > If you wish to use `.exists()` in a subquery considering
  /// > using `.asSubQuery.exists()` which returns an [Expr<bool>].
  QuerySingle<(Expr<bool>,)> exists() => QuerySingle._(Query._(
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

  /// Combine this [Query] with [other] using `UNION` _set operator_.
  ///
  /// This returns a [Query] containing all the rows from this [Query]
  /// and [other] with duplicate rows appearing only once.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> union(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
              other) =>
      Query._(
        _context,
        _expressions,
        (e) => UnionClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );

  /// Combine this [Query] with [other] using `UNION ALL` _set operator_.
  ///
  /// This returns a [Query] containing all the rows from this [Query] and
  /// [other]. Unlike `.union` this retains duplicate rows.
  Query<
      (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> unionAll(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
              other) =>
      Query._(
        _context,
        _expressions,
        (e) => UnionAllClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );

  /// Combine this [Query] with [other] using `INTERSECT` _set operator_.
  ///
  /// This returns a [Query] containing all the rows that appear in both this
  /// [Query] and [other], with duplicate rows appearing only once.
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
      Query._(
        _context,
        _expressions,
        (e) => IntersectClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );

  /// Combine this [Query] with [other] using `EXCEPT` _set operator_.
  ///
  /// This returns a [Query] containing all the rows that appear in this
  /// [Query] and does not appear in [other], with duplicate rows appearing
  /// only once.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> except(
          Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
              other) =>
      Query._(
        _context,
        _expressions,
        (e) => ExceptClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );

  /// Combine this [Query] with [other] using `UNION` _set operator_.
  ///
  /// This returns a [Query] containing all the rows from this [Query]
  /// and [other] with duplicate rows appearing only once.
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

  /// Combine this [Query] with [other] using `UNION ALL` _set operator_.
  ///
  /// This returns a [Query] containing all the rows from this [Query] and
  /// [other]. Unlike `.union` this retains duplicate rows.
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

  /// Combine this [Query] with [other] using `INTERSECT` _set operator_.
  ///
  /// This returns a [Query] containing all the rows that appear in both this
  /// [Query] and [other], with duplicate rows appearing only once.
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

  /// Combine this [Query] with [other] using `EXCEPT` _set operator_.
  ///
  /// This returns a [Query] containing all the rows that appear in this
  /// [Query] and does not appear in [other], with duplicate rows appearing
  /// only once.
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

  /// Create projection for `GROUP BY` clause.
  ///
  /// The [groupBuilder] must return a [Record] where all the values are [Expr]
  /// objects. If something else is returned you will get a [Group] object which
  /// doesn't have any methods!
  ///
  /// This returns a [Group] object which has an `.aggregate` method that returns
  /// a query with a row for each distinct value of the projetion created by
  /// [groupBuilder]. The `.aggregate` method is used to construct
  /// _aggregate functions_ over rows of this [Query] for each group.
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

  /// Query the database for rows in this [Query] as a [Stream].
  Stream<(A, B, C, D, E, F, G)> stream() async* {
    final from = _from(_expressions.toList());
    final decode1 = _expressions.$1._decode;
    final decode2 = _expressions.$2._decode;
    final decode3 = _expressions.$3._decode;
    final decode4 = _expressions.$4._decode;
    final decode5 = _expressions.$5._decode;
    final decode6 = _expressions.$6._decode;
    final decode7 = _expressions.$7._decode;
    final (sql, params) = _context._dialect.select(SelectStatement._(from));
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

  /// Query the database for rows in this [Query] as a [List].
  Future<List<(A, B, C, D, E, F, G)>> fetch() async => await stream().toList();
}

/// Extension methods for a subquery returning zero or more rows with
/// 7 expressions.
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

  /// Filter [SubQuery] using `WHERE` clause.
  ///
  /// Returns a [SubQuery] retaining rows from this [SubQuery] where the expression
  /// returned by [conditionBuilder] evaluates to `true`.
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

  /// Order [SubQuery] using `ORDER BY` clause.
  ///
  /// Returns a [SubQuery] with the same rows as this [SubQuery], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedSubQuery<
          (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
      orderBy(
          List<(Expr<Comparable?>, Order)> Function(Expr<A> a, Expr<B> b,
                  Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f, Expr<G> g)
              builder) {
    final (handle, orderBy) = _build(builder);
    if (orderBy.isEmpty) {
      return OrderedSubQuery._(this);
    }
    return OrderedSubQuery._(SubQuery._(
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy),
    ));
  }

  /// Limit [SubQuery] using `LIMIT` clause.
  ///
  /// The resulting [SubQuery] will only return the first [limit] rows.
  SubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
      limit(int limit) => SubQuery._(
            _expressions,
            (e) => LimitClause._(_from(e), limit),
          );

  /// Offset [SubQuery] using `OFFSET` clause.
  ///
  /// The resulting [SubQuery] will skip the first [offset] rows.
  SubQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
      offset(int offset) => SubQuery._(
            _expressions,
            (e) => OffsetClause._(_from(e), offset),
          );

  /// Count number of rows in this [SubQuery] using `COUNT(*)` aggregate
  /// function.
  ///
  /// The resulting [Expr<int>] will evaluate to the number of rows in this
  /// [SubQuery].
  ///
  /// This will count all rows, including rows with `null` values. If you
  /// don't wish to count `null` values, use [where] to filter out such
  /// rows first.
  Expr<int> count() =>
      select((a, b, c, d, e, f, g) => (CountAllExpression._(),))
          .first
          .asNotNull();

  /// Create a projection of this [SubQuery] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [SubQuery] object which doesn't have any methods!
  ///
  /// All methods and properties on [SubQuery<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
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

  /// Check for existance of rows in this [SubQuery] using `EXISTS` operator.
  ///
  /// This returns an [Expr<bool>] that evaluates to `true`, if this [SubQuery]
  /// contains any rows, even if those rows are entirely `null`s.
  Expr<bool> exists() => ExistsExpression._(_from(_expressions.toList()));
}

/// Extension methods for a query returning zero or more rows with
/// 7 expressions.
extension OrderedQuery7<A, B, C, D, E, F, G> on OrderedQuery<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> {
  /// Filter [OrderedQuery] using `WHERE` clause.
  ///
  /// Returns a [OrderedQuery] retaining rows from this [OrderedQuery] where the expression
  /// returned by [conditionBuilder] evaluates to `true`.
  OrderedQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
      where(
              Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                      Expr<E> e, Expr<F> f, Expr<G> g)
                  conditionBuilder) =>
          OrderedQuery._(_query.where(conditionBuilder));

  /// Create a projection of this [OrderedQuery] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [OrderedQuery] object which doesn't have any methods!
  ///
  /// All methods and properties on [OrderedQuery<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  ProjectedOrderedQuery<T> select<T extends Record>(
          T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
                  Expr<F> f, Expr<G> g)
              projectionBuilder) =>
      ProjectedOrderedQuery._(_query.select(projectionBuilder));

  /// Limit [OrderedQuery] using `LIMIT` clause.
  ///
  /// The resulting [OrderedQuery] will only return the first [limit] rows.
  OrderedQueryRange<
      (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> limit(
          int limit) =>
      OrderedQueryRange._(_query.limit(limit));

  /// Offset [OrderedQuery] using `OFFSET` clause.
  ///
  /// The resulting [OrderedQuery] will skip the first [offset] rows.
  OrderedQueryRange<
      (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> offset(
          int offset) =>
      OrderedQueryRange._(_query.offset(offset));

  /// Order [OrderedQuery] using `ORDER BY` clause.
  ///
  /// Returns a [OrderedQuery] with the same rows as this [OrderedQuery], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
      orderBy(
              List<(Expr<Comparable?>, Order)> Function(Expr<A> a, Expr<B> b,
                      Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f, Expr<G> g)
                  builder) =>
          _query.orderBy(builder);

  /// Query the database for rows in this [Query] as a [List].
  Future<List<(A, B, C, D, E, F, G)>> fetch() => _query.fetch();

  /// Query the database for rows in this [Query] as a [Stream].
  Stream<(A, B, C, D, E, F, G)> stream() => _query.stream();

  /// Limit [Query] to the first row using `LIMIT` clause.
  ///
  /// This returns a [QuerySingle] which contains at-most one row.
  QuerySingle<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
      get first => _query.first;
}

/// Extension methods for a query returning zero or more rows with
/// 7 expressions.
extension OrderedQueryRange7<A, B, C, D, E, F, G> on OrderedQueryRange<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> {
  /// Create a projection of this [OrderedQueryRange] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [OrderedQueryRange] object which doesn't have any methods!
  ///
  /// All methods and properties on [OrderedQueryRange<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  ProjectedOrderedQueryRange<T> select<T extends Record>(
          T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
                  Expr<F> f, Expr<G> g)
              projectionBuilder) =>
      ProjectedOrderedQueryRange._(_query.select(projectionBuilder));

  /// Limit [OrderedQueryRange] using `LIMIT` clause.
  ///
  /// The resulting [OrderedQueryRange] will only return the first [limit] rows.
  OrderedQueryRange<
      (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> limit(
          int limit) =>
      OrderedQueryRange._(_query.limit(limit));

  /// Offset [OrderedQueryRange] using `OFFSET` clause.
  ///
  /// The resulting [OrderedQueryRange] will skip the first [offset] rows.
  OrderedQueryRange<
      (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> offset(
          int offset) =>
      OrderedQueryRange._(_query.offset(offset));

  /// Order [OrderedQueryRange] using `ORDER BY` clause.
  ///
  /// Returns a [OrderedQueryRange] with the same rows as this [OrderedQueryRange], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
      orderBy(
              List<(Expr<Comparable?>, Order)> Function(Expr<A> a, Expr<B> b,
                      Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f, Expr<G> g)
                  builder) =>
          _query.orderBy(builder);

  /// Query the database for rows in this [Query] as a [List].
  Future<List<(A, B, C, D, E, F, G)>> fetch() => _query.fetch();

  /// Query the database for rows in this [Query] as a [Stream].
  Stream<(A, B, C, D, E, F, G)> stream() => _query.stream();

  /// Limit [Query] to the first row using `LIMIT` clause.
  ///
  /// This returns a [QuerySingle] which contains at-most one row.
  QuerySingle<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
      get first => _query.first;
}

/// Extension methods for a query returning zero or more rows with
/// 7 expressions.
extension ProjectedOrderedQuery7<A, B, C, D, E, F, G> on ProjectedOrderedQuery<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> {
  /// Limit [ProjectedOrderedQuery] using `LIMIT` clause.
  ///
  /// The resulting [ProjectedOrderedQuery] will only return the first [limit] rows.
  ProjectedOrderedQueryRange<
      (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> limit(
          int limit) =>
      ProjectedOrderedQueryRange._(_query.limit(limit));

  /// Offset [ProjectedOrderedQuery] using `OFFSET` clause.
  ///
  /// The resulting [ProjectedOrderedQuery] will skip the first [offset] rows.
  ProjectedOrderedQueryRange<
      (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> offset(
          int offset) =>
      ProjectedOrderedQueryRange._(_query.offset(offset));

  /// Order [ProjectedOrderedQuery] using `ORDER BY` clause.
  ///
  /// Returns a [ProjectedOrderedQuery] with the same rows as this [ProjectedOrderedQuery], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
      orderBy(
              List<(Expr<Comparable?>, Order)> Function(Expr<A> a, Expr<B> b,
                      Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f, Expr<G> g)
                  builder) =>
          _query.orderBy(builder);

  /// Query the database for rows in this [Query] as a [List].
  Future<List<(A, B, C, D, E, F, G)>> fetch() => _query.fetch();

  /// Query the database for rows in this [Query] as a [Stream].
  Stream<(A, B, C, D, E, F, G)> stream() => _query.stream();

  /// Limit [Query] to the first row using `LIMIT` clause.
  ///
  /// This returns a [QuerySingle] which contains at-most one row.
  QuerySingle<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
      get first => _query.first;
}

/// Extension methods for a query returning zero or more rows with
/// 7 expressions.
extension ProjectedOrderedQueryRange7<A, B, C, D, E, F, G>
    on ProjectedOrderedQueryRange<
        (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> {
  /// Limit [ProjectedOrderedQueryRange] using `LIMIT` clause.
  ///
  /// The resulting [ProjectedOrderedQueryRange] will only return the first [limit] rows.
  ProjectedOrderedQueryRange<
      (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> limit(
          int limit) =>
      ProjectedOrderedQueryRange._(_query.limit(limit));

  /// Offset [ProjectedOrderedQueryRange] using `OFFSET` clause.
  ///
  /// The resulting [ProjectedOrderedQueryRange] will skip the first [offset] rows.
  ProjectedOrderedQueryRange<
      (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> offset(
          int offset) =>
      ProjectedOrderedQueryRange._(_query.offset(offset));

  /// Order [ProjectedOrderedQueryRange] using `ORDER BY` clause.
  ///
  /// Returns a [ProjectedOrderedQueryRange] with the same rows as this [ProjectedOrderedQueryRange], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedQuery<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
      orderBy(
              List<(Expr<Comparable?>, Order)> Function(Expr<A> a, Expr<B> b,
                      Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f, Expr<G> g)
                  builder) =>
          _query.orderBy(builder);

  /// Query the database for rows in this [Query] as a [List].
  Future<List<(A, B, C, D, E, F, G)>> fetch() => _query.fetch();

  /// Query the database for rows in this [Query] as a [Stream].
  Stream<(A, B, C, D, E, F, G)> stream() => _query.stream();

  /// Limit [Query] to the first row using `LIMIT` clause.
  ///
  /// This returns a [QuerySingle] which contains at-most one row.
  QuerySingle<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
      get first => _query.first;
}

/// Extension methods for a ordered subquery of zero or more rows with
/// 7 expressions.
extension OrderedSubQuery7<A, B, C, D, E, F, G> on OrderedSubQuery<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> {
  /// Filter [OrderedSubQuery] using `WHERE` clause.
  ///
  /// Returns a [OrderedSubQuery] retaining rows from this [OrderedSubQuery] where the expression
  /// returned by [conditionBuilder] evaluates to `true`.
  OrderedSubQuery<
      (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> where(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g)
              conditionBuilder) =>
      OrderedSubQuery._(_query.where(conditionBuilder));

  /// Create a projection of this [OrderedSubQuery] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [OrderedSubQuery] object which doesn't have any methods!
  ///
  /// All methods and properties on [OrderedSubQuery<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  ProjectedOrderedSubQuery<T> select<T extends Record>(
          T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
                  Expr<F> f, Expr<G> g)
              projectionBuilder) =>
      ProjectedOrderedSubQuery._(_query.select(projectionBuilder));

  /// Limit [OrderedSubQuery] using `LIMIT` clause.
  ///
  /// The resulting [OrderedSubQuery] will only return the first [limit] rows.
  OrderedSubQueryRange<
      (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> limit(
          int limit) =>
      OrderedSubQueryRange._(_query.limit(limit));

  /// Offset [OrderedSubQuery] using `OFFSET` clause.
  ///
  /// The resulting [OrderedSubQuery] will skip the first [offset] rows.
  OrderedSubQueryRange<
      (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> offset(
          int offset) =>
      OrderedSubQueryRange._(_query.offset(offset));

  /// Order [OrderedSubQuery] using `ORDER BY` clause.
  ///
  /// Returns a [OrderedSubQuery] with the same rows as this [OrderedSubQuery], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedSubQuery<
      (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> orderBy(
          List<(Expr<Comparable?>, Order)> Function(Expr<A> a, Expr<B> b,
                  Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f, Expr<G> g)
              builder) =>
      _query.orderBy(builder);
}

/// Extension methods for a ordered subquery of zero or more rows with
/// 7 expressions.
extension OrderedSubQueryRange7<A, B, C, D, E, F, G> on OrderedSubQueryRange<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> {
  /// Create a projection of this [OrderedSubQueryRange] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [OrderedSubQueryRange] object which doesn't have any methods!
  ///
  /// All methods and properties on [OrderedSubQueryRange<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  ProjectedOrderedSubQueryRange<T> select<T extends Record>(
          T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
                  Expr<F> f, Expr<G> g)
              projectionBuilder) =>
      ProjectedOrderedSubQueryRange._(_query.select(projectionBuilder));

  /// Limit [OrderedSubQueryRange] using `LIMIT` clause.
  ///
  /// The resulting [OrderedSubQueryRange] will only return the first [limit] rows.
  OrderedSubQueryRange<
      (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> limit(
          int limit) =>
      OrderedSubQueryRange._(_query.limit(limit));

  /// Offset [OrderedSubQueryRange] using `OFFSET` clause.
  ///
  /// The resulting [OrderedSubQueryRange] will skip the first [offset] rows.
  OrderedSubQueryRange<
      (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> offset(
          int offset) =>
      OrderedSubQueryRange._(_query.offset(offset));

  /// Order [OrderedSubQueryRange] using `ORDER BY` clause.
  ///
  /// Returns a [OrderedSubQueryRange] with the same rows as this [OrderedSubQueryRange], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedSubQuery<
      (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> orderBy(
          List<(Expr<Comparable?>, Order)> Function(Expr<A> a, Expr<B> b,
                  Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f, Expr<G> g)
              builder) =>
      _query.orderBy(builder);
}

/// Extension methods for a ordered subquery of zero or more rows with
/// 7 expressions.
extension ProjectedOrderedSubQuery7<A, B, C, D, E, F, G>
    on ProjectedOrderedSubQuery<
        (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> {
  /// Limit [ProjectedOrderedSubQuery] using `LIMIT` clause.
  ///
  /// The resulting [ProjectedOrderedSubQuery] will only return the first [limit] rows.
  ProjectedOrderedSubQueryRange<
      (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> limit(
          int limit) =>
      ProjectedOrderedSubQueryRange._(_query.limit(limit));

  /// Offset [ProjectedOrderedSubQuery] using `OFFSET` clause.
  ///
  /// The resulting [ProjectedOrderedSubQuery] will skip the first [offset] rows.
  ProjectedOrderedSubQueryRange<
      (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> offset(
          int offset) =>
      ProjectedOrderedSubQueryRange._(_query.offset(offset));

  /// Order [ProjectedOrderedSubQuery] using `ORDER BY` clause.
  ///
  /// Returns a [ProjectedOrderedSubQuery] with the same rows as this [ProjectedOrderedSubQuery], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedSubQuery<
      (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> orderBy(
          List<(Expr<Comparable?>, Order)> Function(Expr<A> a, Expr<B> b,
                  Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f, Expr<G> g)
              builder) =>
      _query.orderBy(builder);
}

/// Extension methods for a ordered subquery of zero or more rows with
/// 7 expressions.
extension ProjectedOrderedSubQueryRange7<A, B, C, D, E, F, G>
    on ProjectedOrderedSubQueryRange<
        (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> {
  /// Limit [ProjectedOrderedSubQueryRange] using `LIMIT` clause.
  ///
  /// The resulting [ProjectedOrderedSubQueryRange] will only return the first [limit] rows.
  ProjectedOrderedSubQueryRange<
      (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> limit(
          int limit) =>
      ProjectedOrderedSubQueryRange._(_query.limit(limit));

  /// Offset [ProjectedOrderedSubQueryRange] using `OFFSET` clause.
  ///
  /// The resulting [ProjectedOrderedSubQueryRange] will skip the first [offset] rows.
  ProjectedOrderedSubQueryRange<
      (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> offset(
          int offset) =>
      ProjectedOrderedSubQueryRange._(_query.offset(offset));

  /// Order [ProjectedOrderedSubQueryRange] using `ORDER BY` clause.
  ///
  /// Returns a [ProjectedOrderedSubQueryRange] with the same rows as this [ProjectedOrderedSubQueryRange], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedSubQuery<
      (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> orderBy(
          List<(Expr<Comparable?>, Order)> Function(Expr<A> a, Expr<B> b,
                  Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f, Expr<G> g)
              builder) =>
      _query.orderBy(builder);
}

/// Extension methods for a query returning zero or more rows with
/// 8 expressions.
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

  /// Filter [Query] using `WHERE` clause.
  ///
  /// Returns a [Query] retaining rows from this [Query] where the expression
  /// returned by [conditionBuilder] evaluates to `true`.
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
    return Query._(
      _context,
      _expressions,
      (e) => WhereClause._(_from(e), handle, where),
    );
  }

  /// Order [Query] using `ORDER BY` clause.
  ///
  /// Returns a [Query] with the same rows as this [Query], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedQuery<
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
              builder) {
    final (handle, orderBy) = _build(builder);
    if (orderBy.isEmpty) {
      return OrderedQuery._(this);
    }
    return OrderedQuery._(Query._(
      _context,
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy),
    ));
  }

  /// Limit [Query] using `LIMIT` clause.
  ///
  /// The resulting [Query] will only return the first [limit] rows.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)>
      limit(int limit) => Query._(
            _context,
            _expressions,
            (e) => LimitClause._(_from(e), limit),
          );

  /// Offset [Query] using `OFFSET` clause.
  ///
  /// The resulting [Query] will skip the first [offset] rows.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)>
      offset(int offset) => Query._(
            _context,
            _expressions,
            (e) => OffsetClause._(_from(e), offset),
          );

  /// Limit [Query] to the first row using `LIMIT` clause.
  ///
  /// This returns a [QuerySingle] which contains at-most one row.
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

  /// Count number of rows in this [Query] using `COUNT(*)` aggregate
  /// function.
  ///
  /// The resulting [QuerySingle] will have exactly one row, which is the
  /// number of rows in the this query.
  ///
  /// This will count all rows, including rows with `null` values. If you
  /// don't wish to count `null` values, use [where] to filter out such
  /// rows first.
  QuerySingle<(Expr<int>,)> count() =>
      select((a, b, c, d, e, f, g, h) => (CountAllExpression._(),)).first;

  /// Create a projection of this [Query] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [Query] object which doesn't have any methods!
  ///
  /// All methods and properties on [Query<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  Query<T> select<T extends Record>(
      T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
              Expr<F> f, Expr<G> g, Expr<H> h)
          projectionBuilder) {
    final (handle, projection) = _build(projectionBuilder);
    return Query._(
      _context,
      projection,
      (e) => SelectFromClause._(_from(_expressions.toList()), handle, e),
    );
  }

  /// Join this [Query] with another [Query] using `INNER JOIN` clause.
  ///
  /// This method returns an [InnerJoin] object on which you must call either
  ///  * `.all` to get the cartesian product of the two queries, or,
  ///  * `.on` to specify how the two queries should be joined.
  ///
  /// This always creates a `INNER JOIN`, where the `.on` condition can be
  /// used to control how the two queries are joined.
  InnerJoin<
      (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>),
      T> join<T extends Record>(Query<T> query) => InnerJoin._(this, query);

  /// Join this [Query] with another [Query] using `LEFT JOIN` clause.
  ///
  /// This method returns an [LeftJoin] object on which you must call
  /// `.on` to specify how the two queries should be joined.
  ///
  /// This always creates a `LEFT JOIN`, where the `.on` condition can be
  /// used to control how the two queries are joined.
  LeftJoin<
      (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>),
      T> leftJoin<T extends Record>(Query<T> query) => LeftJoin._(this, query);

  /// Join this [Query] with another [Query] using `RIGHT JOIN` clause.
  ///
  /// This method returns an [RightJoin] object on which you must call
  /// `.on` to specify how the two queries should be joined.
  ///
  /// This always creates a `RIGHT JOIN`, where the `.on` condition can be
  /// used to control how the two queries are joined.
  RightJoin<
      (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>),
      T> rightJoin<T extends Record>(
          Query<T> query) =>
      RightJoin._(this, query);

  /// Check for existance of rows in this [Query] using `EXISTS` operator.
  ///
  /// This returns a [QuerySingle] which contains exactly one row.
  /// The value of this query will be `true`, if this [Query] contains
  /// any rows, even if those rows are entirely `null`s.
  ///
  /// > [!TIP]
  /// > If you wish to use `.exists()` in a subquery considering
  /// > using `.asSubQuery.exists()` which returns an [Expr<bool>].
  QuerySingle<(Expr<bool>,)> exists() => QuerySingle._(Query._(
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

  /// Combine this [Query] with [other] using `UNION` _set operator_.
  ///
  /// This returns a [Query] containing all the rows from this [Query]
  /// and [other] with duplicate rows appearing only once.
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
      Query._(
        _context,
        _expressions,
        (e) => UnionClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );

  /// Combine this [Query] with [other] using `UNION ALL` _set operator_.
  ///
  /// This returns a [Query] containing all the rows from this [Query] and
  /// [other]. Unlike `.union` this retains duplicate rows.
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
      Query._(
        _context,
        _expressions,
        (e) => UnionAllClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );

  /// Combine this [Query] with [other] using `INTERSECT` _set operator_.
  ///
  /// This returns a [Query] containing all the rows that appear in both this
  /// [Query] and [other], with duplicate rows appearing only once.
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
      Query._(
        _context,
        _expressions,
        (e) => IntersectClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );

  /// Combine this [Query] with [other] using `EXCEPT` _set operator_.
  ///
  /// This returns a [Query] containing all the rows that appear in this
  /// [Query] and does not appear in [other], with duplicate rows appearing
  /// only once.
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
      Query._(
        _context,
        _expressions,
        (e) => ExceptClause._(
          _from(_expressions.toList()),
          other._castAs(this),
        ),
      );

  /// Combine this [Query] with [other] using `UNION` _set operator_.
  ///
  /// This returns a [Query] containing all the rows from this [Query]
  /// and [other] with duplicate rows appearing only once.
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

  /// Combine this [Query] with [other] using `UNION ALL` _set operator_.
  ///
  /// This returns a [Query] containing all the rows from this [Query] and
  /// [other]. Unlike `.union` this retains duplicate rows.
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

  /// Combine this [Query] with [other] using `INTERSECT` _set operator_.
  ///
  /// This returns a [Query] containing all the rows that appear in both this
  /// [Query] and [other], with duplicate rows appearing only once.
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

  /// Combine this [Query] with [other] using `EXCEPT` _set operator_.
  ///
  /// This returns a [Query] containing all the rows that appear in this
  /// [Query] and does not appear in [other], with duplicate rows appearing
  /// only once.
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

  /// Create projection for `GROUP BY` clause.
  ///
  /// The [groupBuilder] must return a [Record] where all the values are [Expr]
  /// objects. If something else is returned you will get a [Group] object which
  /// doesn't have any methods!
  ///
  /// This returns a [Group] object which has an `.aggregate` method that returns
  /// a query with a row for each distinct value of the projetion created by
  /// [groupBuilder]. The `.aggregate` method is used to construct
  /// _aggregate functions_ over rows of this [Query] for each group.
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

  /// Query the database for rows in this [Query] as a [Stream].
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
    final (sql, params) = _context._dialect.select(SelectStatement._(from));
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

  /// Query the database for rows in this [Query] as a [List].
  Future<List<(A, B, C, D, E, F, G, H)>> fetch() async =>
      await stream().toList();
}

/// Extension methods for a subquery returning zero or more rows with
/// 8 expressions.
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

  /// Filter [SubQuery] using `WHERE` clause.
  ///
  /// Returns a [SubQuery] retaining rows from this [SubQuery] where the expression
  /// returned by [conditionBuilder] evaluates to `true`.
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

  /// Order [SubQuery] using `ORDER BY` clause.
  ///
  /// Returns a [SubQuery] with the same rows as this [SubQuery], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedSubQuery<
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
              builder) {
    final (handle, orderBy) = _build(builder);
    if (orderBy.isEmpty) {
      return OrderedSubQuery._(this);
    }
    return OrderedSubQuery._(SubQuery._(
      _expressions,
      (e) => OrderByClause._(_from(e), handle, orderBy),
    ));
  }

  /// Limit [SubQuery] using `LIMIT` clause.
  ///
  /// The resulting [SubQuery] will only return the first [limit] rows.
  SubQuery<
          (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)>
      limit(int limit) => SubQuery._(
            _expressions,
            (e) => LimitClause._(_from(e), limit),
          );

  /// Offset [SubQuery] using `OFFSET` clause.
  ///
  /// The resulting [SubQuery] will skip the first [offset] rows.
  SubQuery<
          (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)>
      offset(int offset) => SubQuery._(
            _expressions,
            (e) => OffsetClause._(_from(e), offset),
          );

  /// Count number of rows in this [SubQuery] using `COUNT(*)` aggregate
  /// function.
  ///
  /// The resulting [Expr<int>] will evaluate to the number of rows in this
  /// [SubQuery].
  ///
  /// This will count all rows, including rows with `null` values. If you
  /// don't wish to count `null` values, use [where] to filter out such
  /// rows first.
  Expr<int> count() =>
      select((a, b, c, d, e, f, g, h) => (CountAllExpression._(),))
          .first
          .asNotNull();

  /// Create a projection of this [SubQuery] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [SubQuery] object which doesn't have any methods!
  ///
  /// All methods and properties on [SubQuery<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
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

  /// Check for existance of rows in this [SubQuery] using `EXISTS` operator.
  ///
  /// This returns an [Expr<bool>] that evaluates to `true`, if this [SubQuery]
  /// contains any rows, even if those rows are entirely `null`s.
  Expr<bool> exists() => ExistsExpression._(_from(_expressions.toList()));
}

/// Extension methods for a query returning zero or more rows with
/// 8 expressions.
extension OrderedQuery8<A, B, C, D, E, F, G, H> on OrderedQuery<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)> {
  /// Filter [OrderedQuery] using `WHERE` clause.
  ///
  /// Returns a [OrderedQuery] retaining rows from this [OrderedQuery] where the expression
  /// returned by [conditionBuilder] evaluates to `true`.
  OrderedQuery<
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
      OrderedQuery._(_query.where(conditionBuilder));

  /// Create a projection of this [OrderedQuery] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [OrderedQuery] object which doesn't have any methods!
  ///
  /// All methods and properties on [OrderedQuery<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  ProjectedOrderedQuery<T> select<T extends Record>(
          T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
                  Expr<F> f, Expr<G> g, Expr<H> h)
              projectionBuilder) =>
      ProjectedOrderedQuery._(_query.select(projectionBuilder));

  /// Limit [OrderedQuery] using `LIMIT` clause.
  ///
  /// The resulting [OrderedQuery] will only return the first [limit] rows.
  OrderedQueryRange<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>
      )> limit(int limit) => OrderedQueryRange._(_query.limit(limit));

  /// Offset [OrderedQuery] using `OFFSET` clause.
  ///
  /// The resulting [OrderedQuery] will skip the first [offset] rows.
  OrderedQueryRange<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>
      )> offset(int offset) => OrderedQueryRange._(_query.offset(offset));

  /// Order [OrderedQuery] using `ORDER BY` clause.
  ///
  /// Returns a [OrderedQuery] with the same rows as this [OrderedQuery], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedQuery<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>
      )> orderBy(
          List<(Expr<Comparable?>, Order)> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h)
              builder) =>
      _query.orderBy(builder);

  /// Query the database for rows in this [Query] as a [List].
  Future<List<(A, B, C, D, E, F, G, H)>> fetch() => _query.fetch();

  /// Query the database for rows in this [Query] as a [Stream].
  Stream<(A, B, C, D, E, F, G, H)> stream() => _query.stream();

  /// Limit [Query] to the first row using `LIMIT` clause.
  ///
  /// This returns a [QuerySingle] which contains at-most one row.
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
      )> get first => _query.first;
}

/// Extension methods for a query returning zero or more rows with
/// 8 expressions.
extension OrderedQueryRange8<A, B, C, D, E, F, G, H> on OrderedQueryRange<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)> {
  /// Create a projection of this [OrderedQueryRange] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [OrderedQueryRange] object which doesn't have any methods!
  ///
  /// All methods and properties on [OrderedQueryRange<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  ProjectedOrderedQueryRange<T> select<T extends Record>(
          T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
                  Expr<F> f, Expr<G> g, Expr<H> h)
              projectionBuilder) =>
      ProjectedOrderedQueryRange._(_query.select(projectionBuilder));

  /// Limit [OrderedQueryRange] using `LIMIT` clause.
  ///
  /// The resulting [OrderedQueryRange] will only return the first [limit] rows.
  OrderedQueryRange<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>
      )> limit(int limit) => OrderedQueryRange._(_query.limit(limit));

  /// Offset [OrderedQueryRange] using `OFFSET` clause.
  ///
  /// The resulting [OrderedQueryRange] will skip the first [offset] rows.
  OrderedQueryRange<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>
      )> offset(int offset) => OrderedQueryRange._(_query.offset(offset));

  /// Order [OrderedQueryRange] using `ORDER BY` clause.
  ///
  /// Returns a [OrderedQueryRange] with the same rows as this [OrderedQueryRange], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedQuery<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>
      )> orderBy(
          List<(Expr<Comparable?>, Order)> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h)
              builder) =>
      _query.orderBy(builder);

  /// Query the database for rows in this [Query] as a [List].
  Future<List<(A, B, C, D, E, F, G, H)>> fetch() => _query.fetch();

  /// Query the database for rows in this [Query] as a [Stream].
  Stream<(A, B, C, D, E, F, G, H)> stream() => _query.stream();

  /// Limit [Query] to the first row using `LIMIT` clause.
  ///
  /// This returns a [QuerySingle] which contains at-most one row.
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
      )> get first => _query.first;
}

/// Extension methods for a query returning zero or more rows with
/// 8 expressions.
extension ProjectedOrderedQuery8<A, B, C, D, E, F, G, H>
    on ProjectedOrderedQuery<
        (
          Expr<A>,
          Expr<B>,
          Expr<C>,
          Expr<D>,
          Expr<E>,
          Expr<F>,
          Expr<G>,
          Expr<H>
        )> {
  /// Limit [ProjectedOrderedQuery] using `LIMIT` clause.
  ///
  /// The resulting [ProjectedOrderedQuery] will only return the first [limit] rows.
  ProjectedOrderedQueryRange<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>
      )> limit(int limit) => ProjectedOrderedQueryRange._(_query.limit(limit));

  /// Offset [ProjectedOrderedQuery] using `OFFSET` clause.
  ///
  /// The resulting [ProjectedOrderedQuery] will skip the first [offset] rows.
  ProjectedOrderedQueryRange<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>
      )> offset(
          int offset) =>
      ProjectedOrderedQueryRange._(_query.offset(offset));

  /// Order [ProjectedOrderedQuery] using `ORDER BY` clause.
  ///
  /// Returns a [ProjectedOrderedQuery] with the same rows as this [ProjectedOrderedQuery], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedQuery<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>
      )> orderBy(
          List<(Expr<Comparable?>, Order)> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h)
              builder) =>
      _query.orderBy(builder);

  /// Query the database for rows in this [Query] as a [List].
  Future<List<(A, B, C, D, E, F, G, H)>> fetch() => _query.fetch();

  /// Query the database for rows in this [Query] as a [Stream].
  Stream<(A, B, C, D, E, F, G, H)> stream() => _query.stream();

  /// Limit [Query] to the first row using `LIMIT` clause.
  ///
  /// This returns a [QuerySingle] which contains at-most one row.
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
      )> get first => _query.first;
}

/// Extension methods for a query returning zero or more rows with
/// 8 expressions.
extension ProjectedOrderedQueryRange8<A, B, C, D, E, F, G, H>
    on ProjectedOrderedQueryRange<
        (
          Expr<A>,
          Expr<B>,
          Expr<C>,
          Expr<D>,
          Expr<E>,
          Expr<F>,
          Expr<G>,
          Expr<H>
        )> {
  /// Limit [ProjectedOrderedQueryRange] using `LIMIT` clause.
  ///
  /// The resulting [ProjectedOrderedQueryRange] will only return the first [limit] rows.
  ProjectedOrderedQueryRange<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>
      )> limit(int limit) => ProjectedOrderedQueryRange._(_query.limit(limit));

  /// Offset [ProjectedOrderedQueryRange] using `OFFSET` clause.
  ///
  /// The resulting [ProjectedOrderedQueryRange] will skip the first [offset] rows.
  ProjectedOrderedQueryRange<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>
      )> offset(
          int offset) =>
      ProjectedOrderedQueryRange._(_query.offset(offset));

  /// Order [ProjectedOrderedQueryRange] using `ORDER BY` clause.
  ///
  /// Returns a [ProjectedOrderedQueryRange] with the same rows as this [ProjectedOrderedQueryRange], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedQuery<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>
      )> orderBy(
          List<(Expr<Comparable?>, Order)> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h)
              builder) =>
      _query.orderBy(builder);

  /// Query the database for rows in this [Query] as a [List].
  Future<List<(A, B, C, D, E, F, G, H)>> fetch() => _query.fetch();

  /// Query the database for rows in this [Query] as a [Stream].
  Stream<(A, B, C, D, E, F, G, H)> stream() => _query.stream();

  /// Limit [Query] to the first row using `LIMIT` clause.
  ///
  /// This returns a [QuerySingle] which contains at-most one row.
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
      )> get first => _query.first;
}

/// Extension methods for a ordered subquery of zero or more rows with
/// 8 expressions.
extension OrderedSubQuery8<A, B, C, D, E, F, G, H> on OrderedSubQuery<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)> {
  /// Filter [OrderedSubQuery] using `WHERE` clause.
  ///
  /// Returns a [OrderedSubQuery] retaining rows from this [OrderedSubQuery] where the expression
  /// returned by [conditionBuilder] evaluates to `true`.
  OrderedSubQuery<
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
      OrderedSubQuery._(_query.where(conditionBuilder));

  /// Create a projection of this [OrderedSubQuery] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [OrderedSubQuery] object which doesn't have any methods!
  ///
  /// All methods and properties on [OrderedSubQuery<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  ProjectedOrderedSubQuery<T> select<T extends Record>(
          T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
                  Expr<F> f, Expr<G> g, Expr<H> h)
              projectionBuilder) =>
      ProjectedOrderedSubQuery._(_query.select(projectionBuilder));

  /// Limit [OrderedSubQuery] using `LIMIT` clause.
  ///
  /// The resulting [OrderedSubQuery] will only return the first [limit] rows.
  OrderedSubQueryRange<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>
      )> limit(int limit) => OrderedSubQueryRange._(_query.limit(limit));

  /// Offset [OrderedSubQuery] using `OFFSET` clause.
  ///
  /// The resulting [OrderedSubQuery] will skip the first [offset] rows.
  OrderedSubQueryRange<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>
      )> offset(int offset) => OrderedSubQueryRange._(_query.offset(offset));

  /// Order [OrderedSubQuery] using `ORDER BY` clause.
  ///
  /// Returns a [OrderedSubQuery] with the same rows as this [OrderedSubQuery], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedSubQuery<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>
      )> orderBy(
          List<(Expr<Comparable?>, Order)> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h)
              builder) =>
      _query.orderBy(builder);
}

/// Extension methods for a ordered subquery of zero or more rows with
/// 8 expressions.
extension OrderedSubQueryRange8<A, B, C, D, E, F, G, H> on OrderedSubQueryRange<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)> {
  /// Create a projection of this [OrderedSubQueryRange] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [OrderedSubQueryRange] object which doesn't have any methods!
  ///
  /// All methods and properties on [OrderedSubQueryRange<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  ProjectedOrderedSubQueryRange<T> select<T extends Record>(
          T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
                  Expr<F> f, Expr<G> g, Expr<H> h)
              projectionBuilder) =>
      ProjectedOrderedSubQueryRange._(_query.select(projectionBuilder));

  /// Limit [OrderedSubQueryRange] using `LIMIT` clause.
  ///
  /// The resulting [OrderedSubQueryRange] will only return the first [limit] rows.
  OrderedSubQueryRange<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>
      )> limit(int limit) => OrderedSubQueryRange._(_query.limit(limit));

  /// Offset [OrderedSubQueryRange] using `OFFSET` clause.
  ///
  /// The resulting [OrderedSubQueryRange] will skip the first [offset] rows.
  OrderedSubQueryRange<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>
      )> offset(int offset) => OrderedSubQueryRange._(_query.offset(offset));

  /// Order [OrderedSubQueryRange] using `ORDER BY` clause.
  ///
  /// Returns a [OrderedSubQueryRange] with the same rows as this [OrderedSubQueryRange], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedSubQuery<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>
      )> orderBy(
          List<(Expr<Comparable?>, Order)> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h)
              builder) =>
      _query.orderBy(builder);
}

/// Extension methods for a ordered subquery of zero or more rows with
/// 8 expressions.
extension ProjectedOrderedSubQuery8<A, B, C, D, E, F, G, H>
    on ProjectedOrderedSubQuery<
        (
          Expr<A>,
          Expr<B>,
          Expr<C>,
          Expr<D>,
          Expr<E>,
          Expr<F>,
          Expr<G>,
          Expr<H>
        )> {
  /// Limit [ProjectedOrderedSubQuery] using `LIMIT` clause.
  ///
  /// The resulting [ProjectedOrderedSubQuery] will only return the first [limit] rows.
  ProjectedOrderedSubQueryRange<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>
      )> limit(
          int limit) =>
      ProjectedOrderedSubQueryRange._(_query.limit(limit));

  /// Offset [ProjectedOrderedSubQuery] using `OFFSET` clause.
  ///
  /// The resulting [ProjectedOrderedSubQuery] will skip the first [offset] rows.
  ProjectedOrderedSubQueryRange<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>
      )> offset(
          int offset) =>
      ProjectedOrderedSubQueryRange._(_query.offset(offset));

  /// Order [ProjectedOrderedSubQuery] using `ORDER BY` clause.
  ///
  /// Returns a [ProjectedOrderedSubQuery] with the same rows as this [ProjectedOrderedSubQuery], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedSubQuery<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>
      )> orderBy(
          List<(Expr<Comparable?>, Order)> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h)
              builder) =>
      _query.orderBy(builder);
}

/// Extension methods for a ordered subquery of zero or more rows with
/// 8 expressions.
extension ProjectedOrderedSubQueryRange8<A, B, C, D, E, F, G, H>
    on ProjectedOrderedSubQueryRange<
        (
          Expr<A>,
          Expr<B>,
          Expr<C>,
          Expr<D>,
          Expr<E>,
          Expr<F>,
          Expr<G>,
          Expr<H>
        )> {
  /// Limit [ProjectedOrderedSubQueryRange] using `LIMIT` clause.
  ///
  /// The resulting [ProjectedOrderedSubQueryRange] will only return the first [limit] rows.
  ProjectedOrderedSubQueryRange<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>
      )> limit(
          int limit) =>
      ProjectedOrderedSubQueryRange._(_query.limit(limit));

  /// Offset [ProjectedOrderedSubQueryRange] using `OFFSET` clause.
  ///
  /// The resulting [ProjectedOrderedSubQueryRange] will skip the first [offset] rows.
  ProjectedOrderedSubQueryRange<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>
      )> offset(
          int offset) =>
      ProjectedOrderedSubQueryRange._(_query.offset(offset));

  /// Order [ProjectedOrderedSubQueryRange] using `ORDER BY` clause.
  ///
  /// Returns a [ProjectedOrderedSubQueryRange] with the same rows as this [ProjectedOrderedSubQueryRange], but ordered by
  /// the expressions returned by [builder].
  ///
  /// The [builder] callback must return a list of
  /// `(Expr<Comparable?>, Order)` records, where the [Order] specifies
  /// whether results should be sorted in [Order.ascending] or
  /// [Order.descending] order.
  ///
  /// Regardless of the [Order] given, `null` values are always sorted
  /// last. If you want `null` values sorted first, you can get this
  /// behavior using an extra `.isNull()` expression.
  ///
  /// For example:
  /// ```dart
  /// final result = await db.books
  ///     .orderBy((book) => [
  ///       // books where title == null will be sorted first now!
  ///       (book.title.isNull(), Order.descending),
  ///       (book.title, Order.ascending),
  ///     ])
  ///     .fetch();
  /// ```
  OrderedSubQuery<
      (
        Expr<A>,
        Expr<B>,
        Expr<C>,
        Expr<D>,
        Expr<E>,
        Expr<F>,
        Expr<G>,
        Expr<H>
      )> orderBy(
          List<(Expr<Comparable?>, Order)> Function(
                  Expr<A> a,
                  Expr<B> b,
                  Expr<C> c,
                  Expr<D> d,
                  Expr<E> e,
                  Expr<F> f,
                  Expr<G> g,
                  Expr<H> h)
              builder) =>
      _query.orderBy(builder);
}

/// Extension methods for completing an `INNER JOIN`.
extension InnerJoin1On1<A, B> on InnerJoin<(Expr<A>,), (Expr<B>,)> {
  /// Create query containing the cartesian product using a `CROSS JOIN`.
  ///
  /// This is equivalent to `... INNER JOIN ... ON TRUE`.
  Query<(Expr<A>, Expr<B>)> get all => Query._(
        _from._context,
        (
          _from._expressions.$1,
          _join._expressions.$1,
        ),
        (_) => JoinClause._(
          Object(),
          JoinType.inner,
          _from._from(_from._expressions.toList()),
          _join._from(_join._expressions.toList()),
          Literal.true$,
        ),
      );

  /// Create `inner JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A>, Expr<B>)> on(
      Expr<bool> Function(Expr<A> a, Expr<B> b) conditionBuilder) {
    late JoinClause join;
    final q = Query._(
      _from._context,
      (
        _from._expressions.$1,
        _join._expressions.$1,
      ),
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.inner,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `LEFT JOIN`.
extension LeftJoin1On1<A, B> on LeftJoin<(Expr<A>,), (Expr<B>,)> {
  /// Create `left JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A>, Expr<B?>)> on(
      Expr<bool> Function(Expr<A> a, Expr<B> b) conditionBuilder) {
    late JoinClause join;
    final q = Query._(
      _from._context,
      (
        _from._expressions.$1,
        _join._expressions.$1,
      ),
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.left,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `RIGHT JOIN`.
extension RightJoin1On1<A, B> on RightJoin<(Expr<A>,), (Expr<B>,)> {
  /// Create `right JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A?>, Expr<B>)> on(
      Expr<bool> Function(Expr<A> a, Expr<B> b) conditionBuilder) {
    late JoinClause join;
    final q = Query._(
      _from._context,
      (
        _from._expressions.$1,
        _join._expressions.$1,
      ),
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.right,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `INNER JOIN`.
extension InnerJoin1On2<A, B, C> on InnerJoin<(Expr<A>,), (Expr<B>, Expr<C>)> {
  /// Create query containing the cartesian product using a `CROSS JOIN`.
  ///
  /// This is equivalent to `... INNER JOIN ... ON TRUE`.
  Query<(Expr<A>, Expr<B>, Expr<C>)> get all => Query._(
        _from._context,
        (
          _from._expressions.$1,
          _join._expressions.$1,
          _join._expressions.$2,
        ),
        (_) => JoinClause._(
          Object(),
          JoinType.inner,
          _from._from(_from._expressions.toList()),
          _join._from(_join._expressions.toList()),
          Literal.true$,
        ),
      );

  /// Create `inner JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A>, Expr<B>, Expr<C>)> on(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c) conditionBuilder) {
    late JoinClause join;
    final q = Query._(
      _from._context,
      (
        _from._expressions.$1,
        _join._expressions.$1,
        _join._expressions.$2,
      ),
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.inner,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `LEFT JOIN`.
extension LeftJoin1On2<A, B, C> on LeftJoin<(Expr<A>,), (Expr<B>, Expr<C>)> {
  /// Create `left JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A>, Expr<B?>, Expr<C?>)> on(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c) conditionBuilder) {
    late JoinClause join;
    final q = Query._(
      _from._context,
      (
        _from._expressions.$1,
        _join._expressions.$1,
        _join._expressions.$2,
      ),
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.left,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `RIGHT JOIN`.
extension RightJoin1On2<A, B, C> on RightJoin<(Expr<A>,), (Expr<B>, Expr<C>)> {
  /// Create `right JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A?>, Expr<B>, Expr<C>)> on(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c) conditionBuilder) {
    late JoinClause join;
    final q = Query._(
      _from._context,
      (
        _from._expressions.$1,
        _join._expressions.$1,
        _join._expressions.$2,
      ),
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.right,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `INNER JOIN`.
extension InnerJoin1On3<A, B, C, D>
    on InnerJoin<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D>)> {
  /// Create query containing the cartesian product using a `CROSS JOIN`.
  ///
  /// This is equivalent to `... INNER JOIN ... ON TRUE`.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> get all => Query._(
        _from._context,
        (
          _from._expressions.$1,
          _join._expressions.$1,
          _join._expressions.$2,
          _join._expressions.$3,
        ),
        (_) => JoinClause._(
          Object(),
          JoinType.inner,
          _from._from(_from._expressions.toList()),
          _join._from(_join._expressions.toList()),
          Literal.true$,
        ),
      );

  /// Create `inner JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> on(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
      _from._context,
      (
        _from._expressions.$1,
        _join._expressions.$1,
        _join._expressions.$2,
        _join._expressions.$3,
      ),
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.inner,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `LEFT JOIN`.
extension LeftJoin1On3<A, B, C, D>
    on LeftJoin<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D>)> {
  /// Create `left JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A>, Expr<B?>, Expr<C?>, Expr<D?>)> on(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
      _from._context,
      (
        _from._expressions.$1,
        _join._expressions.$1,
        _join._expressions.$2,
        _join._expressions.$3,
      ),
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.left,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `RIGHT JOIN`.
extension RightJoin1On3<A, B, C, D>
    on RightJoin<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D>)> {
  /// Create `right JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A?>, Expr<B>, Expr<C>, Expr<D>)> on(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
      _from._context,
      (
        _from._expressions.$1,
        _join._expressions.$1,
        _join._expressions.$2,
        _join._expressions.$3,
      ),
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.right,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `INNER JOIN`.
extension InnerJoin1On4<A, B, C, D, E>
    on InnerJoin<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D>, Expr<E>)> {
  /// Create query containing the cartesian product using a `CROSS JOIN`.
  ///
  /// This is equivalent to `... INNER JOIN ... ON TRUE`.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> get all => Query._(
        _from._context,
        (
          _from._expressions.$1,
          _join._expressions.$1,
          _join._expressions.$2,
          _join._expressions.$3,
          _join._expressions.$4,
        ),
        (_) => JoinClause._(
          Object(),
          JoinType.inner,
          _from._from(_from._expressions.toList()),
          _join._from(_join._expressions.toList()),
          Literal.true$,
        ),
      );

  /// Create `inner JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> on(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
      _from._context,
      (
        _from._expressions.$1,
        _join._expressions.$1,
        _join._expressions.$2,
        _join._expressions.$3,
        _join._expressions.$4,
      ),
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.inner,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `LEFT JOIN`.
extension LeftJoin1On4<A, B, C, D, E>
    on LeftJoin<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D>, Expr<E>)> {
  /// Create `left JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A>, Expr<B?>, Expr<C?>, Expr<D?>, Expr<E?>)> on(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
      _from._context,
      (
        _from._expressions.$1,
        _join._expressions.$1,
        _join._expressions.$2,
        _join._expressions.$3,
        _join._expressions.$4,
      ),
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.left,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `RIGHT JOIN`.
extension RightJoin1On4<A, B, C, D, E>
    on RightJoin<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D>, Expr<E>)> {
  /// Create `right JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A?>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> on(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
      _from._context,
      (
        _from._expressions.$1,
        _join._expressions.$1,
        _join._expressions.$2,
        _join._expressions.$3,
        _join._expressions.$4,
      ),
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.right,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `INNER JOIN`.
extension InnerJoin1On5<A, B, C, D, E, F>
    on InnerJoin<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> {
  /// Create query containing the cartesian product using a `CROSS JOIN`.
  ///
  /// This is equivalent to `... INNER JOIN ... ON TRUE`.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> get all =>
      Query._(
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
          Object(),
          JoinType.inner,
          _from._from(_from._expressions.toList()),
          _join._from(_join._expressions.toList()),
          Literal.true$,
        ),
      );

  /// Create `inner JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> on(
      Expr<bool> Function(
              Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
      _from._context,
      (
        _from._expressions.$1,
        _join._expressions.$1,
        _join._expressions.$2,
        _join._expressions.$3,
        _join._expressions.$4,
        _join._expressions.$5,
      ),
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.inner,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `LEFT JOIN`.
extension LeftJoin1On5<A, B, C, D, E, F>
    on LeftJoin<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> {
  /// Create `left JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A>, Expr<B?>, Expr<C?>, Expr<D?>, Expr<E?>, Expr<F?>)> on(
      Expr<bool> Function(
              Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
      _from._context,
      (
        _from._expressions.$1,
        _join._expressions.$1,
        _join._expressions.$2,
        _join._expressions.$3,
        _join._expressions.$4,
        _join._expressions.$5,
      ),
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.left,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `RIGHT JOIN`.
extension RightJoin1On5<A, B, C, D, E, F>
    on RightJoin<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> {
  /// Create `right JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A?>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> on(
      Expr<bool> Function(
              Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
      _from._context,
      (
        _from._expressions.$1,
        _join._expressions.$1,
        _join._expressions.$2,
        _join._expressions.$3,
        _join._expressions.$4,
        _join._expressions.$5,
      ),
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.right,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `INNER JOIN`.
extension InnerJoin1On6<A, B, C, D, E, F, G> on InnerJoin<(Expr<A>,),
    (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> {
  /// Create query containing the cartesian product using a `CROSS JOIN`.
  ///
  /// This is equivalent to `... INNER JOIN ... ON TRUE`.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
      get all => Query._(
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
              Object(),
              JoinType.inner,
              _from._from(_from._expressions.toList()),
              _join._from(_join._expressions.toList()),
              Literal.true$,
            ),
          );

  /// Create `inner JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> on(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
              Expr<F> f, Expr<G> g)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
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
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.inner,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `LEFT JOIN`.
extension LeftJoin1On6<A, B, C, D, E, F, G> on LeftJoin<(Expr<A>,),
    (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> {
  /// Create `left JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A>, Expr<B?>, Expr<C?>, Expr<D?>, Expr<E?>, Expr<F?>, Expr<G?>)>
      on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g)
              conditionBuilder) {
    late JoinClause join;
    final q = Query._(
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
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.left,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `RIGHT JOIN`.
extension RightJoin1On6<A, B, C, D, E, F, G> on RightJoin<(Expr<A>,),
    (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> {
  /// Create `right JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A?>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> on(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
              Expr<F> f, Expr<G> g)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
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
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.right,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `INNER JOIN`.
extension InnerJoin1On7<A, B, C, D, E, F, G, H> on InnerJoin<(Expr<A>,),
    (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)> {
  /// Create query containing the cartesian product using a `CROSS JOIN`.
  ///
  /// This is equivalent to `... INNER JOIN ... ON TRUE`.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)>
      get all => Query._(
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
              Object(),
              JoinType.inner,
              _from._from(_from._expressions.toList()),
              _join._from(_join._expressions.toList()),
              Literal.true$,
            ),
          );

  /// Create `inner JOIN` using [conditionBuilder] in the `ON` clause.
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
      on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g, Expr<H> h)
              conditionBuilder) {
    late JoinClause join;
    final q = Query._(
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
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.inner,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `LEFT JOIN`.
extension LeftJoin1On7<A, B, C, D, E, F, G, H> on LeftJoin<(Expr<A>,),
    (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)> {
  /// Create `left JOIN` using [conditionBuilder] in the `ON` clause.
  Query<
          (
            Expr<A>,
            Expr<B?>,
            Expr<C?>,
            Expr<D?>,
            Expr<E?>,
            Expr<F?>,
            Expr<G?>,
            Expr<H?>
          )>
      on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g, Expr<H> h)
              conditionBuilder) {
    late JoinClause join;
    final q = Query._(
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
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.left,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `RIGHT JOIN`.
extension RightJoin1On7<A, B, C, D, E, F, G, H> on RightJoin<(Expr<A>,),
    (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)> {
  /// Create `right JOIN` using [conditionBuilder] in the `ON` clause.
  Query<
          (
            Expr<A?>,
            Expr<B>,
            Expr<C>,
            Expr<D>,
            Expr<E>,
            Expr<F>,
            Expr<G>,
            Expr<H>
          )>
      on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g, Expr<H> h)
              conditionBuilder) {
    late JoinClause join;
    final q = Query._(
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
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.right,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `INNER JOIN`.
extension InnerJoin2On1<A, B, C> on InnerJoin<(Expr<A>, Expr<B>), (Expr<C>,)> {
  /// Create query containing the cartesian product using a `CROSS JOIN`.
  ///
  /// This is equivalent to `... INNER JOIN ... ON TRUE`.
  Query<(Expr<A>, Expr<B>, Expr<C>)> get all => Query._(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _join._expressions.$1,
        ),
        (_) => JoinClause._(
          Object(),
          JoinType.inner,
          _from._from(_from._expressions.toList()),
          _join._from(_join._expressions.toList()),
          Literal.true$,
        ),
      );

  /// Create `inner JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A>, Expr<B>, Expr<C>)> on(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c) conditionBuilder) {
    late JoinClause join;
    final q = Query._(
      _from._context,
      (
        _from._expressions.$1,
        _from._expressions.$2,
        _join._expressions.$1,
      ),
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.inner,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `LEFT JOIN`.
extension LeftJoin2On1<A, B, C> on LeftJoin<(Expr<A>, Expr<B>), (Expr<C>,)> {
  /// Create `left JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A>, Expr<B>, Expr<C?>)> on(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c) conditionBuilder) {
    late JoinClause join;
    final q = Query._(
      _from._context,
      (
        _from._expressions.$1,
        _from._expressions.$2,
        _join._expressions.$1,
      ),
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.left,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `RIGHT JOIN`.
extension RightJoin2On1<A, B, C> on RightJoin<(Expr<A>, Expr<B>), (Expr<C>,)> {
  /// Create `right JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A?>, Expr<B?>, Expr<C>)> on(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c) conditionBuilder) {
    late JoinClause join;
    final q = Query._(
      _from._context,
      (
        _from._expressions.$1,
        _from._expressions.$2,
        _join._expressions.$1,
      ),
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.right,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `INNER JOIN`.
extension InnerJoin2On2<A, B, C, D>
    on InnerJoin<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>)> {
  /// Create query containing the cartesian product using a `CROSS JOIN`.
  ///
  /// This is equivalent to `... INNER JOIN ... ON TRUE`.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> get all => Query._(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _join._expressions.$1,
          _join._expressions.$2,
        ),
        (_) => JoinClause._(
          Object(),
          JoinType.inner,
          _from._from(_from._expressions.toList()),
          _join._from(_join._expressions.toList()),
          Literal.true$,
        ),
      );

  /// Create `inner JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> on(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
      _from._context,
      (
        _from._expressions.$1,
        _from._expressions.$2,
        _join._expressions.$1,
        _join._expressions.$2,
      ),
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.inner,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `LEFT JOIN`.
extension LeftJoin2On2<A, B, C, D>
    on LeftJoin<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>)> {
  /// Create `left JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A>, Expr<B>, Expr<C?>, Expr<D?>)> on(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
      _from._context,
      (
        _from._expressions.$1,
        _from._expressions.$2,
        _join._expressions.$1,
        _join._expressions.$2,
      ),
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.left,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `RIGHT JOIN`.
extension RightJoin2On2<A, B, C, D>
    on RightJoin<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>)> {
  /// Create `right JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A?>, Expr<B?>, Expr<C>, Expr<D>)> on(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
      _from._context,
      (
        _from._expressions.$1,
        _from._expressions.$2,
        _join._expressions.$1,
        _join._expressions.$2,
      ),
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.right,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `INNER JOIN`.
extension InnerJoin2On3<A, B, C, D, E>
    on InnerJoin<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>, Expr<E>)> {
  /// Create query containing the cartesian product using a `CROSS JOIN`.
  ///
  /// This is equivalent to `... INNER JOIN ... ON TRUE`.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> get all => Query._(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _join._expressions.$1,
          _join._expressions.$2,
          _join._expressions.$3,
        ),
        (_) => JoinClause._(
          Object(),
          JoinType.inner,
          _from._from(_from._expressions.toList()),
          _join._from(_join._expressions.toList()),
          Literal.true$,
        ),
      );

  /// Create `inner JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> on(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
      _from._context,
      (
        _from._expressions.$1,
        _from._expressions.$2,
        _join._expressions.$1,
        _join._expressions.$2,
        _join._expressions.$3,
      ),
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.inner,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `LEFT JOIN`.
extension LeftJoin2On3<A, B, C, D, E>
    on LeftJoin<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>, Expr<E>)> {
  /// Create `left JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A>, Expr<B>, Expr<C?>, Expr<D?>, Expr<E?>)> on(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
      _from._context,
      (
        _from._expressions.$1,
        _from._expressions.$2,
        _join._expressions.$1,
        _join._expressions.$2,
        _join._expressions.$3,
      ),
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.left,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `RIGHT JOIN`.
extension RightJoin2On3<A, B, C, D, E>
    on RightJoin<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>, Expr<E>)> {
  /// Create `right JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A?>, Expr<B?>, Expr<C>, Expr<D>, Expr<E>)> on(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
      _from._context,
      (
        _from._expressions.$1,
        _from._expressions.$2,
        _join._expressions.$1,
        _join._expressions.$2,
        _join._expressions.$3,
      ),
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.right,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `INNER JOIN`.
extension InnerJoin2On4<A, B, C, D, E, F>
    on InnerJoin<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>, Expr<E>, Expr<F>)> {
  /// Create query containing the cartesian product using a `CROSS JOIN`.
  ///
  /// This is equivalent to `... INNER JOIN ... ON TRUE`.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> get all =>
      Query._(
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
          Object(),
          JoinType.inner,
          _from._from(_from._expressions.toList()),
          _join._from(_join._expressions.toList()),
          Literal.true$,
        ),
      );

  /// Create `inner JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> on(
      Expr<bool> Function(
              Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
      _from._context,
      (
        _from._expressions.$1,
        _from._expressions.$2,
        _join._expressions.$1,
        _join._expressions.$2,
        _join._expressions.$3,
        _join._expressions.$4,
      ),
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.inner,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `LEFT JOIN`.
extension LeftJoin2On4<A, B, C, D, E, F>
    on LeftJoin<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>, Expr<E>, Expr<F>)> {
  /// Create `left JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A>, Expr<B>, Expr<C?>, Expr<D?>, Expr<E?>, Expr<F?>)> on(
      Expr<bool> Function(
              Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
      _from._context,
      (
        _from._expressions.$1,
        _from._expressions.$2,
        _join._expressions.$1,
        _join._expressions.$2,
        _join._expressions.$3,
        _join._expressions.$4,
      ),
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.left,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `RIGHT JOIN`.
extension RightJoin2On4<A, B, C, D, E, F>
    on RightJoin<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>, Expr<E>, Expr<F>)> {
  /// Create `right JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A?>, Expr<B?>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> on(
      Expr<bool> Function(
              Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
      _from._context,
      (
        _from._expressions.$1,
        _from._expressions.$2,
        _join._expressions.$1,
        _join._expressions.$2,
        _join._expressions.$3,
        _join._expressions.$4,
      ),
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.right,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `INNER JOIN`.
extension InnerJoin2On5<A, B, C, D, E, F, G> on InnerJoin<(Expr<A>, Expr<B>),
    (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> {
  /// Create query containing the cartesian product using a `CROSS JOIN`.
  ///
  /// This is equivalent to `... INNER JOIN ... ON TRUE`.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
      get all => Query._(
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
              Object(),
              JoinType.inner,
              _from._from(_from._expressions.toList()),
              _join._from(_join._expressions.toList()),
              Literal.true$,
            ),
          );

  /// Create `inner JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> on(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
              Expr<F> f, Expr<G> g)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
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
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.inner,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `LEFT JOIN`.
extension LeftJoin2On5<A, B, C, D, E, F, G> on LeftJoin<(Expr<A>, Expr<B>),
    (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> {
  /// Create `left JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A>, Expr<B>, Expr<C?>, Expr<D?>, Expr<E?>, Expr<F?>, Expr<G?>)>
      on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g)
              conditionBuilder) {
    late JoinClause join;
    final q = Query._(
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
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.left,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `RIGHT JOIN`.
extension RightJoin2On5<A, B, C, D, E, F, G> on RightJoin<(Expr<A>, Expr<B>),
    (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> {
  /// Create `right JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A?>, Expr<B?>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> on(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
              Expr<F> f, Expr<G> g)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
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
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.right,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `INNER JOIN`.
extension InnerJoin2On6<A, B, C, D, E, F, G, H> on InnerJoin<(Expr<A>, Expr<B>),
    (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)> {
  /// Create query containing the cartesian product using a `CROSS JOIN`.
  ///
  /// This is equivalent to `... INNER JOIN ... ON TRUE`.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)>
      get all => Query._(
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
              Object(),
              JoinType.inner,
              _from._from(_from._expressions.toList()),
              _join._from(_join._expressions.toList()),
              Literal.true$,
            ),
          );

  /// Create `inner JOIN` using [conditionBuilder] in the `ON` clause.
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
      on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g, Expr<H> h)
              conditionBuilder) {
    late JoinClause join;
    final q = Query._(
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
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.inner,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `LEFT JOIN`.
extension LeftJoin2On6<A, B, C, D, E, F, G, H> on LeftJoin<(Expr<A>, Expr<B>),
    (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)> {
  /// Create `left JOIN` using [conditionBuilder] in the `ON` clause.
  Query<
          (
            Expr<A>,
            Expr<B>,
            Expr<C?>,
            Expr<D?>,
            Expr<E?>,
            Expr<F?>,
            Expr<G?>,
            Expr<H?>
          )>
      on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g, Expr<H> h)
              conditionBuilder) {
    late JoinClause join;
    final q = Query._(
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
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.left,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `RIGHT JOIN`.
extension RightJoin2On6<A, B, C, D, E, F, G, H> on RightJoin<(Expr<A>, Expr<B>),
    (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)> {
  /// Create `right JOIN` using [conditionBuilder] in the `ON` clause.
  Query<
          (
            Expr<A?>,
            Expr<B?>,
            Expr<C>,
            Expr<D>,
            Expr<E>,
            Expr<F>,
            Expr<G>,
            Expr<H>
          )>
      on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g, Expr<H> h)
              conditionBuilder) {
    late JoinClause join;
    final q = Query._(
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
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.right,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `INNER JOIN`.
extension InnerJoin3On1<A, B, C, D>
    on InnerJoin<(Expr<A>, Expr<B>, Expr<C>), (Expr<D>,)> {
  /// Create query containing the cartesian product using a `CROSS JOIN`.
  ///
  /// This is equivalent to `... INNER JOIN ... ON TRUE`.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> get all => Query._(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _from._expressions.$3,
          _join._expressions.$1,
        ),
        (_) => JoinClause._(
          Object(),
          JoinType.inner,
          _from._from(_from._expressions.toList()),
          _join._from(_join._expressions.toList()),
          Literal.true$,
        ),
      );

  /// Create `inner JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> on(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
      _from._context,
      (
        _from._expressions.$1,
        _from._expressions.$2,
        _from._expressions.$3,
        _join._expressions.$1,
      ),
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.inner,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `LEFT JOIN`.
extension LeftJoin3On1<A, B, C, D>
    on LeftJoin<(Expr<A>, Expr<B>, Expr<C>), (Expr<D>,)> {
  /// Create `left JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D?>)> on(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
      _from._context,
      (
        _from._expressions.$1,
        _from._expressions.$2,
        _from._expressions.$3,
        _join._expressions.$1,
      ),
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.left,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `RIGHT JOIN`.
extension RightJoin3On1<A, B, C, D>
    on RightJoin<(Expr<A>, Expr<B>, Expr<C>), (Expr<D>,)> {
  /// Create `right JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A?>, Expr<B?>, Expr<C?>, Expr<D>)> on(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
      _from._context,
      (
        _from._expressions.$1,
        _from._expressions.$2,
        _from._expressions.$3,
        _join._expressions.$1,
      ),
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.right,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `INNER JOIN`.
extension InnerJoin3On2<A, B, C, D, E>
    on InnerJoin<(Expr<A>, Expr<B>, Expr<C>), (Expr<D>, Expr<E>)> {
  /// Create query containing the cartesian product using a `CROSS JOIN`.
  ///
  /// This is equivalent to `... INNER JOIN ... ON TRUE`.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> get all => Query._(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _from._expressions.$3,
          _join._expressions.$1,
          _join._expressions.$2,
        ),
        (_) => JoinClause._(
          Object(),
          JoinType.inner,
          _from._from(_from._expressions.toList()),
          _join._from(_join._expressions.toList()),
          Literal.true$,
        ),
      );

  /// Create `inner JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> on(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
      _from._context,
      (
        _from._expressions.$1,
        _from._expressions.$2,
        _from._expressions.$3,
        _join._expressions.$1,
        _join._expressions.$2,
      ),
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.inner,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `LEFT JOIN`.
extension LeftJoin3On2<A, B, C, D, E>
    on LeftJoin<(Expr<A>, Expr<B>, Expr<C>), (Expr<D>, Expr<E>)> {
  /// Create `left JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D?>, Expr<E?>)> on(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
      _from._context,
      (
        _from._expressions.$1,
        _from._expressions.$2,
        _from._expressions.$3,
        _join._expressions.$1,
        _join._expressions.$2,
      ),
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.left,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `RIGHT JOIN`.
extension RightJoin3On2<A, B, C, D, E>
    on RightJoin<(Expr<A>, Expr<B>, Expr<C>), (Expr<D>, Expr<E>)> {
  /// Create `right JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A?>, Expr<B?>, Expr<C?>, Expr<D>, Expr<E>)> on(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
      _from._context,
      (
        _from._expressions.$1,
        _from._expressions.$2,
        _from._expressions.$3,
        _join._expressions.$1,
        _join._expressions.$2,
      ),
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.right,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `INNER JOIN`.
extension InnerJoin3On3<A, B, C, D, E, F>
    on InnerJoin<(Expr<A>, Expr<B>, Expr<C>), (Expr<D>, Expr<E>, Expr<F>)> {
  /// Create query containing the cartesian product using a `CROSS JOIN`.
  ///
  /// This is equivalent to `... INNER JOIN ... ON TRUE`.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> get all =>
      Query._(
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
          Object(),
          JoinType.inner,
          _from._from(_from._expressions.toList()),
          _join._from(_join._expressions.toList()),
          Literal.true$,
        ),
      );

  /// Create `inner JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> on(
      Expr<bool> Function(
              Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
      _from._context,
      (
        _from._expressions.$1,
        _from._expressions.$2,
        _from._expressions.$3,
        _join._expressions.$1,
        _join._expressions.$2,
        _join._expressions.$3,
      ),
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.inner,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `LEFT JOIN`.
extension LeftJoin3On3<A, B, C, D, E, F>
    on LeftJoin<(Expr<A>, Expr<B>, Expr<C>), (Expr<D>, Expr<E>, Expr<F>)> {
  /// Create `left JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D?>, Expr<E?>, Expr<F?>)> on(
      Expr<bool> Function(
              Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
      _from._context,
      (
        _from._expressions.$1,
        _from._expressions.$2,
        _from._expressions.$3,
        _join._expressions.$1,
        _join._expressions.$2,
        _join._expressions.$3,
      ),
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.left,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `RIGHT JOIN`.
extension RightJoin3On3<A, B, C, D, E, F>
    on RightJoin<(Expr<A>, Expr<B>, Expr<C>), (Expr<D>, Expr<E>, Expr<F>)> {
  /// Create `right JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A?>, Expr<B?>, Expr<C?>, Expr<D>, Expr<E>, Expr<F>)> on(
      Expr<bool> Function(
              Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
      _from._context,
      (
        _from._expressions.$1,
        _from._expressions.$2,
        _from._expressions.$3,
        _join._expressions.$1,
        _join._expressions.$2,
        _join._expressions.$3,
      ),
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.right,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `INNER JOIN`.
extension InnerJoin3On4<A, B, C, D, E, F, G> on InnerJoin<
    (Expr<A>, Expr<B>, Expr<C>), (Expr<D>, Expr<E>, Expr<F>, Expr<G>)> {
  /// Create query containing the cartesian product using a `CROSS JOIN`.
  ///
  /// This is equivalent to `... INNER JOIN ... ON TRUE`.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
      get all => Query._(
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
              Object(),
              JoinType.inner,
              _from._from(_from._expressions.toList()),
              _join._from(_join._expressions.toList()),
              Literal.true$,
            ),
          );

  /// Create `inner JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> on(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
              Expr<F> f, Expr<G> g)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
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
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.inner,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `LEFT JOIN`.
extension LeftJoin3On4<A, B, C, D, E, F, G> on LeftJoin<
    (Expr<A>, Expr<B>, Expr<C>), (Expr<D>, Expr<E>, Expr<F>, Expr<G>)> {
  /// Create `left JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D?>, Expr<E?>, Expr<F?>, Expr<G?>)> on(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
              Expr<F> f, Expr<G> g)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
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
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.left,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `RIGHT JOIN`.
extension RightJoin3On4<A, B, C, D, E, F, G> on RightJoin<
    (Expr<A>, Expr<B>, Expr<C>), (Expr<D>, Expr<E>, Expr<F>, Expr<G>)> {
  /// Create `right JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A?>, Expr<B?>, Expr<C?>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> on(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
              Expr<F> f, Expr<G> g)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
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
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.right,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `INNER JOIN`.
extension InnerJoin3On5<A, B, C, D, E, F, G, H> on InnerJoin<
    (Expr<A>, Expr<B>, Expr<C>),
    (Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)> {
  /// Create query containing the cartesian product using a `CROSS JOIN`.
  ///
  /// This is equivalent to `... INNER JOIN ... ON TRUE`.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)>
      get all => Query._(
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
              Object(),
              JoinType.inner,
              _from._from(_from._expressions.toList()),
              _join._from(_join._expressions.toList()),
              Literal.true$,
            ),
          );

  /// Create `inner JOIN` using [conditionBuilder] in the `ON` clause.
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
      on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g, Expr<H> h)
              conditionBuilder) {
    late JoinClause join;
    final q = Query._(
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
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.inner,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `LEFT JOIN`.
extension LeftJoin3On5<A, B, C, D, E, F, G, H> on LeftJoin<
    (Expr<A>, Expr<B>, Expr<C>),
    (Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)> {
  /// Create `left JOIN` using [conditionBuilder] in the `ON` clause.
  Query<
          (
            Expr<A>,
            Expr<B>,
            Expr<C>,
            Expr<D?>,
            Expr<E?>,
            Expr<F?>,
            Expr<G?>,
            Expr<H?>
          )>
      on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g, Expr<H> h)
              conditionBuilder) {
    late JoinClause join;
    final q = Query._(
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
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.left,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `RIGHT JOIN`.
extension RightJoin3On5<A, B, C, D, E, F, G, H> on RightJoin<
    (Expr<A>, Expr<B>, Expr<C>),
    (Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)> {
  /// Create `right JOIN` using [conditionBuilder] in the `ON` clause.
  Query<
          (
            Expr<A?>,
            Expr<B?>,
            Expr<C?>,
            Expr<D>,
            Expr<E>,
            Expr<F>,
            Expr<G>,
            Expr<H>
          )>
      on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g, Expr<H> h)
              conditionBuilder) {
    late JoinClause join;
    final q = Query._(
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
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.right,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `INNER JOIN`.
extension InnerJoin4On1<A, B, C, D, E>
    on InnerJoin<(Expr<A>, Expr<B>, Expr<C>, Expr<D>), (Expr<E>,)> {
  /// Create query containing the cartesian product using a `CROSS JOIN`.
  ///
  /// This is equivalent to `... INNER JOIN ... ON TRUE`.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> get all => Query._(
        _from._context,
        (
          _from._expressions.$1,
          _from._expressions.$2,
          _from._expressions.$3,
          _from._expressions.$4,
          _join._expressions.$1,
        ),
        (_) => JoinClause._(
          Object(),
          JoinType.inner,
          _from._from(_from._expressions.toList()),
          _join._from(_join._expressions.toList()),
          Literal.true$,
        ),
      );

  /// Create `inner JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> on(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
      _from._context,
      (
        _from._expressions.$1,
        _from._expressions.$2,
        _from._expressions.$3,
        _from._expressions.$4,
        _join._expressions.$1,
      ),
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.inner,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `LEFT JOIN`.
extension LeftJoin4On1<A, B, C, D, E>
    on LeftJoin<(Expr<A>, Expr<B>, Expr<C>, Expr<D>), (Expr<E>,)> {
  /// Create `left JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E?>)> on(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
      _from._context,
      (
        _from._expressions.$1,
        _from._expressions.$2,
        _from._expressions.$3,
        _from._expressions.$4,
        _join._expressions.$1,
      ),
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.left,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `RIGHT JOIN`.
extension RightJoin4On1<A, B, C, D, E>
    on RightJoin<(Expr<A>, Expr<B>, Expr<C>, Expr<D>), (Expr<E>,)> {
  /// Create `right JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A?>, Expr<B?>, Expr<C?>, Expr<D?>, Expr<E>)> on(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
      _from._context,
      (
        _from._expressions.$1,
        _from._expressions.$2,
        _from._expressions.$3,
        _from._expressions.$4,
        _join._expressions.$1,
      ),
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.right,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `INNER JOIN`.
extension InnerJoin4On2<A, B, C, D, E, F>
    on InnerJoin<(Expr<A>, Expr<B>, Expr<C>, Expr<D>), (Expr<E>, Expr<F>)> {
  /// Create query containing the cartesian product using a `CROSS JOIN`.
  ///
  /// This is equivalent to `... INNER JOIN ... ON TRUE`.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> get all =>
      Query._(
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
          Object(),
          JoinType.inner,
          _from._from(_from._expressions.toList()),
          _join._from(_join._expressions.toList()),
          Literal.true$,
        ),
      );

  /// Create `inner JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> on(
      Expr<bool> Function(
              Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
      _from._context,
      (
        _from._expressions.$1,
        _from._expressions.$2,
        _from._expressions.$3,
        _from._expressions.$4,
        _join._expressions.$1,
        _join._expressions.$2,
      ),
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.inner,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `LEFT JOIN`.
extension LeftJoin4On2<A, B, C, D, E, F>
    on LeftJoin<(Expr<A>, Expr<B>, Expr<C>, Expr<D>), (Expr<E>, Expr<F>)> {
  /// Create `left JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E?>, Expr<F?>)> on(
      Expr<bool> Function(
              Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
      _from._context,
      (
        _from._expressions.$1,
        _from._expressions.$2,
        _from._expressions.$3,
        _from._expressions.$4,
        _join._expressions.$1,
        _join._expressions.$2,
      ),
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.left,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `RIGHT JOIN`.
extension RightJoin4On2<A, B, C, D, E, F>
    on RightJoin<(Expr<A>, Expr<B>, Expr<C>, Expr<D>), (Expr<E>, Expr<F>)> {
  /// Create `right JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A?>, Expr<B?>, Expr<C?>, Expr<D?>, Expr<E>, Expr<F>)> on(
      Expr<bool> Function(
              Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
      _from._context,
      (
        _from._expressions.$1,
        _from._expressions.$2,
        _from._expressions.$3,
        _from._expressions.$4,
        _join._expressions.$1,
        _join._expressions.$2,
      ),
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.right,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `INNER JOIN`.
extension InnerJoin4On3<A, B, C, D, E, F, G> on InnerJoin<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>), (Expr<E>, Expr<F>, Expr<G>)> {
  /// Create query containing the cartesian product using a `CROSS JOIN`.
  ///
  /// This is equivalent to `... INNER JOIN ... ON TRUE`.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
      get all => Query._(
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
              Object(),
              JoinType.inner,
              _from._from(_from._expressions.toList()),
              _join._from(_join._expressions.toList()),
              Literal.true$,
            ),
          );

  /// Create `inner JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> on(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
              Expr<F> f, Expr<G> g)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
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
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.inner,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `LEFT JOIN`.
extension LeftJoin4On3<A, B, C, D, E, F, G> on LeftJoin<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>), (Expr<E>, Expr<F>, Expr<G>)> {
  /// Create `left JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E?>, Expr<F?>, Expr<G?>)> on(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
              Expr<F> f, Expr<G> g)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
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
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.left,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `RIGHT JOIN`.
extension RightJoin4On3<A, B, C, D, E, F, G> on RightJoin<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>), (Expr<E>, Expr<F>, Expr<G>)> {
  /// Create `right JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A?>, Expr<B?>, Expr<C?>, Expr<D?>, Expr<E>, Expr<F>, Expr<G>)> on(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
              Expr<F> f, Expr<G> g)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
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
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.right,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `INNER JOIN`.
extension InnerJoin4On4<A, B, C, D, E, F, G, H> on InnerJoin<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>),
    (Expr<E>, Expr<F>, Expr<G>, Expr<H>)> {
  /// Create query containing the cartesian product using a `CROSS JOIN`.
  ///
  /// This is equivalent to `... INNER JOIN ... ON TRUE`.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)>
      get all => Query._(
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
              Object(),
              JoinType.inner,
              _from._from(_from._expressions.toList()),
              _join._from(_join._expressions.toList()),
              Literal.true$,
            ),
          );

  /// Create `inner JOIN` using [conditionBuilder] in the `ON` clause.
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
      on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g, Expr<H> h)
              conditionBuilder) {
    late JoinClause join;
    final q = Query._(
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
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.inner,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `LEFT JOIN`.
extension LeftJoin4On4<A, B, C, D, E, F, G, H> on LeftJoin<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>),
    (Expr<E>, Expr<F>, Expr<G>, Expr<H>)> {
  /// Create `left JOIN` using [conditionBuilder] in the `ON` clause.
  Query<
          (
            Expr<A>,
            Expr<B>,
            Expr<C>,
            Expr<D>,
            Expr<E?>,
            Expr<F?>,
            Expr<G?>,
            Expr<H?>
          )>
      on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g, Expr<H> h)
              conditionBuilder) {
    late JoinClause join;
    final q = Query._(
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
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.left,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `RIGHT JOIN`.
extension RightJoin4On4<A, B, C, D, E, F, G, H> on RightJoin<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>),
    (Expr<E>, Expr<F>, Expr<G>, Expr<H>)> {
  /// Create `right JOIN` using [conditionBuilder] in the `ON` clause.
  Query<
          (
            Expr<A?>,
            Expr<B?>,
            Expr<C?>,
            Expr<D?>,
            Expr<E>,
            Expr<F>,
            Expr<G>,
            Expr<H>
          )>
      on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g, Expr<H> h)
              conditionBuilder) {
    late JoinClause join;
    final q = Query._(
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
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.right,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `INNER JOIN`.
extension InnerJoin5On1<A, B, C, D, E, F>
    on InnerJoin<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>), (Expr<F>,)> {
  /// Create query containing the cartesian product using a `CROSS JOIN`.
  ///
  /// This is equivalent to `... INNER JOIN ... ON TRUE`.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> get all =>
      Query._(
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
          Object(),
          JoinType.inner,
          _from._from(_from._expressions.toList()),
          _join._from(_join._expressions.toList()),
          Literal.true$,
        ),
      );

  /// Create `inner JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> on(
      Expr<bool> Function(
              Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
      _from._context,
      (
        _from._expressions.$1,
        _from._expressions.$2,
        _from._expressions.$3,
        _from._expressions.$4,
        _from._expressions.$5,
        _join._expressions.$1,
      ),
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.inner,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `LEFT JOIN`.
extension LeftJoin5On1<A, B, C, D, E, F>
    on LeftJoin<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>), (Expr<F>,)> {
  /// Create `left JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F?>)> on(
      Expr<bool> Function(
              Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
      _from._context,
      (
        _from._expressions.$1,
        _from._expressions.$2,
        _from._expressions.$3,
        _from._expressions.$4,
        _from._expressions.$5,
        _join._expressions.$1,
      ),
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.left,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `RIGHT JOIN`.
extension RightJoin5On1<A, B, C, D, E, F>
    on RightJoin<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>), (Expr<F>,)> {
  /// Create `right JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A?>, Expr<B?>, Expr<C?>, Expr<D?>, Expr<E?>, Expr<F>)> on(
      Expr<bool> Function(
              Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e, Expr<F> f)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
      _from._context,
      (
        _from._expressions.$1,
        _from._expressions.$2,
        _from._expressions.$3,
        _from._expressions.$4,
        _from._expressions.$5,
        _join._expressions.$1,
      ),
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.right,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `INNER JOIN`.
extension InnerJoin5On2<A, B, C, D, E, F, G> on InnerJoin<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>), (Expr<F>, Expr<G>)> {
  /// Create query containing the cartesian product using a `CROSS JOIN`.
  ///
  /// This is equivalent to `... INNER JOIN ... ON TRUE`.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
      get all => Query._(
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
              Object(),
              JoinType.inner,
              _from._from(_from._expressions.toList()),
              _join._from(_join._expressions.toList()),
              Literal.true$,
            ),
          );

  /// Create `inner JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> on(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
              Expr<F> f, Expr<G> g)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
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
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.inner,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `LEFT JOIN`.
extension LeftJoin5On2<A, B, C, D, E, F, G> on LeftJoin<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>), (Expr<F>, Expr<G>)> {
  /// Create `left JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F?>, Expr<G?>)> on(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
              Expr<F> f, Expr<G> g)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
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
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.left,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `RIGHT JOIN`.
extension RightJoin5On2<A, B, C, D, E, F, G> on RightJoin<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>), (Expr<F>, Expr<G>)> {
  /// Create `right JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A?>, Expr<B?>, Expr<C?>, Expr<D?>, Expr<E?>, Expr<F>, Expr<G>)>
      on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g)
              conditionBuilder) {
    late JoinClause join;
    final q = Query._(
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
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.right,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `INNER JOIN`.
extension InnerJoin5On3<A, B, C, D, E, F, G, H> on InnerJoin<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>),
    (Expr<F>, Expr<G>, Expr<H>)> {
  /// Create query containing the cartesian product using a `CROSS JOIN`.
  ///
  /// This is equivalent to `... INNER JOIN ... ON TRUE`.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)>
      get all => Query._(
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
              Object(),
              JoinType.inner,
              _from._from(_from._expressions.toList()),
              _join._from(_join._expressions.toList()),
              Literal.true$,
            ),
          );

  /// Create `inner JOIN` using [conditionBuilder] in the `ON` clause.
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
      on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g, Expr<H> h)
              conditionBuilder) {
    late JoinClause join;
    final q = Query._(
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
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.inner,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `LEFT JOIN`.
extension LeftJoin5On3<A, B, C, D, E, F, G, H> on LeftJoin<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>),
    (Expr<F>, Expr<G>, Expr<H>)> {
  /// Create `left JOIN` using [conditionBuilder] in the `ON` clause.
  Query<
          (
            Expr<A>,
            Expr<B>,
            Expr<C>,
            Expr<D>,
            Expr<E>,
            Expr<F?>,
            Expr<G?>,
            Expr<H?>
          )>
      on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g, Expr<H> h)
              conditionBuilder) {
    late JoinClause join;
    final q = Query._(
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
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.left,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `RIGHT JOIN`.
extension RightJoin5On3<A, B, C, D, E, F, G, H> on RightJoin<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>),
    (Expr<F>, Expr<G>, Expr<H>)> {
  /// Create `right JOIN` using [conditionBuilder] in the `ON` clause.
  Query<
          (
            Expr<A?>,
            Expr<B?>,
            Expr<C?>,
            Expr<D?>,
            Expr<E?>,
            Expr<F>,
            Expr<G>,
            Expr<H>
          )>
      on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g, Expr<H> h)
              conditionBuilder) {
    late JoinClause join;
    final q = Query._(
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
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.right,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `INNER JOIN`.
extension InnerJoin6On1<A, B, C, D, E, F, G> on InnerJoin<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>), (Expr<G>,)> {
  /// Create query containing the cartesian product using a `CROSS JOIN`.
  ///
  /// This is equivalent to `... INNER JOIN ... ON TRUE`.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
      get all => Query._(
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
              Object(),
              JoinType.inner,
              _from._from(_from._expressions.toList()),
              _join._from(_join._expressions.toList()),
              Literal.true$,
            ),
          );

  /// Create `inner JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> on(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
              Expr<F> f, Expr<G> g)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
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
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.inner,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `LEFT JOIN`.
extension LeftJoin6On1<A, B, C, D, E, F, G> on LeftJoin<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>), (Expr<G>,)> {
  /// Create `left JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G?>)> on(
      Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
              Expr<F> f, Expr<G> g)
          conditionBuilder) {
    late JoinClause join;
    final q = Query._(
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
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.left,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `RIGHT JOIN`.
extension RightJoin6On1<A, B, C, D, E, F, G> on RightJoin<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>), (Expr<G>,)> {
  /// Create `right JOIN` using [conditionBuilder] in the `ON` clause.
  Query<(Expr<A?>, Expr<B?>, Expr<C?>, Expr<D?>, Expr<E?>, Expr<F?>, Expr<G>)>
      on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g)
              conditionBuilder) {
    late JoinClause join;
    final q = Query._(
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
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.right,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `INNER JOIN`.
extension InnerJoin6On2<A, B, C, D, E, F, G, H> on InnerJoin<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>),
    (Expr<G>, Expr<H>)> {
  /// Create query containing the cartesian product using a `CROSS JOIN`.
  ///
  /// This is equivalent to `... INNER JOIN ... ON TRUE`.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)>
      get all => Query._(
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
              Object(),
              JoinType.inner,
              _from._from(_from._expressions.toList()),
              _join._from(_join._expressions.toList()),
              Literal.true$,
            ),
          );

  /// Create `inner JOIN` using [conditionBuilder] in the `ON` clause.
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
      on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g, Expr<H> h)
              conditionBuilder) {
    late JoinClause join;
    final q = Query._(
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
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.inner,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `LEFT JOIN`.
extension LeftJoin6On2<A, B, C, D, E, F, G, H> on LeftJoin<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>),
    (Expr<G>, Expr<H>)> {
  /// Create `left JOIN` using [conditionBuilder] in the `ON` clause.
  Query<
          (
            Expr<A>,
            Expr<B>,
            Expr<C>,
            Expr<D>,
            Expr<E>,
            Expr<F>,
            Expr<G?>,
            Expr<H?>
          )>
      on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g, Expr<H> h)
              conditionBuilder) {
    late JoinClause join;
    final q = Query._(
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
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.left,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `RIGHT JOIN`.
extension RightJoin6On2<A, B, C, D, E, F, G, H> on RightJoin<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>),
    (Expr<G>, Expr<H>)> {
  /// Create `right JOIN` using [conditionBuilder] in the `ON` clause.
  Query<
          (
            Expr<A?>,
            Expr<B?>,
            Expr<C?>,
            Expr<D?>,
            Expr<E?>,
            Expr<F?>,
            Expr<G>,
            Expr<H>
          )>
      on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g, Expr<H> h)
              conditionBuilder) {
    late JoinClause join;
    final q = Query._(
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
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.right,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `INNER JOIN`.
extension InnerJoin7On1<A, B, C, D, E, F, G, H> on InnerJoin<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>),
    (Expr<H>,)> {
  /// Create query containing the cartesian product using a `CROSS JOIN`.
  ///
  /// This is equivalent to `... INNER JOIN ... ON TRUE`.
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)>
      get all => Query._(
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
              Object(),
              JoinType.inner,
              _from._from(_from._expressions.toList()),
              _join._from(_join._expressions.toList()),
              Literal.true$,
            ),
          );

  /// Create `inner JOIN` using [conditionBuilder] in the `ON` clause.
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
      on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g, Expr<H> h)
              conditionBuilder) {
    late JoinClause join;
    final q = Query._(
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
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.inner,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `LEFT JOIN`.
extension LeftJoin7On1<A, B, C, D, E, F, G, H> on LeftJoin<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>),
    (Expr<H>,)> {
  /// Create `left JOIN` using [conditionBuilder] in the `ON` clause.
  Query<
          (
            Expr<A>,
            Expr<B>,
            Expr<C>,
            Expr<D>,
            Expr<E>,
            Expr<F>,
            Expr<G>,
            Expr<H?>
          )>
      on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g, Expr<H> h)
              conditionBuilder) {
    late JoinClause join;
    final q = Query._(
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
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.left,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing an `RIGHT JOIN`.
extension RightJoin7On1<A, B, C, D, E, F, G, H> on RightJoin<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>),
    (Expr<H>,)> {
  /// Create `right JOIN` using [conditionBuilder] in the `ON` clause.
  Query<
          (
            Expr<A?>,
            Expr<B?>,
            Expr<C?>,
            Expr<D?>,
            Expr<E?>,
            Expr<F?>,
            Expr<G?>,
            Expr<H>
          )>
      on(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g, Expr<H> h)
              conditionBuilder) {
    late JoinClause join;
    final q = Query._(
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
      (_) => join,
    );
    final (handle, on) = q._build(conditionBuilder);
    join = JoinClause._(
      handle,
      JoinType.right,
      _from._from(_from._expressions.toList()),
      _join._from(_join._expressions.toList()),
      on,
    );
    return q;
  }
}

/// Extension methods for completing a `GROUP BY`.
extension Group1By1<A, B> on Group<(Expr<A>,), (Expr<B>,)> {
  /// Finish `GROUP BY` clause by specifying _aggregate functions_.
  ///
  /// Groups are determined by the projection created with the `.groupBy`
  /// projection. Aggregate functions over rows within each group are specified
  /// using the [aggregationBuilder] callback.
  ///
  /// The resulting query will have a row for each distinct value of the
  /// projection created with `.groupBy`. Each row will contain the `.groupBy`
  /// projection and any aggregate functions built with [aggregationBuilder].
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<B>,), T> Function(
              Aggregation<(Expr<B>,), (Expr<A>,)> agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return Query._(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        e.take(1).toList(),
        e.skip(1).toList(),
      ),
    );
  }
}

/// Extension methods for specifying aggregate functions over rows in a group.
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

  /// Add a `SUM` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `SUM` aggregate over the rows
  /// in each group. The `SUM` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will coalesced to zero.
  Aggregation<(Expr<A>,), (Expr<B>, Expr<C>)> sum<C extends num>(
          Expr<C?> Function(Expr<A> a) aggregateBuilder) =>
      _build(aggregateBuilder, SumExpression._);

  /// Add a `AVG` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes an `AVG` aggregate over the rows
  /// in each group. The `AVG` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will not be included in the average. If all rows in a group
  /// evaluate to `NULL`, the `AVG` aggregate function will return `NULL`.
  ///
  /// > [!WARNING]
  /// > If you want `NULL` values to count in denominator of the average, use
  /// > `.orElseValue(0)` to force a non-nullable expression.
  Aggregation<(Expr<A>,), (Expr<B>, Expr<double?>)> avg<C extends num>(
          Expr<C?> Function(Expr<A> a) aggregateBuilder) =>
      _build(aggregateBuilder, AvgExpression._);

  /// Add a `MIN` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MIN` aggregate over the rows
  /// in each group. The `MIN` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MIN` aggregate function will return `NULL`.
  Aggregation<(Expr<A>,), (Expr<B>, Expr<C?>)> min<C extends Comparable>(
          Expr<C?> Function(Expr<A> a) aggregateBuilder) =>
      _build(aggregateBuilder, MinExpression._);

  /// Add a `MAX` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MAX` aggregate over the rows
  /// in each group. The `MAX` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MAX` aggregate function will return `NULL`.
  Aggregation<(Expr<A>,), (Expr<B>, Expr<C?>)> max<C extends Comparable>(
          Expr<C?> Function(Expr<A> a) aggregateBuilder) =>
      _build(aggregateBuilder, MaxExpression._);

  /// Add a `COUNT(*)` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `COUNT(*)` aggregate over the rows
  /// in each group. This count the number of rows in the group, using a
  /// `COUNT(*)` expression.
  ///
  /// This will count the number of rows in the group, including rows consisting
  /// entirely of `NULL` values.
  Aggregation<(Expr<A>,), (Expr<B>, Expr<int>)> count() =>
      _build((a) => CountAllExpression._(), (a) => a);
}

/// Extension methods for completing a `GROUP BY`.
extension Group2By1<A, B, C> on Group<(Expr<A>,), (Expr<B>, Expr<C>)> {
  /// Finish `GROUP BY` clause by specifying _aggregate functions_.
  ///
  /// Groups are determined by the projection created with the `.groupBy`
  /// projection. Aggregate functions over rows within each group are specified
  /// using the [aggregationBuilder] callback.
  ///
  /// The resulting query will have a row for each distinct value of the
  /// projection created with `.groupBy`. Each row will contain the `.groupBy`
  /// projection and any aggregate functions built with [aggregationBuilder].
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<B>, Expr<C>), T> Function(
              Aggregation<(Expr<B>, Expr<C>), (Expr<A>,)> agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return Query._(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        e.take(1).toList(),
        e.skip(1).toList(),
      ),
    );
  }
}

/// Extension methods for specifying aggregate functions over rows in a group.
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

  /// Add a `SUM` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `SUM` aggregate over the rows
  /// in each group. The `SUM` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will coalesced to zero.
  Aggregation<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D>)> sum<D extends num>(
          Expr<D?> Function(Expr<A> a) aggregateBuilder) =>
      _build(aggregateBuilder, SumExpression._);

  /// Add a `AVG` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes an `AVG` aggregate over the rows
  /// in each group. The `AVG` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will not be included in the average. If all rows in a group
  /// evaluate to `NULL`, the `AVG` aggregate function will return `NULL`.
  ///
  /// > [!WARNING]
  /// > If you want `NULL` values to count in denominator of the average, use
  /// > `.orElseValue(0)` to force a non-nullable expression.
  Aggregation<(Expr<A>,), (Expr<B>, Expr<C>, Expr<double?>)> avg<D extends num>(
          Expr<D?> Function(Expr<A> a) aggregateBuilder) =>
      _build(aggregateBuilder, AvgExpression._);

  /// Add a `MIN` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MIN` aggregate over the rows
  /// in each group. The `MIN` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MIN` aggregate function will return `NULL`.
  Aggregation<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D?>)>
      min<D extends Comparable>(
              Expr<D?> Function(Expr<A> a) aggregateBuilder) =>
          _build(aggregateBuilder, MinExpression._);

  /// Add a `MAX` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MAX` aggregate over the rows
  /// in each group. The `MAX` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MAX` aggregate function will return `NULL`.
  Aggregation<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D?>)>
      max<D extends Comparable>(
              Expr<D?> Function(Expr<A> a) aggregateBuilder) =>
          _build(aggregateBuilder, MaxExpression._);

  /// Add a `COUNT(*)` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `COUNT(*)` aggregate over the rows
  /// in each group. This count the number of rows in the group, using a
  /// `COUNT(*)` expression.
  ///
  /// This will count the number of rows in the group, including rows consisting
  /// entirely of `NULL` values.
  Aggregation<(Expr<A>,), (Expr<B>, Expr<C>, Expr<int>)> count() =>
      _build((a) => CountAllExpression._(), (a) => a);
}

/// Extension methods for completing a `GROUP BY`.
extension Group3By1<A, B, C, D>
    on Group<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D>)> {
  /// Finish `GROUP BY` clause by specifying _aggregate functions_.
  ///
  /// Groups are determined by the projection created with the `.groupBy`
  /// projection. Aggregate functions over rows within each group are specified
  /// using the [aggregationBuilder] callback.
  ///
  /// The resulting query will have a row for each distinct value of the
  /// projection created with `.groupBy`. Each row will contain the `.groupBy`
  /// projection and any aggregate functions built with [aggregationBuilder].
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<B>, Expr<C>, Expr<D>), T> Function(
              Aggregation<(Expr<B>, Expr<C>, Expr<D>), (Expr<A>,)> agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return Query._(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        e.take(1).toList(),
        e.skip(1).toList(),
      ),
    );
  }
}

/// Extension methods for specifying aggregate functions over rows in a group.
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

  /// Add a `SUM` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `SUM` aggregate over the rows
  /// in each group. The `SUM` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will coalesced to zero.
  Aggregation<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D>, Expr<E>)>
      sum<E extends num>(Expr<E?> Function(Expr<A> a) aggregateBuilder) =>
          _build(aggregateBuilder, SumExpression._);

  /// Add a `AVG` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes an `AVG` aggregate over the rows
  /// in each group. The `AVG` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will not be included in the average. If all rows in a group
  /// evaluate to `NULL`, the `AVG` aggregate function will return `NULL`.
  ///
  /// > [!WARNING]
  /// > If you want `NULL` values to count in denominator of the average, use
  /// > `.orElseValue(0)` to force a non-nullable expression.
  Aggregation<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D>, Expr<double?>)>
      avg<E extends num>(Expr<E?> Function(Expr<A> a) aggregateBuilder) =>
          _build(aggregateBuilder, AvgExpression._);

  /// Add a `MIN` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MIN` aggregate over the rows
  /// in each group. The `MIN` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MIN` aggregate function will return `NULL`.
  Aggregation<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D>, Expr<E?>)>
      min<E extends Comparable>(
              Expr<E?> Function(Expr<A> a) aggregateBuilder) =>
          _build(aggregateBuilder, MinExpression._);

  /// Add a `MAX` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MAX` aggregate over the rows
  /// in each group. The `MAX` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MAX` aggregate function will return `NULL`.
  Aggregation<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D>, Expr<E?>)>
      max<E extends Comparable>(
              Expr<E?> Function(Expr<A> a) aggregateBuilder) =>
          _build(aggregateBuilder, MaxExpression._);

  /// Add a `COUNT(*)` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `COUNT(*)` aggregate over the rows
  /// in each group. This count the number of rows in the group, using a
  /// `COUNT(*)` expression.
  ///
  /// This will count the number of rows in the group, including rows consisting
  /// entirely of `NULL` values.
  Aggregation<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D>, Expr<int>)> count() =>
      _build((a) => CountAllExpression._(), (a) => a);
}

/// Extension methods for completing a `GROUP BY`.
extension Group4By1<A, B, C, D, E>
    on Group<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D>, Expr<E>)> {
  /// Finish `GROUP BY` clause by specifying _aggregate functions_.
  ///
  /// Groups are determined by the projection created with the `.groupBy`
  /// projection. Aggregate functions over rows within each group are specified
  /// using the [aggregationBuilder] callback.
  ///
  /// The resulting query will have a row for each distinct value of the
  /// projection created with `.groupBy`. Each row will contain the `.groupBy`
  /// projection and any aggregate functions built with [aggregationBuilder].
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<B>, Expr<C>, Expr<D>, Expr<E>), T> Function(
              Aggregation<(Expr<B>, Expr<C>, Expr<D>, Expr<E>), (Expr<A>,)> agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return Query._(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        e.take(1).toList(),
        e.skip(1).toList(),
      ),
    );
  }
}

/// Extension methods for specifying aggregate functions over rows in a group.
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

  /// Add a `SUM` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `SUM` aggregate over the rows
  /// in each group. The `SUM` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will coalesced to zero.
  Aggregation<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)>
      sum<F extends num>(Expr<F?> Function(Expr<A> a) aggregateBuilder) =>
          _build(aggregateBuilder, SumExpression._);

  /// Add a `AVG` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes an `AVG` aggregate over the rows
  /// in each group. The `AVG` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will not be included in the average. If all rows in a group
  /// evaluate to `NULL`, the `AVG` aggregate function will return `NULL`.
  ///
  /// > [!WARNING]
  /// > If you want `NULL` values to count in denominator of the average, use
  /// > `.orElseValue(0)` to force a non-nullable expression.
  Aggregation<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<double?>)>
      avg<F extends num>(Expr<F?> Function(Expr<A> a) aggregateBuilder) =>
          _build(aggregateBuilder, AvgExpression._);

  /// Add a `MIN` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MIN` aggregate over the rows
  /// in each group. The `MIN` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MIN` aggregate function will return `NULL`.
  Aggregation<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F?>)>
      min<F extends Comparable>(
              Expr<F?> Function(Expr<A> a) aggregateBuilder) =>
          _build(aggregateBuilder, MinExpression._);

  /// Add a `MAX` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MAX` aggregate over the rows
  /// in each group. The `MAX` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MAX` aggregate function will return `NULL`.
  Aggregation<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F?>)>
      max<F extends Comparable>(
              Expr<F?> Function(Expr<A> a) aggregateBuilder) =>
          _build(aggregateBuilder, MaxExpression._);

  /// Add a `COUNT(*)` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `COUNT(*)` aggregate over the rows
  /// in each group. This count the number of rows in the group, using a
  /// `COUNT(*)` expression.
  ///
  /// This will count the number of rows in the group, including rows consisting
  /// entirely of `NULL` values.
  Aggregation<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<int>)>
      count() => _build((a) => CountAllExpression._(), (a) => a);
}

/// Extension methods for completing a `GROUP BY`.
extension Group5By1<A, B, C, D, E, F>
    on Group<(Expr<A>,), (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> {
  /// Finish `GROUP BY` clause by specifying _aggregate functions_.
  ///
  /// Groups are determined by the projection created with the `.groupBy`
  /// projection. Aggregate functions over rows within each group are specified
  /// using the [aggregationBuilder] callback.
  ///
  /// The resulting query will have a row for each distinct value of the
  /// projection created with `.groupBy`. Each row will contain the `.groupBy`
  /// projection and any aggregate functions built with [aggregationBuilder].
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>), T> Function(
              Aggregation<(Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>),
                      (Expr<A>,)>
                  agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return Query._(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        e.take(1).toList(),
        e.skip(1).toList(),
      ),
    );
  }
}

/// Extension methods for specifying aggregate functions over rows in a group.
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

  /// Add a `SUM` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `SUM` aggregate over the rows
  /// in each group. The `SUM` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will coalesced to zero.
  Aggregation<(Expr<A>,),
          (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
      sum<G extends num>(Expr<G?> Function(Expr<A> a) aggregateBuilder) =>
          _build(aggregateBuilder, SumExpression._);

  /// Add a `AVG` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes an `AVG` aggregate over the rows
  /// in each group. The `AVG` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will not be included in the average. If all rows in a group
  /// evaluate to `NULL`, the `AVG` aggregate function will return `NULL`.
  ///
  /// > [!WARNING]
  /// > If you want `NULL` values to count in denominator of the average, use
  /// > `.orElseValue(0)` to force a non-nullable expression.
  Aggregation<(Expr<A>,),
          (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<double?>)>
      avg<G extends num>(Expr<G?> Function(Expr<A> a) aggregateBuilder) =>
          _build(aggregateBuilder, AvgExpression._);

  /// Add a `MIN` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MIN` aggregate over the rows
  /// in each group. The `MIN` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MIN` aggregate function will return `NULL`.
  Aggregation<(Expr<A>,),
          (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G?>)>
      min<G extends Comparable>(
              Expr<G?> Function(Expr<A> a) aggregateBuilder) =>
          _build(aggregateBuilder, MinExpression._);

  /// Add a `MAX` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MAX` aggregate over the rows
  /// in each group. The `MAX` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MAX` aggregate function will return `NULL`.
  Aggregation<(Expr<A>,),
          (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G?>)>
      max<G extends Comparable>(
              Expr<G?> Function(Expr<A> a) aggregateBuilder) =>
          _build(aggregateBuilder, MaxExpression._);

  /// Add a `COUNT(*)` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `COUNT(*)` aggregate over the rows
  /// in each group. This count the number of rows in the group, using a
  /// `COUNT(*)` expression.
  ///
  /// This will count the number of rows in the group, including rows consisting
  /// entirely of `NULL` values.
  Aggregation<(Expr<A>,),
          (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<int>)>
      count() => _build((a) => CountAllExpression._(), (a) => a);
}

/// Extension methods for completing a `GROUP BY`.
extension Group6By1<A, B, C, D, E, F, G> on Group<(Expr<A>,),
    (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> {
  /// Finish `GROUP BY` clause by specifying _aggregate functions_.
  ///
  /// Groups are determined by the projection created with the `.groupBy`
  /// projection. Aggregate functions over rows within each group are specified
  /// using the [aggregationBuilder] callback.
  ///
  /// The resulting query will have a row for each distinct value of the
  /// projection created with `.groupBy`. Each row will contain the `.groupBy`
  /// projection and any aggregate functions built with [aggregationBuilder].
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>), T> Function(
              Aggregation<
                      (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>),
                      (Expr<A>,)>
                  agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return Query._(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        e.take(1).toList(),
        e.skip(1).toList(),
      ),
    );
  }
}

/// Extension methods for specifying aggregate functions over rows in a group.
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

  /// Add a `SUM` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `SUM` aggregate over the rows
  /// in each group. The `SUM` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will coalesced to zero.
  Aggregation<(Expr<A>,),
          (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)>
      sum<H extends num>(Expr<H?> Function(Expr<A> a) aggregateBuilder) =>
          _build(aggregateBuilder, SumExpression._);

  /// Add a `AVG` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes an `AVG` aggregate over the rows
  /// in each group. The `AVG` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will not be included in the average. If all rows in a group
  /// evaluate to `NULL`, the `AVG` aggregate function will return `NULL`.
  ///
  /// > [!WARNING]
  /// > If you want `NULL` values to count in denominator of the average, use
  /// > `.orElseValue(0)` to force a non-nullable expression.
  Aggregation<(Expr<A>,),
          (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<double?>)>
      avg<H extends num>(Expr<H?> Function(Expr<A> a) aggregateBuilder) =>
          _build(aggregateBuilder, AvgExpression._);

  /// Add a `MIN` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MIN` aggregate over the rows
  /// in each group. The `MIN` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MIN` aggregate function will return `NULL`.
  Aggregation<(Expr<A>,),
          (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H?>)>
      min<H extends Comparable>(
              Expr<H?> Function(Expr<A> a) aggregateBuilder) =>
          _build(aggregateBuilder, MinExpression._);

  /// Add a `MAX` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MAX` aggregate over the rows
  /// in each group. The `MAX` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MAX` aggregate function will return `NULL`.
  Aggregation<(Expr<A>,),
          (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H?>)>
      max<H extends Comparable>(
              Expr<H?> Function(Expr<A> a) aggregateBuilder) =>
          _build(aggregateBuilder, MaxExpression._);

  /// Add a `COUNT(*)` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `COUNT(*)` aggregate over the rows
  /// in each group. This count the number of rows in the group, using a
  /// `COUNT(*)` expression.
  ///
  /// This will count the number of rows in the group, including rows consisting
  /// entirely of `NULL` values.
  Aggregation<(Expr<A>,),
          (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<int>)>
      count() => _build((a) => CountAllExpression._(), (a) => a);
}

/// Extension methods for completing a `GROUP BY`.
extension Group7By1<A, B, C, D, E, F, G, H> on Group<(Expr<A>,),
    (Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)> {
  /// Finish `GROUP BY` clause by specifying _aggregate functions_.
  ///
  /// Groups are determined by the projection created with the `.groupBy`
  /// projection. Aggregate functions over rows within each group are specified
  /// using the [aggregationBuilder] callback.
  ///
  /// The resulting query will have a row for each distinct value of the
  /// projection created with `.groupBy`. Each row will contain the `.groupBy`
  /// projection and any aggregate functions built with [aggregationBuilder].
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

    return Query._(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        e.take(1).toList(),
        e.skip(1).toList(),
      ),
    );
  }
}

/// Extension methods for specifying aggregate functions over rows in a group.
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

  /// Add a `SUM` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `SUM` aggregate over the rows
  /// in each group. The `SUM` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will coalesced to zero.
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

  /// Add a `AVG` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes an `AVG` aggregate over the rows
  /// in each group. The `AVG` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will not be included in the average. If all rows in a group
  /// evaluate to `NULL`, the `AVG` aggregate function will return `NULL`.
  ///
  /// > [!WARNING]
  /// > If you want `NULL` values to count in denominator of the average, use
  /// > `.orElseValue(0)` to force a non-nullable expression.
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

  /// Add a `MIN` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MIN` aggregate over the rows
  /// in each group. The `MIN` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MIN` aggregate function will return `NULL`.
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

  /// Add a `MAX` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MAX` aggregate over the rows
  /// in each group. The `MAX` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MAX` aggregate function will return `NULL`.
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

  /// Add a `COUNT(*)` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `COUNT(*)` aggregate over the rows
  /// in each group. This count the number of rows in the group, using a
  /// `COUNT(*)` expression.
  ///
  /// This will count the number of rows in the group, including rows consisting
  /// entirely of `NULL` values.
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

/// Extension methods for completing a `GROUP BY`.
extension Group1By2<A, B, C> on Group<(Expr<A>, Expr<B>), (Expr<C>,)> {
  /// Finish `GROUP BY` clause by specifying _aggregate functions_.
  ///
  /// Groups are determined by the projection created with the `.groupBy`
  /// projection. Aggregate functions over rows within each group are specified
  /// using the [aggregationBuilder] callback.
  ///
  /// The resulting query will have a row for each distinct value of the
  /// projection created with `.groupBy`. Each row will contain the `.groupBy`
  /// projection and any aggregate functions built with [aggregationBuilder].
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<C>,), T> Function(
              Aggregation<(Expr<C>,), (Expr<A>, Expr<B>)> agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return Query._(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        e.take(2).toList(),
        e.skip(2).toList(),
      ),
    );
  }
}

/// Extension methods for specifying aggregate functions over rows in a group.
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

  /// Add a `SUM` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `SUM` aggregate over the rows
  /// in each group. The `SUM` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will coalesced to zero.
  Aggregation<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>)> sum<D extends num>(
          Expr<D?> Function(Expr<A> a, Expr<B> b) aggregateBuilder) =>
      _build(aggregateBuilder, SumExpression._);

  /// Add a `AVG` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes an `AVG` aggregate over the rows
  /// in each group. The `AVG` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will not be included in the average. If all rows in a group
  /// evaluate to `NULL`, the `AVG` aggregate function will return `NULL`.
  ///
  /// > [!WARNING]
  /// > If you want `NULL` values to count in denominator of the average, use
  /// > `.orElseValue(0)` to force a non-nullable expression.
  Aggregation<(Expr<A>, Expr<B>), (Expr<C>, Expr<double?>)> avg<D extends num>(
          Expr<D?> Function(Expr<A> a, Expr<B> b) aggregateBuilder) =>
      _build(aggregateBuilder, AvgExpression._);

  /// Add a `MIN` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MIN` aggregate over the rows
  /// in each group. The `MIN` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MIN` aggregate function will return `NULL`.
  Aggregation<(Expr<A>, Expr<B>), (Expr<C>, Expr<D?>)>
      min<D extends Comparable>(
              Expr<D?> Function(Expr<A> a, Expr<B> b) aggregateBuilder) =>
          _build(aggregateBuilder, MinExpression._);

  /// Add a `MAX` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MAX` aggregate over the rows
  /// in each group. The `MAX` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MAX` aggregate function will return `NULL`.
  Aggregation<(Expr<A>, Expr<B>), (Expr<C>, Expr<D?>)>
      max<D extends Comparable>(
              Expr<D?> Function(Expr<A> a, Expr<B> b) aggregateBuilder) =>
          _build(aggregateBuilder, MaxExpression._);

  /// Add a `COUNT(*)` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `COUNT(*)` aggregate over the rows
  /// in each group. This count the number of rows in the group, using a
  /// `COUNT(*)` expression.
  ///
  /// This will count the number of rows in the group, including rows consisting
  /// entirely of `NULL` values.
  Aggregation<(Expr<A>, Expr<B>), (Expr<C>, Expr<int>)> count() =>
      _build((a, b) => CountAllExpression._(), (a) => a);
}

/// Extension methods for completing a `GROUP BY`.
extension Group2By2<A, B, C, D>
    on Group<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>)> {
  /// Finish `GROUP BY` clause by specifying _aggregate functions_.
  ///
  /// Groups are determined by the projection created with the `.groupBy`
  /// projection. Aggregate functions over rows within each group are specified
  /// using the [aggregationBuilder] callback.
  ///
  /// The resulting query will have a row for each distinct value of the
  /// projection created with `.groupBy`. Each row will contain the `.groupBy`
  /// projection and any aggregate functions built with [aggregationBuilder].
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<C>, Expr<D>), T> Function(
              Aggregation<(Expr<C>, Expr<D>), (Expr<A>, Expr<B>)> agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return Query._(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        e.take(2).toList(),
        e.skip(2).toList(),
      ),
    );
  }
}

/// Extension methods for specifying aggregate functions over rows in a group.
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

  /// Add a `SUM` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `SUM` aggregate over the rows
  /// in each group. The `SUM` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will coalesced to zero.
  Aggregation<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>, Expr<E>)>
      sum<E extends num>(
              Expr<E?> Function(Expr<A> a, Expr<B> b) aggregateBuilder) =>
          _build(aggregateBuilder, SumExpression._);

  /// Add a `AVG` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes an `AVG` aggregate over the rows
  /// in each group. The `AVG` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will not be included in the average. If all rows in a group
  /// evaluate to `NULL`, the `AVG` aggregate function will return `NULL`.
  ///
  /// > [!WARNING]
  /// > If you want `NULL` values to count in denominator of the average, use
  /// > `.orElseValue(0)` to force a non-nullable expression.
  Aggregation<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>, Expr<double?>)>
      avg<E extends num>(
              Expr<E?> Function(Expr<A> a, Expr<B> b) aggregateBuilder) =>
          _build(aggregateBuilder, AvgExpression._);

  /// Add a `MIN` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MIN` aggregate over the rows
  /// in each group. The `MIN` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MIN` aggregate function will return `NULL`.
  Aggregation<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>, Expr<E?>)>
      min<E extends Comparable>(
              Expr<E?> Function(Expr<A> a, Expr<B> b) aggregateBuilder) =>
          _build(aggregateBuilder, MinExpression._);

  /// Add a `MAX` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MAX` aggregate over the rows
  /// in each group. The `MAX` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MAX` aggregate function will return `NULL`.
  Aggregation<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>, Expr<E?>)>
      max<E extends Comparable>(
              Expr<E?> Function(Expr<A> a, Expr<B> b) aggregateBuilder) =>
          _build(aggregateBuilder, MaxExpression._);

  /// Add a `COUNT(*)` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `COUNT(*)` aggregate over the rows
  /// in each group. This count the number of rows in the group, using a
  /// `COUNT(*)` expression.
  ///
  /// This will count the number of rows in the group, including rows consisting
  /// entirely of `NULL` values.
  Aggregation<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>, Expr<int>)> count() =>
      _build((a, b) => CountAllExpression._(), (a) => a);
}

/// Extension methods for completing a `GROUP BY`.
extension Group3By2<A, B, C, D, E>
    on Group<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>, Expr<E>)> {
  /// Finish `GROUP BY` clause by specifying _aggregate functions_.
  ///
  /// Groups are determined by the projection created with the `.groupBy`
  /// projection. Aggregate functions over rows within each group are specified
  /// using the [aggregationBuilder] callback.
  ///
  /// The resulting query will have a row for each distinct value of the
  /// projection created with `.groupBy`. Each row will contain the `.groupBy`
  /// projection and any aggregate functions built with [aggregationBuilder].
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<C>, Expr<D>, Expr<E>), T> Function(
              Aggregation<(Expr<C>, Expr<D>, Expr<E>), (Expr<A>, Expr<B>)> agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return Query._(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        e.take(2).toList(),
        e.skip(2).toList(),
      ),
    );
  }
}

/// Extension methods for specifying aggregate functions over rows in a group.
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

  /// Add a `SUM` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `SUM` aggregate over the rows
  /// in each group. The `SUM` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will coalesced to zero.
  Aggregation<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>, Expr<E>, Expr<F>)>
      sum<F extends num>(
              Expr<F?> Function(Expr<A> a, Expr<B> b) aggregateBuilder) =>
          _build(aggregateBuilder, SumExpression._);

  /// Add a `AVG` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes an `AVG` aggregate over the rows
  /// in each group. The `AVG` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will not be included in the average. If all rows in a group
  /// evaluate to `NULL`, the `AVG` aggregate function will return `NULL`.
  ///
  /// > [!WARNING]
  /// > If you want `NULL` values to count in denominator of the average, use
  /// > `.orElseValue(0)` to force a non-nullable expression.
  Aggregation<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>, Expr<E>, Expr<double?>)>
      avg<F extends num>(
              Expr<F?> Function(Expr<A> a, Expr<B> b) aggregateBuilder) =>
          _build(aggregateBuilder, AvgExpression._);

  /// Add a `MIN` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MIN` aggregate over the rows
  /// in each group. The `MIN` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MIN` aggregate function will return `NULL`.
  Aggregation<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>, Expr<E>, Expr<F?>)>
      min<F extends Comparable>(
              Expr<F?> Function(Expr<A> a, Expr<B> b) aggregateBuilder) =>
          _build(aggregateBuilder, MinExpression._);

  /// Add a `MAX` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MAX` aggregate over the rows
  /// in each group. The `MAX` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MAX` aggregate function will return `NULL`.
  Aggregation<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>, Expr<E>, Expr<F?>)>
      max<F extends Comparable>(
              Expr<F?> Function(Expr<A> a, Expr<B> b) aggregateBuilder) =>
          _build(aggregateBuilder, MaxExpression._);

  /// Add a `COUNT(*)` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `COUNT(*)` aggregate over the rows
  /// in each group. This count the number of rows in the group, using a
  /// `COUNT(*)` expression.
  ///
  /// This will count the number of rows in the group, including rows consisting
  /// entirely of `NULL` values.
  Aggregation<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>, Expr<E>, Expr<int>)>
      count() => _build((a, b) => CountAllExpression._(), (a) => a);
}

/// Extension methods for completing a `GROUP BY`.
extension Group4By2<A, B, C, D, E, F>
    on Group<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>, Expr<E>, Expr<F>)> {
  /// Finish `GROUP BY` clause by specifying _aggregate functions_.
  ///
  /// Groups are determined by the projection created with the `.groupBy`
  /// projection. Aggregate functions over rows within each group are specified
  /// using the [aggregationBuilder] callback.
  ///
  /// The resulting query will have a row for each distinct value of the
  /// projection created with `.groupBy`. Each row will contain the `.groupBy`
  /// projection and any aggregate functions built with [aggregationBuilder].
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<C>, Expr<D>, Expr<E>, Expr<F>), T> Function(
              Aggregation<(Expr<C>, Expr<D>, Expr<E>, Expr<F>),
                      (Expr<A>, Expr<B>)>
                  agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return Query._(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        e.take(2).toList(),
        e.skip(2).toList(),
      ),
    );
  }
}

/// Extension methods for specifying aggregate functions over rows in a group.
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

  /// Add a `SUM` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `SUM` aggregate over the rows
  /// in each group. The `SUM` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will coalesced to zero.
  Aggregation<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
      sum<G extends num>(
              Expr<G?> Function(Expr<A> a, Expr<B> b) aggregateBuilder) =>
          _build(aggregateBuilder, SumExpression._);

  /// Add a `AVG` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes an `AVG` aggregate over the rows
  /// in each group. The `AVG` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will not be included in the average. If all rows in a group
  /// evaluate to `NULL`, the `AVG` aggregate function will return `NULL`.
  ///
  /// > [!WARNING]
  /// > If you want `NULL` values to count in denominator of the average, use
  /// > `.orElseValue(0)` to force a non-nullable expression.
  Aggregation<(Expr<A>, Expr<B>),
      (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<double?>)> avg<G extends num>(
          Expr<G?> Function(Expr<A> a, Expr<B> b) aggregateBuilder) =>
      _build(aggregateBuilder, AvgExpression._);

  /// Add a `MIN` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MIN` aggregate over the rows
  /// in each group. The `MIN` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MIN` aggregate function will return `NULL`.
  Aggregation<(Expr<A>, Expr<B>),
      (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G?>)> min<G extends Comparable>(
          Expr<G?> Function(Expr<A> a, Expr<B> b) aggregateBuilder) =>
      _build(aggregateBuilder, MinExpression._);

  /// Add a `MAX` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MAX` aggregate over the rows
  /// in each group. The `MAX` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MAX` aggregate function will return `NULL`.
  Aggregation<(Expr<A>, Expr<B>),
      (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G?>)> max<G extends Comparable>(
          Expr<G?> Function(Expr<A> a, Expr<B> b) aggregateBuilder) =>
      _build(aggregateBuilder, MaxExpression._);

  /// Add a `COUNT(*)` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `COUNT(*)` aggregate over the rows
  /// in each group. This count the number of rows in the group, using a
  /// `COUNT(*)` expression.
  ///
  /// This will count the number of rows in the group, including rows consisting
  /// entirely of `NULL` values.
  Aggregation<(Expr<A>, Expr<B>),
          (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<int>)>
      count() => _build((a, b) => CountAllExpression._(), (a) => a);
}

/// Extension methods for completing a `GROUP BY`.
extension Group5By2<A, B, C, D, E, F, G> on Group<(Expr<A>, Expr<B>),
    (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> {
  /// Finish `GROUP BY` clause by specifying _aggregate functions_.
  ///
  /// Groups are determined by the projection created with the `.groupBy`
  /// projection. Aggregate functions over rows within each group are specified
  /// using the [aggregationBuilder] callback.
  ///
  /// The resulting query will have a row for each distinct value of the
  /// projection created with `.groupBy`. Each row will contain the `.groupBy`
  /// projection and any aggregate functions built with [aggregationBuilder].
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>), T> Function(
              Aggregation<(Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>),
                      (Expr<A>, Expr<B>)>
                  agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return Query._(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        e.take(2).toList(),
        e.skip(2).toList(),
      ),
    );
  }
}

/// Extension methods for specifying aggregate functions over rows in a group.
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

  /// Add a `SUM` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `SUM` aggregate over the rows
  /// in each group. The `SUM` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will coalesced to zero.
  Aggregation<(Expr<A>, Expr<B>),
          (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)>
      sum<H extends num>(
              Expr<H?> Function(Expr<A> a, Expr<B> b) aggregateBuilder) =>
          _build(aggregateBuilder, SumExpression._);

  /// Add a `AVG` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes an `AVG` aggregate over the rows
  /// in each group. The `AVG` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will not be included in the average. If all rows in a group
  /// evaluate to `NULL`, the `AVG` aggregate function will return `NULL`.
  ///
  /// > [!WARNING]
  /// > If you want `NULL` values to count in denominator of the average, use
  /// > `.orElseValue(0)` to force a non-nullable expression.
  Aggregation<(Expr<A>, Expr<B>),
          (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<double?>)>
      avg<H extends num>(
              Expr<H?> Function(Expr<A> a, Expr<B> b) aggregateBuilder) =>
          _build(aggregateBuilder, AvgExpression._);

  /// Add a `MIN` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MIN` aggregate over the rows
  /// in each group. The `MIN` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MIN` aggregate function will return `NULL`.
  Aggregation<(Expr<A>, Expr<B>),
          (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H?>)>
      min<H extends Comparable>(
              Expr<H?> Function(Expr<A> a, Expr<B> b) aggregateBuilder) =>
          _build(aggregateBuilder, MinExpression._);

  /// Add a `MAX` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MAX` aggregate over the rows
  /// in each group. The `MAX` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MAX` aggregate function will return `NULL`.
  Aggregation<(Expr<A>, Expr<B>),
          (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H?>)>
      max<H extends Comparable>(
              Expr<H?> Function(Expr<A> a, Expr<B> b) aggregateBuilder) =>
          _build(aggregateBuilder, MaxExpression._);

  /// Add a `COUNT(*)` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `COUNT(*)` aggregate over the rows
  /// in each group. This count the number of rows in the group, using a
  /// `COUNT(*)` expression.
  ///
  /// This will count the number of rows in the group, including rows consisting
  /// entirely of `NULL` values.
  Aggregation<(Expr<A>, Expr<B>),
          (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<int>)>
      count() => _build((a, b) => CountAllExpression._(), (a) => a);
}

/// Extension methods for completing a `GROUP BY`.
extension Group6By2<A, B, C, D, E, F, G, H> on Group<(Expr<A>, Expr<B>),
    (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)> {
  /// Finish `GROUP BY` clause by specifying _aggregate functions_.
  ///
  /// Groups are determined by the projection created with the `.groupBy`
  /// projection. Aggregate functions over rows within each group are specified
  /// using the [aggregationBuilder] callback.
  ///
  /// The resulting query will have a row for each distinct value of the
  /// projection created with `.groupBy`. Each row will contain the `.groupBy`
  /// projection and any aggregate functions built with [aggregationBuilder].
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>), T> Function(
              Aggregation<
                      (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>),
                      (Expr<A>, Expr<B>)>
                  agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return Query._(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        e.take(2).toList(),
        e.skip(2).toList(),
      ),
    );
  }
}

/// Extension methods for specifying aggregate functions over rows in a group.
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

  /// Add a `SUM` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `SUM` aggregate over the rows
  /// in each group. The `SUM` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will coalesced to zero.
  Aggregation<(Expr<A>, Expr<B>),
          (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<I>)>
      sum<I extends num>(
              Expr<I?> Function(Expr<A> a, Expr<B> b) aggregateBuilder) =>
          _build(aggregateBuilder, SumExpression._);

  /// Add a `AVG` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes an `AVG` aggregate over the rows
  /// in each group. The `AVG` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will not be included in the average. If all rows in a group
  /// evaluate to `NULL`, the `AVG` aggregate function will return `NULL`.
  ///
  /// > [!WARNING]
  /// > If you want `NULL` values to count in denominator of the average, use
  /// > `.orElseValue(0)` to force a non-nullable expression.
  Aggregation<(Expr<A>, Expr<B>),
          (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<double?>)>
      avg<I extends num>(
              Expr<I?> Function(Expr<A> a, Expr<B> b) aggregateBuilder) =>
          _build(aggregateBuilder, AvgExpression._);

  /// Add a `MIN` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MIN` aggregate over the rows
  /// in each group. The `MIN` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MIN` aggregate function will return `NULL`.
  Aggregation<(Expr<A>, Expr<B>),
          (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<I?>)>
      min<I extends Comparable>(
              Expr<I?> Function(Expr<A> a, Expr<B> b) aggregateBuilder) =>
          _build(aggregateBuilder, MinExpression._);

  /// Add a `MAX` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MAX` aggregate over the rows
  /// in each group. The `MAX` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MAX` aggregate function will return `NULL`.
  Aggregation<(Expr<A>, Expr<B>),
          (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<I?>)>
      max<I extends Comparable>(
              Expr<I?> Function(Expr<A> a, Expr<B> b) aggregateBuilder) =>
          _build(aggregateBuilder, MaxExpression._);

  /// Add a `COUNT(*)` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `COUNT(*)` aggregate over the rows
  /// in each group. This count the number of rows in the group, using a
  /// `COUNT(*)` expression.
  ///
  /// This will count the number of rows in the group, including rows consisting
  /// entirely of `NULL` values.
  Aggregation<(Expr<A>, Expr<B>),
          (Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<int>)>
      count() => _build((a, b) => CountAllExpression._(), (a) => a);
}

/// Extension methods for completing a `GROUP BY`.
extension Group1By3<A, B, C, D>
    on Group<(Expr<A>, Expr<B>, Expr<C>), (Expr<D>,)> {
  /// Finish `GROUP BY` clause by specifying _aggregate functions_.
  ///
  /// Groups are determined by the projection created with the `.groupBy`
  /// projection. Aggregate functions over rows within each group are specified
  /// using the [aggregationBuilder] callback.
  ///
  /// The resulting query will have a row for each distinct value of the
  /// projection created with `.groupBy`. Each row will contain the `.groupBy`
  /// projection and any aggregate functions built with [aggregationBuilder].
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<D>,), T> Function(
              Aggregation<(Expr<D>,), (Expr<A>, Expr<B>, Expr<C>)> agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return Query._(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        e.take(3).toList(),
        e.skip(3).toList(),
      ),
    );
  }
}

/// Extension methods for specifying aggregate functions over rows in a group.
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

  /// Add a `SUM` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `SUM` aggregate over the rows
  /// in each group. The `SUM` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will coalesced to zero.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>), (Expr<D>, Expr<E>)>
      sum<E extends num>(
              Expr<E?> Function(Expr<A> a, Expr<B> b, Expr<C> c)
                  aggregateBuilder) =>
          _build(aggregateBuilder, SumExpression._);

  /// Add a `AVG` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes an `AVG` aggregate over the rows
  /// in each group. The `AVG` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will not be included in the average. If all rows in a group
  /// evaluate to `NULL`, the `AVG` aggregate function will return `NULL`.
  ///
  /// > [!WARNING]
  /// > If you want `NULL` values to count in denominator of the average, use
  /// > `.orElseValue(0)` to force a non-nullable expression.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>), (Expr<D>, Expr<double?>)>
      avg<E extends num>(
              Expr<E?> Function(Expr<A> a, Expr<B> b, Expr<C> c)
                  aggregateBuilder) =>
          _build(aggregateBuilder, AvgExpression._);

  /// Add a `MIN` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MIN` aggregate over the rows
  /// in each group. The `MIN` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MIN` aggregate function will return `NULL`.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>), (Expr<D>, Expr<E?>)>
      min<E extends Comparable>(
              Expr<E?> Function(Expr<A> a, Expr<B> b, Expr<C> c)
                  aggregateBuilder) =>
          _build(aggregateBuilder, MinExpression._);

  /// Add a `MAX` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MAX` aggregate over the rows
  /// in each group. The `MAX` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MAX` aggregate function will return `NULL`.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>), (Expr<D>, Expr<E?>)>
      max<E extends Comparable>(
              Expr<E?> Function(Expr<A> a, Expr<B> b, Expr<C> c)
                  aggregateBuilder) =>
          _build(aggregateBuilder, MaxExpression._);

  /// Add a `COUNT(*)` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `COUNT(*)` aggregate over the rows
  /// in each group. This count the number of rows in the group, using a
  /// `COUNT(*)` expression.
  ///
  /// This will count the number of rows in the group, including rows consisting
  /// entirely of `NULL` values.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>), (Expr<D>, Expr<int>)> count() =>
      _build((a, b, c) => CountAllExpression._(), (a) => a);
}

/// Extension methods for completing a `GROUP BY`.
extension Group2By3<A, B, C, D, E>
    on Group<(Expr<A>, Expr<B>, Expr<C>), (Expr<D>, Expr<E>)> {
  /// Finish `GROUP BY` clause by specifying _aggregate functions_.
  ///
  /// Groups are determined by the projection created with the `.groupBy`
  /// projection. Aggregate functions over rows within each group are specified
  /// using the [aggregationBuilder] callback.
  ///
  /// The resulting query will have a row for each distinct value of the
  /// projection created with `.groupBy`. Each row will contain the `.groupBy`
  /// projection and any aggregate functions built with [aggregationBuilder].
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<D>, Expr<E>), T> Function(
              Aggregation<(Expr<D>, Expr<E>), (Expr<A>, Expr<B>, Expr<C>)> agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return Query._(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        e.take(3).toList(),
        e.skip(3).toList(),
      ),
    );
  }
}

/// Extension methods for specifying aggregate functions over rows in a group.
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

  /// Add a `SUM` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `SUM` aggregate over the rows
  /// in each group. The `SUM` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will coalesced to zero.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>), (Expr<D>, Expr<E>, Expr<F>)>
      sum<F extends num>(
              Expr<F?> Function(Expr<A> a, Expr<B> b, Expr<C> c)
                  aggregateBuilder) =>
          _build(aggregateBuilder, SumExpression._);

  /// Add a `AVG` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes an `AVG` aggregate over the rows
  /// in each group. The `AVG` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will not be included in the average. If all rows in a group
  /// evaluate to `NULL`, the `AVG` aggregate function will return `NULL`.
  ///
  /// > [!WARNING]
  /// > If you want `NULL` values to count in denominator of the average, use
  /// > `.orElseValue(0)` to force a non-nullable expression.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>), (Expr<D>, Expr<E>, Expr<double?>)>
      avg<F extends num>(
              Expr<F?> Function(Expr<A> a, Expr<B> b, Expr<C> c)
                  aggregateBuilder) =>
          _build(aggregateBuilder, AvgExpression._);

  /// Add a `MIN` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MIN` aggregate over the rows
  /// in each group. The `MIN` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MIN` aggregate function will return `NULL`.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>), (Expr<D>, Expr<E>, Expr<F?>)>
      min<F extends Comparable>(
              Expr<F?> Function(Expr<A> a, Expr<B> b, Expr<C> c)
                  aggregateBuilder) =>
          _build(aggregateBuilder, MinExpression._);

  /// Add a `MAX` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MAX` aggregate over the rows
  /// in each group. The `MAX` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MAX` aggregate function will return `NULL`.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>), (Expr<D>, Expr<E>, Expr<F?>)>
      max<F extends Comparable>(
              Expr<F?> Function(Expr<A> a, Expr<B> b, Expr<C> c)
                  aggregateBuilder) =>
          _build(aggregateBuilder, MaxExpression._);

  /// Add a `COUNT(*)` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `COUNT(*)` aggregate over the rows
  /// in each group. This count the number of rows in the group, using a
  /// `COUNT(*)` expression.
  ///
  /// This will count the number of rows in the group, including rows consisting
  /// entirely of `NULL` values.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>), (Expr<D>, Expr<E>, Expr<int>)>
      count() => _build((a, b, c) => CountAllExpression._(), (a) => a);
}

/// Extension methods for completing a `GROUP BY`.
extension Group3By3<A, B, C, D, E, F>
    on Group<(Expr<A>, Expr<B>, Expr<C>), (Expr<D>, Expr<E>, Expr<F>)> {
  /// Finish `GROUP BY` clause by specifying _aggregate functions_.
  ///
  /// Groups are determined by the projection created with the `.groupBy`
  /// projection. Aggregate functions over rows within each group are specified
  /// using the [aggregationBuilder] callback.
  ///
  /// The resulting query will have a row for each distinct value of the
  /// projection created with `.groupBy`. Each row will contain the `.groupBy`
  /// projection and any aggregate functions built with [aggregationBuilder].
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<D>, Expr<E>, Expr<F>), T> Function(
              Aggregation<(Expr<D>, Expr<E>, Expr<F>),
                      (Expr<A>, Expr<B>, Expr<C>)>
                  agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return Query._(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        e.take(3).toList(),
        e.skip(3).toList(),
      ),
    );
  }
}

/// Extension methods for specifying aggregate functions over rows in a group.
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

  /// Add a `SUM` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `SUM` aggregate over the rows
  /// in each group. The `SUM` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will coalesced to zero.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>), (Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
      sum<G extends num>(
              Expr<G?> Function(Expr<A> a, Expr<B> b, Expr<C> c)
                  aggregateBuilder) =>
          _build(aggregateBuilder, SumExpression._);

  /// Add a `AVG` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes an `AVG` aggregate over the rows
  /// in each group. The `AVG` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will not be included in the average. If all rows in a group
  /// evaluate to `NULL`, the `AVG` aggregate function will return `NULL`.
  ///
  /// > [!WARNING]
  /// > If you want `NULL` values to count in denominator of the average, use
  /// > `.orElseValue(0)` to force a non-nullable expression.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>),
      (Expr<D>, Expr<E>, Expr<F>, Expr<double?>)> avg<G extends num>(
          Expr<G?> Function(Expr<A> a, Expr<B> b, Expr<C> c)
              aggregateBuilder) =>
      _build(aggregateBuilder, AvgExpression._);

  /// Add a `MIN` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MIN` aggregate over the rows
  /// in each group. The `MIN` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MIN` aggregate function will return `NULL`.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>),
      (Expr<D>, Expr<E>, Expr<F>, Expr<G?>)> min<G extends Comparable>(
          Expr<G?> Function(Expr<A> a, Expr<B> b, Expr<C> c)
              aggregateBuilder) =>
      _build(aggregateBuilder, MinExpression._);

  /// Add a `MAX` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MAX` aggregate over the rows
  /// in each group. The `MAX` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MAX` aggregate function will return `NULL`.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>),
      (Expr<D>, Expr<E>, Expr<F>, Expr<G?>)> max<G extends Comparable>(
          Expr<G?> Function(Expr<A> a, Expr<B> b, Expr<C> c)
              aggregateBuilder) =>
      _build(aggregateBuilder, MaxExpression._);

  /// Add a `COUNT(*)` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `COUNT(*)` aggregate over the rows
  /// in each group. This count the number of rows in the group, using a
  /// `COUNT(*)` expression.
  ///
  /// This will count the number of rows in the group, including rows consisting
  /// entirely of `NULL` values.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>),
          (Expr<D>, Expr<E>, Expr<F>, Expr<int>)>
      count() => _build((a, b, c) => CountAllExpression._(), (a) => a);
}

/// Extension methods for completing a `GROUP BY`.
extension Group4By3<A, B, C, D, E, F, G> on Group<(Expr<A>, Expr<B>, Expr<C>),
    (Expr<D>, Expr<E>, Expr<F>, Expr<G>)> {
  /// Finish `GROUP BY` clause by specifying _aggregate functions_.
  ///
  /// Groups are determined by the projection created with the `.groupBy`
  /// projection. Aggregate functions over rows within each group are specified
  /// using the [aggregationBuilder] callback.
  ///
  /// The resulting query will have a row for each distinct value of the
  /// projection created with `.groupBy`. Each row will contain the `.groupBy`
  /// projection and any aggregate functions built with [aggregationBuilder].
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<D>, Expr<E>, Expr<F>, Expr<G>), T> Function(
              Aggregation<(Expr<D>, Expr<E>, Expr<F>, Expr<G>),
                      (Expr<A>, Expr<B>, Expr<C>)>
                  agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return Query._(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        e.take(3).toList(),
        e.skip(3).toList(),
      ),
    );
  }
}

/// Extension methods for specifying aggregate functions over rows in a group.
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

  /// Add a `SUM` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `SUM` aggregate over the rows
  /// in each group. The `SUM` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will coalesced to zero.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>),
      (Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)> sum<H extends num>(
          Expr<H?> Function(Expr<A> a, Expr<B> b, Expr<C> c)
              aggregateBuilder) =>
      _build(aggregateBuilder, SumExpression._);

  /// Add a `AVG` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes an `AVG` aggregate over the rows
  /// in each group. The `AVG` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will not be included in the average. If all rows in a group
  /// evaluate to `NULL`, the `AVG` aggregate function will return `NULL`.
  ///
  /// > [!WARNING]
  /// > If you want `NULL` values to count in denominator of the average, use
  /// > `.orElseValue(0)` to force a non-nullable expression.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>),
      (Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<double?>)> avg<H extends num>(
          Expr<H?> Function(Expr<A> a, Expr<B> b, Expr<C> c)
              aggregateBuilder) =>
      _build(aggregateBuilder, AvgExpression._);

  /// Add a `MIN` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MIN` aggregate over the rows
  /// in each group. The `MIN` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MIN` aggregate function will return `NULL`.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>),
      (Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H?>)> min<H extends Comparable>(
          Expr<H?> Function(Expr<A> a, Expr<B> b, Expr<C> c)
              aggregateBuilder) =>
      _build(aggregateBuilder, MinExpression._);

  /// Add a `MAX` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MAX` aggregate over the rows
  /// in each group. The `MAX` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MAX` aggregate function will return `NULL`.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>),
      (Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H?>)> max<H extends Comparable>(
          Expr<H?> Function(Expr<A> a, Expr<B> b, Expr<C> c)
              aggregateBuilder) =>
      _build(aggregateBuilder, MaxExpression._);

  /// Add a `COUNT(*)` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `COUNT(*)` aggregate over the rows
  /// in each group. This count the number of rows in the group, using a
  /// `COUNT(*)` expression.
  ///
  /// This will count the number of rows in the group, including rows consisting
  /// entirely of `NULL` values.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>),
          (Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<int>)>
      count() => _build((a, b, c) => CountAllExpression._(), (a) => a);
}

/// Extension methods for completing a `GROUP BY`.
extension Group5By3<A, B, C, D, E, F, G, H> on Group<
    (Expr<A>, Expr<B>, Expr<C>),
    (Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)> {
  /// Finish `GROUP BY` clause by specifying _aggregate functions_.
  ///
  /// Groups are determined by the projection created with the `.groupBy`
  /// projection. Aggregate functions over rows within each group are specified
  /// using the [aggregationBuilder] callback.
  ///
  /// The resulting query will have a row for each distinct value of the
  /// projection created with `.groupBy`. Each row will contain the `.groupBy`
  /// projection and any aggregate functions built with [aggregationBuilder].
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>), T> Function(
              Aggregation<(Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>),
                      (Expr<A>, Expr<B>, Expr<C>)>
                  agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return Query._(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        e.take(3).toList(),
        e.skip(3).toList(),
      ),
    );
  }
}

/// Extension methods for specifying aggregate functions over rows in a group.
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

  /// Add a `SUM` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `SUM` aggregate over the rows
  /// in each group. The `SUM` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will coalesced to zero.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>),
          (Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<I>)>
      sum<I extends num>(
              Expr<I?> Function(Expr<A> a, Expr<B> b, Expr<C> c)
                  aggregateBuilder) =>
          _build(aggregateBuilder, SumExpression._);

  /// Add a `AVG` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes an `AVG` aggregate over the rows
  /// in each group. The `AVG` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will not be included in the average. If all rows in a group
  /// evaluate to `NULL`, the `AVG` aggregate function will return `NULL`.
  ///
  /// > [!WARNING]
  /// > If you want `NULL` values to count in denominator of the average, use
  /// > `.orElseValue(0)` to force a non-nullable expression.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>),
          (Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<double?>)>
      avg<I extends num>(
              Expr<I?> Function(Expr<A> a, Expr<B> b, Expr<C> c)
                  aggregateBuilder) =>
          _build(aggregateBuilder, AvgExpression._);

  /// Add a `MIN` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MIN` aggregate over the rows
  /// in each group. The `MIN` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MIN` aggregate function will return `NULL`.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>),
          (Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<I?>)>
      min<I extends Comparable>(
              Expr<I?> Function(Expr<A> a, Expr<B> b, Expr<C> c)
                  aggregateBuilder) =>
          _build(aggregateBuilder, MinExpression._);

  /// Add a `MAX` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MAX` aggregate over the rows
  /// in each group. The `MAX` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MAX` aggregate function will return `NULL`.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>),
          (Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<I?>)>
      max<I extends Comparable>(
              Expr<I?> Function(Expr<A> a, Expr<B> b, Expr<C> c)
                  aggregateBuilder) =>
          _build(aggregateBuilder, MaxExpression._);

  /// Add a `COUNT(*)` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `COUNT(*)` aggregate over the rows
  /// in each group. This count the number of rows in the group, using a
  /// `COUNT(*)` expression.
  ///
  /// This will count the number of rows in the group, including rows consisting
  /// entirely of `NULL` values.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>),
          (Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<int>)>
      count() => _build((a, b, c) => CountAllExpression._(), (a) => a);
}

/// Extension methods for completing a `GROUP BY`.
extension Group1By4<A, B, C, D, E>
    on Group<(Expr<A>, Expr<B>, Expr<C>, Expr<D>), (Expr<E>,)> {
  /// Finish `GROUP BY` clause by specifying _aggregate functions_.
  ///
  /// Groups are determined by the projection created with the `.groupBy`
  /// projection. Aggregate functions over rows within each group are specified
  /// using the [aggregationBuilder] callback.
  ///
  /// The resulting query will have a row for each distinct value of the
  /// projection created with `.groupBy`. Each row will contain the `.groupBy`
  /// projection and any aggregate functions built with [aggregationBuilder].
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<E>,), T> Function(
              Aggregation<(Expr<E>,), (Expr<A>, Expr<B>, Expr<C>, Expr<D>)> agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return Query._(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        e.take(4).toList(),
        e.skip(4).toList(),
      ),
    );
  }
}

/// Extension methods for specifying aggregate functions over rows in a group.
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

  /// Add a `SUM` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `SUM` aggregate over the rows
  /// in each group. The `SUM` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will coalesced to zero.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>), (Expr<E>, Expr<F>)>
      sum<F extends num>(
              Expr<F?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
                  aggregateBuilder) =>
          _build(aggregateBuilder, SumExpression._);

  /// Add a `AVG` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes an `AVG` aggregate over the rows
  /// in each group. The `AVG` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will not be included in the average. If all rows in a group
  /// evaluate to `NULL`, the `AVG` aggregate function will return `NULL`.
  ///
  /// > [!WARNING]
  /// > If you want `NULL` values to count in denominator of the average, use
  /// > `.orElseValue(0)` to force a non-nullable expression.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>), (Expr<E>, Expr<double?>)>
      avg<F extends num>(
              Expr<F?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
                  aggregateBuilder) =>
          _build(aggregateBuilder, AvgExpression._);

  /// Add a `MIN` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MIN` aggregate over the rows
  /// in each group. The `MIN` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MIN` aggregate function will return `NULL`.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>), (Expr<E>, Expr<F?>)>
      min<F extends Comparable>(
              Expr<F?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
                  aggregateBuilder) =>
          _build(aggregateBuilder, MinExpression._);

  /// Add a `MAX` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MAX` aggregate over the rows
  /// in each group. The `MAX` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MAX` aggregate function will return `NULL`.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>), (Expr<E>, Expr<F?>)>
      max<F extends Comparable>(
              Expr<F?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
                  aggregateBuilder) =>
          _build(aggregateBuilder, MaxExpression._);

  /// Add a `COUNT(*)` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `COUNT(*)` aggregate over the rows
  /// in each group. This count the number of rows in the group, using a
  /// `COUNT(*)` expression.
  ///
  /// This will count the number of rows in the group, including rows consisting
  /// entirely of `NULL` values.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>), (Expr<E>, Expr<int>)>
      count() => _build((a, b, c, d) => CountAllExpression._(), (a) => a);
}

/// Extension methods for completing a `GROUP BY`.
extension Group2By4<A, B, C, D, E, F>
    on Group<(Expr<A>, Expr<B>, Expr<C>, Expr<D>), (Expr<E>, Expr<F>)> {
  /// Finish `GROUP BY` clause by specifying _aggregate functions_.
  ///
  /// Groups are determined by the projection created with the `.groupBy`
  /// projection. Aggregate functions over rows within each group are specified
  /// using the [aggregationBuilder] callback.
  ///
  /// The resulting query will have a row for each distinct value of the
  /// projection created with `.groupBy`. Each row will contain the `.groupBy`
  /// projection and any aggregate functions built with [aggregationBuilder].
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<E>, Expr<F>), T> Function(
              Aggregation<(Expr<E>, Expr<F>),
                      (Expr<A>, Expr<B>, Expr<C>, Expr<D>)>
                  agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return Query._(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        e.take(4).toList(),
        e.skip(4).toList(),
      ),
    );
  }
}

/// Extension methods for specifying aggregate functions over rows in a group.
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

  /// Add a `SUM` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `SUM` aggregate over the rows
  /// in each group. The `SUM` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will coalesced to zero.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>), (Expr<E>, Expr<F>, Expr<G>)>
      sum<G extends num>(
              Expr<G?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
                  aggregateBuilder) =>
          _build(aggregateBuilder, SumExpression._);

  /// Add a `AVG` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes an `AVG` aggregate over the rows
  /// in each group. The `AVG` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will not be included in the average. If all rows in a group
  /// evaluate to `NULL`, the `AVG` aggregate function will return `NULL`.
  ///
  /// > [!WARNING]
  /// > If you want `NULL` values to count in denominator of the average, use
  /// > `.orElseValue(0)` to force a non-nullable expression.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>),
      (Expr<E>, Expr<F>, Expr<double?>)> avg<G extends num>(
          Expr<G?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
              aggregateBuilder) =>
      _build(aggregateBuilder, AvgExpression._);

  /// Add a `MIN` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MIN` aggregate over the rows
  /// in each group. The `MIN` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MIN` aggregate function will return `NULL`.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>),
      (Expr<E>, Expr<F>, Expr<G?>)> min<G extends Comparable>(
          Expr<G?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
              aggregateBuilder) =>
      _build(aggregateBuilder, MinExpression._);

  /// Add a `MAX` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MAX` aggregate over the rows
  /// in each group. The `MAX` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MAX` aggregate function will return `NULL`.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>),
      (Expr<E>, Expr<F>, Expr<G?>)> max<G extends Comparable>(
          Expr<G?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
              aggregateBuilder) =>
      _build(aggregateBuilder, MaxExpression._);

  /// Add a `COUNT(*)` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `COUNT(*)` aggregate over the rows
  /// in each group. This count the number of rows in the group, using a
  /// `COUNT(*)` expression.
  ///
  /// This will count the number of rows in the group, including rows consisting
  /// entirely of `NULL` values.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>),
          (Expr<E>, Expr<F>, Expr<int>)>
      count() => _build((a, b, c, d) => CountAllExpression._(), (a) => a);
}

/// Extension methods for completing a `GROUP BY`.
extension Group3By4<A, B, C, D, E, F, G> on Group<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>), (Expr<E>, Expr<F>, Expr<G>)> {
  /// Finish `GROUP BY` clause by specifying _aggregate functions_.
  ///
  /// Groups are determined by the projection created with the `.groupBy`
  /// projection. Aggregate functions over rows within each group are specified
  /// using the [aggregationBuilder] callback.
  ///
  /// The resulting query will have a row for each distinct value of the
  /// projection created with `.groupBy`. Each row will contain the `.groupBy`
  /// projection and any aggregate functions built with [aggregationBuilder].
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<E>, Expr<F>, Expr<G>), T> Function(
              Aggregation<(Expr<E>, Expr<F>, Expr<G>),
                      (Expr<A>, Expr<B>, Expr<C>, Expr<D>)>
                  agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return Query._(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        e.take(4).toList(),
        e.skip(4).toList(),
      ),
    );
  }
}

/// Extension methods for specifying aggregate functions over rows in a group.
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

  /// Add a `SUM` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `SUM` aggregate over the rows
  /// in each group. The `SUM` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will coalesced to zero.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>),
      (Expr<E>, Expr<F>, Expr<G>, Expr<H>)> sum<H extends num>(
          Expr<H?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
              aggregateBuilder) =>
      _build(aggregateBuilder, SumExpression._);

  /// Add a `AVG` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes an `AVG` aggregate over the rows
  /// in each group. The `AVG` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will not be included in the average. If all rows in a group
  /// evaluate to `NULL`, the `AVG` aggregate function will return `NULL`.
  ///
  /// > [!WARNING]
  /// > If you want `NULL` values to count in denominator of the average, use
  /// > `.orElseValue(0)` to force a non-nullable expression.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>),
      (Expr<E>, Expr<F>, Expr<G>, Expr<double?>)> avg<H extends num>(
          Expr<H?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
              aggregateBuilder) =>
      _build(aggregateBuilder, AvgExpression._);

  /// Add a `MIN` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MIN` aggregate over the rows
  /// in each group. The `MIN` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MIN` aggregate function will return `NULL`.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>),
      (Expr<E>, Expr<F>, Expr<G>, Expr<H?>)> min<H extends Comparable>(
          Expr<H?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
              aggregateBuilder) =>
      _build(aggregateBuilder, MinExpression._);

  /// Add a `MAX` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MAX` aggregate over the rows
  /// in each group. The `MAX` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MAX` aggregate function will return `NULL`.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>),
      (Expr<E>, Expr<F>, Expr<G>, Expr<H?>)> max<H extends Comparable>(
          Expr<H?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
              aggregateBuilder) =>
      _build(aggregateBuilder, MaxExpression._);

  /// Add a `COUNT(*)` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `COUNT(*)` aggregate over the rows
  /// in each group. This count the number of rows in the group, using a
  /// `COUNT(*)` expression.
  ///
  /// This will count the number of rows in the group, including rows consisting
  /// entirely of `NULL` values.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>),
          (Expr<E>, Expr<F>, Expr<G>, Expr<int>)>
      count() => _build((a, b, c, d) => CountAllExpression._(), (a) => a);
}

/// Extension methods for completing a `GROUP BY`.
extension Group4By4<A, B, C, D, E, F, G, H> on Group<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>),
    (Expr<E>, Expr<F>, Expr<G>, Expr<H>)> {
  /// Finish `GROUP BY` clause by specifying _aggregate functions_.
  ///
  /// Groups are determined by the projection created with the `.groupBy`
  /// projection. Aggregate functions over rows within each group are specified
  /// using the [aggregationBuilder] callback.
  ///
  /// The resulting query will have a row for each distinct value of the
  /// projection created with `.groupBy`. Each row will contain the `.groupBy`
  /// projection and any aggregate functions built with [aggregationBuilder].
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<E>, Expr<F>, Expr<G>, Expr<H>), T> Function(
              Aggregation<(Expr<E>, Expr<F>, Expr<G>, Expr<H>),
                      (Expr<A>, Expr<B>, Expr<C>, Expr<D>)>
                  agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return Query._(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        e.take(4).toList(),
        e.skip(4).toList(),
      ),
    );
  }
}

/// Extension methods for specifying aggregate functions over rows in a group.
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

  /// Add a `SUM` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `SUM` aggregate over the rows
  /// in each group. The `SUM` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will coalesced to zero.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>),
      (Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<I>)> sum<I extends num>(
          Expr<I?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
              aggregateBuilder) =>
      _build(aggregateBuilder, SumExpression._);

  /// Add a `AVG` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes an `AVG` aggregate over the rows
  /// in each group. The `AVG` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will not be included in the average. If all rows in a group
  /// evaluate to `NULL`, the `AVG` aggregate function will return `NULL`.
  ///
  /// > [!WARNING]
  /// > If you want `NULL` values to count in denominator of the average, use
  /// > `.orElseValue(0)` to force a non-nullable expression.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>),
      (Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<double?>)> avg<I extends num>(
          Expr<I?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
              aggregateBuilder) =>
      _build(aggregateBuilder, AvgExpression._);

  /// Add a `MIN` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MIN` aggregate over the rows
  /// in each group. The `MIN` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MIN` aggregate function will return `NULL`.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>),
      (Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<I?>)> min<I extends Comparable>(
          Expr<I?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
              aggregateBuilder) =>
      _build(aggregateBuilder, MinExpression._);

  /// Add a `MAX` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MAX` aggregate over the rows
  /// in each group. The `MAX` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MAX` aggregate function will return `NULL`.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>),
      (Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<I?>)> max<I extends Comparable>(
          Expr<I?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
              aggregateBuilder) =>
      _build(aggregateBuilder, MaxExpression._);

  /// Add a `COUNT(*)` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `COUNT(*)` aggregate over the rows
  /// in each group. This count the number of rows in the group, using a
  /// `COUNT(*)` expression.
  ///
  /// This will count the number of rows in the group, including rows consisting
  /// entirely of `NULL` values.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>),
          (Expr<E>, Expr<F>, Expr<G>, Expr<H>, Expr<int>)>
      count() => _build((a, b, c, d) => CountAllExpression._(), (a) => a);
}

/// Extension methods for completing a `GROUP BY`.
extension Group1By5<A, B, C, D, E, F>
    on Group<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>), (Expr<F>,)> {
  /// Finish `GROUP BY` clause by specifying _aggregate functions_.
  ///
  /// Groups are determined by the projection created with the `.groupBy`
  /// projection. Aggregate functions over rows within each group are specified
  /// using the [aggregationBuilder] callback.
  ///
  /// The resulting query will have a row for each distinct value of the
  /// projection created with `.groupBy`. Each row will contain the `.groupBy`
  /// projection and any aggregate functions built with [aggregationBuilder].
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<F>,), T> Function(
              Aggregation<(Expr<F>,),
                      (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)>
                  agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return Query._(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        e.take(5).toList(),
        e.skip(5).toList(),
      ),
    );
  }
}

/// Extension methods for specifying aggregate functions over rows in a group.
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

  /// Add a `SUM` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `SUM` aggregate over the rows
  /// in each group. The `SUM` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will coalesced to zero.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>), (Expr<F>, Expr<G>)>
      sum<G extends num>(
              Expr<G?> Function(
                      Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
                  aggregateBuilder) =>
          _build(aggregateBuilder, SumExpression._);

  /// Add a `AVG` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes an `AVG` aggregate over the rows
  /// in each group. The `AVG` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will not be included in the average. If all rows in a group
  /// evaluate to `NULL`, the `AVG` aggregate function will return `NULL`.
  ///
  /// > [!WARNING]
  /// > If you want `NULL` values to count in denominator of the average, use
  /// > `.orElseValue(0)` to force a non-nullable expression.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>),
      (Expr<F>, Expr<double?>)> avg<G extends num>(
          Expr<G?> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
              aggregateBuilder) =>
      _build(aggregateBuilder, AvgExpression._);

  /// Add a `MIN` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MIN` aggregate over the rows
  /// in each group. The `MIN` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MIN` aggregate function will return `NULL`.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>),
      (Expr<F>, Expr<G?>)> min<G extends Comparable>(
          Expr<G?> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
              aggregateBuilder) =>
      _build(aggregateBuilder, MinExpression._);

  /// Add a `MAX` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MAX` aggregate over the rows
  /// in each group. The `MAX` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MAX` aggregate function will return `NULL`.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>),
      (Expr<F>, Expr<G?>)> max<G extends Comparable>(
          Expr<G?> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
              aggregateBuilder) =>
      _build(aggregateBuilder, MaxExpression._);

  /// Add a `COUNT(*)` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `COUNT(*)` aggregate over the rows
  /// in each group. This count the number of rows in the group, using a
  /// `COUNT(*)` expression.
  ///
  /// This will count the number of rows in the group, including rows consisting
  /// entirely of `NULL` values.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>),
          (Expr<F>, Expr<int>)>
      count() => _build((a, b, c, d, e) => CountAllExpression._(), (a) => a);
}

/// Extension methods for completing a `GROUP BY`.
extension Group2By5<A, B, C, D, E, F, G> on Group<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>), (Expr<F>, Expr<G>)> {
  /// Finish `GROUP BY` clause by specifying _aggregate functions_.
  ///
  /// Groups are determined by the projection created with the `.groupBy`
  /// projection. Aggregate functions over rows within each group are specified
  /// using the [aggregationBuilder] callback.
  ///
  /// The resulting query will have a row for each distinct value of the
  /// projection created with `.groupBy`. Each row will contain the `.groupBy`
  /// projection and any aggregate functions built with [aggregationBuilder].
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<F>, Expr<G>), T> Function(
              Aggregation<(Expr<F>, Expr<G>),
                      (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)>
                  agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return Query._(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        e.take(5).toList(),
        e.skip(5).toList(),
      ),
    );
  }
}

/// Extension methods for specifying aggregate functions over rows in a group.
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

  /// Add a `SUM` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `SUM` aggregate over the rows
  /// in each group. The `SUM` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will coalesced to zero.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>),
      (Expr<F>, Expr<G>, Expr<H>)> sum<H extends num>(
          Expr<H?> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
              aggregateBuilder) =>
      _build(aggregateBuilder, SumExpression._);

  /// Add a `AVG` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes an `AVG` aggregate over the rows
  /// in each group. The `AVG` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will not be included in the average. If all rows in a group
  /// evaluate to `NULL`, the `AVG` aggregate function will return `NULL`.
  ///
  /// > [!WARNING]
  /// > If you want `NULL` values to count in denominator of the average, use
  /// > `.orElseValue(0)` to force a non-nullable expression.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>),
      (Expr<F>, Expr<G>, Expr<double?>)> avg<H extends num>(
          Expr<H?> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
              aggregateBuilder) =>
      _build(aggregateBuilder, AvgExpression._);

  /// Add a `MIN` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MIN` aggregate over the rows
  /// in each group. The `MIN` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MIN` aggregate function will return `NULL`.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>),
      (Expr<F>, Expr<G>, Expr<H?>)> min<H extends Comparable>(
          Expr<H?> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
              aggregateBuilder) =>
      _build(aggregateBuilder, MinExpression._);

  /// Add a `MAX` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MAX` aggregate over the rows
  /// in each group. The `MAX` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MAX` aggregate function will return `NULL`.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>),
      (Expr<F>, Expr<G>, Expr<H?>)> max<H extends Comparable>(
          Expr<H?> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
              aggregateBuilder) =>
      _build(aggregateBuilder, MaxExpression._);

  /// Add a `COUNT(*)` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `COUNT(*)` aggregate over the rows
  /// in each group. This count the number of rows in the group, using a
  /// `COUNT(*)` expression.
  ///
  /// This will count the number of rows in the group, including rows consisting
  /// entirely of `NULL` values.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>),
          (Expr<F>, Expr<G>, Expr<int>)>
      count() => _build((a, b, c, d, e) => CountAllExpression._(), (a) => a);
}

/// Extension methods for completing a `GROUP BY`.
extension Group3By5<A, B, C, D, E, F, G, H> on Group<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>),
    (Expr<F>, Expr<G>, Expr<H>)> {
  /// Finish `GROUP BY` clause by specifying _aggregate functions_.
  ///
  /// Groups are determined by the projection created with the `.groupBy`
  /// projection. Aggregate functions over rows within each group are specified
  /// using the [aggregationBuilder] callback.
  ///
  /// The resulting query will have a row for each distinct value of the
  /// projection created with `.groupBy`. Each row will contain the `.groupBy`
  /// projection and any aggregate functions built with [aggregationBuilder].
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<F>, Expr<G>, Expr<H>), T> Function(
              Aggregation<(Expr<F>, Expr<G>, Expr<H>),
                      (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)>
                  agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return Query._(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        e.take(5).toList(),
        e.skip(5).toList(),
      ),
    );
  }
}

/// Extension methods for specifying aggregate functions over rows in a group.
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

  /// Add a `SUM` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `SUM` aggregate over the rows
  /// in each group. The `SUM` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will coalesced to zero.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>),
      (Expr<F>, Expr<G>, Expr<H>, Expr<I>)> sum<I extends num>(
          Expr<I?> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
              aggregateBuilder) =>
      _build(aggregateBuilder, SumExpression._);

  /// Add a `AVG` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes an `AVG` aggregate over the rows
  /// in each group. The `AVG` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will not be included in the average. If all rows in a group
  /// evaluate to `NULL`, the `AVG` aggregate function will return `NULL`.
  ///
  /// > [!WARNING]
  /// > If you want `NULL` values to count in denominator of the average, use
  /// > `.orElseValue(0)` to force a non-nullable expression.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>),
      (Expr<F>, Expr<G>, Expr<H>, Expr<double?>)> avg<I extends num>(
          Expr<I?> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
              aggregateBuilder) =>
      _build(aggregateBuilder, AvgExpression._);

  /// Add a `MIN` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MIN` aggregate over the rows
  /// in each group. The `MIN` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MIN` aggregate function will return `NULL`.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>),
      (Expr<F>, Expr<G>, Expr<H>, Expr<I?>)> min<I extends Comparable>(
          Expr<I?> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
              aggregateBuilder) =>
      _build(aggregateBuilder, MinExpression._);

  /// Add a `MAX` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MAX` aggregate over the rows
  /// in each group. The `MAX` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MAX` aggregate function will return `NULL`.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>),
      (Expr<F>, Expr<G>, Expr<H>, Expr<I?>)> max<I extends Comparable>(
          Expr<I?> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
              aggregateBuilder) =>
      _build(aggregateBuilder, MaxExpression._);

  /// Add a `COUNT(*)` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `COUNT(*)` aggregate over the rows
  /// in each group. This count the number of rows in the group, using a
  /// `COUNT(*)` expression.
  ///
  /// This will count the number of rows in the group, including rows consisting
  /// entirely of `NULL` values.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>),
          (Expr<F>, Expr<G>, Expr<H>, Expr<int>)>
      count() => _build((a, b, c, d, e) => CountAllExpression._(), (a) => a);
}

/// Extension methods for completing a `GROUP BY`.
extension Group1By6<A, B, C, D, E, F, G> on Group<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>), (Expr<G>,)> {
  /// Finish `GROUP BY` clause by specifying _aggregate functions_.
  ///
  /// Groups are determined by the projection created with the `.groupBy`
  /// projection. Aggregate functions over rows within each group are specified
  /// using the [aggregationBuilder] callback.
  ///
  /// The resulting query will have a row for each distinct value of the
  /// projection created with `.groupBy`. Each row will contain the `.groupBy`
  /// projection and any aggregate functions built with [aggregationBuilder].
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<G>,), T> Function(
              Aggregation<(Expr<G>,),
                      (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)>
                  agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return Query._(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        e.take(6).toList(),
        e.skip(6).toList(),
      ),
    );
  }
}

/// Extension methods for specifying aggregate functions over rows in a group.
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

  /// Add a `SUM` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `SUM` aggregate over the rows
  /// in each group. The `SUM` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will coalesced to zero.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>),
      (Expr<G>, Expr<H>)> sum<H extends num>(
          Expr<H?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f)
              aggregateBuilder) =>
      _build(aggregateBuilder, SumExpression._);

  /// Add a `AVG` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes an `AVG` aggregate over the rows
  /// in each group. The `AVG` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will not be included in the average. If all rows in a group
  /// evaluate to `NULL`, the `AVG` aggregate function will return `NULL`.
  ///
  /// > [!WARNING]
  /// > If you want `NULL` values to count in denominator of the average, use
  /// > `.orElseValue(0)` to force a non-nullable expression.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>),
      (Expr<G>, Expr<double?>)> avg<H extends num>(
          Expr<H?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f)
              aggregateBuilder) =>
      _build(aggregateBuilder, AvgExpression._);

  /// Add a `MIN` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MIN` aggregate over the rows
  /// in each group. The `MIN` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MIN` aggregate function will return `NULL`.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>),
      (Expr<G>, Expr<H?>)> min<H extends Comparable>(
          Expr<H?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f)
              aggregateBuilder) =>
      _build(aggregateBuilder, MinExpression._);

  /// Add a `MAX` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MAX` aggregate over the rows
  /// in each group. The `MAX` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MAX` aggregate function will return `NULL`.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>),
      (Expr<G>, Expr<H?>)> max<H extends Comparable>(
          Expr<H?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f)
              aggregateBuilder) =>
      _build(aggregateBuilder, MaxExpression._);

  /// Add a `COUNT(*)` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `COUNT(*)` aggregate over the rows
  /// in each group. This count the number of rows in the group, using a
  /// `COUNT(*)` expression.
  ///
  /// This will count the number of rows in the group, including rows consisting
  /// entirely of `NULL` values.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>),
          (Expr<G>, Expr<int>)>
      count() => _build((a, b, c, d, e, f) => CountAllExpression._(), (a) => a);
}

/// Extension methods for completing a `GROUP BY`.
extension Group2By6<A, B, C, D, E, F, G, H> on Group<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>),
    (Expr<G>, Expr<H>)> {
  /// Finish `GROUP BY` clause by specifying _aggregate functions_.
  ///
  /// Groups are determined by the projection created with the `.groupBy`
  /// projection. Aggregate functions over rows within each group are specified
  /// using the [aggregationBuilder] callback.
  ///
  /// The resulting query will have a row for each distinct value of the
  /// projection created with `.groupBy`. Each row will contain the `.groupBy`
  /// projection and any aggregate functions built with [aggregationBuilder].
  Query<T> aggregate<T extends Record>(
      Aggregation<(Expr<G>, Expr<H>), T> Function(
              Aggregation<(Expr<G>, Expr<H>),
                      (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)>
                  agg)
          aggregationBuilder) {
    final agg = aggregationBuilder(Aggregation._(_standins, _group));

    return Query._(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        e.take(6).toList(),
        e.skip(6).toList(),
      ),
    );
  }
}

/// Extension methods for specifying aggregate functions over rows in a group.
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

  /// Add a `SUM` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `SUM` aggregate over the rows
  /// in each group. The `SUM` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will coalesced to zero.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>),
      (Expr<G>, Expr<H>, Expr<I>)> sum<I extends num>(
          Expr<I?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f)
              aggregateBuilder) =>
      _build(aggregateBuilder, SumExpression._);

  /// Add a `AVG` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes an `AVG` aggregate over the rows
  /// in each group. The `AVG` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will not be included in the average. If all rows in a group
  /// evaluate to `NULL`, the `AVG` aggregate function will return `NULL`.
  ///
  /// > [!WARNING]
  /// > If you want `NULL` values to count in denominator of the average, use
  /// > `.orElseValue(0)` to force a non-nullable expression.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>),
      (Expr<G>, Expr<H>, Expr<double?>)> avg<I extends num>(
          Expr<I?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f)
              aggregateBuilder) =>
      _build(aggregateBuilder, AvgExpression._);

  /// Add a `MIN` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MIN` aggregate over the rows
  /// in each group. The `MIN` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MIN` aggregate function will return `NULL`.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>),
      (Expr<G>, Expr<H>, Expr<I?>)> min<I extends Comparable>(
          Expr<I?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f)
              aggregateBuilder) =>
      _build(aggregateBuilder, MinExpression._);

  /// Add a `MAX` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MAX` aggregate over the rows
  /// in each group. The `MAX` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MAX` aggregate function will return `NULL`.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>),
      (Expr<G>, Expr<H>, Expr<I?>)> max<I extends Comparable>(
          Expr<I?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f)
              aggregateBuilder) =>
      _build(aggregateBuilder, MaxExpression._);

  /// Add a `COUNT(*)` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `COUNT(*)` aggregate over the rows
  /// in each group. This count the number of rows in the group, using a
  /// `COUNT(*)` expression.
  ///
  /// This will count the number of rows in the group, including rows consisting
  /// entirely of `NULL` values.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>),
          (Expr<G>, Expr<H>, Expr<int>)>
      count() => _build((a, b, c, d, e, f) => CountAllExpression._(), (a) => a);
}

/// Extension methods for completing a `GROUP BY`.
extension Group1By7<A, B, C, D, E, F, G, H> on Group<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>),
    (Expr<H>,)> {
  /// Finish `GROUP BY` clause by specifying _aggregate functions_.
  ///
  /// Groups are determined by the projection created with the `.groupBy`
  /// projection. Aggregate functions over rows within each group are specified
  /// using the [aggregationBuilder] callback.
  ///
  /// The resulting query will have a row for each distinct value of the
  /// projection created with `.groupBy`. Each row will contain the `.groupBy`
  /// projection and any aggregate functions built with [aggregationBuilder].
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

    return Query._(
      _from._context,
      agg._projection,
      (e) => GroupByClause._(
        _from._from(_from._expressions.toList()),
        _handle,
        e.take(7).toList(),
        e.skip(7).toList(),
      ),
    );
  }
}

/// Extension methods for specifying aggregate functions over rows in a group.
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

  /// Add a `SUM` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `SUM` aggregate over the rows
  /// in each group. The `SUM` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will coalesced to zero.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>),
      (Expr<H>, Expr<I>)> sum<I extends num>(
          Expr<I?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g)
              aggregateBuilder) =>
      _build(aggregateBuilder, SumExpression._);

  /// Add a `AVG` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes an `AVG` aggregate over the rows
  /// in each group. The `AVG` aggregate is applied to the `Expr<num>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<num>` built by [aggregateBuilder] evaluates
  /// to `NULL` it will not be included in the average. If all rows in a group
  /// evaluate to `NULL`, the `AVG` aggregate function will return `NULL`.
  ///
  /// > [!WARNING]
  /// > If you want `NULL` values to count in denominator of the average, use
  /// > `.orElseValue(0)` to force a non-nullable expression.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>),
      (Expr<H>, Expr<double?>)> avg<I extends num>(
          Expr<I?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g)
              aggregateBuilder) =>
      _build(aggregateBuilder, AvgExpression._);

  /// Add a `MIN` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MIN` aggregate over the rows
  /// in each group. The `MIN` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MIN` aggregate function will return `NULL`.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>),
      (Expr<H>, Expr<I?>)> min<I extends Comparable>(
          Expr<I?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g)
              aggregateBuilder) =>
      _build(aggregateBuilder, MinExpression._);

  /// Add a `MAX` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `MAX` aggregate over the rows
  /// in each group. The `MAX` aggregate is applied to the `Expr<Comparable>`
  /// created with [aggregateBuilder].
  ///
  /// If the expression `Expr<Comparable>` built by [aggregateBuilder] evaluates
  /// to `NULL` it is not considered. If all rows in a group evaluate to `NULL`,
  /// the `MAX` aggregate function will return `NULL`.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>),
      (Expr<H>, Expr<I?>)> max<I extends Comparable>(
          Expr<I?> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f, Expr<G> g)
              aggregateBuilder) =>
      _build(aggregateBuilder, MaxExpression._);

  /// Add a `COUNT(*)` aggregate function to this [Aggregation].
  ///
  /// Returns an [Aggregation] that includes a `COUNT(*)` aggregate over the rows
  /// in each group. This count the number of rows in the group, using a
  /// `COUNT(*)` expression.
  ///
  /// This will count the number of rows in the group, including rows consisting
  /// entirely of `NULL` values.
  Aggregation<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>),
          (Expr<H>, Expr<int>)>
      count() =>
          _build((a, b, c, d, e, f, g) => CountAllExpression._(), (a) => a);
}

/// Extensions for a query returning at-most one row with
/// 1 expression.
extension QuerySingle1<A> on QuerySingle<(Expr<A>,)> {
  /// Get [Query] with the same rows as this [QuerySingle].
  ///
  /// This returns a [Query] with at-most one row.
  ///
  /// > [!NOTE]
  /// > This is method is only useful for converting a [QuerySingle]
  /// > into a [Query] representation, which can be necessary if you wish to pass
  /// > a [QuerySingle] into a function that only accepts [Query].
  Query<(Expr<A>,)> get asQuery => _query;

  /// Filter [QuerySingle] using `WHERE` clause.
  ///
  /// Returns a [QuerySingle] retaining rows from this [QuerySingle] where the expression
  /// returned by [conditionBuilder] evaluates to `true`.
  QuerySingle<(Expr<A>,)> where(
          Expr<bool> Function(Expr<A> a) conditionBuilder) =>
      asQuery.where(conditionBuilder).first;

  /// Create a projection of this [QuerySingle] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [QuerySingle] object which doesn't have any methods!
  ///
  /// All methods and properties on [QuerySingle<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  QuerySingle<T> select<T extends Record>(
          T Function(Expr<A> a) projectionBuilder) =>
      QuerySingle._(asQuery.select(projectionBuilder));

  /// Query the database for the row matching this [QuerySingle], if any.
  ///
  /// This returns at-most a single row because [QuerySingle] represents a [Query]
  /// containing at-most one row.
  Future<A?> fetch() async => (await asQuery.fetch()).firstOrNull;
}

/// Extensions for a query returning at-most one row with
/// 2 expressions.
extension QuerySingle2<A, B> on QuerySingle<(Expr<A>, Expr<B>)> {
  /// Get [Query] with the same rows as this [QuerySingle].
  ///
  /// This returns a [Query] with at-most one row.
  ///
  /// > [!NOTE]
  /// > This is method is only useful for converting a [QuerySingle]
  /// > into a [Query] representation, which can be necessary if you wish to pass
  /// > a [QuerySingle] into a function that only accepts [Query].
  Query<(Expr<A>, Expr<B>)> get asQuery => _query;

  /// Filter [QuerySingle] using `WHERE` clause.
  ///
  /// Returns a [QuerySingle] retaining rows from this [QuerySingle] where the expression
  /// returned by [conditionBuilder] evaluates to `true`.
  QuerySingle<(Expr<A>, Expr<B>)> where(
          Expr<bool> Function(Expr<A> a, Expr<B> b) conditionBuilder) =>
      asQuery.where(conditionBuilder).first;

  /// Create a projection of this [QuerySingle] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [QuerySingle] object which doesn't have any methods!
  ///
  /// All methods and properties on [QuerySingle<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  QuerySingle<T> select<T extends Record>(
          T Function(Expr<A> a, Expr<B> b) projectionBuilder) =>
      QuerySingle._(asQuery.select(projectionBuilder));

  /// Query the database for the row matching this [QuerySingle], if any.
  ///
  /// This returns at-most a single row because [QuerySingle] represents a [Query]
  /// containing at-most one row.
  ///
  /// > [!TIP]
  /// > If you don't care about whether or not the row is `null` or not
  /// > present, you can use the convinience method [fetchOrNulls] instead.
  Future<(A, B)?> fetch() async => (await asQuery.fetch()).firstOrNull;

  /// Query the database for the row matching this [QuerySingle], if any.
  ///
  /// > [!WARNING]
  /// > When using this method it is impossible to distinguish between
  /// > a result where all values are `null` and zero rows.
  Future<(A?, B?)> fetchOrNulls() async => await fetch() ?? (null, null);
}

/// Extensions for a query returning at-most one row with
/// 3 expressions.
extension QuerySingle3<A, B, C> on QuerySingle<(Expr<A>, Expr<B>, Expr<C>)> {
  /// Get [Query] with the same rows as this [QuerySingle].
  ///
  /// This returns a [Query] with at-most one row.
  ///
  /// > [!NOTE]
  /// > This is method is only useful for converting a [QuerySingle]
  /// > into a [Query] representation, which can be necessary if you wish to pass
  /// > a [QuerySingle] into a function that only accepts [Query].
  Query<(Expr<A>, Expr<B>, Expr<C>)> get asQuery => _query;

  /// Filter [QuerySingle] using `WHERE` clause.
  ///
  /// Returns a [QuerySingle] retaining rows from this [QuerySingle] where the expression
  /// returned by [conditionBuilder] evaluates to `true`.
  QuerySingle<(Expr<A>, Expr<B>, Expr<C>)> where(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c)
              conditionBuilder) =>
      asQuery.where(conditionBuilder).first;

  /// Create a projection of this [QuerySingle] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [QuerySingle] object which doesn't have any methods!
  ///
  /// All methods and properties on [QuerySingle<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  QuerySingle<T> select<T extends Record>(
          T Function(Expr<A> a, Expr<B> b, Expr<C> c) projectionBuilder) =>
      QuerySingle._(asQuery.select(projectionBuilder));

  /// Query the database for the row matching this [QuerySingle], if any.
  ///
  /// This returns at-most a single row because [QuerySingle] represents a [Query]
  /// containing at-most one row.
  ///
  /// > [!TIP]
  /// > If you don't care about whether or not the row is `null` or not
  /// > present, you can use the convinience method [fetchOrNulls] instead.
  Future<(A, B, C)?> fetch() async => (await asQuery.fetch()).firstOrNull;

  /// Query the database for the row matching this [QuerySingle], if any.
  ///
  /// > [!WARNING]
  /// > When using this method it is impossible to distinguish between
  /// > a result where all values are `null` and zero rows.
  Future<(A?, B?, C?)> fetchOrNulls() async =>
      await fetch() ?? (null, null, null);
}

/// Extensions for a query returning at-most one row with
/// 4 expressions.
extension QuerySingle4<A, B, C, D>
    on QuerySingle<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> {
  /// Get [Query] with the same rows as this [QuerySingle].
  ///
  /// This returns a [Query] with at-most one row.
  ///
  /// > [!NOTE]
  /// > This is method is only useful for converting a [QuerySingle]
  /// > into a [Query] representation, which can be necessary if you wish to pass
  /// > a [QuerySingle] into a function that only accepts [Query].
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> get asQuery => _query;

  /// Filter [QuerySingle] using `WHERE` clause.
  ///
  /// Returns a [QuerySingle] retaining rows from this [QuerySingle] where the expression
  /// returned by [conditionBuilder] evaluates to `true`.
  QuerySingle<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> where(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
              conditionBuilder) =>
      asQuery.where(conditionBuilder).first;

  /// Create a projection of this [QuerySingle] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [QuerySingle] object which doesn't have any methods!
  ///
  /// All methods and properties on [QuerySingle<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  QuerySingle<T> select<T extends Record>(
          T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d)
              projectionBuilder) =>
      QuerySingle._(asQuery.select(projectionBuilder));

  /// Query the database for the row matching this [QuerySingle], if any.
  ///
  /// This returns at-most a single row because [QuerySingle] represents a [Query]
  /// containing at-most one row.
  ///
  /// > [!TIP]
  /// > If you don't care about whether or not the row is `null` or not
  /// > present, you can use the convinience method [fetchOrNulls] instead.
  Future<(A, B, C, D)?> fetch() async => (await asQuery.fetch()).firstOrNull;

  /// Query the database for the row matching this [QuerySingle], if any.
  ///
  /// > [!WARNING]
  /// > When using this method it is impossible to distinguish between
  /// > a result where all values are `null` and zero rows.
  Future<(A?, B?, C?, D?)> fetchOrNulls() async =>
      await fetch() ?? (null, null, null, null);
}

/// Extensions for a query returning at-most one row with
/// 5 expressions.
extension QuerySingle5<A, B, C, D, E>
    on QuerySingle<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> {
  /// Get [Query] with the same rows as this [QuerySingle].
  ///
  /// This returns a [Query] with at-most one row.
  ///
  /// > [!NOTE]
  /// > This is method is only useful for converting a [QuerySingle]
  /// > into a [Query] representation, which can be necessary if you wish to pass
  /// > a [QuerySingle] into a function that only accepts [Query].
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> get asQuery => _query;

  /// Filter [QuerySingle] using `WHERE` clause.
  ///
  /// Returns a [QuerySingle] retaining rows from this [QuerySingle] where the expression
  /// returned by [conditionBuilder] evaluates to `true`.
  QuerySingle<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> where(
          Expr<bool> Function(
                  Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
              conditionBuilder) =>
      asQuery.where(conditionBuilder).first;

  /// Create a projection of this [QuerySingle] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [QuerySingle] object which doesn't have any methods!
  ///
  /// All methods and properties on [QuerySingle<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  QuerySingle<T> select<T extends Record>(
          T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e)
              projectionBuilder) =>
      QuerySingle._(asQuery.select(projectionBuilder));

  /// Query the database for the row matching this [QuerySingle], if any.
  ///
  /// This returns at-most a single row because [QuerySingle] represents a [Query]
  /// containing at-most one row.
  ///
  /// > [!TIP]
  /// > If you don't care about whether or not the row is `null` or not
  /// > present, you can use the convinience method [fetchOrNulls] instead.
  Future<(A, B, C, D, E)?> fetch() async => (await asQuery.fetch()).firstOrNull;

  /// Query the database for the row matching this [QuerySingle], if any.
  ///
  /// > [!WARNING]
  /// > When using this method it is impossible to distinguish between
  /// > a result where all values are `null` and zero rows.
  Future<(A?, B?, C?, D?, E?)> fetchOrNulls() async =>
      await fetch() ?? (null, null, null, null, null);
}

/// Extensions for a query returning at-most one row with
/// 6 expressions.
extension QuerySingle6<A, B, C, D, E, F>
    on QuerySingle<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> {
  /// Get [Query] with the same rows as this [QuerySingle].
  ///
  /// This returns a [Query] with at-most one row.
  ///
  /// > [!NOTE]
  /// > This is method is only useful for converting a [QuerySingle]
  /// > into a [Query] representation, which can be necessary if you wish to pass
  /// > a [QuerySingle] into a function that only accepts [Query].
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> get asQuery =>
      _query;

  /// Filter [QuerySingle] using `WHERE` clause.
  ///
  /// Returns a [QuerySingle] retaining rows from this [QuerySingle] where the expression
  /// returned by [conditionBuilder] evaluates to `true`.
  QuerySingle<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> where(
          Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                  Expr<E> e, Expr<F> f)
              conditionBuilder) =>
      asQuery.where(conditionBuilder).first;

  /// Create a projection of this [QuerySingle] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [QuerySingle] object which doesn't have any methods!
  ///
  /// All methods and properties on [QuerySingle<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  QuerySingle<T> select<T extends Record>(
          T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
                  Expr<F> f)
              projectionBuilder) =>
      QuerySingle._(asQuery.select(projectionBuilder));

  /// Query the database for the row matching this [QuerySingle], if any.
  ///
  /// This returns at-most a single row because [QuerySingle] represents a [Query]
  /// containing at-most one row.
  ///
  /// > [!TIP]
  /// > If you don't care about whether or not the row is `null` or not
  /// > present, you can use the convinience method [fetchOrNulls] instead.
  Future<(A, B, C, D, E, F)?> fetch() async =>
      (await asQuery.fetch()).firstOrNull;

  /// Query the database for the row matching this [QuerySingle], if any.
  ///
  /// > [!WARNING]
  /// > When using this method it is impossible to distinguish between
  /// > a result where all values are `null` and zero rows.
  Future<(A?, B?, C?, D?, E?, F?)> fetchOrNulls() async =>
      await fetch() ?? (null, null, null, null, null, null);
}

/// Extensions for a query returning at-most one row with
/// 7 expressions.
extension QuerySingle7<A, B, C, D, E, F, G> on QuerySingle<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> {
  /// Get [Query] with the same rows as this [QuerySingle].
  ///
  /// This returns a [Query] with at-most one row.
  ///
  /// > [!NOTE]
  /// > This is method is only useful for converting a [QuerySingle]
  /// > into a [Query] representation, which can be necessary if you wish to pass
  /// > a [QuerySingle] into a function that only accepts [Query].
  Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
      get asQuery => _query;

  /// Filter [QuerySingle] using `WHERE` clause.
  ///
  /// Returns a [QuerySingle] retaining rows from this [QuerySingle] where the expression
  /// returned by [conditionBuilder] evaluates to `true`.
  QuerySingle<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)>
      where(
              Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d,
                      Expr<E> e, Expr<F> f, Expr<G> g)
                  conditionBuilder) =>
          asQuery.where(conditionBuilder).first;

  /// Create a projection of this [QuerySingle] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [QuerySingle] object which doesn't have any methods!
  ///
  /// All methods and properties on [QuerySingle<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  QuerySingle<T> select<T extends Record>(
          T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
                  Expr<F> f, Expr<G> g)
              projectionBuilder) =>
      QuerySingle._(asQuery.select(projectionBuilder));

  /// Query the database for the row matching this [QuerySingle], if any.
  ///
  /// This returns at-most a single row because [QuerySingle] represents a [Query]
  /// containing at-most one row.
  ///
  /// > [!TIP]
  /// > If you don't care about whether or not the row is `null` or not
  /// > present, you can use the convinience method [fetchOrNulls] instead.
  Future<(A, B, C, D, E, F, G)?> fetch() async =>
      (await asQuery.fetch()).firstOrNull;

  /// Query the database for the row matching this [QuerySingle], if any.
  ///
  /// > [!WARNING]
  /// > When using this method it is impossible to distinguish between
  /// > a result where all values are `null` and zero rows.
  Future<(A?, B?, C?, D?, E?, F?, G?)> fetchOrNulls() async =>
      await fetch() ?? (null, null, null, null, null, null, null);
}

/// Extensions for a query returning at-most one row with
/// 8 expressions.
extension QuerySingle8<A, B, C, D, E, F, G, H> on QuerySingle<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)> {
  /// Get [Query] with the same rows as this [QuerySingle].
  ///
  /// This returns a [Query] with at-most one row.
  ///
  /// > [!NOTE]
  /// > This is method is only useful for converting a [QuerySingle]
  /// > into a [Query] representation, which can be necessary if you wish to pass
  /// > a [QuerySingle] into a function that only accepts [Query].
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

  /// Filter [QuerySingle] using `WHERE` clause.
  ///
  /// Returns a [QuerySingle] retaining rows from this [QuerySingle] where the expression
  /// returned by [conditionBuilder] evaluates to `true`.
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

  /// Create a projection of this [QuerySingle] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [QuerySingle] object which doesn't have any methods!
  ///
  /// All methods and properties on [QuerySingle<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  QuerySingle<T> select<T extends Record>(
          T Function(Expr<A> a, Expr<B> b, Expr<C> c, Expr<D> d, Expr<E> e,
                  Expr<F> f, Expr<G> g, Expr<H> h)
              projectionBuilder) =>
      QuerySingle._(asQuery.select(projectionBuilder));

  /// Query the database for the row matching this [QuerySingle], if any.
  ///
  /// This returns at-most a single row because [QuerySingle] represents a [Query]
  /// containing at-most one row.
  ///
  /// > [!TIP]
  /// > If you don't care about whether or not the row is `null` or not
  /// > present, you can use the convinience method [fetchOrNulls] instead.
  Future<(A, B, C, D, E, F, G, H)?> fetch() async =>
      (await asQuery.fetch()).firstOrNull;

  /// Query the database for the row matching this [QuerySingle], if any.
  ///
  /// > [!WARNING]
  /// > When using this method it is impossible to distinguish between
  /// > a result where all values are `null` and zero rows.
  Future<(A?, B?, C?, D?, E?, F?, G?, H?)> fetchOrNulls() async =>
      await fetch() ?? (null, null, null, null, null, null, null, null);
}

/// Extension methods for a statement returning zero or more rows with
/// 1 expression.
extension Return1<A> on Return<(Expr<A>,)> {
  /// Execute this statement and return the output as a [Stream].
  Stream<A> executeAndStream() async* {
    final (sql, params) = _render(_expressions.toList());
    await for (final r in _context._query(sql, params)) {
      yield _expressions.$1._decode(r) as A;
    }
  }

  /// Execute this statement and return the output as a [List].
  Future<List<A>> executeAndFetch() async => await executeAndStream().toList();
}

/// Extension methods for a statement returning at-most one row with
/// 1 expression.
extension ReturnSingle1<A> on ReturnSingle<(Expr<A>,)> {
  /// Execute this statement and return the output.
  Future<A?> executeAndFetch() async =>
      (await _return.executeAndFetch()).firstOrNull;
}

/// Extension methods for a statement returning exactly one row with
/// 1 expression.
extension ReturnOne1<A> on ReturnOne<(Expr<A>,)> {
  /// Execute this statement and return the output.
  Future<A> executeAndFetch() async => (await _return.executeAndFetch()).first;
}

/// Extension methods for a statement returning zero or more rows with
/// 2 expressions.
extension Return2<A, B> on Return<(Expr<A>, Expr<B>)> {
  /// Execute this statement and return the output as a [Stream].
  Stream<(A, B)> executeAndStream() async* {
    final (sql, params) = _render(_expressions.toList());
    await for (final r in _context._query(sql, params)) {
      yield (_expressions.$1._decode(r) as A, _expressions.$2._decode(r) as B);
    }
  }

  /// Execute this statement and return the output as a [List].
  Future<List<(A, B)>> executeAndFetch() async =>
      await executeAndStream().toList();
}

/// Extension methods for a statement returning at-most one row with
/// 2 expressions.
extension ReturnSingle2<A, B> on ReturnSingle<(Expr<A>, Expr<B>)> {
  /// Execute this statement and return the output.
  Future<(A, B)?> executeAndFetch() async =>
      (await _return.executeAndFetch()).firstOrNull;

  /// Execute this statement and return the output.
  Future<(A?, B?)> executeAndFetchOrNulls() async =>
      await executeAndFetch() ?? (null, null);
}

/// Extension methods for a statement returning exactly one row with
/// 2 expressions.
extension ReturnOne2<A, B> on ReturnOne<(Expr<A>, Expr<B>)> {
  /// Execute this statement and return the output.
  Future<(A, B)> executeAndFetch() async =>
      (await _return.executeAndFetch()).first;
}

/// Extension methods for a statement returning zero or more rows with
/// 3 expressions.
extension Return3<A, B, C> on Return<(Expr<A>, Expr<B>, Expr<C>)> {
  /// Execute this statement and return the output as a [Stream].
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

  /// Execute this statement and return the output as a [List].
  Future<List<(A, B, C)>> executeAndFetch() async =>
      await executeAndStream().toList();
}

/// Extension methods for a statement returning at-most one row with
/// 3 expressions.
extension ReturnSingle3<A, B, C> on ReturnSingle<(Expr<A>, Expr<B>, Expr<C>)> {
  /// Execute this statement and return the output.
  Future<(A, B, C)?> executeAndFetch() async =>
      (await _return.executeAndFetch()).firstOrNull;

  /// Execute this statement and return the output.
  Future<(A?, B?, C?)> executeAndFetchOrNulls() async =>
      await executeAndFetch() ?? (null, null, null);
}

/// Extension methods for a statement returning exactly one row with
/// 3 expressions.
extension ReturnOne3<A, B, C> on ReturnOne<(Expr<A>, Expr<B>, Expr<C>)> {
  /// Execute this statement and return the output.
  Future<(A, B, C)> executeAndFetch() async =>
      (await _return.executeAndFetch()).first;
}

/// Extension methods for a statement returning zero or more rows with
/// 4 expressions.
extension Return4<A, B, C, D> on Return<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> {
  /// Execute this statement and return the output as a [Stream].
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

  /// Execute this statement and return the output as a [List].
  Future<List<(A, B, C, D)>> executeAndFetch() async =>
      await executeAndStream().toList();
}

/// Extension methods for a statement returning at-most one row with
/// 4 expressions.
extension ReturnSingle4<A, B, C, D>
    on ReturnSingle<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> {
  /// Execute this statement and return the output.
  Future<(A, B, C, D)?> executeAndFetch() async =>
      (await _return.executeAndFetch()).firstOrNull;

  /// Execute this statement and return the output.
  Future<(A?, B?, C?, D?)> executeAndFetchOrNulls() async =>
      await executeAndFetch() ?? (null, null, null, null);
}

/// Extension methods for a statement returning exactly one row with
/// 4 expressions.
extension ReturnOne4<A, B, C, D>
    on ReturnOne<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)> {
  /// Execute this statement and return the output.
  Future<(A, B, C, D)> executeAndFetch() async =>
      (await _return.executeAndFetch()).first;
}

/// Extension methods for a statement returning zero or more rows with
/// 5 expressions.
extension Return5<A, B, C, D, E>
    on Return<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> {
  /// Execute this statement and return the output as a [Stream].
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

  /// Execute this statement and return the output as a [List].
  Future<List<(A, B, C, D, E)>> executeAndFetch() async =>
      await executeAndStream().toList();
}

/// Extension methods for a statement returning at-most one row with
/// 5 expressions.
extension ReturnSingle5<A, B, C, D, E>
    on ReturnSingle<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> {
  /// Execute this statement and return the output.
  Future<(A, B, C, D, E)?> executeAndFetch() async =>
      (await _return.executeAndFetch()).firstOrNull;

  /// Execute this statement and return the output.
  Future<(A?, B?, C?, D?, E?)> executeAndFetchOrNulls() async =>
      await executeAndFetch() ?? (null, null, null, null, null);
}

/// Extension methods for a statement returning exactly one row with
/// 5 expressions.
extension ReturnOne5<A, B, C, D, E>
    on ReturnOne<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>)> {
  /// Execute this statement and return the output.
  Future<(A, B, C, D, E)> executeAndFetch() async =>
      (await _return.executeAndFetch()).first;
}

/// Extension methods for a statement returning zero or more rows with
/// 6 expressions.
extension Return6<A, B, C, D, E, F>
    on Return<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> {
  /// Execute this statement and return the output as a [Stream].
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

  /// Execute this statement and return the output as a [List].
  Future<List<(A, B, C, D, E, F)>> executeAndFetch() async =>
      await executeAndStream().toList();
}

/// Extension methods for a statement returning at-most one row with
/// 6 expressions.
extension ReturnSingle6<A, B, C, D, E, F>
    on ReturnSingle<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> {
  /// Execute this statement and return the output.
  Future<(A, B, C, D, E, F)?> executeAndFetch() async =>
      (await _return.executeAndFetch()).firstOrNull;

  /// Execute this statement and return the output.
  Future<(A?, B?, C?, D?, E?, F?)> executeAndFetchOrNulls() async =>
      await executeAndFetch() ?? (null, null, null, null, null, null);
}

/// Extension methods for a statement returning exactly one row with
/// 6 expressions.
extension ReturnOne6<A, B, C, D, E, F>
    on ReturnOne<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>)> {
  /// Execute this statement and return the output.
  Future<(A, B, C, D, E, F)> executeAndFetch() async =>
      (await _return.executeAndFetch()).first;
}

/// Extension methods for a statement returning zero or more rows with
/// 7 expressions.
extension Return7<A, B, C, D, E, F, G>
    on Return<(Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> {
  /// Execute this statement and return the output as a [Stream].
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

  /// Execute this statement and return the output as a [List].
  Future<List<(A, B, C, D, E, F, G)>> executeAndFetch() async =>
      await executeAndStream().toList();
}

/// Extension methods for a statement returning at-most one row with
/// 7 expressions.
extension ReturnSingle7<A, B, C, D, E, F, G> on ReturnSingle<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> {
  /// Execute this statement and return the output.
  Future<(A, B, C, D, E, F, G)?> executeAndFetch() async =>
      (await _return.executeAndFetch()).firstOrNull;

  /// Execute this statement and return the output.
  Future<(A?, B?, C?, D?, E?, F?, G?)> executeAndFetchOrNulls() async =>
      await executeAndFetch() ?? (null, null, null, null, null, null, null);
}

/// Extension methods for a statement returning exactly one row with
/// 7 expressions.
extension ReturnOne7<A, B, C, D, E, F, G> on ReturnOne<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>)> {
  /// Execute this statement and return the output.
  Future<(A, B, C, D, E, F, G)> executeAndFetch() async =>
      (await _return.executeAndFetch()).first;
}

/// Extension methods for a statement returning zero or more rows with
/// 8 expressions.
extension Return8<A, B, C, D, E, F, G, H> on Return<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)> {
  /// Execute this statement and return the output as a [Stream].
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

  /// Execute this statement and return the output as a [List].
  Future<List<(A, B, C, D, E, F, G, H)>> executeAndFetch() async =>
      await executeAndStream().toList();
}

/// Extension methods for a statement returning at-most one row with
/// 8 expressions.
extension ReturnSingle8<A, B, C, D, E, F, G, H> on ReturnSingle<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)> {
  /// Execute this statement and return the output.
  Future<(A, B, C, D, E, F, G, H)?> executeAndFetch() async =>
      (await _return.executeAndFetch()).firstOrNull;

  /// Execute this statement and return the output.
  Future<(A?, B?, C?, D?, E?, F?, G?, H?)> executeAndFetchOrNulls() async =>
      await executeAndFetch() ??
      (null, null, null, null, null, null, null, null);
}

/// Extension methods for a statement returning exactly one row with
/// 8 expressions.
extension ReturnOne8<A, B, C, D, E, F, G, H> on ReturnOne<
    (Expr<A>, Expr<B>, Expr<C>, Expr<D>, Expr<E>, Expr<F>, Expr<G>, Expr<H>)> {
  /// Execute this statement and return the output.
  Future<(A, B, C, D, E, F, G, H)> executeAndFetch() async =>
      (await _return.executeAndFetch()).first;
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
