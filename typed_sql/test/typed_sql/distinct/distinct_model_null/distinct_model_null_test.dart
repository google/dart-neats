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

part 'distinct_model_null_test.g.dart';

abstract final class TestDatabase extends Schema {
  Table<Item> get items;
}

@PrimaryKey(['id'])
abstract final class Item extends Model {
  @AutoIncrement()
  int get id;

  String? get text;
  int? get integer;
  double? get real;
}

final _testData = [
  (
    text: 'A',
    integer: 0,
    real: null,
  ),
  (
    text: 'A',
    integer: null,
    real: null,
  ),
  (
    text: 'A',
    integer: null,
    real: null,
  ),
  (
    text: 'B',
    integer: null,
    real: null,
  ),
  (
    text: 'C',
    integer: null,
    real: 3.14,
  ),
  (
    text: null,
    integer: 0,
    real: 3.14,
  ),
  (
    text: null,
    integer: 0,
    real: 1.2,
  ),
];

void main() {
  final r = TestRunner<TestDatabase>(
    setup: (db) async {
      await db.createTables();
      for (final v in _testData) {
        await db.items
            .insertLiteral(
              text: v.text,
              integer: v.integer,
              real: v.real,
            )
            .execute();
      }
    },
  );

  r.addTest('items.distinct()', (db) async {
    final items = await db.items.distinct().fetch();
    check(items).length.equals(7);
  });

  r.addTest('items.distinct().count()', (db) async {
    final count = await db.items.distinct().count().fetch();
    check(count).isNotNull().equals(7);
  });

  r.addTest('items.select(.text).distinct()', (db) async {
    final items = await db.items
        .select(
          (i) => (i.text,),
        )
        .distinct()
        .fetch();
    check(items).length.equals(4);
  });

  r.addTest('items.select(.text).distinct().count()', (db) async {
    final count = await db.items
        .select(
          (i) => (i.text,),
        )
        .distinct()
        .count()
        .fetch();
    check(count).isNotNull().equals(4);
  });

  r.addTest('items.select(.integer).distinct()', (db) async {
    final items = await db.items
        .select(
          (i) => (i.integer,),
        )
        .distinct()
        .fetch();
    check(items).length.equals(2);
  });

  r.addTest('items.select(.integer).distinct().count()', (db) async {
    final count = await db.items
        .select(
          (i) => (i.integer,),
        )
        .distinct()
        .count()
        .fetch();
    check(count).isNotNull().equals(2);
  });

  r.addTest('items.select(.real).distinct()', (db) async {
    final items = await db.items
        .select(
          (i) => (i.real,),
        )
        .distinct()
        .fetch();
    check(items).length.equals(3);
  });

  r.addTest('items.select(.value).distinct().count()', (db) async {
    final count = await db.items
        .select(
          (i) => (i.real,),
        )
        .distinct()
        .count()
        .fetch();
    check(count).isNotNull().equals(3);
  });

  r.addTest('items.select(.id).distinct()', (db) async {
    final items = await db.items
        .select(
          (i) => (i.id,),
        )
        .distinct()
        .fetch();
    check(items).length.equals(7);
  });

  r.addTest('items.select(.id).distinct().count()', (db) async {
    final count = await db.items
        .select(
          (i) => (i.id,),
        )
        .distinct()
        .count()
        .fetch();
    check(count).isNotNull().equals(7);
  });

  r.addTest('items.select(.text, .integer).distinct()', (db) async {
    final items = await db.items
        .select(
          (i) => (
            i.text,
            i.integer,
          ),
        )
        .distinct()
        .fetch();
    check(items).length.equals(5);
  });

  r.addTest('items.select(.text, .integer).distinct().count()', (db) async {
    final count = await db.items
        .select(
          (i) => (
            i.text,
            i.integer,
          ),
        )
        .distinct()
        .count()
        .fetch();
    check(count).isNotNull().equals(5);
  });

  r.addTest('items.select(.text, .integer, real).distinct()', (db) async {
    final items = await db.items
        .select(
          (i) => (
            i.text,
            i.integer,
            i.real,
          ),
        )
        .distinct()
        .fetch();
    check(items).length.equals(6);
  });

  r.addTest('items.select(.text, .integer, real).distinct().count()',
      (db) async {
    final count = await db.items
        .select(
          (i) => (
            i.text,
            i.integer,
            i.real,
          ),
        )
        .distinct()
        .count()
        .fetch();
    check(count).isNotNull().equals(6);
  });

  r.run();
}
