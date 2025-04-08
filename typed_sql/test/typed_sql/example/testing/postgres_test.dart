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

@Skip('Tests for this package uses a unix domain socket for postgres')
library;

import 'package:test/test.dart' show Skip;

// #region testing
import 'package:test/test.dart' show addTearDown, test;
import 'package:typed_sql/typed_sql.dart';

import 'model.dart';

void main() {
  test('test with postgres database', () async {
    final adaptor = DatabaseAdaptor.postgresTestDatabase();
    // Always remember to close the adaptor. This will delete the test database!
    addTearDown(adaptor.close);

    final db = Database<Bookstore>(adaptor, SqlDialect.postgres());

    // Create tables in the empty test database
    await db.createTables();

    // ...
  });
}
// #endregion
