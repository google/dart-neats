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

part 'group_by_join_expression_test.g.dart';

abstract final class TestDatabase extends Schema {
  Table<Department> get departments;
  Table<Employee> get employees;
}

@PrimaryKey(['id'])
abstract final class Department extends Row {
  @AutoIncrement()
  int get id;
  String get name;
}

@PrimaryKey(['id'])
abstract final class Employee extends Row {
  @AutoIncrement()
  int get id;
  String get name;
  @References(table: 'departments', field: 'id', name: 'dept')
  int get deptId;
  int get salary;
}

final _depts = [
  (id: 1, name: 'Engineering'),
  (id: 2, name: 'Sales'),
];

final _employees = [
  (name: 'Alice', deptId: 1, salary: 100000),
  (name: 'Bob', deptId: 1, salary: 120000),
  (name: 'Charlie', deptId: 2, salary: 80000),
  (name: 'Dave', deptId: 2, salary: 90000),
  (name: 'Eve', deptId: 2, salary: 100000),
];

void main() {
  final r = TestRunner<TestDatabase>(
    setup: (db) async {
      await db.createTables();

      for (final d in _depts) {
        await db.departments
            .insert(id: toExpr(d.id), name: toExpr(d.name))
            .execute();
      }
      for (final e in _employees) {
        await db.employees
            .insert(
              name: toExpr(e.name),
              deptId: toExpr(e.deptId),
              salary: toExpr(e.salary),
            )
            .execute();
      }
    },
  );

  r.addTest('join.groupBy(dept.name).aggregate(avg(salary))', (db) async {
    final result = await db.employees
        .join(db.departments)
        .on((e, d) => e.deptId.equals(d.id))
        .groupBy((e, d) => (d.name,))
        .aggregate((agg) => agg.avg((e, d) => e.salary))
        .fetch();

    check(result).unorderedEquals([
      ('Engineering', 110000.0),
      ('Sales', 90000.0),
    ]);
  });

  r.addTest('join.select().groupBy().aggregate()', (db) async {
    final result = await db.employees
        .join(db.departments)
        .on((e, d) => e.deptId.equals(d.id))
        .select((e, d) => (d.name, e.salary))
        .groupBy((deptName, salary) => (deptName,))
        .aggregate((agg) => agg.sum((deptName, salary) => salary))
        .fetch();

    check(result).unorderedEquals([
      ('Engineering', 220000),
      ('Sales', 270000),
    ]);
  });

  r.addTest('groupBy(expression in join).aggregate()', (db) async {
    // Grouping by a complex expression involving columns from both tables
    final result = await db.employees
        .join(db.departments)
        .on((e, d) => e.deptId.equals(d.id))
        .groupBy((e, d) => (d.name.toLowerCase(), e.salary / toExpr(100000)))
        .aggregate((agg) => agg.count())
        .fetch();

    // Engineering:
    // Alice: ('engineering', 1.0)
    // Bob: ('engineering', 1.2)
    // Sales:
    // Charlie: ('sales', 0.8)
    // Dave: ('sales', 0.9)
    // Eve: ('sales', 1.0)

    check(result).unorderedEquals([
      ('engineering', 1.0, 1),
      ('engineering', 1.2, 1),
      ('sales', 0.8, 1),
      ('sales', 0.9, 1),
      ('sales', 1.0, 1),
    ]);
  });

  r.addTest('join.aggregate(multiple columns)', (db) async {
    final result = await db.employees
        .join(db.departments)
        .on((e, d) => e.deptId.equals(d.id))
        .groupBy((e, d) => (d.name,))
        .aggregate((agg) => agg.sum((e, d) => e.salary + d.id))
        .fetch();

    // Engineering:
    // Alice (100000 + 1) = 100001
    // Bob (120000 + 1) = 120001
    // Total: 220002

    // Sales:
    // Charlie (80000 + 2) = 80002
    // Dave (90000 + 2) = 90002
    // Eve (100000 + 2) = 100002
    // Total: 270006

    check(result).unorderedEquals([
      ('Engineering', 220002),
      ('Sales', 270006),
    ]);
  });

  r.run();
}
