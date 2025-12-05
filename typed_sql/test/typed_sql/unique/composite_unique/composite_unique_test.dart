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

part 'composite_unique_test.g.dart';

abstract final class PrimaryDatabase extends Schema {
  Table<User> get users;
}

@PrimaryKey(['accountId'])
@Unique(name: 'fullname', fields: ['firstName', 'lastName'])
abstract final class User extends Row {
  @AutoIncrement()
  int get accountId;

  @SqlOverride(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String get firstName;

  @SqlOverride(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String get lastName;
}

void main() {
  final r = TestRunner<PrimaryDatabase>(
    setup: (db) async {
      await db.createTables();
    },
  );

  r.addTest('db.users.insert', (db) async {
    await db.users
        .insert(
          firstName: toExpr('Bucks'),
          lastName: toExpr('Bunny'),
        )
        .execute();
  });

  r.addTest('db.users.insert (unique violation)', (db) async {
    await db.users
        .insert(
          firstName: toExpr('Bucks'),
          lastName: toExpr('Bunny'),
        )
        .execute();
    try {
      await db.users
          .insert(
            firstName: toExpr('Bucks'),
            lastName: toExpr('Bunny'),
          )
          .execute();
      fail('expected violation of unique constraint!');
    } on OperationException {
      return;
    }
  });

  r.addTest('db.users.byFullname()', (db) async {
    await db.users
        .insert(
          firstName: toExpr('Bucks'),
          lastName: toExpr('Bunny'),
        )
        .execute();
    await db.users
        .insert(
          firstName: toExpr('Donald'),
          lastName: toExpr('Duck'),
        )
        .execute();

    final users = await db.users.byFullname('Bucks', 'Bunny').fetch();
    check(users).isNotNull()
      ..firstName.equals('Bucks')
      ..lastName.equals('Bunny');
  });

  r.addTest('db.users.byFullname() - not found', (db) async {
    await db.users
        .insert(
          firstName: toExpr('Bucks'),
          lastName: toExpr('Bunny'),
        )
        .execute();
    await db.users
        .insert(
          firstName: toExpr('Easter'),
          lastName: toExpr('Bunny'),
        )
        .execute();

    final users = await db.users.byFullname('Donald', 'Duck').fetch();
    check(users).isNull();
  });

  r.run();
}
