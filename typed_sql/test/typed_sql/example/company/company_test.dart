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

// ignore_for_file: omit_local_variable_types

import 'package:typed_sql/typed_sql.dart';

import '../../testrunner.dart';

part 'company_test.g.dart';

// #region schema
abstract final class CompanyDatabase extends Schema {
  Table<Department> get departments;
  Table<Employee> get employees;
}

@PrimaryKey(['departmentId'])
abstract final class Department extends Row {
  @AutoIncrement()
  int get departmentId;

  String get name;

  String get location;
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

// #endregion

// #region initial-data
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
// #endregion

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
    // #region inner-join
    final List<(Employee, Department)> result = await db.employees
        .join(db.departments)
        .on((employee, department) =>
            employee.departmentId.equals(department.departmentId))
        // Now we have a Query<(Expr<Employee>, Expr<Department>)>
        .fetch();

    for (final (employee, department) in result) {
      check(employee.departmentId).equals(department.departmentId);
    }
    // #endregion
  });

  r.addTest('employees.join(departments).select()', (db) async {
    // #region inner-join-select
    final result = await db.employees
        .join(db.departments)
        .on((employee, department) =>
            employee.departmentId.equals(department.departmentId))
        // Now we have a Query<(Expr<Employee>, Expr<Department>)>
        .select((employee, department) => (
              employee.name,
              department.name,
            ))
        .fetch();

    check(result).unorderedEquals([
      // employee.name, department.name
      ('Alice', 'Engineering'),
      ('Bob', 'Sales'),
      ('Charlie', 'Engineering'),
    ]);
    // #endregion
  });

  r.addTest('employees.join(departments).using().select()', (db) async {
    // #region inner-join-using-select
    final result = await db.employees
        .join(db.departments)
        // Join using the foreign key declared with @References
        .usingDepartment()
        .select((employee, department) => (
              employee.name,
              department.name,
            ))
        .fetch();

    check(result).unorderedEquals([
      // employee.name, department.name
      ('Alice', 'Engineering'),
      ('Bob', 'Sales'),
      ('Charlie', 'Engineering'),
    ]);
    // #endregion
  });

  r.addTest('employees.leftJoin(departments).select()', (db) async {
    // #region left-join-select
    final result = await db.employees
        .leftJoin(db.departments)
        .usingDepartment()
        // Now we have a Query<(Expr<Employee>, Expr<Department?>)>
        .select((employee, department) => (
              employee.name,
              department.name,
            ))
        .fetch();

    check(result).unorderedEquals([
      // employee.name, department.name
      ('Alice', 'Engineering'),
      ('Bob', 'Sales'),
      ('Charlie', 'Engineering'),
      ('David', null),
      ('Eve', null),
    ]);
    // #endregion
  });

  r.addTest('employees.rightJoin(departments).select()', (db) async {
    // #region right-join-select
    final result = await db.employees
        .rightJoin(db.departments)
        .usingDepartment()
        // Now we have a Query<(Expr<Employee?>, Expr<Department>)>
        .select((employee, department) => (
              employee.name,
              department.name,
            ))
        .fetch();

    check(result).unorderedEquals([
      // employee.name, department.name
      ('Alice', 'Engineering'),
      ('Bob', 'Sales'),
      ('Charlie', 'Engineering'),
      (null, 'Marketing'),
    ]);
    // #endregion
  });

  r.run();
}
