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

import 'adaptor.dart';

DatabaseAdaptor loggingAdaptor(
  DatabaseAdaptor adaptor,
  void Function(String message) logDrain,
) =>
    _LoggingDatabaseAdaptor(adaptor, logDrain);

final class _LoggingDatabaseAdaptor extends DatabaseAdaptor {
  final DatabaseAdaptor _adaptor;
  final void Function(String message) _log;

  _LoggingDatabaseAdaptor(this._adaptor, this._log);

  @override
  Future<void> close({bool force = false}) async {
    _log('db.close(force: $force)');
    await _adaptor.close(force: force);
  }

  @override
  Stream<RowReader> query(String sql, List<Object?> params) async* {
    _log('db.query("$sql", [${params.join(', ')}])');
    yield* _adaptor.query(sql, params);
  }

  @override
  Future<QueryResult> execute(String sql, List<Object?> params) async {
    _log('db.execute("$sql", [${params.join(', ')}])');
    return await _adaptor.execute(sql, params);
  }

  @override
  Future<void> script(String sql) {
    _log('db.script("$sql")');
    return _adaptor.script(sql);
  }

  @override
  Future<T> transact<T>(Future<T> Function(QueryExecutor tx) fn) async {
    _log('db.transact()');
    return await _adaptor.transact((tx) async {
      return await fn(_LoggingDatabaseTransaction(tx, _log));
    });
  }
}

final class _LoggingDatabaseTransaction extends DatabaseTransaction {
  final QueryExecutor _tx;
  final void Function(String message) _log;

  _LoggingDatabaseTransaction(this._tx, this._log);

  @override
  Stream<RowReader> query(String sql, List<Object?> params) async* {
    _log('tx.query("$sql", [${params.join(', ')}])');
    yield* _tx.query(sql, params);
  }

  @override
  Future<QueryResult> execute(String sql, List<Object?> params) async {
    _log('tx.execute("$sql", [${params.join(', ')}])');
    return await _tx.execute(sql, params);
  }

  @override
  Future<void> script(String sql) {
    _log('tx.script("$sql")');
    return _tx.script(sql);
  }

  @override
  Future<T> transact<T>(Future<T> Function(QueryExecutor tx) fn) async {
    _log('tx.transact()');
    return await _tx.transact((sp) async {
      return await fn(_LoggingDatabaseTransaction(sp, _log));
    });
  }
}
