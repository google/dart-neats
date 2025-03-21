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

final class _PostgresDatabaseAdaptor extends DatabaseAdaptor {
  final Pool<void> _session;
  var _closed = false;
  // TODO: Support closing state where new transactions / queries can't be started!
  //       existing transactions and queries may continue running.
  int _savePointIndex = 0;

  _PostgresDatabaseAdaptor(this._session);

  void _throwIfClosed() {
    if (_closed) {
      throw StateError('DatabaseAdaptor is closed!');
    }
  }

  @override
  Future<T> transact<T>(Future<T> Function(DatabaseTransaction tx) fn) async {
    _throwIfClosed();

    try {
      return await _session.withConnection((conn) async {
        try {
          await conn.execute('BEGIN');
        } on PgException catch (e) {
          _throwPostgresException(e);
        }
        try {
          final tx = _DatabaseTransaction(conn, this);
          final T value;
          try {
            value = await fn(tx);
          } finally {
            tx._closed = true;
          }
          await conn.execute('COMMIT');
          return value;
        } on PgException catch (e) {
          // TODO: Find out what exception postgres might throw and only catch
          //       those!
          await conn.execute('ROLLBACK');
          _throwPostgresException(e);
        }
      });
    } on PgException catch (e) {
      _throwPostgresException(e);
    }
  }

  @override
  Future<QueryResult> execute(String sql, List<Object?> params) async {
    _throwIfClosed();
    try {
      final rs = await _session.execute(
        sql,
        parameters: _paramsForPostgres(params),
      );
      return QueryResult(affectedRows: rs.affectedRows);
    } on PgException catch (e) {
      _throwPostgresException(e);
    }
  }

  @override
  Stream<RowReader> query(String sql, List<Object?> params) async* {
    _throwIfClosed();
    try {
      final rs = await _session.execute(
        sql,
        parameters: _paramsForPostgres(params),
        queryMode: QueryMode.extended,
      );
      yield* Stream.fromIterable(rs.map(_PostgresRowReader.new));
    } on PgException catch (e) {
      _throwPostgresException(e);
    }
    // TODO: Explore why streaming mode doesn't work
    // final ps = await _session.prepare(sql);
    // yield* ps.bind(params).map(_PostgresRowReader.new);
  }

  @override
  Future<void> script(String sql) async {
    _throwIfClosed();
    try {
      await _session.execute(sql, queryMode: QueryMode.simple);
    } on PgException catch (e) {
      _throwPostgresException(e);
    }
  }

  @override
  Future<void> close({bool force = false}) async {
    await _session.close(force: force);
    _closed = true;
  }
}

final class _DatabaseTransaction extends DatabaseTransaction {
  final _PostgresDatabaseAdaptor _adaptor;
  final Session _session;
  var _closed = false;
  var _activeSubtransaction = false;

  _DatabaseTransaction(this._session, this._adaptor);

  void _throwIfBlocked() {
    _adaptor._throwIfClosed();
    if (_closed) {
      throw StateError('Transaction is closed!');
    }
    if (_activeSubtransaction) {
      throw StateError('Nested transaction is in progress!');
    }
  }

  @override
  Future<QueryResult> execute(String sql, List<Object?> params) async {
    _throwIfBlocked();
    try {
      final rs = await _session.execute(
        sql,
        parameters: _paramsForPostgres(params),
      );
      return QueryResult(affectedRows: rs.affectedRows);
    } on PgException catch (e) {
      _throwPostgresException(e);
    }
  }

  @override
  Stream<RowReader> query(String sql, List<Object?> params) async* {
    _throwIfBlocked();
    try {
      final rs = await _session.execute(
        sql,
        parameters: _paramsForPostgres(params),
        queryMode: QueryMode.extended,
      );
      yield* Stream.fromIterable(rs.map(_PostgresRowReader.new));
    } on PgException catch (e) {
      _throwPostgresException(e);
    }
    // TODO: Explore why streaming mode doesn't work
    // final ps = await _session.prepare(sql);
    // yield* ps.bind(params).map(_PostgresRowReader.new);
  }

  @override
  Future<void> script(String sql) async {
    _throwIfBlocked();
    try {
      await _session.execute(sql, queryMode: QueryMode.simple);
    } on PgException catch (e) {
      _throwPostgresException(e);
    }
  }

  @override
  Future<T> transact<T>(Future<T> Function(_DatabaseTransaction sp) fn) async {
    _throwIfBlocked();

    final sp = 'sp_${_adaptor._savePointIndex++}';
    try {
      _activeSubtransaction = true;
      try {
        await _session.execute('SAVEPOINT "$sp"');
      } on PgException catch (e) {
        _throwPostgresException(e);
      }
      try {
        final tx = _DatabaseTransaction(_session, _adaptor);
        final T value;
        try {
          value = await fn(tx);
        } finally {
          tx._closed = true;
        }
        await _session.execute('RELEASE "$sp"');
        return value;
      } on Exception {
        try {
          await _session.execute('ROLLBACK TO "$sp"');
        } on PgException catch (e) {
          // TODO: throw an exception that shouldn't be caught by the user!
          _throwPostgresException(e);
        }
        rethrow;
      }
    } finally {
      _activeSubtransaction = false;
    }
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

// TODO: Fix all the places that calls this method, this was just thrown together!
Never _throwPostgresException(PgException e) {
  // TODO: Separate error code into:
  //  - Temporary I/O error
  //  - Permanent database connection error (configuration issue)
  //  - Query issue
  //  - Transaction conflict!
  // NOTICE: that conflicts often happen as soon as offending statement is
  //         executed, conflicts don't just happen on COMMIT. They can and often
  //         do happen much sooner!

  switch (e) {
    case ServerException e:
      throw PostgresQueryException._(e);

    default:
      throw UnsupportedError('exception handling is missing: $e');
  }
}

final class PostgresQueryException extends DatabaseQueryException {
  final ServerException e;

  PostgresQueryException._(this.e);

  @override
  String toString() => 'DatabaseQueryException(${e.toString()})';
}

final class PostgresTransactionAbortedException
    extends DatabaseTransactionAbortedException {
  PostgresTransactionAbortedException._(this.e);

  final ServerException e;

  @override
  String toString() => 'DatabaseTransactionAbortedException(${e.toString()})';
}
