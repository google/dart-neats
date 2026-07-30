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

import 'package:checks/checks.dart';
import 'package:test/test.dart';
import 'package:typed_sql/typed_sql.dart';

import '../index_ddl_helpers.dart';
import 'gist_index_test.dart' hide main;

void main() {
  test(
    'Postgres emits `USING GIST` and round-trips data (needs btree_gist)',
    () async {
      final ddl = await capturePostgresDdl<ContactDirectory>((
        adapter,
        db,
      ) async {
        // A GiST index on `text` has no default operator class; enabling
        // `btree_gist` is a prerequisite the application must handle itself.
        await adapter.script('CREATE EXTENSION IF NOT EXISTS btree_gist;');
        await db.createTables();

        await db.contacts.insertValue(email: 'jane@example.com').execute();
        final item = await db.contacts.first.fetch();
        check(item).isNotNull().email.equals('jane@example.com');
      });
      if (ddl == null) return;

      check(ddl).contains('USING GIST ("email")');
    },
  );

  test('SQLite drops GIST and falls back to a plain index', () async {
    final ddl = await captureSqliteDdl<ContactDirectory>(
      (adapter, db) => db.createTables(),
    );

    check(ddl).contains('CREATE INDEX');
    check(ddl).not((d) => d.contains('GIST'));
  });

  test('MySQL/MariaDB drops GIST and falls back to a plain index', () async {
    final ddl = await captureMariadbDdl<ContactDirectory>(
      (adapter, db) => db.createTables(),
    );
    if (ddl == null) return;

    check(ddl).contains('CREATE INDEX');
    check(ddl).not((d) => d.contains('GIST'));
  });
}
