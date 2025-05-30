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
import 'dart:convert';
import 'dart:io';

import 'package:checks/context.dart';
import 'package:meta/meta.dart';
import 'package:test/test.dart';
import 'package:typed_sql/src/adapter/mysql_adaptor.dart'
    show mysqlTestingAdaptor;
import 'package:typed_sql/src/dialect/mysql_dialect.dart';
import 'package:typed_sql/typed_sql.dart';

export 'package:checks/checks.dart';
export 'package:test/test.dart' show fail;

final class TestRunner<T extends Schema> {
  final bool _resetDatabaseForEachTest;

  final _tests = <({
    String name,
    FutureOr<void> Function(Database<T> db) fn,
    String? skipSqlite,
    String? skipPostgres,
    String? skipMysql,
  })>[];

  final FutureOr<void> Function(Database<T> db)? _setup;
  final FutureOr<void> Function(Database<T> db)? _validate;

  TestRunner({
    bool resetDatabaseForEachTest = true,
    FutureOr<void> Function(Database<T> db)? setup,
    FutureOr<void> Function(Database<T> db)? validate,
  })  : _setup = setup,
        _validate = validate,
        _resetDatabaseForEachTest = resetDatabaseForEachTest;

  @isTest
  void addTest(
    String name,
    FutureOr<void> Function(Database<T> db) fn, {
    String? skipSqlite,
    String? skipPostgres,
    String? skipMysql,
  }) =>
      _tests.add((
        name: name,
        fn: fn,
        skipSqlite: skipSqlite,
        skipPostgres: skipPostgres,
        skipMysql: skipMysql,
      ));

  late final String? _getPostgresSocket = () {
    final socketFile = File('.dart_tool/run/postgresql/.s.PGSQL.5432');
    if (socketFile.existsSync()) {
      return socketFile.absolute.path;
    }
    return null;
  }();

  late final String? _getMysqlSocket = () {
    final socketFile = File('.dart_tool/run/mariadb/mysqld.sock');
    if (socketFile.existsSync()) {
      return socketFile.absolute.path;
    }
    return null;
  }();

  DatabaseAdapter _getPostgres() {
    return DatabaseAdapter.postgresTestDatabase(host: _getPostgresSocket);
  }

  DatabaseAdapter _getMysql() {
    return mysqlTestingAdaptor(host: _getMysqlSocket);
  }

  void run() {
    DatabaseAdapter Function() getSqlite;
    DatabaseAdapter Function() getPostgres;
    DatabaseAdapter Function() getMysql;

    if (_resetDatabaseForEachTest) {
      getSqlite = DatabaseAdapter.sqlite3TestDatabase;
      getPostgres = _getPostgres;
      getMysql = _getMysql;
    } else {
      late DatabaseAdapter sqlite;
      getSqlite = () => DatabaseAdapter.withNopClose(sqlite);

      late DatabaseAdapter postgres;
      getPostgres = () => DatabaseAdapter.withNopClose(postgres);

      late DatabaseAdapter mysql;
      getMysql = () => DatabaseAdapter.withNopClose(mysql);

      setUpAll(() async {
        sqlite = DatabaseAdapter.sqlite3TestDatabase();
        postgres = _getPostgres();
        mysql = _getMysql();
      });
      tearDownAll(() async {
        await sqlite.close();
        await postgres.close();
        await mysql.close();
      });
    }

    for (final testcase in _tests) {
      test('${testcase.name} (variant: sqlite)', () async {
        if (testcase.skipSqlite != null) {
          markTestSkipped(testcase.skipSqlite!);
          return;
        }

        final adapter =
            DatabaseAdapter.withLogging(getSqlite(), printOnFailure);
        final db = Database<T>(adapter, SqlDialect.sqlite());

        try {
          if (_setup != null) {
            await _setup(db);
          }

          await testcase.fn(db);

          if (_validate != null) {
            await _validate(db);
          }
        } finally {
          await adapter.close();
        }
      });
    }

    for (final testcase in _tests) {
      test('${testcase.name} (variant: postgres)', () async {
        if (testcase.skipPostgres != null) {
          markTestSkipped(testcase.skipPostgres!);
          return;
        }

        final adapter =
            DatabaseAdapter.withLogging(getPostgres(), printOnFailure);
        final db = Database<T>(adapter, SqlDialect.postgres());

        try {
          if (_setup != null) {
            await _setup(db);
          }

          await testcase.fn(db);

          if (_validate != null) {
            await _validate(db);
          }
        } finally {
          await adapter.close(force: true);
        }
      });
    }

    for (final testcase in _tests) {
      test('${testcase.name} (variant: mysql)', () async {
        if (testcase.skipMysql != null) {
          markTestSkipped(testcase.skipMysql!);
          return;
        }

        final adapter = DatabaseAdapter.withLogging(getMysql(), printOnFailure);
        final db = Database<T>(adapter, mysqlDialect());

        try {
          if (_setup != null) {
            await _setup(db);
          }

          await testcase.fn(db);

          if (_validate != null) {
            await _validate(db);
          }
        } finally {
          await adapter.close(force: true);
        }
      });
    }
  }
}

extension JsonValueSubjectExt on Subject<JsonValue> {
  void deepEquals(JsonValue other) =>
      context.expect(() => ['matches JSON'], (v) {
        if (json.encode(v.value) == json.encode(other.value)) {
          return null;
        }
        return Rejection();
      });
}
