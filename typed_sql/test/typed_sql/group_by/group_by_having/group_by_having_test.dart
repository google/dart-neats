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

part 'group_by_having_test.g.dart';

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
  (surname: 'Jones', salary: 1500),
  (surname: 'Jones', salary: 2500),
  (surname: 'Williams', salary: 1000),
  (surname: 'Brown', salary: 1000),
  (surname: 'Brown', salary: 1000),
  (surname: 'Brown', salary: 1000),
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

  r.addTest('groupBy.aggregate.where (HAVING emulation)', (db) async {
    final result = await db.employees
        .groupBy((e) => (e.surname,))
        .aggregate((agg) => agg.count())
        .where((surname, count) => count.greaterThan(toExpr(1)))
        .fetch();

    // Smith: 2
    // Jones: 2
    // Williams: 1 (filtered out)
    // Brown: 3

    check(result).unorderedEquals([
      ('Smith', 2),
      ('Jones', 2),
      ('Brown', 3),
    ]);
  });

  r.addTest('groupBy.aggregate.where.select', (db) async {
    final result = await db.employees
        .groupBy((e) => (e.surname,))
        .aggregate((agg) => agg.count())
        .where((surname, count) => count.greaterThan(toExpr(1)))
        .select((surname, count) => (surname,))
        .fetch();

    check(result).unorderedEquals([
      'Smith',
      'Jones',
      'Brown',
    ]);
  });

  r.addTest('groupBy.aggregate.select.where', (db) async {
    final result = await db.employees
        .groupBy((e) => (e.surname,))
        .aggregate((agg) => agg.count())
        .select((surname, count) => (surname, count))
        .where((surname, count) => count.equals(toExpr(3)))
        .fetch();

    check(result).unorderedEquals([
      ('Brown', 3),
    ]);
  });

  r.run();
}
