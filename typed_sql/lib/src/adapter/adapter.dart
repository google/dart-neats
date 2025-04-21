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

/// @docImport 'package:test/test.dart';
library;

import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:postgres/postgres.dart' show Pool;

import '../exceptions.dart';
import 'future_adapter.dart';
import 'logging_adapter.dart';
import 'postgres_adapter.dart';
import 'sqlite_adapter.dart';
import 'testing_adapter.dart';
import 'wrapclose_adapter.dart';

export '../exceptions.dart';

/// Interface that a database adapter must implement.
///
/// > [!WARNING]
/// > This interface is NOT stable yet, while subclasses of [DatabaseAdapter]
/// > is possible outside `package:typed_sql`, newer versions of this package
/// > may add new methods (remove existing) without a major version bump!
///
/// {@category testing}
abstract base class DatabaseAdapter extends Executor {
  DatabaseAdapter();

  /// Close the database connection pool.
  ///
  /// If called without [force] this must wait for all ongoing calls to
  /// [script], [query], [execute] or [transact] to finish.
  ///
  /// Once this has been called further calls to [script], [query], [execute] or
  /// [transact] shall throw [StateError]. Unless, these calls are taking place
  /// inside a transaction started before [close] was called.
  ///
  /// If called with [force] set to `true`, all ongoing calls to [script],
  /// [query], [execute] or [transact] shall throw a
  /// [DatabaseConnectionException].
  Future<void> close({bool force = false});

  /// Create an SQLite3 [DatabaseAdapter] from [uri].
  ///
  /// The [uri] must be given in [SQLite3 URI format][1], such as
  /// `file://path/to/database.db`.
  ///
  /// {@template sqlite-dependency}
  /// The [DatabaseAdapter] for SQLite3 relies on [`package:sqlite3`][sd-1],
  /// this requires the dynamic library to available on the system, or manually
  /// specified, see [manually providing sqlite3 libraries][sd-2].
  ///
  /// [sd-1]: https://pub.dev/packages/sqlite3
  /// [sd-2]: https://pub.dev/packages/sqlite3#manually-providing-sqlite3-libraries
  /// {@endtemplate}
  ///
  /// > [!WARNING]
  /// > Do not use `:memory:`, the [DatabaseAdapter] **must** be able to open
  /// > concurrent connections. For testing consider using
  /// > [DatabaseAdapter.sqlite3TestDatabase]. If you want an in-memory
  /// > database, use _shared-cache_ with [URI filename][1], such as:
  /// > `file:memdb1?mode=memory&cache=shared`.
  /// >
  /// > See also SQLite3 documentation on [In-Memory Databases][2].
  ///
  /// [1]: https://www.sqlite.org/uri.html
  /// [2]: https://www.sqlite.org/inmemorydb.html
  factory DatabaseAdapter.sqlite3(Uri uri) => sqlite3Adapter(uri);

  /// Create a Postgres [DatabaseAdapter] using [pool].
  ///
  /// Calling [close] on the returned [DatabaseAdapter] will close [pool].
  factory DatabaseAdapter.postgres(Pool<void> pool) => postgresAdapter(pool);

  /// Wrap [adapter] as [DatabaseAdapter].
  ///
  /// This returns a [DatabaseAdapter] that awaits the future before
  /// calling forwarding the requested operation.
  factory DatabaseAdapter.fromFuture(Future<DatabaseAdapter> adapter) =>
      futureDatabaseAdapter(adapter);

  /// Create an SQLite in-memory database for testing.
  ///
  /// This will create an SQLite3 database that runs entirely in-memory and is
  /// suitable for testing. You can create multiple databases at the same time,
  /// and they will not interfere with each other.
  ///
  /// When [close] is called the memory will be released, and
  /// any data stored in the database will be gone.
  ///
  /// {@macro sqlite-dependency}
  @visibleForTesting
  factory DatabaseAdapter.sqlite3TestDatabase() =>
      futureDatabaseAdapter(sqlite3TestingDatabaseAdapter());

  /// Create an ephemeral postgres database for testing.
  ///
  /// This assumes that a postgres server is running and admin priviledges are
  /// available when connecting with:
  ///  * [host], read from `$PGHOST` if `null`, and defaults to `'127.0.0.1'`,
  ///  * [port], read from `$PGPORT` if `null`, and defaults to `5432`,
  ///  * [database], read from `$PGDATABASE` if `null`, and defaults to
  ///    `'postgres'`,
  ///  * [user], read from `$PGUSER` if `null`, and defaults to `'postgres'`,
  ///  * [password], read from `$PGPASSWORD` if `null`, and defaults to
  ///    `'postgres'`.
  ///
  /// This will connect to postgres, use `CREATE DATABASE "testdb-<uuid>"` to
  /// create an empty database for testing, and return a [DatabaseAdapter] for
  /// that database. When [close] is called the test database will be deleted.
  ///
  /// You can launch a postgres database for local testing with:
  /// ```sh
  /// docker run \
  ///   -ti --rm \
  ///   -e POSTGRES_PASSWORD=postgres \
  ///   -p 127.0.0.1:5432:5432 \
  ///   postgres:17
  /// ```
  ///
  /// If running tests on Github Actions you can add a postgres service to your
  /// workflows jobs with:
  /// ```yaml
  /// runs-on: ubuntu-latest
  /// services:
  ///   postgres:
  ///     image: postgres:17
  ///     env:
  ///       POSTGRES_PASSWORD: postgres
  ///     options: >-
  ///       --health-cmd pg_isready
  ///       --health-interval 10s
  ///       --health-timeout 5s
  ///       --health-retries 5
  ///     ports:
  ///       - 5432:5432
  /// steps:
  ///  - ...
  /// ```
  /// See Github Actions documentation on
  /// [creating PostgreSQL service containers](https://docs.github.com/en/actions/use-cases-and-examples/using-containerized-services/creating-postgresql-service-containers)
  /// for details.
  @visibleForTesting
  factory DatabaseAdapter.postgresTestDatabase({
    String? host,
    int? port,
    String? database,
    String? user,
    String? password,
  }) =>
      futureDatabaseAdapter(postgresTestingDatabaseAdapter(
        host: host,
        port: port,
        database: database,
        user: user,
        password: password,
      ));

  /// Wrap [adapter] such that [close] calls [onClosed] instead of
  /// `adapter.close`.
  ///
  /// > [!NOTE]
  /// > [adapter] will not be closed when [close] is called on the returned
  /// > [DatabaseAdapter].
  factory DatabaseAdapter.withOnClose(
    DatabaseAdapter adapter,
    Future<void> Function({required bool force}) onClosed,
  ) =>
      withOnCloseDatabaseAdapter(adapter, onClosed);

  /// Wrap [adapter] such that [close] is a no-op!
  ///
  /// > [!NOTE]
  /// > [adapter] will not be closed when [close] is called on the returned
  /// > [DatabaseAdapter].
  factory DatabaseAdapter.withNopClose(DatabaseAdapter adapter) =>
      withOnCloseDatabaseAdapter(adapter, ({required bool force}) async {});

  /// Wrap [adapter] such that all queries are written to [log].
  ///
  /// > [!WARNING]
  /// > The format of log messages written are not covered by version
  /// > compatibility guarantees.
  ///
  /// This is intended for debugging purposes, and pairs nicely with
  /// [printOnFailure] from `package:test/test.dart`.
  factory DatabaseAdapter.withLogging(
    DatabaseAdapter adapter,
    void Function(String message) log,
  ) =>
      loggingAdapter(adapter, log);
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
