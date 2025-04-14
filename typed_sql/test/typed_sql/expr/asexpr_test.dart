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

import 'dart:typed_data';

import 'package:typed_sql/typed_sql.dart';

import '../testrunner.dart';

void main() {
  final r = TestRunner<Schema>(resetDatabaseForEachTest: false);

  r.addTest('bool.asExpr', (db) async {
    final value = true;
    final result = await db.select(
      (value.asExpr,),
    ).fetch();
    check(result).equals(value);
  });

  r.addTest('bool?.asExpr', (db) async {
    final value = true as bool?;
    final result = await db.select(
      (value.asExpr,),
    ).fetch();
    check(result).equals(value);
  });

  r.addTest('int.asExpr', (db) async {
    final value = 42;
    final result = await db.select(
      (value.asExpr,),
    ).fetch();
    check(result).equals(value);
  });

  r.addTest('int?.asExpr', (db) async {
    final value = 42 as int?;
    final result = await db.select(
      (value.asExpr,),
    ).fetch();
    check(result).equals(value);
  });

  r.addTest('double.asExpr', (db) async {
    final value = 3.14;
    final result = await db.select(
      (value.asExpr,),
    ).fetch();
    check(result).equals(value);
  });

  r.addTest('double?.asExpr', (db) async {
    final value = 3.14 as double?;
    final result = await db.select(
      (value.asExpr,),
    ).fetch();
    check(result).equals(value);
  });

  r.addTest('String.asExpr', (db) async {
    final value = 'hello world';
    final result = await db.select(
      (value.asExpr,),
    ).fetch();
    check(result).equals(value);
  });

  r.addTest('String?.asExpr', (db) async {
    final value = 'hello world' as String?;
    final result = await db.select(
      (value.asExpr,),
    ).fetch();
    check(result).equals(value);
  });

  r.addTest('DateTime.asExpr', (db) async {
    final value = DateTime.now()
        .copyWith(
          microsecond: 0,
          millisecond: 0,
        )
        .toUtc();
    final result = await db.select(
      (value.asExpr,),
    ).fetch();
    check(result).equals(value);
  });

  r.addTest('DateTime?.asExpr', (db) async {
    final value = DateTime.now()
        .copyWith(
          microsecond: 0,
          millisecond: 0,
        )
        .toUtc() as DateTime?;
    final result = await db.select(
      (value.asExpr,),
    ).fetch();
    check(result).equals(value);
  });

  r.addTest('DateTime.asExpr (with microseconds)', (db) async {
    final value = DateTime.now().toUtc();
    final result = await db.select(
      (value.asExpr,),
    ).fetch();
    check(result).equals(value);
  }, skipMysql: 'MySQL driver does not support microseconds');

  r.addTest('DateTime?.asExpr (with microseconds)', (db) async {
    final value = DateTime.now().toUtc() as DateTime?;
    final result = await db.select(
      (value.asExpr,),
    ).fetch();
    check(result).equals(value);
  }, skipMysql: 'MySQL driver does not support microseconds');

  r.addTest('Uint8List.asExpr', (db) async {
    final value = Uint8List.fromList([1, 2, 3]);
    final result = await db.select(
      (value.asExpr,),
    ).fetch();
    check(result).isNotNull().deepEquals(value);
  });

  r.addTest('Uint8List?.asExpr', (db) async {
    final value = Uint8List.fromList([1, 2, 3]) as Uint8List?;
    final result = await db.select(
      (value.asExpr,),
    ).fetch();
    check(result).isNotNull().deepEquals(value!);
  });

  r.run();
}
