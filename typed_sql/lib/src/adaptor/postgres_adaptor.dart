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
import 'dart:typed_data' show Uint8List;

import 'package:postgres/postgres.dart';

import 'adaptor.dart';

DatabaseAdaptor postgresAdaptor(Pool<void> pool) =>
    _PostgresDatabaseAdaptor(pool);

mixin _QueryExecutor<S extends Session> {
  S get _session;

  Future<QueryResult> execute(String sql, List<Object?> params) async {
    final rs = await _session.execute(
      sql,
      parameters: _paramsForPostgres(params),
    );
    return QueryResult(
      affectedRows: rs.affectedRows,
      rows: rs.map(_PostgresRowReader.new).toList(),
    );
  }

  Stream<RowReader> query(String sql, List<Object?> params) async* {
    final rs = await _session.execute(
      sql,
      parameters: _paramsForPostgres(params),
      queryMode: QueryMode.extended,
    );
    yield* Stream.fromIterable(rs.map(_PostgresRowReader.new));
    // TODO: Explore why streaming mode doesn't work
    // final ps = await _session.prepare(sql);
    // yield* ps.bind(params).map(_PostgresRowReader.new);
  }

  Future<void> script(String sql) async {
    await _session.execute(sql, queryMode: QueryMode.simple);
  }
}

final class _PostgresDatabaseAdaptor extends DatabaseAdaptor
    with _QueryExecutor<Pool<void>> {
  @override
  final Pool _session;

  _PostgresDatabaseAdaptor(this._session);

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

final class _DatabaseTransaction extends DatabaseTransaction
    with _QueryExecutor<TxSession> {
  @override
  final TxSession _session;

  _DatabaseTransaction(this._session);

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
    final value = _row[_i++];
    if (value is String) {
      // No idea why postgres sometimes return dates as strings.
      // Maybe, it does this only for literal values, because it can't infer
      // the type as a date.
      return DateTime.parse(value);
    }
    return value as DateTime?;
  }

  @override
  double? readDouble() {
    final value = _row[_i++];
    if (value is String) {
      // No idea why postgres sometimes return doubles as strings.
      // Maybe, it does this only for literal values, because they could be more
      // than 64 bits!
      return double.parse(value);
    }
    return value as double?;
  }

  @override
  int? readInt() {
    final value = _row[_i++];
    if (value is String) {
      // No idea why postgres sometimes return integers as strings.
      // Maybe, it does this only for literal values, because they could be more
      // than 64 bits!
      return int.parse(value);
    }
    return value as int?;
  }

  @override
  String? readString() {
    return _row[_i++] as String?;
  }

  @override
  Uint8List? readUint8List() {
    final value = _row[_i++];
    if (value == null) {
      return null;
    }
    return value as Uint8List;
  }

  @override
  bool tryReadNull() {
    if (_row[_i] == null) {
      _i++;
      return true;
    }
    return false;
  }
}

List<Object?> _paramsForPostgres(List<Object?> params) => params
    .map((p) => switch (p) {
          DateTime d => d.toIso8601String(),
          String s => s,
          null => null,
          bool b => b,
          int i => i,
          double d => d,
          Uint8List u => TypedValue(Type.byteArray, u, isSqlNull: false),
          _ => throw UnsupportedError('Unsupported type: ${p.runtimeType}'),
        })
    .toList();
