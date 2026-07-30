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

import '../index_ddl_helpers.dart';
import 'gin_index_test.dart' hide main;

void main() {
  test('Postgres emits `USING GIN` for method: .gin indexes', () async {
    final ddl = await capturePostgresDdl<ProductCatalog>(
      (adapter, db) => db.createTables(),
    );
    if (ddl == null) return;

    check(ddl).contains('USING GIN ("metadata")');
    check(ddl).contains('USING GIN ("tags")');
  });

  test('SQLite falls back to a plain index for method: .gin indexes', () async {
    final ddl = await captureSqliteDdl<ProductCatalog>(
      (adapter, db) => db.createTables(),
    );

    check(ddl).contains('CREATE INDEX');
    check(ddl).not((d) => d.contains('USING GIN'));
  });

  test(
    'MySQL/MariaDB falls back to a plain index for method: .gin indexes',
    () async {
      final ddl = await captureMariadbDdl<ProductCatalog>(
        (adapter, db) => db.createTables(),
      );
      if (ddl == null) return;

      check(ddl).contains('CREATE INDEX');
      check(ddl).not((d) => d.contains('USING GIN'));
    },
  );
}
