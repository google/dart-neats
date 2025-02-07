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
        deserialize: _$User.new,
      );

  /// TODO: Propagate documentation for tables!
  Table<Like> get likes => ExposedForCodeGen.declareTable(
        context: this,
        tableName: 'likes',
        columns: _$Like._$fields,
        deserialize: _$Like.new,
      );

  /// TODO: Propagate documentation for tables!
  Table<Package> get packages => ExposedForCodeGen.declareTable(
        context: this,
        tableName: 'packages',
        columns: _$Package._$fields,
        deserialize: _$Package.new,
      );
}

final class _$User extends User {
  _$User(this._$get);

  final Object? Function(int index) _$get;

  @override
  late final userId = _$get(0) as int;

  @override
  late final email = _$get(1) as String;

  static const _$fields = [
    'userId',
    'email',
  ];

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
  _$Package(this._$get);

  final Object? Function(int index) _$get;

  @override
  late final name = _$get(0) as String;

  static const _$fields = ['name'];

  @override
  String toString() => 'Package(name: "$name")';
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

  /// TODO: document updateAll()
  Future<void> updateAll({String? name}) =>
      ExposedForCodeGen.update(this, [name]);
}

extension QuerySinglePackageExt on QuerySingle<Package> {
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
  _$Like(this._$get);

  final Object? Function(int index) _$get;

  @override
  late final userId = _$get(0) as int;

  @override
  late final packageName = _$get(1) as String;

  static const _$fields = [
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

  /// TODO: document updateAll()
  Future<void> updateAll({
    int? userId,
    String? packageName,
  }) =>
      ExposedForCodeGen.update(this, [userId, packageName]);
}

extension QuerySingleLikeExt on QuerySingle<Like> {
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
