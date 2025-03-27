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

part 'join_query_test.g.dart';

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

  // Join query and table

  r.addTest('employees.where(..).join(departments)', (db) async {
    final result = await db.employees
        .where((e) => e.name.endsWithLiteral('e'))
        .join(db.departments)
        .on((e, d) => e.departmentId.equals(d.departmentId))
        .fetch();
    check(result).length.equals(2);
  });

  r.addTest('employees.where(..).leftJoin(departments)', (db) async {
    final result = await db.employees
        .where((e) => e.name.endsWithLiteral('e'))
        .leftJoin(db.departments)
        .on((e, d) => e.departmentId.equals(d.departmentId))
        .fetch();
    check(result).length.equals(3);
  });

  r.addTest('employees.where(..).rightJoin(departments)', (db) async {
    final result = await db.employees
        .where((e) => e.name.endsWithLiteral('e'))
        .rightJoin(db.departments)
        .on((e, d) => e.departmentId.equals(d.departmentId))
        .fetch();
    check(result).length.equals(4);
  });

  // Join table and query

  r.addTest('departments.join(employees.where(..))', (db) async {
    final result = await db.departments
        .join(db.employees.where((e) => e.name.endsWithLiteral('e')))
        .on((d, e) => e.departmentId.equals(d.departmentId))
        .fetch();
    check(result).length.equals(2);
  });

  r.addTest('departments.leftJoin(employees.where(..))', (db) async {
    final result = await db.departments
        .leftJoin(db.employees.where((e) => e.name.endsWithLiteral('e')))
        .on((d, e) => e.departmentId.equals(d.departmentId))
        .fetch();
    check(result).length.equals(4);
  });

  r.addTest('departments.rightJoin(employees.where(..))', (db) async {
    final result = await db.departments
        .rightJoin(db.employees.where((e) => e.name.endsWithLiteral('e')))
        .on((d, e) => e.departmentId.equals(d.departmentId))
        .fetch();
    check(result).length.equals(3);
  });

  // Join query and query

  r.addTest('departments.where(..).join(employees.where(..))', (db) async {
    final result = await db.departments
        .where((d) => d.location.notEqualsLiteral('Floor 3'))
        .join(db.employees.where((e) => e.name.endsWithLiteral('e')))
        .on((d, e) => e.departmentId.equals(d.departmentId))
        .fetch();
    check(result).length.equals(2);
  });

  r.addTest('departments.where(..).leftJoin(employees.where(..))', (db) async {
    final result = await db.departments
        .where((d) => d.location.notEqualsLiteral('Floor 3'))
        .leftJoin(db.employees.where((e) => e.name.endsWithLiteral('e')))
        .on((d, e) => e.departmentId.equals(d.departmentId))
        .fetch();
    check(result).length.equals(3);
  });

  r.addTest('departments.where(..).rightJoin(employees.where(..))', (db) async {
    final result = await db.departments
        .where((d) => d.location.notEqualsLiteral('Floor 3'))
        .rightJoin(db.employees.where((e) => e.name.endsWithLiteral('e')))
        .on((d, e) => e.departmentId.equals(d.departmentId))
        .fetch();
    check(result).length.equals(3);
  });

  r.run();
}
