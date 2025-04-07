// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'join_model_test.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

extension CompanyDatabaseSchema on Database<CompanyDatabase> {
  static const _$tables = [_$Employee._$table, _$Department._$table];

  /// TODO: Propagate documentation for tables!
  Table<Employee> get employees => ExposedForCodeGen.declareTable(
        this,
        _$Employee._$table,
      );

  /// TODO: Propagate documentation for tables!
  Table<Department> get departments => ExposedForCodeGen.declareTable(
        this,
        _$Department._$table,
      );
  Future<void> createTables() async => ExposedForCodeGen.createTables(
        context: this,
        tables: _$tables,
      );
}

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
    })>[],
    readModel: _$Employee._$fromDatabase,
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

extension TableEmployeeExt on Table<Employee> {
  /// TODO: document insert
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

  /// TODO: document delete
  DeleteSingle<Employee> delete(int employeeId) =>
      ExposedForCodeGen.deleteSingle(
        byKey(employeeId),
        _$Employee._$table,
      );
}

extension QueryEmployeeExt on Query<(Expr<Employee>,)> {
  /// TODO: document lookup by PrimaryKey
  QuerySingle<(Expr<Employee>,)> byKey(int employeeId) =>
      where((employee) => employee.employeeId.equalsLiteral(employeeId)).first;

  /// TODO: document update()
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

  /// TODO: document delete()}
  Delete<Employee> delete() =>
      ExposedForCodeGen.delete(this, _$Employee._$table);
}

extension QuerySingleEmployeeExt on QuerySingle<(Expr<Employee>,)> {
  /// TODO: document update()
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

  /// TODO: document delete()
  DeleteSingle<Employee> delete() =>
      ExposedForCodeGen.deleteSingle(this, _$Employee._$table);
}

extension ExpressionEmployeeExt on Expr<Employee> {
  /// TODO: document employeeId
  Expr<int> get employeeId =>
      ExposedForCodeGen.field(this, 0, ExposedForCodeGen.integer);

  /// TODO: document name
  Expr<String> get name =>
      ExposedForCodeGen.field(this, 1, ExposedForCodeGen.text);

  /// TODO: document departmentId
  Expr<int?> get departmentId =>
      ExposedForCodeGen.field(this, 2, ExposedForCodeGen.integer);
}

extension ExpressionNullableEmployeeExt on Expr<Employee?> {
  /// TODO: document employeeId
  Expr<int?> get employeeId =>
      ExposedForCodeGen.field(this, 0, ExposedForCodeGen.integer);

  /// TODO: document name
  Expr<String?> get name =>
      ExposedForCodeGen.field(this, 1, ExposedForCodeGen.text);

  /// TODO: document departmentId
  Expr<int?> get departmentId =>
      ExposedForCodeGen.field(this, 2, ExposedForCodeGen.integer);

  /// TODO: Document isNotNull
  Expr<bool> isNotNull() => employeeId.isNotNull();

  /// TODO: Document isNull
  Expr<bool> isNull() => isNotNull().not();
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
    readModel: _$Department._$fromDatabase,
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

extension TableDepartmentExt on Table<Department> {
  /// TODO: document insert
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

  /// TODO: document delete
  DeleteSingle<Department> delete(int departmentId) =>
      ExposedForCodeGen.deleteSingle(
        byKey(departmentId),
        _$Department._$table,
      );
}

extension QueryDepartmentExt on Query<(Expr<Department>,)> {
  /// TODO: document lookup by PrimaryKey
  QuerySingle<(Expr<Department>,)> byKey(int departmentId) =>
      where((department) => department.departmentId.equalsLiteral(departmentId))
          .first;

  /// TODO: document update()
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

  /// TODO: document delete()}
  Delete<Department> delete() =>
      ExposedForCodeGen.delete(this, _$Department._$table);
}

extension QuerySingleDepartmentExt on QuerySingle<(Expr<Department>,)> {
  /// TODO: document update()
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

  /// TODO: document delete()
  DeleteSingle<Department> delete() =>
      ExposedForCodeGen.deleteSingle(this, _$Department._$table);
}

extension ExpressionDepartmentExt on Expr<Department> {
  /// TODO: document departmentId
  Expr<int> get departmentId =>
      ExposedForCodeGen.field(this, 0, ExposedForCodeGen.integer);

  /// TODO: document name
  Expr<String> get name =>
      ExposedForCodeGen.field(this, 1, ExposedForCodeGen.text);

  /// TODO: document location
  Expr<String> get location =>
      ExposedForCodeGen.field(this, 2, ExposedForCodeGen.text);
}

extension ExpressionNullableDepartmentExt on Expr<Department?> {
  /// TODO: document departmentId
  Expr<int?> get departmentId =>
      ExposedForCodeGen.field(this, 0, ExposedForCodeGen.integer);

  /// TODO: document name
  Expr<String?> get name =>
      ExposedForCodeGen.field(this, 1, ExposedForCodeGen.text);

  /// TODO: document location
  Expr<String?> get location =>
      ExposedForCodeGen.field(this, 2, ExposedForCodeGen.text);

  /// TODO: Document isNotNull
  Expr<bool> isNotNull() => departmentId.isNotNull();

  /// TODO: Document isNull
  Expr<bool> isNull() => isNotNull().not();
}

extension DepartmentChecks on Subject<Department> {
  Subject<int> get departmentId => has((m) => m.departmentId, 'departmentId');
  Subject<String> get name => has((m) => m.name, 'name');
  Subject<String> get location => has((m) => m.location, 'location');
}

extension EmployeeChecks on Subject<Employee> {
  Subject<int> get employeeId => has((m) => m.employeeId, 'employeeId');
  Subject<String> get name => has((m) => m.name, 'name');
  Subject<int?> get departmentId => has((m) => m.departmentId, 'departmentId');
}
