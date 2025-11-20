// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dealership_test.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

/// Extension methods for a [Database] operating on [Dealership].
extension DealershipSchema on Database<Dealership> {
  static const _$tables = [_$Car._$table];

  Table<Car> get cars => $ForGeneratedCode.declareTable(
        this,
        _$Car._$table,
      );

  /// Create tables defined in [Dealership].
  ///
  /// Calling this on an empty database will create the tables
  /// defined in [Dealership]. In production it's often better to
  /// use [createDealershipTables] and manage migrations using
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

/// Get SQL [DDL statements][1] for tables defined in [Dealership].
///
/// This returns a SQL script with multiple DDL statements separated by `;`
/// using the specified [dialect].
///
/// Executing these statements in an empty database will create the tables
/// defined in [Dealership]. In practice, this method is often used for
/// printing the DDL statements, such that migrations can be managed by
/// external tools.
///
/// [1]: https://en.wikipedia.org/wiki/Data_definition_language
String createDealershipTables(SqlDialect dialect) =>
    $ForGeneratedCode.createTableSchema(
      dialect: dialect,
      tables: DealershipSchema._$tables,
    );

final class _$Car extends Car {
  _$Car._(
    this.id,
    this.model,
    this.licensePlate,
    this.color,
  );

  @override
  final int id;

  @override
  final String model;

  @override
  final String licensePlate;

  @override
  final Color color;

  static const _$table = (
    tableName: 'cars',
    columns: <String>['id', 'model', 'licensePlate', 'color'],
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
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: <SqlOverride>[
          SqlOverride(dialect: 'mysql', columnType: 'VARCHAR(255)')
        ],
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
    unique: <List<String>>[
      ['licensePlate']
    ],
    foreignKeys: <({
      String name,
      List<String> columns,
      String referencedTable,
      List<String> referencedColumns,
    })>[],
    readRow: _$Car._$fromDatabase,
  );

  static Car? _$fromDatabase(RowReader row) {
    final id = row.readInt();
    final model = row.readString();
    final licensePlate = row.readString();
    final color = $ForGeneratedCode.customDataTypeOrNull(
      row.readInt(),
      Color.fromDatabase,
    );
    if (id == null && model == null && licensePlate == null && color == null) {
      return null;
    }
    return _$Car._(id!, model!, licensePlate!, color!);
  }

  @override
  String toString() =>
      'Car(id: "$id", model: "$model", licensePlate: "$licensePlate", color: "$color")';
}

/// Extension methods for table defined in [Car].
extension TableCarExt on Table<Car> {
  /// Insert row into the `cars` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<Car> insert({
    Expr<int>? id,
    required Expr<String> model,
    required Expr<String> licensePlate,
    required Expr<Color> color,
  }) =>
      $ForGeneratedCode.insertInto(
        table: this,
        values: [
          id,
          model,
          licensePlate,
          color,
        ],
      );

  /// Delete a single row from the `cars` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<Car> delete(int id) => $ForGeneratedCode.deleteSingle(
        byKey(id),
        _$Car._$table,
      );
}

/// Extension methods for building queries against the `cars` table.
extension QueryCarExt on Query<(Expr<Car>,)> {
  /// Lookup a single row in `cars` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<Car>,)> byKey(int id) =>
      where((car) => car.id.equalsValue(id)).first;

  /// Update all rows in the `cars` table matching this [Query].
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
  Update<Car> update(
          UpdateSet<Car> Function(
            Expr<Car> car,
            UpdateSet<Car> Function({
              Expr<int> id,
              Expr<String> model,
              Expr<String> licensePlate,
              Expr<Color> color,
            }) set,
          ) updateBuilder) =>
      $ForGeneratedCode.update<Car>(
        this,
        _$Car._$table,
        (car) => updateBuilder(
          car,
          ({
            Expr<int>? id,
            Expr<String>? model,
            Expr<String>? licensePlate,
            Expr<Color>? color,
          }) =>
              $ForGeneratedCode.buildUpdate<Car>([
            id,
            model,
            licensePlate,
            color,
          ]),
        ),
      );

  /// Lookup a single row in `cars` table using the
  /// `licensePlate` field.
  ///
  /// We know that lookup by the `licensePlate` field returns
  /// at-most one row because the `licensePlate` has an [Unique]
  /// annotation in [Car].
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<Car>,)> byLicensePlate(String licensePlate) =>
      where((car) => car.licensePlate.equalsValue(licensePlate)).first;

  /// Delete all rows in the `cars` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<Car> delete() => $ForGeneratedCode.delete(this, _$Car._$table);
}

/// Extension methods for building point queries against the `cars` table.
extension QuerySingleCarExt on QuerySingle<(Expr<Car>,)> {
  /// Update the row (if any) in the `cars` table matching this
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
  UpdateSingle<Car> update(
          UpdateSet<Car> Function(
            Expr<Car> car,
            UpdateSet<Car> Function({
              Expr<int> id,
              Expr<String> model,
              Expr<String> licensePlate,
              Expr<Color> color,
            }) set,
          ) updateBuilder) =>
      $ForGeneratedCode.updateSingle<Car>(
        this,
        _$Car._$table,
        (car) => updateBuilder(
          car,
          ({
            Expr<int>? id,
            Expr<String>? model,
            Expr<String>? licensePlate,
            Expr<Color>? color,
          }) =>
              $ForGeneratedCode.buildUpdate<Car>([
            id,
            model,
            licensePlate,
            color,
          ]),
        ),
      );

  /// Delete the row (if any) in the `cars` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<Car> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$Car._$table);
}

/// Extension methods for expressions on a row in the `cars` table.
extension ExpressionCarExt on Expr<Car> {
  Expr<int> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String> get model =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<String> get licensePlate =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  Expr<Color> get color => $ForGeneratedCode.field(this, 3, ColorExt._exprType);
}

extension ExpressionNullableCarExt on Expr<Car?> {
  Expr<int?> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String?> get model =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<String?> get licensePlate =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  Expr<Color?> get color =>
      $ForGeneratedCode.field(this, 3, ColorExt._exprType);

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

/// Wrap this [Color] as [Expr<Color>] for use queries with
/// `package:typed_sql`.
extension ColorExt on Color {
  static final _exprType = $ForGeneratedCode.customDataType(
    $ForGeneratedCode.integer,
    Color.fromDatabase,
  );

  /// Wrap this [Color] as [Expr<Color>] for use queries with
  /// `package:typed_sql`.
  Expr<Color> get asExpr => $ForGeneratedCode
      .literalCustomDataType(
        this,
        _exprType,
      )
      .asNotNull();
}

/// Wrap this [Color] as [Expr<Color>] for use queries with
/// `package:typed_sql`.
extension ColorNullableExt on Color? {
  /// Wrap this [Color] as [Expr<Color?>] for use queries with
  /// `package:typed_sql`.
  Expr<Color?> get asExpr => $ForGeneratedCode.literalCustomDataType(
        this,
        ColorExt._exprType,
      );
}

/// Extension methods for assertions on [Car] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension CarChecks on Subject<Car> {
  /// Create assertions on [Car.id].
  Subject<int> get id => has((m) => m.id, 'id');

  /// Create assertions on [Car.model].
  Subject<String> get model => has((m) => m.model, 'model');

  /// Create assertions on [Car.licensePlate].
  Subject<String> get licensePlate =>
      has((m) => m.licensePlate, 'licensePlate');

  /// Create assertions on [Car.color].
  Subject<Color> get color => has((m) => m.color, 'color');
}
