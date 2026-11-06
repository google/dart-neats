// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'self_foreign_key_test.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

/// Extension methods for a [Database] operating on [TestDatabase].
extension TestDatabaseSchema on Database<TestDatabase> {
  static final _$tables = [_$Category._$table, _$Node._$table];

  Table<Category> get categories =>
      $ForGeneratedCode.declareTable(this, _$Category._$table);

  Table<Node> get nodes => $ForGeneratedCode.declareTable(this, _$Node._$table);

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

final class _$Category extends Category {
  _$Category._(this.categoryId, this.name, this.parentId);

  @override
  final int categoryId;

  @override
  final String name;

  @override
  final int? parentId;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'categories',
    columns: <String>['categoryId', 'name', 'parentId'],
    columnInfo: [
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.integer,
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
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.integer,
        isNotNull: false,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
    ],
    primaryKey: <String>['categoryId'],
    unique: <List<String>>[],
    foreignKeys: [
      $ForGeneratedCode.foreignKeyDefinition(
        name: 'parent',
        columns: ['parentId'],
        referencedTable: 'categories',
        referencedColumns: ['categoryId'],
        onDelete: .noAction,
        onUpdate: .noAction,
      ),
    ],
    indexes: [],
    readRow: _$Category._$fromDatabase,
  );

  static Category? _$fromDatabase(RowReader row) {
    final categoryId = row.readInt();
    final name = row.readString();
    final parentId = row.readInt();
    if (categoryId == null && name == null && parentId == null) {
      return null;
    }
    return _$Category._(categoryId!, name!, parentId);
  }

  @override
  String toString() =>
      'Category(categoryId: "$categoryId", name: "$name", parentId: "$parentId")';
}

/// Extension methods for table defined in [Category].
extension TableCategoryExt on Table<Category> {
  /// Insert row into the `categories` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<Category> insert({
    required Expr<int> categoryId,
    required Expr<String> name,
    Expr<int?>? parentId,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [categoryId, name, parentId],
  );

  /// Insert row into the `categories` table, or update the
  /// existing row if it conflicts with the _primary key_.
  ///
  /// This is a shorthand for calling `.insert(...)` followed by
  /// `.onConflict(.primaryKey)` and `.update(...)` to overwrite
  /// the fields `name`, `parentId`,
  /// with the values given, leaving the _primary key_ untouched.
  ///
  /// Returns an [UpsertSingle] statement on which `.execute()` must be
  /// called for the row to be inserted or updated.
  UpsertSingle<Category> upsert({
    required Expr<int> categoryId,
    required Expr<String> name,
    Expr<int?>? parentId,
  }) => insert(categoryId: categoryId, name: name, parentId: parentId)
      .onConflict(.primaryKey)
      .update(
        (_, excluded, set) =>
            set(name: excluded.name, parentId: excluded.parentId),
      );

  /// Insert row into the `categories` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<Category> insertValue({
    required int categoryId,
    required String name,
    int? parentId,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [categoryId.asExpr, name.asExpr, parentId.asExpr],
  );

  /// Insert row into the `categories` table, or update the
  /// existing row if it conflicts with the _primary key_.
  ///
  /// This is a shorthand for calling `.insertValue(...)` followed by
  /// `.onConflict(.primaryKey)` and `.update(...)` to overwrite
  /// the fields `name`, `parentId`,
  /// with the values given, leaving the _primary key_ untouched.
  ///
  /// Returns an [UpsertSingle] statement on which `.execute()` must be
  /// called for the row to be inserted or updated.
  UpsertSingle<Category> upsertValue({
    required int categoryId,
    required String name,
    int? parentId,
  }) => insertValue(categoryId: categoryId, name: name, parentId: parentId)
      .onConflict(.primaryKey)
      .update(
        (_, excluded, set) =>
            set(name: excluded.name, parentId: excluded.parentId),
      );

  /// Bulk insert rows into the `categories` table.
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
  Insert<Category> insertValuesMapped<T>(
    Iterable<T> rows, {
    required int Function(T row) categoryId,
    required String Function(T row) name,
    int? Function(T row)? parentId,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mappings: [categoryId, name, parentId],
  );

  /// Delete a single row from the `categories` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<Category> delete(int categoryId) =>
      $ForGeneratedCode.deleteSingle(byKey(categoryId), _$Category._$table);
}

/// Extension methods for building queries against the `categories` table.
extension QueryCategoryExt on Query<(Expr<Category>,)> {
  /// Lookup a single row in `categories` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<Category>,)> byKey(int categoryId) =>
      where((category) => category.categoryId.equalsValue(categoryId)).first;

  /// Update all rows in the `categories` table matching this [Query].
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
  Update<Category> update(
    UpdateSet<Category> Function(
      Expr<Category> category,
      UpdateSet<Category> Function({
        Expr<int> categoryId,
        Expr<String> name,
        Expr<int?> parentId,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<Category>(
    this,
    _$Category._$table,
    (category) => updateBuilder(
      category,
      ({Expr<int>? categoryId, Expr<String>? name, Expr<int?>? parentId}) =>
          $ForGeneratedCode.buildUpdate<Category>([categoryId, name, parentId]),
    ),
  );

  /// Delete all rows in the `categories` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<Category> delete() =>
      $ForGeneratedCode.delete(this, _$Category._$table);
}

/// Extension methods for building point queries against the `categories` table.
extension QuerySingleCategoryExt on QuerySingle<(Expr<Category>,)> {
  /// Update the row (if any) in the `categories` table matching this
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
  UpdateSingle<Category> update(
    UpdateSet<Category> Function(
      Expr<Category> category,
      UpdateSet<Category> Function({
        Expr<int> categoryId,
        Expr<String> name,
        Expr<int?> parentId,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<Category>(
    this,
    _$Category._$table,
    (category) => updateBuilder(
      category,
      ({Expr<int>? categoryId, Expr<String>? name, Expr<int?>? parentId}) =>
          $ForGeneratedCode.buildUpdate<Category>([categoryId, name, parentId]),
    ),
  );

  /// Delete the row (if any) in the `categories` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<Category> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$Category._$table);
}

/// Extension methods for expressions on a row in the `categories` table.
extension ExpressionCategoryExt on Expr<Category> {
  Expr<int> get categoryId =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String> get name =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<int?> get parentId =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.integer);

  /// Get [SubQuery] of rows from the `categories` table which
  /// reference this row.
  ///
  /// This returns a [SubQuery] of [Category] rows,
  /// where [Category.parentId]
  /// references [Category.categoryId]
  /// in this row.
  SubQuery<(Expr<Category>,)> get children => $ForGeneratedCode
      .subqueryTable(_$Category._$table)
      .where((r) => r.parentId.equalsUnlessNull(categoryId));

  /// Do a subquery lookup of the row from table
  /// `categories` referenced in
  /// [parentId].
  ///
  /// The gets the row from table `categories` where
  /// [Category.categoryId]
  /// is equal to [parentId], if any.
  Expr<Category?> get parent => $ForGeneratedCode
      .subqueryTable(_$Category._$table)
      .where((r) => r.categoryId.equalsUnlessNull(parentId))
      .first;
}

extension ExpressionNullableCategoryExt on Expr<Category?> {
  Expr<int?> get categoryId =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String?> get name =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<int?> get parentId =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.integer);

  /// Get [SubQuery] of rows from the `categories` table which
  /// reference this row.
  ///
  /// This returns a [SubQuery] of [Category] rows,
  /// where [Category.parentId]
  /// references [Category.categoryId]
  /// in this row, if any.
  ///
  /// If this row is `NULL` the subquery is always be empty.
  SubQuery<(Expr<Category>,)> get children => $ForGeneratedCode
      .subqueryTable(_$Category._$table)
      .where((r) => r.parentId.equalsUnlessNull(categoryId));

  /// Do a subquery lookup of the row from table
  /// `categories` referenced in
  /// [parentId].
  ///
  /// The gets the row from table `categories` where
  /// [Category.categoryId]
  /// is equal to [parentId], if any.
  ///
  /// If this row is `NULL` the subquery is always return `NULL`.
  Expr<Category?> get parent => $ForGeneratedCode
      .subqueryTable(_$Category._$table)
      .where((r) => r.categoryId.equalsUnlessNull(parentId))
      .first;

  /// Check if the row is not `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNotNull() => categoryId.isNotNull();

  /// Check if the row is `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNull() => isNotNull().not();
}

extension InnerJoinCategoryCategoryExt
    on InnerJoin<(Expr<Category>,), (Expr<Category>,)> {
  /// Join using the `parent` _foreign key_.
  ///
  /// This will match rows where [Category.categoryId] = [Category.parentId].
  Query<(Expr<Category>, Expr<Category>)> usingChildren() =>
      on((a, b) => a.categoryId.equalsUnlessNull(b.parentId));

  /// Join using the `parent` _foreign key_.
  ///
  /// This will match rows where [Category.parentId] = [Category.categoryId].
  Query<(Expr<Category>, Expr<Category>)> usingParent() =>
      on((a, b) => b.categoryId.equalsUnlessNull(a.parentId));
}

extension LeftJoinCategoryCategoryExt
    on LeftJoin<(Expr<Category>,), (Expr<Category>,)> {
  /// Join using the `parent` _foreign key_.
  ///
  /// This will match rows where [Category.categoryId] = [Category.parentId].
  Query<(Expr<Category>, Expr<Category?>)> usingChildren() =>
      on((a, b) => a.categoryId.equalsUnlessNull(b.parentId));

  /// Join using the `parent` _foreign key_.
  ///
  /// This will match rows where [Category.parentId] = [Category.categoryId].
  Query<(Expr<Category>, Expr<Category?>)> usingParent() =>
      on((a, b) => b.categoryId.equalsUnlessNull(a.parentId));
}

extension RightJoinCategoryCategoryExt
    on RightJoin<(Expr<Category>,), (Expr<Category>,)> {
  /// Join using the `parent` _foreign key_.
  ///
  /// This will match rows where [Category.categoryId] = [Category.parentId].
  Query<(Expr<Category?>, Expr<Category>)> usingChildren() =>
      on((a, b) => a.categoryId.equalsUnlessNull(b.parentId));

  /// Join using the `parent` _foreign key_.
  ///
  /// This will match rows where [Category.parentId] = [Category.categoryId].
  Query<(Expr<Category?>, Expr<Category>)> usingParent() =>
      on((a, b) => b.categoryId.equalsUnlessNull(a.parentId));
}

/// `Table<Category>` conflict targets for use with `.onConflict`.
enum CategoryConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `categoryId`.
  primaryKey(['categoryId']);

  const CategoryConflict(this._fields);

  final List<String> _fields;
}

extension InsertCategoryExt on Insert<Category> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((category, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflict<Category> onConflict(CategoryConflict target) =>
      $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictCategoryExt on InsertOnConflict<Category> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `category` an [Expr] representing the existing row in
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
  Upsert<Category> update(
    UpdateSet<Category> Function(
      Expr<Category> category,
      Expr<Category> excluded,
      UpdateSet<Category> Function({
        Expr<int> categoryId,
        Expr<String> name,
        Expr<int?> parentId,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<Category>(
    this,
    (category, excluded) => updateBuilder(
      category,
      excluded,
      ({Expr<int>? categoryId, Expr<String>? name, Expr<int?>? parentId}) =>
          $ForGeneratedCode.buildUpdate<Category>([categoryId, name, parentId]),
    ),
  );
}

extension InsertSingleCategoryExt on InsertSingle<Category> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((category, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflictSingle<Category> onConflict(CategoryConflict target) =>
      $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleCategoryExt
    on InsertOnConflictSingle<Category> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `category` an [Expr] representing the existing row in
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
  UpsertSingle<Category> update(
    UpdateSet<Category> Function(
      Expr<Category> category,
      Expr<Category> excluded,
      UpdateSet<Category> Function({
        Expr<int> categoryId,
        Expr<String> name,
        Expr<int?> parentId,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<Category>(
    this,
    (category, excluded) => updateBuilder(
      category,
      excluded,
      ({Expr<int>? categoryId, Expr<String>? name, Expr<int?>? parentId}) =>
          $ForGeneratedCode.buildUpdate<Category>([categoryId, name, parentId]),
    ),
  );
}

final class _$Node extends Node {
  _$Node._(
    this.region,
    this.code,
    this.parentRegion,
    this.parentCode,
    this.weight,
  );

  @override
  final String region;

  @override
  final String code;

  @override
  final String? parentRegion;

  @override
  final String? parentCode;

  @override
  final int weight;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'nodes',
    columns: <String>['region', 'code', 'parentRegion', 'parentCode', 'weight'],
    columnInfo: [
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [
          (
            dialect: 'mysql',
            columnType: 'VARCHAR(255)',
            defaultValue: null,
            collation: null,
          ),
        ],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [
          (
            dialect: 'mysql',
            columnType: 'VARCHAR(255)',
            defaultValue: null,
            collation: null,
          ),
        ],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: false,
        defaultValue: null,
        autoIncrement: false,
        overrides: [
          (
            dialect: 'mysql',
            columnType: 'VARCHAR(255)',
            defaultValue: null,
            collation: null,
          ),
        ],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: false,
        defaultValue: null,
        autoIncrement: false,
        overrides: [
          (
            dialect: 'mysql',
            columnType: 'VARCHAR(255)',
            defaultValue: null,
            collation: null,
          ),
        ],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.integer,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
    ],
    primaryKey: <String>['region', 'code'],
    unique: <List<String>>[],
    foreignKeys: [
      $ForGeneratedCode.foreignKeyDefinition(
        name: 'parent',
        columns: ['parentRegion', 'parentCode'],
        referencedTable: 'nodes',
        referencedColumns: ['region', 'code'],
        onDelete: .noAction,
        onUpdate: .noAction,
      ),
    ],
    indexes: [],
    readRow: _$Node._$fromDatabase,
  );

  static Node? _$fromDatabase(RowReader row) {
    final region = row.readString();
    final code = row.readString();
    final parentRegion = row.readString();
    final parentCode = row.readString();
    final weight = row.readInt();
    if (region == null &&
        code == null &&
        parentRegion == null &&
        parentCode == null &&
        weight == null) {
      return null;
    }
    return _$Node._(region!, code!, parentRegion, parentCode, weight!);
  }

  @override
  String toString() =>
      'Node(region: "$region", code: "$code", parentRegion: "$parentRegion", parentCode: "$parentCode", weight: "$weight")';
}

/// Extension methods for table defined in [Node].
extension TableNodeExt on Table<Node> {
  /// Insert row into the `nodes` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<Node> insert({
    required Expr<String> region,
    required Expr<String> code,
    Expr<String?>? parentRegion,
    Expr<String?>? parentCode,
    required Expr<int> weight,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [region, code, parentRegion, parentCode, weight],
  );

  /// Insert row into the `nodes` table, or update the
  /// existing row if it conflicts with the _primary key_.
  ///
  /// This is a shorthand for calling `.insert(...)` followed by
  /// `.onConflict(.primaryKey)` and `.update(...)` to overwrite
  /// the fields `parentRegion`, `parentCode`, `weight`,
  /// with the values given, leaving the _primary key_ untouched.
  ///
  /// Returns an [UpsertSingle] statement on which `.execute()` must be
  /// called for the row to be inserted or updated.
  UpsertSingle<Node> upsert({
    required Expr<String> region,
    required Expr<String> code,
    Expr<String?>? parentRegion,
    Expr<String?>? parentCode,
    required Expr<int> weight,
  }) =>
      insert(
            region: region,
            code: code,
            parentRegion: parentRegion,
            parentCode: parentCode,
            weight: weight,
          )
          .onConflict(.primaryKey)
          .update(
            (_, excluded, set) => set(
              parentRegion: excluded.parentRegion,
              parentCode: excluded.parentCode,
              weight: excluded.weight,
            ),
          );

  /// Insert row into the `nodes` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<Node> insertValue({
    required String region,
    required String code,
    String? parentRegion,
    String? parentCode,
    required int weight,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [
      region.asExpr,
      code.asExpr,
      parentRegion.asExpr,
      parentCode.asExpr,
      weight.asExpr,
    ],
  );

  /// Insert row into the `nodes` table, or update the
  /// existing row if it conflicts with the _primary key_.
  ///
  /// This is a shorthand for calling `.insertValue(...)` followed by
  /// `.onConflict(.primaryKey)` and `.update(...)` to overwrite
  /// the fields `parentRegion`, `parentCode`, `weight`,
  /// with the values given, leaving the _primary key_ untouched.
  ///
  /// Returns an [UpsertSingle] statement on which `.execute()` must be
  /// called for the row to be inserted or updated.
  UpsertSingle<Node> upsertValue({
    required String region,
    required String code,
    String? parentRegion,
    String? parentCode,
    required int weight,
  }) =>
      insertValue(
            region: region,
            code: code,
            parentRegion: parentRegion,
            parentCode: parentCode,
            weight: weight,
          )
          .onConflict(.primaryKey)
          .update(
            (_, excluded, set) => set(
              parentRegion: excluded.parentRegion,
              parentCode: excluded.parentCode,
              weight: excluded.weight,
            ),
          );

  /// Bulk insert rows into the `nodes` table.
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
  Insert<Node> insertValuesMapped<T>(
    Iterable<T> rows, {
    required String Function(T row) region,
    required String Function(T row) code,
    String? Function(T row)? parentRegion,
    String? Function(T row)? parentCode,
    required int Function(T row) weight,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mappings: [region, code, parentRegion, parentCode, weight],
  );

  /// Delete a single row from the `nodes` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<Node> delete(String region, String code) =>
      $ForGeneratedCode.deleteSingle(byKey(region, code), _$Node._$table);
}

/// Extension methods for building queries against the `nodes` table.
extension QueryNodeExt on Query<(Expr<Node>,)> {
  /// Lookup a single row in `nodes` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<Node>,)> byKey(String region, String code) => where(
    (node) => node.region.equalsValue(region) & node.code.equalsValue(code),
  ).first;

  /// Update all rows in the `nodes` table matching this [Query].
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
  Update<Node> update(
    UpdateSet<Node> Function(
      Expr<Node> node,
      UpdateSet<Node> Function({
        Expr<String> region,
        Expr<String> code,
        Expr<String?> parentRegion,
        Expr<String?> parentCode,
        Expr<int> weight,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<Node>(
    this,
    _$Node._$table,
    (node) => updateBuilder(
      node,
      ({
        Expr<String>? region,
        Expr<String>? code,
        Expr<String?>? parentRegion,
        Expr<String?>? parentCode,
        Expr<int>? weight,
      }) => $ForGeneratedCode.buildUpdate<Node>([
        region,
        code,
        parentRegion,
        parentCode,
        weight,
      ]),
    ),
  );

  /// Delete all rows in the `nodes` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<Node> delete() => $ForGeneratedCode.delete(this, _$Node._$table);
}

/// Extension methods for building point queries against the `nodes` table.
extension QuerySingleNodeExt on QuerySingle<(Expr<Node>,)> {
  /// Update the row (if any) in the `nodes` table matching this
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
  UpdateSingle<Node> update(
    UpdateSet<Node> Function(
      Expr<Node> node,
      UpdateSet<Node> Function({
        Expr<String> region,
        Expr<String> code,
        Expr<String?> parentRegion,
        Expr<String?> parentCode,
        Expr<int> weight,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<Node>(
    this,
    _$Node._$table,
    (node) => updateBuilder(
      node,
      ({
        Expr<String>? region,
        Expr<String>? code,
        Expr<String?>? parentRegion,
        Expr<String?>? parentCode,
        Expr<int>? weight,
      }) => $ForGeneratedCode.buildUpdate<Node>([
        region,
        code,
        parentRegion,
        parentCode,
        weight,
      ]),
    ),
  );

  /// Delete the row (if any) in the `nodes` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<Node> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$Node._$table);
}

/// Extension methods for expressions on a row in the `nodes` table.
extension ExpressionNodeExt on Expr<Node> {
  Expr<String> get region =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.text);

  Expr<String> get code =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<String?> get parentRegion =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  Expr<String?> get parentCode =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.text);

  Expr<int> get weight =>
      $ForGeneratedCode.field(this, 4, $ForGeneratedCode.integer);

  /// Get [SubQuery] of rows from the `nodes` table which
  /// reference this row.
  ///
  /// This returns a [SubQuery] of [Node] rows,
  /// where [Node.parentRegion], [Node.parentCode]
  /// references [Node.region], [Node.code]
  /// in this row.
  SubQuery<(Expr<Node>,)> get children => $ForGeneratedCode
      .subqueryTable(_$Node._$table)
      .where(
        (r) =>
            r.parentRegion.equalsUnlessNull(region) &
            r.parentCode.equalsUnlessNull(code),
      );

  /// Do a subquery lookup of the row from table
  /// `nodes` referenced in
  /// [parentRegion], [parentCode].
  ///
  /// The gets the row from table `nodes` where
  /// [Node.region], [Node.code]
  /// is equal to [parentRegion], [parentCode], if any.
  Expr<Node?> get parent => $ForGeneratedCode
      .subqueryTable(_$Node._$table)
      .where(
        (r) =>
            r.region.equalsUnlessNull(parentRegion) &
            r.code.equalsUnlessNull(parentCode),
      )
      .first;
}

extension ExpressionNullableNodeExt on Expr<Node?> {
  Expr<String?> get region =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.text);

  Expr<String?> get code =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<String?> get parentRegion =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  Expr<String?> get parentCode =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.text);

  Expr<int?> get weight =>
      $ForGeneratedCode.field(this, 4, $ForGeneratedCode.integer);

  /// Get [SubQuery] of rows from the `nodes` table which
  /// reference this row.
  ///
  /// This returns a [SubQuery] of [Node] rows,
  /// where [Node.parentRegion], [Node.parentCode]
  /// references [Node.region], [Node.code]
  /// in this row, if any.
  ///
  /// If this row is `NULL` the subquery is always be empty.
  SubQuery<(Expr<Node>,)> get children => $ForGeneratedCode
      .subqueryTable(_$Node._$table)
      .where(
        (r) =>
            r.parentRegion.equalsUnlessNull(region) &
            r.parentCode.equalsUnlessNull(code),
      );

  /// Do a subquery lookup of the row from table
  /// `nodes` referenced in
  /// [parentRegion], [parentCode].
  ///
  /// The gets the row from table `nodes` where
  /// [Node.region], [Node.code]
  /// is equal to [parentRegion], [parentCode], if any.
  ///
  /// If this row is `NULL` the subquery is always return `NULL`.
  Expr<Node?> get parent => $ForGeneratedCode
      .subqueryTable(_$Node._$table)
      .where(
        (r) =>
            r.region.equalsUnlessNull(parentRegion) &
            r.code.equalsUnlessNull(parentCode),
      )
      .first;

  /// Check if the row is not `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNotNull() => region.isNotNull() & code.isNotNull();

  /// Check if the row is `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNull() => isNotNull().not();
}

extension InnerJoinNodeNodeExt on InnerJoin<(Expr<Node>,), (Expr<Node>,)> {
  /// Join using the `parent` _foreign key_.
  ///
  /// This will match rows where [Node.region] = [Node.parentRegion] and [Node.code] = [Node.parentCode].
  Query<(Expr<Node>, Expr<Node>)> usingChildren() => on(
    (a, b) =>
        a.region.equalsUnlessNull(b.parentRegion) &
        a.code.equalsUnlessNull(b.parentCode),
  );

  /// Join using the `parent` _foreign key_.
  ///
  /// This will match rows where [Node.parentRegion] = [Node.region] and [Node.parentCode] = [Node.code].
  Query<(Expr<Node>, Expr<Node>)> usingParent() => on(
    (a, b) =>
        b.region.equalsUnlessNull(a.parentRegion) &
        b.code.equalsUnlessNull(a.parentCode),
  );
}

extension LeftJoinNodeNodeExt on LeftJoin<(Expr<Node>,), (Expr<Node>,)> {
  /// Join using the `parent` _foreign key_.
  ///
  /// This will match rows where [Node.region] = [Node.parentRegion] and [Node.code] = [Node.parentCode].
  Query<(Expr<Node>, Expr<Node?>)> usingChildren() => on(
    (a, b) =>
        a.region.equalsUnlessNull(b.parentRegion) &
        a.code.equalsUnlessNull(b.parentCode),
  );

  /// Join using the `parent` _foreign key_.
  ///
  /// This will match rows where [Node.parentRegion] = [Node.region] and [Node.parentCode] = [Node.code].
  Query<(Expr<Node>, Expr<Node?>)> usingParent() => on(
    (a, b) =>
        b.region.equalsUnlessNull(a.parentRegion) &
        b.code.equalsUnlessNull(a.parentCode),
  );
}

extension RightJoinNodeNodeExt on RightJoin<(Expr<Node>,), (Expr<Node>,)> {
  /// Join using the `parent` _foreign key_.
  ///
  /// This will match rows where [Node.region] = [Node.parentRegion] and [Node.code] = [Node.parentCode].
  Query<(Expr<Node?>, Expr<Node>)> usingChildren() => on(
    (a, b) =>
        a.region.equalsUnlessNull(b.parentRegion) &
        a.code.equalsUnlessNull(b.parentCode),
  );

  /// Join using the `parent` _foreign key_.
  ///
  /// This will match rows where [Node.parentRegion] = [Node.region] and [Node.parentCode] = [Node.code].
  Query<(Expr<Node?>, Expr<Node>)> usingParent() => on(
    (a, b) =>
        b.region.equalsUnlessNull(a.parentRegion) &
        b.code.equalsUnlessNull(a.parentCode),
  );
}

/// `Table<Node>` conflict targets for use with `.onConflict`.
enum NodeConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `region`, `code`.
  primaryKey(['region', 'code']);

  const NodeConflict(this._fields);

  final List<String> _fields;
}

extension InsertNodeExt on Insert<Node> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((node, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflict<Node> onConflict(NodeConflict target) =>
      $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictNodeExt on InsertOnConflict<Node> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `node` an [Expr] representing the existing row in
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
  Upsert<Node> update(
    UpdateSet<Node> Function(
      Expr<Node> node,
      Expr<Node> excluded,
      UpdateSet<Node> Function({
        Expr<String> region,
        Expr<String> code,
        Expr<String?> parentRegion,
        Expr<String?> parentCode,
        Expr<int> weight,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<Node>(
    this,
    (node, excluded) => updateBuilder(
      node,
      excluded,
      ({
        Expr<String>? region,
        Expr<String>? code,
        Expr<String?>? parentRegion,
        Expr<String?>? parentCode,
        Expr<int>? weight,
      }) => $ForGeneratedCode.buildUpdate<Node>([
        region,
        code,
        parentRegion,
        parentCode,
        weight,
      ]),
    ),
  );
}

extension InsertSingleNodeExt on InsertSingle<Node> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((node, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflictSingle<Node> onConflict(NodeConflict target) =>
      $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleNodeExt on InsertOnConflictSingle<Node> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `node` an [Expr] representing the existing row in
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
  UpsertSingle<Node> update(
    UpdateSet<Node> Function(
      Expr<Node> node,
      Expr<Node> excluded,
      UpdateSet<Node> Function({
        Expr<String> region,
        Expr<String> code,
        Expr<String?> parentRegion,
        Expr<String?> parentCode,
        Expr<int> weight,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<Node>(
    this,
    (node, excluded) => updateBuilder(
      node,
      excluded,
      ({
        Expr<String>? region,
        Expr<String>? code,
        Expr<String?>? parentRegion,
        Expr<String?>? parentCode,
        Expr<int>? weight,
      }) => $ForGeneratedCode.buildUpdate<Node>([
        region,
        code,
        parentRegion,
        parentCode,
        weight,
      ]),
    ),
  );
}

/// Extension methods for assertions on [Category] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension CategoryChecks on Subject<Category> {
  /// Create assertions on [Category.categoryId].
  Subject<int> get categoryId => has((m) => m.categoryId, 'categoryId');

  /// Create assertions on [Category.name].
  Subject<String> get name => has((m) => m.name, 'name');

  /// Create assertions on [Category.parentId].
  Subject<int?> get parentId => has((m) => m.parentId, 'parentId');
}

/// Extension methods for assertions on [Node] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension NodeChecks on Subject<Node> {
  /// Create assertions on [Node.region].
  Subject<String> get region => has((m) => m.region, 'region');

  /// Create assertions on [Node.code].
  Subject<String> get code => has((m) => m.code, 'code');

  /// Create assertions on [Node.parentRegion].
  Subject<String?> get parentRegion =>
      has((m) => m.parentRegion, 'parentRegion');

  /// Create assertions on [Node.parentCode].
  Subject<String?> get parentCode => has((m) => m.parentCode, 'parentCode');

  /// Create assertions on [Node.weight].
  Subject<int> get weight => has((m) => m.weight, 'weight');
}
