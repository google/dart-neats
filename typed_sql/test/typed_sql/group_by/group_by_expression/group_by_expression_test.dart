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

part 'group_by_expression_test.g.dart';

abstract final class TestDatabase extends Schema {
  Table<Employee> get employees;
}

@PrimaryKey(['id'])
abstract final class Employee extends Row {
  @AutoIncrement()
  int get id;

  String get surname;

  int get salary;
}

final _testData = [
  (surname: 'Smith', salary: 1000),
  (surname: 'Smith', salary: 2000),
  (surname: 'Smith', salary: 3000),
  (surname: 'Jones', salary: 1500),
  (surname: 'Jones', salary: 2500),
  (surname: 'Williams', salary: 1000),
  (surname: 'Williams', salary: 4000),
  (surname: 'Brown', salary: 1000),
  (surname: 'Brown', salary: 5000),
];

void main() {
  final r = TestRunner<TestDatabase>(
    setup: (db) async {
      await db.createTables();

      for (final v in _testData) {
        await db.employees
            .insert(
              surname: toExpr(v.surname),
              salary: toExpr(v.salary),
            )
            .execute();
      }
    },
  );

  r.addTest('.groupBy(salary / 1000).aggregate(.count)', (db) async {
    final result = await db.employees
        .groupBy((e) => (e.salary / toExpr(1000),))
        .aggregate((agg) => agg.count())
        .fetch();

    // Groups by salary / 1000:
    // 1000 / 1000 = 1 (Smith, Williams, Brown) -> 3
    // 2000 / 1000 = 2 (Smith) -> 1
    // 3000 / 1000 = 3 (Smith) -> 1
    // 1500 / 1000 = 1.5 (Jones) -> 1
    // 2500 / 1000 = 2.5 (Jones) -> 1
    // 4000 / 1000 = 4 (Williams) -> 1
    // 5000 / 1000 = 5 (Brown) -> 1

    // Note: integer division vs double division might depend on dialect.
    // In many SQL dialects, integer / integer is integer division.
    // typed_sql might use double division if salary is double, but here it's int.
    // Let's see what happens.

    check(result).unorderedEquals([
      (1.0, 3),
      (2.0, 1),
      (3.0, 1),
      (1.5, 1),
      (2.5, 1),
      (4.0, 1),
      (5.0, 1),
    ]);
  });

  r.addTest('.select().groupBy().aggregate()', (db) async {
    // Test select before groupBy
    final result = await db.employees
        .select((e) => (e.surname, e.salary))
        .groupBy((surname, salary) => (surname,))
        .aggregate((agg) => agg.sum((surname, salary) => salary))
        .fetch();

    check(result).unorderedEquals([
      ('Smith', 6000),
      ('Jones', 4000),
      ('Williams', 5000),
      ('Brown', 6000),
    ]);
  });

  r.addTest('.groupBy().aggregate(sum(salary * 2))', (db) async {
    final result = await db.employees
        .groupBy((e) => (e.surname,))
        .aggregate((agg) => agg.sum((e) => e.salary * toExpr(2)))
        .fetch();

    check(result).unorderedEquals([
      ('Smith', 12000),
      ('Jones', 8000),
      ('Williams', 10000),
      ('Brown', 12000),
    ]);
  });

  r.run();
}
