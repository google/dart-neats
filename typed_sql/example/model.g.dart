// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

extension PrimaryDatabaseSchema on DatabaseContext<PrimaryDatabase> {
  static const _$tables = [
    (
      tableName: 'users',
      columns: <({
        String name,
        Type type,
        bool isNotNull,
        Object? defaultValue,
        bool autoIncrement,
      })>[
        (
          name: 'userId',
          type: int,
          isNotNull: true,
          defaultValue: null,
          autoIncrement: false,
        ),
        (
          name: 'email',
          type: String,
          isNotNull: true,
          defaultValue: null,
          autoIncrement: false,
        )
      ],
      primaryKey: _$User._$primaryKey,
      unique: <List<String>>[
        ['email']
      ],
      foreignKeys: <({
        String name,
        List<String> columns,
        String referencedTable,
        List<String> referencedColumns,
      })>[],
    ),
    (
      tableName: 'likes',
      columns: <({
        String name,
        Type type,
        bool isNotNull,
        Object? defaultValue,
        bool autoIncrement,
      })>[
        (
          name: 'userId',
          type: int,
          isNotNull: true,
          defaultValue: null,
          autoIncrement: false,
        ),
        (
          name: 'packageName',
          type: String,
          isNotNull: true,
          defaultValue: null,
          autoIncrement: false,
        )
      ],
      primaryKey: _$Like._$primaryKey,
      unique: <List<String>>[],
      foreignKeys: <({
        String name,
        List<String> columns,
        String referencedTable,
        List<String> referencedColumns,
      })>[],
    ),
    (
      tableName: 'packages',
      columns: <({
        String name,
        Type type,
        bool isNotNull,
        Object? defaultValue,
        bool autoIncrement,
      })>[
        (
          name: 'name',
          type: String,
          isNotNull: true,
          defaultValue: null,
          autoIncrement: false,
        )
      ],
      primaryKey: _$Package._$primaryKey,
      unique: <List<String>>[],
      foreignKeys: <({
        String name,
        List<String> columns,
        String referencedTable,
        List<String> referencedColumns,
      })>[],
    ),
  ];

  /// TODO: Propagate documentation for tables!
  Table<User> get users => ExposedForCodeGen.declareTable(
        context: this,
        tableName: 'users',
        columns: _$User._$fields,
        primaryKey: _$User._$primaryKey,
        deserialize: _$User.new,
      );

  /// TODO: Propagate documentation for tables!
  Table<Like> get likes => ExposedForCodeGen.declareTable(
        context: this,
        tableName: 'likes',
        columns: _$Like._$fields,
        primaryKey: _$Like._$primaryKey,
        deserialize: _$Like.new,
      );

  /// TODO: Propagate documentation for tables!
  Table<Package> get packages => ExposedForCodeGen.declareTable(
        context: this,
        tableName: 'packages',
        columns: _$Package._$fields,
        primaryKey: _$Package._$primaryKey,
        deserialize: _$Package.new,
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
        email = row.readString()!;

  @override
  final int userId;

  @override
  final String email;

  static const _$fields = [
    'userId',
    'email',
  ];

  static const _$primaryKey = ['userId'];

  @override
  String toString() => 'User(userId: "$userId", email: "$email")';
}

extension TableUserExt on Table<User> {
  /// TODO: document create
  Future<User> create({
    required int userId,
    required String email,
  }) =>
      ExposedForCodeGen.insertInto(
        table: this,
        values: [
          literal(userId),
          literal(email),
        ],
      );

  /// TODO: document insert
  Future<User> insert({
    required Expr<int> userId,
    required Expr<String> email,
  }) =>
      ExposedForCodeGen.insertInto(
        table: this,
        values: [
          userId,
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
              Expr<String> email,
            }) set,
          ) updateBuilder) =>
      ExposedForCodeGen.update<User>(
        this,
        (user) => updateBuilder(
          user,
          ({
            Expr<int>? userId,
            Expr<String>? email,
          }) =>
              ExposedForCodeGen.buildUpdate<User>([
            userId,
            email,
          ]),
        ),
      );

  /// TODO: document updateAllLiteral()
  /// WARNING: This cannot set properties to `null`!
  Future<void> updateAllLiteral({
    int? userId,
    String? email,
  }) =>
      ExposedForCodeGen.update<User>(
        this,
        (user) => ExposedForCodeGen.buildUpdate<User>([
          userId != null ? literal(userId) : null,
          email != null ? literal(email) : null,
        ]),
      );

  /// TODO: document byXXX()}
  QuerySingle<(Expr<User>,)> byEmail(String email) =>
      where((user) => user.email.equalsLiteral(email)).first;
}

extension QuerySingleUserExt on QuerySingle<(Expr<User>,)> {
  /// TODO: document update()
  Future<void> update(
          Update<User> Function(
            Expr<User> user,
            Update<User> Function({
              Expr<int> userId,
              Expr<String> email,
            }) set,
          ) updateBuilder) =>
      ExposedForCodeGen.update<User>(
        asQuery,
        (user) => updateBuilder(
          user,
          ({
            Expr<int>? userId,
            Expr<String>? email,
          }) =>
              ExposedForCodeGen.buildUpdate<User>([
            userId,
            email,
          ]),
        ),
      );

  /// TODO: document updateLiteral()
  /// WARNING: This cannot set properties to `null`!
  Future<void> updateLiteral({
    int? userId,
    String? email,
  }) =>
      ExposedForCodeGen.update<User>(
        asQuery,
        (user) => ExposedForCodeGen.buildUpdate<User>([
          userId != null ? literal(userId) : null,
          email != null ? literal(email) : null,
        ]),
      );
}

extension ExpressionUserExt on Expr<User> {
  /// TODO: document userId
  Expr<int> get userId => ExposedForCodeGen.field(this, 0);

  /// TODO: document email
  Expr<String> get email => ExposedForCodeGen.field(this, 1);
}

final class _$Package extends Package {
  _$Package(RowReader row) : name = row.readString()!;

  @override
  final String name;

  static const _$fields = ['name'];

  static const _$primaryKey = ['name'];

  @override
  String toString() => 'Package(name: "$name")';
}

extension TablePackageExt on Table<Package> {
  /// TODO: document create
  Future<Package> create({required String name}) =>
      ExposedForCodeGen.insertInto(
        table: this,
        values: [
          literal(name),
        ],
      );

  /// TODO: document insert
  Future<Package> insert({required Expr<String> name}) =>
      ExposedForCodeGen.insertInto(
        table: this,
        values: [
          name,
        ],
      );

  /// TODO: document delete
  Future<void> delete({required String name}) => byKey(name: name).delete();
}

extension QueryPackageExt on Query<(Expr<Package>,)> {
  /// TODO: document lookup by PrimaryKey
  QuerySingle<(Expr<Package>,)> byKey({required String name}) =>
      where((package) => package.name.equalsLiteral(name)).first;

  /// TODO: document updateAll()
  Future<void> updateAll(
          Update<Package> Function(
            Expr<Package> package,
            Update<Package> Function({
              Expr<String> name,
            }) set,
          ) updateBuilder) =>
      ExposedForCodeGen.update<Package>(
        this,
        (package) => updateBuilder(
          package,
          ({
            Expr<String>? name,
          }) =>
              ExposedForCodeGen.buildUpdate<Package>([
            name,
          ]),
        ),
      );

  /// TODO: document updateAllLiteral()
  /// WARNING: This cannot set properties to `null`!
  Future<void> updateAllLiteral({String? name}) =>
      ExposedForCodeGen.update<Package>(
        this,
        (package) => ExposedForCodeGen.buildUpdate<Package>([
          name != null ? literal(name) : null,
        ]),
      );
}

extension QuerySinglePackageExt on QuerySingle<(Expr<Package>,)> {
  /// TODO: document update()
  Future<void> update(
          Update<Package> Function(
            Expr<Package> package,
            Update<Package> Function({
              Expr<String> name,
            }) set,
          ) updateBuilder) =>
      ExposedForCodeGen.update<Package>(
        asQuery,
        (package) => updateBuilder(
          package,
          ({
            Expr<String>? name,
          }) =>
              ExposedForCodeGen.buildUpdate<Package>([
            name,
          ]),
        ),
      );

  /// TODO: document updateLiteral()
  /// WARNING: This cannot set properties to `null`!
  Future<void> updateLiteral({String? name}) =>
      ExposedForCodeGen.update<Package>(
        asQuery,
        (package) => ExposedForCodeGen.buildUpdate<Package>([
          name != null ? literal(name) : null,
        ]),
      );
}

extension ExpressionPackageExt on Expr<Package> {
  /// TODO: document name
  Expr<String> get name => ExposedForCodeGen.field(this, 0);
}

final class _$Like extends Like {
  _$Like(RowReader row)
      : userId = row.readInt()!,
        packageName = row.readString()!;

  @override
  final int userId;

  @override
  final String packageName;

  static const _$fields = [
    'userId',
    'packageName',
  ];

  static const _$primaryKey = [
    'userId',
    'packageName',
  ];

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
        (like) => ExposedForCodeGen.buildUpdate<Like>([
          userId != null ? literal(userId) : null,
          packageName != null ? literal(packageName) : null,
        ]),
      );
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
        (like) => ExposedForCodeGen.buildUpdate<Like>([
          userId != null ? literal(userId) : null,
          packageName != null ? literal(packageName) : null,
        ]),
      );
}

extension ExpressionLikeExt on Expr<Like> {
  /// TODO: document userId
  Expr<int> get userId => ExposedForCodeGen.field(this, 0);

  /// TODO: document packageName
  Expr<String> get packageName => ExposedForCodeGen.field(this, 1);
}
