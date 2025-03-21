// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_by_string_test.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

extension TestDatabaseSchema on DatabaseContext<TestDatabase> {
  static const _$tables = [_$Employee._$table];

  /// TODO: Propagate documentation for tables!
  Table<Employee> get employees => ExposedForCodeGen.declareTable(
        this,
        _$Employee._$table,
      );
  Future<void> createTables() async => ExposedForCodeGen.createTables(
        context: this,
        tables: _$tables,
      );
}

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

extension TableEmployeeExt on Table<Employee> {
  /// TODO: document insertLiteral (this cannot explicitly insert NULL for nullable fields with a default value)
  InsertSingle<Employee> insertLiteral({
    int? id,
    required String surname,
    required String seniority,
    int? salary,
  }) =>
      ExposedForCodeGen.insertInto(
        table: this,
        values: [
          id != null ? literal(id) : null,
          literal(surname),
          literal(seniority),
          salary != null ? literal(salary) : null,
        ],
      );

  /// TODO: document insert
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

  /// TODO: document delete
  DeleteSingle<Employee> delete({required int id}) =>
      ExposedForCodeGen.deleteSingle(
        byKey(id: id),
        _$Employee._$table,
      );
}

extension QueryEmployeeExt on Query<(Expr<Employee>,)> {
  /// TODO: document lookup by PrimaryKey
  QuerySingle<(Expr<Employee>,)> byKey({required int id}) =>
      where((employee) => employee.id.equalsLiteral(id)).first;

  /// TODO: document updateAll()
  Update<Employee> updateAll(
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

  /// TODO: document updateAllLiteral()
  /// WARNING: This cannot set properties to `null`!
  Update<Employee> updateAllLiteral({
    int? id,
    String? surname,
    String? seniority,
    int? salary,
  }) =>
      ExposedForCodeGen.update<Employee>(
        this,
        _$Employee._$table,
        (employee) => ExposedForCodeGen.buildUpdate<Employee>([
          id != null ? literal(id) : null,
          surname != null ? literal(surname) : null,
          seniority != null ? literal(seniority) : null,
          salary != null ? literal(salary) : null,
        ]),
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

  /// TODO: document updateLiteral()
  /// WARNING: This cannot set properties to `null`!
  UpdateSingle<Employee> updateLiteral({
    int? id,
    String? surname,
    String? seniority,
    int? salary,
  }) =>
      ExposedForCodeGen.updateSingle<Employee>(
        this,
        _$Employee._$table,
        (employee) => ExposedForCodeGen.buildUpdate<Employee>([
          id != null ? literal(id) : null,
          surname != null ? literal(surname) : null,
          seniority != null ? literal(seniority) : null,
          salary != null ? literal(salary) : null,
        ]),
      );

  /// TODO: document delete()
  DeleteSingle<Employee> delete() =>
      ExposedForCodeGen.deleteSingle(this, _$Employee._$table);
}

extension ExpressionEmployeeExt on Expr<Employee> {
  /// TODO: document id
  Expr<int> get id =>
      ExposedForCodeGen.field(this, 0, ExposedForCodeGen.integer);

  /// TODO: document surname
  Expr<String> get surname =>
      ExposedForCodeGen.field(this, 1, ExposedForCodeGen.text);

  /// TODO: document seniority
  Expr<String> get seniority =>
      ExposedForCodeGen.field(this, 2, ExposedForCodeGen.text);

  /// TODO: document salary
  Expr<int?> get salary =>
      ExposedForCodeGen.field(this, 3, ExposedForCodeGen.integer);
}

extension ExpressionNullableEmployeeExt on Expr<Employee?> {
  /// TODO: document id
  Expr<int?> get id =>
      ExposedForCodeGen.field(this, 0, ExposedForCodeGen.integer);

  /// TODO: document surname
  Expr<String?> get surname =>
      ExposedForCodeGen.field(this, 1, ExposedForCodeGen.text);

  /// TODO: document seniority
  Expr<String?> get seniority =>
      ExposedForCodeGen.field(this, 2, ExposedForCodeGen.text);

  /// TODO: document salary
  Expr<int?> get salary =>
      ExposedForCodeGen.field(this, 3, ExposedForCodeGen.integer);
}

extension EmployeeChecks on Subject<Employee> {
  Subject<int> get id => has((m) => m.id, 'id');
  Subject<String> get surname => has((m) => m.surname, 'surname');
  Subject<String> get seniority => has((m) => m.seniority, 'seniority');
  Subject<int?> get salary => has((m) => m.salary, 'salary');
}
