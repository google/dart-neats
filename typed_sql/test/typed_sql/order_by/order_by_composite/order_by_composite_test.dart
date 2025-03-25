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

import 'package:typed_sql/typed_sql.dart';

import '../../testrunner.dart';

part 'order_by_composite_test.g.dart';

abstract final class TestDatabase extends Schema {
  Table<Item> get items;
}

@PrimaryKey(['id'])
abstract final class Item extends Model {
  @AutoIncrement()
  int get id;

  String get text;
  double get real;
  DateTime get timestamp;
  int? get integer;
}

final epoch = DateTime.fromMicrosecondsSinceEpoch(0).toUtc();
final yesterday = DateTime.parse('2025-03-09T11:34:36.164006Z');
final today = DateTime.parse('2025-03-10T11:34:36.164006Z');
final tomorrow = DateTime.parse('2025-03-11T11:34:36.164006Z');

final initialItems = [
  (
    text: 'a',
    real: 1.0,
    integer: 1,
    timestamp: yesterday,
  ),
  (
    text: 'a',
    real: 2.0,
    integer: 2,
    timestamp: today,
  ),
  (
    text: 'a',
    real: 3.0,
    integer: 3,
    timestamp: tomorrow,
  ),
  (
    text: 'b',
    real: 3.0,
    integer: 1,
    timestamp: yesterday,
  ),
  (
    text: 'b',
    real: 2.0,
    integer: 2,
    timestamp: today,
  ),
  (
    text: 'b',
    real: 1.0,
    integer: 3,
    timestamp: tomorrow,
  ),
  (
    text: 'c',
    real: 1.0,
    integer: null,
    timestamp: yesterday,
  ),
  (
    text: 'c',
    real: 2.0,
    integer: null,
    timestamp: today,
  ),
];

void main() {
  final r = TestRunner<TestDatabase>(
    setup: (db) async {
      await db.createTables();

      // Insert initial items
      for (final v in initialItems) {
        await db.items
            .insert(
              text: literal(v.text),
              real: literal(v.real),
              integer: literal(v.integer),
              timestamp: literal(v.timestamp),
            )
            .execute();
      }
    },
  );

  r.addTest('orderBy(.id)', (db) async {
    final result = await db.items
        .orderBy((i) => [(i.id, Order.ascending)])
        .select((i) => (i.id,))
        .fetch();
    check(result).deepEquals([1, 2, 3, 4, 5, 6, 7, 8]);
  });

  // Test orderings by .text, .real
  r.addTest('orderBy(.text asc, .real asc)', (db) async {
    final result = await db.items
        .orderBy((i) => [
              (i.text, Order.ascending),
              (i.real, Order.ascending),
              (i.id, Order.ascending), // ensure consistent tests
            ])
        .select((i) => (i.id, i.text, i.real))
        .fetch();
    check(result).deepEquals([
      (1, 'a', 1.0),
      (2, 'a', 2.0),
      (3, 'a', 3.0),
      (6, 'b', 1.0),
      (5, 'b', 2.0),
      (4, 'b', 3.0),
      (7, 'c', 1.0),
      (8, 'c', 2.0),
    ]);
  });

  r.addTest('orderBy(.text asc, .real desc)', (db) async {
    final result = await db.items
        .orderBy((i) => [
              (i.text, Order.ascending),
              (i.real, Order.descending),
              (i.id, Order.ascending), // ensure consistent tests
            ])
        .select((i) => (i.id, i.text, i.real))
        .fetch();
    check(result).deepEquals([
      (3, 'a', 3.0),
      (2, 'a', 2.0),
      (1, 'a', 1.0),
      (4, 'b', 3.0),
      (5, 'b', 2.0),
      (6, 'b', 1.0),
      (8, 'c', 2.0),
      (7, 'c', 1.0),
    ]);
  });

  r.addTest('orderBy(.text desc, .real asc)', (db) async {
    final result = await db.items
        .orderBy((i) => [
              (i.text, Order.descending),
              (i.real, Order.ascending),
              (i.id, Order.ascending), // ensure consistent tests
            ])
        .select((i) => (i.id, i.text, i.real))
        .fetch();
    check(result).deepEquals([
      (7, 'c', 1.0),
      (8, 'c', 2.0),
      (6, 'b', 1.0),
      (5, 'b', 2.0),
      (4, 'b', 3.0),
      (1, 'a', 1.0),
      (2, 'a', 2.0),
      (3, 'a', 3.0),
    ]);
  });

  r.addTest('orderBy(.text desc, .real desc)', (db) async {
    final result = await db.items
        .orderBy((i) => [
              (i.text, Order.descending),
              (i.real, Order.descending),
              (i.id, Order.ascending), // ensure consistent tests
            ])
        .select((i) => (i.id, i.text, i.real))
        .fetch();
    check(result).deepEquals([
      (8, 'c', 2.0),
      (7, 'c', 1.0),
      (4, 'b', 3.0),
      (5, 'b', 2.0),
      (6, 'b', 1.0),
      (3, 'a', 3.0),
      (2, 'a', 2.0),
      (1, 'a', 1.0),
    ]);
  });

  // Test orderings by .text, .integer
  r.addTest('orderBy(.text asc, .integer asc)', (db) async {
    final result = await db.items
        .orderBy((i) => [
              (i.text, Order.ascending),
              (i.integer, Order.ascending),
              (i.id, Order.ascending), // ensure consistent tests
            ])
        .select((i) => (i.id, i.text, i.integer))
        .fetch();
    check(result).deepEquals([
      (1, 'a', 1),
      (2, 'a', 2),
      (3, 'a', 3),
      (4, 'b', 1),
      (5, 'b', 2),
      (6, 'b', 3),
      (7, 'c', null),
      (8, 'c', null),
    ]);
  });

  r.addTest('orderBy(.text asc, .integer desc)', (db) async {
    final result = await db.items
        .orderBy((i) => [
              (i.text, Order.ascending),
              (i.integer, Order.descending),
              (i.id, Order.ascending), // ensure consistent tests
            ])
        .select((i) => (i.id, i.text, i.integer))
        .fetch();
    check(result).deepEquals([
      (3, 'a', 3),
      (2, 'a', 2),
      (1, 'a', 1),
      (6, 'b', 3),
      (5, 'b', 2),
      (4, 'b', 1),
      (7, 'c', null),
      (8, 'c', null),
    ]);
  });

  r.addTest('orderBy(.text desc, .integer asc)', (db) async {
    final result = await db.items
        .orderBy((i) => [
              (i.text, Order.descending),
              (i.integer, Order.ascending),
              (i.id, Order.ascending), // ensure consistent tests
            ])
        .select((i) => (i.id, i.text, i.integer))
        .fetch();
    check(result).deepEquals([
      (7, 'c', null),
      (8, 'c', null),
      (4, 'b', 1),
      (5, 'b', 2),
      (6, 'b', 3),
      (1, 'a', 1),
      (2, 'a', 2),
      (3, 'a', 3),
    ]);
  });

  r.addTest('orderBy(.text desc, .integer desc)', (db) async {
    final result = await db.items
        .orderBy((i) => [
              (i.text, Order.descending),
              (i.integer, Order.descending),
              (i.id, Order.ascending), // ensure consistent tests
            ])
        .select((i) => (i.id, i.text, i.integer))
        .fetch();
    check(result).deepEquals([
      (7, 'c', null),
      (8, 'c', null),
      (6, 'b', 3),
      (5, 'b', 2),
      (4, 'b', 1),
      (3, 'a', 3),
      (2, 'a', 2),
      (1, 'a', 1),
    ]);
  });

  // Test orderings by .integer, .text
  r.addTest('orderBy(.integer asc, .text asc)', (db) async {
    final result = await db.items
        .orderBy((i) => [
              (i.integer, Order.ascending),
              (i.text, Order.ascending),
              (i.id, Order.ascending), // ensure consistent tests
            ])
        .select((i) => (i.id, i.integer, i.text))
        .fetch();
    check(result).deepEquals([
      (1, 1, 'a'),
      (4, 1, 'b'),
      (2, 2, 'a'),
      (5, 2, 'b'),
      (3, 3, 'a'),
      (6, 3, 'b'),
      (7, null, 'c'),
      (8, null, 'c'),
    ]);
  });

  r.addTest('orderBy(.integer asc, .text desc)', (db) async {
    final result = await db.items
        .orderBy((i) => [
              (i.integer, Order.ascending),
              (i.text, Order.descending),
              (i.id, Order.ascending), // ensure consistent tests
            ])
        .select((i) => (i.id, i.integer, i.text))
        .fetch();
    check(result).deepEquals([
      (4, 1, 'b'),
      (1, 1, 'a'),
      (5, 2, 'b'),
      (2, 2, 'a'),
      (6, 3, 'b'),
      (3, 3, 'a'),
      (7, null, 'c'),
      (8, null, 'c'),
    ]);
  });

  r.addTest('orderBy(.integer desc, .text asc)', (db) async {
    final result = await db.items
        .orderBy((i) => [
              (i.integer, Order.descending),
              (i.text, Order.ascending),
              (i.id, Order.ascending), // ensure consistent tests
            ])
        .select((i) => (i.id, i.integer, i.text))
        .fetch();
    check(result).deepEquals([
      (3, 3, 'a'),
      (6, 3, 'b'),
      (2, 2, 'a'),
      (5, 2, 'b'),
      (1, 1, 'a'),
      (4, 1, 'b'),
      (7, null, 'c'),
      (8, null, 'c'),
    ]);
  });

  r.addTest('orderBy(.integer desc, .text desc)', (db) async {
    final result = await db.items
        .orderBy((i) => [
              (i.integer, Order.descending),
              (i.text, Order.descending),
              (i.id, Order.ascending), // ensure consistent tests
            ])
        .select((i) => (i.id, i.integer, i.text))
        .fetch();
    check(result).deepEquals([
      (6, 3, 'b'),
      (3, 3, 'a'),
      (5, 2, 'b'),
      (2, 2, 'a'),
      (4, 1, 'b'),
      (1, 1, 'a'),
      (7, null, 'c'),
      (8, null, 'c'),
    ]);
  });

  // Test orderings by .timestamp, .text
  r.addTest('orderBy(.timestamp asc, .text asc)', (db) async {
    final result = await db.items
        .orderBy((i) => [
              (i.timestamp, Order.ascending),
              (i.text, Order.ascending),
              (i.id, Order.ascending), // ensure consistent tests
            ])
        .select((i) => (i.id, i.timestamp, i.text))
        .fetch();
    check(result).deepEquals([
      (1, yesterday, 'a'),
      (4, yesterday, 'b'),
      (7, yesterday, 'c'),
      (2, today, 'a'),
      (5, today, 'b'),
      (8, today, 'c'),
      (3, tomorrow, 'a'),
      (6, tomorrow, 'b'),
    ]);
  });

  r.addTest('orderBy(.timestamp asc, .text desc)', (db) async {
    final result = await db.items
        .orderBy((i) => [
              (i.timestamp, Order.ascending),
              (i.text, Order.descending),
              (i.id, Order.ascending), // ensure consistent tests
            ])
        .select((i) => (i.id, i.timestamp, i.text))
        .fetch();
    check(result).deepEquals([
      (7, yesterday, 'c'),
      (4, yesterday, 'b'),
      (1, yesterday, 'a'),
      (8, today, 'c'),
      (5, today, 'b'),
      (2, today, 'a'),
      (6, tomorrow, 'b'),
      (3, tomorrow, 'a'),
    ]);
  });

  r.addTest('orderBy(.timestamp desc, .text asc)', (db) async {
    final result = await db.items
        .orderBy((i) => [
              (i.timestamp, Order.descending),
              (i.text, Order.ascending),
              (i.id, Order.ascending), // ensure consistent tests
            ])
        .select((i) => (i.id, i.timestamp, i.text))
        .fetch();
    check(result).deepEquals([
      (3, tomorrow, 'a'),
      (6, tomorrow, 'b'),
      (2, today, 'a'),
      (5, today, 'b'),
      (8, today, 'c'),
      (1, yesterday, 'a'),
      (4, yesterday, 'b'),
      (7, yesterday, 'c'),
    ]);
  });

  r.addTest('orderBy(.timestamp desc, .text desc)', (db) async {
    final result = await db.items
        .orderBy((i) => [
              (i.timestamp, Order.descending),
              (i.text, Order.descending),
              (i.id, Order.ascending), // ensure consistent tests
            ])
        .select((i) => (i.id, i.timestamp, i.text))
        .fetch();
    check(result).deepEquals([
      (6, tomorrow, 'b'),
      (3, tomorrow, 'a'),
      (8, today, 'c'),
      (5, today, 'b'),
      (2, today, 'a'),
      (7, yesterday, 'c'),
      (4, yesterday, 'b'),
      (1, yesterday, 'a'),
    ]);
  });

  r.run();
}
