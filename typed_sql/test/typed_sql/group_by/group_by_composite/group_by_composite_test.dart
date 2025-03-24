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

part 'group_by_composite_test.g.dart';

abstract final class TestDatabase extends Schema {
  Table<Item> get items;
}

@PrimaryKey(['id'])
abstract final class Item extends Model {
  @AutoIncrement()
  int get id;

  String get text;
  double get real;
  int get integer;
  DateTime get timestamp;

  String? get optText;
  double? get optReal;
  int? get optInteger;
  DateTime? get optTimestamp;
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
    optText: 'a',
    optReal: 1.0,
    optInteger: 1,
    optTimestamp: yesterday,
  ),
  (
    text: 'a',
    real: 2.0,
    integer: 2,
    timestamp: today,
    optText: 'a',
    optReal: 2.0,
    optInteger: 2,
    optTimestamp: today,
  ),
  (
    text: 'a',
    real: 3.0,
    integer: 3,
    timestamp: tomorrow,
    optText: 'a',
    optReal: 3.0,
    optInteger: 3,
    optTimestamp: tomorrow,
  ),
  (
    text: 'b',
    real: 1.0,
    integer: 1,
    timestamp: yesterday,
    optText: 'b',
    optReal: 1.0,
    optInteger: 1,
    optTimestamp: yesterday,
  ),
  (
    text: 'b',
    real: 2.0,
    integer: 2,
    timestamp: today,
    optText: 'b',
    optReal: 2.0,
    optInteger: 2,
    optTimestamp: today,
  ),
  (
    text: 'b',
    real: 3.0,
    integer: 3,
    timestamp: tomorrow,
    optText: 'b',
    optReal: 3.0,
    optInteger: 3,
    optTimestamp: tomorrow,
  ),
  (
    text: 'c',
    real: 1.0,
    integer: 1,
    timestamp: yesterday,
    optText: null,
    optReal: null,
    optInteger: null,
    optTimestamp: null,
  ),
  (
    text: 'c',
    real: 2.0,
    integer: 2,
    timestamp: today,
    optText: null,
    optReal: null,
    optInteger: null,
    optTimestamp: null,
  ),
];

void main() {
  final r = TestRunner<TestDatabase>(
    setup: (db) async {
      await db.createTables();

      // Insert test Authors and books
      for (final v in initialItems) {
        await db.items
            .insert(
              text: literal(v.text),
              real: literal(v.real),
              integer: literal(v.integer),
              timestamp: literal(v.timestamp),
              optText: literal(v.optText),
              optReal: literal(v.optReal),
              optInteger: literal(v.optInteger),
              optTimestamp: literal(v.optTimestamp),
            )
            .execute();
      }
    },
  );

  // In this file we're going to test sum, avg, min, max and count grouped by
  // a single column, two columns and 3 columns.

  // Test .real for sum(), avg(), min(), max(), count(), grouped by text, integer
  r.addTest('groupBy(.text).aggregate(sum/avg/min/max(.real), count)',
      (db) async {
    final result = await db.items
        .groupBy((i) => (i.text,))
        .aggregate(
          (agg) => agg
              //
              .sum((i) => i.real)
              .avg((i) => i.real)
              .min((i) => i.real)
              .max((i) => i.real)
              .count(),
        )
        .fetch();

    check(result).unorderedEquals([
      ('a', 6.0, 2.0, 1.0, 3.0, 3),
      ('b', 6.0, 2.0, 1.0, 3.0, 3),
      ('c', 3.0, 1.5, 1.0, 2.0, 2),
    ]);
  });

  r.addTest('groupBy(.text, .integer).aggregate(sum/avg/min/max(.real), count)',
      (db) async {
    final result = await db.items
        .groupBy((i) => (i.text, i.integer))
        .aggregate(
          (agg) => agg
              //
              .sum((i) => i.real)
              .avg((i) => i.real)
              .min((i) => i.real)
              .max((i) => i.real)
              .count(),
        )
        .fetch();

    check(result).unorderedEquals([
      ('a', 1, 1.0, 1.0, 1.0, 1.0, 1),
      ('a', 2, 2.0, 2.0, 2.0, 2.0, 1),
      ('a', 3, 3.0, 3.0, 3.0, 3.0, 1),
      ('b', 1, 1.0, 1.0, 1.0, 1.0, 1),
      ('b', 2, 2.0, 2.0, 2.0, 2.0, 1),
      ('b', 3, 3.0, 3.0, 3.0, 3.0, 1),
      ('c', 1, 1.0, 1.0, 1.0, 1.0, 1),
      ('c', 2, 2.0, 2.0, 2.0, 2.0, 1),
    ]);
  });

  // Test .real for sum(), avg(), min(), max(), count(), grouped by optText, optInteger
  r.addTest(
      'groupBy(.optText, .optInteger).aggregate(sum/avg/min/max(.real), count)',
      (db) async {
    final result = await db.items
        .groupBy((i) => (i.optText, i.optInteger))
        .aggregate(
          (agg) => agg
              //
              .sum((i) => i.real)
              .avg((i) => i.real)
              .min((i) => i.real)
              .max((i) => i.real)
              .count(),
        )
        .fetch();

    check(result).unorderedEquals([
      ('a', 1, 1.0, 1.0, 1.0, 1.0, 1),
      ('a', 2, 2.0, 2.0, 2.0, 2.0, 1),
      ('a', 3, 3.0, 3.0, 3.0, 3.0, 1),
      ('b', 1, 1.0, 1.0, 1.0, 1.0, 1),
      ('b', 2, 2.0, 2.0, 2.0, 2.0, 1),
      ('b', 3, 3.0, 3.0, 3.0, 3.0, 1),
      (null, null, 3.0, 1.5, 1.0, 2.0, 2),
    ]);
  });

  // Test .optReal for sum(), avg(), min(), max(), count(), grouped by text, integer
  r.addTest(
      'groupBy(.text, .integer).aggregate(sum/avg/min/max(.optReal), count)',
      (db) async {
    final result = await db.items
        .groupBy((i) => (i.text, i.integer))
        .aggregate(
          (agg) => agg
              //
              .sum((i) => i.optReal)
              .avg((i) => i.optReal)
              .min((i) => i.optReal)
              .max((i) => i.optReal)
              .count(),
        )
        .fetch();

    check(result).unorderedEquals([
      ('a', 1, 1.0, 1.0, 1.0, 1.0, 1),
      ('a', 2, 2.0, 2.0, 2.0, 2.0, 1),
      ('a', 3, 3.0, 3.0, 3.0, 3.0, 1),
      ('b', 1, 1.0, 1.0, 1.0, 1.0, 1),
      ('b', 2, 2.0, 2.0, 2.0, 2.0, 1),
      ('b', 3, 3.0, 3.0, 3.0, 3.0, 1),
      ('c', 1, 0, null, null, null, 1),
      ('c', 2, 0, null, null, null, 1),
    ]);
  });

  // Test .optReal for sum(), avg(), min(), max(), count(), grouped by optText, optInteger
  r.addTest(
      'groupBy(.optText, .optInteger).aggregate(sum/avg/min/max(.optReal), count)',
      (db) async {
    final result = await db.items
        .groupBy((i) => (i.optText, i.optInteger))
        .aggregate(
          (agg) => agg
              //
              .sum((i) => i.optReal)
              .avg((i) => i.optReal)
              .min((i) => i.optReal)
              .max((i) => i.optReal)
              .count(),
        )
        .fetch();

    check(result).unorderedEquals([
      ('a', 1, 1.0, 1.0, 1.0, 1.0, 1),
      ('a', 2, 2.0, 2.0, 2.0, 2.0, 1),
      ('a', 3, 3.0, 3.0, 3.0, 3.0, 1),
      ('b', 1, 1.0, 1.0, 1.0, 1.0, 1),
      ('b', 2, 2.0, 2.0, 2.0, 2.0, 1),
      ('b', 3, 3.0, 3.0, 3.0, 3.0, 1),
      (null, null, 0, null, null, null, 2),
    ]);
  });

  // Test .integer for sum(), avg(), min(), max(), count(), grouped by text, integer
  r.addTest(
      'groupBy(.text, .integer).aggregate(sum/avg/min/max(.integer), count)',
      (db) async {
    final result = await db.items
        .groupBy((i) => (i.text, i.integer))
        .aggregate(
          (agg) => agg
              //
              .sum((i) => i.integer)
              .avg((i) => i.integer)
              .min((i) => i.integer)
              .max((i) => i.integer)
              .count(),
        )
        .fetch();

    check(result).unorderedEquals([
      ('a', 1, 1, 1.0, 1, 1, 1),
      ('a', 2, 2, 2.0, 2, 2, 1),
      ('a', 3, 3, 3.0, 3, 3, 1),
      ('b', 1, 1, 1.0, 1, 1, 1),
      ('b', 2, 2, 2.0, 2, 2, 1),
      ('b', 3, 3, 3.0, 3, 3, 1),
      ('c', 1, 1, 1.0, 1, 1, 1),
      ('c', 2, 2, 2.0, 2, 2, 1),
    ]);
  });

  // Test .integer for sum(), avg(), min(), max(), count(), grouped by optText, optInteger
  r.addTest(
      'groupBy(.optText, .optInteger).aggregate(sum/avg/min/max(.integer), count)',
      (db) async {
    final result = await db.items
        .groupBy((i) => (i.optText, i.optInteger))
        .aggregate(
          (agg) => agg
              //
              .sum((i) => i.integer)
              .avg((i) => i.integer)
              .min((i) => i.integer)
              .max((i) => i.integer)
              .count(),
        )
        .fetch();

    check(result).unorderedEquals([
      ('a', 1, 1, 1.0, 1, 1, 1),
      ('a', 2, 2, 2.0, 2, 2, 1),
      ('a', 3, 3, 3.0, 3, 3, 1),
      ('b', 1, 1, 1.0, 1, 1, 1),
      ('b', 2, 2, 2.0, 2, 2, 1),
      ('b', 3, 3, 3.0, 3, 3, 1),
      (null, null, 3, 1.5, 1, 2, 2),
    ]);
  });

  // Test .optInteger for sum(), avg(), min(), max(), count(), grouped by text, integer
  r.addTest(
      'groupBy(.text, .integer).aggregate(sum/avg/min/max(.optInteger), count)',
      (db) async {
    final result = await db.items
        .groupBy((i) => (i.text, i.integer))
        .aggregate(
          (agg) => agg
              //
              .sum((i) => i.optInteger)
              .avg((i) => i.optInteger)
              .min((i) => i.optInteger)
              .max((i) => i.optInteger)
              .count(),
        )
        .fetch();

    check(result).unorderedEquals([
      ('a', 1, 1, 1.0, 1, 1, 1),
      ('a', 2, 2, 2.0, 2, 2, 1),
      ('a', 3, 3, 3.0, 3, 3, 1),
      ('b', 1, 1, 1.0, 1, 1, 1),
      ('b', 2, 2, 2.0, 2, 2, 1),
      ('b', 3, 3, 3.0, 3, 3, 1),
      ('c', 1, 0, null, null, null, 1),
      ('c', 2, 0, null, null, null, 1),
    ]);
  });

  // Test .optInteger for sum(), avg(), min(), max(), count(), grouped by optText, optInteger
  r.addTest(
      'groupBy(.optText, .optInteger).aggregate(sum/avg/min/max(.optInteger), count)',
      (db) async {
    final result = await db.items
        .groupBy((i) => (i.optText, i.optInteger))
        .aggregate(
          (agg) => agg
              //
              .sum((i) => i.optInteger)
              .avg((i) => i.optInteger)
              .min((i) => i.optInteger)
              .max((i) => i.optInteger)
              .count(),
        )
        .fetch();

    check(result).unorderedEquals([
      ('a', 1, 1, 1.0, 1, 1, 1),
      ('a', 2, 2, 2.0, 2, 2, 1),
      ('a', 3, 3, 3.0, 3, 3, 1),
      ('b', 1, 1, 1.0, 1, 1, 1),
      ('b', 2, 2, 2.0, 2, 2, 1),
      ('b', 3, 3, 3.0, 3, 3, 1),
      (null, null, 0, null, null, null, 2),
    ]);
  });

  // Test .text for min(), max(), count(), grouped by text, integer
  r.addTest('groupBy(.text, .integer).aggregate(min/max(.text), count)',
      (db) async {
    final result = await db.items
        .groupBy((i) => (i.text, i.integer))
        .aggregate(
          (agg) => agg
              //
              .min((i) => i.text)
              .max((i) => i.text)
              .count(),
        )
        .fetch();

    check(result).unorderedEquals([
      ('a', 1, 'a', 'a', 1),
      ('a', 2, 'a', 'a', 1),
      ('a', 3, 'a', 'a', 1),
      ('b', 1, 'b', 'b', 1),
      ('b', 2, 'b', 'b', 1),
      ('b', 3, 'b', 'b', 1),
      ('c', 1, 'c', 'c', 1),
      ('c', 2, 'c', 'c', 1),
    ]);
  });

  // Test .text for min(), max(), count(), grouped by optText, optInteger
  r.addTest('groupBy(.optText, .optInteger).aggregate(min/max(.text), count)',
      (db) async {
    final result = await db.items
        .groupBy((i) => (i.optText, i.optInteger))
        .aggregate(
          (agg) => agg
              //
              .min((i) => i.text)
              .max((i) => i.text)
              .count(),
        )
        .fetch();

    check(result).unorderedEquals([
      ('a', 1, 'a', 'a', 1),
      ('a', 2, 'a', 'a', 1),
      ('a', 3, 'a', 'a', 1),
      ('b', 1, 'b', 'b', 1),
      ('b', 2, 'b', 'b', 1),
      ('b', 3, 'b', 'b', 1),
      (null, null, 'c', 'c', 2),
    ]);
  });

  // Test .optText for min(), max(), count(), grouped by text, integer
  r.addTest('groupBy(.text, .integer).aggregate(min/max(.optText), count)',
      (db) async {
    final result = await db.items
        .groupBy((i) => (i.text, i.integer))
        .aggregate(
          (agg) => agg
              //
              .min((i) => i.optText)
              .max((i) => i.optText)
              .count(),
        )
        .fetch();

    check(result).unorderedEquals([
      ('a', 1, 'a', 'a', 1),
      ('a', 2, 'a', 'a', 1),
      ('a', 3, 'a', 'a', 1),
      ('b', 1, 'b', 'b', 1),
      ('b', 2, 'b', 'b', 1),
      ('b', 3, 'b', 'b', 1),
      ('c', 1, null, null, 1),
      ('c', 2, null, null, 1),
    ]);
  });

  // Test .optText for min(), max(), count(), grouped by optText, optInteger
  r.addTest(
      'groupBy(.optText, .optInteger).aggregate(min/max(.optText), count)',
      (db) async {
    final result = await db.items
        .groupBy((i) => (i.optText, i.optInteger))
        .aggregate(
          (agg) => agg
              //
              .min((i) => i.optText)
              .max((i) => i.optText)
              .count(),
        )
        .fetch();

    check(result).unorderedEquals([
      ('a', 1, 'a', 'a', 1),
      ('a', 2, 'a', 'a', 1),
      ('a', 3, 'a', 'a', 1),
      ('b', 1, 'b', 'b', 1),
      ('b', 2, 'b', 'b', 1),
      ('b', 3, 'b', 'b', 1),
      (null, null, null, null, 2),
    ]);
  });

  // Test .timestamp for min(), max(), count(), grouped by text, integer
  r.addTest('groupBy(.text, .integer).aggregate(min/max(.timestamp), count)',
      (db) async {
    final result = await db.items
        .groupBy((i) => (i.text, i.integer))
        .aggregate(
          (agg) => agg
              //
              .min((i) => i.timestamp)
              .max((i) => i.timestamp)
              .count(),
        )
        .fetch();

    check(result).unorderedEquals([
      ('a', 1, yesterday, yesterday, 1),
      ('a', 2, today, today, 1),
      ('a', 3, tomorrow, tomorrow, 1),
      ('b', 1, yesterday, yesterday, 1),
      ('b', 2, today, today, 1),
      ('b', 3, tomorrow, tomorrow, 1),
      ('c', 1, yesterday, yesterday, 1),
      ('c', 2, today, today, 1),
    ]);
  });

  // Test .timestamp for min(), max(), count(), grouped by optText, optInteger
  r.addTest(
      'groupBy(.optText, .optInteger).aggregate(min/max(.timestamp), count)',
      (db) async {
    final result = await db.items
        .groupBy((i) => (i.optText, i.optInteger))
        .aggregate(
          (agg) => agg
              //
              .min((i) => i.timestamp)
              .max((i) => i.timestamp)
              .count(),
        )
        .fetch();

    check(result).unorderedEquals([
      ('a', 1, yesterday, yesterday, 1),
      ('a', 2, today, today, 1),
      ('a', 3, tomorrow, tomorrow, 1),
      ('b', 1, yesterday, yesterday, 1),
      ('b', 2, today, today, 1),
      ('b', 3, tomorrow, tomorrow, 1),
      (null, null, yesterday, today, 2),
    ]);
  });

  // Test .optTimestamp for min(), max(), count(), grouped by text, integer
  r.addTest('groupBy(.text, .integer).aggregate(min/max(.optTimestamp), count)',
      (db) async {
    final result = await db.items
        .groupBy((i) => (i.text, i.integer))
        .aggregate(
          (agg) => agg
              //
              .min((i) => i.optTimestamp)
              .max((i) => i.optTimestamp)
              .count(),
        )
        .fetch();

    check(result).unorderedEquals([
      ('a', 1, yesterday, yesterday, 1),
      ('a', 2, today, today, 1),
      ('a', 3, tomorrow, tomorrow, 1),
      ('b', 1, yesterday, yesterday, 1),
      ('b', 2, today, today, 1),
      ('b', 3, tomorrow, tomorrow, 1),
      ('c', 1, null, null, 1),
      ('c', 2, null, null, 1),
    ]);
  });

  // Test .optTimestamp for min(), max(), count(), grouped by optText, optInteger
  r.addTest(
      'groupBy(.optText, .optInteger).aggregate(min/max(.optTimestamp), count)',
      (db) async {
    final result = await db.items
        .groupBy((i) => (i.optText, i.optInteger))
        .aggregate(
          (agg) => agg
              //
              .min((i) => i.optTimestamp)
              .max((i) => i.optTimestamp)
              .count(),
        )
        .fetch();

    check(result).unorderedEquals([
      ('a', 1, yesterday, yesterday, 1),
      ('a', 2, today, today, 1),
      ('a', 3, tomorrow, tomorrow, 1),
      ('b', 1, yesterday, yesterday, 1),
      ('b', 2, today, today, 1),
      ('b', 3, tomorrow, tomorrow, 1),
      (null, null, null, null, 2),
    ]);
  });

  r.run();
}
