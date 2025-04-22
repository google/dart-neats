// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_by_null_test.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

/// Extension methods for a [Database] operating on [TestDatabase].
extension TestDatabaseSchema on Database<TestDatabase> {
  static const _$tables = [_$Employee._$table];

  Table<Employee> get employees => ExposedForCodeGen.declareTable(
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
  Future<void> createTables() async => ExposedForCodeGen.createTables(
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
    ExposedForCodeGen.createTableSchema(
      dialect: dialect,
      tables: TestDatabaseSchema._$tables,
    );

final class _$Employee extends Employee {
  _$Employee._(
    this.id,
    this.surname,
    this.seniority,
    this.salary,
  );

  @override
  final int id;

  @override
  final String surname;

  @override
  final String seniority;

  @override
  final int? salary;

  static const _$table = (
    tableName: 'employees',
    columns: <String>['id', 'surname', 'seniority', 'salary'],
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
      ),
      (
        type: ExposedForCodeGen.integer,
        isNotNull: false,
        defaultValue: null,
        autoIncrement: false,
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
    readModel: _$Employee._$fromDatabase,
  );

  static Employee? _$fromDatabase(RowReader row) {
    final id = row.readInt();
    final surname = row.readString();
    final seniority = row.readString();
    final salary = row.readInt();
    if (id == null && surname == null && seniority == null && salary == null) {
      return null;
    }
    return _$Employee._(id!, surname!, seniority!, salary);
  }

  @override
  String toString() =>
      'Employee(id: "$id", surname: "$surname", seniority: "$seniority", salary: "$salary")';
}

/// Extension methods for table defined in [Employee].
extension TableEmployeeExt on Table<Employee> {
  /// Insert row into the `employees` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<Employee> insert({
    Expr<int>? id,
    required Expr<String> surname,
    required Expr<String> seniority,
    Expr<int?>? salary,
  }) =>
      ExposedForCodeGen.insertInto(
        table: this,
        values: [
          id,
          surname,
          seniority,
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
  DeleteSingle<Employee> delete(int id) => ExposedForCodeGen.deleteSingle(
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
              Expr<String> surname,
              Expr<String> seniority,
              Expr<int?> salary,
            }) set,
          ) updateBuilder) =>
      ExposedForCodeGen.update<Employee>(
        this,
        _$Employee._$table,
        (employee) => updateBuilder(
          employee,
          ({
            Expr<int>? id,
            Expr<String>? surname,
            Expr<String>? seniority,
            Expr<int?>? salary,
          }) =>
              ExposedForCodeGen.buildUpdate<Employee>([
            id,
            surname,
            seniority,
            salary,
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
              Expr<int> id,
              Expr<String> surname,
              Expr<String> seniority,
              Expr<int?> salary,
            }) set,
          ) updateBuilder) =>
      ExposedForCodeGen.updateSingle<Employee>(
        this,
        _$Employee._$table,
        (employee) => updateBuilder(
          employee,
          ({
            Expr<int>? id,
            Expr<String>? surname,
            Expr<String>? seniority,
            Expr<int?>? salary,
          }) =>
              ExposedForCodeGen.buildUpdate<Employee>([
            id,
            surname,
            seniority,
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
      ExposedForCodeGen.deleteSingle(this, _$Employee._$table);
}

/// Extension methods for expressions on a row in the `employees` table.
extension ExpressionEmployeeExt on Expr<Employee> {
  Expr<int> get id =>
      ExposedForCodeGen.field(this, 0, ExposedForCodeGen.integer);

  Expr<String> get surname =>
      ExposedForCodeGen.field(this, 1, ExposedForCodeGen.text);

  Expr<String> get seniority =>
      ExposedForCodeGen.field(this, 2, ExposedForCodeGen.text);

  Expr<int?> get salary =>
      ExposedForCodeGen.field(this, 3, ExposedForCodeGen.integer);
}

extension ExpressionNullableEmployeeExt on Expr<Employee?> {
  Expr<int?> get id =>
      ExposedForCodeGen.field(this, 0, ExposedForCodeGen.integer);

  Expr<String?> get surname =>
      ExposedForCodeGen.field(this, 1, ExposedForCodeGen.text);

  Expr<String?> get seniority =>
      ExposedForCodeGen.field(this, 2, ExposedForCodeGen.text);

  Expr<int?> get salary =>
      ExposedForCodeGen.field(this, 3, ExposedForCodeGen.integer);

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

/// Extension methods for assertions on [Employee] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension EmployeeChecks on Subject<Employee> {
  /// Create assertions on [Employee.id].
  Subject<int> get id => has((m) => m.id, 'id');

  /// Create assertions on [Employee.surname].
  Subject<String> get surname => has((m) => m.surname, 'surname');

  /// Create assertions on [Employee.seniority].
  Subject<String> get seniority => has((m) => m.seniority, 'seniority');

  /// Create assertions on [Employee.salary].
  Subject<int?> get salary => has((m) => m.salary, 'salary');
}
