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

import 'package:meta/meta.dart';
import 'package:test/test.dart';
import 'package:typed_sql/typed_sql.dart';

import '../testutil/postgres_manager.dart';

export 'package:checks/checks.dart';

var _testFileCounter = 0;

final class TestRunner<T extends Schema> {
  final _pg = PostgresManager();

  final _tests = <({
    String name,
    FutureOr<void> Function(Database<T> db) fn,
    String? skipSqlite,
    String? skipPostgres,
  })>[];

  final FutureOr<void> Function(Database<T> db)? _setup;
  final FutureOr<void> Function(Database<T> db)? _validate;

  TestRunner({
    FutureOr<void> Function(Database<T> db)? setup,
    FutureOr<void> Function(Database<T> db)? validate,
  })  : _setup = setup,
        _validate = validate;

  @isTest
  void addTest(
    String name,
    FutureOr<void> Function(Database<T> db) fn, {
    String? skipSqlite,
    String? skipPostgres,
  }) =>
      _tests.add((
        name: name,
        fn: fn,
        skipSqlite: skipSqlite,
        skipPostgres: skipPostgres,
      ));

  void run() {
    for (final testcase in _tests) {
      test('${testcase.name} (variant: sqlite)', () async {
        if (testcase.skipSqlite != null) {
          markTestSkipped(testcase.skipSqlite!);
          return;
        }

        _testFileCounter++;
        final filename = [
          DateTime.now().microsecondsSinceEpoch,
          _testFileCounter,
        ].join('-');
        final u = Uri.parse('file:inmemory-$filename?mode=memory&cache=shared');
        final adaptor = DatabaseAdaptor.withLogging(
          DatabaseAdaptor.sqlite3(u),
          printOnFailure,
        );
        final db = Database<T>(adaptor, SqlDialect.sqlite());

        try {
          if (_setup != null) {
            await _setup(db);
          }

          await testcase.fn(db);

          if (_validate != null) {
            await _validate(db);
          }
        } finally {
          try {
            await adaptor.close();
          } catch (e) {
            // ignore
          }
        }
      });
    }

    final skipPg = !_pg.isAvailable
        ? 'postgres unavailable, try ./tool/run_postgres_test_server.sh'
        : null;

    for (final testcase in _tests) {
      test('${testcase.name} (variant: postgres)', () async {
        if (testcase.skipPostgres != null) {
          markTestSkipped(testcase.skipPostgres!);
          return;
        }

        final pool = await _pg.getPool();
        try {
          final adaptor = DatabaseAdaptor.withLogging(
            DatabaseAdaptor.postgres(pool),
            printOnFailure,
          );
          final db = Database<T>(adaptor, SqlDialect.postgres());

          try {
            if (_setup != null) {
              await _setup(db);
            }

            await testcase.fn(db);

            if (_validate != null) {
              await _validate(db);
            }
          } finally {
            try {
              await adaptor.close();
            } catch (e) {
              // ignore
            }
          }
        } finally {
          await pool.close(force: true);
        }
      }, skip: skipPg);
    }
  }
}
