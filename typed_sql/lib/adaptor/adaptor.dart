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

import 'logging_adaptor.dart';
import 'sqlite.dart';

abstract base class DatabaseAdaptor extends QueryExecutor {
  /// Begin a transaction ad call [fn] before committing the transaction.
  ///
  /// If [fn] throws, the transaction shall be rolled back and the [Exception]
  /// or [Error] propagated to the caller.
  Future<T> transaction<T>(Future<T> Function(DatabaseTransaction tx) fn);

  // TODO: Consider if we need session() similar to transaction, which ensures
  //       that queries run sequentially on the same connection / session.

  Future<void> close({bool force = false});

  static DatabaseAdaptor sqlite3(Uri uri) => sqlite3Adaptor(uri);

  static DatabaseAdaptor withLogging(
    DatabaseAdaptor adaptor,
    void Function(String message) logDrain,
  ) =>
      loggingAdaptor(adaptor, logDrain);
}

abstract base class DatabaseTransaction extends QueryExecutor {
  /// Create a save-point and runs `fn` before releasing the save-point.
  ///
  /// If [fn] throws, this transaction shall be rolled back to the
  /// save-point and the [Exception] or [Error] propagated to the caller.
  // TODO: Remark that calling [query] before [savePoint] has returned may
  //       cause undefined behavior.
  //       Indeed typed_sql wrappers will ensure that [query]/[savePoint] are
  //       not called concurrently at the same level!
  Future<T> savePoint<T>(Future<T> Function(DatabaseSavePoint sp) fn);
}

abstract base class DatabaseSavePoint extends DatabaseTransaction {}

class QueryResult {
  final int affectedRows;
  final List<RowReader> rows;

  QueryResult({
    required this.affectedRows,
    required this.rows,
  });
}

abstract final class QueryExecutor {
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
  ///  * [BigInt]
  ///  * [Uint8List]
  ///  * `null`
  ///  * [Map<String, Object?>], [List<Object?>], [String], [int],
  ///    [double], [bool], `null` (for JSON).
  Stream<RowReader> query(String sql, List<Object?> params);

  Future<QueryResult> execute(String sql, List<Object?> params);
}

abstract base class RowReader {
  String? readString();
  int? readInt();
  double? readDouble();
  bool? readBool();
  DateTime? readDateTime();
}

sealed class DatabaseException implements Exception {}

/// Thrown by [QueryExecutor.query] if the query failed to execute.
///
/// This does not cause the underlying connection or transactions to be aborted.
base class DatabaseQueryException implements DatabaseException {}

/// Thrown by [DatabaseAdaptor.transaction] if the transaction fails to commit.
///
/// This should only be thrown because the transaction couldn't be committed,
/// when it was attempted.
base class DatabaseTransactionConflictException implements DatabaseException {}

/// Thrown, when [DatabaseConnection] has failed to maintain or obtain a
/// connection.
sealed class DatabaseConnectionException implements DatabaseException {}

/// Thrown, when [DatabaseConnection] is broken, but it's believed that
/// the issue is intermittent.
///
/// **Example**: A broken TCP connection can often be resolved by creating a new
/// connection.
base class DatabaseConnectionBrokenException
    extends DatabaseConnectionException {}

/// Thrown, when a [DatabaseConnection] fails and it is believe that the issue
/// is persistent.
///
/// **Example**: An authentication error can usually not be resolved by trying
/// to create a new connection.
base class DatabaseConnectionFailedException
    extends DatabaseConnectionException {}
