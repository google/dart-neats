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

part 'hash_index_test.g.dart';

abstract final class AccountDatabase extends Schema {
  Table<Account> get accounts;
}

@PrimaryKey(['id'])
abstract final class Account extends Row {
  @AutoIncrement()
  int get id;

  @Index.field(method: .hash)
  @SqlOverride.field(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String get email;
}

void main() {
  final r = TestRunner<AccountDatabase>(
    setup: (db) async {
      await db.createTables();
    },
  );

  r.addTest('createTables() succeeds with a HASH index', (db) async {
    await db.accounts.insertValue(email: 'jane@example.com').execute();

    final item = await db.accounts.first.fetch();
    check(item).isNotNull().email.equals('jane@example.com');
  });

  r.run();
}
