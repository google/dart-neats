// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

extension PrimaryDatabaseSchema on DatabaseContext<PrimaryDatabase> {
  /// TODO: Propagate documentation for tables!
  Table<User> get users => ExposedForCodeGen.declareTable(
        context: this,
        tableName: 'users',
        columns: _$User._$fields,
        deserialize: _$User._$deserialize,
      );

  /// TODO: Propagate documentation for tables!
  Table<Like> get likes => ExposedForCodeGen.declareTable(
        context: this,
        tableName: 'likes',
        columns: _$Like._$fields,
        deserialize: _$Like._$deserialize,
      );

  /// TODO: Propagate documentation for tables!
  Table<Package> get packages => ExposedForCodeGen.declareTable(
        context: this,
        tableName: 'packages',
        columns: _$Package._$fields,
        deserialize: _$Package._$deserialize,
      );
}

final class _$User extends User {
  _$User(
    this._$userId,
    this._$email,
  );

  final int? _$userId;

  final String? _$email;

  static const _$fields = [
    'userId',
    'email',
  ];

  static User _$deserialize(List<Object?> fields) => _$User(
        (fields[0] as int?),
        (fields[1] as String?),
      );

  @override
  int get userId {
    final value = _$userId;
    if (value == null) {
      throw StateError('Query did not fetch "userId"');
    }
    return value;
  }

  @override
  String get email {
    final value = _$email;
    if (value == null) {
      throw StateError('Query did not fetch "email"');
    }
    return value;
  }

  @override
  String toString() => 'User(userId: "${_$userId}", email: "${_$email}")';
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
          userId,
          email,
        ],
      );

  /// TODO: document delete
  Future<void> delete({required int userId}) => byKey(userId: userId).delete();
}

extension QueryUserExt on Query<User> {
  /// TODO: document lookup by PrimaryKey
  QuerySingle<User> byKey({required int userId}) =>
      where((user) => user.userId.equals.literal(userId)).first;

  /// TODO: document where()
  Query<User> where(Expr<bool> Function(Expr<User> user) conditionBuilder) =>
      ExposedForCodeGen.where(this, conditionBuilder);

  /// TODO: document orderBy()
  Query<User> orderBy(
    Expr Function(Expr<User> user) fieldBuilder, {
    bool descending = false,
  }) =>
      ExposedForCodeGen.orderBy(this, fieldBuilder, descending: descending);

  /// TODO: document select()
  Query<User> select({
    bool userId = false,
    bool email = false,
  }) =>
      ExposedForCodeGen.select(this, [userId, email]);

  /// TODO: document updateAll()
  Future<void> updateAll({
    int? userId,
    String? email,
  }) =>
      ExposedForCodeGen.update(this, [userId, email]);

  /// TODO: document byXXX()}
  QuerySingle<User> byEmail(String email) =>
      where((user) => user.email.equals.literal(email)).first;
}

extension QuerySingleUserExt on QuerySingle<User> {
  /// TODO document select()
  QuerySingle<User> select({
    bool userId = false,
    bool email = false,
  }) =>
      ExposedForCodeGen.select(asQuery, [userId, email]).first;

  /// TODO document update()
  Future<void> update({
    int? userId,
    String? email,
  }) =>
      ExposedForCodeGen.update(asQuery, [userId, email]);

  /// TODO document where()
  QuerySingle<User> where(
          Expr<bool> Function(Expr<User> user) conditionBuilder) =>
      ExposedForCodeGen.where(asQuery, conditionBuilder).first;
}

extension ExpressionUserExt on Expr<User> {
  /// TODO: document userId
  Expr<int> get userId => ExposedForCodeGen.field(this, 'userId');

  /// TODO: document email
  Expr<String> get email => ExposedForCodeGen.field(this, 'email');
}

final class _$Package extends Package {
  _$Package(this._$name);

  final String? _$name;

  static const _$fields = ['name'];

  static Package _$deserialize(List<Object?> fields) =>
      _$Package((fields[0] as String?));

  @override
  String get name {
    final value = _$name;
    if (value == null) {
      throw StateError('Query did not fetch "name"');
    }
    return value;
  }

  @override
  String toString() => 'Package(name: "${_$name}")';
}

extension TablePackageExt on Table<Package> {
  /// TODO: document create
  Future<Package> create({required String name}) =>
      ExposedForCodeGen.insertInto(
        table: this,
        values: [name],
      );

  /// TODO: document delete
  Future<void> delete({required String name}) => byKey(name: name).delete();
}

extension QueryPackageExt on Query<Package> {
  /// TODO: document lookup by PrimaryKey
  QuerySingle<Package> byKey({required String name}) =>
      where((package) => package.name.equals.literal(name)).first;

  /// TODO: document where()
  Query<Package> where(
          Expr<bool> Function(Expr<Package> package) conditionBuilder) =>
      ExposedForCodeGen.where(this, conditionBuilder);

  /// TODO: document orderBy()
  Query<Package> orderBy(
    Expr Function(Expr<Package> package) fieldBuilder, {
    bool descending = false,
  }) =>
      ExposedForCodeGen.orderBy(this, fieldBuilder, descending: descending);

  /// TODO: document select()
  Query<Package> select({bool name = false}) =>
      ExposedForCodeGen.select(this, [name]);

  /// TODO: document updateAll()
  Future<void> updateAll({String? name}) =>
      ExposedForCodeGen.update(this, [name]);
}

extension QuerySinglePackageExt on QuerySingle<Package> {
  /// TODO document select()
  QuerySingle<Package> select({bool name = false}) =>
      ExposedForCodeGen.select(asQuery, [name]).first;

  /// TODO document update()
  Future<void> update({String? name}) =>
      ExposedForCodeGen.update(asQuery, [name]);

  /// TODO document where()
  QuerySingle<Package> where(
          Expr<bool> Function(Expr<Package> package) conditionBuilder) =>
      ExposedForCodeGen.where(asQuery, conditionBuilder).first;
}

extension ExpressionPackageExt on Expr<Package> {
  /// TODO: document name
  Expr<String> get name => ExposedForCodeGen.field(this, 'name');
}

final class _$Like extends Like {
  _$Like(
    this._$userId,
    this._$packageName,
  );

  final int? _$userId;

  final String? _$packageName;

  static const _$fields = [
    'userId',
    'packageName',
  ];

  static Like _$deserialize(List<Object?> fields) => _$Like(
        (fields[0] as int?),
        (fields[1] as String?),
      );

  @override
  int get userId {
    final value = _$userId;
    if (value == null) {
      throw StateError('Query did not fetch "userId"');
    }
    return value;
  }

  @override
  String get packageName {
    final value = _$packageName;
    if (value == null) {
      throw StateError('Query did not fetch "packageName"');
    }
    return value;
  }

  @override
  String toString() =>
      'Like(userId: "${_$userId}", packageName: "${_$packageName}")';
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

extension QueryLikeExt on Query<Like> {
  /// TODO: document lookup by PrimaryKey
  QuerySingle<Like> byKey({
    required int userId,
    required String packageName,
  }) =>
      where((like) => like.userId.equals
          .literal(userId)
          .and(like.packageName.equals.literal(packageName))).first;

  /// TODO: document where()
  Query<Like> where(Expr<bool> Function(Expr<Like> like) conditionBuilder) =>
      ExposedForCodeGen.where(this, conditionBuilder);

  /// TODO: document orderBy()
  Query<Like> orderBy(
    Expr Function(Expr<Like> like) fieldBuilder, {
    bool descending = false,
  }) =>
      ExposedForCodeGen.orderBy(this, fieldBuilder, descending: descending);

  /// TODO: document select()
  Query<Like> select({
    bool userId = false,
    bool packageName = false,
  }) =>
      ExposedForCodeGen.select(this, [userId, packageName]);

  /// TODO: document updateAll()
  Future<void> updateAll({
    int? userId,
    String? packageName,
  }) =>
      ExposedForCodeGen.update(this, [userId, packageName]);
}

extension QuerySingleLikeExt on QuerySingle<Like> {
  /// TODO document select()
  QuerySingle<Like> select({
    bool userId = false,
    bool packageName = false,
  }) =>
      ExposedForCodeGen.select(asQuery, [userId, packageName]).first;

  /// TODO document update()
  Future<void> update({
    int? userId,
    String? packageName,
  }) =>
      ExposedForCodeGen.update(asQuery, [userId, packageName]);

  /// TODO document where()
  QuerySingle<Like> where(
          Expr<bool> Function(Expr<Like> like) conditionBuilder) =>
      ExposedForCodeGen.where(asQuery, conditionBuilder).first;
}

extension ExpressionLikeExt on Expr<Like> {
  /// TODO: document userId
  Expr<int> get userId => ExposedForCodeGen.field(this, 'userId');

  /// TODO: document packageName
  Expr<String> get packageName => ExposedForCodeGen.field(this, 'packageName');
}
