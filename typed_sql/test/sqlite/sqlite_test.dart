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

import 'package:checks/checks.dart';
import 'package:meta/meta.dart';
import 'package:test/test.dart';
import 'package:typed_sql/typed_sql.dart';

import 'model.dart';

var _testFileCounter = 0;

Future<DatabaseAdapter> _createSqliteAdapter(String name) async {
  _testFileCounter++;
  final filename = [
    name.hashCode.abs(),
    DateTime.now().microsecondsSinceEpoch,
    _testFileCounter,
  ].join('-');
  final u = Uri.parse('file:inmemory-$filename?mode=memory&cache=shared');
  return DatabaseAdapter.sqlite3(u);
}

@isTest
void _test(
  String name,
  FutureOr<void> Function(Database<PrimaryDatabase> db) fn,
) async {
  test(name, () async {
    final adapter = DatabaseAdapter.withLogging(
      await _createSqliteAdapter(name),
      printOnFailure,
      //print,
    );
    final db = Database<PrimaryDatabase>(adapter, SqlDialect.sqlite());

    await db.createTables();
    await db.users
        .insert(
          userId: toExpr(1),
          name: toExpr('Alice'),
          email: toExpr('alice@example.com'),
        )
        .execute();
    await db.users
        .insert(
          userId: toExpr(2),
          name: toExpr('Bob'),
          email: toExpr('bob@example.com'),
        )
        .execute();
    await db.packages
        .insert(
          packageName: toExpr('foo'),
          likes: toExpr(2),
          publisher: toExpr(null),
          ownerId: toExpr(1),
        )
        .execute();
    await db.packages
        .insert(
          packageName: toExpr('bar'),
          likes: toExpr(3),
          publisher: toExpr(null),
          ownerId: toExpr(1),
        )
        .execute();
    await db.likes
        .insert(
          userId: toExpr(1),
          packageName: toExpr('foo'),
        )
        .execute();
    await db.likes
        .insert(
          userId: toExpr(2),
          packageName: toExpr('foo'),
        )
        .execute();

    try {
      await fn(db);
    } finally {
      await adapter.close(force: true);
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
          packageName: toExpr('foobar'),
          likes: toExpr(0),
          publisher: toExpr(null),
          ownerId: toExpr(2),
        )
        .execute();
  });

  _test('db.users.where(.endsWithValue).select()', (db) async {
    final users = await db.users
        .where((u) => u.email.endsWithValue('@example.com'))
        .select((u) => (u.name,))
        .fetch();
    check(users).contains('Alice');
    check(users).contains('Bob');
    check(users).length.equals(2);
  });

  _test('db.users.where(.startsWithValue).select()', (db) async {
    final users = await db.users
        .where((u) => u.email.startsWithValue('alice@'))
        .select((u) => (u.name,))
        .fetch();
    check(users).contains('Alice');
    check(users).length.equals(1);
  });

  _test('db.packages.where().update()', (db) async {
    {
      final p = await db.packages.byKey('foo').fetch();
      check(p!.ownerId).equals(1);
    }
    await db.packages
        .where((p) => p.packageName.equalsValue('foo'))
        .update(
          (p, set) => set(
            ownerId: toExpr(2),
          ),
        )
        .execute();
    {
      final p = await db.packages.byKey('foo').fetch();
      check(p!.ownerId).equals(2);
    }
  });

  _test('db.packages.byKey().update(.add / .subtract)', (db) async {
    check(
      await db.packages.byKey('foo').select((p) => (p.likes,)).fetch(),
    ).equals(2);

    await db.packages
        .byKey('foo')
        .update(
          (u, set) => set(
            likes: u.likes + toExpr(1),
          ),
        )
        .execute();

    check(
      await db.packages.byKey('foo').select((p) => (p.likes,)).fetch(),
    ).equals(3);

    await db.packages
        .byKey('foo')
        .update(
          (u, set) => set(
            likes: u.likes.addValue(1),
          ),
        )
        .execute();

    check(
      await db.packages.byKey('foo').select((p) => (p.likes,)).fetch(),
    ).equals(4);

    await db.packages
        .byKey('foo')
        .update(
          (u, set) => set(
            likes: u.likes.subtractValue(1),
          ),
        )
        .execute();

    await db.packages
        .byKey('foo')
        .update(
          (u, set) => set(
            likes: u.likes - toExpr(1),
          ),
        )
        .execute();

    check(
      await db.packages.byKey('foo').select((p) => (p.likes,)).fetch(),
    ).equals(2);
  });

  _test('db.packages.byKey().delete()', (db) async {
    {
      final p = await db.packages.byKey('foo').fetch();
      check(p).isNotNull();
    }
    await db.packages.byKey('foo').delete().execute();
    {
      final p = await db.packages.byKey('foo').fetch();
      check(p).isNull();
    }
  });

  _test('db.packages.where().deleteAll()', (db) async {
    {
      final packages = await db.packages.fetch();
      check(packages).length.equals(2);
    }
    await db.packages
        .where((p) => p.packageName.equalsValue('foo'))
        .delete()
        .execute();
    {
      final packages = await db.packages.fetch();
      check(packages).length.equals(1);
    }
  });

  _test('db.users.where().limit()', (db) async {
    final users = await db.users
        .where((u) => u.email.equalsValue('alice@example.com'))
        .limit(1)
        .select((u) => (u.name,))
        .fetch();
    check(users).contains('Alice');
    check(users).length.equals(1);
  });

  _test('db.users.limit().where()', (db) async {
    final users = await db.users
        .limit(2)
        .where((u) => u.email.equalsValue('alice@example.com'))
        .select((u) => (u.name,))
        .fetch();
    check(users).contains('Alice');
    check(users).length.equals(1);
  });

  _test('db.users.offset(0).limit().where()', (db) async {
    final users = await db.users
        .offset(0)
        .limit(2)
        .where((u) => u.email.equalsValue('bob@example.com'))
        .select((u) => (u.name,))
        .fetch();
    check(users).contains('Bob');
    check(users).length.equals(1);
  });

  _test('db.users.limit(0).offset().where()', (db) async {
    final users = await db.users
        .limit(2)
        .offset(0)
        .where((u) => u.email.equalsValue('bob@example.com'))
        .select((u) => (u.name,))
        .fetch();
    check(users).contains('Bob');
    check(users).length.equals(1);
  });

  _test('db.users.orderBy().offset().where(1) (empty)', (db) async {
    final users = await db.users
        .orderBy((u) => [(u.userId, Order.ascending)])
        .offset(1)
        .asQuery
        .where((u) => u.email.equalsValue('alice@example.com'))
        .select((u) => (u.name,))
        .fetch();
    check(users).isEmpty();
  });

  _test('db.users.orderBy().offset(1).where()', (db) async {
    final users = await db.users
        .orderBy((u) => [(u.userId, Order.ascending)])
        .offset(1)
        .asQuery
        .where((u) => u.email.equalsValue('bob@example.com'))
        .select((u) => (u.name,))
        .fetch();
    check(users).contains('Bob');
    check(users).length.equals(1);
  });

  _test('db.users.orderBy(descending).offset(1).where() (empty)', (db) async {
    final users = await db.users
        .orderBy((u) => [(u.userId, Order.descending)])
        .offset(1)
        .asQuery
        .where((u) => u.email.equalsValue('bob@example.com'))
        .select((u) => (u.name,))
        .fetch();
    check(users).isEmpty();
  });

  _test('db.users.orderBy(descending).offset(1).where()', (db) async {
    final users = await db.users
        .orderBy((u) => [(u.userId, Order.descending)])
        .offset(1)
        .asQuery
        .where((u) => u.email.equalsValue('alice@example.com'))
        .select((u) => (u.name,))
        .fetch();
    check(users).contains('Alice');
    check(users).length.equals(1);
  });

  _test('db.users.join(db.packages).on()', (db) async {
    final result = await db.users
        .join(db.packages)
        .on((u, p) => u.userId.equals(p.ownerId))
        .fetch();
    check(result).length.equals(2);
    final (u, p) = result[0];
    check(u.name).equals('Alice');
    check(['foo', 'bar']).contains(p.packageName);
  });

  _test('db.users.join(db.packages).on().select()', (db) async {
    final result = await db.users
        .join(db.packages)
        .on((u, p) => u.userId.equals(p.ownerId))
        .select((u, p) => (u.name, p.packageName))
        .fetch();
    check(result).contains(('Alice', 'foo'));
    check(result).length.equals(2);
  });

  _test('db.users.byKey().asQuery.join(db.packages).on().select()', (db) async {
    final result = await db.users
        .byKey(1)
        .asQuery
        .join(db.packages)
        .on((u, p) => u.userId.equals(p.ownerId))
        .select((u, p) => (u.name, p.packageName))
        .fetch();
    check(result).contains(('Alice', 'foo'));
    check(result).length.equals(2);
  });

  _test('db.users.byKey().asQuery.join(db.packages).on() (empty)', (db) async {
    final result = await db.users
        .byKey(2)
        .asQuery
        .join(db.packages)
        .on((u, p) => u.userId.equals(p.ownerId))
        .fetch();
    check(result).length.equals(0);
  });

  _test('db.users.join(db.packages.where().select()).on()', (db) async {
    final result = await db.users
        .join(
          db.packages
              .where((p) => p.likes > toExpr(1))
              .select((p) => (p.packageName, p.ownerId)),
        )
        .on((u, packageName, ownerId) => u.userId.equals(ownerId))
        .fetch();
    check(result).length.equals(2);
    final (u, packageName, ownerId) = result[0];
    check(u.name).equals('Alice');
    check(['foo', 'bar']).contains(packageName);
    check(ownerId).equals(1);
  });

  _test('db.users.join(db.packages.select().where().select()).on()', (
    db,
  ) async {
    final result = await db.users
        .join(
          db.packages
              .select((p) => (p.packageName, p.ownerId, p.likes))
              .where((packageName, ownerId, likes) => likes > toExpr(1))
              .select((packageName, ownerId, likes) => (packageName, ownerId)),
        )
        .on((u, packageName, ownerId) => u.userId.equals(ownerId))
        .fetch();
    check(result).length.equals(2);
    final (u, packageName, ownerId) = result[0];
    check(u.name).equals('Alice');
    check(['foo', 'bar']).contains(packageName);
    check(ownerId).equals(1);
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
                .asExpr,
          ),
        )
        .fetch();
    check(result).length.equals(2);
    final (p, name) = result[0];
    check(['foo', 'bar']).contains(p.packageName);
    check(name).equals('Alice');
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
    check(result).length.equals(2);
    final (p, user) = result[0];
    check(['foo', 'bar']).contains(p.packageName);
    check(user).isNotNull();
    check(user!.name).equals('Alice');
  });

  _test('db.select(true, "hello world", 42)', (db) async {
    final result = await db.select((
      toExpr(true),
      toExpr('hello world'),
      toExpr(42),
    )).fetch();
    check(result).equals((true, 'hello world', 42));
  });

  _test('db.select(true && false)', (db) async {
    final result = await db.select(
      (toExpr(true) & toExpr(false),),
    ).fetch();
    check(result).equals(false);
  });

  _test('db.select(true || false)', (db) async {
    final result = await db.select(
      (toExpr(true) | toExpr(false),),
    ).fetch();
    check(result).equals(true);
  });

  _test('db.select(true.not)', (db) async {
    final result = await db.select(
      (toExpr(true).not(),),
    ).fetch();
    check(result).equals(false);
  });

  _test('db.select(true.not())', (db) async {
    final result = await db.select(
      (toExpr(true).not(),),
    ).fetch();
    check(result).equals(false);
  });

  _test('db.select(true.and(false))', (db) async {
    final result = await db.select(
      (toExpr(true).and(toExpr(false)),),
    ).fetch();
    check(result).equals(false);
  });

  _test('db.select(true.or(false))', (db) async {
    final result = await db.select(
      (toExpr(true).or(toExpr(false)),),
    ).fetch();
    check(result).equals(true);
  });

  _test('db.select(42.add(1))', (db) async {
    final result = await db.select(
      (toExpr(42).add(toExpr(1)),),
    ).fetch();
    check(result).equals(43);
  });

  _test('db.select(42.subtract(1))', (db) async {
    final result = await db.select(
      (toExpr(42).subtract(toExpr(1)),),
    ).fetch();
    check(result).equals(41);
  });

  _test('db.select(42.multiply(2))', (db) async {
    final result = await db.select(
      (toExpr(42).multiply(toExpr(2)),),
    ).fetch();
    check(result).equals(84);
  });

  _test('db.select(42.divide(2))', (db) async {
    final result = await db.select(
      (toExpr(42).divide(toExpr(2)),),
    ).fetch();
    check(result).equals(21);
  });

  _test('db.select(42.equals(42))', (db) async {
    final result = await db.select(
      (toExpr(42).equals(toExpr(42)),),
    ).fetch();
    check(result).equals(true);
  });

  _test('db.packages.exists()', (db) async {
    final result = await db.packages.exists().fetch();
    check(result).equals(true);
  });

  _test('db.packages.exists().asExpr', (db) async {
    final result = await db.select((db.packages.exists().asExpr,)).fetch();
    check(result).equals(true);
  });

  _test('db.packages.exists().asExpr.not()', (db) async {
    final result = await db.select((
      db.packages.exists().asExpr.asNotNull().not(),
    )).fetch();
    check(result).equals(false);
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
    check(result).length.equals(2);
    final (user1, hasPackage1) = result[0];
    final (user2, hasPackage2) = result[1];
    check(user1.name).equals('Alice');
    check(hasPackage1).equals(true);
    check(user2.name).equals('Bob');
    check(hasPackage2).equals(false);
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
                .asNotNull()
                .not(),
          ),
        )
        .fetch();
    check(result).length.equals(2);
    final (user1, hasPackage1) = result[0];
    final (user2, hasPackage2) = result[1];
    check(user1.name).equals('Alice');
    check(hasPackage1).equals(false);
    check(user2.name).equals('Bob');
    check(hasPackage2).equals(true);
  });

  _test('db.users.where(db.packages.where().isEmpty)', (db) async {
    final result = await db.users
        .where(
          (u) => db.packages
              .where((p) => p.ownerId.equals(u.userId))
              .exists()
              .asExpr
              .asNotNull()
              .not(),
        )
        .select((u) => (u.name,))
        .fetch();
    check(result).length.equals(1);
    check(result).contains('Bob');
  });

  _test('db.users.where(db.packages.where().isNotEmpty)', (db) async {
    final result = await db.users
        .where(
          (u) => db.packages
              .where((p) => p.ownerId.equals(u.userId))
              .exists()
              .asExpr
              .asNotNull(),
        )
        .select((u) => (u.name,))
        .fetch();
    check(result).length.equals(1);
    check(result).contains('Alice');
  });

  _test('select((u, p) => (owner: u.name, packages: p.packageName))', (
    db,
  ) async {
    final result = await db.users
        .join(db.packages)
        .on((u, p) => p.ownerId.equals(u.userId))
        .select(
          (u, p) => (
            owner: u.name,
            package: p.packageName,
          ),
        )
        .fetch();
    check(result).length.equals(2);
    check(result[0].owner).equals('Alice');
    check(['foo', 'bar']).contains(result[0].package);
  });

  _test('db.likes.select().sum()', (db) async {
    final result = await db.packages.select((p) => (p.likes,)).sum().fetch();
    check(result).equals(5);
  });

  _test('db.likes.select().avg()', (db) async {
    final result = await db.packages.select((p) => (p.likes,)).avg().fetch();
    check(result).equals(2.5);
  });

  _test('db.likes.select().min()', (db) async {
    final result = await db.packages.select((p) => (p.likes,)).min().fetch();
    check(result).equals(2);
  });

  _test('db.likes.select().max()', (db) async {
    final result = await db.packages.select((p) => (p.likes,)).max().fetch();
    check(result).equals(3);
  });

  _test('db.likes.count()', (db) async {
    final result = await db.likes.count().fetch();
    check(result).equals(2);
  });

  _test('db.likes.select().count()', (db) async {
    final result = await db.likes
        .select((l) => (l.packageName,))
        .count()
        .fetch();
    check(result).equals(2);
  });

  _test('db.likes.where().select().count()', (db) async {
    final result = await db.likes
        .where((l) => l.packageName.equalsValue('bar'))
        .select((l) => (l.packageName,))
        .count()
        .fetch();
    check(result).equals(0);
  });

  _test('db.packages.select(ownerId).distinct()', (db) async {
    final result = await db.packages
        .select((p) => (p.ownerId,))
        .distinct()
        .fetch();
    check(result).length.equals(1);
    check(result).contains(1);
  });

  _test('db.packages.distinct()', (db) async {
    final result = await db.packages.distinct().fetch();
    check(result).length.equals(2);
    check(['foo', 'bar']).contains(result[0].packageName);
  });

  _test('db.packages.union(db.packages)', (db) async {
    final result = await db.packages.union(db.packages).fetch();
    check(result).length.equals(2);
  });

  _test('db.packages.unionAll(db.packages)', (db) async {
    final result = await db.packages.unionAll(db.packages).fetch();
    check(result).length.equals(4);
  });

  _test('db.packages.intersect(db.packages)', (db) async {
    final result = await db.packages.intersect(db.packages).fetch();
    check(result).length.equals(2);
  });

  _test('db.packages.except(db.packages)', (db) async {
    final result = await db.packages.except(db.packages).fetch();
    check(result).length.equals(0);
  });

  /*
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
    check(result).length.equals(2);
    check(result[0].userName).equals('Alice');
    check(result[0].packages).equals(2);
    check(result[0].totalLikes).equals(5);
    check(result[1].userName).equals('Bob');
    check(result[1].packages).equals(0);
    check(result[1].totalLikes).equals(0);
  });*/

  _test('db.packages.select((p) => p, p.owner)', (db) async {
    final result = await db.packages
        .select(
          (p) => (
            p,
            p.owner,
          ),
        )
        .fetch();
    check(result).length.equals(2);
  });

  _test('db.packages.select((p) => p.packageName, p.owner.name)', (db) async {
    final result = await db.packages
        .select(
          (p) => (
            p.packageName,
            p.owner.name,
          ),
        )
        .fetch();
    check(result).length.equals(2);
    check(result).contains(('foo', 'Alice'));
    check(result).contains(('bar', 'Alice'));
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
    check(result).length.equals(1);
    check(result[0]).equals(('foo', 2, 1));
  });

  _test('db.insert().returnInserted()', (db) async {
    final result = await db.packages
        .insert(packageName: toExpr('foobar'), ownerId: toExpr(1))
        .returnInserted()
        .executeAndFetch();
    check(result).isNotNull();
    check(result.ownerId).equals(1);
  });

  _test('db.insert().returning()', (db) async {
    final (likes, owner) = await db.packages
        .insert(packageName: toExpr('foobar'), ownerId: toExpr(1))
        .returning((pkg) => (pkg.likes, pkg.owner))
        .executeAndFetch();
    check(likes).equals(0);
    check(owner.userId).equals(1);
    check(owner.name).equals('Alice');
  });

  _test('db.update().returning()', (db) async {
    final (likes, owner) = await db.packages
        .byKey('foo')
        .update((pkg, set) => set(likes: pkg.likes + toExpr(1)))
        .returning((pkg) => (pkg.likes, pkg.owner))
        .executeAndFetchOrNulls();
    check(likes).equals(3);
    check(owner!.userId).equals(1);
    check(owner.name).equals('Alice');
  });

  _test('db.update().returnUpdated()', (db) async {
    final result = await db.packages
        .byKey('foo')
        .update((pkg, set) => set(likes: pkg.likes + toExpr(1)))
        .returnUpdated()
        .executeAndFetch();
    check(result).isNotNull();
    check(result?.likes).equals(3);
  });

  _test('db.delete().returning()', (db) async {
    final (likes, owner) = await db.packages
        .byKey('foo')
        .delete()
        .returning((pkg) => (pkg.likes, pkg.owner))
        .executeAndFetchOrNulls();
    check(likes).equals(2);
    check(owner!.userId).equals(1);
    check(owner.name).equals('Alice');
  });

  _test('db.delete().returnDeleted()', (db) async {
    final result = await db.packages
        .byKey('foo')
        .delete()
        .returnDeleted()
        .executeAndFetch();
    check(result).isNotNull();
    check(result?.likes).equals(2);
  });

  // TODO: Support operators on nullable values!
  /*_test('db.packages.where(publisher == null).select()', (db) async {
    final result = await db.packages
        .where((p) => p.publisher.equals(Expr.null$))
        .select((p) => (p.packageName,))
        .fetch()
        ;
    check(result).contains('foo');
    check(result).length.equals(1);
  });*/
}

// ignore_for_file: unreachable_from_main
