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
import 'dart:convert' show utf8;
import 'dart:io';
import 'dart:typed_data' show Uint8List;

// ignore: depend_on_referenced_packages
import 'package:mysql1/mysql1.dart';

import '../utils/notifier.dart';
import '../utils/uuid.dart';
import 'adapter.dart'; // ignore: implementation_imports

DatabaseAdapter mysqlTestingAdaptor() {
  return DatabaseAdapter.fromFuture(_mysqlTestingAdapter());
}

Future<DatabaseAdapter> _mysqlTestingAdapter() async {
  final f = File('.dart_tool/run/mariadb/mysqld.sock');

  final admin = await MySqlConnection.connect(
    ConnectionSettings.socket(
      path: f.absolute.path,
      user: 'root',
      password: 'mysql',
    ),
    isUnixSocket: true,
  );

  final testdb = 'testdb-${uuid()}';

  await admin.query('CREATE DATABASE `$testdb`;');

  var closing = false;
  final closed = Completer<void>();
  final adaptor = _MysqlDatabaseAdapter(() async {
    return await MySqlConnection.connect(
      ConnectionSettings.socket(
        path: f.absolute.path,
        user: 'root',
        password: 'mysql',
        db: testdb,
      ),
      isUnixSocket: true,
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
  Future<T> transact<T>(Future<T> Function(Executor tx) fn) {
    throw UnimplementedError();
  }
}

/*
// ignore: unused_element
final class _DatabaseTransaction extends DatabaseTransaction {
  final _MysqlDatabaseAdapter _adaptor;
  final MySqlConnection _conn;
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
    (sql, params) = _rearrangeParams(sql, params);
    try {
      final stmt = await _conn.prepare(sql, false);
      try {
        final result = await stmt.execute(params);
        return QueryResult(
          affectedRows: result.affectedRows.toInt(),
        );
      } finally {
        await stmt.deallocate();
      }
    } on Exception catch (e) {
      _adaptor._throwDatabaseException(e);
    }
  }

  @override
  Stream<RowReader> query(String sql, List<Object?> params) async* {
    _throwIfBlocked();
    (sql, params) = _rearrangeParams(sql, params);
    try {
      final stmt = await _conn.prepare(sql, false);
      try {
        final result = await stmt.execute(params);
        yield* Stream.fromIterable(result.rows.map(_MysqlRowReader.new));
      } finally {
        await stmt.deallocate();
      }
    } on Exception catch (e) {
      _adaptor._throwDatabaseException(e);
    }
  }

  @override
  Future<void> script(String sql) async {
    _throwIfBlocked();

    try {
      await _conn.execute(sql);
    } on Exception catch (e) {
      _adaptor._throwDatabaseException(e);
    }
  }

  @override
  Future<T> transact<T>(Future<T> Function(DatabaseTransaction tx) fn) {
    throw UnimplementedError();
  }
}*/

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
    if (value == null) {
      return null;
    }
    throw AssertionError('Mysql cannot return Uint8List');
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
            _ => p,
          })
      .toList();

  print('###: ("$newSql", $newParams)');
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
