// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brin_index_test.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

/// Extension methods for a [Database] operating on [EventLog].
extension EventLogSchema on Database<EventLog> {
  static final _$tables = [_$Event._$table];

  Table<Event> get events =>
      $ForGeneratedCode.declareTable(this, _$Event._$table);

  /// Create tables defined in [EventLog].
  ///
  /// Calling this on an empty database will create the tables
  /// defined in [EventLog]. In production it's often better to
  /// use [createEventLogTables] and manage migrations using
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

/// Get SQL [DDL statements][1] for tables defined in [EventLog].
///
/// This returns a SQL script with multiple DDL statements separated by `;`
/// using the specified [dialect].
///
/// Executing these statements in an empty database will create the tables
/// defined in [EventLog]. In practice, this method is often used for
/// printing the DDL statements, such that migrations can be managed by
/// external tools.
///
/// [1]: https://en.wikipedia.org/wiki/Data_definition_language
String createEventLogTables(SqlDialect dialect) => $ForGeneratedCode
    .createTableSchema(dialect: dialect, tables: EventLogSchema._$tables);

final class _$Event extends Event {
  _$Event._(this.id, this.createdAt);

  @override
  final int id;

  @override
  final DateTime createdAt;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'events',
    columns: <String>['id', 'createdAt'],
    columnInfo: [
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.integer,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: true,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.dateTime,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
    ],
    primaryKey: <String>['id'],
    unique: <List<String>>[],
    foreignKeys: [],
    indexes: [
      $ForGeneratedCode.indexDefinition(
        name: null,
        sqlName: null,
        columns: ['createdAt'],
        method: .brin,
        covering: [],
      ),
    ],
    readRow: _$Event._$fromDatabase,
  );

  static Event? _$fromDatabase(RowReader row) {
    final id = row.readInt();
    final createdAt = row.readDateTime();
    if (id == null && createdAt == null) {
      return null;
    }
    return _$Event._(id!, createdAt!);
  }

  @override
  String toString() => 'Event(id: "$id", createdAt: "$createdAt")';
}

/// Extension methods for table defined in [Event].
extension TableEventExt on Table<Event> {
  /// Insert row into the `events` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<Event> insert({
    Expr<int>? id,
    required Expr<DateTime> createdAt,
  }) => $ForGeneratedCode.insertInto(table: this, values: [id, createdAt]);

  /// Insert row into the `events` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<Event> insertValue({int? id, required DateTime createdAt}) =>
      $ForGeneratedCode.insertInto(
        table: this,
        values: [id?.asExpr, createdAt.asExpr],
      );

  /// Bulk insert rows into the `events` table.
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
  Insert<Event> insertValuesMapped<T>(
    Iterable<T> rows, {
    int Function(T row)? id,
    required DateTime Function(T row) createdAt,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mappings: [id, createdAt],
  );

  /// Delete a single row from the `events` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<Event> delete(int id) =>
      $ForGeneratedCode.deleteSingle(byKey(id), _$Event._$table);
}

/// Extension methods for building queries against the `events` table.
extension QueryEventExt on Query<(Expr<Event>,)> {
  /// Lookup a single row in `events` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<Event>,)> byKey(int id) =>
      where((event) => event.id.equalsValue(id)).first;

  /// Update all rows in the `events` table matching this [Query].
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
  Update<Event> update(
    UpdateSet<Event> Function(
      Expr<Event> event,
      UpdateSet<Event> Function({Expr<int> id, Expr<DateTime> createdAt}) set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<Event>(
    this,
    _$Event._$table,
    (event) => updateBuilder(
      event,
      ({Expr<int>? id, Expr<DateTime>? createdAt}) =>
          $ForGeneratedCode.buildUpdate<Event>([id, createdAt]),
    ),
  );

  /// Delete all rows in the `events` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<Event> delete() => $ForGeneratedCode.delete(this, _$Event._$table);
}

/// Extension methods for building point queries against the `events` table.
extension QuerySingleEventExt on QuerySingle<(Expr<Event>,)> {
  /// Update the row (if any) in the `events` table matching this
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
  UpdateSingle<Event> update(
    UpdateSet<Event> Function(
      Expr<Event> event,
      UpdateSet<Event> Function({Expr<int> id, Expr<DateTime> createdAt}) set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<Event>(
    this,
    _$Event._$table,
    (event) => updateBuilder(
      event,
      ({Expr<int>? id, Expr<DateTime>? createdAt}) =>
          $ForGeneratedCode.buildUpdate<Event>([id, createdAt]),
    ),
  );

  /// Delete the row (if any) in the `events` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<Event> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$Event._$table);
}

/// Extension methods for expressions on a row in the `events` table.
extension ExpressionEventExt on Expr<Event> {
  Expr<int> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<DateTime> get createdAt =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.dateTime);
}

extension ExpressionNullableEventExt on Expr<Event?> {
  Expr<int?> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<DateTime?> get createdAt =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.dateTime);

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

/// `Table<Event>` conflict targets for use with `.onConflict`.
enum EventConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `id`.
  primaryKey(['id']);

  const EventConflict(this._fields);

  final List<String> _fields;
}

extension InsertEventExt on Insert<Event> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((event, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflict<Event> onConflict(EventConflict target) =>
      $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictEventExt on InsertOnConflict<Event> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `event` an [Expr] representing the existing row in
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
  Upsert<Event> update(
    UpdateSet<Event> Function(
      Expr<Event> event,
      Expr<Event> excluded,
      UpdateSet<Event> Function({Expr<int> id, Expr<DateTime> createdAt}) set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<Event>(
    this,
    (event, excluded) => updateBuilder(
      event,
      excluded,
      ({Expr<int>? id, Expr<DateTime>? createdAt}) =>
          $ForGeneratedCode.buildUpdate<Event>([id, createdAt]),
    ),
  );
}

extension InsertSingleEventExt on InsertSingle<Event> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((event, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflictSingle<Event> onConflict(EventConflict target) =>
      $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleEventExt on InsertOnConflictSingle<Event> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `event` an [Expr] representing the existing row in
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
  UpsertSingle<Event> update(
    UpdateSet<Event> Function(
      Expr<Event> event,
      Expr<Event> excluded,
      UpdateSet<Event> Function({Expr<int> id, Expr<DateTime> createdAt}) set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<Event>(
    this,
    (event, excluded) => updateBuilder(
      event,
      excluded,
      ({Expr<int>? id, Expr<DateTime>? createdAt}) =>
          $ForGeneratedCode.buildUpdate<Event>([id, createdAt]),
    ),
  );
}

/// Extension methods for assertions on [Event] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension EventChecks on Subject<Event> {
  /// Create assertions on [Event.id].
  Subject<int> get id => has((m) => m.id, 'id');

  /// Create assertions on [Event.createdAt].
  Subject<DateTime> get createdAt => has((m) => m.createdAt, 'createdAt');
}
