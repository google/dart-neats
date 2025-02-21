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
import 'package:typed_sql/sql_dialect/sql_dialect.dart';
import 'package:typed_sql/typed_sql.dart';

import 'model.dart';

final u = Uri.parse('file:shared-inmemory?mode=memory&cache=shared');

void _test(
  String name,
  FutureOr<void> Function(Database<PrimaryDatabase> db) fn,
) async {
  test(name, () async {
    final adaptor = DatabaseAdaptor.withLogging(
      DatabaseAdaptor.sqlite3(u),
      printOnFailure,
      //print,
    );
    final db = Database<PrimaryDatabase>(adaptor, SqlDialect.sqlite());
    await adaptor.createTables();
    try {
      await db.users.create(
        userId: 1,
        name: 'Alice',
        email: 'alice@example.com',
      );
      await db.users.create(userId: 2, name: 'Bob', email: 'bob@example.com');
      await db.packages.create(
        packageName: 'foo',
        likes: 2,
        publisher: null,
        ownerId: 1,
      );
      await db.likes.create(userId: 1, packageName: 'foo');
      await db.likes.create(userId: 2, packageName: 'foo');
      await fn(db);
    } finally {
      await adaptor.close();
    }
  });
}

void main() {
  _test('db.users.create()', (db) async {
    // Do nothing, this is covered in the setup
  });

  _test('db.packages.insert()', (db) async {
    await db.packages.insert(
      packageName: literal('bar'),
      likes: literal(0),
      publisher: literal(null),
      ownerId: literal(2),
    );
  });

  _test('db.users.where(.endsWithLiteral).select()', (db) async {
    final users = await db.users
        .where((u) => u.email.endsWithLiteral('@example.com'))
        .select((u) => (u.name,))
        .fetch()
        .toList();
    expect(users, contains('Alice'));
    expect(users, contains('Bob'));
    expect(users, hasLength(2));
  });

  _test('db.users.where(.startsWithLiteral).select()', (db) async {
    final users = await db.users
        .where((u) => u.email.startsWithLiteral('alice@'))
        .select((u) => (u.name,))
        .fetch()
        .toList();
    expect(users, contains('Alice'));
    expect(users, hasLength(1));
  });

  _test('db.packages.where().updateAllLiteral()', (db) async {
    {
      final p = await db.packages.byKey(packageName: 'foo').fetch();
      expect(p!.ownerId, equals(1));
    }
    await db.packages
        .where((p) => p.packageName.equalsLiteral('foo'))
        .updateAllLiteral(
          ownerId: 2,
        );
    {
      final p = await db.packages.byKey(packageName: 'foo').fetch();
      expect(p!.ownerId, equals(2));
    }
  });

  _test('db.packages.byKey().update(.add / .subtract)', (db) async {
    expect(
      await db.packages
          .byKey(packageName: 'foo')
          .select((p) => (p.likes,))
          .fetch(),
      equals(2),
    );

    await db.packages.byKey(packageName: 'foo').update((u, set) => set(
          likes: u.likes + literal(1),
        ));

    expect(
      await db.packages
          .byKey(packageName: 'foo')
          .select((p) => (p.likes,))
          .fetch(),
      equals(3),
    );

    await db.packages.byKey(packageName: 'foo').update((u, set) => set(
          likes: u.likes.addLiteral(1),
        ));

    expect(
      await db.packages
          .byKey(packageName: 'foo')
          .select((p) => (p.likes,))
          .fetch(),
      equals(4),
    );

    await db.packages.byKey(packageName: 'foo').update((u, set) => set(
          likes: u.likes.subtractLiteral(1),
        ));

    await db.packages.byKey(packageName: 'foo').update((u, set) => set(
          likes: u.likes - literal(1),
        ));

    expect(
      await db.packages
          .byKey(packageName: 'foo')
          .select((p) => (p.likes,))
          .fetch(),
      equals(2),
    );
  });

  _test('db.packages.byKey().delete()', (db) async {
    {
      final p = await db.packages.byKey(packageName: 'foo').fetch();
      expect(p, isNotNull);
    }
    await db.packages.byKey(packageName: 'foo').delete();
    {
      final p = await db.packages.byKey(packageName: 'foo').fetch();
      expect(p, isNull);
    }
  });

  _test('db.packages.where().deleteAll()', (db) async {
    {
      final packages = await db.packages.fetch().toList();
      expect(packages, hasLength(1));
    }
    await db.packages.where((p) => p.packageName.equalsLiteral('foo')).delete();
    {
      final packages = await db.packages.fetch().toList();
      expect(packages, isEmpty);
    }
  });

  _test('db.users.where().limit()', (db) async {
    final users = await db.users
        .where((u) => u.email.equalsLiteral('alice@example.com'))
        .limit(1)
        .select((u) => (u.name,))
        .fetch()
        .toList();
    expect(users, contains('Alice'));
    expect(users, hasLength(1));
  });

  _test('db.users.limit().where()', (db) async {
    final users = await db.users
        .limit(2)
        .where((u) => u.email.equalsLiteral('alice@example.com'))
        .select((u) => (u.name,))
        .fetch()
        .toList();
    expect(users, contains('Alice'));
    expect(users, hasLength(1));
  });

  _test('db.users.offset(0).limit().where()', (db) async {
    final users = await db.users
        .offset(0)
        .limit(2)
        .where((u) => u.email.equalsLiteral('bob@example.com'))
        .select((u) => (u.name,))
        .fetch()
        .toList();
    expect(users, contains('Bob'));
    expect(users, hasLength(1));
  });

  _test('db.users.limit(0).offset().where()', (db) async {
    final users = await db.users
        .limit(2)
        .offset(0)
        .where((u) => u.email.equalsLiteral('bob@example.com'))
        .select((u) => (u.name,))
        .fetch()
        .toList();
    expect(users, contains('Bob'));
    expect(users, hasLength(1));
  });

  _test('db.users.orderBy().offset().where(1) (empty)', (db) async {
    final users = await db.users
        .orderBy((u) => u.userId)
        .offset(1)
        .where((u) => u.email.equalsLiteral('alice@example.com'))
        .select((u) => (u.name,))
        .fetch()
        .toList();
    expect(users, isEmpty);
  });

  _test('db.users.orderBy().offset(1).where()', (db) async {
    final users = await db.users
        .orderBy((u) => u.userId)
        .offset(1)
        .where((u) => u.email.equalsLiteral('bob@example.com'))
        .select((u) => (u.name,))
        .fetch()
        .toList();
    expect(users, contains('Bob'));
    expect(users, hasLength(1));
  });

  _test('db.users.orderBy(descending).offset(1).where() (empty)', (db) async {
    final users = await db.users
        .orderBy((u) => u.userId, descending: true)
        .offset(1)
        .where((u) => u.email.equalsLiteral('bob@example.com'))
        .select((u) => (u.name,))
        .fetch()
        .toList();
    expect(users, isEmpty);
  });

  _test('db.users.orderBy(descending).offset(1).where()', (db) async {
    final users = await db.users
        .orderBy((u) => u.userId, descending: true)
        .offset(1)
        .where((u) => u.email.equalsLiteral('alice@example.com'))
        .select((u) => (u.name,))
        .fetch()
        .toList();
    expect(users, contains('Alice'));
    expect(users, hasLength(1));
  });

  _test('db.users.join(db.packages).on()', (db) async {
    final result = await db.users
        .join(db.packages)
        .on((u, p) => u.userId.equals(p.ownerId))
        .fetch()
        .toList();
    expect(result, hasLength(1));
    final (u, p) = result[0];
    expect(u.name, equals('Alice'));
    expect(p.packageName, equals('foo'));
  });

  _test('db.users.join(db.packages).on().select()', (db) async {
    final result = await db.users
        .join(db.packages)
        .on((u, p) => u.userId.equals(p.ownerId))
        .select((u, p) => (u.name, p.packageName))
        .fetch()
        .toList();
    expect(result, contains(('Alice', 'foo')));
    expect(result, hasLength(1));
  });

  _test('db.users.byKey().asQuery.join(db.packages).on().select()', (db) async {
    final result = await db.users
        .byKey(userId: 1)
        .asQuery
        .join(db.packages)
        .on((u, p) => u.userId.equals(p.ownerId))
        .select((u, p) => (u.name, p.packageName))
        .fetch()
        .toList();
    expect(result, contains(('Alice', 'foo')));
    expect(result, hasLength(1));
  });

  _test('db.users.byKey().asQuery.join(db.packages).on() (empty)', (db) async {
    final result = await db.users
        .byKey(userId: 2)
        .asQuery
        .join(db.packages)
        .on((u, p) => u.userId.equals(p.ownerId))
        .fetch()
        .toList();
    expect(result, hasLength(0));
  });

  _test('db.users.join(db.packages.where().select()).on()', (db) async {
    final result = await db.users
        .join(
          db.packages
              .where((p) => p.likes > literal(1))
              .select((p) => (p.packageName, p.ownerId)),
        )
        .on((u, packageName, ownerId) => u.userId.equals(ownerId))
        .fetch()
        .toList();
    expect(result, hasLength(1));
    final (u, packageName, ownerId) = result[0];
    expect(u.name, equals('Alice'));
    expect(packageName, equals('foo'));
    expect(ownerId, equals(1));
  });

  _test('db.users.join(db.packages.select().where().select()).on()',
      (db) async {
    final result = await db.users
        .join(
          db.packages
              .select((p) => (p.packageName, p.ownerId, p.likes))
              .where((packageName, ownerId, likes) => likes > literal(1))
              .select((packageName, ownerId, likes) => (packageName, ownerId)),
        )
        .on((u, packageName, ownerId) => u.userId.equals(ownerId))
        .fetch()
        .toList();
    expect(result, hasLength(1));
    final (u, packageName, ownerId) = result[0];
    expect(u.name, equals('Alice'));
    expect(packageName, equals('foo'));
    expect(ownerId, equals(1));
  });

  _test('db.packages.select(db.users.where().select().first)', (db) async {
    final result = await db.packages
        .select(
          (p) => (
            p,
            db.users
                .where((u) => u.userId.equals(p.ownerId))
                .select((u) => (u.name,))
                .first
                .asExpr
          ),
        )
        .fetch()
        .toList();
    expect(result, hasLength(1));
    final (p, name) = result[0];
    expect(p.packageName, equals('foo'));
    expect(name, equals('Alice'));
  });

  _test('db.packages.select(db.users.where().first)', (db) async {
    final result = await db.packages
        .select(
          (p) => (
            p,
            // This isn't efficient, but we can do it!
            db.users.where((u) => u.userId.equals(p.ownerId)).first.asExpr,
          ),
        )
        .fetch()
        .toList();
    expect(result, hasLength(1));
    final (p, user) = result[0];
    expect(p.packageName, equals('foo'));
    expect(user.name, equals('Alice'));
  });

  // TODO: Support operators on nullable values!
  /*_test('db.packages.where(publisher == null).select()', (db) async {
    final result = await db.packages
        .where((p) => p.publisher.equals(Expr.null$))
        .select((p) => (p.packageName,))
        .fetch()
        .toList();
    expect(result, contains('foo'));
    expect(result, hasLength(1));
  });*/
}
