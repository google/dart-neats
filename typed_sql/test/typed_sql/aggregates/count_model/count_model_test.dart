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

import '../../testrunner.dart';

part 'count_model_test.g.dart';

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

  r.addTest('items.count()', (db) async {
    final result = await db.items.count().fetch();
    check(result).equals(8);
  });

  r.addTest('items.asSubQuery.count()', (db) async {
    final result = await db.select(
      (db.items.asSubQuery.count(),),
    ).fetch();
    check(result).equals(8);
  });

  r.addTest('items.where(.integer.isNotNull).count()', (db) async {
    final result =
        await db.items.where((i) => i.integer.isNotNull()).count().fetch();
    check(result).equals(6);
  });

  r.addTest('items.asSubQuery.where(.integer.isNotNull).count()', (db) async {
    final result = await db.select(
      (db.items.asSubQuery.where((i) => i.integer.isNotNull()).count(),),
    ).fetch();
    check(result).equals(6);
  });

  r.addTest('items.select(.integer, .text).count()', (db) async {
    final result = await db.items
        .select(
          (i) => (i.integer, i.text),
        )
        .count()
        .fetch();
    check(result).equals(8);
  });

  r.addTest('items.select(.text).count()', (db) async {
    final result = await db.items
        .select(
          (i) => (i.text,),
        )
        .count()
        .fetch();
    check(result).equals(8);
  });

  r.addTest('items.select(.text).distinct().count()', (db) async {
    final result = await db.items
        .select(
          (i) => (i.text,),
        )
        .distinct()
        .count()
        .fetch();
    check(result).equals(3);
  });

  r.addTest('items.select(.integer, .text).distinct().count()', (db) async {
    final result = await db.items
        .select(
          (i) => (i.integer, i.text),
        )
        .distinct()
        .count()
        .fetch();
    check(result).equals(7);
  });

  r.addTest('items.distinct().count()', (db) async {
    final result = await db.items.distinct().count().fetch();
    check(result).equals(8);
  });

  r.run();
}
