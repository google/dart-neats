// Copyright 2026 Google LLC
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

part 'complex_aggregations_test.g.dart';

abstract final class CompanyDatabase extends Schema {
  Table<Department> get departments;
  Table<Employee> get employees;
  Table<Project> get projects;
}

@PrimaryKey(['departmentId'])
abstract final class Department extends Row {
  @AutoIncrement()
  int get departmentId;

  @SqlOverride(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String get name;
}

@PrimaryKey(['employeeId'])
abstract final class Employee extends Row {
  @AutoIncrement()
  int get employeeId;

  String get name;

  @References(table: 'departments', field: 'departmentId')
  int get departmentId;
}

@PrimaryKey(['projectId'])
abstract final class Project extends Row {
  @AutoIncrement()
  int get projectId;

  String get name;

  @References(table: 'departments', field: 'departmentId')
  int get departmentId;

  int get budget;
}

void main() {
  final r = TestRunner<CompanyDatabase>(
    setup: (db) async {
      await db.createTables();
    },
  );

  r.addTest('Complex aggregations with 3-way join and groupBy', (db) async {
    await db.departments.insertValue(departmentId: 1, name: 'Eng').execute();
    await db.departments.insertValue(departmentId: 2, name: 'Sales').execute();

    await db.employees
        .insertValue(employeeId: 1, name: 'Alice', departmentId: 1)
        .execute();
    await db.employees
        .insertValue(employeeId: 2, name: 'Bob', departmentId: 1)
        .execute();
    await db.employees
        .insertValue(employeeId: 3, name: 'Charlie', departmentId: 2)
        .execute();

    await db.projects
        .insertValue(projectId: 1, name: 'P1', departmentId: 1, budget: 1000)
        .execute();
    await db.projects
        .insertValue(projectId: 2, name: 'P2', departmentId: 1, budget: 2000)
        .execute();
    await db.projects
        .insertValue(projectId: 3, name: 'P3', departmentId: 2, budget: 5000)
        .execute();

    final result = await db.departments
        .join(db.employees)
        .on((d, e) => d.departmentId.equals(e.departmentId))
        .join(db.projects)
        .on((d, e, p) => d.departmentId.equals(p.departmentId))
        .groupBy((d, e, p) => (d.name,))
        .aggregate(
          (agg) => agg.count().sum((d, e, p) => p.budget),
        )
        .fetch();

    check(result).unorderedEquals([
      ('Eng', 4, 6000),
      ('Sales', 1, 5000),
    ]);
  });

  r.run();
}
