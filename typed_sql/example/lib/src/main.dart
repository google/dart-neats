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
import 'model.dart';

Future<void> main() async {
  final dynamic conn = null; // TODO: Get hold of a DatabaseConnectionPool
  final dynamic dialect = null; // TODO: Get hold of an SqlDialect object
  // ignore: argument_type_not_assignable
  final db = Database<PrimaryDatabase>(conn, dialect);

  //await db.migrate();

  // Create 3 users
  await db.users
      .insert(
        userId: toExpr(12),
        name: toExpr('alice'),
        email: toExpr('alice@wonderland.com'),
      )
      .execute();
  await db.users
      .insert(
        userId: toExpr(13),
        name: toExpr('trudy'),
        email: toExpr('trudy@evil.inc'),
      )
      .execute();
  await db.users
      .insert(
        userId: toExpr(14),
        name: toExpr('bob'),
        email: toExpr('bob@builders.com'),
      )
      .execute();

  // Create two packages
  await db.packages
      .insert(
        packageName: toExpr('try'),
        ownerId: toExpr(12),
        likes: toExpr(0),
        publisher: toExpr(null),
      )
      .execute();
  await db.packages
      .insert(
        packageName: toExpr('retry'),
        ownerId: toExpr(12),
        likes: toExpr(0),
        publisher: toExpr(null),
      )
      .execute();

  // Create some likes
  await db.likes
      .insert(userId: toExpr(12), packageName: toExpr('retry'))
      .execute();
  await db.likes
      .insert(userId: toExpr(13), packageName: toExpr('try'))
      .execute();
  await db.likes
      .insert(userId: toExpr(14), packageName: toExpr('retry'))
      .execute();

  // Try to fetch all users
  {
    final users = await db.users.fetch();
    assert(users.length == 2);
  }

  // List alice and all her liked packages
  {
    final email = 'alice@wonderland.com';
    final user = await db.users.byEmail(email).fetch();
    if (user != null) {
      print('${user.email} has liked');
      final queryLikes =
          db.likes.where((like) => like.userId.equalsValue(user.userId));
      await for (final like in queryLikes.stream()) {
        print(like.packageName);
      }
    } else {
      print('Could not find user');
    }
  }

  // List packages with more than zero likes
  {
    // TODO: ...
  }

  {
    final users = await db.users
        .where((user) => user.email.endsWithValue('@google.com'))
        .orderBy((user) => [(user.email, Order.ascending)])
        .offset(5)
        .limit(10)
        .fetch();
    print(users.first.email);
  }

  // List users who has liked a package that has more than 1 likes
  // This essentially users that like packages other people like.
  {
    // TODO: ...
  }

  // We can do transactions
  {
    await db.transact(() async {
      await db.users.where((u) => u.email.endsWithValue('@google.com')).fetch();
      await db.likes
          .where((l) => l.packageName.startsWithValue('_').not())
          .fetch();

      await db.transact(() async {
        await db.users.byEmail('user@example.com').delete().execute();

        await db.transact(() async {
          await db.users
              .insert(
                userId: toExpr(42),
                name: toExpr('user'),
                email: toExpr('user@example.com'),
              )
              .execute();
        });
      });
    });
  }
}
