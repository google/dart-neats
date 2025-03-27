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

sealed class DatabaseContext<T extends Schema> {
  // TODO: Consider if DatabaseContext is necessary, perhaps using
  //       the Database object directly is fine. We just need .fetch/.execute
  //       to call _executor right when they are doing the actual queries!
  DatabaseContext._(this._dialect);

  final SqlDialect _dialect;
  Executor get _executor;

  Stream<RowReader> _query(String sql, List<Object?> params) =>
      _executor.query(sql, params);
}

/// {@category Schema definition}
/// {@category Inserting rows}
/// {@category Writing queries}
/// {@category Update and delete}
/// {@category Foreign keys}
/// {@category Joins}
/// {@category Aggregate functions}
/// {@category Transactions}
/// {@category Exception handling}
/// {@category Custom data types}
/// {@category Migrations}
/// {@category Testing}
final class Database<T extends Schema> extends DatabaseContext<T> {
  Database(DatabaseAdaptor adaptor, super.dialect)
      : _adaptor = adaptor,
        super._();

  final DatabaseAdaptor _adaptor;

  late final _zoneKey = (this, #_transaction);

  @override
  Executor get _executor => Zone.current[_zoneKey] as Executor? ?? _adaptor;

  Future<R> transact<R>(
    Future<R> Function() fn,
  ) async {
    return await _executor.transact((tx) async {
      return await runZoned(fn, zoneValues: {
        _zoneKey: tx,
      });
    });
  }

  QuerySingle<S> select<S extends Record>(S expressions) =>
      QuerySingle._(_Query(this, expressions, SelectClause._));
}
