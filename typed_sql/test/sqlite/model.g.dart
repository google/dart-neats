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
}

final class _$User extends User {
  _$User(this._$get);

  final Object? Function(int index) _$get;

  @override
  late final userId = _$get(0) as int;

  @override
  late final name = _$get(1) as String;

  @override
  late final email = _$get(2) as String;

  static const _$fields = [
    'userId',
    'name',
    'email',
  ];

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
      where((user) => user.userId.equals.literal(userId)).first;

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
        (user) => ExposedForCodeGen.buildUpdate<User>([
          userId != null ? literal(userId) : null,
          name != null ? literal(name) : null,
          email != null ? literal(email) : null,
        ]),
      );

  /// TODO: document byXXX()}
  QuerySingle<(Expr<User>,)> byEmail(String email) =>
      where((user) => user.email.equals.literal(email)).first;
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
        (user) => ExposedForCodeGen.buildUpdate<User>([
          userId != null ? literal(userId) : null,
          name != null ? literal(name) : null,
          email != null ? literal(email) : null,
        ]),
      );
}

extension ExpressionUserExt on Expr<User> {
  /// TODO: document userId
  Expr<int> get userId => ExposedForCodeGen.field(this, 0);

  /// TODO: document name
  Expr<String> get name => ExposedForCodeGen.field(this, 1);

  /// TODO: document email
  Expr<String> get email => ExposedForCodeGen.field(this, 2);
}
