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

final _values = <Object?>[
  'hello world',
  'æøå',
  'hello\nworld',
  '\\',
  '',
  42,
  -1,
  0,
  true,
  false,
  null,
  3.14,
  -3.14,
  0.0,
  DateTime(2025).toUtc(),
];

final epoch = DateTime.fromMicrosecondsSinceEpoch(0).toUtc();
final today = DateTime.parse('2025-03-10T11:34:36.164006Z');
final yearNoUtc = DateTime(2025);

void main() {
  final r = TestRunner<Schema>(resetDatabaseForEachTest: false);

  for (final value in _values) {
    r.addTest('literal(${'$value'.replaceAll('\n', '\\n')})', (db) async {
      final result = await db.select((literal(value),)).fetch();
      check(result).equals(value);
    });
  }

  r.addTest('literal(epoch)', (db) async {
    final result = await db.select((literal(epoch),)).fetch();
    check(result).equals(epoch);
  });

  r.addTest('literal(today)', (db) async {
    final result = await db.select((literal(today),)).fetch();
    check(result).equals(today);
  });

  r.addTest('literal(yearNoUtc) (allow for conversion to UTC)', (db) async {
    final result = await db.select((literal(yearNoUtc),)).fetch();
    // We allow for conversion to UTC
    check(result!.isAtSameMomentAs(yearNoUtc)).isTrue();
  });

  r.addTest('literal(UintList)', (db) async {
    final result = await db.select(
      (literal(Uint8List.fromList([1, 2, 3])),),
    ).fetch();
    check(result).isNotNull().deepEquals(Uint8List.fromList([1, 2, 3]));
  });

  r.run();
}
