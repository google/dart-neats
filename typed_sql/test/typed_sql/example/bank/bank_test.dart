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

import 'package:typed_sql/typed_sql.dart';

import '../../testrunner.dart';

part 'bank_test.g.dart';

// #region schema
abstract final class BankVault extends Schema {
  Table<Account> get accounts;
}

@PrimaryKey(['accountId'])
abstract final class Account extends Model {
  @AutoIncrement()
  int get accountId;

  @Unique()
  String get accountNumber;

  @DefaultValue(0.0)
  double get balance;
}
// #endregion

// #region initial-data
final initialAccounts = [
  (accountNumber: '0001', balance: 100.0),
  (accountNumber: '0002', balance: 200.0),
  (accountNumber: '0003', balance: 300.0),
];
// #endregion

final class InsufficientBalanceException implements Exception {}

final class AccountNotFoundException implements Exception {}

void main() {
  final r = TestRunner<BankVault>(
    setup: (db) async {
      await db.createTables();

      // Insert test Authors and books
      for (final v in initialAccounts) {
        await db.accounts
            .insert(
              accountNumber: toExpr(v.accountNumber),
              balance: toExpr(v.balance),
            )
            .execute();
      }
    },
  );

  r.addTest('transfer 100', (db) async {
    // #region transfer-100
    await db.transact(() async {
      // Withdraw 100 from account 0000-01
      await db.accounts
          // We can use `.byAccountNumber()` because the `accountNumber` field
          // is annotated with @Unique()
          .byAccountNumber('0001')
          .update((a, set) => set(balance: a.balance - toExpr(100)))
          .execute();

      // Deposit 100 to account 0000-02
      await db.accounts
          .byAccountNumber('0002')
          .update((a, set) => set(balance: a.balance + toExpr(100)))
          .execute();
    });
    // #endregion
  });

  r.addTest('transfer 100 with rollback', (db) async {
    // #region transfer-100-with-rollback
    try {
      await db.transact(() async {
        // Withdraw 100 from account 0000-01
        final newBalance = await db.accounts
            .byAccountNumber('0001')
            .update((a, set) => set(balance: a.balance - toExpr(100)))
            .returning((a) => (a.balance,))
            .executeAndFetch();
        if (newBalance == null) {
          throw AccountNotFoundException();
        }
        if (newBalance < 0) {
          // If balance is negative we throw an Exception to rollback the
          // transaction
          throw InsufficientBalanceException();
        }

        // Deposit 100 to account 0000-02
        await db.accounts
            .byAccountNumber('0002')
            .update((a, set) => set(balance: a.balance + toExpr(100)))
            .execute();
      });
    } on TransactionAbortedException catch (e) {
      switch (e.reason) {
        case InsufficientBalanceException():
          print('Transfer was aborted due to insufficient balance');
        case AccountNotFoundException():
          print('Transfer was aborted as account was not found');
        default:
          rethrow;
      }
    }
    // #endregion
  });

  r.addTest('transfer 100 conditional update', (db) async {
    // #region transfer-100-with-conditional-update
    await db.transact(() async {
      // Withdraw 100 from account 0000-01
      final newBalance = await db.accounts
          .byAccountNumber('0001')
          .where((a) => a.balance >= toExpr(100))
          .update((a, set) => set(balance: a.balance - toExpr(100)))
          .returning((a) => (a.balance,))
          .executeAndFetch();
      if (newBalance == null) {
        print('account not found or insufficient balance');
        return;
      }

      // Deposit 100 to account 0000-02
      await db.accounts
          .byAccountNumber('0002')
          .update((a, set) => set(balance: a.balance + toExpr(100)))
          .execute();
    });
    // #endregion
  });

  r.addTest('insert or update using nested transaction', (db) async {
    // #region insert-or-update-using-nested-transaction
    await db.transact(() async {
      await db.accounts
          .byAccountNumber('0001')
          .update((a, set) => set(balance: a.balance - toExpr(100)))
          .execute();

      try {
        await db.transact(() async {
          await db.accounts
              .insert(
                accountNumber: toExpr('0002'),
                balance: toExpr(100),
              )
              .execute();
        });
      } on TransactionAbortedException {
        await db.accounts
            .byAccountNumber('0002')
            .update((a, set) => set(balance: a.balance + toExpr(100)))
            .execute();
      }
    });
    // #endregion
  });

  r.run();
}
