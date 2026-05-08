// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_groupby_caveat_test.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

/// Extension methods for a [Database] operating on [ProductCatalog].
extension ProductCatalogSchema on Database<ProductCatalog> {
  static final _$tables = [_$Product._$table];

  Table<Product> get products =>
      $ForGeneratedCode.declareTable(this, _$Product._$table);

  /// Create tables defined in [ProductCatalog].
  ///
  /// Calling this on an empty database will create the tables
  /// defined in [ProductCatalog]. In production it's often better to
  /// use [createProductCatalogTables] and manage migrations using
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

/// Get SQL [DDL statements][1] for tables defined in [ProductCatalog].
///
/// This returns a SQL script with multiple DDL statements separated by `;`
/// using the specified [dialect].
///
/// Executing these statements in an empty database will create the tables
/// defined in [ProductCatalog]. In practice, this method is often used for
/// printing the DDL statements, such that migrations can be managed by
/// external tools.
///
/// [1]: https://en.wikipedia.org/wiki/Data_definition_language
String createProductCatalogTables(SqlDialect dialect) => $ForGeneratedCode
    .createTableSchema(dialect: dialect, tables: ProductCatalogSchema._$tables);

final class _$Product extends Product {
  _$Product._(this.id, this.name, this.metadata);

  @override
  final int id;

  @override
  final String name;

  @override
  final JsonValue metadata;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'products',
    columns: <String>['id', 'name', 'metadata'],
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
        type: $ForGeneratedCode.jsonValue,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
    ],
    primaryKey: <String>['id'],
    unique: <List<String>>[],
    foreignKeys: [],
    readRow: _$Product._$fromDatabase,
  );

  static Product? _$fromDatabase(RowReader row) {
    final id = row.readInt();
    final name = row.readString();
    final metadata = row.readJsonValue();
    if (id == null && name == null && metadata == null) {
      return null;
    }
    return _$Product._(id!, name!, metadata!);
  }

  @override
  String toString() =>
      'Product(id: "$id", name: "$name", metadata: "$metadata")';
}

/// Extension methods for table defined in [Product].
extension TableProductExt on Table<Product> {
  /// Insert row into the `products` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<Product> insert({
    Expr<int>? id,
    required Expr<String> name,
    required Expr<JsonValue> metadata,
  }) => $ForGeneratedCode.insertInto(table: this, values: [id, name, metadata]);

  /// Insert row into the `products` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<Product> insertValue({
    int? id,
    required String name,
    required JsonValue metadata,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [id?.asExpr, name.asExpr, metadata.asExpr],
  );

  /// Bulk insert rows into the `products` table.
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
  Insert<Product> insertValuesMapped<T>(
    Iterable<T> rows, {
    int Function(T row)? id,
    required String Function(T row) name,
    required JsonValue Function(T row) metadata,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mapping: {'id': id, 'name': name, 'metadata': metadata},
  );

  /// Delete a single row from the `products` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<Product> delete(int id) =>
      $ForGeneratedCode.deleteSingle(byKey(id), _$Product._$table);
}

/// Extension methods for building queries against the `products` table.
extension QueryProductExt on Query<(Expr<Product>,)> {
  /// Lookup a single row in `products` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<Product>,)> byKey(int id) =>
      where((product) => product.id.equalsValue(id)).first;

  /// Update all rows in the `products` table matching this [Query].
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
  Update<Product> update(
    UpdateSet<Product> Function(
      Expr<Product> product,
      UpdateSet<Product> Function({
        Expr<int> id,
        Expr<String> name,
        Expr<JsonValue> metadata,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<Product>(
    this,
    _$Product._$table,
    (product) => updateBuilder(
      product,
      ({Expr<int>? id, Expr<String>? name, Expr<JsonValue>? metadata}) =>
          $ForGeneratedCode.buildUpdate<Product>([id, name, metadata]),
    ),
  );

  /// Delete all rows in the `products` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<Product> delete() => $ForGeneratedCode.delete(this, _$Product._$table);
}

/// Extension methods for building point queries against the `products` table.
extension QuerySingleProductExt on QuerySingle<(Expr<Product>,)> {
  /// Update the row (if any) in the `products` table matching this
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
  UpdateSingle<Product> update(
    UpdateSet<Product> Function(
      Expr<Product> product,
      UpdateSet<Product> Function({
        Expr<int> id,
        Expr<String> name,
        Expr<JsonValue> metadata,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<Product>(
    this,
    _$Product._$table,
    (product) => updateBuilder(
      product,
      ({Expr<int>? id, Expr<String>? name, Expr<JsonValue>? metadata}) =>
          $ForGeneratedCode.buildUpdate<Product>([id, name, metadata]),
    ),
  );

  /// Delete the row (if any) in the `products` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<Product> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$Product._$table);
}

/// Extension methods for expressions on a row in the `products` table.
extension ExpressionProductExt on Expr<Product> {
  Expr<int> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String> get name =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<JsonValue> get metadata =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.jsonValue);
}

extension ExpressionNullableProductExt on Expr<Product?> {
  Expr<int?> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String?> get name =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<JsonValue?> get metadata =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.jsonValue);

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

/// `Table<Product>` conflict targets for use with `.onConflict`.
enum ProductConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `id`.
  primaryKey(['id']);

  const ProductConflict(this._fields);

  final List<String> _fields;
}

extension InsertProductExt on Insert<Product> {
  InsertOnConflict<Product> onConflict(ProductConflict target) =>
      $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictProductExt on InsertOnConflict<Product> {
  Upsert<Product> update(
    UpdateSet<Product> Function(
      Expr<Product> product,
      Expr<Product> excluded,
      UpdateSet<Product> Function({
        Expr<int> id,
        Expr<String> name,
        Expr<JsonValue> metadata,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<Product>(
    this,
    (product, excluded) => updateBuilder(
      product,
      excluded,
      ({Expr<int>? id, Expr<String>? name, Expr<JsonValue>? metadata}) =>
          $ForGeneratedCode.buildUpdate<Product>([id, name, metadata]),
    ),
  );
}

extension InsertSingleProductExt on InsertSingle<Product> {
  InsertOnConflictSingle<Product> onConflict(ProductConflict target) =>
      $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleProductExt on InsertOnConflictSingle<Product> {
  UpsertSingle<Product> update(
    UpdateSet<Product> Function(
      Expr<Product> product,
      Expr<Product> excluded,
      UpdateSet<Product> Function({
        Expr<int> id,
        Expr<String> name,
        Expr<JsonValue> metadata,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<Product>(
    this,
    (product, excluded) => updateBuilder(
      product,
      excluded,
      ({Expr<int>? id, Expr<String>? name, Expr<JsonValue>? metadata}) =>
          $ForGeneratedCode.buildUpdate<Product>([id, name, metadata]),
    ),
  );
}

/// Extension methods for assertions on [Product] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension ProductChecks on Subject<Product> {
  /// Create assertions on [Product.id].
  Subject<int> get id => has((m) => m.id, 'id');

  /// Create assertions on [Product.name].
  Subject<String> get name => has((m) => m.name, 'name');

  /// Create assertions on [Product.metadata].
  Subject<JsonValue> get metadata => has((m) => m.metadata, 'metadata');
}
