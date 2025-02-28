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

import 'dart:async';

import 'package:postgres/postgres.dart';

import 'adaptor.dart';

DatabaseAdaptor postgresAdaptor(Pool pool) => _PostgresDatabaseAdaptor(pool);

class _QueryExecutor<S extends Session> extends QueryExecutor {
  final S _session;

  _QueryExecutor(this._session);

  @override
  Future<QueryResult> execute(String sql, List<Object?> params) async {
    final rs = await _session.execute(sql, parameters: params);
    return QueryResult(
      affectedRows: rs.affectedRows,
      rows: rs.map(_PostgresRowReader.new).toList(),
    );
  }

  @override
  Stream<RowReader> query(String sql, List<Object?> params) async* {
    final ps = await _session.prepare(sql);
    yield* ps.bind(params).map(_PostgresRowReader.new);
  }

  @override
  Future<void> script(String sql) async {
    await _session.execute(sql, queryMode: QueryMode.simple);
  }
}

final class _PostgresDatabaseAdaptor extends _QueryExecutor<Pool>
    implements DatabaseAdaptor {
  _PostgresDatabaseAdaptor(super._session);

  @override
  Future<T> transaction<T>(
      Future<T> Function(DatabaseTransaction tx) fn) async {
    return await _session.runTx((tx) async {
      return await fn(_DatabaseTransaction(tx));
    });
  }

  @override
  Future<void> close({bool force = false}) async {
    await _session.close(force: force);
  }
}

class _DatabaseTransaction extends _QueryExecutor<TxSession>
    implements DatabaseTransaction {
  _DatabaseTransaction(super._session);

  @override
  Future<T> savePoint<T>(Future<T> Function(DatabaseSavePoint sp) fn) {
    throw UnimplementedError();
  }
}

final class _PostgresRowReader extends RowReader {
  int _i = 0;
  final ResultRow _row;

  _PostgresRowReader(this._row);

  @override
  bool? readBool() {
    return _row[_i++] as bool?;
  }

  @override
  DateTime? readDateTime() {
    return _row[_i++] as DateTime?;
  }

  @override
  double? readDouble() {
    return _row[_i++] as double?;
  }

  @override
  int? readInt() {
    return _row[_i++] as int?;
  }

  @override
  String? readString() {
    return _row[_i++] as String?;
  }
}
