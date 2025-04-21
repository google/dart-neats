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

import 'package:typed_sql/typed_sql.dart';

import '../../testrunner.dart';

part 'unique_nullable_test.g.dart';

abstract final class BankVault extends Schema {
  Table<Account> get accounts;
}

@PrimaryKey(['accountId'])
abstract final class Account extends Model {
  @AutoIncrement()
  int get accountId;

  @Unique()
  String? get accountNumber;

  @DefaultValue(0.0)
  double get balance;
}

void main() {
  final r = TestRunner<BankVault>(
    setup: (db) async {
      await db.createTables();
    },
  );

  r.addTest('db.account.insert', (db) async {
    await db.accounts.insert(accountNumber: toExpr('0001')).execute();
    await db.accounts.insert(accountNumber: toExpr('0002')).execute();
  });

  r.addTest('db.account.insert(accountNumber: null)', (db) async {
    await db.accounts.insert(accountNumber: toExpr('0001')).execute();
    await db.accounts.insert(accountNumber: toExpr(null)).execute();
  });

  r.addTest('db.account.insert(accountNumber: null) - twice', (db) async {
    await db.accounts.insert(accountNumber: toExpr('0001')).execute();
    await db.accounts.insert(accountNumber: toExpr(null)).execute();
    await db.accounts.insert(accountNumber: toExpr(null)).execute();
  });

  r.addTest('db.account.insert (unqiue violation)', (db) async {
    await db.accounts.insert(accountNumber: toExpr('0001')).execute();
    try {
      await db.accounts.insert(accountNumber: toExpr('0001')).execute();
      fail('expected violation of unique constraint!');
    } on OperationException {
      return;
    }
  });

  r.addTest('db.account.byAccountNumber()', (db) async {
    await db.accounts.insert(accountNumber: toExpr('0001')).execute();
    await db.accounts.insert(accountNumber: toExpr('0002')).execute();

    final account = await db.accounts.byAccountNumber('0001').fetch();
    check(account).isNotNull()
      ..accountNumber.equals('0001')
      ..balance.equals(0.0);
  });

  r.addTest('db.account.byAccountNumber() - not found', (db) async {
    await db.accounts.insert(accountNumber: toExpr('0001')).execute();
    await db.accounts.insert(accountNumber: toExpr('0002')).execute();

    final account = await db.accounts.byAccountNumber('0003').fetch();
    check(account).isNull();
  });

  r.addTest('db.account.byAccountNumber is! QuerySingle Function(String?)',
      (db) async {
    // This should not be allowed, because multiple rows with NULL is allowed!
    check(db.accounts.byAccountNumber)
        .not((s) => s.isA<QuerySingle Function(String?)>());
  });

  r.addTest('db.account.byAccountNumber is QuerySingle Function(String)',
      (db) async {
    check(db.accounts.byAccountNumber).isA<QuerySingle Function(String)>();
  });

  r.run();
}
