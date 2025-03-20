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

import 'package:test/test.dart';
import 'package:typed_sql/adaptor.dart';

void _test(String name, Future<void> Function(DatabaseAdaptor db) fn) async {
  test(name, () async {
    final u = Uri.parse('file:shared-inmemory?mode=memory&cache=shared');
    final db = DatabaseAdaptor.sqlite3(u);
    try {
      await db
          .query('CREATE TABLE users (id INT, name TEXT)', []).drain<void>();
      await fn(db);
    } finally {
      await db.close();
    }
  });
}

Future<void> insertAliceBob(DatabaseAdaptor db) async {
  await db.query(
    'INSERT INTO users (id, name) VALUES (?, ?)',
    [1, 'Alice'],
  ).drain<void>();
  await db.query(
    'INSERT INTO users (id, name) VALUES (?, ?)',
    [2, 'Bob'],
  ).drain<void>();
}

extension on Stream<RowReader> {
  Future<List<List<Object?>>> toIntStr() async =>
      (await toList()).map((row) => [row.readInt(), row.readString()]).toList();
}

void main() {
  _test('insert', (db) async {
    await insertAliceBob(db);
  });

  _test('select', (db) async {
    await insertAliceBob(db);

    final users = await db.query('SELECT id, name FROM users', []).toIntStr();
    expect(users.firstWhere((u) => u[0] == 1), [1, 'Alice']);
    expect(users.firstWhere((u) => u[0] == 2), [2, 'Bob']);
  });

  _test('update', (db) async {
    await insertAliceBob(db);

    await db.query(
      'UPDATE users SET name = ? WHERE id = ?',
      ['Bob Builder', 2],
    ).drain<void>();

    final users = await db.query('SELECT id, name FROM users', []).toIntStr();
    expect(users.firstWhere((u) => u[0] == 1), [1, 'Alice']);
    expect(users.firstWhere((u) => u[0] == 2), [2, 'Bob Builder']);
  });

  _test('delete', (db) async {
    await insertAliceBob(db);

    await db.query('DELETE FROM users WHERE id = ?', [1]).drain<void>();

    final users = await db.query('SELECT id, name FROM users', []).toIntStr();
    expect(users.firstWhere((u) => u[0] == 2), [2, 'Bob']);
    expect(users, hasLength(1));
  });

  _test('transaction', (db) async {
    await insertAliceBob(db);

    await db.transact((tx) async {
      await tx.query('DELETE FROM users WHERE id = ?', [1]).drain<void>();
    });

    final users = await db.query('SELECT id, name FROM users', []).toIntStr();
    expect(users.firstWhere((u) => u[0] == 2), [2, 'Bob']);
    expect(users, hasLength(1));
  });

  _test('transaction with conflict', (db) async {
    await insertAliceBob(db);

    final c1 = Completer<void>();
    final c2 = Completer<void>();

    await expectLater(
      Future.wait([
        () async {
          await db.transact((tx) async {
            c1.complete();
            await c2.future;

            await tx.query(
              'UPDATE users SET name = ? WHERE id = ?',
              ['Alice1', 1],
            ).drain<void>();
          });
        }(),
        () async {
          await db.transact((tx) async {
            c2.complete();
            await c1.future;

            await tx.query(
              'UPDATE users SET name = ? WHERE id = ?',
              ['Alice2', 1],
            ).drain<void>();
          });
        }(),
      ]),
      throwsA(isA<DatabaseTransactionAbortedException>()),
    );
  });

  _test('savepoint', (db) async {
    await insertAliceBob(db);

    await db.transact((tx) async {
      await tx.transact((sp) async {
        await sp.query('DELETE FROM users WHERE id = ?', [1]).drain<void>();
      });
    });

    final users = await db.query('SELECT id, name FROM users', []).toIntStr();
    expect(users.firstWhere((u) => u[0] == 2), [2, 'Bob']);
    expect(users, hasLength(1));
  });

  // TODO: Make some more intersting test cases with conflicts!

  _test('savepoint with conflict', (db) async {
    await insertAliceBob(db);

    final c1started = Completer<void>();
    final c2started = Completer<void>();

    await expectLater(
      Future.wait([
        () async {
          await db.transact((tx) async {
            await c2started.future;
            c1started.complete();

            await tx.transact((sp) async {
              await sp.query(
                'UPDATE users SET name = ? WHERE id = ?',
                ['Alice1', 1],
              ).drain<void>();
            });
          });
        }(),
        () async {
          await db.transact((tx) async {
            c2started.complete();
            await c1started.future;

            await tx.transact((sp) async {
              await sp.query(
                'UPDATE users SET name = ? WHERE id = ?',
                ['Alice2', 1],
              ).drain<void>();
            });
          });
        }(),
      ]),
      throwsA(isA<DatabaseTransactionAbortedException>()),
    );
  });
}
