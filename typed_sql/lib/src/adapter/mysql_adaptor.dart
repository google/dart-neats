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
import 'dart:convert' show json, latin1, utf8;
import 'dart:io';
import 'dart:typed_data' show Uint8List;

// ignore: depend_on_referenced_packages
import 'package:mysql1/mysql1.dart';

// ignore: depend_on_referenced_packages
import 'package:test/test.dart' show printOnFailure;

import '../types/json_value.dart';
import '../utils/normalize_json.dart';
import '../utils/notifier.dart';
import '../utils/uuid.dart';
import 'adapter.dart'; // ignore: implementation_imports

DatabaseAdapter mysqlTestingAdaptor({
  String? host,
  int? port,
  String? database,
  String? user,
  String? password,
}) {
  return DatabaseAdapter.fromFuture(_mysqlTestingAdapter(
    host: host,
    port: port,
    database: database,
    user: user,
    password: password,
  ));
}

Future<DatabaseAdapter> _mysqlTestingAdapter({
  String? host,
  int? port,
  String? database,
  String? user,
  String? password,
}) async {
  host ??= Platform.environment['MYSQL_HOST'] ?? '127.0.0.1';
  port ??= int.tryParse(Platform.environment['MYSQL_PORT'] ?? '') ?? 3306;
  database ??= Platform.environment['MYSQL_DATABASE'] ?? '';
  user ??= Platform.environment['MYSQL_USER'] ?? 'root';
  password ??= Platform.environment['MYSQL_PASSWORD'] ?? 'root';

  final isUnixSocket = Platform.isWindows
      ? host.startsWith(RegExp(r'[a-zA-Z]+:\\'))
      : host.startsWith('/');

  final admin = await MySqlConnection.connect(
    isUnixSocket
        ? ConnectionSettings.socket(
            path: host,
            db: database,
            user: user,
            password: password,
          )
        : ConnectionSettings(
            host: host,
            db: database,
            port: port,
            user: user,
            password: password,
          ),
    isUnixSocket: isUnixSocket,
  );

  final testdb = 'testdb-${uuid()}';

  await admin.query('CREATE DATABASE `$testdb`;');

  var closing = false;
  final closed = Completer<void>();
  final adaptor = _MysqlDatabaseAdapter(() async {
    return await MySqlConnection.connect(
      isUnixSocket
          ? ConnectionSettings.socket(
              path: host!,
              db: testdb,
              user: user,
              password: password,
            )
          : ConnectionSettings(
              host: host!,
              db: testdb,
              port: port!,
              user: user,
              password: password,
            ),
      isUnixSocket: isUnixSocket,
    );
  });
  return DatabaseAdapter.withOnClose(adaptor, ({
    required bool force,
  }) async {
    try {
      await adaptor.close(force: force);
    } finally {
      if (!closing) {
        closing = true;
        closed.complete(() async {
          try {
            await admin.query('DROP DATABASE `$testdb`;');
          } finally {
            await admin.close();
          }
        }());
      }
    }

    return await closed.future;
  });
}

final class _MysqlDatabaseAdapter extends DatabaseAdapter {
  final Future<MySqlConnection> Function() _connect;

  bool _closing = false;
  bool _forceClosing = false;
  bool _closed = false;
  int _pendingConnectionRequests = 0;
  final List<MySqlConnection> _idleConnections = [];
  final _stateChanged = Notifier();
  int _savePointIndex = 0;

  _MysqlDatabaseAdapter(this._connect);

  void _throwIfClosing() {
    _throwIfClosed();
    if (_closing) {
      throw StateError('DatabaseAdapter is closing!');
    }
  }

  void _throwIfClosed() {
    if (_closed) {
      throw StateError('DatabaseAdapter is closed!');
    }
  }

  /// Throw a [DatabaseException] after [e] was thrown by `package:mysql_dart`.
  Never _throwDatabaseException(Exception e) {
    throw MysqlUnspecifiedOperationException._(e.toString());
  }

  Future<T> _withConnection<T>(
    Future<T> Function(MySqlConnection conn) fn,
  ) async {
    _throwIfClosing();

    _pendingConnectionRequests++;
    try {
      final MySqlConnection c;
      if (_idleConnections.isEmpty) {
        c = await _connect();
      } else {
        c = _idleConnections.removeLast();
      }
      var failed = true;
      try {
        final value = await fn(c);
        failed = false;
        return value;
      } finally {
        if (failed) {
          await c.close();
        } else {
          _idleConnections.add(c);
        }
      }
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
        // TODO: Force close
      }
      _forceClosing = true;
    }

    // Gracefully wait for all connection requests to be closed
    while (_pendingConnectionRequests > 0) {
      await _stateChanged.wait;
    }

    final idleConnections = _idleConnections.toList();
    _idleConnections.clear();
    for (final conn in idleConnections) {
      await conn.close();
    }

    _closed = true;
  }

  @override
  Future<QueryResult> execute(String sql, List<Object?> params) async {
    (sql, params) = _rearrangeParams(sql, params);
    try {
      return await _withConnection((conn) async {
        final result = await conn.query(sql, params);
        return QueryResult(affectedRows: result.affectedRows!);
      });
    } on Exception catch (e) {
      _throwDatabaseException(e);
    }
  }

  @override
  Stream<RowReader> query(String sql, List<Object?> params) async* {
    (sql, params) = _rearrangeParams(sql, params);
    try {
      final results = await _withConnection((conn) async {
        final result = await conn.query(sql, params);
        return result.map(_MysqlRowReader.new).toList();
      });
      yield* Stream.fromIterable(results);
    } on Exception catch (e) {
      _throwDatabaseException(e);
    }
  }

  @override
  Future<void> script(String sql) async {
    try {
      return await _withConnection((conn) async {
        // TODO: Fix this pretty ugly hack!
        for (final s in sql.split(';')) {
          await conn.query(s);
        }
      });
    } on Exception catch (e) {
      _throwDatabaseException(e);
    }
  }

  @override
  Future<T> transact<T>(Future<T> Function(DatabaseTransaction tx) fn) async {
    return await _withConnection((conn) async {
      try {
        await conn.query('START TRANSACTION');
        final tx = _DatabaseTransaction(conn, this);
        final T value;
        try {
          value = await fn(tx);
        } finally {
          tx._closed = true;
        }
        await conn.query('COMMIT');
        return value;
      } on Exception catch (e) {
        await conn.query('ROLLBACK');
        throwTransactionAbortedException(e);
      } catch (e) {
        await conn.query('ROLLBACK');
        rethrow;
      }
    });
  }
}

final class _DatabaseTransaction extends DatabaseTransaction {
  final _MysqlDatabaseAdapter _adapter;
  final MySqlConnection _conn;
  var _closed = false;
  var _activeSubtransaction = false;

  _DatabaseTransaction(this._conn, this._adapter);

  void _throwIfBlocked() {
    _adapter._throwIfClosed();
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
    (sql, params) = _rearrangeParams(sql, params);
    try {
      final result = await _conn.query(sql, params);
      return QueryResult(
        affectedRows: result.affectedRows!,
      );
    } on Exception catch (e) {
      _adapter._throwDatabaseException(e);
    }
  }

  @override
  Stream<RowReader> query(String sql, List<Object?> params) async* {
    _throwIfBlocked();
    (sql, params) = _rearrangeParams(sql, params);
    try {
      final result = await _conn.query(sql, params);
      yield* Stream.fromIterable(result.map(_MysqlRowReader.new));
    } on Exception catch (e) {
      _adapter._throwDatabaseException(e);
    }
  }

  @override
  Future<void> script(String sql) async {
    _throwIfBlocked();

    try {
      // TODO: Fix this pretty ugly hack!
      for (final s in sql.split(';')) {
        await _conn.query(s);
      }
    } on Exception catch (e) {
      _adapter._throwDatabaseException(e);
    }
  }

  @override
  Future<T> transact<T>(Future<T> Function(DatabaseTransaction tx) fn) async {
    _throwIfBlocked();

    final sp = 'sp_${_adapter._savePointIndex++}';
    try {
      _activeSubtransaction = true;
      await _conn.query('SAVEPOINT `$sp`');
      try {
        final tx = _DatabaseTransaction(_conn, _adapter);
        final T value;
        try {
          value = await fn(tx);
        } finally {
          tx._closed = true;
        }
        await _conn.query('RELEASE SAVEPOINT `$sp`');
        return value;
      } on Exception catch (e) {
        await _conn.query('ROLLBACK TO `$sp`');
        throwTransactionAbortedException(e);
      } catch (e) {
        await _conn.query('ROLLBACK TO `$sp`');
        rethrow;
      }
    } finally {
      _activeSubtransaction = false;
    }
  }
}

final class _MysqlRowReader extends RowReader {
  int _i = 0;
  final ResultRow _row;

  _MysqlRowReader(this._row);

  @override
  bool? readBool() {
    final value = _row.values![_i++];
    if (value is String) {
      return int.parse(value) > 0;
    }
    if (value is int) {
      return value > 0;
    }
    if (value == null) {
      return null;
    }
    throw AssertionError('Mysql cannot return bool');
    // TODO: Wrap exceptions that we might get here
  }

  @override
  DateTime? readDateTime() {
    final value = _row.values![_i++];
    if (value is DateTime) {
      return value.copyWith(isUtc: true);
    }
    return null;
  }

  @override
  double? readDouble() {
    final value = _row.values![_i++];
    if (value is double) {
      return value;
    }
    if (value is String) {
      return double.parse(value);
    }
    if (value == null) {
      return null;
    }
    throw AssertionError('Mysql cannot return double');
  }

  @override
  int? readInt() {
    final value = _row.values![_i++];
    if (value is int) {
      return value;
    }
    if (value is String) {
      return int.parse(value);
    }
    if (value == null) {
      return null;
    }
    throw AssertionError('Mysql cannot return double');
  }

  @override
  String? readString() {
    final value = _row.values![_i++];
    if (value is String) {
      return value;
    }
    if (value == null) {
      return null;
    }
    if (value is Blob) {
      return utf8.decode(value.toBytes());
    }
    throw AssertionError('Mysql cannot return string');
  }

  @override
  Uint8List? readUint8List() {
    final value = _row.values![_i++];
    if (value is Blob) {
      return Uint8List.fromList(value.toBytes());
    }
    // If we do CAST(? AS BINARY) the database won't return it as a BLOB, but as
    // a binary string instead.
    if (value is String) {
      return latin1.encode(value);
    }
    if (value == null) {
      return null;
    }
    throw AssertionError('Mysql cannot return Uint8List');
  }

  @override
  JsonValue? readJsonValue() {
    final value = _row[_i++];
    if (value is String) {
      return JsonValue(json.decode(value));
    }
    if (value is Blob) {
      return JsonValue(json.decode(utf8.decode(value.toBytes())));
    }
    throw AssertionError('readJsonValue() expected a JSON type, got "$value"');
  }

  @override
  bool tryReadNull() {
    if (_row.values![_i] == null) {
      _i++;
      return true;
    }
    return false;
  }
}

final _paramPattern = RegExp(r'\?([0-9]+)');

(String, List<Object?>) _rearrangeParams(String sql, List<Object?> params) {
  var newParams = <Object?>[];
  final newSql = sql.replaceAllMapped(_paramPattern, (match) {
    final index = int.parse(match.group(1)!);
    newParams.add(params[index - 1]);
    return '?';
  });

  newParams = newParams
      .map((p) => switch (p) {
            DateTime d => d.toUtc(),
            Uint8List b => Blob.fromBytes(b),
            // TODO: Consider forking JsonEncoder from 'dart:convert' and
            //       normalize while we encode for increased performance
            //       and more reliable normalization.
            JsonValue v => json.encode(normalizeJson(v.value)),
            _ => p,
          })
      .toList();

  // TODO: Remove this when mysql driver is working reasonably well.
  printOnFailure('###: ("$newSql", $newParams)');
  return (newSql, newParams);
}

mixin MysqlDatabaseException implements Exception {
  String get message;

  @override
  String toString() => message;
}

final class MysqlConstraintViolationException
    extends ConstraintViolationException with MysqlDatabaseException {
  @override
  final String message;

  MysqlConstraintViolationException._(this.message);
}

final class MysqlUnspecifiedOperationException
    extends UnspecifiedOperationException with MysqlDatabaseException {
  @override
  final String message;

  MysqlUnspecifiedOperationException._(this.message);
}

final class MysqlDatabaseConnectionForceClosedException
    extends DatabaseConnectionForceClosedException with MysqlDatabaseException {
  @override
  final String message;

  MysqlDatabaseConnectionForceClosedException._(this.message);
}

final class MysqlAuthenticationException extends AuthenticationException
    with MysqlDatabaseException {
  @override
  final String message;

  MysqlAuthenticationException._(this.message);
}

final class MysqlDatabaseConnectionRefusedException
    extends DatabaseConnectionRefusedException with MysqlDatabaseException {
  @override
  final String message;

  MysqlDatabaseConnectionRefusedException._(this.message);
}

final class MysqlDatabaseConnectionBrokenException
    extends DatabaseConnectionBrokenException with MysqlDatabaseException {
  @override
  final String message;

  MysqlDatabaseConnectionBrokenException._(this.message);
}

final class MysqlDatabaseConnectionTimeoutException
    extends DatabaseConnectionTimeoutException with MysqlDatabaseException {
  @override
  final String message;

  MysqlDatabaseConnectionTimeoutException._(this.message);
}
