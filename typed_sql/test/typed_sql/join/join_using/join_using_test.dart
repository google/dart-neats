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

part 'join_using_test.g.dart';

abstract final class CompanyDatabase extends Schema {
  Table<Employee> get employees;
  Table<Department> get departments;
}

@PrimaryKey(['employeeId'])
abstract final class Employee extends Row {
  @AutoIncrement()
  int get employeeId;

  String get name;

  @References(
    table: 'departments',
    field: 'departmentId',
    name: 'department',
    as: 'employees',
  )
  int? get departmentId;
}

@PrimaryKey(['departmentId'])
abstract final class Department extends Row {
  @AutoIncrement()
  int get departmentId;

  String get name;

  String get location;
}

final _initialDepartments = [
  (id: 1, name: 'Engineering', location: 'Floor 1'),
  (id: 2, name: 'Sales', location: 'Floor 2'),
  (id: 3, name: 'Marketing', location: 'Floor 3'),
];

final _initialEmployees = [
  (id: 1, name: 'Alice', departmentId: 1),
  (id: 2, name: 'Bob', departmentId: 2),
  (id: 3, name: 'Charlie', departmentId: 1),
  (id: 4, name: 'David', departmentId: null),
  (id: 5, name: 'Eve', departmentId: null),
];

void main() {
  final r = TestRunner<CompanyDatabase>(
    setup: (db) async {
      await db.createTables();
      for (final d in _initialDepartments) {
        await db.departments
            .insert(
              departmentId: toExpr(d.id),
              name: toExpr(d.name),
              location: toExpr(d.location),
            )
            .execute();
      }
      for (final e in _initialEmployees) {
        await db.employees
            .insert(
              employeeId: toExpr(e.id),
              name: toExpr(e.name),
              departmentId: toExpr(e.departmentId),
            )
            .execute();
      }
    },
  );

  r.addTest('employees.join(departments)', (db) async {
    final result = await db.employees
        .join(db.departments)
        .on((employee, department) =>
            employee.departmentId.equals(department.departmentId))
        .fetch();
    check(result).length.equals(3);
  });

  r.addTest('employees.leftJoin(departments)', (db) async {
    final result =
        await db.employees.leftJoin(db.departments).usingDepartment().fetch();
    check(result).length.equals(5);
  });

  r.addTest('employees.rightJoin(departments)', (db) async {
    final result =
        await db.employees.rightJoin(db.departments).usingDepartment().fetch();
    check(result).length.equals(4);
  });

  // --- Standard Join Test Cases (Equi-Join) ---

  // Test standard INNER JOIN with equality ON condition.
  r.addTest('employees.join(departments)', (db) async {
    final result = await db.employees
        .join(db.departments)
        .usingDepartment()
        .select((employee, department) => (
              employee.name,
              department.name,
              department.location,
            ))
        .fetch();
    check(result).unorderedEquals([
      ('Alice', 'Engineering', 'Floor 1'),
      ('Bob', 'Sales', 'Floor 2'),
      ('Charlie', 'Engineering', 'Floor 1'),
    ]);
  });

  // Test standard LEFT JOIN with equality ON condition.
  r.addTest('employees.leftJoin(departments)', (db) async {
    final result = await db.employees
        .leftJoin(db.departments)
        .usingDepartment()
        .select((employee, department) => (
              employee.name,
              department.name,
              department.location,
            ))
        .fetch();
    check(result).unorderedEquals([
      ('Alice', 'Engineering', 'Floor 1'),
      ('Bob', 'Sales', 'Floor 2'),
      ('Charlie', 'Engineering', 'Floor 1'),
      ('David', null, null),
      ('Eve', null, null),
    ]);
  });

  // Test standard RIGHT JOIN with equality ON condition.
  r.addTest('employees.rightJoin(departments)', (db) async {
    final result = await db.employees
        .rightJoin(db.departments)
        .usingDepartment()
        .select((employee, department) => (
              employee.name,
              department.name,
              department.location,
            ))
        .fetch();
    check(result).unorderedEquals([
      ('Alice', 'Engineering', 'Floor 1'),
      ('Bob', 'Sales', 'Floor 2'),
      ('Charlie', 'Engineering', 'Floor 1'),
      (null, 'Marketing', 'Floor 3'),
    ]);
  });

  // Test LEFT JOIN followed by a WHERE clause filtering on the right table
  r.addTest('employees.leftJoin(..).where(department.isNotNull())', (db) async {
    final result = await db.employees
        .leftJoin(db.departments)
        .usingDepartment()
        .where((employee, department) => department.departmentId.isNotNull())
        .select((employee, department) => (
              employee.name,
              department.name,
              department.location,
            ))
        .fetch();
    // Effectively the same result as the INNER JOIN because WHERE filters NULLs
    check(result).unorderedEquals([
      ('Alice', 'Engineering', 'Floor 1'),
      ('Bob', 'Sales', 'Floor 2'),
      ('Charlie', 'Engineering', 'Floor 1'),
    ]);
  });

  // Test RIGHT JOIN followed by a WHERE clause filtering on the left table
  r.addTest('employees.rightJoin(..).where(employee.isNotNull())', (db) async {
    final result = await db.employees
        .rightJoin(db.departments)
        .usingDepartment()
        .where((employee, department) => employee.employeeId.isNotNull())
        .select((employee, department) => (
              employee.name,
              department.name,
              department.location,
            ))
        .fetch();
    // Effectively the same result as the INNER JOIN because WHERE filters NULLs
    check(result).unorderedEquals([
      ('Alice', 'Engineering', 'Floor 1'),
      ('Bob', 'Sales', 'Floor 2'),
      ('Charlie', 'Engineering', 'Floor 1'),
    ]);
  });

  // Test joining and then aggregating using COUNT(*)
  r.addTest('departments.leftJoin(emp).groupBy.count', (db) async {
    final result = await db.departments
        .leftJoin(db.employees)
        .usingDepartment()
        .groupBy((department, employee) => (department.name,))
        .aggregate(
          (agg) => agg
              // aggregates:
              .count(),
        )
        .select((deptName, rowCount) => (
              deptName,
              rowCount,
            ))
        .orderBy((deptName, rowCount) => [(deptName, Order.ascending)])
        .fetch();

    check(result).deepEquals([
      ('Engineering', 2),
      ('Marketing', 1),
      ('Sales', 1),
    ]);
  });

  r.run();
}
