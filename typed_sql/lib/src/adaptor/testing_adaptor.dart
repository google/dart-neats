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
import 'dart:io';

import 'package:postgres/postgres.dart';

import '../utils/uuid.dart';
import 'adaptor.dart';
import 'wrapclose_adaptor.dart';

Future<DatabaseAdaptor> sqlite3TestingDatabaseAdaptor() async {
  final u = Uri.parse('file:inmemory-${uuid()}?mode=memory&cache=shared');
  return DatabaseAdaptor.sqlite3(u);
}

Future<DatabaseAdaptor> postgresTestingDatabaseAdaptor() async {
  final host = Platform.environment['PGHOST'] ?? '127.0.0.1';
  final port = int.tryParse(Platform.environment['PGPORT'] ?? '') ?? 5432;
  final database = Platform.environment['PGDATABASE'] ?? 'postgres';
  final user = Platform.environment['PGUSER'] ?? 'postgres';
  final password = Platform.environment['PGPASSWORD'] ?? 'postgres';

  final admin = Pool<Never>.withEndpoints([
    Endpoint(
      host: host,
      port: port,
      database: database,
      username: user,
      password: password,
    ),
  ], settings: const PoolSettings(sslMode: SslMode.disable));

  final testdb = 'testdb-${uuid()}';

  await admin.execute('CREATE DATABASE "$testdb"');

  final pool = Pool<Never>.withEndpoints([
    Endpoint(
      host: host,
      port: port,
      database: testdb,
      username: user,
      password: password,
    ),
  ], settings: const PoolSettings(sslMode: SslMode.disable));

  var closing = false;
  final closed = Completer<void>();
  final adaptor = DatabaseAdaptor.postgres(pool);
  return withOnCloseDatabaseAdaptor(adaptor, ({
    required bool force,
  }) async {
    try {
      await adaptor.close(force: force);
    } finally {}
    if (!closing) {
      closing = true;
      closed.complete(() async {
        try {
          await admin.execute('DROP DATABASE "$testdb" WITH (FORCE)');
        } finally {
          try {
            await admin.close(force: true);
          } finally {
            try {
              await pool.close(force: true);
            } catch (e) {
              // ignore
            }
          }
        }
      }());
    }

    return await closed.future;
  });
}
