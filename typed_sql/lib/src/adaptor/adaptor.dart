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

import 'dart:typed_data';

import 'package:postgres/postgres.dart' show Pool;

import 'logging_adaptor.dart';
import 'postgres_adaptor.dart';
import 'sqlite_adaptor.dart';

abstract base class DatabaseAdaptor extends QueryExecutor {
  Future<void> close({bool force = false});

  static DatabaseAdaptor sqlite3(Uri uri) => sqlite3Adaptor(uri);

  static DatabaseAdaptor postgres(Pool<void> pool) => postgresAdaptor(pool);

  static DatabaseAdaptor withLogging(
    DatabaseAdaptor adaptor,
    void Function(String message) logDrain,
  ) =>
      loggingAdaptor(adaptor, logDrain);
}

abstract base class DatabaseTransaction extends QueryExecutor {
  /// Begin a transaction / save-point and call [fn] before committing the
  /// transaction.
  ///
  /// If [fn] throws, the transaction shall be rolled back and the [Exception]
  /// or [Error] propagated to the caller.
  ///
  /// Any calls on the `tx` provided to [fn] shall throw [StateError] after the
  /// transaction has been committed or rolled back.
  ///
  /// Any call to [script], [query], [execute] until this function has returned
  /// shall throw [StateError].
  @override
  Future<T> transact<T>(Future<T> Function(QueryExecutor tx) fn);
}

/// Result of executing an SQL statement.
final class QueryResult {
  /// Number of rows affected by the SQL statement.
  final int affectedRows;

  QueryResult({
    required this.affectedRows,
  });
}

abstract final class QueryExecutor {
  /// Execute an [sql] script that may contain multiple statements.
  ///
  /// Statements are typically separated by `;`.
  Future<void> script(String sql);

  /// Execute [sql] query with positional [params].
  ///
  /// Parameters may be referenced in the [sql] query using `$1`, `$2`, ...
  ///
  /// Returns a stream of rows, where each row is a list columns.
  /// If there are no data to be returned, this yields an empty stream.
  ///
  /// If inside a transaction the returned [Stream] must not disregard
  /// back-pressure, to avoid deadlocks in the transaction. In practice this can
  /// be trivially archived by buffering all results in a [List] and return
  /// a [Stream] wrapping said list.
  ///
  /// The following types can be passed in and out.
  ///  * [String]
  ///  * [int]
  ///  * [double]
  ///  * [bool]
  ///  * [DateTime]
  ///  * [Uint8List]
  ///  * `null`
  // TODO: Add support for JSON, Duration, BigInt
  Stream<RowReader> query(String sql, List<Object?> params);

  /// Execute a single [sql] query with positional [params].
  ///
  /// Does not return any results.
  Future<QueryResult> execute(String sql, List<Object?> params);

  /// Begin a transaction / save-point and call [fn] before committing the
  /// transaction.
  ///
  /// If [fn] throws, the transaction shall be rolled back and the [Exception]
  /// or [Error] propagated to the caller.
  ///
  /// Any calls on the `tx` provided to [fn] shall throw [StateError] after the
  /// transaction has been committed or rolled back.
  Future<T> transact<T>(Future<T> Function(QueryExecutor tx) fn);
}

abstract base class RowReader {
  String? readString();
  int? readInt();
  double? readDouble();
  bool? readBool();
  DateTime? readDateTime();
  Uint8List? readUint8List();
  bool tryReadNull();
}

sealed class DatabaseException implements Exception {}

/// Thrown by [QueryExecutor] if the query failed to execute.
///
/// This does not cause the underlying connection or transactions to be aborted.
base class DatabaseQueryException implements DatabaseException {}

/// Thrown by [QueryExecutor] if the transaction/save-point is aborted.
base class DatabaseTransactionAbortedException implements DatabaseException {}

/// Thrown, when [DatabaseAdaptor] has failed to maintain or obtain a
/// connection.
sealed class DatabaseConnectionException implements DatabaseException {}

/// Thrown, when [DatabaseAdaptor] is broken, but it's believed that
/// the issue is intermittent.
///
/// **Example**: A broken TCP connection can often be resolved by creating a new
/// connection.
base class DatabaseConnectionBrokenException
    extends DatabaseConnectionException {}

/// Thrown, when a [DatabaseAdaptor] fails and it is believe that the issue
/// is persistent.
///
/// **Example**: An authentication error can usually not be resolved by trying
/// to create a new connection.
base class DatabaseConnectionFailedException
    extends DatabaseConnectionException {}
