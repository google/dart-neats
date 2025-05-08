This document shows how to use joins with `package:typed_sql`.
Examples throughout this document assume a database schema defined as
follows:

```dart company_test.dart#schema
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

```

Similarly, examples in this document will assume that the database is loaded
with the following examples:
```dart company_test.dart#initial-data
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
```

## (Inner) join two tables with `.join`
In `package:typed_sql` we can join two [Query] objects creating a new `Query`
object with fields from both queries. The follow example shows how to join
the employees table with the departments table.

```dart company_test.dart#inner-join
final List<(Employee, Department)> result = await db.employees
    .join(db.departments)
    .on((employee, department) =>
        employee.departmentId.equals(department.departmentId))
    // Now we have a Query<(Expr<Employee>, Expr<Department>)>
    .fetch();

for (final (employee, department) in result) {
  check(employee.departmentId).equals(department.departmentId);
}
```

When joining `Query<(Expr<A>, Expr<B>, ...)>` with
`Query<(Expr<C>, Expr<D>, ...)>` we first call `.join` to create an [InnerJoin]
object, we then call `InnerJoin.on` to create a
`Query<(Expr<A>, Expr<B>, ..., Expr<C>, Expr<D>, ...)>`. Once you've joined two
query objects, you can still use `.where` and `.select` on the resulting
query object as demonstrated in the example below:

```dart company_test.dart#inner-join-select
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
```

The equivalent SQL query for the above example would like:
```sql
SELECT
  employees.name,
  departments.name
FROM employees
INNER JOIN departments
  ON employees.departmentId IS NOT DISTINCT FROM departments.departmentId
```

The `.on` extension method on `InnerJoin` let's us join on any condition.
However, because used the `@References` annotation to declare
`Employee.departmentId` a _foreign key_, we also get a `.usingDepartment`
extension method on `InnerJoin<(Expr<Employee>,), (Expr<Department>,)>`.
Thus, we don't have to use `.on`, instead we can simply do:

```dart company_test.dart#inner-join-using-select
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
```

The `.usingDepartment` is only available when joining `departments` with
`employees` or `employees` with `departments`. If you want to join multiple
tables or projections you'll have to use the `.on` extension method.

> [!NOTE]
> The name of the `.usingDepartment` extension method, gets the suffix
> "Department" from the `name` field in the `@References` annotation.

If you want to create the cartesian product (`CROSS JOIN`), you can use the
`.all` extension method. The `.all` extension method is not available for
left and right joins.

## (Left) join two tables with `.leftJoin`
We can also do a `.leftJoin` of two queries, this works the same way as `.join`
except that in the resulting query object all the fields from the right hand
query will be nullable.

In the example below, we do a `.leftJoin` of the employees table with the
departments table, resulting in a query object where `department` is nullable.

```dart company_test.dart#left-join-select
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
```

The equivalent SQL query for the above example would look like:
```sql
SELECT
  employees.name,
  departments.name
FROM employees
LEFT JOIN departments
  ON employees.departmentId = departments.departmentId
```

Again the `.usingDepartment` extension method is only available for joins on
between `departments` and `employees` or `employees` and `departments`.
For other joins you'll have to use the `.on` extension method.

## (Right) join two tables with `.rightJoin`
Similarly, to how we can do a `.leftJoin`, we can also do a `.rightJoin`. This
behaves symmetrically, meaning that the fields from the left hand query will
be nullable, while all fields from the right hand query will be present in
the joined query. The following example show how to do a `RIGHT JOIN`:

```dart company_test.dart#right-join-select
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
```

The equivalent SQL query for the above example would look like:
```sql
SELECT
  employees.name,
  departments.name
FROM employees
RIGHT JOIN departments
  ON employees.departmentId = departments.departmentId
```

> [!NOTE]
> There is currently no support for `FULL OUTER JOIN` in `package:typed_sql`,
> this may be introduced in the future. But at the moment PostgreSQL only
> supports `FULL JOIN` on merge-joinable and hash-joinable expressions.

<!-- GENERATED DOCUMENTATION LINKS -->
[InnerJoin]: ../typed_sql/InnerJoin-class.html
[Query]: ../typed_sql/Query-class.html
