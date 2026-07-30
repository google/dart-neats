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

part 'gist_index_test.g.dart';

abstract final class ContactDirectory extends Schema {
  Table<Contact> get contacts;
}

@PrimaryKey(['id'])
abstract final class Contact extends Row {
  @AutoIncrement()
  int get id;

  // A GiST index on an ordinary scalar column only works if the
  // `btree_gist` extension is installed, since PostgreSQL does not ship a
  // default GiST operator class for `text`. typed_sql does not manage
  // extensions, so this is up to the application/migration to install.
  @Index.field(method: .gist)
  @SqlOverride.field(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String get email;
}

void main() {
  final r = TestRunner<ContactDirectory>(
    setup: (db) async {
      await db.createTables();
    },
  );

  r.addTest(
    'createTables() succeeds with a GiST index',
    (db) async {
      await db.contacts.insertValue(email: 'jane@example.com').execute();

      final item = await db.contacts.first.fetch();
      check(item).isNotNull().email.equals('jane@example.com');
    },
    skipPostgres:
        'GiST on a plain text column needs the btree_gist extension '
        'bootstrapped first; see gist_index_ddl_test.dart',
  );

  r.run();
}
