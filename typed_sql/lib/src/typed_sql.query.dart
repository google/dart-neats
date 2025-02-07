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

sealed class Query<T> {}

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
sealed class QuerySingle<T> {}

final class _Query<T> extends Query<T> {
  final Table<T> _table;
  final int _limit; // -1, if there is no limit
  final int _offset;
  final Expr<bool> _where; // default to True
  final ({bool descending, Expr term})? _orderBy; // default to null

  _Query(
    this._table, {
    int? limit,
    int? offset,
    Expr<bool>? where,
    ({bool descending, Expr term})? orderBy,
  })  : _limit = limit ?? -1,
        _offset = offset ?? 0,
        _where = where ?? Literal(true),
        _orderBy = orderBy;

  /// Create a [_Query] with updated properties
  _Query<T> _update({
    int? limit,
    int? offset,
    Expr<bool>? where,
    ({bool descending, Expr term})? orderBy,
  }) =>
      _Query(
        _table,
        limit: switch (limit) {
          null => _limit,
          -1 => _limit,
          int limit when (_limit != -1) => math.min(limit, _limit),
          int limit => limit,
        },
        offset: _offset + (offset ?? 0),
        where: where?.and(_where) ?? _where,
        orderBy: orderBy ?? _orderBy,
      );
}

final class _QuerySingle<T> extends QuerySingle<T> {
  final _Query<T> _query;
  _QuerySingle(this._query);
}

extension QueryClauses<T> on Query<T> {
  _Query<T> _query() => switch (this) {
        final Table<T> table => _Query(table),
        final _Query<T> query => query,
      };

  Query<T> offset(int offset) {
    if (offset < 0) {
      throw ArgumentError.value(offset, 'offset', 'cannot be negative');
    }

    return _query()._update(offset: offset);
  }

  Query<T> limit(int limit) {
    if (limit < 0) {
      throw ArgumentError.value(limit, 'limit', 'cannot be negative');
    }

    return _query()._update(limit: limit);
  }

  QuerySingle<T> get first => _QuerySingle(_query()._update(limit: 1));

  /// Fetch rows from this query, use `.fetch().toList()` to get a
  /// `Future<List<T>>`.
  Stream<T> fetch() async* {
    final q = _query();

    final (sql, params) = q._table._context._dialect.selectFrom(
      q._table._tableName,
      _tableAliasName,
      q._table._columns,
      q._limit,
      q._offset,
      q._where,
      q._orderBy,
    );

    await for (final row in q._table._context._query(sql, params)) {
      yield q._table._deserialize((i) => row[i]);
    }
  }
}

extension QuerySingleClauses<T> on QuerySingle<T> {
  Query<T> get asQuery => switch (this) {
        final _QuerySingle<T> query => query._query,
      };

  Future<T?> fetch() async => (await asQuery.fetch().toList()).firstOrNull;
}

extension QueryModelClauses<T extends Model> on Query<T> {
  /// Delete rows selected by this query.
  ///
  /// This will not delete any included references, these can only be used to
  /// filter the rows to be deleted.
  Future<void> deleteAll() async {
    final q = _query();

    final (sql, params) = q._table._context._dialect.deleteFrom(
      q._table._tableName,
      _tableAliasName,
      q._limit,
      q._offset,
      q._where,
      q._orderBy,
    );

    await q._table._context._query(sql, params).drain();
  }
}

extension QuerySingleModelClauses<T extends Model> on QuerySingle<T> {
  /// Delete rows selected by this query.
  ///
  /// This will not delete any included references, these can only be used to
  /// filter the rows to be deleted.
  Future<void> delete() => asQuery.deleteAll();
}
