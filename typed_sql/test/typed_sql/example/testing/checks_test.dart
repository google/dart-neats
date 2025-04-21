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

import 'package:checks/checks.dart';
import 'package:test/test.dart' show addTearDown, test;
import 'package:typed_sql/typed_sql.dart';

import 'model.dart';

void main() {
  test('assertions with check()', () async {
    final adapter = DatabaseAdapter.sqlite3TestDatabase();
    addTearDown(adapter.close);

    final db = Database<BankVault>(adapter, SqlDialect.sqlite());

    await db.createTables();

    // #region check-account
    // Create a new account
    await db.accounts.insert(accountNumber: toExpr('0000-001')).execute();

    // Fetch the created account
    final account = await db.accounts.byAccountNumber('0000-001').fetch();
    // Check that the default balance is not positive
    check(account).isNotNull().balance.isLessOrEqual(0);
    // #endregion
  });
}
