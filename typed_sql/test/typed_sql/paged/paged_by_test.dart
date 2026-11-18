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

import '../testrunner.dart';

part 'paged_by_test.g.dart';

abstract final class TestDatabase extends Schema {
  Table<User> get users;
  Table<Event> get events;
}

@PrimaryKey(['userId'])
@Unique(name: 'fullName', fields: ['firstName', 'lastName'])
abstract final class User extends Row {
  int get userId;

  @Unique.field()
  @SqlOverride.field(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String get email;

  @SqlOverride.field(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String get firstName;

  @SqlOverride.field(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String get lastName;

  /// Nullable, so `.pagedByNickname` is not generated.
  @Unique.field()
  @SqlOverride.field(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String? get nickname;
}

final class Source implements CustomDataType<String> {
  final String value;
  Source(this.value);
  factory Source.fromDatabase(String value) => Source(value);
  @override
  String toDatabase() => value;
}

@PrimaryKey(['source', 'created', 'seq'])
abstract final class Event extends Row {
  @SqlOverride.field(dialect: 'mysql', columnType: 'VARCHAR(255)')
  Source get source;

  DateTime get created;

  double get seq;
}

final _users = [
  (userId: 1, email: 'c@x', firstName: 'Bob', lastName: 'Smith', nick: 'b'),
  (userId: 2, email: 'a@x', firstName: 'Alice', lastName: 'Smith', nick: null),
  (userId: 3, email: 'e@x', firstName: 'Alice', lastName: 'Jones', nick: null),
  (userId: 4, email: 'b@x', firstName: 'Carol', lastName: 'Adams', nick: 'c'),
  (userId: 5, email: 'd@x', firstName: 'Bob', lastName: 'Adams', nick: null),
];

final _t0 = DateTime.utc(2026, 1, 1, 12);
final _t1 = DateTime.utc(2026, 1, 1, 12, 0, 1);
final _t2 = DateTime.utc(2026, 1, 2);

final _events = [
  (source: 'b', created: _t0, seq: 1.5),
  (source: 'a', created: _t1, seq: 1.0),
  (source: 'a', created: _t0, seq: 2.0),
  (source: 'b', created: _t0, seq: 0.5),
  (source: 'a', created: _t0, seq: 1.0),
  (source: 'b', created: _t2, seq: 0.0),
  (source: 'a', created: _t2, seq: 3.0),
];

void main() {
  final r = TestRunner<TestDatabase>(
    setup: (db) async {
      await db.createTables();
      await db.users
          .insertValuesMapped(
            _users,
            userId: (u) => u.userId,
            email: (u) => u.email,
            firstName: (u) => u.firstName,
            lastName: (u) => u.lastName,
            nickname: (u) => u.nick,
          )
          .execute();
      await db.events
          .insertValuesMapped(
            _events,
            source: (e) => Source(e.source),
            created: (e) => e.created,
            seq: (e) => e.seq,
          )
          .execute();
    },
  );

  r.addTest('users.pagedByKey()', (db) async {
    for (final pageSize in [1, 2, 5, 6]) {
      final ids = await db.users
          .pagedByKey(pageSize: pageSize)
          .map((u) => u.userId)
          .toList();
      check(because: 'pageSize: $pageSize', ids).deepEquals([1, 2, 3, 4, 5]);
    }
  });

  r.addTest('users.pagedByKey(order: descending)', (db) async {
    final ids = await db.users
        .pagedByKey(order: Order.descending, pageSize: 2)
        .map((u) => u.userId)
        .toList();
    check(ids).deepEquals([5, 4, 3, 2, 1]);
  });

  r.addTest('users.where(..).pagedByKey(startFrom: ..)', (db) async {
    final user = await db.users.byKey(2).fetch();
    final ids = await db.users
        .where((u) => u.userId.equalsValue(4).isFalse())
        .pagedByKey(pageSize: 1, startFrom: user)
        .map((u) => u.userId)
        .toList();
    check(ids).deepEquals([3, 5]);
  });

  r.addTest('users.pagedByEmail()', (db) async {
    final emails = await db.users
        .pagedByEmail(pageSize: 2)
        .map((u) => u.email)
        .toList();
    check(emails).deepEquals(['a@x', 'b@x', 'c@x', 'd@x', 'e@x']);
  });

  r.addTest('users.pagedByFullName()', (db) async {
    final ids = await db.users
        .pagedByFullName(pageSize: 2)
        .map((u) => u.userId)
        .toList();
    check(ids).deepEquals([3, 2, 5, 1, 4]);
  });

  r.addTest('users.pagedByFullName(order: descending)', (db) async {
    final ids = await db.users
        .pagedByFullName(order: Order.descending, pageSize: 2)
        .map((u) => u.userId)
        .toList();
    check(ids).deepEquals([4, 1, 5, 2, 3]);
  });

  r.addTest('events.pagedByKey()', (db) async {
    for (final pageSize in [1, 2, 3, 7]) {
      final events = await db.events
          .pagedByKey(pageSize: pageSize)
          .map((e) => (e.source.value, e.created, e.seq))
          .toList();
      check(because: 'pageSize: $pageSize', events).deepEquals([
        ('a', _t0, 1.0),
        ('a', _t0, 2.0),
        ('a', _t1, 1.0),
        ('a', _t2, 3.0),
        ('b', _t0, 0.5),
        ('b', _t0, 1.5),
        ('b', _t2, 0.0),
      ]);
    }
  });

  r.addTest('events.pagedByKey(order: descending)', (db) async {
    final events = await db.events
        .pagedByKey(order: Order.descending, pageSize: 2)
        .map((e) => (e.source.value, e.created, e.seq))
        .toList();
    check(events).deepEquals([
      ('b', _t2, 0.0),
      ('b', _t0, 1.5),
      ('b', _t0, 0.5),
      ('a', _t2, 3.0),
      ('a', _t1, 1.0),
      ('a', _t0, 2.0),
      ('a', _t0, 1.0),
    ]);
  });

  r.addTest(
    'events.pagedByKey() with fractional seconds',
    (db) async {
      final t = DateTime.utc(2026, 1, 3, 12);
      await db.events
          .insertValuesMapped(
            [0, 1, 999, 1000, 1001, 100000, 100001, 999999],
            source: (_) => Source('c'),
            created: (us) => t.add(Duration(microseconds: us)),
            seq: (_) => 0.0,
          )
          .execute();

      final created = await db.events
          .where((e) => e.source.asEncoded().equalsValue('c'))
          .pagedByKey(pageSize: 1)
          .map((e) => e.created.difference(t).inMicroseconds)
          .toList();
      check(
        created,
      ).deepEquals([0, 1, 999, 1000, 1001, 100000, 100001, 999999]);
    },
    skipMysql: 'package:mysql1 drops fractional seconds when decoding DateTime',
  );

  r.run();
}
