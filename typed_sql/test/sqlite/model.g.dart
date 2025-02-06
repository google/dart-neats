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
}

final class _$User extends User {
  _$User(
    this._$userId,
    this._$name,
    this._$email,
  );

  final int? _$userId;

  final String? _$name;

  final String? _$email;

  static const _$fields = [
    'userId',
    'name',
    'email',
  ];

  static User _$deserialize(List<Object?> fields) => _$User(
        (fields[0] as int?),
        (fields[1] as String?),
        (fields[2] as String?),
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
  String get name {
    final value = _$name;
    if (value == null) {
      throw StateError('Query did not fetch "name"');
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
  String toString() =>
      'User(userId: "${_$userId}", name: "${_$name}", email: "${_$email}")';
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
          userId,
          name,
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
    bool name = false,
    bool email = false,
  }) =>
      ExposedForCodeGen.select(this, [userId, name, email]);

  /// TODO: document updateAll()
  Future<void> updateAll({
    int? userId,
    String? name,
    String? email,
  }) =>
      ExposedForCodeGen.update(this, [userId, name, email]);

  /// TODO: document byXXX()}
  QuerySingle<User> byEmail(String email) =>
      where((user) => user.email.equals.literal(email)).first;
}

extension QuerySingleUserExt on QuerySingle<User> {
  /// TODO document select()
  QuerySingle<User> select({
    bool userId = false,
    bool name = false,
    bool email = false,
  }) =>
      ExposedForCodeGen.select(asQuery, [userId, name, email]).first;

  /// TODO document update()
  Future<void> update({
    int? userId,
    String? name,
    String? email,
  }) =>
      ExposedForCodeGen.update(asQuery, [userId, name, email]);

  /// TODO document where()
  QuerySingle<User> where(
          Expr<bool> Function(Expr<User> user) conditionBuilder) =>
      ExposedForCodeGen.where(asQuery, conditionBuilder).first;
}

extension ExpressionUserExt on Expr<User> {
  /// TODO: document userId
  Expr<int> get userId => ExposedForCodeGen.field(this, 'userId');

  /// TODO: document name
  Expr<String> get name => ExposedForCodeGen.field(this, 'name');

  /// TODO: document email
  Expr<String> get email => ExposedForCodeGen.field(this, 'email');
}
