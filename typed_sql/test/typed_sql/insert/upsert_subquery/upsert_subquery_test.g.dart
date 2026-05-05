// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upsert_subquery_test.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

/// Extension methods for a [Database] operating on [SubQueryDatabase].
extension SubQueryDatabaseSchema on Database<SubQueryDatabase> {
  static final _$tables = [_$SourceItem._$table, _$SubQueryItem._$table];

  Table<SourceItem> get sourceItems =>
      $ForGeneratedCode.declareTable(this, _$SourceItem._$table);

  Table<SubQueryItem> get subQueryItems =>
      $ForGeneratedCode.declareTable(this, _$SubQueryItem._$table);

  /// Create tables defined in [SubQueryDatabase].
  ///
  /// Calling this on an empty database will create the tables
  /// defined in [SubQueryDatabase]. In production it's often better to
  /// use [createSubQueryDatabaseTables] and manage migrations using
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

/// Get SQL [DDL statements][1] for tables defined in [SubQueryDatabase].
///
/// This returns a SQL script with multiple DDL statements separated by `;`
/// using the specified [dialect].
///
/// Executing these statements in an empty database will create the tables
/// defined in [SubQueryDatabase]. In practice, this method is often used for
/// printing the DDL statements, such that migrations can be managed by
/// external tools.
///
/// [1]: https://en.wikipedia.org/wiki/Data_definition_language
String createSubQueryDatabaseTables(SqlDialect dialect) =>
    $ForGeneratedCode.createTableSchema(
      dialect: dialect,
      tables: SubQueryDatabaseSchema._$tables,
    );

final class _$SourceItem extends SourceItem {
  _$SourceItem._(this.id, this.value);

  @override
  final int id;

  @override
  final String value;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'sourceItems',
    columns: <String>['id', 'value'],
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
    ],
    primaryKey: <String>['id'],
    unique: <List<String>>[],
    foreignKeys: [],
    readRow: _$SourceItem._$fromDatabase,
  );

  static SourceItem? _$fromDatabase(RowReader row) {
    final id = row.readInt();
    final value = row.readString();
    if (id == null && value == null) {
      return null;
    }
    return _$SourceItem._(id!, value!);
  }

  @override
  String toString() => 'SourceItem(id: "$id", value: "$value")';
}

/// Extension methods for table defined in [SourceItem].
extension TableSourceItemExt on Table<SourceItem> {
  /// Insert row into the `sourceItems` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<SourceItem> insert({
    Expr<int>? id,
    required Expr<String> value,
  }) => $ForGeneratedCode.insertInto(table: this, values: [id, value]);

  /// Insert row into the `sourceItems` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<SourceItem> insertValue({int? id, required String value}) =>
      $ForGeneratedCode.insertInto(
        table: this,
        values: [id?.asExpr, value.asExpr],
      );

  /// Delete a single row from the `sourceItems` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<SourceItem> delete(int id) =>
      $ForGeneratedCode.deleteSingle(byKey(id), _$SourceItem._$table);
}

/// Extension methods for building queries against the `sourceItems` table.
extension QuerySourceItemExt on Query<(Expr<SourceItem>,)> {
  /// Lookup a single row in `sourceItems` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<SourceItem>,)> byKey(int id) =>
      where((sourceItem) => sourceItem.id.equalsValue(id)).first;

  /// Update all rows in the `sourceItems` table matching this [Query].
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
  Update<SourceItem> update(
    UpdateSet<SourceItem> Function(
      Expr<SourceItem> sourceItem,
      UpdateSet<SourceItem> Function({Expr<int> id, Expr<String> value}) set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<SourceItem>(
    this,
    _$SourceItem._$table,
    (sourceItem) => updateBuilder(
      sourceItem,
      ({Expr<int>? id, Expr<String>? value}) =>
          $ForGeneratedCode.buildUpdate<SourceItem>([id, value]),
    ),
  );

  /// Delete all rows in the `sourceItems` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<SourceItem> delete() =>
      $ForGeneratedCode.delete(this, _$SourceItem._$table);
}

/// Extension methods for building point queries against the `sourceItems` table.
extension QuerySingleSourceItemExt on QuerySingle<(Expr<SourceItem>,)> {
  /// Update the row (if any) in the `sourceItems` table matching this
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
  UpdateSingle<SourceItem> update(
    UpdateSet<SourceItem> Function(
      Expr<SourceItem> sourceItem,
      UpdateSet<SourceItem> Function({Expr<int> id, Expr<String> value}) set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<SourceItem>(
    this,
    _$SourceItem._$table,
    (sourceItem) => updateBuilder(
      sourceItem,
      ({Expr<int>? id, Expr<String>? value}) =>
          $ForGeneratedCode.buildUpdate<SourceItem>([id, value]),
    ),
  );

  /// Delete the row (if any) in the `sourceItems` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<SourceItem> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$SourceItem._$table);
}

/// Extension methods for expressions on a row in the `sourceItems` table.
extension ExpressionSourceItemExt on Expr<SourceItem> {
  Expr<int> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String> get value =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);
}

extension ExpressionNullableSourceItemExt on Expr<SourceItem?> {
  Expr<int?> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String?> get value =>
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

/// `Table<SourceItem>` conflict targets for use with `.onConflict`.
enum SourceItemConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `id`.
  primaryKey(['id']);

  const SourceItemConflict(this._fields);

  final List<String> _fields;
}

extension InsertSingleSourceItemExt on InsertSingle<SourceItem> {
  InsertOnConflictSingle<SourceItem> onConflict(SourceItemConflict target) =>
      $ForGeneratedCode.insertSingleOnConflict(this, target._fields);
}

extension InsertOnConflictSingleSourceItemExt
    on InsertOnConflictSingle<SourceItem> {
  UpsertOne<SourceItem> update(
    UpdateSet<SourceItem> Function(
      Expr<SourceItem> sourceItem,
      Expr<SourceItem> excluded,
      UpdateSet<SourceItem> Function({Expr<int> id, Expr<String> value}) set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<SourceItem>(
    this,
    (sourceItem, excluded) => updateBuilder(
      sourceItem,
      excluded,
      ({Expr<int>? id, Expr<String>? value}) =>
          $ForGeneratedCode.buildUpdate<SourceItem>([id, value]),
    ),
  );
}

final class _$SubQueryItem extends SubQueryItem {
  _$SubQueryItem._(this.id, this.tag, this.refId, this.count);

  @override
  final int id;

  @override
  final String tag;

  @override
  final int refId;

  @override
  final int count;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'subQueryItems',
    columns: <String>['id', 'tag', 'refId', 'count'],
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
        overrides: [
          const SqlOverride(dialect: 'mysql', columnType: 'VARCHAR(255)'),
        ],
      ),
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
    primaryKey: <String>['id'],
    unique: <List<String>>[
      ['tag'],
    ],
    foreignKeys: [
      $ForGeneratedCode.foreignKeyDefinition(
        name: 'null',
        columns: ['refId'],
        referencedTable: 'sourceItems',
        referencedColumns: ['id'],
        onDelete: .noAction,
        onUpdate: .noAction,
      ),
    ],
    readRow: _$SubQueryItem._$fromDatabase,
  );

  static SubQueryItem? _$fromDatabase(RowReader row) {
    final id = row.readInt();
    final tag = row.readString();
    final refId = row.readInt();
    final count = row.readInt();
    if (id == null && tag == null && refId == null && count == null) {
      return null;
    }
    return _$SubQueryItem._(id!, tag!, refId!, count!);
  }

  @override
  String toString() =>
      'SubQueryItem(id: "$id", tag: "$tag", refId: "$refId", count: "$count")';
}

/// Extension methods for table defined in [SubQueryItem].
extension TableSubQueryItemExt on Table<SubQueryItem> {
  /// Insert row into the `subQueryItems` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<SubQueryItem> insert({
    Expr<int>? id,
    required Expr<String> tag,
    required Expr<int> refId,
    required Expr<int> count,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [id, tag, refId, count],
  );

  /// Insert row into the `subQueryItems` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<SubQueryItem> insertValue({
    int? id,
    required String tag,
    required int refId,
    required int count,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [id?.asExpr, tag.asExpr, refId.asExpr, count.asExpr],
  );

  /// Delete a single row from the `subQueryItems` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<SubQueryItem> delete(int id) =>
      $ForGeneratedCode.deleteSingle(byKey(id), _$SubQueryItem._$table);
}

/// Extension methods for building queries against the `subQueryItems` table.
extension QuerySubQueryItemExt on Query<(Expr<SubQueryItem>,)> {
  /// Lookup a single row in `subQueryItems` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<SubQueryItem>,)> byKey(int id) =>
      where((subQueryItem) => subQueryItem.id.equalsValue(id)).first;

  /// Update all rows in the `subQueryItems` table matching this [Query].
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
  Update<SubQueryItem> update(
    UpdateSet<SubQueryItem> Function(
      Expr<SubQueryItem> subQueryItem,
      UpdateSet<SubQueryItem> Function({
        Expr<int> id,
        Expr<String> tag,
        Expr<int> refId,
        Expr<int> count,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<SubQueryItem>(
    this,
    _$SubQueryItem._$table,
    (subQueryItem) => updateBuilder(
      subQueryItem,
      ({
        Expr<int>? id,
        Expr<String>? tag,
        Expr<int>? refId,
        Expr<int>? count,
      }) =>
          $ForGeneratedCode.buildUpdate<SubQueryItem>([id, tag, refId, count]),
    ),
  );

  /// Lookup a single row in `subQueryItems` table using the
  /// `tag` field
  ///
  /// We know that lookup by the `tag` field returns
  /// at-most one row because the [Unique] annotation in [SubQueryItem].
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<SubQueryItem>,)> byTag(String tag) =>
      where((subQueryItem) => subQueryItem.tag.equalsValue(tag)).first;

  /// Delete all rows in the `subQueryItems` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<SubQueryItem> delete() =>
      $ForGeneratedCode.delete(this, _$SubQueryItem._$table);
}

/// Extension methods for building point queries against the `subQueryItems` table.
extension QuerySingleSubQueryItemExt on QuerySingle<(Expr<SubQueryItem>,)> {
  /// Update the row (if any) in the `subQueryItems` table matching this
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
  UpdateSingle<SubQueryItem> update(
    UpdateSet<SubQueryItem> Function(
      Expr<SubQueryItem> subQueryItem,
      UpdateSet<SubQueryItem> Function({
        Expr<int> id,
        Expr<String> tag,
        Expr<int> refId,
        Expr<int> count,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<SubQueryItem>(
    this,
    _$SubQueryItem._$table,
    (subQueryItem) => updateBuilder(
      subQueryItem,
      ({
        Expr<int>? id,
        Expr<String>? tag,
        Expr<int>? refId,
        Expr<int>? count,
      }) =>
          $ForGeneratedCode.buildUpdate<SubQueryItem>([id, tag, refId, count]),
    ),
  );

  /// Delete the row (if any) in the `subQueryItems` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<SubQueryItem> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$SubQueryItem._$table);
}

/// Extension methods for expressions on a row in the `subQueryItems` table.
extension ExpressionSubQueryItemExt on Expr<SubQueryItem> {
  Expr<int> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String> get tag =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<int> get refId =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.integer);

  Expr<int> get count =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.integer);
}

extension ExpressionNullableSubQueryItemExt on Expr<SubQueryItem?> {
  Expr<int?> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String?> get tag =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<int?> get refId =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.integer);

  Expr<int?> get count =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.integer);

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

/// `Table<SubQueryItem>` conflict targets for use with `.onConflict`.
enum SubQueryItemConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `id`.
  primaryKey(['id']),

  /// `tag` conflict.
  ///
  /// Due to violation of the `UNIQUE` constraint on
  /// `tag`.
  ///
  /// Thus, the conflicting row has matching values for these fields.
  tag(['tag']);

  const SubQueryItemConflict(this._fields);

  final List<String> _fields;
}

extension InsertSingleSubQueryItemExt on InsertSingle<SubQueryItem> {
  InsertOnConflictSingle<SubQueryItem> onConflict(
    SubQueryItemConflict target,
  ) => $ForGeneratedCode.insertSingleOnConflict(this, target._fields);
}

extension InsertOnConflictSingleSubQueryItemExt
    on InsertOnConflictSingle<SubQueryItem> {
  UpsertOne<SubQueryItem> update(
    UpdateSet<SubQueryItem> Function(
      Expr<SubQueryItem> subQueryItem,
      Expr<SubQueryItem> excluded,
      UpdateSet<SubQueryItem> Function({
        Expr<int> id,
        Expr<String> tag,
        Expr<int> refId,
        Expr<int> count,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<SubQueryItem>(
    this,
    (subQueryItem, excluded) => updateBuilder(
      subQueryItem,
      excluded,
      ({
        Expr<int>? id,
        Expr<String>? tag,
        Expr<int>? refId,
        Expr<int>? count,
      }) =>
          $ForGeneratedCode.buildUpdate<SubQueryItem>([id, tag, refId, count]),
    ),
  );
}

/// Extension methods for assertions on [SourceItem] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension SourceItemChecks on Subject<SourceItem> {
  /// Create assertions on [SourceItem.id].
  Subject<int> get id => has((m) => m.id, 'id');

  /// Create assertions on [SourceItem.value].
  Subject<String> get value => has((m) => m.value, 'value');
}

/// Extension methods for assertions on [SubQueryItem] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension SubQueryItemChecks on Subject<SubQueryItem> {
  /// Create assertions on [SubQueryItem.id].
  Subject<int> get id => has((m) => m.id, 'id');

  /// Create assertions on [SubQueryItem.tag].
  Subject<String> get tag => has((m) => m.tag, 'tag');

  /// Create assertions on [SubQueryItem.refId].
  Subject<int> get refId => has((m) => m.refId, 'refId');

  /// Create assertions on [SubQueryItem.count].
  Subject<int> get count => has((m) => m.count, 'count');
}
