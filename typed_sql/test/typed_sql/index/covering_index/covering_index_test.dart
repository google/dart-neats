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

part 'covering_index_test.g.dart';

abstract final class Directory extends Schema {
  Table<Contact> get contacts;
}

@PrimaryKey(['id'])
@Index(fields: ['lastName'], covering: ['email'])
abstract final class Contact extends Row {
  @AutoIncrement()
  int get id;

  @SqlOverride.field(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String get lastName;
  String get firstName;

  @Index.field(covering: ['lastName'])
  @SqlOverride.field(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String get phone;

  String get email;
}

void main() {
  final r = TestRunner<Directory>(
    setup: (db) async {
      await db.createTables();
    },
  );

  r.addTest('createTables() succeeds with covering columns', (db) async {
    await db.contacts
        .insertValue(
          lastName: 'Doe',
          firstName: 'Jane',
          phone: '555-0100',
          email: 'jane@example.com',
        )
        .execute();

    final item = await db.contacts.first.fetch();
    check(item).isNotNull()
      ..lastName.equals('Doe')
      ..firstName.equals('Jane')
      ..phone.equals('555-0100')
      ..email.equals('jane@example.com');
  });

  r.run();
}
