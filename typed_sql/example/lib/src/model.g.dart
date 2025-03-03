// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

extension PrimaryDatabaseSchema on DatabaseContext<PrimaryDatabase> {
  static const _$tables = [_$User._$table, _$Package._$table, _$Like._$table];

  /// TODO: Propagate documentation for tables!
  Table<User> get users => ExposedForCodeGen.declareTable(
        this,
        _$User._$table,
      );

  /// TODO: Propagate documentation for tables!
  Table<Package> get packages => ExposedForCodeGen.declareTable(
        this,
        _$Package._$table,
      );

  /// TODO: Propagate documentation for tables!
  Table<Like> get likes => ExposedForCodeGen.declareTable(
        this,
        _$Like._$table,
      );
  Future<void> createTables() async => ExposedForCodeGen.createTables(
        context: this,
        tables: _$tables,
      );
}

String createPrimaryDatabaseTables(SqlDialect dialect) =>
    ExposedForCodeGen.createTableSchema(
      dialect: dialect,
      tables: PrimaryDatabaseSchema._$tables,
    );

final class _$User extends User {
  _$User(RowReader row)
      : userId = row.readInt()!,
        name = row.readString()!,
        email = row.readString()!;

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
      Type type,
      bool isNotNull,
      Object? defaultValue,
      bool autoIncrement,
    })>[
      (
        type: int,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: true,
      ),
      (
        type: String,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
      ),
      (
        type: String,
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
    readModel: _$User.new,
  );

  @override
  String toString() =>
      'User(userId: "$userId", name: "$name", email: "$email")';
}

extension TableUserExt on Table<User> {
  /// TODO: document create
  Future<User> create({
    required int userId,
    required String name,
    required String email,
  }) =>
      ExposedForCodeGen.insertInto(
        table: this,
        values: [
          literal(userId),
          literal(name),
          literal(email),
        ],
      );

  /// TODO: document insert
  Future<User> insert({
    required Expr<int> userId,
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

  /// TODO: document delete
  Future<void> delete({required int userId}) => byKey(userId: userId).delete();
}

extension QueryUserExt on Query<(Expr<User>,)> {
  /// TODO: document lookup by PrimaryKey
  QuerySingle<(Expr<User>,)> byKey({required int userId}) =>
      where((user) => user.userId.equalsLiteral(userId)).first;

  /// TODO: document updateAll()
  Future<void> updateAll(
          Update<User> Function(
            Expr<User> user,
            Update<User> Function({
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

  /// TODO: document updateAllLiteral()
  /// WARNING: This cannot set properties to `null`!
  Future<void> updateAllLiteral({
    int? userId,
    String? name,
    String? email,
  }) =>
      ExposedForCodeGen.update<User>(
        this,
        _$User._$table,
        (user) => ExposedForCodeGen.buildUpdate<User>([
          userId != null ? literal(userId) : null,
          name != null ? literal(name) : null,
          email != null ? literal(email) : null,
        ]),
      );

  /// TODO: document byXXX()}
  QuerySingle<(Expr<User>,)> byEmail(String email) =>
      where((user) => user.email.equalsLiteral(email)).first;

  /// TODO: document delete()}
  Future<int> delete() => ExposedForCodeGen.delete(this, _$User._$table);
}

extension QuerySingleUserExt on QuerySingle<(Expr<User>,)> {
  /// TODO: document update()
  Future<void> update(
          Update<User> Function(
            Expr<User> user,
            Update<User> Function({
              Expr<int> userId,
              Expr<String> name,
              Expr<String> email,
            }) set,
          ) updateBuilder) =>
      ExposedForCodeGen.update<User>(
        asQuery,
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

  /// TODO: document updateLiteral()
  /// WARNING: This cannot set properties to `null`!
  Future<void> updateLiteral({
    int? userId,
    String? name,
    String? email,
  }) =>
      ExposedForCodeGen.update<User>(
        asQuery,
        _$User._$table,
        (user) => ExposedForCodeGen.buildUpdate<User>([
          userId != null ? literal(userId) : null,
          name != null ? literal(name) : null,
          email != null ? literal(email) : null,
        ]),
      );

  /// TODO: document delete()
  Future<int> delete() => asQuery.delete();
}

extension ExpressionUserExt on Expr<User> {
  /// TODO: document userId
  Expr<int> get userId => ExposedForCodeGen.field(this, 0);

  /// TODO: document name
  Expr<String> get name => ExposedForCodeGen.field(this, 1);

  /// TODO: document email
  Expr<String> get email => ExposedForCodeGen.field(this, 2);

  /// TODO: document references
  SubQuery<(Expr<Package>,)> get packages =>
      ExposedForCodeGen.subqueryTable(this, _$Package._$table)
          .where((r) => r.ownerId.equals(userId));
}

final class _$Package extends Package {
  _$Package(RowReader row)
      : packageName = row.readString()!,
        likes = row.readInt()!,
        ownerId = row.readInt()!,
        publisher = row.readString();

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
      Type type,
      bool isNotNull,
      Object? defaultValue,
      bool autoIncrement,
    })>[
      (
        type: String,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
      ),
      (
        type: int,
        isNotNull: true,
        defaultValue: 0,
        autoIncrement: false,
      ),
      (
        type: int,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
      ),
      (
        type: String,
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
    readModel: _$Package.new,
  );

  @override
  String toString() =>
      'Package(packageName: "$packageName", likes: "$likes", ownerId: "$ownerId", publisher: "$publisher")';
}

extension TablePackageExt on Table<Package> {
  /// TODO: document create
  Future<Package> create({
    required String packageName,
    required int likes,
    required int ownerId,
    required String? publisher,
  }) =>
      ExposedForCodeGen.insertInto(
        table: this,
        values: [
          literal(packageName),
          literal(likes),
          literal(ownerId),
          literal(publisher),
        ],
      );

  /// TODO: document insert
  Future<Package> insert({
    required Expr<String> packageName,
    required Expr<int> likes,
    required Expr<int> ownerId,
    required Expr<String?> publisher,
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

  /// TODO: document delete
  Future<void> delete({required String packageName}) =>
      byKey(packageName: packageName).delete();
}

extension QueryPackageExt on Query<(Expr<Package>,)> {
  /// TODO: document lookup by PrimaryKey
  QuerySingle<(Expr<Package>,)> byKey({required String packageName}) =>
      where((package) => package.packageName.equalsLiteral(packageName)).first;

  /// TODO: document updateAll()
  Future<void> updateAll(
          Update<Package> Function(
            Expr<Package> package,
            Update<Package> Function({
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

  /// TODO: document updateAllLiteral()
  /// WARNING: This cannot set properties to `null`!
  Future<void> updateAllLiteral({
    String? packageName,
    int? likes,
    int? ownerId,
    String? publisher,
  }) =>
      ExposedForCodeGen.update<Package>(
        this,
        _$Package._$table,
        (package) => ExposedForCodeGen.buildUpdate<Package>([
          packageName != null ? literal(packageName) : null,
          likes != null ? literal(likes) : null,
          ownerId != null ? literal(ownerId) : null,
          publisher != null ? literal(publisher) : null,
        ]),
      );

  /// TODO: document delete()}
  Future<int> delete() => ExposedForCodeGen.delete(this, _$Package._$table);
}

extension QuerySinglePackageExt on QuerySingle<(Expr<Package>,)> {
  /// TODO: document update()
  Future<void> update(
          Update<Package> Function(
            Expr<Package> package,
            Update<Package> Function({
              Expr<String> packageName,
              Expr<int> likes,
              Expr<int> ownerId,
              Expr<String?> publisher,
            }) set,
          ) updateBuilder) =>
      ExposedForCodeGen.update<Package>(
        asQuery,
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

  /// TODO: document updateLiteral()
  /// WARNING: This cannot set properties to `null`!
  Future<void> updateLiteral({
    String? packageName,
    int? likes,
    int? ownerId,
    String? publisher,
  }) =>
      ExposedForCodeGen.update<Package>(
        asQuery,
        _$Package._$table,
        (package) => ExposedForCodeGen.buildUpdate<Package>([
          packageName != null ? literal(packageName) : null,
          likes != null ? literal(likes) : null,
          ownerId != null ? literal(ownerId) : null,
          publisher != null ? literal(publisher) : null,
        ]),
      );

  /// TODO: document delete()
  Future<int> delete() => asQuery.delete();
}

extension ExpressionPackageExt on Expr<Package> {
  /// TODO: document packageName
  Expr<String> get packageName => ExposedForCodeGen.field(this, 0);

  /// TODO: document likes
  Expr<int> get likes => ExposedForCodeGen.field(this, 1);

  /// TODO: document ownerId
  Expr<int> get ownerId => ExposedForCodeGen.field(this, 2);

  /// TODO: document publisher
  Expr<String?> get publisher => ExposedForCodeGen.field(this, 3);

  /// TODO: document references
  Expr<User> get owner => ExposedForCodeGen.subqueryTable(this, _$User._$table)
      .where((r) => r.userId.equals(ownerId))
      .first
      .assertNotNull();
}

final class _$Like extends Like {
  _$Like(RowReader row)
      : userId = row.readInt()!,
        packageName = row.readString()!;

  @override
  final int userId;

  @override
  final String packageName;

  static const _$table = (
    tableName: 'likes',
    columns: <String>['userId', 'packageName'],
    columnInfo: <({
      Type type,
      bool isNotNull,
      Object? defaultValue,
      bool autoIncrement,
    })>[
      (
        type: int,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
      ),
      (
        type: String,
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
    readModel: _$Like.new,
  );

  @override
  String toString() => 'Like(userId: "$userId", packageName: "$packageName")';
}

extension TableLikeExt on Table<Like> {
  /// TODO: document create
  Future<Like> create({
    required int userId,
    required String packageName,
  }) =>
      ExposedForCodeGen.insertInto(
        table: this,
        values: [
          literal(userId),
          literal(packageName),
        ],
      );

  /// TODO: document insert
  Future<Like> insert({
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

  /// TODO: document delete
  Future<void> delete({
    required int userId,
    required String packageName,
  }) =>
      byKey(
        userId: userId,
        packageName: packageName,
      ).delete();
}

extension QueryLikeExt on Query<(Expr<Like>,)> {
  /// TODO: document lookup by PrimaryKey
  QuerySingle<(Expr<Like>,)> byKey({
    required int userId,
    required String packageName,
  }) =>
      where((like) => like.userId
          .equalsLiteral(userId)
          .and(like.packageName.equalsLiteral(packageName))).first;

  /// TODO: document updateAll()
  Future<void> updateAll(
          Update<Like> Function(
            Expr<Like> like,
            Update<Like> Function({
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

  /// TODO: document updateAllLiteral()
  /// WARNING: This cannot set properties to `null`!
  Future<void> updateAllLiteral({
    int? userId,
    String? packageName,
  }) =>
      ExposedForCodeGen.update<Like>(
        this,
        _$Like._$table,
        (like) => ExposedForCodeGen.buildUpdate<Like>([
          userId != null ? literal(userId) : null,
          packageName != null ? literal(packageName) : null,
        ]),
      );

  /// TODO: document delete()}
  Future<int> delete() => ExposedForCodeGen.delete(this, _$Like._$table);
}

extension QuerySingleLikeExt on QuerySingle<(Expr<Like>,)> {
  /// TODO: document update()
  Future<void> update(
          Update<Like> Function(
            Expr<Like> like,
            Update<Like> Function({
              Expr<int> userId,
              Expr<String> packageName,
            }) set,
          ) updateBuilder) =>
      ExposedForCodeGen.update<Like>(
        asQuery,
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

  /// TODO: document updateLiteral()
  /// WARNING: This cannot set properties to `null`!
  Future<void> updateLiteral({
    int? userId,
    String? packageName,
  }) =>
      ExposedForCodeGen.update<Like>(
        asQuery,
        _$Like._$table,
        (like) => ExposedForCodeGen.buildUpdate<Like>([
          userId != null ? literal(userId) : null,
          packageName != null ? literal(packageName) : null,
        ]),
      );

  /// TODO: document delete()
  Future<int> delete() => asQuery.delete();
}

extension ExpressionLikeExt on Expr<Like> {
  /// TODO: document userId
  Expr<int> get userId => ExposedForCodeGen.field(this, 0);

  /// TODO: document packageName
  Expr<String> get packageName => ExposedForCodeGen.field(this, 1);
}
