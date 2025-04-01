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

import 'package:meta/meta.dart' hide literal;
import 'package:test/test.dart';
import 'package:typed_sql/typed_sql.dart';

import 'model.dart';

var _testFileCounter = 0;

Future<DatabaseAdaptor> _createSqliteAdaptor(String name) async {
  _testFileCounter++;
  final filename = [
    name.hashCode.abs(),
    DateTime.now().microsecondsSinceEpoch,
    _testFileCounter,
  ].join('-');
  final u = Uri.parse('file:inmemory-$filename?mode=memory&cache=shared');
  return DatabaseAdaptor.sqlite3(u);
}

@isTest
void _test(
  String name,
  FutureOr<void> Function(Database<PrimaryDatabase> db) fn,
) async {
  test(name, () async {
    final adaptor = DatabaseAdaptor.withLogging(
      await _createSqliteAdaptor(name),
      printOnFailure,
      //print,
    );
    final db = Database<PrimaryDatabase>(adaptor, SqlDialect.sqlite());

    await db.createTables();
    await db.users
        .insertLiteral(
          userId: 1,
          name: 'Alice',
          email: 'alice@example.com',
        )
        .execute();
    await db.users
        .insertLiteral(userId: 2, name: 'Bob', email: 'bob@example.com')
        .execute();
    await db.packages
        .insertLiteral(
          packageName: 'foo',
          likes: 2,
          publisher: null,
          ownerId: 1,
        )
        .execute();
    await db.packages
        .insertLiteral(
          packageName: 'bar',
          likes: 3,
          publisher: null,
          ownerId: 1,
        )
        .execute();
    await db.likes.insertLiteral(userId: 1, packageName: 'foo').execute();
    await db.likes.insertLiteral(userId: 2, packageName: 'foo').execute();

    try {
      await fn(db);
    } finally {
      await adaptor.close(force: true);
    }
  });
}

void main() {
  _test('db.users.create()', (db) async {
    // Do nothing, this is covered in the setup
  });

  _test('db.packages.insert()', (db) async {
    await db.packages
        .insert(
          packageName: literal('foobar'),
          likes: literal(0),
          publisher: literal(null),
          ownerId: literal(2),
        )
        .execute();
  });

  _test('db.users.where(.endsWithLiteral).select()', (db) async {
    final users = await db.users
        .where((u) => u.email.endsWithLiteral('@example.com'))
        .select((u) => (u.name,))
        .fetch();
    expect(users, contains('Alice'));
    expect(users, contains('Bob'));
    expect(users, hasLength(2));
  });

  _test('db.users.where(.startsWithLiteral).select()', (db) async {
    final users = await db.users
        .where((u) => u.email.startsWithLiteral('alice@'))
        .select((u) => (u.name,))
        .fetch();
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
        )
        .execute();
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

    await db.packages
        .byKey(packageName: 'foo')
        .update((u, set) => set(
              likes: u.likes + literal(1),
            ))
        .execute();

    expect(
      await db.packages
          .byKey(packageName: 'foo')
          .select((p) => (p.likes,))
          .fetch(),
      equals(3),
    );

    await db.packages
        .byKey(packageName: 'foo')
        .update((u, set) => set(
              likes: u.likes.addLiteral(1),
            ))
        .execute();

    expect(
      await db.packages
          .byKey(packageName: 'foo')
          .select((p) => (p.likes,))
          .fetch(),
      equals(4),
    );

    await db.packages
        .byKey(packageName: 'foo')
        .update((u, set) => set(
              likes: u.likes.subtractLiteral(1),
            ))
        .execute();

    await db.packages
        .byKey(packageName: 'foo')
        .update((u, set) => set(
              likes: u.likes - literal(1),
            ))
        .execute();

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
    await db.packages.byKey(packageName: 'foo').delete().execute();
    {
      final p = await db.packages.byKey(packageName: 'foo').fetch();
      expect(p, isNull);
    }
  });

  _test('db.packages.where().deleteAll()', (db) async {
    {
      final packages = await db.packages.fetch();
      expect(packages, hasLength(2));
    }
    await db.packages
        .where((p) => p.packageName.equalsLiteral('foo'))
        .delete()
        .execute();
    {
      final packages = await db.packages.fetch();
      expect(packages, hasLength(1));
    }
  });

  _test('db.users.where().limit()', (db) async {
    final users = await db.users
        .where((u) => u.email.equalsLiteral('alice@example.com'))
        .limit(1)
        .select((u) => (u.name,))
        .fetch();
    expect(users, contains('Alice'));
    expect(users, hasLength(1));
  });

  _test('db.users.limit().where()', (db) async {
    final users = await db.users
        .limit(2)
        .where((u) => u.email.equalsLiteral('alice@example.com'))
        .select((u) => (u.name,))
        .fetch();
    expect(users, contains('Alice'));
    expect(users, hasLength(1));
  });

  _test('db.users.offset(0).limit().where()', (db) async {
    final users = await db.users
        .offset(0)
        .limit(2)
        .where((u) => u.email.equalsLiteral('bob@example.com'))
        .select((u) => (u.name,))
        .fetch();
    expect(users, contains('Bob'));
    expect(users, hasLength(1));
  });

  _test('db.users.limit(0).offset().where()', (db) async {
    final users = await db.users
        .limit(2)
        .offset(0)
        .where((u) => u.email.equalsLiteral('bob@example.com'))
        .select((u) => (u.name,))
        .fetch();
    expect(users, contains('Bob'));
    expect(users, hasLength(1));
  });

  _test('db.users.orderBy().offset().where(1) (empty)', (db) async {
    final users = await db.users
        .orderBy((u) => [(u.userId, Order.ascending)])
        .offset(1)
        .where((u) => u.email.equalsLiteral('alice@example.com'))
        .select((u) => (u.name,))
        .fetch();
    expect(users, isEmpty);
  });

  _test('db.users.orderBy().offset(1).where()', (db) async {
    final users = await db.users
        .orderBy((u) => [(u.userId, Order.ascending)])
        .offset(1)
        .where((u) => u.email.equalsLiteral('bob@example.com'))
        .select((u) => (u.name,))
        .fetch();
    expect(users, contains('Bob'));
    expect(users, hasLength(1));
  });

  _test('db.users.orderBy(descending).offset(1).where() (empty)', (db) async {
    final users = await db.users
        .orderBy((u) => [(u.userId, Order.descending)])
        .offset(1)
        .where((u) => u.email.equalsLiteral('bob@example.com'))
        .select((u) => (u.name,))
        .fetch();
    expect(users, isEmpty);
  });

  _test('db.users.orderBy(descending).offset(1).where()', (db) async {
    final users = await db.users
        .orderBy((u) => [(u.userId, Order.descending)])
        .offset(1)
        .where((u) => u.email.equalsLiteral('alice@example.com'))
        .select((u) => (u.name,))
        .fetch();
    expect(users, contains('Alice'));
    expect(users, hasLength(1));
  });

  _test('db.users.join(db.packages).on()', (db) async {
    final result = await db.users
        .join(db.packages)
        .on((u, p) => u.userId.equals(p.ownerId))
        .fetch();
    expect(result, hasLength(2));
    final (u, p) = result[0];
    expect(u.name, equals('Alice'));
    expect(p.packageName, anyOf(equals('foo'), equals('bar')));
  });

  _test('db.users.join(db.packages).on().select()', (db) async {
    final result = await db.users
        .join(db.packages)
        .on((u, p) => u.userId.equals(p.ownerId))
        .select((u, p) => (u.name, p.packageName))
        .fetch();
    expect(result, contains(('Alice', 'foo')));
    expect(result, hasLength(2));
  });

  _test('db.users.byKey().asQuery.join(db.packages).on().select()', (db) async {
    final result = await db.users
        .byKey(userId: 1)
        .asQuery
        .join(db.packages)
        .on((u, p) => u.userId.equals(p.ownerId))
        .select((u, p) => (u.name, p.packageName))
        .fetch();
    expect(result, contains(('Alice', 'foo')));
    expect(result, hasLength(2));
  });

  _test('db.users.byKey().asQuery.join(db.packages).on() (empty)', (db) async {
    final result = await db.users
        .byKey(userId: 2)
        .asQuery
        .join(db.packages)
        .on((u, p) => u.userId.equals(p.ownerId))
        .fetch();
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
        .fetch();
    expect(result, hasLength(2));
    final (u, packageName, ownerId) = result[0];
    expect(u.name, equals('Alice'));
    expect(packageName, anyOf(equals('foo'), equals('bar')));
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
        .fetch();
    expect(result, hasLength(2));
    final (u, packageName, ownerId) = result[0];
    expect(u.name, equals('Alice'));
    expect(packageName, anyOf(equals('foo'), equals('bar')));
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
        .fetch();
    expect(result, hasLength(2));
    final (p, name) = result[0];
    expect(p.packageName, anyOf(equals('foo'), equals('bar')));
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
        .fetch();
    expect(result, hasLength(2));
    final (p, user) = result[0];
    expect(p.packageName, anyOf(equals('foo'), equals('bar')));
    expect(user, isNotNull);
    expect(user!.name, equals('Alice'));
  });

  _test('db.select(true, "hello world", 42)', (db) async {
    final result = await db.select((
      literal(true),
      literal('hello world'),
      literal(42),
    )).fetch();
    expect(result, equals((true, 'hello world', 42)));
  });

  _test('db.select(true && false)', (db) async {
    final result = await db.select(
      (literal(true) & literal(false),),
    ).fetch();
    expect(result, isFalse);
  });

  _test('db.select(true || false)', (db) async {
    final result = await db.select(
      (literal(true) | literal(false),),
    ).fetch();
    expect(result, isTrue);
  });

  _test('db.select(true.not)', (db) async {
    final result = await db.select(
      (literal(true).not(),),
    ).fetch();
    expect(result, isFalse);
  });

  _test('db.select(true.not())', (db) async {
    final result = await db.select(
      (literal(true).not(),),
    ).fetch();
    expect(result, isFalse);
  });

  _test('db.select(true.and(false))', (db) async {
    final result = await db.select(
      (literal(true).and(literal(false)),),
    ).fetch();
    expect(result, isFalse);
  });

  _test('db.select(true.or(false))', (db) async {
    final result = await db.select(
      (literal(true).or(literal(false)),),
    ).fetch();
    expect(result, isTrue);
  });

  _test('db.select(42.add(1))', (db) async {
    final result = await db.select(
      (literal(42).add(literal(1)),),
    ).fetch();
    expect(result, equals(43));
  });

  _test('db.select(42.subtract(1))', (db) async {
    final result = await db.select(
      (literal(42).subtract(literal(1)),),
    ).fetch();
    expect(result, equals(41));
  });

  _test('db.select(42.multiply(2))', (db) async {
    final result = await db.select(
      (literal(42).multiply(literal(2)),),
    ).fetch();
    expect(result, equals(84));
  });

  _test('db.select(42.divide(2))', (db) async {
    final result = await db.select(
      (literal(42).divide(literal(2)),),
    ).fetch();
    expect(result, equals(21));
  });

  _test('db.select(42.equals(42))', (db) async {
    final result = await db.select(
      (literal(42).equals(literal(42)),),
    ).fetch();
    expect(result, isTrue);
  });

  _test('db.packages.exists()', (db) async {
    final result = await db.packages.exists().fetch();
    expect(result, isTrue);
  });

  _test('db.packages.exists().asExpr', (db) async {
    final result = await db.select((db.packages.exists().asExpr,)).fetch();
    expect(result, isTrue);
  });

  _test('db.packages.exists().asExpr.not()', (db) async {
    final result = await db
        .select((db.packages.exists().asExpr.assertNotNull().not(),)).fetch();
    expect(result, isFalse);
  });

  _test('db.users.select(db.packages.where().isNotEmpty)', (db) async {
    final result = await db.users
        .select(
          (u) => (
            u,
            db.packages
                .where((p) => p.ownerId.equals(u.userId))
                .exists()
                .asExpr,
          ),
        )
        .fetch();
    expect(result, hasLength(2));
    final (user1, hasPackage1) = result[0];
    final (user2, hasPackage2) = result[1];
    expect(user1.name, equals('Alice'));
    expect(hasPackage1, isTrue);
    expect(user2.name, equals('Bob'));
    expect(hasPackage2, isFalse);
  });

  _test('db.users.select(db.packages.where().isEmpty)', (db) async {
    final result = await db.users
        .select(
          (u) => (
            u,
            db.packages
                .where((p) => p.ownerId.equals(u.userId))
                .exists()
                .asExpr
                .assertNotNull()
                .not(),
          ),
        )
        .fetch();
    expect(result, hasLength(2));
    final (user1, hasPackage1) = result[0];
    final (user2, hasPackage2) = result[1];
    expect(user1.name, equals('Alice'));
    expect(hasPackage1, isFalse);
    expect(user2.name, equals('Bob'));
    expect(hasPackage2, isTrue);
  });

  _test('db.users.where(db.packages.where().isEmpty)', (db) async {
    final result = await db.users
        .where(
          (u) => db.packages
              .where((p) => p.ownerId.equals(u.userId))
              .exists()
              .asExpr
              .assertNotNull()
              .not(),
        )
        .select((u) => (u.name,))
        .fetch();
    expect(result, hasLength(1));
    expect(result, contains('Bob'));
  });

  _test('db.users.where(db.packages.where().isNotEmpty)', (db) async {
    final result = await db.users
        .where(
          (u) => db.packages
              .where((p) => p.ownerId.equals(u.userId))
              .exists()
              .asExpr
              .assertNotNull(),
        )
        .select((u) => (u.name,))
        .fetch();
    expect(result, hasLength(1));
    expect(result, contains('Alice'));
  });

  _test('select((u, p) => (owner: u.name, packages: p.packageName))',
      (db) async {
    final result = await db.users
        .join(db.packages)
        .on((u, p) => p.ownerId.equals(u.userId))
        .select((u, p) => (
              owner: u.name,
              package: p.packageName,
            ))
        .fetch();
    expect(result, hasLength(2));
    expect(result[0].owner, equals('Alice'));
    expect(result[0].package, anyOf(equals('foo'), equals('bar')));
  });

  _test('db.likes.select().sum()', (db) async {
    final result = await db.packages.select((p) => (p.likes,)).sum().fetch();
    expect(result, equals(5));
  });

  _test('db.likes.select().avg()', (db) async {
    final result = await db.packages.select((p) => (p.likes,)).avg().fetch();
    expect(result, equals(2.5));
  });

  _test('db.likes.select().min()', (db) async {
    final result = await db.packages.select((p) => (p.likes,)).min().fetch();
    expect(result, equals(2));
  });

  _test('db.likes.select().max()', (db) async {
    final result = await db.packages.select((p) => (p.likes,)).max().fetch();
    expect(result, equals(3));
  });

  _test('db.likes.count()', (db) async {
    final result = await db.likes.count().fetch();
    expect(result, equals(2));
  });

  _test('db.likes.select().count()', (db) async {
    final result =
        await db.likes.select((l) => (l.packageName,)).count().fetch();
    expect(result, equals(2));
  });

  _test('db.likes.where().select().count()', (db) async {
    final result = await db.likes
        .where((l) => l.packageName.equalsLiteral('bar'))
        .select((l) => (l.packageName,))
        .count()
        .fetch();
    expect(result, equals(0));
  });

  _test('db.packages.select(ownerId).distinct()', (db) async {
    final result =
        await db.packages.select((p) => (p.ownerId,)).distinct().fetch();
    expect(result, hasLength(1));
    expect(result, contains(1));
  });

  _test('db.packages.distinct()', (db) async {
    final result = await db.packages.distinct().fetch();
    expect(result, hasLength(2));
    expect(result[0].packageName, anyOf(equals('foo'), equals('bar')));
  });

  _test('db.packages.union(db.packages)', (db) async {
    final result = await db.packages.union(db.packages).fetch();
    expect(result, hasLength(2));
  });

  _test('db.packages.unionAll(db.packages)', (db) async {
    final result = await db.packages.unionAll(db.packages).fetch();
    expect(result, hasLength(4));
  });

  _test('db.packages.intersect(db.packages)', (db) async {
    final result = await db.packages.intersect(db.packages).fetch();
    expect(result, hasLength(2));
  });

  _test('db.packages.except(db.packages)', (db) async {
    final result = await db.packages.except(db.packages).fetch();
    expect(result, hasLength(0));
  });

  _test('db.users.select((u) => u.packages.countAll())', (db) async {
    final result = await db.users
        .select(
          (u) => (
            userName: u.name,
            packages: u.packages.count(),
            totalLikes: u.packages.select((p) => (p.likes,)).sum(),
          ),
        )
        .orderBy((r) => [(r.userName, Order.ascending)])
        .fetch();
    expect(result, hasLength(2));
    expect(result[0].userName, equals('Alice'));
    expect(result[0].packages, equals(2));
    expect(result[0].totalLikes, equals(5));
    expect(result[1].userName, equals('Bob'));
    expect(result[1].packages, equals(0));
    expect(result[1].totalLikes, equals(0));
  });

  _test('db.packages.select((p) => p, p.owner)', (db) async {
    final result = await db.packages
        .select((p) => (
              p,
              p.owner,
            ))
        .fetch();
    expect(result, hasLength(2));
  });

  _test('db.packages.select((p) => p.packageName, p.owner.name)', (db) async {
    final result = await db.packages
        .select((p) => (
              p.packageName,
              p.owner.name,
            ))
        .fetch();
    expect(result, hasLength(2));
    expect(result, contains(('foo', 'Alice')));
    expect(result, contains(('bar', 'Alice')));
  });

  _test('db.likes.groupBy((l) => p.package).aggregate(count, avg)', (db) async {
    final result = await db.likes
        .groupBy((like) => (like.packageName,))
        .aggregate(
          (agg) => agg
              // Aggregates
              .count()
              .min((like) => like.userId), // doesn't make sense, but tests min
        )
        .fetch();
    expect(result, hasLength(1));
    expect(result[0], equals(('foo', 2, 1)));
  });

  _test('db.insert().returnInserted()', (db) async {
    final result = await db.packages
        .insert(packageName: literal('foobar'), ownerId: literal(1))
        .returnInserted()
        .executeAndFetch();
    expect(result, isNotNull);
    expect(result.ownerId, equals(1));
  });

  _test('db.insert().returning()', (db) async {
    final (likes, owner) = await db.packages
        .insert(packageName: literal('foobar'), ownerId: literal(1))
        .returning((pkg) => (pkg.likes, pkg.owner))
        .executeAndFetch();
    expect(likes, equals(0));
    expect(owner.userId, equals(1));
    expect(owner.name, equals('Alice'));
  });

  _test('db.update().returning()', (db) async {
    final (likes, owner) = await db.packages
        .byKey(packageName: 'foo')
        .update((pkg, set) => set(likes: pkg.likes + literal(1)))
        .returning((pkg) => (pkg.likes, pkg.owner))
        .executeAndFetchOrNulls();
    expect(likes, equals(3));
    expect(owner!.userId, equals(1));
    expect(owner.name, equals('Alice'));
  });

  _test('db.update().returnUpdated()', (db) async {
    final result = await db.packages
        .byKey(packageName: 'foo')
        .update((pkg, set) => set(likes: pkg.likes + literal(1)))
        .returnUpdated()
        .executeAndFetch();
    expect(result, isNotNull);
    expect(result?.likes, equals(3));
  });

  _test('db.delete().returning()', (db) async {
    final (likes, owner) = await db.packages
        .byKey(packageName: 'foo')
        .delete()
        .returning((pkg) => (pkg.likes, pkg.owner))
        .executeAndFetchOrNulls();
    expect(likes, equals(2));
    expect(owner!.userId, equals(1));
    expect(owner.name, equals('Alice'));
  });

  _test('db.delete().returnDeleted()', (db) async {
    final result = await db.packages
        .byKey(packageName: 'foo')
        .delete()
        .returnDeleted()
        .executeAndFetch();
    expect(result, isNotNull);
    expect(result?.likes, equals(2));
  });

  // TODO: Support operators on nullable values!
  /*_test('db.packages.where(publisher == null).select()', (db) async {
    final result = await db.packages
        .where((p) => p.publisher.equals(Expr.null$))
        .select((p) => (p.packageName,))
        .fetch()
        ;
    expect(result, contains('foo'));
    expect(result, hasLength(1));
  });*/
}

// ignore_for_file: unreachable_from_main
