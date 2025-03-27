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

// ignore_for_file: unused_element, unused_field, prefer_final_fields

import 'dart:async';
import 'dart:io';
import 'dart:typed_data' show Uint8List;

import 'package:postgres/postgres.dart';

import '../utils/notifier.dart';
import 'adaptor.dart';

DatabaseAdaptor postgresAdaptor(Pool<void> pool) =>
    _PostgresDatabaseAdaptor(pool);

final class _PostgresDatabaseAdaptor extends DatabaseAdaptor {
  final Pool<void> _pool;

  bool _closing = false;
  bool _forceClosing = false;
  bool _closed = false;
  int _pendingConnectionRequests = 0;
  final _stateChanged = Notifier();
  int _savePointIndex = 0;

  _PostgresDatabaseAdaptor(this._pool);

  void _throwIfClosing() {
    _throwIfClosed();
    if (_closing) {
      throw StateError('DatabaseAdaptor is closing!');
    }
  }

  void _throwIfClosed() {
    if (_closed) {
      throw StateError('DatabaseAdaptor is closed!');
    }
  }

  /// Throw a [DatabaseException] after [e] was thrown by `package:postgres`.
  Never _throwDatabaseException(Exception e) {
    // Unfortunately package:postgres does not document what exceptions it may
    // throw, perhaps there are all subclasses of PgException, perhaps not.
    // To be as defensive as possible we shall just catch all exceptions, and
    // try to map them to something useful.
    switch (e) {
      case ForeignKeyViolationException _:
        throw PostgresConstraintViolationException._('Exception: $e');

      case UniqueViolationException _:
        throw PostgresConstraintViolationException._('Exception: $e');

      case BadCertificateException _:
        // TODO: we could probably define a better exception for this
        throw PostgresDatabaseConnectionRefusedException._('Exception: $e');

      case PgException _:
        throw PostgresUnspecifiedOperationException._('Exception: $e');

      case SocketException _:
        // TODO: Find out if connection was refused, or it just broke!
        throw PostgresDatabaseConnectionBrokenException._('Exception: $e');

      case IOException _:
        throw PostgresDatabaseConnectionBrokenException._('Exception: $e');

      case TimeoutException _:
        throw PostgresDatabaseConnectionTimeoutException._('Exception: $e');

      default:
        throw PostgresUnspecifiedOperationException._('Exception: $e');
    }
  }

  Future<T> _withConnection<T>(Future<T> Function(Connection conn) fn) async {
    _throwIfClosing();

    _pendingConnectionRequests++;
    try {
      return await _pool.withConnection(fn);
    } finally {
      _pendingConnectionRequests--;
      _stateChanged.notify();
    }
  }

  @override
  Future<void> close({bool force = false}) async {
    _closing = true;

    if (force) {
      if (!_forceClosing) {
        await _pool.close(force: true);
      }
      _forceClosing = true;
    }

    // Gracefully wait for all connection requests to be closed
    while (_pendingConnectionRequests > 0) {
      await _stateChanged.wait;
    }

    await _pool.close();

    _closed = true;
  }

  @override
  Stream<RowReader> query(String sql, List<Object?> params) async* {
    try {
      // We can't use _withConnection directly, because that would make it
      // impossible to a streaming result.
      final futureConn = Completer<Connection>();
      final done = Completer<void>();
      scheduleMicrotask(() async {
        try {
          await _withConnection((conn) {
            futureConn.complete(conn);
            return done.future;
          });
        } catch (e, st) {
          futureConn.completeError(e, st);
        }
      });

      try {
        final conn = await futureConn.future;

        // TODO: Explore why streaming mode doesn't work
        // final ps = await _session.prepare(sql);
        // yield* ps.bind(params).map(_PostgresRowReader.new);
        final result = await conn.execute(
          sql,
          parameters: _paramsForPostgres(params),
          queryMode: QueryMode.extended,
        );
        yield* Stream.fromIterable(result.map(_PostgresRowReader.new));
      } finally {
        done.complete();
      }
    } on Exception catch (e) {
      _throwDatabaseException(e);
    }
  }

  @override
  Future<QueryResult> execute(String sql, List<Object?> params) async {
    try {
      return await _withConnection((conn) async {
        final result = await conn.execute(
          sql,
          parameters: _paramsForPostgres(params),
        );
        return QueryResult(affectedRows: result.affectedRows);
      });
    } on Exception catch (e) {
      _throwDatabaseException(e);
    }
  }

  @override
  Future<void> script(String sql) async {
    try {
      return await _withConnection((conn) async {
        await conn.execute(sql, queryMode: QueryMode.simple);
      });
    } on Exception catch (e) {
      _throwDatabaseException(e);
    }
  }

  @override
  Future<T> transact<T>(Future<T> Function(DatabaseTransaction tx) fn) async {
    // We can't use _withConnection directly, because then we can't know where
    // exceptions come from. We **must** know if an exception is from the
    // database or application code, as these **must** be treated differently.
    final futureConn = Completer<Connection>();
    final done = Completer<void>();
    scheduleMicrotask(() async {
      try {
        await _withConnection((conn) {
          futureConn.complete(conn);
          return done.future;
        });
      } catch (e, st) {
        futureConn.completeError(e, st);
      }
    });

    try {
      final Connection conn;
      try {
        conn = await futureConn.future;
        await conn.execute('BEGIN');
      } on Exception catch (e) {
        _throwDatabaseException(e);
      }

      try {
        final tx = _DatabaseTransaction(conn, this);
        final T value;
        try {
          value = await fn(tx);
        } finally {
          tx._closed = true;
        }
        try {
          await conn.execute('COMMIT');
        } on Exception catch (e) {
          _throwDatabaseException(e);
        }
        return value;
      } on Exception catch (e) {
        try {
          await conn.execute('ROLLBACK');
        } on Exception catch (e) {
          _throwDatabaseException(e);
        }
        throwTransactionAbortedException(e);
      } catch (e) {
        try {
          await conn.execute('ROLLBACK');
        } catch (e) {
          // ignore, the error is worse, we should just rethrow that!
        }
        rethrow; // always rethrow the error
      }
    } finally {
      done.complete();
    }
  }
}

final class _DatabaseTransaction extends DatabaseTransaction {
  final _PostgresDatabaseAdaptor _adaptor;
  final Connection _conn;
  var _closed = false;
  var _activeSubtransaction = false;

  _DatabaseTransaction(this._conn, this._adaptor);

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
      final rs = await _conn.execute(
        sql,
        parameters: _paramsForPostgres(params),
      );
      return QueryResult(affectedRows: rs.affectedRows);
    } on Exception catch (e) {
      _adaptor._throwDatabaseException(e);
    }
  }

  @override
  Stream<RowReader> query(String sql, List<Object?> params) async* {
    _throwIfBlocked();
    try {
      // Notice that in transaction query() MAY NOT block when there is
      // back-pressure. The easiest way to do this is to fetch all the results
      // at once.
      final result = await _conn.execute(
        sql,
        parameters: _paramsForPostgres(params),
        queryMode: QueryMode.extended,
      );
      yield* Stream.fromIterable(result.map(_PostgresRowReader.new));
    } on Exception catch (e) {
      _adaptor._throwDatabaseException(e);
    }
  }

  @override
  Future<void> script(String sql) async {
    _throwIfBlocked();

    try {
      await _conn.execute(sql, queryMode: QueryMode.simple);
    } on Exception catch (e) {
      _adaptor._throwDatabaseException(e);
    }
  }

  @override
  Future<T> transact<T>(Future<T> Function(_DatabaseTransaction sp) fn) async {
    _throwIfBlocked();

    final sp = 'sp_${_adaptor._savePointIndex++}';
    try {
      _activeSubtransaction = true;
      try {
        await _conn.execute('SAVEPOINT "$sp"');
      } on Exception catch (e) {
        _adaptor._throwDatabaseException(e);
      }
      try {
        final tx = _DatabaseTransaction(_conn, _adaptor);
        final T value;
        try {
          value = await fn(tx);
        } finally {
          tx._closed = true;
        }
        try {
          await _conn.execute('RELEASE "$sp"');
        } on Exception catch (e) {
          _adaptor._throwDatabaseException(e);
        }
        return value;
      } on Exception catch (e) {
        try {
          await _conn.execute('ROLLBACK TO "$sp"');
        } on Exception catch (e) {
          _adaptor._throwDatabaseException(e);
        }
        throwTransactionAbortedException(e);
      } catch (e) {
        try {
          await _conn.execute('ROLLBACK');
        } catch (e) {
          // ignore, the error is worse, we should just rethrow that!
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
    final value = _row[_i++];
    if (value is! bool?) {
      throw AssertionError('readBool() expected a bool, got "$value"');
    }
    return value;
  }

  @override
  DateTime? readDateTime() {
    var value = _row[_i++];
    if (value is String) {
      // No idea why postgres sometimes return dates as strings.
      // Maybe, it does this only for literal values, because it can't infer
      // the type as a date.
      final parsed = DateTime.tryParse(value);
      if (parsed != null) {
        return parsed;
      }
    }
    if (value is! DateTime?) {
      throw AssertionError('readDateTime() expected a timestamp, got "$value"');
    }
    return value;
  }

  @override
  double? readDouble() {
    var value = _row[_i++];
    if (value is String) {
      // No idea why postgres sometimes return doubles as strings.
      // Maybe, it does this only for literal values, because they could be more
      // than 64 bits!
      final parsed = double.tryParse(value);
      if (parsed != null) {
        return parsed;
      }
    }
    if (value is! double?) {
      throw AssertionError('readDouble() expected a float, got "$value"');
    }
    return value;
  }

  @override
  int? readInt() {
    final value = _row[_i++];
    if (value is String) {
      // No idea why postgres sometimes return integers as strings.
      // Maybe, it does this only for literal values, because they could be more
      // than 64 bits!
      final parsed = int.tryParse(value);
      if (parsed != null) {
        return parsed;
      }
    }
    if (value is! int?) {
      throw AssertionError('readInt() expected a integer, got "$value"');
    }
    return value;
  }

  @override
  String? readString() {
    final value = _row[_i++];
    if (value is! String?) {
      throw AssertionError('readString() expected a String, got "$value"');
    }
    return value;
  }

  @override
  Uint8List? readUint8List() {
    final value = _row[_i++];
    if (value is! Uint8List?) {
      throw AssertionError(
          'readUint8List() expected a Uint8List, got "$value"');
    }
    return value;
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

mixin PostgresDatabaseException implements Exception {
  String get message;

  @override
  String toString() => message;
}

final class PostgresConstraintViolationException
    extends ConstraintViolationException with PostgresDatabaseException {
  @override
  final String message;

  PostgresConstraintViolationException._(this.message);
}

final class PostgresUnspecifiedOperationException
    extends UnspecifiedOperationException with PostgresDatabaseException {
  @override
  final String message;

  PostgresUnspecifiedOperationException._(this.message);
}

final class PostgresDatabaseConnectionClosedException
    extends DatabaseConnectionClosedException with PostgresDatabaseException {
  @override
  final String message;

  PostgresDatabaseConnectionClosedException._(this.message);
}

final class PostgresAuthenticationException extends AuthenticationException
    with PostgresDatabaseException {
  @override
  final String message;

  PostgresAuthenticationException._(this.message);
}

final class PostgresDatabaseConnectionRefusedException
    extends DatabaseConnectionRefusedException with PostgresDatabaseException {
  @override
  final String message;

  PostgresDatabaseConnectionRefusedException._(this.message);
}

final class PostgresDatabaseConnectionBrokenException
    extends DatabaseConnectionBrokenException with PostgresDatabaseException {
  @override
  final String message;

  PostgresDatabaseConnectionBrokenException._(this.message);
}

final class PostgresDatabaseConnectionTimeoutException
    extends DatabaseConnectionTimeoutException with PostgresDatabaseException {
  @override
  final String message;

  PostgresDatabaseConnectionTimeoutException._(this.message);
}
