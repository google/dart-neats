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

import '../testrunner.dart';

void main() {
  final r = TestRunner<Schema>(resetDatabaseForEachTest: false);

  r.addTest('(A).unionAll(null)', (db) async {
    // Convoluted way of creating Query<(Expr<String?>,)>
    final q1 = db.select(
      (db.select((literal('A'),)).asExpr,),
    ).asQuery;

    final q2 = db.select(
      (literal(null),),
    ).asQuery;

    final result = await q1.unionAll(q2).fetch().toList();
    check(result).length.equals(2);
    check(result).deepEquals(['A', null]);
  });

  r.addTest('(42).unionAll(null)', (db) async {
    // Convoluted way of creating Query<(Expr<int?>,)>
    final q1 = db.select(
      (db.select((literal(42),)).asExpr,),
    ).asQuery;

    final q2 = db.select(
      (literal(null),),
    ).asQuery;

    final result = await q1.unionAll(q2).fetch().toList();
    check(result).length.equals(2);
    check(result).deepEquals([42, null]);
  }, skipPostgres: 'NULL needs a cast to BIGINT');

  r.addTest('(3.14).unionAll(null)', (db) async {
    // Convoluted way of creating Query<(Expr<double?>,)>
    final q1 = db.select(
      (db.select((literal(3.14),)).asExpr,),
    ).asQuery;

    final q2 = db.select(
      (literal(null),),
    ).asQuery;

    final result = await q1.unionAll(q2).fetch().toList();
    check(result).length.equals(2);
    check(result).deepEquals([3.14, null]);
  }, skipPostgres: 'NULL needs a cast to REAL');

  r.run();
}
