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

part 'group_by_null_test.g.dart';

abstract final class TestDatabase extends Schema {
  Table<Employee> get employees;
}

@PrimaryKey(['id'])
abstract final class Employee extends Model {
  @AutoIncrement()
  int get id;

  String get surname;

  String get seniority;

  int? get salary;
}

final _testData = [
  (surname: 'Smith', seniority: 'junior', salary: 1000),
  (surname: 'Smith', seniority: 'junior', salary: 2000),
  (surname: 'Smith', seniority: 'junior', salary: 3000),
  (surname: 'Jones', seniority: 'junior', salary: 1500),
  (surname: 'Jones', seniority: 'senior', salary: 2500),
  (surname: 'Williams', seniority: 'senior', salary: null),
  (surname: 'Williams', seniority: 'senior', salary: 1000),
  (surname: 'Brown', seniority: 'junior', salary: 1000),
  (surname: 'Brown', seniority: 'junior', salary: null),
  (surname: 'Brown', seniority: 'senior', salary: null),
  (surname: 'Brown', seniority: 'senior', salary: 4000),
  (surname: 'Brown', seniority: 'senior', salary: 7000),
];

void main() {
  final r = TestRunner<TestDatabase>(
    setup: (db) async {
      await db.createTables();

      for (final v in _testData) {
        await db.employees
            .insertLiteral(
              surname: v.surname,
              seniority: v.seniority,
              salary: v.salary,
            )
            .execute();
      }
    },
  );

  r.addTest('.groupBy(null).aggretate(.count, .avg(salary.orElse(0)))',
      (db) async {
    final (count, avgSalary, minSalary, maxSalary) = await db.employees
        .groupBy(
          (employee) => (
            // Creating an Expr<void> to avoid matching extensions for
            // Expr<Model?> which Expr<Null> would otherwise match.
            // We can't prevent Expr<Null> from matching such extensions, but
            // we can use Expr<void> instead!
            literal<void>(null),
          ),
        )
        .aggregate(
          (agg) => agg //
              .count()
              .avg((employee) => employee.salary.orElseLiteral(0))
              .min((employee) => employee.salary.orElseLiteral(0))
              .max((employee) => employee.salary.orElseLiteral(0)),
        )
        .select(
          (_, count, avgSalary, minSalary, maxSalary) => (
            count,
            avgSalary,
            minSalary,
            maxSalary,
          ),
        )
        .first // We only have one group, so we only need the first row!
        .fetchOrNulls();

    check(count).equals(12);
    check(avgSalary).isNotNull().isCloseTo(23000 / 12, 0.0000001);
    check(minSalary).equals(0);
    check(maxSalary).equals(7000);
  });

  r.run();
}
