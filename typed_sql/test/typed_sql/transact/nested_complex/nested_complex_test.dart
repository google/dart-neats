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

part 'nested_complex_test.g.dart';

abstract final class BankVault extends Schema {
  Table<Account> get accounts;
}

@PrimaryKey(['accountId'])
abstract final class Account extends Row {
  @AutoIncrement()
  int get accountId;

  @Unique.field()
  @SqlOverride.field(dialect: 'mysql', columnType: 'VARCHAR(255)')
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

  r.addTest('Complex nested transaction with partial rollback', (db) async {
    await db.accounts
        .insertValue(accountNumber: '0001', balance: 100.0)
        .execute();
    await db.accounts
        .insertValue(accountNumber: '0002', balance: 200.0)
        .execute();

    await db.transact(() async {
      await db.accounts
          .byAccountNumber('0001')
          .update((a, set) => set(balance: toExpr(150.0)))
          .execute();

      await db.transact(() async {
        await db.accounts
            .byAccountNumber('0002')
            .update((a, set) => set(balance: toExpr(250.0)))
            .execute();

        try {
          await db.transact(() async {
            await db.accounts
                .byAccountNumber('0001')
                .update((a, set) => set(balance: toExpr(999.0)))
                .execute();
            throw Exception('Abort level 3');
          });
        } on TransactionAbortedException {
          // Expected
        }

        // Level 2 should see its own update (250) and level 1 update (150), but NOT level 3 (999)
        final a1 = await db.accounts.byAccountNumber('0001').fetch();
        check(a1).isNotNull().balance.equals(150.0);

        final a2 = await db.accounts.byAccountNumber('0002').fetch();
        check(a2).isNotNull().balance.equals(250.0);
      });

      // Level 1 should see its own update (150) and level 2 update (250) because level 2 committed!
      final a1 = await db.accounts.byAccountNumber('0001').fetch();
      check(a1).isNotNull().balance.equals(150.0);

      final a2 = await db.accounts.byAccountNumber('0002').fetch();
      check(a2).isNotNull().balance.equals(250.0);
    });

    // After outer commit, all changes from level 1 and level 2 should be visible!
    final a1 = await db.accounts.byAccountNumber('0001').fetch();
    check(a1).isNotNull().balance.equals(150.0);

    final a2 = await db.accounts.byAccountNumber('0002').fetch();
    check(a2).isNotNull().balance.equals(250.0);
  });

  r.run();
}
