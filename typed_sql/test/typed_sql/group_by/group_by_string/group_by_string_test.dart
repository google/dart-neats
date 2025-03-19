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

part 'group_by_string_test.g.dart';

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

  r.addTest('.groupBy(.surname).aggretate(.count)', (db) async {
    final result = await db.employees
        .groupBy((employee) => (employee.surname,))
        .aggregate((b) => b.count())
        .fetch();
    check(result).unorderedEquals({
      ('Smith', 3),
      ('Jones', 2),
      ('Williams', 2),
      ('Brown', 5),
    });
  });

  r.addTest('.groupBy(.surname).aggretate(.avg(.salary))', (db) async {
    final result = await db.employees
        .groupBy((employee) => (employee.surname,))
        .aggregate((b) => b.avg((employee) => employee.salary))
        .fetch();
    check(result).unorderedEquals({
      ('Smith', 2000.0),
      ('Jones', 2000.0),
      ('Williams', 1000.0), // NULL don't figure in AVG
      ('Brown', 4000.0),
    });
  });

  r.addTest('.groupBy(.surname).aggretate(.avg(.salary.orElse(0)))',
      (db) async {
    final result = await db.employees
        .groupBy((employee) => (employee.surname,))
        .aggregate((b) => b.avg((employee) => employee.salary.orElseLiteral(0)))
        .fetch();
    check(result).unorderedEquals({
      ('Smith', 2000.0),
      ('Jones', 2000.0),
      ('Williams', 500.0), // .orElse(0) ensures that NULL figures in AVG
      ('Brown', 12000.0 / 5),
    });
  });

  r.addTest('.groupBy(.surname).aggretate(.count, .avg)', (db) async {
    final result = await db.employees
        .groupBy((employee) => (employee.surname,))
        .aggregate(
          (b) => b
              //
              .count()
              .avg(
                (employee) => employee.salary.orElseLiteral(0),
              ),
        )
        .fetch();
    check(result).unorderedEquals({
      ('Smith', 3, 2000.0),
      ('Jones', 2, 2000.0),
      ('Williams', 2, 500.0),
      ('Brown', 5, 12000.0 / 5),
    });
  });

  r.addTest('.groupBy(.surname, .seniority).aggretate(.count).where(count > 1)',
      (db) async {
    final result = await db.employees
        .groupBy((employee) => (employee.surname, employee.seniority))
        .aggregate(
          (b) => b
              //
              .count(),
        )
        .where((surname, seniority, count) => count > literal(1))
        .fetch();
    check(result).unorderedEquals({
      ('Smith', 'junior', 3),
      ('Williams', 'senior', 2),
      ('Brown', 'junior', 2),
      ('Brown', 'senior', 3),
    });
  });

  r.addTest(
      '.groupBy(.surname, .seniority).aggretate(.count).where(count > 1).select()',
      (db) async {
    final result = await db.employees
        .groupBy((employee) => (employee.surname, employee.seniority))
        .aggregate(
          (b) => b
              //
              .count(),
        )
        .where((surname, seniority, count) => count > literal(1))
        .select((surname, seniority, count) => (surname, seniority))
        .fetch();
    check(result).unorderedEquals({
      ('Smith', 'junior'),
      ('Williams', 'senior'),
      ('Brown', 'junior'),
      ('Brown', 'senior'),
    });
  });

  r.addTest('.groupBy(.seniority).aggretate(.min, .max)', (db) async {
    final result = await db.employees
        .groupBy((employee) => (employee.seniority,))
        .aggregate(
          (b) => b
              // without orElse() NULL gets ignored!
              .min((employee) => employee.salary.orElse(literal(0)))
              .max((employee) => employee.salary),
        )
        .fetch();
    check(result).unorderedEquals({
      ('junior', 0, 3000),
      ('senior', 0, 7000),
    });
  });

  r.run();
}
