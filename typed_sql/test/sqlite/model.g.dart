// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

/// Extension methods for a [Database] operating on [PrimaryDatabase].
extension PrimaryDatabaseSchema on Database<PrimaryDatabase> {
  static const _$tables = [_$User._$table, _$Package._$table, _$Like._$table];

  Table<User> get users => $ForGeneratedCode.declareTable(
        this,
        _$User._$table,
      );

  Table<Package> get packages => $ForGeneratedCode.declareTable(
        this,
        _$Package._$table,
      );

  Table<Like> get likes => $ForGeneratedCode.declareTable(
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
  Future<void> createTables() async => $ForGeneratedCode.createTables(
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
    $ForGeneratedCode.createTableSchema(
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
        overrides: <SqlOverride>[],
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
    readRow: _$User._$fromDatabase,
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
      $ForGeneratedCode.insertInto(
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
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<User> delete(int userId) => $ForGeneratedCode.deleteSingle(
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
      where((user) => user.userId.equalsValue(userId)).first;

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
  Update<User> update(
          UpdateSet<User> Function(
            Expr<User> user,
            UpdateSet<User> Function({
              Expr<int> userId,
              Expr<String> name,
              Expr<String> email,
            }) set,
          ) updateBuilder) =>
      $ForGeneratedCode.update<User>(
        this,
        _$User._$table,
        (user) => updateBuilder(
          user,
          ({
            Expr<int>? userId,
            Expr<String>? name,
            Expr<String>? email,
          }) =>
              $ForGeneratedCode.buildUpdate<User>([
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
      where((user) => user.email.equalsValue(email)).first;

  /// Delete all rows in the `users` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<User> delete() => $ForGeneratedCode.delete(this, _$User._$table);
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
  UpdateSingle<User> update(
          UpdateSet<User> Function(
            Expr<User> user,
            UpdateSet<User> Function({
              Expr<int> userId,
              Expr<String> name,
              Expr<String> email,
            }) set,
          ) updateBuilder) =>
      $ForGeneratedCode.updateSingle<User>(
        this,
        _$User._$table,
        (user) => updateBuilder(
          user,
          ({
            Expr<int>? userId,
            Expr<String>? name,
            Expr<String>? email,
          }) =>
              $ForGeneratedCode.buildUpdate<User>([
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
      $ForGeneratedCode.deleteSingle(this, _$User._$table);
}

/// Extension methods for expressions on a row in the `users` table.
extension ExpressionUserExt on Expr<User> {
  Expr<int> get userId =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  /// Name of the user
  ///
  /// This is the fullname.
  Expr<String> get name =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  /// The users email address, not verified, by provided from OIDC.
  Expr<String> get email =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  /// Get [SubQuery] of rows from the `packages` table which
  /// reference this row.
  ///
  /// This returns a [SubQuery] of [Package] rows,
  /// where [Package.ownerId]
  /// references [User.userId]
  /// in this row.
  SubQuery<(Expr<Package>,)> get packages => $ForGeneratedCode
      .subqueryTable(_$Package._$table)
      .where((r) => r.ownerId.equals(userId));
}

extension ExpressionNullableUserExt on Expr<User?> {
  Expr<int?> get userId =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  /// Name of the user
  ///
  /// This is the fullname.
  Expr<String?> get name =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  /// The users email address, not verified, by provided from OIDC.
  Expr<String?> get email =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  /// Get [SubQuery] of rows from the `packages` table which
  /// reference this row.
  ///
  /// This returns a [SubQuery] of [Package] rows,
  /// where [Package.ownerId]
  /// references [User.userId]
  /// in this row, if any.
  ///
  /// If this row is `NULL` the subquery is always be empty.
  SubQuery<(Expr<Package>,)> get packages => $ForGeneratedCode
      .subqueryTable(_$Package._$table)
      .where((r) => r.ownerId.equalsUnlessNull(userId).asNotNull());

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

extension InnerJoinUserPackageExt
    on InnerJoin<(Expr<User>,), (Expr<Package>,)> {
  /// Join using the `owner` _foreign key_.
  ///
  /// This will match rows where [User.userId] = [Package.ownerId].
  Query<(Expr<User>, Expr<Package>)> usingOwner() =>
      on((a, b) => a.userId.equals(b.ownerId));
}

extension LeftJoinUserPackageExt on LeftJoin<(Expr<User>,), (Expr<Package>,)> {
  /// Join using the `owner` _foreign key_.
  ///
  /// This will match rows where [User.userId] = [Package.ownerId].
  Query<(Expr<User>, Expr<Package?>)> usingOwner() =>
      on((a, b) => a.userId.equals(b.ownerId));
}

extension RightJoinUserPackageExt
    on RightJoin<(Expr<User>,), (Expr<Package>,)> {
  /// Join using the `owner` _foreign key_.
  ///
  /// This will match rows where [User.userId] = [Package.ownerId].
  Query<(Expr<User?>, Expr<Package>)> usingOwner() =>
      on((a, b) => a.userId.equals(b.ownerId));
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
      List<SqlOverride> overrides,
    })>[
      (
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: <SqlOverride>[],
      ),
      (
        type: $ForGeneratedCode.integer,
        isNotNull: true,
        defaultValue: (kind: 'raw', value: 0),
        autoIncrement: false,
        overrides: <SqlOverride>[],
      ),
      (
        type: $ForGeneratedCode.integer,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: <SqlOverride>[],
      ),
      (
        type: $ForGeneratedCode.text,
        isNotNull: false,
        defaultValue: null,
        autoIncrement: false,
        overrides: <SqlOverride>[],
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
    readRow: _$Package._$fromDatabase,
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
      $ForGeneratedCode.insertInto(
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
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<Package> delete(String packageName) =>
      $ForGeneratedCode.deleteSingle(
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
      where((package) => package.packageName.equalsValue(packageName)).first;

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
      $ForGeneratedCode.update<Package>(
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
              $ForGeneratedCode.buildUpdate<Package>([
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
  Delete<Package> delete() => $ForGeneratedCode.delete(this, _$Package._$table);
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
      $ForGeneratedCode.updateSingle<Package>(
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
              $ForGeneratedCode.buildUpdate<Package>([
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
      $ForGeneratedCode.deleteSingle(this, _$Package._$table);
}

/// Extension methods for expressions on a row in the `packages` table.
extension ExpressionPackageExt on Expr<Package> {
  Expr<String> get packageName =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.text);

  Expr<int> get likes =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.integer);

  Expr<int> get ownerId =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.integer);

  Expr<String?> get publisher =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.text);

  /// Do a subquery lookup of the row from table
  /// `users` referenced in
  /// [ownerId].
  ///
  /// The gets the row from table `users` where
  /// [User.userId]
  /// is equal to [ownerId].
  Expr<User> get owner => $ForGeneratedCode
      .subqueryTable(_$User._$table)
      .where((r) => r.userId.equals(ownerId))
      .first
      .asNotNull();
}

extension ExpressionNullablePackageExt on Expr<Package?> {
  Expr<String?> get packageName =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.text);

  Expr<int?> get likes =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.integer);

  Expr<int?> get ownerId =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.integer);

  Expr<String?> get publisher =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.text);

  /// Do a subquery lookup of the row from table
  /// `users` referenced in
  /// [ownerId].
  ///
  /// The gets the row from table `users` where
  /// [User.userId]
  /// is equal to [ownerId], if any.
  ///
  /// If this row is `NULL` the subquery is always return `NULL`.
  Expr<User?> get owner => $ForGeneratedCode
      .subqueryTable(_$User._$table)
      .where((r) => r.userId.equalsUnlessNull(ownerId).asNotNull())
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

extension InnerJoinPackageUserExt
    on InnerJoin<(Expr<Package>,), (Expr<User>,)> {
  /// Join using the `owner` _foreign key_.
  ///
  /// This will match rows where [Package.ownerId] = [User.userId].
  Query<(Expr<Package>, Expr<User>)> usingOwner() =>
      on((a, b) => b.userId.equals(a.ownerId));
}

extension LeftJoinPackageUserExt on LeftJoin<(Expr<Package>,), (Expr<User>,)> {
  /// Join using the `owner` _foreign key_.
  ///
  /// This will match rows where [Package.ownerId] = [User.userId].
  Query<(Expr<Package>, Expr<User?>)> usingOwner() =>
      on((a, b) => b.userId.equals(a.ownerId));
}

extension RightJoinPackageUserExt
    on RightJoin<(Expr<Package>,), (Expr<User>,)> {
  /// Join using the `owner` _foreign key_.
  ///
  /// This will match rows where [Package.ownerId] = [User.userId].
  Query<(Expr<Package?>, Expr<User>)> usingOwner() =>
      on((a, b) => b.userId.equals(a.ownerId));
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
      List<SqlOverride> overrides,
    })>[
      (
        type: $ForGeneratedCode.integer,
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
        overrides: <SqlOverride>[],
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
    readRow: _$Like._$fromDatabase,
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
      $ForGeneratedCode.insertInto(
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
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<Like> delete(
    int userId,
    String packageName,
  ) =>
      $ForGeneratedCode.deleteSingle(
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
          like.userId.equalsValue(userId) &
          like.packageName.equalsValue(packageName)).first;

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
  Update<Like> update(
          UpdateSet<Like> Function(
            Expr<Like> like,
            UpdateSet<Like> Function({
              Expr<int> userId,
              Expr<String> packageName,
            }) set,
          ) updateBuilder) =>
      $ForGeneratedCode.update<Like>(
        this,
        _$Like._$table,
        (like) => updateBuilder(
          like,
          ({
            Expr<int>? userId,
            Expr<String>? packageName,
          }) =>
              $ForGeneratedCode.buildUpdate<Like>([
            userId,
            packageName,
          ]),
        ),
      );

  /// Delete all rows in the `likes` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<Like> delete() => $ForGeneratedCode.delete(this, _$Like._$table);
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
  UpdateSingle<Like> update(
          UpdateSet<Like> Function(
            Expr<Like> like,
            UpdateSet<Like> Function({
              Expr<int> userId,
              Expr<String> packageName,
            }) set,
          ) updateBuilder) =>
      $ForGeneratedCode.updateSingle<Like>(
        this,
        _$Like._$table,
        (like) => updateBuilder(
          like,
          ({
            Expr<int>? userId,
            Expr<String>? packageName,
          }) =>
              $ForGeneratedCode.buildUpdate<Like>([
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
      $ForGeneratedCode.deleteSingle(this, _$Like._$table);
}

/// Extension methods for expressions on a row in the `likes` table.
extension ExpressionLikeExt on Expr<Like> {
  Expr<int> get userId =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String> get packageName =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);
}

extension ExpressionNullableLikeExt on Expr<Like?> {
  Expr<int?> get userId =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String?> get packageName =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

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

/// Extension methods for building queries projected to a named record.
extension QueryOwnerPackageNamed<A, B> on Query<
    ({
      Expr<A> owner,
      Expr<B> package,
    })> {
  Query<(Expr<A>, Expr<B>)> get _asPositionalQuery =>
      $ForGeneratedCode.renamedRecord(
          this,
          (e) => (
                e.owner,
                e.package,
              ));

  static Query<
      ({
        Expr<A> owner,
        Expr<B> package,
      })> _fromPositionalQuery<A, B>(
          Query<(Expr<A>, Expr<B>)> query) =>
      $ForGeneratedCode.renamedRecord(
          query,
          (e) => (
                owner: e.$1,
                package: e.$2,
              ));

  static T Function(Expr<A> a, Expr<B> b) _wrapBuilder<T, A, B>(
          T Function(
                  ({
                    Expr<A> owner,
                    Expr<B> package,
                  }) e)
              builder) =>
      (a, b) => builder((
            owner: a,
            package: b,
          ));

  /// Query the database for rows in this [Query] as a [Stream].
  Stream<
      ({
        A owner,
        B package,
      })> stream() async* {
    yield* _asPositionalQuery.stream().map((e) => (
          owner: e.$1,
          package: e.$2,
        ));
  }

  /// Query the database for rows in this [Query] as a [List].
  Future<
      List<
          ({
            A owner,
            B package,
          })>> fetch() async => await stream().toList();

  /// Offset [Query] using `OFFSET` clause.
  ///
  /// The resulting [Query] will skip the first [offset] rows.
  Query<
      ({
        Expr<A> owner,
        Expr<B> package,
      })> offset(
          int offset) =>
      _fromPositionalQuery(_asPositionalQuery.offset(offset));

  /// Limit [Query] using `LIMIT` clause.
  ///
  /// The resulting [Query] will only return the first [limit] rows.
  Query<
      ({
        Expr<A> owner,
        Expr<B> package,
      })> limit(
          int limit) =>
      _fromPositionalQuery(_asPositionalQuery.limit(limit));

  /// Create a projection of this [Query] using `SELECT` clause.
  ///
  /// The [projectionBuilder] **must** return a [Record] where all the
  /// values are [Expr] objects. If something else is returned you will
  /// get a [Query] object which doesn't have any methods!
  ///
  /// All methods and properties on [Query<T>] are extension methods and
  /// they are only defined for records `T` where all the values are
  /// [Expr] objects.
  Query<T> select<T extends Record>(
          T Function(
                  ({
                    Expr<A> owner,
                    Expr<B> package,
                  }) expr)
              projectionBuilder) =>
      _asPositionalQuery.select(_wrapBuilder(projectionBuilder));

  /// Filter [Query] using `WHERE` clause.
  ///
  /// Returns a [Query] retaining rows from this [Query] where the expression
  /// returned by [conditionBuilder] evaluates to `true`.
  Query<
      ({
        Expr<A> owner,
        Expr<B> package,
      })> where(
          Expr<bool> Function(
                  ({
                    Expr<A> owner,
                    Expr<B> package,
                  }) expr)
              conditionBuilder) =>
      _fromPositionalQuery(
          _asPositionalQuery.where(_wrapBuilder(conditionBuilder)));
}
