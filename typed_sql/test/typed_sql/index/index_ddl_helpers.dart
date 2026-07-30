// Copyright 2026 Google LLC
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

import 'dart:io';

import 'package:test/test.dart';
import 'package:typed_sql/src/adapter/mysql_adapter.dart'
    show mysqlTestingAdapter;
import 'package:typed_sql/src/dialect/mysql_dialect.dart';
import 'package:typed_sql/typed_sql.dart';

/// Runs [body] against a live Postgres test database, wrapped in a logging
/// [DatabaseAdapter], and returns the SQL text it logged (joined by `\n`).
///
/// [body] is given both the raw [DatabaseAdapter] (to run bootstrap SQL,
/// e.g. `CREATE EXTENSION`, before/around [Database] calls) and the
/// constructed `Database<T>`.
///
/// Returns `null` (after calling [markTestSkipped]) if no local Postgres
/// test database is available.
Future<String?> capturePostgresDdl<T extends Schema>(
  Future<void> Function(DatabaseAdapter adapter, Database<T> db) body,
) async {
  final socketFile = File('.dart_tool/run/postgresql/.s.PGSQL.5432');
  if (!socketFile.existsSync() &&
      Platform.environment['POSTGRES_PORT'] == null) {
    markTestSkipped('No local postgres test database available');
    return null;
  }

  final logs = <String>[];
  final adapter = DatabaseAdapter.withLogging(
    DatabaseAdapter.postgresTestDatabase(
      host: socketFile.existsSync() ? socketFile.absolute.path : null,
      port: int.tryParse(Platform.environment['POSTGRES_PORT'] ?? ''),
    ),
    logs.add,
  );
  try {
    await body(adapter, Database<T>(adapter, SqlDialect.postgres()));
  } finally {
    await adapter.close(force: true);
  }
  return logs.join('\n');
}

/// Runs [body] against a fresh in-memory SQLite database, wrapped in a
/// logging [DatabaseAdapter], and returns the SQL text it logged (joined by
/// `\n`).
Future<String> captureSqliteDdl<T extends Schema>(
  Future<void> Function(DatabaseAdapter adapter, Database<T> db) body,
) async {
  final logs = <String>[];
  final adapter = DatabaseAdapter.withLogging(
    DatabaseAdapter.sqlite3TestDatabase(),
    logs.add,
  );
  try {
    await body(adapter, Database<T>(adapter, SqlDialect.sqlite()));
  } finally {
    await adapter.close();
  }
  return logs.join('\n');
}

/// Runs [body] against a live MySQL/MariaDB test database, wrapped in a
/// logging [DatabaseAdapter], and returns the SQL text it logged (joined by
/// `\n`).
///
/// Returns `null` (after calling [markTestSkipped]) if no local
/// MySQL/MariaDB test database is available.
Future<String?> captureMariadbDdl<T extends Schema>(
  Future<void> Function(DatabaseAdapter adapter, Database<T> db) body,
) async {
  final socketFile = File('.dart_tool/run/mariadb/mysqld.sock');
  if (!socketFile.existsSync() &&
      Platform.environment['MARIADB_PORT'] == null) {
    markTestSkipped('No local mariadb test database available');
    return null;
  }

  final logs = <String>[];
  final adapter = DatabaseAdapter.withLogging(
    mysqlTestingAdapter(
      host: socketFile.existsSync() ? socketFile.absolute.path : null,
      port: int.tryParse(Platform.environment['MARIADB_PORT'] ?? ''),
    ),
    logs.add,
  );
  try {
    await body(adapter, Database<T>(adapter, mysqlDialect()));
  } finally {
    await adapter.close();
  }
  return logs.join('\n');
}
