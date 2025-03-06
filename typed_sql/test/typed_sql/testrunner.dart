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

import 'package:test/test.dart';
import 'package:typed_sql/typed_sql.dart';

export 'package:checks/checks.dart';

var _testFileCounter = 0;

final class TestRunner<T extends Schema> {
  final _tests = <({
    String name,
    FutureOr<void> Function(Database<T> db) fn,
    String? skipSqlite,
  })>[];

  final FutureOr<void> Function(Database<T> db)? _setup;
  final FutureOr<void> Function(Database<T> db)? _validate;

  TestRunner({
    FutureOr<void> Function(Database<T> db)? setup,
    FutureOr<void> Function(Database<T> db)? validate,
  })  : _setup = setup,
        _validate = validate;

  void addTest(
    String name,
    FutureOr<void> Function(Database<T> db) fn, {
    String? skipSqlite,
  }) =>
      _tests.add((
        name: name,
        fn: fn,
        skipSqlite: skipSqlite,
      ));

  void run() {
    for (final testcase in _tests) {
      group('sqlite', () {
        test(testcase.name, () async {
          await Future<void>.delayed(Duration.zero);

          if (testcase.skipSqlite != null) {
            markTestSkipped(testcase.skipSqlite!);
          }

          _testFileCounter++;
          final filename = [
            DateTime.now().microsecondsSinceEpoch,
            _testFileCounter,
          ].join('-');
          final u =
              Uri.parse('file:inmemory-$filename?mode=memory&cache=shared');
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
      });
    }
  }
}
