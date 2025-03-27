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

part 'join_model_test.g.dart';

abstract final class CompanyDatabase extends Schema {
  Table<Employee> get employees;
  Table<Department> get departments;
}

@PrimaryKey(['employeeId'])
abstract final class Employee extends Model {
  @AutoIncrement()
  int get employeeId;

  String get name;

  int? get departmentId;
}

@PrimaryKey(['departmentId'])
abstract final class Department extends Model {
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
  (id: 5, name: 'Eve', departmentId: 4),
];

void main() {
  final r = TestRunner<CompanyDatabase>(
    setup: (db) async {
      await db.createTables();
      for (final d in _initialDepartments) {
        await db.departments
            .insert(
              departmentId: literal(d.id),
              name: literal(d.name),
              location: literal(d.location),
            )
            .execute();
      }
      for (final e in _initialEmployees) {
        await db.employees
            .insert(
              employeeId: literal(e.id),
              name: literal(e.name),
              departmentId: literal(e.departmentId),
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
    final result = await db.employees
        .leftJoin(db.departments)
        .on((employee, department) =>
            employee.departmentId.equals(department.departmentId))
        .fetch();
    check(result).length.equals(5);
  });

  r.addTest('employees.rightJoin(departments)', (db) async {
    final result = await db.employees
        .rightJoin(db.departments)
        .on((employee, department) =>
            employee.departmentId.equals(department.departmentId))
        .fetch();
    check(result).length.equals(4);
  });

  // --- Standard Join Test Cases (Equi-Join) ---

  // Test standard INNER JOIN with equality ON condition.
  r.addTest('employees.join(departments)', (db) async {
    final result = await db.employees
        .join(db.departments)
        .on((employee, department) =>
            employee.departmentId.equals(department.departmentId))
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
        .on((employee, department) =>
            employee.departmentId.equals(department.departmentId))
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
        .on((employee, department) =>
            employee.departmentId.equals(department.departmentId))
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

  // --- ON TRUE Test Cases ---

  // Test INNER JOIN with a condition that is always true (Cartesian Product).
  r.addTest('employees.join(..).on(true)', (db) async {
    final result = await db.employees
        .join(db.departments)
        .on((employee, department) => literal(true))
        .select((employee, department) => (
              employee.name,
              department.name,
            ))
        .fetch();
    check(result).unorderedEquals([
      ('Alice', 'Engineering'),
      ('Alice', 'Sales'),
      ('Alice', 'Marketing'),
      ('Bob', 'Engineering'),
      ('Bob', 'Sales'),
      ('Bob', 'Marketing'),
      ('Charlie', 'Engineering'),
      ('Charlie', 'Sales'),
      ('Charlie', 'Marketing'),
      ('David', 'Engineering'),
      ('David', 'Sales'),
      ('David', 'Marketing'),
      ('Eve', 'Engineering'),
      ('Eve', 'Sales'),
      ('Eve', 'Marketing'),
    ]);
  });

  // Test LEFT JOIN with a condition that is always true (Cartesian Product).
  r.addTest('employees.leftJoin(..).on(true)', (db) async {
    final result = await db.employees
        .leftJoin(db.departments)
        .on((employee, department) => literal(true))
        .select((employee, department) => (
              employee.name,
              department.name,
            ))
        .fetch();
    check(result).unorderedEquals([
      ('Alice', 'Engineering'),
      ('Alice', 'Sales'),
      ('Alice', 'Marketing'),
      ('Bob', 'Engineering'),
      ('Bob', 'Sales'),
      ('Bob', 'Marketing'),
      ('Charlie', 'Engineering'),
      ('Charlie', 'Sales'),
      ('Charlie', 'Marketing'),
      ('David', 'Engineering'),
      ('David', 'Sales'),
      ('David', 'Marketing'),
      ('Eve', 'Engineering'),
      ('Eve', 'Sales'),
      ('Eve', 'Marketing'),
    ]);
  });

  // Test RIGHT JOIN with a condition that is always true (Cartesian Product).
  r.addTest('employees.rightJoin(..).on(true)', (db) async {
    final result = await db.employees
        .rightJoin(db.departments)
        .on((employee, department) => literal(true))
        .select((employee, department) => (
              employee.name,
              department.name,
            ))
        .fetch();
    check(result).unorderedEquals([
      ('Alice', 'Engineering'),
      ('Bob', 'Engineering'),
      ('Charlie', 'Engineering'),
      ('David', 'Engineering'),
      ('Eve', 'Engineering'),
      ('Alice', 'Sales'),
      ('Bob', 'Sales'),
      ('Charlie', 'Sales'),
      ('David', 'Sales'),
      ('Eve', 'Sales'),
      ('Alice', 'Marketing'),
      ('Bob', 'Marketing'),
      ('Charlie', 'Marketing'),
      ('David', 'Marketing'),
      ('Eve', 'Marketing'),
    ]);
  });

  // --- ON FALSE Test Cases ---

  // Test INNER JOIN with a condition that is always false (Empty Set).
  r.addTest('employees.join(..).on(false)', (db) async {
    final result = await db.employees
        .join(db.departments)
        .on((employee, department) => literal(false))
        .select((employee, department) => (
              employee.name,
              department.name,
            ))
        .fetch();
    check(result).unorderedEquals([]);
  });

  // Test LEFT JOIN with a condition that is always false (All left rows + NULLs).
  r.addTest('employees.leftJoin(..).on(false)', (db) async {
    final result = await db.employees
        .leftJoin(db.departments)
        .on((employee, department) => literal(false))
        .select((employee, department) => (
              employee.name,
              department.name,
            ))
        .fetch();
    check(result).unorderedEquals([
      ('Alice', null),
      ('Bob', null),
      ('Charlie', null),
      ('David', null),
      ('Eve', null),
    ]);
  });

  // Test RIGHT JOIN with a condition that is always false (All right rows + NULLs).
  r.addTest('employees.rightJoin(..).on(false)', (db) async {
    final result = await db.employees
        .rightJoin(db.departments)
        .on((employee, department) => literal(false))
        .select((employee, department) => (
              employee.name,
              department.name,
            ))
        .fetch();
    check(result).unorderedEquals([
      (null, 'Engineering'),
      (null, 'Sales'),
      (null, 'Marketing'),
    ]);
  });

  // --- Other ON Conditions ---

  // Test INNER JOIN with a non-equality condition
  r.addTest('employees.join(..).on(notEquals)', (db) async {
    final result = await db.employees
        .join(db.departments)
        .on((employee, department) =>
            employee.departmentId.notEquals(department.departmentId))
        .select((employee, department) => (
              employee.name,
              department.name,
            ))
        .fetch();
    check(result).unorderedEquals([
      ('Alice', 'Sales'),
      ('Alice', 'Marketing'),
      ('Bob', 'Engineering'),
      ('Bob', 'Marketing'),
      ('Charlie', 'Sales'),
      ('Charlie', 'Marketing'),
      ('David', 'Engineering'),
      ('David', 'Sales'),
      ('David', 'Marketing'),
      ('Eve', 'Engineering'),
      ('Eve', 'Sales'),
      ('Eve', 'Marketing'),
    ]);
  });

  // Test LEFT JOIN with a non-equality condition
  r.addTest('employees.leftJoin(..).on(notEquals)', (db) async {
    final result = await db.employees
        .leftJoin(db.departments)
        .on((employee, department) =>
            employee.departmentId.notEquals(department.departmentId))
        .select((employee, department) => (
              employee.name,
              department.name,
            ))
        .fetch();
    // Result is same as INNER JOIN here because IS DISTINCT FROM always finds matches for all employees
    check(result).unorderedEquals([
      ('Alice', 'Sales'),
      ('Alice', 'Marketing'),
      ('Bob', 'Engineering'),
      ('Bob', 'Marketing'),
      ('Charlie', 'Sales'),
      ('Charlie', 'Marketing'),
      ('David', 'Engineering'),
      ('David', 'Sales'),
      ('David', 'Marketing'),
      ('Eve', 'Engineering'),
      ('Eve', 'Sales'),
      ('Eve', 'Marketing'),
    ]);
  });

  // Test LEFT JOIN where the ON condition uses non-key columns.
  r.addTest('employees.leftJoin.on(name)', (db) async {
    final result = await db.employees
        .leftJoin(db.departments)
        .on((employee, department) => employee.name.equals(department.name))
        .select((employee, department) => (
              employee.name,
              department.name,
              department.location,
            ))
        .fetch();
    // Since no employee names match department names in the sample data
    check(result).unorderedEquals([
      ('Alice', null, null),
      ('Bob', null, null),
      ('Charlie', null, null),
      ('David', null, null),
      ('Eve', null, null),
    ]);
  });

  // --- Self Join ---

  // Test joining a table to itself (self-join) to find colleagues.
  r.addTest('employees.selfJoinFindColleagues', (db) async {
    final result = await db.employees
        .join(db.employees)
        .on((e1, e2) =>
            e1.departmentId.equals(e2.departmentId) &
            e1.employeeId.notEquals(e2.employeeId) &
            e1.departmentId.isNotNull())
        .select((e1, e2) => (
              e1.name,
              e2.name,
            ))
        .fetch();
    check(result).unorderedEquals([
      ('Alice', 'Charlie'),
      ('Charlie', 'Alice'),
    ]);
  });

  // Test INNER JOIN with multiple conditions in the ON clause (AND).
  r.addTest('employees.join(..).on(deptId & DeptName)', (db) async {
    final result = await db.employees
        .join(db.departments)
        .on((employee, department) =>
            employee.departmentId.equals(department.departmentId) &
            department.name.equals(literal('Engineering')))
        .select((employee, department) => (
              employee.name,
              department.name,
            ))
        .fetch();
    check(result).unorderedEquals([
      ('Alice', 'Engineering'),
      ('Charlie', 'Engineering'),
    ]);
  });

  // Test LEFT JOIN with multiple conditions in the ON clause (OR).
  r.addTest('employees.leftJoin(..).on(deptId | David & Marketing)',
      (db) async {
    final result = await db.employees
        .leftJoin(db.departments)
        .on(
          (employee, department) =>
              employee.departmentId.equals(department.departmentId) |
              (employee.name.equals(literal('David')) &
                  department.name.equals(literal('Marketing'))),
        )
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
      ('David', 'Marketing', 'Floor 3'),
      ('Eve', null, null),
    ]);
  });

  // Test LEFT JOIN followed by a WHERE clause filtering on the right table
  r.addTest('employees.leftJoin(..).where(department.isNotNull())', (db) async {
    final result = await db.employees
        .leftJoin(db.departments)
        .on((employee, department) =>
            employee.departmentId.equals(department.departmentId))
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
        .on((employee, department) =>
            employee.departmentId.equals(department.departmentId))
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
        .on(
          (department, employee) =>
              department.departmentId.equals(employee.departmentId),
        )
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

  // Test self LEFT JOIN to find all employees and any colleagues in the same department.
  r.addTest('employees.leftJoinColleagues', (db) async {
    final result = await db.employees
        .leftJoin(db.employees)
        .on(
          (e1, e2) =>
              e1.departmentId.equals(e2.departmentId) &
              e1.employeeId.notEquals(e2.employeeId) &
              e1.departmentId.isNotNull(),
        )
        .select((e1, e2) => (
              e1.name,
              e2.name,
            ))
        .fetch();
    check(result).unorderedEquals([
      ('Alice', 'Charlie'),
      ('Bob', null),
      ('Charlie', 'Alice'),
      ('David', null),
      ('Eve', null),
    ]);
  });

  // Test INNER JOIN using a condition comparing unrelated columns.
  r.addTest('employees.join(..).on(employeeId = deptId)', (db) async {
    final result = await db.employees
        .join(db.departments)
        .on((employee, department) =>
            employee.employeeId.equals(department.departmentId))
        .select((employee, department) => (
              employee.name,
              department.name,
            ))
        .fetch();
    check(result).unorderedEquals([
      ('Alice', 'Engineering'),
      ('Bob', 'Sales'),
      ('Charlie', 'Marketing'),
    ]);
  });

  r.run();
}
