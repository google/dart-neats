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

/// {@category schema}
/// {@category foreign_keys}
/// {@category inserting_rows}
/// {@category writing_queries}
/// {@category update_and_delete}
/// {@category joins}
/// {@category aggregate_functions}
/// {@category transactions}
/// {@category exceptions}
/// {@category custom_data_types}
/// {@category migrations}
/// {@category testing}
final class Database<T extends Schema> {
  Database(DatabaseAdaptor adaptor, SqlDialect dialect)
      : _adaptor = adaptor,
        _dialect = dialect;

  final SqlDialect _dialect;
  final DatabaseAdaptor _adaptor;

  late final _zoneKey = (this, #_transaction);

  Executor get _executor => Zone.current[_zoneKey] as Executor? ?? _adaptor;

  /// Start a transaction an execute [fn] in a [Zone] where all operations on
  /// this [Database] happens in the transaction.
  ///
  /// When [fn] completes the transaction will be committed. If [fn] throws an
  /// [Exception] then the transaction will be rolled back, and the call to
  /// [transact] will throw an [TransactionAbortedException].
  ///
  /// Inside the transaction [Zone] result streams will not respect
  /// back-pressure. This means that all rows may be buffered in memory!
  /// Avoid scanning large result sets inside the transaction.
  ///
  /// Using [transact] inside a transaction will create `SAVEPOINT` in SQL.
  ///
  /// > [!WARNING]
  /// > All database operations inside [fn] **must be awaited**. When [fn]
  /// > returns the transaction will be committed or rolledback, further
  /// > operations inside the transaction [Zone] will throw!
  /// >
  /// > Avoid using [unawaited] and [scheduleMicrotask] inside [fn].
  Future<R> transact<R>(
    Future<R> Function() fn,
  ) async {
    return await _executor.transact((tx) async {
      return await runZoned(fn, zoneValues: {
        _zoneKey: tx,
      });
    });
  }

  Stream<RowReader> _query(String sql, List<Object?> params) =>
      _executor.query(sql, params);

  /// Create a [QuerySingle] that evaluates [expressions].
  ///
  /// Returns a [QuerySingle] with exactly one row.
  ///
  /// The values in [expressions] **must** be [Expr] objects. If you pass any
  /// other record as [expressions], there will be no `.fetch()`
  /// _extension method_ for fetching results.
  ///
  /// This can be useful for evaluating multiple point-queries in a single
  /// database query.
  QuerySingle<S> select<S extends Record>(S expressions) =>
      QuerySingle._(Query._(this, expressions, SelectClause._));
}
