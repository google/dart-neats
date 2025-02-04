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

import 'package:test/test.dart';
import 'package:typed_sql/sql_dialect/sql_dialect.dart';
import 'model.dart';
import 'package:typed_sql/typed_sql.dart';

final u = Uri.parse('file:shared-inmemory?mode=memory&cache=shared');

void main() {
  test('sqlite', () async {
    final adaptor = DatabaseAdaptor.withLogging(
      DatabaseAdaptor.sqlite3(u),
      print,
    );
    final db = Database<PrimaryDatabase>(adaptor, SqlDialect.sqlite());

    await db.migrate();

    await db.users.create(
      userId: 22,
      name: 'Bob',
      email: 'bob@example.com',
    );
    await db.users.create(
      userId: 42,
      name: 'Alice',
      email: 'alice@example.com',
    );

    final users = await db.users.fetch().toList();
    print(users);

    final alice = await db.users
        .where((u) => u.name.equals.literal('Alice'))
        .first
        .fetch();
    print(alice);

    await adaptor.close();
  });
}
