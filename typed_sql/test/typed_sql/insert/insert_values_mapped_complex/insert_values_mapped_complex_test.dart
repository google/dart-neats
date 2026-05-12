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

import 'dart:typed_data';
import 'package:typed_sql/typed_sql.dart';
import '../../testrunner.dart';

part 'insert_values_mapped_complex_test.g.dart';

abstract final class ComplexMappedDatabase extends Schema {
  Table<ComplexMappedItem> get complexMappedItems;
}

final class MyCustomType implements CustomDataType<int> {
  final int value;
  MyCustomType(this.value);
  factory MyCustomType.fromDatabase(int value) => MyCustomType(value);
  @override
  int toDatabase() => value;
}

@PrimaryKey(['id'])
abstract final class ComplexMappedItem extends Row {
  @AutoIncrement()
  int get id;

  String? get s;
  DateTime? get dt;
  Uint8List? get blob;
  MyCustomType? get custom;
  int? get i;
  JsonValue? get json;
}

void main() {
  final r = TestRunner<ComplexMappedDatabase>(
    setup: (db) async {
      await db.createTables();
    },
  );

  r.addTest('insertValuesMapped with [null, null, String]', (db) async {
    final data = [
      (s: null),
      (s: null),
      (s: 'hello'),
    ];

    await db.complexMappedItems
        .insertValuesMapped(
          data,
          s: (r) => r.s,
        )
        .execute();

    final items = await db.complexMappedItems
        .orderBy((i) => [(i.id, .ascending)])
        .fetch();
    check(items).length.equals(3);
    check(items[0].s).isNull();
    check(items[1].s).isNull();
    check(items[2].s).equals('hello');
  });

  r.addTest('insertValuesMapped with [null, null, DateTime]', (db) async {
    final now = DateTime.now().toUtc();
    final data = [
      (dt: null),
      (dt: null),
      (dt: now),
    ];

    await db.complexMappedItems
        .insertValuesMapped(
          data,
          dt: (r) => r.dt,
        )
        .execute();

    final items = await db.complexMappedItems
        .orderBy((i) => [(i.id, .ascending)])
        .fetch();
    check(items).length.equals(3);
    check(items[2].dt).isNotNull();
  });

  r.addTest('insertValuesMapped with BC DateTime', (db) async {
    final bcDate = DateTime.utc(-100, 1, 1);
    final data = [
      (dt: bcDate),
    ];

    await db.complexMappedItems
        .insertValuesMapped(
          data,
          dt: (r) => r.dt,
        )
        .execute();

    final item = await db.complexMappedItems.first.fetch();
    check(item).isNotNull();
  });

  r.addTest('insertValuesMapped with [null, null, Uint8List]', (db) async {
    final blob = Uint8List.fromList([1, 2, 3]);
    final data = [
      (blob: null),
      (blob: null),
      (blob: blob),
    ];

    await db.complexMappedItems
        .insertValuesMapped(
          data,
          blob: (r) => r.blob,
        )
        .execute();
  });

  r.addTest('insertValuesMapped with custom values', (db) async {
    final data = [
      (custom: MyCustomType(42)),
    ];

    await db.complexMappedItems
        .insertValuesMapped(
          data,
          custom: (r) => r.custom,
        )
        .execute();
  });

  r.addTest('insertValuesMapped with all nulls for String', (db) async {
    final data = [
      (s: null),
      (s: null),
    ];

    await db.complexMappedItems
        .insertValuesMapped(
          data,
          s: (r) => r.s,
        )
        .execute();

    final items = await db.complexMappedItems
        .orderBy((i) => [(i.id, .ascending)])
        .fetch();
    check(items).length.equals(2);
    check(items[0].s).isNull();
    check(items[1].s).isNull();
  });

  r.addTest('insertValuesMapped with all nulls for DateTime', (db) async {
    final data = [
      (dt: null),
      (dt: null),
    ];

    await db.complexMappedItems
        .insertValuesMapped(
          data,
          dt: (r) => r.dt,
        )
        .execute();

    final items = await db.complexMappedItems
        .orderBy((i) => [(i.id, .ascending)])
        .fetch();
    check(items).length.equals(2);
    check(items[0].dt).isNull();
    check(items[1].dt).isNull();
  });

  r.addTest('insertValuesMapped with all nulls for int', (db) async {
    final data = [
      (i: null),
      (i: null),
    ];

    await db.complexMappedItems
        .insertValuesMapped(
          data,
          i: (r) => r.i,
        )
        .execute();

    final items = await db.complexMappedItems
        .orderBy((i) => [(i.id, .ascending)])
        .fetch();
    check(items).length.equals(2);
    check(items[0].i).isNull();
    check(items[1].i).isNull();
  });

  r.addTest(
    'insertValuesMapped with all nulls for JsonValue',
    (db) async {
      final data = [
        (json: null),
        (json: null),
      ];

      await db.complexMappedItems
          .insertValuesMapped(
            data,
            json: (r) => r.json,
          )
          .execute();

      final items = await db.complexMappedItems
          .orderBy((i) => [(i.id, .ascending)])
          .fetch();
      check(items).length.equals(2);
      check(items[0].json).isNull();
      check(items[1].json).isNull();
    },
  );

  r.addTest(
    'insertValuesMapped with JSON null vs SQL NULL',
    (db) async {
      final data = [
        (json: const JsonValue(null)), // JSON null
        (json: null), // SQL NULL
      ];

      await db.complexMappedItems
          .insertValuesMapped(
            data,
            json: (r) => r.json,
          )
          .execute();

      final items = await db.complexMappedItems
          .orderBy((i) => [(i.id, .ascending)])
          .fetch();
      check(items).length.equals(2);

      // Check if first item is JSON null (has value null)
      check(items[0].json).isNotNull();
      check(items[0].json!.value).isNull();

      // Check if second item is SQL NULL (is null)
      check(items[1].json).isNull();
    },
  );

  r.run();
}
