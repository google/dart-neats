// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paged_by_order_class_test.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

/// Extension methods for a [Database] operating on [TestDatabase].
extension TestDatabaseSchema on Database<TestDatabase> {
  static final _$tables = [_$Order._$table, _$Stream._$table];

  Table<Order> get orders =>
      $ForGeneratedCode.declareTable(this, _$Order._$table);

  Table<Stream> get streams =>
      $ForGeneratedCode.declareTable(this, _$Stream._$table);

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
  Future<void> createTables() async =>
      $ForGeneratedCode.createTables(context: this, tables: _$tables);
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
String createTestDatabaseTables(SqlDialect dialect) => $ForGeneratedCode
    .createTableSchema(dialect: dialect, tables: TestDatabaseSchema._$tables);

final class _$Order extends Order {
  _$Order._(this.orderId, this.quantity);

  @override
  final int orderId;

  @override
  final int quantity;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'orders',
    columns: <String>['orderId', 'quantity'],
    columnInfo: [
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.integer,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.integer,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
    ],
    primaryKey: <String>['orderId'],
    unique: <List<String>>[],
    foreignKeys: [],
    indexes: [],
    readRow: _$Order._$fromDatabase,
    fieldReaders: [(Order r) => r.orderId, (Order r) => r.quantity],
  );

  static Order? _$fromDatabase(RowReader row) {
    final orderId = row.readInt();
    final quantity = row.readInt();
    if (orderId == null && quantity == null) {
      return null;
    }
    return _$Order._(orderId!, quantity!);
  }

  @override
  String toString() => 'Order(orderId: "$orderId", quantity: "$quantity")';
}

/// Extension methods for table defined in [Order].
extension TableOrderExt on Table<Order> {
  /// Insert row into the `orders` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<Order> insert({
    required Expr<int> orderId,
    required Expr<int> quantity,
  }) => $ForGeneratedCode.insertInto(table: this, values: [orderId, quantity]);

  /// Insert row into the `orders` table, or update the
  /// existing row if it conflicts with the _primary key_.
  ///
  /// This is a shorthand for calling `.insert(...)` followed by
  /// `.onConflict(.primaryKey)` and `.update(...)` to overwrite
  /// the fields `quantity`,
  /// with the values given, leaving the _primary key_ untouched.
  ///
  /// Returns an [UpsertSingle] statement on which `.execute()` must be
  /// called for the row to be inserted or updated.
  UpsertSingle<Order> upsert({
    required Expr<int> orderId,
    required Expr<int> quantity,
  }) => insert(orderId: orderId, quantity: quantity)
      .onConflict(.primaryKey)
      .update((_, excluded, set) => set(quantity: excluded.quantity));

  /// Insert row into the `orders` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<Order> insertValue({
    required int orderId,
    required int quantity,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [orderId.asExpr, quantity.asExpr],
  );

  /// Insert row into the `orders` table, or update the
  /// existing row if it conflicts with the _primary key_.
  ///
  /// This is a shorthand for calling `.insertValue(...)` followed by
  /// `.onConflict(.primaryKey)` and `.update(...)` to overwrite
  /// the fields `quantity`,
  /// with the values given, leaving the _primary key_ untouched.
  ///
  /// Returns an [UpsertSingle] statement on which `.execute()` must be
  /// called for the row to be inserted or updated.
  UpsertSingle<Order> upsertValue({
    required int orderId,
    required int quantity,
  }) => insertValue(orderId: orderId, quantity: quantity)
      .onConflict(.primaryKey)
      .update((_, excluded, set) => set(quantity: excluded.quantity));

  /// Bulk insert rows into the `orders` table.
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
  Insert<Order> insertValuesMapped<T>(
    Iterable<T> rows, {
    required int Function(T row) orderId,
    required int Function(T row) quantity,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mappings: [orderId, quantity],
  );

  /// Delete a single row from the `orders` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<Order> delete(int orderId) =>
      $ForGeneratedCode.deleteSingle(byKey(orderId), _$Order._$table);
}

/// Extension methods for building queries against the `orders` table.
extension QueryOrderExt on Query<(Expr<Order>,)> {
  /// Lookup a single row in `orders` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<Order>,)> byKey(int orderId) =>
      where((order) => order.orderId.equalsValue(orderId)).first;

  /// Update all rows in the `orders` table matching this [Query].
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
  Update<Order> update(
    UpdateSet<Order> Function(
      Expr<Order> order,
      UpdateSet<Order> Function({Expr<int> orderId, Expr<int> quantity}) set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<Order>(
    this,
    _$Order._$table,
    (order) => updateBuilder(
      order,
      ({Expr<int>? orderId, Expr<int>? quantity}) =>
          $ForGeneratedCode.buildUpdate<Order>([orderId, quantity]),
    ),
  );

  /// Query the database for rows in this [Query] in pages of [pageSize]
  /// rows, ordered by the _primary key_, using _keyset pagination_.
  ///
  /// This is a shorthand for `.pagedBy(...)`, where each page is fetched by
  /// a separate query. If [startFrom] is given, only rows after [startFrom]
  /// in the given [order] are returned.
  ///
  /// > [!WARNING]
  /// > Rows in this [Query] must be unique, otherwise rows may be skipped.
  /// > Avoid using this on a `.join` projected to a single row or on a
  /// > `.unionAll`. Never use this after `.limit` or `.offset`, instead
  /// > use `.take` on the returned [Stream].
  $Stream<Order> pagedByKey({
    $Order order = $Order.ascending,
    int pageSize = 100,
    Order? startFrom,
  }) => pagedBy(
    (row) => [(row.orderId, order)],
    pageSize: pageSize,
    startFrom: startFrom,
  );

  /// Delete all rows in the `orders` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<Order> delete() => $ForGeneratedCode.delete(this, _$Order._$table);
}

/// Extension methods for building point queries against the `orders` table.
extension QuerySingleOrderExt on QuerySingle<(Expr<Order>,)> {
  /// Update the row (if any) in the `orders` table matching this
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
  UpdateSingle<Order> update(
    UpdateSet<Order> Function(
      Expr<Order> order,
      UpdateSet<Order> Function({Expr<int> orderId, Expr<int> quantity}) set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<Order>(
    this,
    _$Order._$table,
    (order) => updateBuilder(
      order,
      ({Expr<int>? orderId, Expr<int>? quantity}) =>
          $ForGeneratedCode.buildUpdate<Order>([orderId, quantity]),
    ),
  );

  /// Delete the row (if any) in the `orders` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<Order> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$Order._$table);
}

/// Extension methods for expressions on a row in the `orders` table.
extension ExpressionOrderExt on Expr<Order> {
  Expr<int> get orderId =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<int> get quantity =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.integer);
}

extension ExpressionNullableOrderExt on Expr<Order?> {
  Expr<int?> get orderId =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<int?> get quantity =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.integer);

  /// Check if the row is not `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNotNull() => orderId.isNotNull();

  /// Check if the row is `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNull() => isNotNull().not();
}

/// `Table<Order>` conflict targets for use with `.onConflict`.
enum OrderConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `orderId`.
  primaryKey(['orderId']);

  const OrderConflict(this._fields);

  final List<String> _fields;
}

extension InsertOrderExt on Insert<Order> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((order, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflict<Order> onConflict(OrderConflict target) =>
      $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictOrderExt on InsertOnConflict<Order> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `order` an [Expr] representing the existing row in
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
  Upsert<Order> update(
    UpdateSet<Order> Function(
      Expr<Order> order,
      Expr<Order> excluded,
      UpdateSet<Order> Function({Expr<int> orderId, Expr<int> quantity}) set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<Order>(
    this,
    (order, excluded) => updateBuilder(
      order,
      excluded,
      ({Expr<int>? orderId, Expr<int>? quantity}) =>
          $ForGeneratedCode.buildUpdate<Order>([orderId, quantity]),
    ),
  );
}

extension InsertSingleOrderExt on InsertSingle<Order> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((order, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflictSingle<Order> onConflict(OrderConflict target) =>
      $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleOrderExt on InsertOnConflictSingle<Order> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `order` an [Expr] representing the existing row in
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
  UpsertSingle<Order> update(
    UpdateSet<Order> Function(
      Expr<Order> order,
      Expr<Order> excluded,
      UpdateSet<Order> Function({Expr<int> orderId, Expr<int> quantity}) set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<Order>(
    this,
    (order, excluded) => updateBuilder(
      order,
      excluded,
      ({Expr<int>? orderId, Expr<int>? quantity}) =>
          $ForGeneratedCode.buildUpdate<Order>([orderId, quantity]),
    ),
  );
}

final class _$Stream extends Stream {
  _$Stream._(this.streamId, this.viewers);

  @override
  final int streamId;

  @override
  final int viewers;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'streams',
    columns: <String>['streamId', 'viewers'],
    columnInfo: [
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.integer,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.integer,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
    ],
    primaryKey: <String>['streamId'],
    unique: <List<String>>[],
    foreignKeys: [],
    indexes: [],
    readRow: _$Stream._$fromDatabase,
    fieldReaders: [(Stream r) => r.streamId, (Stream r) => r.viewers],
  );

  static Stream? _$fromDatabase(RowReader row) {
    final streamId = row.readInt();
    final viewers = row.readInt();
    if (streamId == null && viewers == null) {
      return null;
    }
    return _$Stream._(streamId!, viewers!);
  }

  @override
  String toString() => 'Stream(streamId: "$streamId", viewers: "$viewers")';
}

/// Extension methods for table defined in [Stream].
extension TableStreamExt on Table<Stream> {
  /// Insert row into the `streams` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<Stream> insert({
    required Expr<int> streamId,
    required Expr<int> viewers,
  }) => $ForGeneratedCode.insertInto(table: this, values: [streamId, viewers]);

  /// Insert row into the `streams` table, or update the
  /// existing row if it conflicts with the _primary key_.
  ///
  /// This is a shorthand for calling `.insert(...)` followed by
  /// `.onConflict(.primaryKey)` and `.update(...)` to overwrite
  /// the fields `viewers`,
  /// with the values given, leaving the _primary key_ untouched.
  ///
  /// Returns an [UpsertSingle] statement on which `.execute()` must be
  /// called for the row to be inserted or updated.
  UpsertSingle<Stream> upsert({
    required Expr<int> streamId,
    required Expr<int> viewers,
  }) => insert(streamId: streamId, viewers: viewers)
      .onConflict(.primaryKey)
      .update((_, excluded, set) => set(viewers: excluded.viewers));

  /// Insert row into the `streams` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<Stream> insertValue({
    required int streamId,
    required int viewers,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [streamId.asExpr, viewers.asExpr],
  );

  /// Insert row into the `streams` table, or update the
  /// existing row if it conflicts with the _primary key_.
  ///
  /// This is a shorthand for calling `.insertValue(...)` followed by
  /// `.onConflict(.primaryKey)` and `.update(...)` to overwrite
  /// the fields `viewers`,
  /// with the values given, leaving the _primary key_ untouched.
  ///
  /// Returns an [UpsertSingle] statement on which `.execute()` must be
  /// called for the row to be inserted or updated.
  UpsertSingle<Stream> upsertValue({
    required int streamId,
    required int viewers,
  }) => insertValue(streamId: streamId, viewers: viewers)
      .onConflict(.primaryKey)
      .update((_, excluded, set) => set(viewers: excluded.viewers));

  /// Bulk insert rows into the `streams` table.
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
  Insert<Stream> insertValuesMapped<T>(
    Iterable<T> rows, {
    required int Function(T row) streamId,
    required int Function(T row) viewers,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mappings: [streamId, viewers],
  );

  /// Delete a single row from the `streams` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<Stream> delete(int streamId) =>
      $ForGeneratedCode.deleteSingle(byKey(streamId), _$Stream._$table);
}

/// Extension methods for building queries against the `streams` table.
extension QueryStreamExt on Query<(Expr<Stream>,)> {
  /// Lookup a single row in `streams` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<Stream>,)> byKey(int streamId) =>
      where((stream) => stream.streamId.equalsValue(streamId)).first;

  /// Update all rows in the `streams` table matching this [Query].
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
  Update<Stream> update(
    UpdateSet<Stream> Function(
      Expr<Stream> stream,
      UpdateSet<Stream> Function({Expr<int> streamId, Expr<int> viewers}) set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<Stream>(
    this,
    _$Stream._$table,
    (stream) => updateBuilder(
      stream,
      ({Expr<int>? streamId, Expr<int>? viewers}) =>
          $ForGeneratedCode.buildUpdate<Stream>([streamId, viewers]),
    ),
  );

  /// Query the database for rows in this [Query] in pages of [pageSize]
  /// rows, ordered by the _primary key_, using _keyset pagination_.
  ///
  /// This is a shorthand for `.pagedBy(...)`, where each page is fetched by
  /// a separate query. If [startFrom] is given, only rows after [startFrom]
  /// in the given [order] are returned.
  ///
  /// > [!WARNING]
  /// > Rows in this [Query] must be unique, otherwise rows may be skipped.
  /// > Avoid using this on a `.join` projected to a single row or on a
  /// > `.unionAll`. Never use this after `.limit` or `.offset`, instead
  /// > use `.take` on the returned [Stream].
  $Stream<Stream> pagedByKey({
    $Order order = $Order.ascending,
    int pageSize = 100,
    Stream? startFrom,
  }) => pagedBy(
    (row) => [(row.streamId, order)],
    pageSize: pageSize,
    startFrom: startFrom,
  );

  /// Delete all rows in the `streams` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<Stream> delete() => $ForGeneratedCode.delete(this, _$Stream._$table);
}

/// Extension methods for building point queries against the `streams` table.
extension QuerySingleStreamExt on QuerySingle<(Expr<Stream>,)> {
  /// Update the row (if any) in the `streams` table matching this
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
  UpdateSingle<Stream> update(
    UpdateSet<Stream> Function(
      Expr<Stream> stream,
      UpdateSet<Stream> Function({Expr<int> streamId, Expr<int> viewers}) set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<Stream>(
    this,
    _$Stream._$table,
    (stream) => updateBuilder(
      stream,
      ({Expr<int>? streamId, Expr<int>? viewers}) =>
          $ForGeneratedCode.buildUpdate<Stream>([streamId, viewers]),
    ),
  );

  /// Delete the row (if any) in the `streams` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<Stream> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$Stream._$table);
}

/// Extension methods for expressions on a row in the `streams` table.
extension ExpressionStreamExt on Expr<Stream> {
  Expr<int> get streamId =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<int> get viewers =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.integer);
}

extension ExpressionNullableStreamExt on Expr<Stream?> {
  Expr<int?> get streamId =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<int?> get viewers =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.integer);

  /// Check if the row is not `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNotNull() => streamId.isNotNull();

  /// Check if the row is `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNull() => isNotNull().not();
}

/// `Table<Stream>` conflict targets for use with `.onConflict`.
enum StreamConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `streamId`.
  primaryKey(['streamId']);

  const StreamConflict(this._fields);

  final List<String> _fields;
}

extension InsertStreamExt on Insert<Stream> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((stream, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflict<Stream> onConflict(StreamConflict target) =>
      $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictStreamExt on InsertOnConflict<Stream> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `stream` an [Expr] representing the existing row in
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
  Upsert<Stream> update(
    UpdateSet<Stream> Function(
      Expr<Stream> stream,
      Expr<Stream> excluded,
      UpdateSet<Stream> Function({Expr<int> streamId, Expr<int> viewers}) set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<Stream>(
    this,
    (stream, excluded) => updateBuilder(
      stream,
      excluded,
      ({Expr<int>? streamId, Expr<int>? viewers}) =>
          $ForGeneratedCode.buildUpdate<Stream>([streamId, viewers]),
    ),
  );
}

extension InsertSingleStreamExt on InsertSingle<Stream> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((stream, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflictSingle<Stream> onConflict(StreamConflict target) =>
      $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleStreamExt on InsertOnConflictSingle<Stream> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `stream` an [Expr] representing the existing row in
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
  UpsertSingle<Stream> update(
    UpdateSet<Stream> Function(
      Expr<Stream> stream,
      Expr<Stream> excluded,
      UpdateSet<Stream> Function({Expr<int> streamId, Expr<int> viewers}) set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<Stream>(
    this,
    (stream, excluded) => updateBuilder(
      stream,
      excluded,
      ({Expr<int>? streamId, Expr<int>? viewers}) =>
          $ForGeneratedCode.buildUpdate<Stream>([streamId, viewers]),
    ),
  );
}

/// Extension methods for assertions on [Order] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension OrderChecks on Subject<Order> {
  /// Create assertions on [Order.orderId].
  Subject<int> get orderId => has((m) => m.orderId, 'orderId');

  /// Create assertions on [Order.quantity].
  Subject<int> get quantity => has((m) => m.quantity, 'quantity');
}

/// Extension methods for assertions on [Stream] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension StreamChecks on Subject<Stream> {
  /// Create assertions on [Stream.streamId].
  Subject<int> get streamId => has((m) => m.streamId, 'streamId');

  /// Create assertions on [Stream.viewers].
  Subject<int> get viewers => has((m) => m.viewers, 'viewers');
}
