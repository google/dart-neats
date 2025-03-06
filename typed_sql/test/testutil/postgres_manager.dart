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

import 'dart:io';
import 'dart:isolate';

import 'package:postgres/postgres.dart';
import 'package:slugid/slugid.dart';

/// Creates postgres databases for testing.
///
/// The postgres database is expected to be started by
/// `tool/run_postgres_test_server.sh`.
final class PostgresManager {
  final _socketUri =
      Isolate.resolvePackageUriSync(Uri.parse('package:typed_sql/'))
          ?.resolve('../.dart_tool/run/postgresql/.s.PGSQL.5432');

  final _pools = <Pool<Never>>[];
  Pool<Never>? _adminPool;
  bool _closed = false;

  bool get isAvailable {
    if (_socketUri == null) {
      return false;
    }
    return File.fromUri(_socketUri).existsSync();
  }

  Pool<Never> _getAdminPool() {
    if (!isAvailable || _socketUri == null) {
      throw StateError(
        'postgres is not available, did you start '
        'tool/run_postgres_test_server.sh',
      );
    }
    if (_closed) {
      throw StateError('PostgresManager.close() has already been called!');
    }
    return _adminPool ??= Pool<Never>.withEndpoints([
      Endpoint(
        host: _socketUri.toFilePath(),
        isUnixSocket: true,
        database: 'postgres',
        username: 'postgres',
      ),
    ], settings: const PoolSettings(sslMode: SslMode.disable));
  }

  Future<Pool<Never>> getPool() async {
    final adminPool = _getAdminPool();
    return await adminPool.run((db) async {
      final testdb = 'test_${Slugid.nice()}';
      await db.execute('CREATE DATABASE "$testdb"');

      final pool = Pool<Never>.withEndpoints([
        Endpoint(
          host: _socketUri!.toFilePath(),
          isUnixSocket: true,
          database: testdb,
          username: 'postgres',
        ),
      ], settings: const PoolSettings(sslMode: SslMode.disable));

      _pools.add(pool);
      return pool;
    });
  }

  void close() {
    if (_closed) {
      return;
    }
    _closed = true;

    for (final pool in _pools) {
      pool.close(force: true);
    }
    _pools.clear();
    _adminPool?.close(force: true);
    _adminPool = null;
  }
}
