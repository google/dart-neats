// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_test.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

/// Extension methods for a [Database] operating on [CompanyDatabase].
extension CompanyDatabaseSchema on Database<CompanyDatabase> {
  static final _$tables = [_$Department._$table, _$Employee._$table];

  Table<Department> get departments =>
      $ForGeneratedCode.declareTable(this, _$Department._$table);

  Table<Employee> get employees =>
      $ForGeneratedCode.declareTable(this, _$Employee._$table);

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
  Future<void> createTables() async =>
      $ForGeneratedCode.createTables(context: this, tables: _$tables);
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
    $ForGeneratedCode.createTableSchema(
      dialect: dialect,
      tables: CompanyDatabaseSchema._$tables,
    );

final class _$Department extends Department {
  _$Department._(this.departmentId, this.name, this.location);

  @override
  final int departmentId;

  @override
  final String name;

  @override
  final String location;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'departments',
    columns: <String>['departmentId', 'name', 'location'],
    columnInfo: [
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.integer,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: true,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
    ],
    primaryKey: <String>['departmentId'],
    unique: <List<String>>[],
    foreignKeys: [],
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
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [departmentId, name, location],
  );

  /// Insert row into the `departments` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<Department> insertValue({
    int? departmentId,
    required String name,
    required String location,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [departmentId?.asExpr, name.asExpr, location.asExpr],
  );

  /// Bulk insert rows into the `departments` table.
  ///
  /// This method takes an `Iterable<T>` and requires that you provide
  /// a _mapping function_ from `T` to each column to be inserted.
  ///
  /// If a mapping function is omitted, the _default value_ will be
  /// inserted, or `NULL` if column is nullable and as no default value.
  /// To explicitely insert `NULL`, use a _mapping function_ that maps
  /// `T` to `null`.
  ///
  /// > [!NOTE]
  /// > This method aims utilize database specific bulk insertion logic
  /// > to ensure good performance. Database adapters may pipeline bulk
  /// > insertions through multiple statements inside a transaction.
  ///
  /// Returns a [Insert] statement on which `.execute` must be
  /// called for the rows to be inserted.
  Insert<Department> insertValuesMapped<T>(
    Iterable<T> rows, {
    int Function(T row)? departmentId,
    required String Function(T row) name,
    required String Function(T row) location,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mapping: {'departmentId': departmentId, 'name': name, 'location': location},
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
      $ForGeneratedCode.deleteSingle(byKey(departmentId), _$Department._$table);
}

/// Extension methods for building queries against the `departments` table.
extension QueryDepartmentExt on Query<(Expr<Department>,)> {
  /// Lookup a single row in `departments` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<Department>,)> byKey(int departmentId) => where(
    (department) => department.departmentId.equalsValue(departmentId),
  ).first;

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
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<Department>(
    this,
    _$Department._$table,
    (department) => updateBuilder(
      department,
      ({Expr<int>? departmentId, Expr<String>? name, Expr<String>? location}) =>
          $ForGeneratedCode.buildUpdate<Department>([
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
        Expr<int> departmentId,
        Expr<String> name,
        Expr<String> location,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<Department>(
    this,
    _$Department._$table,
    (department) => updateBuilder(
      department,
      ({Expr<int>? departmentId, Expr<String>? name, Expr<String>? location}) =>
          $ForGeneratedCode.buildUpdate<Department>([
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
      $ForGeneratedCode.deleteSingle(this, _$Department._$table);
}

/// Extension methods for expressions on a row in the `departments` table.
extension ExpressionDepartmentExt on Expr<Department> {
  Expr<int> get departmentId =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String> get name =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<String> get location =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  /// Get [SubQuery] of rows from the `employees` table which
  /// reference this row.
  ///
  /// This returns a [SubQuery] of [Employee] rows,
  /// where [Employee.departmentId]
  /// references [Department.departmentId]
  /// in this row.
  SubQuery<(Expr<Employee>,)> get employees => $ForGeneratedCode
      .subqueryTable(_$Employee._$table)
      .where((r) => r.departmentId.equals(departmentId));
}

extension ExpressionNullableDepartmentExt on Expr<Department?> {
  Expr<int?> get departmentId =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String?> get name =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<String?> get location =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  /// Get [SubQuery] of rows from the `employees` table which
  /// reference this row.
  ///
  /// This returns a [SubQuery] of [Employee] rows,
  /// where [Employee.departmentId]
  /// references [Department.departmentId]
  /// in this row, if any.
  ///
  /// If this row is `NULL` the subquery is always be empty.
  SubQuery<(Expr<Employee>,)> get employees => $ForGeneratedCode
      .subqueryTable(_$Employee._$table)
      .where((r) => r.departmentId.equalsUnlessNull(departmentId).asNotNull());

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

/// `Table<Department>` conflict targets for use with `.onConflict`.
enum DepartmentConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `departmentId`.
  primaryKey(['departmentId']);

  const DepartmentConflict(this._fields);

  final List<String> _fields;
}

extension InsertDepartmentExt on Insert<Department> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((department, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflict<Department> onConflict(DepartmentConflict target) =>
      $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictDepartmentExt on InsertOnConflict<Department> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `department` an [Expr] representing the existing row in
  ///     the database,
  ///   * `excluded` an [Expr] representing the row to be inserted in the
  ///     database, and,
  ///   * `set` a function to specify which fields should be updated and
  ///     build the [UpdateSet].
  ///
  /// The result of the `set` function should always be immediately
  /// returned from the [updateBuilder].
  ///
  /// **Example:** Insert a counter with `count = 2` or increment the
  /// existing row, if a `PRIMARY KEY` conflict occurs.
  /// ```dart
  /// await db.counters.insertValue(
  ///     name: 'my-counter', // primary key
  ///     count: 2,
  ///   )
  ///   .onConflict(.primaryKey)
  ///   .update((counter, excluded, set) => set(
  ///     count: counter.count + excluded.count,
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// This is equivalent to
  /// `INSERT ... ON CONFLICT (...) UPDATE SET ...` in SQL.
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  ///
  /// [1]: https://www.sqlite.org/lang_upsert.html
  Upsert<Department> update(
    UpdateSet<Department> Function(
      Expr<Department> department,
      Expr<Department> excluded,
      UpdateSet<Department> Function({
        Expr<int> departmentId,
        Expr<String> name,
        Expr<String> location,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<Department>(
    this,
    (department, excluded) => updateBuilder(
      department,
      excluded,
      ({Expr<int>? departmentId, Expr<String>? name, Expr<String>? location}) =>
          $ForGeneratedCode.buildUpdate<Department>([
            departmentId,
            name,
            location,
          ]),
    ),
  );
}

extension InsertSingleDepartmentExt on InsertSingle<Department> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((department, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflictSingle<Department> onConflict(DepartmentConflict target) =>
      $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleDepartmentExt
    on InsertOnConflictSingle<Department> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `department` an [Expr] representing the existing row in
  ///     the database,
  ///   * `excluded` an [Expr] representing the row to be inserted in the
  ///     database, and,
  ///   * `set` a function to specify which fields should be updated and
  ///     build the [UpdateSet].
  ///
  /// The result of the `set` function should always be immediately
  /// returned from the [updateBuilder].
  ///
  /// **Example:** Insert a counter with `count = 2` or increment the
  /// existing row, if a `PRIMARY KEY` conflict occurs.
  /// ```dart
  /// await db.counters.insertValue(
  ///     name: 'my-counter', // primary key
  ///     count: 2,
  ///   )
  ///   .onConflict(.primaryKey)
  ///   .update((counter, excluded, set) => set(
  ///     count: counter.count + excluded.count,
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// This is equivalent to
  /// `INSERT ... ON CONFLICT (...) UPDATE SET ...` in SQL.
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  ///
  /// [1]: https://www.sqlite.org/lang_upsert.html
  UpsertSingle<Department> update(
    UpdateSet<Department> Function(
      Expr<Department> department,
      Expr<Department> excluded,
      UpdateSet<Department> Function({
        Expr<int> departmentId,
        Expr<String> name,
        Expr<String> location,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<Department>(
    this,
    (department, excluded) => updateBuilder(
      department,
      excluded,
      ({Expr<int>? departmentId, Expr<String>? name, Expr<String>? location}) =>
          $ForGeneratedCode.buildUpdate<Department>([
            departmentId,
            name,
            location,
          ]),
    ),
  );
}

final class _$Employee extends Employee {
  _$Employee._(this.employeeId, this.name, this.departmentId);

  @override
  final int employeeId;

  @override
  final String name;

  @override
  final int? departmentId;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'employees',
    columns: <String>['employeeId', 'name', 'departmentId'],
    columnInfo: [
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.integer,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: true,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.integer,
        isNotNull: false,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
    ],
    primaryKey: <String>['employeeId'],
    unique: <List<String>>[],
    foreignKeys: [
      $ForGeneratedCode.foreignKeyDefinition(
        name: 'department',
        columns: ['departmentId'],
        referencedTable: 'departments',
        referencedColumns: ['departmentId'],
        onDelete: .noAction,
        onUpdate: .noAction,
      ),
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
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [employeeId, name, departmentId],
  );

  /// Insert row into the `employees` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<Employee> insertValue({
    int? employeeId,
    required String name,
    int? departmentId,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [employeeId?.asExpr, name.asExpr, departmentId.asExpr],
  );

  /// Bulk insert rows into the `employees` table.
  ///
  /// This method takes an `Iterable<T>` and requires that you provide
  /// a _mapping function_ from `T` to each column to be inserted.
  ///
  /// If a mapping function is omitted, the _default value_ will be
  /// inserted, or `NULL` if column is nullable and as no default value.
  /// To explicitely insert `NULL`, use a _mapping function_ that maps
  /// `T` to `null`.
  ///
  /// > [!NOTE]
  /// > This method aims utilize database specific bulk insertion logic
  /// > to ensure good performance. Database adapters may pipeline bulk
  /// > insertions through multiple statements inside a transaction.
  ///
  /// Returns a [Insert] statement on which `.execute` must be
  /// called for the rows to be inserted.
  Insert<Employee> insertValuesMapped<T>(
    Iterable<T> rows, {
    int Function(T row)? employeeId,
    required String Function(T row) name,
    int? Function(T row)? departmentId,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mapping: {
      'employeeId': employeeId,
      'name': name,
      'departmentId': departmentId,
    },
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
      $ForGeneratedCode.deleteSingle(byKey(employeeId), _$Employee._$table);
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
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<Employee>(
    this,
    _$Employee._$table,
    (employee) => updateBuilder(
      employee,
      ({Expr<int>? employeeId, Expr<String>? name, Expr<int?>? departmentId}) =>
          $ForGeneratedCode.buildUpdate<Employee>([
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
        Expr<int> employeeId,
        Expr<String> name,
        Expr<int?> departmentId,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<Employee>(
    this,
    _$Employee._$table,
    (employee) => updateBuilder(
      employee,
      ({Expr<int>? employeeId, Expr<String>? name, Expr<int?>? departmentId}) =>
          $ForGeneratedCode.buildUpdate<Employee>([
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
      $ForGeneratedCode.deleteSingle(this, _$Employee._$table);
}

/// Extension methods for expressions on a row in the `employees` table.
extension ExpressionEmployeeExt on Expr<Employee> {
  Expr<int> get employeeId =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String> get name =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<int?> get departmentId =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.integer);

  /// Do a subquery lookup of the row from table
  /// `departments` referenced in
  /// [departmentId].
  ///
  /// The gets the row from table `departments` where
  /// [Department.departmentId]
  /// is equal to [departmentId], if any.
  Expr<Department?> get department => $ForGeneratedCode
      .subqueryTable(_$Department._$table)
      .where((r) => r.departmentId.equals(departmentId))
      .first;
}

extension ExpressionNullableEmployeeExt on Expr<Employee?> {
  Expr<int?> get employeeId =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String?> get name =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<int?> get departmentId =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.integer);

  /// Do a subquery lookup of the row from table
  /// `departments` referenced in
  /// [departmentId].
  ///
  /// The gets the row from table `departments` where
  /// [Department.departmentId]
  /// is equal to [departmentId], if any.
  ///
  /// If this row is `NULL` the subquery is always return `NULL`.
  Expr<Department?> get department => $ForGeneratedCode
      .subqueryTable(_$Department._$table)
      .where((r) => r.departmentId.equalsUnlessNull(departmentId).asNotNull())
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

/// `Table<Employee>` conflict targets for use with `.onConflict`.
enum EmployeeConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `employeeId`.
  primaryKey(['employeeId']);

  const EmployeeConflict(this._fields);

  final List<String> _fields;
}

extension InsertEmployeeExt on Insert<Employee> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((employee, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflict<Employee> onConflict(EmployeeConflict target) =>
      $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictEmployeeExt on InsertOnConflict<Employee> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `employee` an [Expr] representing the existing row in
  ///     the database,
  ///   * `excluded` an [Expr] representing the row to be inserted in the
  ///     database, and,
  ///   * `set` a function to specify which fields should be updated and
  ///     build the [UpdateSet].
  ///
  /// The result of the `set` function should always be immediately
  /// returned from the [updateBuilder].
  ///
  /// **Example:** Insert a counter with `count = 2` or increment the
  /// existing row, if a `PRIMARY KEY` conflict occurs.
  /// ```dart
  /// await db.counters.insertValue(
  ///     name: 'my-counter', // primary key
  ///     count: 2,
  ///   )
  ///   .onConflict(.primaryKey)
  ///   .update((counter, excluded, set) => set(
  ///     count: counter.count + excluded.count,
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// This is equivalent to
  /// `INSERT ... ON CONFLICT (...) UPDATE SET ...` in SQL.
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  ///
  /// [1]: https://www.sqlite.org/lang_upsert.html
  Upsert<Employee> update(
    UpdateSet<Employee> Function(
      Expr<Employee> employee,
      Expr<Employee> excluded,
      UpdateSet<Employee> Function({
        Expr<int> employeeId,
        Expr<String> name,
        Expr<int?> departmentId,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<Employee>(
    this,
    (employee, excluded) => updateBuilder(
      employee,
      excluded,
      ({Expr<int>? employeeId, Expr<String>? name, Expr<int?>? departmentId}) =>
          $ForGeneratedCode.buildUpdate<Employee>([
            employeeId,
            name,
            departmentId,
          ]),
    ),
  );
}

extension InsertSingleEmployeeExt on InsertSingle<Employee> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((employee, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflictSingle<Employee> onConflict(EmployeeConflict target) =>
      $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleEmployeeExt
    on InsertOnConflictSingle<Employee> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `employee` an [Expr] representing the existing row in
  ///     the database,
  ///   * `excluded` an [Expr] representing the row to be inserted in the
  ///     database, and,
  ///   * `set` a function to specify which fields should be updated and
  ///     build the [UpdateSet].
  ///
  /// The result of the `set` function should always be immediately
  /// returned from the [updateBuilder].
  ///
  /// **Example:** Insert a counter with `count = 2` or increment the
  /// existing row, if a `PRIMARY KEY` conflict occurs.
  /// ```dart
  /// await db.counters.insertValue(
  ///     name: 'my-counter', // primary key
  ///     count: 2,
  ///   )
  ///   .onConflict(.primaryKey)
  ///   .update((counter, excluded, set) => set(
  ///     count: counter.count + excluded.count,
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// This is equivalent to
  /// `INSERT ... ON CONFLICT (...) UPDATE SET ...` in SQL.
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  ///
  /// [1]: https://www.sqlite.org/lang_upsert.html
  UpsertSingle<Employee> update(
    UpdateSet<Employee> Function(
      Expr<Employee> employee,
      Expr<Employee> excluded,
      UpdateSet<Employee> Function({
        Expr<int> employeeId,
        Expr<String> name,
        Expr<int?> departmentId,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<Employee>(
    this,
    (employee, excluded) => updateBuilder(
      employee,
      excluded,
      ({Expr<int>? employeeId, Expr<String>? name, Expr<int?>? departmentId}) =>
          $ForGeneratedCode.buildUpdate<Employee>([
            employeeId,
            name,
            departmentId,
          ]),
    ),
  );
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
