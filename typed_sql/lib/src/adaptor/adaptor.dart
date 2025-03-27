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

import '../exceptions.dart';
import 'logging_adaptor.dart';
import 'postgres_adaptor.dart';
import 'sqlite_adaptor.dart';

export '../exceptions.dart';

/// Interface that a database adaptor must implement.
abstract base class DatabaseAdaptor extends Executor {
  /// Close the database connection pool.
  ///
  /// If called without [force] this must wait for all ongoing calls to
  /// [script], [query], [execute] or [transact] to finish.
  ///
  /// Once this has been called all calls to [script], [query], [execute] or
  /// [transact] shall throw [StateError]. Unless, these calls are taking place
  /// inside a transaction started before [close] was called.
  ///
  /// If called with [force] set to `true`, all ongoing calls to [script],
  /// [query], [execute] or [transact] shall throw a
  /// [DatabaseConnectionException].
  Future<void> close({bool force = false});

  static DatabaseAdaptor sqlite3(Uri uri) => sqlite3Adaptor(uri);

  static DatabaseAdaptor postgres(Pool<void> pool) => postgresAdaptor(pool);

  static DatabaseAdaptor withLogging(
    DatabaseAdaptor adaptor,
    void Function(String message) logDrain,
  ) =>
      loggingAdaptor(adaptor, logDrain);
}

/// Interface for executing database operations in a transaction.
abstract base class DatabaseTransaction extends Executor {
  /// {@macro Executor.query}
  ///
  /// The returned [Stream] must disregard back-pressure to avoid deadlocks in
  /// the transaction. In practice this can be done by buffering all results in
  /// a [List] and return a [Stream] wrapping said list.
  @override
  Stream<RowReader> query(String sql, List<Object?> params);

  /// {@macro Executor.transact}
  ///
  /// Any call to [script], [query], [execute] or [transact] while a transaction
  /// is ongoing shall throw [StateError], until the transaction has been
  /// committed or rolled back.
  @override
  Future<T> transact<T>(Future<T> Function(DatabaseTransaction tx) fn);
}

/// Result of executing an SQL statement.
final class QueryResult {
  /// Number of rows affected by the SQL statement.
  final int affectedRows;

  QueryResult({
    required this.affectedRows,
  });
}

/// Interface for executing database operations.
abstract final class Executor {
  /// Execute an [sql] script that may contain multiple statements.
  ///
  /// Statements are typically separated by `;`.
  ///
  /// Throws [DatabaseException], if the execution fails.
  Future<void> script(String sql);

  /// {@template Executor.query}
  /// Execute [sql] query with positional [params].
  ///
  /// Parameters may be referenced in the [sql] query using `$1`, `$2`, ...
  ///
  /// Returns a stream of rows, where each row is a list columns.
  /// If there are no data to be returned, this yields an empty stream.
  ///
  /// The following types can be passed in and out.
  ///  * [String]
  ///  * [int]
  ///  * [double]
  ///  * [bool]
  ///  * [DateTime]
  ///  * [Uint8List]
  ///  * `null`
  ///
  /// Throws [DatabaseException], if the query fails.
  /// {@endtemplate}
  Stream<RowReader> query(String sql, List<Object?> params);

  /// Execute a single [sql] query with positional [params].
  ///
  /// Does not return any results.
  ///
  /// Throws [DatabaseException], if the execution fails.
  Future<QueryResult> execute(String sql, List<Object?> params);

  /// {@template Executor.transact}
  /// Begin a transaction / save-point and call [fn] before committing the
  /// transaction.
  ///
  /// If [fn] throws an [Exception] the transaction shall be rolled back and
  /// [TransactionAbortedException] thrown with the [Exception] as `reason`.
  ///
  /// If [fn] throw an [Error] the transaction shall be rolled back and the
  /// [Error] will be propagated to the caller.
  ///
  /// Any calls on the `tx` provided to [fn] shall throw [StateError] after the
  /// transaction has been committed or rolled back.
  /// {@endtemplate}
  ///
  /// > [!WARNING]
  /// > On [DatabaseTransaction] any call to [script], [query], [execute] or
  /// > [transact] shall throw [StateError], until the transaction has been
  /// > committed or rolled back.
  Future<T> transact<T>(Future<T> Function(Executor tx) fn);
}

/// Interface for reading rows from a database.
///
/// This interface reads one column and then advances to the next column.
abstract base class RowReader {
  /// Read [String] or `null`.
  ///
  /// Throws [AssertionError], if the type is not [String].
  String? readString();

  /// Read [int] or `null`.
  ///
  /// Throws [AssertionError], if the type is not [int].
  int? readInt();

  /// Read [double] or `null`.
  ///
  /// Throws [AssertionError], if the type is not [double].
  double? readDouble();

  /// Read [bool] or `null`.
  ///
  /// Throws [AssertionError], if the type is not [bool].
  bool? readBool();

  /// Read [DateTime] or `null`.
  ///
  /// Throws [AssertionError], if the type is not [DateTime].
  DateTime? readDateTime();

  /// Read [Uint8List] or `null`.
  ///
  /// Throws [AssertionError], if the type is not [Uint8List].
  Uint8List? readUint8List();

  /// Return `true` and consume next column, if next column is `null`.
  bool tryReadNull();
}
