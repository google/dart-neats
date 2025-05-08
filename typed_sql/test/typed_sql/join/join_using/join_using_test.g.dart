// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'join_using_test.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

/// Extension methods for a [Database] operating on [CompanyDatabase].
extension CompanyDatabaseSchema on Database<CompanyDatabase> {
  static const _$tables = [_$Employee._$table, _$Department._$table];

  Table<Employee> get employees => ExposedForCodeGen.declareTable(
        this,
        _$Employee._$table,
      );

  Table<Department> get departments => ExposedForCodeGen.declareTable(
        this,
        _$Department._$table,
      );

  /// Create tables defined in [CompanyDatabase].
  ///
  /// Calling this on an empty database will create the tables
  /// defined in [CompanyDatabase]. In production it's often better to
  /// use [createCompanyDatabaseTables] and manage migrations using
  /// external tools.
  ///
  /// This method is mostly useful for testing.
  ///
  /// > [!WARNING]
  /// > If the database is **not empty** behavior is undefined, most
  /// > likely this operation will fail.
  Future<void> createTables() async => ExposedForCodeGen.createTables(
        context: this,
        tables: _$tables,
      );
}

/// Get SQL [DDL statements][1] for tables defined in [CompanyDatabase].
///
/// This returns a SQL script with multiple DDL statements separated by `;`
/// using the specified [dialect].
///
/// Executing these statements in an empty database will create the tables
/// defined in [CompanyDatabase]. In practice, this method is often used for
/// printing the DDL statements, such that migrations can be managed by
/// external tools.
///
/// [1]: https://en.wikipedia.org/wiki/Data_definition_language
String createCompanyDatabaseTables(SqlDialect dialect) =>
    ExposedForCodeGen.createTableSchema(
      dialect: dialect,
      tables: CompanyDatabaseSchema._$tables,
    );

final class _$Employee extends Employee {
  _$Employee._(
    this.employeeId,
    this.name,
    this.departmentId,
  );

  @override
  final int employeeId;

  @override
  final String name;

  @override
  final int? departmentId;

  static const _$table = (
    tableName: 'employees',
    columns: <String>['employeeId', 'name', 'departmentId'],
    columnInfo: <({
      ColumnType type,
      bool isNotNull,
      Object? defaultValue,
      bool autoIncrement,
    })>[
      (
        type: ExposedForCodeGen.integer,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: true,
      ),
      (
        type: ExposedForCodeGen.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
      ),
      (
        type: ExposedForCodeGen.integer,
        isNotNull: false,
        defaultValue: null,
        autoIncrement: false,
      )
    ],
    primaryKey: <String>['employeeId'],
    unique: <List<String>>[],
    foreignKeys: <({
      String name,
      List<String> columns,
      String referencedTable,
      List<String> referencedColumns,
    })>[
      (
        name: 'department',
        columns: ['departmentId'],
        referencedTable: 'departments',
        referencedColumns: ['departmentId'],
      )
    ],
    readRow: _$Employee._$fromDatabase,
  );

  static Employee? _$fromDatabase(RowReader row) {
    final employeeId = row.readInt();
    final name = row.readString();
    final departmentId = row.readInt();
    if (employeeId == null && name == null && departmentId == null) {
      return null;
    }
    return _$Employee._(employeeId!, name!, departmentId);
  }

  @override
  String toString() =>
      'Employee(employeeId: "$employeeId", name: "$name", departmentId: "$departmentId")';
}

/// Extension methods for table defined in [Employee].
extension TableEmployeeExt on Table<Employee> {
  /// Insert row into the `employees` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<Employee> insert({
    Expr<int>? employeeId,
    required Expr<String> name,
    Expr<int?>? departmentId,
  }) =>
      ExposedForCodeGen.insertInto(
        table: this,
        values: [
          employeeId,
          name,
          departmentId,
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
  DeleteSingle<Employee> delete(int employeeId) =>
      ExposedForCodeGen.deleteSingle(
        byKey(employeeId),
        _$Employee._$table,
      );
}

/// Extension methods for building queries against the `employees` table.
extension QueryEmployeeExt on Query<(Expr<Employee>,)> {
  /// Lookup a single row in `employees` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<Employee>,)> byKey(int employeeId) =>
      where((employee) => employee.employeeId.equalsValue(employeeId)).first;

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
              Expr<int> employeeId,
              Expr<String> name,
              Expr<int?> departmentId,
            }) set,
          ) updateBuilder) =>
      ExposedForCodeGen.update<Employee>(
        this,
        _$Employee._$table,
        (employee) => updateBuilder(
          employee,
          ({
            Expr<int>? employeeId,
            Expr<String>? name,
            Expr<int?>? departmentId,
          }) =>
              ExposedForCodeGen.buildUpdate<Employee>([
            employeeId,
            name,
            departmentId,
          ]),
        ),
      );

  /// Delete all rows in the `employees` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<Employee> delete() =>
      ExposedForCodeGen.delete(this, _$Employee._$table);
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
              Expr<int> employeeId,
              Expr<String> name,
              Expr<int?> departmentId,
            }) set,
          ) updateBuilder) =>
      ExposedForCodeGen.updateSingle<Employee>(
        this,
        _$Employee._$table,
        (employee) => updateBuilder(
          employee,
          ({
            Expr<int>? employeeId,
            Expr<String>? name,
            Expr<int?>? departmentId,
          }) =>
              ExposedForCodeGen.buildUpdate<Employee>([
            employeeId,
            name,
            departmentId,
          ]),
        ),
      );

  /// Delete the row (if any) in the `employees` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<Employee> delete() =>
      ExposedForCodeGen.deleteSingle(this, _$Employee._$table);
}

/// Extension methods for expressions on a row in the `employees` table.
extension ExpressionEmployeeExt on Expr<Employee> {
  Expr<int> get employeeId =>
      ExposedForCodeGen.field(this, 0, ExposedForCodeGen.integer);

  Expr<String> get name =>
      ExposedForCodeGen.field(this, 1, ExposedForCodeGen.text);

  Expr<int?> get departmentId =>
      ExposedForCodeGen.field(this, 2, ExposedForCodeGen.integer);

  /// Do a subquery lookup of the row from table
  /// `departments` referenced in
  /// [departmentId].
  ///
  /// The gets the row from table `departments` where
  /// [Department.departmentId]
  /// is equal to [departmentId], if any.
  Expr<Department?> get department =>
      ExposedForCodeGen.subqueryTable(_$Department._$table)
          .where((r) => r.departmentId.equals(departmentId))
          .first;
}

extension ExpressionNullableEmployeeExt on Expr<Employee?> {
  Expr<int?> get employeeId =>
      ExposedForCodeGen.field(this, 0, ExposedForCodeGen.integer);

  Expr<String?> get name =>
      ExposedForCodeGen.field(this, 1, ExposedForCodeGen.text);

  Expr<int?> get departmentId =>
      ExposedForCodeGen.field(this, 2, ExposedForCodeGen.integer);

  /// Do a subquery lookup of the row from table
  /// `departments` referenced in
  /// [departmentId].
  ///
  /// The gets the row from table `departments` where
  /// [Department.departmentId]
  /// is equal to [departmentId], if any.
  ///
  /// If this row is `NULL` the subquery is always return `NULL`.
  Expr<Department?> get department =>
      ExposedForCodeGen.subqueryTable(_$Department._$table)
          .where(
              (r) => r.departmentId.equalsUnlessNull(departmentId).asNotNull())
          .first;

  /// Check if the row is not `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNotNull() => employeeId.isNotNull();

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
  /// Join using the `department` _foreign key_.
  ///
  /// This will match rows where [Employee.departmentId] = [Department.departmentId].
  Query<(Expr<Employee>, Expr<Department>)> usingDepartment() =>
      on((a, b) => b.departmentId.equals(a.departmentId));
}

extension LeftJoinEmployeeDepartmentExt
    on LeftJoin<(Expr<Employee>,), (Expr<Department>,)> {
  /// Join using the `department` _foreign key_.
  ///
  /// This will match rows where [Employee.departmentId] = [Department.departmentId].
  Query<(Expr<Employee>, Expr<Department?>)> usingDepartment() =>
      on((a, b) => b.departmentId.equals(a.departmentId));
}

extension RightJoinEmployeeDepartmentExt
    on RightJoin<(Expr<Employee>,), (Expr<Department>,)> {
  /// Join using the `department` _foreign key_.
  ///
  /// This will match rows where [Employee.departmentId] = [Department.departmentId].
  Query<(Expr<Employee?>, Expr<Department>)> usingDepartment() =>
      on((a, b) => b.departmentId.equals(a.departmentId));
}

final class _$Department extends Department {
  _$Department._(
    this.departmentId,
    this.name,
    this.location,
  );

  @override
  final int departmentId;

  @override
  final String name;

  @override
  final String location;

  static const _$table = (
    tableName: 'departments',
    columns: <String>['departmentId', 'name', 'location'],
    columnInfo: <({
      ColumnType type,
      bool isNotNull,
      Object? defaultValue,
      bool autoIncrement,
    })>[
      (
        type: ExposedForCodeGen.integer,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: true,
      ),
      (
        type: ExposedForCodeGen.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
      ),
      (
        type: ExposedForCodeGen.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
      )
    ],
    primaryKey: <String>['departmentId'],
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
    final departmentId = row.readInt();
    final name = row.readString();
    final location = row.readString();
    if (departmentId == null && name == null && location == null) {
      return null;
    }
    return _$Department._(departmentId!, name!, location!);
  }

  @override
  String toString() =>
      'Department(departmentId: "$departmentId", name: "$name", location: "$location")';
}

/// Extension methods for table defined in [Department].
extension TableDepartmentExt on Table<Department> {
  /// Insert row into the `departments` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<Department> insert({
    Expr<int>? departmentId,
    required Expr<String> name,
    required Expr<String> location,
  }) =>
      ExposedForCodeGen.insertInto(
        table: this,
        values: [
          departmentId,
          name,
          location,
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
  DeleteSingle<Department> delete(int departmentId) =>
      ExposedForCodeGen.deleteSingle(
        byKey(departmentId),
        _$Department._$table,
      );
}

/// Extension methods for building queries against the `departments` table.
extension QueryDepartmentExt on Query<(Expr<Department>,)> {
  /// Lookup a single row in `departments` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<Department>,)> byKey(int departmentId) =>
      where((department) => department.departmentId.equalsValue(departmentId))
          .first;

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
              Expr<int> departmentId,
              Expr<String> name,
              Expr<String> location,
            }) set,
          ) updateBuilder) =>
      ExposedForCodeGen.update<Department>(
        this,
        _$Department._$table,
        (department) => updateBuilder(
          department,
          ({
            Expr<int>? departmentId,
            Expr<String>? name,
            Expr<String>? location,
          }) =>
              ExposedForCodeGen.buildUpdate<Department>([
            departmentId,
            name,
            location,
          ]),
        ),
      );

  /// Delete all rows in the `departments` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<Department> delete() =>
      ExposedForCodeGen.delete(this, _$Department._$table);
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
              Expr<int> departmentId,
              Expr<String> name,
              Expr<String> location,
            }) set,
          ) updateBuilder) =>
      ExposedForCodeGen.updateSingle<Department>(
        this,
        _$Department._$table,
        (department) => updateBuilder(
          department,
          ({
            Expr<int>? departmentId,
            Expr<String>? name,
            Expr<String>? location,
          }) =>
              ExposedForCodeGen.buildUpdate<Department>([
            departmentId,
            name,
            location,
          ]),
        ),
      );

  /// Delete the row (if any) in the `departments` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<Department> delete() =>
      ExposedForCodeGen.deleteSingle(this, _$Department._$table);
}

/// Extension methods for expressions on a row in the `departments` table.
extension ExpressionDepartmentExt on Expr<Department> {
  Expr<int> get departmentId =>
      ExposedForCodeGen.field(this, 0, ExposedForCodeGen.integer);

  Expr<String> get name =>
      ExposedForCodeGen.field(this, 1, ExposedForCodeGen.text);

  Expr<String> get location =>
      ExposedForCodeGen.field(this, 2, ExposedForCodeGen.text);

  /// Get [SubQuery] of rows from the `employees` table which
  /// reference this row.
  ///
  /// This returns a [SubQuery] of [Employee] rows,
  /// where [Employee.departmentId]
  /// references [Department.departmentId]
  /// in this row.
  SubQuery<(Expr<Employee>,)> get employees =>
      ExposedForCodeGen.subqueryTable(_$Employee._$table)
          .where((r) => r.departmentId.equals(departmentId));
}

extension ExpressionNullableDepartmentExt on Expr<Department?> {
  Expr<int?> get departmentId =>
      ExposedForCodeGen.field(this, 0, ExposedForCodeGen.integer);

  Expr<String?> get name =>
      ExposedForCodeGen.field(this, 1, ExposedForCodeGen.text);

  Expr<String?> get location =>
      ExposedForCodeGen.field(this, 2, ExposedForCodeGen.text);

  /// Get [SubQuery] of rows from the `employees` table which
  /// reference this row.
  ///
  /// This returns a [SubQuery] of [Employee] rows,
  /// where [Employee.departmentId]
  /// references [Department.departmentId]
  /// in this row, if any.
  ///
  /// If this row is `NULL` the subquery is always be empty.
  SubQuery<(Expr<Employee>,)> get employees =>
      ExposedForCodeGen.subqueryTable(_$Employee._$table).where(
          (r) => r.departmentId.equalsUnlessNull(departmentId).asNotNull());

  /// Check if the row is not `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNotNull() => departmentId.isNotNull();

  /// Check if the row is `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNull() => isNotNull().not();
}

extension InnerJoinDepartmentEmployeeExt
    on InnerJoin<(Expr<Department>,), (Expr<Employee>,)> {
  /// Join using the `department` _foreign key_.
  ///
  /// This will match rows where [Department.departmentId] = [Employee.departmentId].
  Query<(Expr<Department>, Expr<Employee>)> usingDepartment() =>
      on((a, b) => a.departmentId.equals(b.departmentId));
}

extension LeftJoinDepartmentEmployeeExt
    on LeftJoin<(Expr<Department>,), (Expr<Employee>,)> {
  /// Join using the `department` _foreign key_.
  ///
  /// This will match rows where [Department.departmentId] = [Employee.departmentId].
  Query<(Expr<Department>, Expr<Employee?>)> usingDepartment() =>
      on((a, b) => a.departmentId.equals(b.departmentId));
}

extension RightJoinDepartmentEmployeeExt
    on RightJoin<(Expr<Department>,), (Expr<Employee>,)> {
  /// Join using the `department` _foreign key_.
  ///
  /// This will match rows where [Department.departmentId] = [Employee.departmentId].
  Query<(Expr<Department?>, Expr<Employee>)> usingDepartment() =>
      on((a, b) => a.departmentId.equals(b.departmentId));
}

/// Extension methods for assertions on [Department] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension DepartmentChecks on Subject<Department> {
  /// Create assertions on [Department.departmentId].
  Subject<int> get departmentId => has((m) => m.departmentId, 'departmentId');

  /// Create assertions on [Department.name].
  Subject<String> get name => has((m) => m.name, 'name');

  /// Create assertions on [Department.location].
  Subject<String> get location => has((m) => m.location, 'location');
}

/// Extension methods for assertions on [Employee] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension EmployeeChecks on Subject<Employee> {
  /// Create assertions on [Employee.employeeId].
  Subject<int> get employeeId => has((m) => m.employeeId, 'employeeId');

  /// Create assertions on [Employee.name].
  Subject<String> get name => has((m) => m.name, 'name');

  /// Create assertions on [Employee.departmentId].
  Subject<int?> get departmentId => has((m) => m.departmentId, 'departmentId');
}
