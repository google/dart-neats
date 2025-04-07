// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

/// Extension methods for a [Database] operating on [PrimaryDatabase].
extension PrimaryDatabaseSchema on Database<PrimaryDatabase> {
  static const _$tables = [_$User._$table, _$Package._$table, _$Like._$table];

  Table<User> get users => ExposedForCodeGen.declareTable(
        this,
        _$User._$table,
      );

  Table<Package> get packages => ExposedForCodeGen.declareTable(
        this,
        _$Package._$table,
      );

  Table<Like> get likes => ExposedForCodeGen.declareTable(
        this,
        _$Like._$table,
      );

  /// Create tables defined in [PrimaryDatabase].
  ///
  /// Calling this on an empty database will create the tables
  /// defined in [PrimaryDatabase]. In production it's often better to
  /// use [createPrimaryDatabaseTables] and manage migrations using
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

/// Get SQL [DDL statements][1] for tables defined in [PrimaryDatabase].
///
/// This returns a SQL script with multiple DDL statements separated by `;`
/// using the specified [dialect].
///
/// Executing these statements in an empty database will create the tables
/// defined in [PrimaryDatabase]. In practice, this method is often used for
/// printing the DDL statements, such that migrations can be managed by
/// external tools.
///
/// [1]: https://en.wikipedia.org/wiki/Data_definition_language
String createPrimaryDatabaseTables(SqlDialect dialect) =>
    ExposedForCodeGen.createTableSchema(
      dialect: dialect,
      tables: PrimaryDatabaseSchema._$tables,
    );

final class _$User extends User {
  _$User._(
    this.userId,
    this.name,
    this.email,
  );

  @override
  final int userId;

  @override
  final String name;

  @override
  final String email;

  static const _$table = (
    tableName: 'users',
    columns: <String>['userId', 'name', 'email'],
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
    primaryKey: <String>['userId'],
    unique: <List<String>>[
      ['email']
    ],
    foreignKeys: <({
      String name,
      List<String> columns,
      String referencedTable,
      List<String> referencedColumns,
    })>[],
    readModel: _$User._$fromDatabase,
  );

  static User? _$fromDatabase(RowReader row) {
    final userId = row.readInt();
    final name = row.readString();
    final email = row.readString();
    if (userId == null && name == null && email == null) {
      return null;
    }
    return _$User._(userId!, name!, email!);
  }

  @override
  String toString() =>
      'User(userId: "$userId", name: "$name", email: "$email")';
}

/// Extension methods for table defined in [User].
extension TableUserExt on Table<User> {
  /// Insert row into the `users` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<User> insert({
    Expr<int>? userId,
    required Expr<String> name,
    required Expr<String> email,
  }) =>
      ExposedForCodeGen.insertInto(
        table: this,
        values: [
          userId,
          name,
          email,
        ],
      );

  /// Delete a single row from the `users` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => literal(true)).delete()`.
  DeleteSingle<User> delete(int userId) => ExposedForCodeGen.deleteSingle(
        byKey(userId),
        _$User._$table,
      );
}

/// Extension methods for building queries against the `users` table.
extension QueryUserExt on Query<(Expr<User>,)> {
  /// Lookup a single row in `users` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<User>,)> byKey(int userId) =>
      where((user) => user.userId.equalsLiteral(userId)).first;

  /// Update all rows in the `users` table matching this [Query].
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
  ///   .where((row) => row.value > literal(0))
  ///   .update((row, set) => set(
  ///     value: row.value - literal(1),
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  Update<User> update(
          UpdateSet<User> Function(
            Expr<User> user,
            UpdateSet<User> Function({
              Expr<int> userId,
              Expr<String> name,
              Expr<String> email,
            }) set,
          ) updateBuilder) =>
      ExposedForCodeGen.update<User>(
        this,
        _$User._$table,
        (user) => updateBuilder(
          user,
          ({
            Expr<int>? userId,
            Expr<String>? name,
            Expr<String>? email,
          }) =>
              ExposedForCodeGen.buildUpdate<User>([
            userId,
            name,
            email,
          ]),
        ),
      );

  /// Lookup a single row in `users` table using the
  /// `email` field.
  ///
  /// We know that lookup by the `email` field returns
  /// at-most one row because the `email` has an [Unique]
  /// annotation in [User].
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<User>,)> byEmail(String email) =>
      where((user) => user.email.equalsLiteral(email)).first;

  /// Delete all rows in the `users` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<User> delete() => ExposedForCodeGen.delete(this, _$User._$table);
}

/// Extension methods for building point queries against the `users` table.
extension QuerySingleUserExt on QuerySingle<(Expr<User>,)> {
  /// Update the row (if any) in the `users` table matching this
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
  ///     value: row.value - literal(1),
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  UpdateSingle<User> update(
          UpdateSet<User> Function(
            Expr<User> user,
            UpdateSet<User> Function({
              Expr<int> userId,
              Expr<String> name,
              Expr<String> email,
            }) set,
          ) updateBuilder) =>
      ExposedForCodeGen.updateSingle<User>(
        this,
        _$User._$table,
        (user) => updateBuilder(
          user,
          ({
            Expr<int>? userId,
            Expr<String>? name,
            Expr<String>? email,
          }) =>
              ExposedForCodeGen.buildUpdate<User>([
            userId,
            name,
            email,
          ]),
        ),
      );

  /// Delete the row (if any) in the `users` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<User> delete() =>
      ExposedForCodeGen.deleteSingle(this, _$User._$table);
}

/// Extension methods for expressions on a row in the `users` table.
extension ExpressionUserExt on Expr<User> {
  Expr<int> get userId =>
      ExposedForCodeGen.field(this, 0, ExposedForCodeGen.integer);

  Expr<String> get name =>
      ExposedForCodeGen.field(this, 1, ExposedForCodeGen.text);

  Expr<String> get email =>
      ExposedForCodeGen.field(this, 2, ExposedForCodeGen.text);

  /// Get [SubQuery] of rows from the `packages` table which
  /// reference [userId] in the `ownerId` field.
  ///
  /// This returns a [SubQuery] of [Package] rows,
  /// where [Package.ownerId] is references
  /// [User.userId] in this row.
  SubQuery<(Expr<Package>,)> get packages =>
      ExposedForCodeGen.subqueryTable(_$Package._$table)
          .where((r) => r.ownerId.equals(userId));
}

extension ExpressionNullableUserExt on Expr<User?> {
  Expr<int?> get userId =>
      ExposedForCodeGen.field(this, 0, ExposedForCodeGen.integer);

  Expr<String?> get name =>
      ExposedForCodeGen.field(this, 1, ExposedForCodeGen.text);

  Expr<String?> get email =>
      ExposedForCodeGen.field(this, 2, ExposedForCodeGen.text);

  /// Get [SubQuery] of rows from the `packages` table which
  /// reference [userId] in the `ownerId` field.
  ///
  /// This returns a [SubQuery] of [Package] rows,
  /// where [Package.ownerId] is references
  /// [User.userId] in this row, if any.
  ///
  /// If this row is `NULL` the subquery is always be empty.
  SubQuery<(Expr<Package>,)> get packages =>
      ExposedForCodeGen.subqueryTable(_$Package._$table)
          .where((r) => userId.isNotNull() & r.ownerId.equals(userId));

  /// Check if the row is not `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNotNull() => userId.isNotNull();

  /// Check if the row is `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNull() => isNotNull().not();
}

final class _$Package extends Package {
  _$Package._(
    this.packageName,
    this.likes,
    this.ownerId,
    this.publisher,
  );

  @override
  final String packageName;

  @override
  final int likes;

  @override
  final int ownerId;

  @override
  final String? publisher;

  static const _$table = (
    tableName: 'packages',
    columns: <String>['packageName', 'likes', 'ownerId', 'publisher'],
    columnInfo: <({
      ColumnType type,
      bool isNotNull,
      Object? defaultValue,
      bool autoIncrement,
    })>[
      (
        type: ExposedForCodeGen.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
      ),
      (
        type: ExposedForCodeGen.integer,
        isNotNull: true,
        defaultValue: 0,
        autoIncrement: false,
      ),
      (
        type: ExposedForCodeGen.integer,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
      ),
      (
        type: ExposedForCodeGen.text,
        isNotNull: false,
        defaultValue: null,
        autoIncrement: false,
      )
    ],
    primaryKey: <String>['packageName'],
    unique: <List<String>>[],
    foreignKeys: <({
      String name,
      List<String> columns,
      String referencedTable,
      List<String> referencedColumns,
    })>[
      (
        name: 'owner',
        columns: ['ownerId'],
        referencedTable: 'users',
        referencedColumns: ['userId'],
      )
    ],
    readModel: _$Package._$fromDatabase,
  );

  static Package? _$fromDatabase(RowReader row) {
    final packageName = row.readString();
    final likes = row.readInt();
    final ownerId = row.readInt();
    final publisher = row.readString();
    if (packageName == null &&
        likes == null &&
        ownerId == null &&
        publisher == null) {
      return null;
    }
    return _$Package._(packageName!, likes!, ownerId!, publisher);
  }

  @override
  String toString() =>
      'Package(packageName: "$packageName", likes: "$likes", ownerId: "$ownerId", publisher: "$publisher")';
}

/// Extension methods for table defined in [Package].
extension TablePackageExt on Table<Package> {
  /// Insert row into the `packages` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<Package> insert({
    required Expr<String> packageName,
    Expr<int>? likes,
    required Expr<int> ownerId,
    Expr<String?>? publisher,
  }) =>
      ExposedForCodeGen.insertInto(
        table: this,
        values: [
          packageName,
          likes,
          ownerId,
          publisher,
        ],
      );

  /// Delete a single row from the `packages` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => literal(true)).delete()`.
  DeleteSingle<Package> delete(String packageName) =>
      ExposedForCodeGen.deleteSingle(
        byKey(packageName),
        _$Package._$table,
      );
}

/// Extension methods for building queries against the `packages` table.
extension QueryPackageExt on Query<(Expr<Package>,)> {
  /// Lookup a single row in `packages` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<Package>,)> byKey(String packageName) =>
      where((package) => package.packageName.equalsLiteral(packageName)).first;

  /// Update all rows in the `packages` table matching this [Query].
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
  ///   .where((row) => row.value > literal(0))
  ///   .update((row, set) => set(
  ///     value: row.value - literal(1),
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  Update<Package> update(
          UpdateSet<Package> Function(
            Expr<Package> package,
            UpdateSet<Package> Function({
              Expr<String> packageName,
              Expr<int> likes,
              Expr<int> ownerId,
              Expr<String?> publisher,
            }) set,
          ) updateBuilder) =>
      ExposedForCodeGen.update<Package>(
        this,
        _$Package._$table,
        (package) => updateBuilder(
          package,
          ({
            Expr<String>? packageName,
            Expr<int>? likes,
            Expr<int>? ownerId,
            Expr<String?>? publisher,
          }) =>
              ExposedForCodeGen.buildUpdate<Package>([
            packageName,
            likes,
            ownerId,
            publisher,
          ]),
        ),
      );

  /// Delete all rows in the `packages` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<Package> delete() => ExposedForCodeGen.delete(this, _$Package._$table);
}

/// Extension methods for building point queries against the `packages` table.
extension QuerySinglePackageExt on QuerySingle<(Expr<Package>,)> {
  /// Update the row (if any) in the `packages` table matching this
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
  ///     value: row.value - literal(1),
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  UpdateSingle<Package> update(
          UpdateSet<Package> Function(
            Expr<Package> package,
            UpdateSet<Package> Function({
              Expr<String> packageName,
              Expr<int> likes,
              Expr<int> ownerId,
              Expr<String?> publisher,
            }) set,
          ) updateBuilder) =>
      ExposedForCodeGen.updateSingle<Package>(
        this,
        _$Package._$table,
        (package) => updateBuilder(
          package,
          ({
            Expr<String>? packageName,
            Expr<int>? likes,
            Expr<int>? ownerId,
            Expr<String?>? publisher,
          }) =>
              ExposedForCodeGen.buildUpdate<Package>([
            packageName,
            likes,
            ownerId,
            publisher,
          ]),
        ),
      );

  /// Delete the row (if any) in the `packages` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<Package> delete() =>
      ExposedForCodeGen.deleteSingle(this, _$Package._$table);
}

/// Extension methods for expressions on a row in the `packages` table.
extension ExpressionPackageExt on Expr<Package> {
  Expr<String> get packageName =>
      ExposedForCodeGen.field(this, 0, ExposedForCodeGen.text);

  Expr<int> get likes =>
      ExposedForCodeGen.field(this, 1, ExposedForCodeGen.integer);

  Expr<int> get ownerId =>
      ExposedForCodeGen.field(this, 2, ExposedForCodeGen.integer);

  Expr<String?> get publisher =>
      ExposedForCodeGen.field(this, 3, ExposedForCodeGen.text);

  /// Do a subquery lookup of the row from table
  /// `users` referenced in [ownerId].
  ///
  /// The gets the row from table `users` where
  /// [User.userId] is equal to
  /// [ownerId].
  Expr<User> get owner => ExposedForCodeGen.subqueryTable(_$User._$table)
      .where((r) => r.userId.equals(ownerId))
      .first
      .asNotNull();
}

extension ExpressionNullablePackageExt on Expr<Package?> {
  Expr<String?> get packageName =>
      ExposedForCodeGen.field(this, 0, ExposedForCodeGen.text);

  Expr<int?> get likes =>
      ExposedForCodeGen.field(this, 1, ExposedForCodeGen.integer);

  Expr<int?> get ownerId =>
      ExposedForCodeGen.field(this, 2, ExposedForCodeGen.integer);

  Expr<String?> get publisher =>
      ExposedForCodeGen.field(this, 3, ExposedForCodeGen.text);

  /// Do a subquery lookup of the row from table
  /// `users` referenced in [ownerId].
  ///
  /// The gets the row from table `users` where
  /// [User.userId] is equal to
  /// [ownerId], if any.
  ///
  /// If this row is `NULL` the subquery is always return `NULL`.
  Expr<User?> get owner => ExposedForCodeGen.subqueryTable(_$User._$table)
      .where((r) => ownerId.isNotNull() & r.userId.equals(ownerId))
      .first;

  /// Check if the row is not `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNotNull() => packageName.isNotNull();

  /// Check if the row is `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNull() => isNotNull().not();
}

final class _$Like extends Like {
  _$Like._(
    this.userId,
    this.packageName,
  );

  @override
  final int userId;

  @override
  final String packageName;

  static const _$table = (
    tableName: 'likes',
    columns: <String>['userId', 'packageName'],
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
        autoIncrement: false,
      ),
      (
        type: ExposedForCodeGen.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
      )
    ],
    primaryKey: <String>['userId', 'packageName'],
    unique: <List<String>>[],
    foreignKeys: <({
      String name,
      List<String> columns,
      String referencedTable,
      List<String> referencedColumns,
    })>[],
    readModel: _$Like._$fromDatabase,
  );

  static Like? _$fromDatabase(RowReader row) {
    final userId = row.readInt();
    final packageName = row.readString();
    if (userId == null && packageName == null) {
      return null;
    }
    return _$Like._(userId!, packageName!);
  }

  @override
  String toString() => 'Like(userId: "$userId", packageName: "$packageName")';
}

/// Extension methods for table defined in [Like].
extension TableLikeExt on Table<Like> {
  /// Insert row into the `likes` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<Like> insert({
    required Expr<int> userId,
    required Expr<String> packageName,
  }) =>
      ExposedForCodeGen.insertInto(
        table: this,
        values: [
          userId,
          packageName,
        ],
      );

  /// Delete a single row from the `likes` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => literal(true)).delete()`.
  DeleteSingle<Like> delete(
    int userId,
    String packageName,
  ) =>
      ExposedForCodeGen.deleteSingle(
        byKey(userId, packageName),
        _$Like._$table,
      );
}

/// Extension methods for building queries against the `likes` table.
extension QueryLikeExt on Query<(Expr<Like>,)> {
  /// Lookup a single row in `likes` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<Like>,)> byKey(
    int userId,
    String packageName,
  ) =>
      where((like) =>
          like.userId.equalsLiteral(userId) &
          like.packageName.equalsLiteral(packageName)).first;

  /// Update all rows in the `likes` table matching this [Query].
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
  ///   .where((row) => row.value > literal(0))
  ///   .update((row, set) => set(
  ///     value: row.value - literal(1),
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  Update<Like> update(
          UpdateSet<Like> Function(
            Expr<Like> like,
            UpdateSet<Like> Function({
              Expr<int> userId,
              Expr<String> packageName,
            }) set,
          ) updateBuilder) =>
      ExposedForCodeGen.update<Like>(
        this,
        _$Like._$table,
        (like) => updateBuilder(
          like,
          ({
            Expr<int>? userId,
            Expr<String>? packageName,
          }) =>
              ExposedForCodeGen.buildUpdate<Like>([
            userId,
            packageName,
          ]),
        ),
      );

  /// Delete all rows in the `likes` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<Like> delete() => ExposedForCodeGen.delete(this, _$Like._$table);
}

/// Extension methods for building point queries against the `likes` table.
extension QuerySingleLikeExt on QuerySingle<(Expr<Like>,)> {
  /// Update the row (if any) in the `likes` table matching this
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
  ///     value: row.value - literal(1),
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  UpdateSingle<Like> update(
          UpdateSet<Like> Function(
            Expr<Like> like,
            UpdateSet<Like> Function({
              Expr<int> userId,
              Expr<String> packageName,
            }) set,
          ) updateBuilder) =>
      ExposedForCodeGen.updateSingle<Like>(
        this,
        _$Like._$table,
        (like) => updateBuilder(
          like,
          ({
            Expr<int>? userId,
            Expr<String>? packageName,
          }) =>
              ExposedForCodeGen.buildUpdate<Like>([
            userId,
            packageName,
          ]),
        ),
      );

  /// Delete the row (if any) in the `likes` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<Like> delete() =>
      ExposedForCodeGen.deleteSingle(this, _$Like._$table);
}

/// Extension methods for expressions on a row in the `likes` table.
extension ExpressionLikeExt on Expr<Like> {
  Expr<int> get userId =>
      ExposedForCodeGen.field(this, 0, ExposedForCodeGen.integer);

  Expr<String> get packageName =>
      ExposedForCodeGen.field(this, 1, ExposedForCodeGen.text);
}

extension ExpressionNullableLikeExt on Expr<Like?> {
  Expr<int?> get userId =>
      ExposedForCodeGen.field(this, 0, ExposedForCodeGen.integer);

  Expr<String?> get packageName =>
      ExposedForCodeGen.field(this, 1, ExposedForCodeGen.text);

  /// Check if the row is not `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNotNull() => userId.isNotNull() & packageName.isNotNull();

  /// Check if the row is `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNull() => isNotNull().not();
}
