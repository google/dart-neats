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
import 'package:typed_sql/adaptor.dart';

import '../testutil/postgres_manager.dart';

extension on Stream<RowReader> {
  Future<List<(int, String)>> toTupleList() async => (await toList())
      .map((row) => (
            row.readInt()!,
            row.readString()!,
          ))
      .toList();
}

void main() async {
  test('create table / insert / select', () async {
    final pg = PostgresManager();
    final pool = await pg.getPool();

    final db = DatabaseAdaptor.postgres(pool);

    await db.execute('CREATE TABLE users (id INT, name TEXT)', []);

    await db.query(
      r'INSERT INTO users (id, name) VALUES ($1, $2)',
      [1, 'Alice'],
    ).drain<void>();

    await db.query(
      r'INSERT INTO users (id, name) VALUES ($1, $2)',
      [2, 'Bob'],
    ).drain<void>();

    final users =
        await db.query('SELECT id, name FROM users', []).toTupleList();
    expect(users.firstWhere((u) => u.$1 == 1), (1, 'Alice'));
    expect(users.firstWhere((u) => u.$1 == 2), (2, 'Bob'));

    await db.close();

    pg.close();
  });
}
