// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_by_join_expression_test.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

/// Extension methods for a [Database] operating on [TestDatabase].
extension TestDatabaseSchema on Database<TestDatabase> {
  static const _$tables = [_$Department._$table, _$Employee._$table];

  Table<Department> get departments => $ForGeneratedCode.declareTable(
        this,
        _$Department._$table,
      );

  Table<Employee> get employees => $ForGeneratedCode.declareTable(
        this,
        _$Employee._$table,
      );

  /// Create tables defined in [TestDatabase].
  ///
  /// Calling this on an empty database will create the tables
  /// defined in [TestDatabase]. In production it's often better to
  /// use [createTestDatabaseTables] and manage migrations using
  /// external tools.
  ///
  /// This method is mostly useful for testing.
  ///
  /// > [!WARNING]
  /// > If the database is **not empty** behavior is undefined, most
  /// > likely this operation will fail.
  Future<void> createTables() async => $ForGeneratedCode.createTables(
        context: this,
        tables: _$tables,
      );
}

/// Get SQL [DDL statements][1] for tables defined in [TestDatabase].
///
/// This returns a SQL script with multiple DDL statements separated by `;`
/// using the specified [dialect].
///
/// Executing these statements in an empty database will create the tables
/// defined in [TestDatabase]. In practice, this method is often used for
/// printing the DDL statements, such that migrations can be managed by
/// external tools.
///
/// [1]: https://en.wikipedia.org/wiki/Data_definition_language
String createTestDatabaseTables(SqlDialect dialect) =>
    $ForGeneratedCode.createTableSchema(
      dialect: dialect,
      tables: TestDatabaseSchema._$tables,
    );

final class _$Department extends Department {
  _$Department._(
    this.id,
    this.name,
  );

  @override
  final int id;

  @override
  final String name;

  static const _$table = (
    tableName: 'departments',
    columns: <String>['id', 'name'],
    columnInfo: <({
      ColumnType type,
      bool isNotNull,
      Object? defaultValue,
      bool autoIncrement,
      List<SqlOverride> overrides,
    })>[
      (
        type: $ForGeneratedCode.integer,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: true,
        overrides: <SqlOverride>[],
      ),
      (
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: <SqlOverride>[],
      )
    ],
    primaryKey: <String>['id'],
    unique: <List<String>>[],
    foreignKeys: <({
      String name,
      List<String> columns,
      String referencedTable,
      List<String> referencedColumns,
    })>[],
    readRow: _$Department._$fromDatabase,
  );

  static Department? _$fromDatabase(RowReader row) {
    final id = row.readInt();
    final name = row.readString();
    if (id == null && name == null) {
      return null;
    }
    return _$Department._(id!, name!);
  }

  @override
  String toString() => 'Department(id: "$id", name: "$name")';
}

/// Extension methods for table defined in [Department].
extension TableDepartmentExt on Table<Department> {
  /// Insert row into the `departments` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<Department> insert({
    Expr<int>? id,
    required Expr<String> name,
  }) =>
      $ForGeneratedCode.insertInto(
        table: this,
        values: [
          id,
          name,
        ],
      );

  /// Delete a single row from the `departments` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<Department> delete(int id) => $ForGeneratedCode.deleteSingle(
        byKey(id),
        _$Department._$table,
      );
}

/// Extension methods for building queries against the `departments` table.
extension QueryDepartmentExt on Query<(Expr<Department>,)> {
  /// Lookup a single row in `departments` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<Department>,)> byKey(int id) =>
      where((department) => department.id.equalsValue(id)).first;

  /// Update all rows in the `departments` table matching this [Query].
  ///
  /// The changes to be applied to each row matching this [Query] are
  /// defined using the [updateBuilder], which is given an [Expr]
  /// representation of the row being updated and a `set` function to
  /// specify which fields should be updated. The result of the `set`
  /// function should always be returned from the `updateBuilder`.
  ///
  /// Returns an [Update] statement on which `.execute()` must be called
  /// for the rows to be updated.
  ///
  /// **Example:** decrementing `1` from the `value` field for each row
  /// where `value > 0`.
  /// ```dart
  /// await db.mytable
  ///   .where((row) => row.value > toExpr(0))
  ///   .update((row, set) => set(
  ///     value: row.value - toExpr(1),
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  Update<Department> update(
          UpdateSet<Department> Function(
            Expr<Department> department,
            UpdateSet<Department> Function({
              Expr<int> id,
              Expr<String> name,
            }) set,
          ) updateBuilder) =>
      $ForGeneratedCode.update<Department>(
        this,
        _$Department._$table,
        (department) => updateBuilder(
          department,
          ({
            Expr<int>? id,
            Expr<String>? name,
          }) =>
              $ForGeneratedCode.buildUpdate<Department>([
            id,
            name,
          ]),
        ),
      );

  /// Delete all rows in the `departments` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<Department> delete() =>
      $ForGeneratedCode.delete(this, _$Department._$table);
}

/// Extension methods for building point queries against the `departments` table.
extension QuerySingleDepartmentExt on QuerySingle<(Expr<Department>,)> {
  /// Update the row (if any) in the `departments` table matching this
  /// [QuerySingle].
  ///
  /// The changes to be applied to the row matching this [QuerySingle] are
  /// defined using the [updateBuilder], which is given an [Expr]
  /// representation of the row being updated and a `set` function to
  /// specify which fields should be updated. The result of the `set`
  /// function should always be returned from the `updateBuilder`.
  ///
  /// Returns an [UpdateSingle] statement on which `.execute()` must be
  /// called for the row to be updated. The resulting statement will
  /// **not** fail, if there are no rows matching this query exists.
  ///
  /// **Example:** decrementing `1` from the `value` field the row with
  /// `id = 1`.
  /// ```dart
  /// await db.mytable
  ///   .byKey(1)
  ///   .update((row, set) => set(
  ///     value: row.value - toExpr(1),
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  UpdateSingle<Department> update(
          UpdateSet<Department> Function(
            Expr<Department> department,
            UpdateSet<Department> Function({
              Expr<int> id,
              Expr<String> name,
            }) set,
          ) updateBuilder) =>
      $ForGeneratedCode.updateSingle<Department>(
        this,
        _$Department._$table,
        (department) => updateBuilder(
          department,
          ({
            Expr<int>? id,
            Expr<String>? name,
          }) =>
              $ForGeneratedCode.buildUpdate<Department>([
            id,
            name,
          ]),
        ),
      );

  /// Delete the row (if any) in the `departments` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<Department> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$Department._$table);
}

/// Extension methods for expressions on a row in the `departments` table.
extension ExpressionDepartmentExt on Expr<Department> {
  Expr<int> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String> get name =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);
}

extension ExpressionNullableDepartmentExt on Expr<Department?> {
  Expr<int?> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String?> get name =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  /// Check if the row is not `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNotNull() => id.isNotNull();

  /// Check if the row is `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNull() => isNotNull().not();
}

final class _$Employee extends Employee {
  _$Employee._(
    this.id,
    this.name,
    this.deptId,
    this.salary,
  );

  @override
  final int id;

  @override
  final String name;

  @override
  final int deptId;

  @override
  final int salary;

  static const _$table = (
    tableName: 'employees',
    columns: <String>['id', 'name', 'deptId', 'salary'],
    columnInfo: <({
      ColumnType type,
      bool isNotNull,
      Object? defaultValue,
      bool autoIncrement,
      List<SqlOverride> overrides,
    })>[
      (
        type: $ForGeneratedCode.integer,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: true,
        overrides: <SqlOverride>[],
      ),
      (
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: <SqlOverride>[],
      ),
      (
        type: $ForGeneratedCode.integer,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: <SqlOverride>[],
      ),
      (
        type: $ForGeneratedCode.integer,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: <SqlOverride>[],
      )
    ],
    primaryKey: <String>['id'],
    unique: <List<String>>[],
    foreignKeys: <({
      String name,
      List<String> columns,
      String referencedTable,
      List<String> referencedColumns,
    })>[
      (
        name: 'dept',
        columns: ['deptId'],
        referencedTable: 'departments',
        referencedColumns: ['id'],
      )
    ],
    readRow: _$Employee._$fromDatabase,
  );

  static Employee? _$fromDatabase(RowReader row) {
    final id = row.readInt();
    final name = row.readString();
    final deptId = row.readInt();
    final salary = row.readInt();
    if (id == null && name == null && deptId == null && salary == null) {
      return null;
    }
    return _$Employee._(id!, name!, deptId!, salary!);
  }

  @override
  String toString() =>
      'Employee(id: "$id", name: "$name", deptId: "$deptId", salary: "$salary")';
}

/// Extension methods for table defined in [Employee].
extension TableEmployeeExt on Table<Employee> {
  /// Insert row into the `employees` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<Employee> insert({
    Expr<int>? id,
    required Expr<String> name,
    required Expr<int> deptId,
    required Expr<int> salary,
  }) =>
      $ForGeneratedCode.insertInto(
        table: this,
        values: [
          id,
          name,
          deptId,
          salary,
        ],
      );

  /// Delete a single row from the `employees` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<Employee> delete(int id) => $ForGeneratedCode.deleteSingle(
        byKey(id),
        _$Employee._$table,
      );
}

/// Extension methods for building queries against the `employees` table.
extension QueryEmployeeExt on Query<(Expr<Employee>,)> {
  /// Lookup a single row in `employees` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<Employee>,)> byKey(int id) =>
      where((employee) => employee.id.equalsValue(id)).first;

  /// Update all rows in the `employees` table matching this [Query].
  ///
  /// The changes to be applied to each row matching this [Query] are
  /// defined using the [updateBuilder], which is given an [Expr]
  /// representation of the row being updated and a `set` function to
  /// specify which fields should be updated. The result of the `set`
  /// function should always be returned from the `updateBuilder`.
  ///
  /// Returns an [Update] statement on which `.execute()` must be called
  /// for the rows to be updated.
  ///
  /// **Example:** decrementing `1` from the `value` field for each row
  /// where `value > 0`.
  /// ```dart
  /// await db.mytable
  ///   .where((row) => row.value > toExpr(0))
  ///   .update((row, set) => set(
  ///     value: row.value - toExpr(1),
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  Update<Employee> update(
          UpdateSet<Employee> Function(
            Expr<Employee> employee,
            UpdateSet<Employee> Function({
              Expr<int> id,
              Expr<String> name,
              Expr<int> deptId,
              Expr<int> salary,
            }) set,
          ) updateBuilder) =>
      $ForGeneratedCode.update<Employee>(
        this,
        _$Employee._$table,
        (employee) => updateBuilder(
          employee,
          ({
            Expr<int>? id,
            Expr<String>? name,
            Expr<int>? deptId,
            Expr<int>? salary,
          }) =>
              $ForGeneratedCode.buildUpdate<Employee>([
            id,
            name,
            deptId,
            salary,
          ]),
        ),
      );

  /// Delete all rows in the `employees` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<Employee> delete() =>
      $ForGeneratedCode.delete(this, _$Employee._$table);
}

/// Extension methods for building point queries against the `employees` table.
extension QuerySingleEmployeeExt on QuerySingle<(Expr<Employee>,)> {
  /// Update the row (if any) in the `employees` table matching this
  /// [QuerySingle].
  ///
  /// The changes to be applied to the row matching this [QuerySingle] are
  /// defined using the [updateBuilder], which is given an [Expr]
  /// representation of the row being updated and a `set` function to
  /// specify which fields should be updated. The result of the `set`
  /// function should always be returned from the `updateBuilder`.
  ///
  /// Returns an [UpdateSingle] statement on which `.execute()` must be
  /// called for the row to be updated. The resulting statement will
  /// **not** fail, if there are no rows matching this query exists.
  ///
  /// **Example:** decrementing `1` from the `value` field the row with
  /// `id = 1`.
  /// ```dart
  /// await db.mytable
  ///   .byKey(1)
  ///   .update((row, set) => set(
  ///     value: row.value - toExpr(1),
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  UpdateSingle<Employee> update(
          UpdateSet<Employee> Function(
            Expr<Employee> employee,
            UpdateSet<Employee> Function({
              Expr<int> id,
              Expr<String> name,
              Expr<int> deptId,
              Expr<int> salary,
            }) set,
          ) updateBuilder) =>
      $ForGeneratedCode.updateSingle<Employee>(
        this,
        _$Employee._$table,
        (employee) => updateBuilder(
          employee,
          ({
            Expr<int>? id,
            Expr<String>? name,
            Expr<int>? deptId,
            Expr<int>? salary,
          }) =>
              $ForGeneratedCode.buildUpdate<Employee>([
            id,
            name,
            deptId,
            salary,
          ]),
        ),
      );

  /// Delete the row (if any) in the `employees` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<Employee> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$Employee._$table);
}

/// Extension methods for expressions on a row in the `employees` table.
extension ExpressionEmployeeExt on Expr<Employee> {
  Expr<int> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String> get name =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<int> get deptId =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.integer);

  Expr<int> get salary =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.integer);

  /// Do a subquery lookup of the row from table
  /// `departments` referenced in
  /// [deptId].
  ///
  /// The gets the row from table `departments` where
  /// [Department.id]
  /// is equal to [deptId].
  Expr<Department> get dept => $ForGeneratedCode
      .subqueryTable(_$Department._$table)
      .where((r) => r.id.equals(deptId))
      .first
      .asNotNull();
}

extension ExpressionNullableEmployeeExt on Expr<Employee?> {
  Expr<int?> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String?> get name =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<int?> get deptId =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.integer);

  Expr<int?> get salary =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.integer);

  /// Do a subquery lookup of the row from table
  /// `departments` referenced in
  /// [deptId].
  ///
  /// The gets the row from table `departments` where
  /// [Department.id]
  /// is equal to [deptId], if any.
  ///
  /// If this row is `NULL` the subquery is always return `NULL`.
  Expr<Department?> get dept => $ForGeneratedCode
      .subqueryTable(_$Department._$table)
      .where((r) => r.id.equalsUnlessNull(deptId).asNotNull())
      .first;

  /// Check if the row is not `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNotNull() => id.isNotNull();

  /// Check if the row is `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNull() => isNotNull().not();
}

extension InnerJoinEmployeeDepartmentExt
    on InnerJoin<(Expr<Employee>,), (Expr<Department>,)> {
  /// Join using the `dept` _foreign key_.
  ///
  /// This will match rows where [Employee.deptId] = [Department.id].
  Query<(Expr<Employee>, Expr<Department>)> usingDept() =>
      on((a, b) => b.id.equals(a.deptId));
}

extension LeftJoinEmployeeDepartmentExt
    on LeftJoin<(Expr<Employee>,), (Expr<Department>,)> {
  /// Join using the `dept` _foreign key_.
  ///
  /// This will match rows where [Employee.deptId] = [Department.id].
  Query<(Expr<Employee>, Expr<Department?>)> usingDept() =>
      on((a, b) => b.id.equals(a.deptId));
}

extension RightJoinEmployeeDepartmentExt
    on RightJoin<(Expr<Employee>,), (Expr<Department>,)> {
  /// Join using the `dept` _foreign key_.
  ///
  /// This will match rows where [Employee.deptId] = [Department.id].
  Query<(Expr<Employee?>, Expr<Department>)> usingDept() =>
      on((a, b) => b.id.equals(a.deptId));
}

/// Extension methods for assertions on [Department] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension DepartmentChecks on Subject<Department> {
  /// Create assertions on [Department.id].
  Subject<int> get id => has((m) => m.id, 'id');

  /// Create assertions on [Department.name].
  Subject<String> get name => has((m) => m.name, 'name');
}

/// Extension methods for assertions on [Employee] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension EmployeeChecks on Subject<Employee> {
  /// Create assertions on [Employee.id].
  Subject<int> get id => has((m) => m.id, 'id');

  /// Create assertions on [Employee.name].
  Subject<String> get name => has((m) => m.name, 'name');

  /// Create assertions on [Employee.deptId].
  Subject<int> get deptId => has((m) => m.deptId, 'deptId');

  /// Create assertions on [Employee.salary].
  Subject<int> get salary => has((m) => m.salary, 'salary');
}
