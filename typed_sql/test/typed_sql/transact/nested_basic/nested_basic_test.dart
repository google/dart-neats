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

import 'package:typed_sql/typed_sql.dart';
import '../../testrunner.dart';

part 'nested_basic_test.g.dart';

abstract final class BankVault extends Schema {
  Table<Account> get accounts;
}

@PrimaryKey(['accountId'])
abstract final class Account extends Row {
  @AutoIncrement()
  int get accountId;

  @Unique.field()
  @SqlOverride(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String get accountNumber;

  @DefaultValue(0.0)
  double get balance;
}

void main() {
  final r = TestRunner<BankVault>(
    setup: (db) async {
      await db.createTables();
    },
  );

  r.addTest('Basic nested transaction (savepoint) rollback', (db) async {
    await db.accounts
        .insertValue(accountNumber: '0001', balance: 100.0)
        .execute();

    await db.transact(() async {
      // Update in outer transaction
      await db.accounts
          .byAccountNumber('0001')
          .update((a, set) => set(balance: toExpr(200.0)))
          .execute();

      try {
        await db.transact(() async {
          // Update in inner transaction
          await db.accounts
              .byAccountNumber('0001')
              .update((a, set) => set(balance: toExpr(300.0)))
              .execute();

          // Abort inner transaction
          throw Exception('Abort inner');
        });
      } on TransactionAbortedException {
        // Expected
      }

      // Outer transaction should still see its own update (200), not inner (300)
      final item = await db.accounts.byAccountNumber('0001').fetch();
      check(item).isNotNull().balance.equals(200.0);
    });

    // After commit, should still be 200
    final item = await db.accounts.byAccountNumber('0001').fetch();
    check(item).isNotNull().balance.equals(200.0);
  });

  r.run();
}
