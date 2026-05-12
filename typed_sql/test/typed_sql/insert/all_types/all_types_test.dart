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

// ignore_for_file: prefer_const_constructors

import 'dart:typed_data';
import 'package:typed_sql/typed_sql.dart';
import '../../testrunner.dart';

part 'all_types_test.g.dart';

abstract final class AllTypesDatabase extends Schema {
  Table<AllTypesItem> get allTypesItems;
}

final class MyCustomType implements CustomDataType<int> {
  final int value;
  MyCustomType(this.value);
  factory MyCustomType.fromDatabase(int value) => MyCustomType(value);
  @override
  int toDatabase() => value;
}

@PrimaryKey(['id'])
abstract final class AllTypesItem extends Row {
  @AutoIncrement()
  int get id;

  bool get b;
  int get i;
  double get d;
  String get s;
  DateTime get dt;
  Uint8List get blob;
  JsonValue get json;
  MyCustomType get custom;

  // Nullable versions
  bool? get nb;
  int? get ni;
  double? get nd;
  String? get ns;
  DateTime? get ndt;
  Uint8List? get nblob;
  JsonValue? get njson;
  MyCustomType? get ncustom;

  // Defaults
  @DefaultValue(true)
  bool get db;
  @DefaultValue(42)
  int get di;
  @DefaultValue(3.14)
  double get dd;
  @DefaultValue('default')
  String get ds;
  @DefaultValue.now
  DateTime get ddt;
  @DefaultValue(JsonValue({}))
  JsonValue get djson;
}

void main() {
  final r = TestRunner<AllTypesDatabase>(
    setup: (db) async {
      await db.createTables();
    },
  );

  r.addTest('Insert all types', (db) async {
    final blob = Uint8List.fromList([1, 2, 3]);
    final now = DateTime.now().toUtc();

    await db.allTypesItems
        .insert(
          b: toExpr(true),
          i: toExpr(10),
          d: toExpr(1.1),
          s: toExpr('hello'),
          dt: toExpr(now),
          blob: toExpr(blob),
          json: toExpr(JsonValue({'key': 'value'})),
          custom: MyCustomType(100).asExpr,

          nb: toExpr(null),
          ni: toExpr(null),
          nd: toExpr(null),
          ns: toExpr(null),
          ndt: toExpr(null),
          nblob: toExpr(null),
          njson: toExpr(null),
          ncustom: toExpr(null),

          db: toExpr(false),
          di: toExpr(20),
          dd: toExpr(2.2),
          ds: toExpr('custom_default'),
          ddt: toExpr(now),
          djson: toExpr(JsonValue({'custom': 'json'})),
        )
        .execute();

    final item = await db.allTypesItems.first.fetch();
    check(item).isNotNull();
    check(item!.b).isTrue();
    check(item.i).equals(10);
    check(item.d).equals(1.1);
    check(item.s).equals('hello');
    check(item.dt.difference(now).inSeconds).equals(0);
    check(item.blob).deepEquals(blob);
    check(
      item.json.value,
    ).isA<Map>().has((m) => m['key'], 'key').equals('value');
    check(item.custom.value).equals(100);

    check(item.nb).isNull();
    check(item.ni).isNull();
    check(item.nd).isNull();
    check(item.ns).isNull();
    check(item.ndt).isNull();
    check(item.nblob).isNull();
    check(item.njson).isNull();
    check(item.ncustom).isNull();

    check(item.db).isFalse();
    check(item.di).equals(20);
    check(item.dd).equals(2.2);
    check(item.ds).equals('custom_default');
    check(
      item.djson.value,
    ).isA<Map>().has((m) => m['custom'], 'custom').equals('json');
  });

  r.addTest('Insert with defaults', (db) async {
    final blob = Uint8List.fromList([1, 2, 3]);
    final now = DateTime.now().toUtc();

    await db.allTypesItems
        .insert(
          b: toExpr(true),
          i: toExpr(10),
          d: toExpr(1.1),
          s: toExpr('hello'),
          dt: toExpr(now),
          blob: toExpr(blob),
          json: toExpr(JsonValue({'key': 'value'})),
          custom: MyCustomType(100).asExpr,
        )
        .execute();

    final item = await db.allTypesItems.first.fetch();
    check(item).isNotNull();

    // Check defaults
    check(item!.db).isTrue();
    check(item.di).equals(42);
    check(item.dd).equals(3.14);
    check(item.ds).equals('default');
    check(
      item.ddt.difference(DateTime.now()).inMinutes,
    ).isLessThan(1); // Should be close to now
    check(item.djson.value).isA<Map>().has((m) => m.length, 'length').equals(0);
  });

  r.run();
}
