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

import 'package:sqlite3/sqlite3.dart';

import '../src/utils/notifier.dart';
import 'adaptor.dart';

DatabaseAdaptor sqlite3Adaptor(Uri uri) => _SqliteDatabaseAdaptor(uri);

final class _SqliteDatabaseAdaptor extends DatabaseAdaptor {
  final Uri _uri;
  final int _maxConnections = 10;

  _SqliteDatabaseAdaptor(this._uri);

  bool _closing = false;
  bool _closed = false;
  int _pendingConnectionRequests = 0;
  final _connections = <Database>[];
  final _idleConnections = <Database>[];
  final _stateChanged = Notifier();
  int _savePointIndex = 0;

  Database _createConnection() => sqlite3.open(
        _uri.toString(),
        uri: true,
        mutex: true, // playing it safe for now!
      );

  void _throwIfClosed() {
    if (_closed) {
      throw StateError('DatabaseAdaptor is closed!');
    }
  }

  Future<Database> _getConnection() async {
    _throwIfClosed();
    if (_closing) {
      // Do not allow new requests for connections while closing.
      throw StateError('DatabaseAdaptor is closing!');
    }

    _pendingConnectionRequests++;
    try {
      while (_idleConnections.isEmpty) {
        if (_connections.length < _maxConnections) {
          final db = _createConnection();
          _connections.add(db);
          return db;
        }
        await _stateChanged.wait;
        // If force closed while pending, then we throw!
        _throwIfClosed();
      }
      return _idleConnections.removeLast();
    } finally {
      _pendingConnectionRequests--;
      _stateChanged.notify();
    }
  }

  void _releaseConnection(Database conn) {
    _idleConnections.add(conn);
    _stateChanged.notify();
  }

  @override
  Future<void> close({bool force = false}) async {
    if (_closed) {
      return;
    }

    if (force) {
      for (final conn in _connections) {
        conn.dispose();
      }
      _connections.clear();
      _idleConnections.clear();
      _closed = true;
      _stateChanged.notify();
      return;
    }

    _closing = true;

    // Wait gracefully for all connections to be closed
    while (_connections.isNotEmpty || _pendingConnectionRequests > 0) {
      if (_pendingConnectionRequests == 0 && _idleConnections.isNotEmpty) {
        for (final conn in _idleConnections) {
          _connections.remove(conn);
          conn.dispose();
        }
        _idleConnections.clear();
        _stateChanged.notify();
      } else {
        await _stateChanged.wait;
      }
    }
    _closed = true;
    _stateChanged.notify();
  }

  @override
  Stream<RowReader> query(String sql, List<Object?> params) async* {
    final conn = await _getConnection();
    try {
      yield* _query(conn, sql, params);
    } finally {
      _releaseConnection(conn);
    }
  }

  Stream<RowReader> _query(
    Database conn,
    String sql,
    List<Object?> params,
  ) async* {
    try {
      _throwIfClosed();
      final stmt = conn.prepare(sql);
      try {
        final cursor = stmt.selectCursor(params);
        while (cursor.moveNext()) {
          _throwIfClosed();
          yield _SqliteRowReader(cursor.current);
        }
      } finally {
        stmt.dispose();
      }
    } on SqliteException catch (e) {
      _throwSqliteException(e);
    }
  }

  @override
  Future<QueryResult> execute(String sql, List<Object?> params) async {
    final conn = await _getConnection();
    try {
      return await _execute(conn, sql, params);
    } finally {
      _releaseConnection(conn);
    }
  }

  Future<QueryResult> _execute(
      Database conn, String sql, List<Object?> params) async {
    final rows = await _query(conn, sql, params).toList();
    final affectedRows = conn.updatedRows;
    return QueryResult(
      affectedRows: affectedRows,
      rows: rows,
    );
  }

  @override
  Future<T> transaction<T>(
    Future<T> Function(DatabaseTransaction tx) fn,
  ) async {
    final conn = await _getConnection();
    _throwIfClosed();
    try {
      conn.execute('BEGIN');
      final value = await fn(_SqliteDatabaseTransaction._(conn, this));
      conn.execute('COMMIT');
      return value;
    } on SqliteException catch (e) {
      conn.execute('ROLLBACK');
      _throwSqliteException(e);
    } finally {
      _releaseConnection(conn);
    }
  }
}

mixin _SqliteDatabaseTransactionBase {
  Database get _conn;
  _SqliteDatabaseAdaptor get _adaptor;

  Stream<RowReader> query(String sql, List<Object?> params) async* {
    yield* _adaptor._query(_conn, sql, params);
  }

  Future<QueryResult> execute(String sql, List<Object?> params) async {
    return await _adaptor._execute(_conn, sql, params);
  }

  Future<T> savePoint<T>(Future<T> Function(DatabaseSavePoint sp) fn) async {
    _adaptor._throwIfClosed();
    final sp = 'sp_${_adaptor._savePointIndex++}';
    _conn.execute('SAVEPOINT "$sp"');
    try {
      final value = await fn(_SqliteDatabaseSavePoint._(_conn, _adaptor));
      _conn.execute('RELEASE "$sp"');
      return value;
    } on SqliteException catch (e) {
      _conn.execute('ROLLBACK TO "$sp"');
      _throwSqliteException(e);
    }
  }
}

final class _SqliteDatabaseTransaction extends DatabaseTransaction
    with _SqliteDatabaseTransactionBase {
  @override
  final Database _conn;

  @override
  final _SqliteDatabaseAdaptor _adaptor;

  _SqliteDatabaseTransaction._(this._conn, this._adaptor);
}

final class _SqliteDatabaseSavePoint extends DatabaseSavePoint
    with _SqliteDatabaseTransactionBase {
  @override
  final Database _conn;

  @override
  final _SqliteDatabaseAdaptor _adaptor;

  _SqliteDatabaseSavePoint._(this._conn, this._adaptor);
}

final class _SqliteRowReader extends RowReader {
  int _i = 0;
  final Row _row;

  _SqliteRowReader(this._row);

  @override
  bool? readBool() => _row.values[_i++] != 0;

  @override
  DateTime? readDateTime() => _row.values[_i++] as DateTime?;

  @override
  double? readDouble() => (_row.values[_i++] as num?)?.toDouble();

  @override
  int? readInt() => (_row.values[_i++] as num?)?.toInt();

  @override
  String? readString() => _row.values[_i++] as String?;
}

Never _throwSqliteException(SqliteException e) {
  // TODO: Separate error code into:
  //  - Temporary I/O error
  //  - Permanent database connection error (configuration issue)
  //  - Query issue
  //  - Transaction conflict!
  // NOTICE: that conflicts often happen as soon as offending statement is
  //         executed, conflicts don't just happen on COMMIT. They can and often
  //         do happen much sooner!

  switch (e.resultCode) {
    case SqlError.SQLITE_BUSY:
    case SqlError.SQLITE_LOCKED:
      throw SqliteTransactionConflictException._(e);

    default:
      throw SqliteQueryException(e);
  }
}

final class SqliteQueryException extends DatabaseQueryException {
  final SqliteException e;

  SqliteQueryException(this.e);

  @override
  String toString() => 'SqliteQueryException(${e.toString()})';
}

final class SqliteTransactionConflictException
    extends DatabaseTransactionConflictException {
  SqliteTransactionConflictException._(this.e);

  final SqliteException e;

  @override
  String toString() => 'DatabaseTransactionConflictException(${e.toString()})';
}
