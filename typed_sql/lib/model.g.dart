// Copyright 2025 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

part of 'model.dart';

// EXAMPLE OF FILE THAT SHOULD BE GENERATED!

extension PrimaryDatabaseMigration on Database<PrimaryDatabase> {
  Future<void> migrate() async {
    // TODO: Apply migrations
  }
}

extension PrimaryDatabaseSchema on DatabaseContext<PrimaryDatabase> {
  Table<User> get users => ExposedForCodeGen.declareTable(
        context: this,
        tableName: 'users',
        columns: ['userId', 'email'],
        deserialize: (List<Object?> fields) {
          return _$User(
            fields[0] as int?,
            fields[1] as String?,
          );
        },
        // TODO: Include some information about relations, and constraints like unique
      );

  Table<Like> get likes => ExposedForCodeGen.declareTable(
        context: this,
        tableName: 'likes',
        columns: ['userId', 'packageName'],
        deserialize: (List<Object?> fields) => throw UnimplementedError(),
        // TODO: Include some information about relations
      );

  Table<Package> get packages => ExposedForCodeGen.declareTable(
        context: this,
        tableName: 'packages',
        columns: ['userId', 'email'],
        deserialize: (List<Object?> fields) => throw UnimplementedError(),
        // TODO: Include some information about relations
      );
}

/*----------------------- Stuff for User -----------------------*/

final class _$User extends User {
  _$User(
    this._userId,
    this._email,
  );

  // TODO: We can't support nullable fields, because we don't know what they
  final int? _userId;
  @override
  int get userId {
    final userId = _userId;
    if (userId == null) {
      throw StateError('Query was made with .select(userId: false)');
    }
    return userId;
  }

  final String? _email;
  @override
  String get email {
    final email = _email;
    if (email == null) {
      throw StateError('Query was made with .select(email: false)');
    }
    return email;
  }

  @override
  String toString() => 'User(userId: $userId, email: "$email")';
}

extension TableUsers on Table<User> {
  Future<User> create({
    required int userId,
    required String email,
  }) =>
      ExposedForCodeGen.insertInto(
        table: this,
        values: [userId, email],
      );

  Future<void> delete({
    required int userId, // always require the primary key
  }) async =>
      where((user) => user.userId.equals.literal(userId)).first.delete();
}

extension QueryUsers on Query<User> {
  /// Select which fields to return.
  ///
  /// Calling `.select()` without any arguments is no-op and will return all
  /// fields (but not relations).
  ///
  /// Accessing a property that wasn't selected will throw [StateError].
  Query<User> select({
    bool userId = false,
    bool email = false,
  }) =>
      ExposedForCodeGen.select(this, [userId, email]);

  Future<void> updateAll({
    int? userId,
    String? email,
  }) =>
      ExposedForCodeGen.update(this, [userId, email]);

  Query<User> where(
    Expression<bool> Function(Expression<User> user) conditionBuilder,
  ) =>
      ExposedForCodeGen.where(this, conditionBuilder);

  Query<User> orderBy(
    Expression Function(Expression<User> user) fieldBuilder, {
    bool descending = false,
  }) =>
      ExposedForCodeGen.orderBy(this, fieldBuilder, descending: descending);

  /// Utility method to lookup a single row using primary key.
  ///
  /// Notice that [QuerySingle.fetch] returns [Future<User>] so it's very
  /// ergonomic for point-queries.
  QuerySingle<User> byKey({
    required int userId,
  }) =>
      where((user) => user.userId.equals.literal(userId)).first;

  /// For each `@unique()` property there is utility method quickly lookup one.
  QuerySingle<User> byEmail(String email) =>
      where((user) => user.email.equals.literal(email)).first;
}

extension QuerySingleUsers on QuerySingle<User> {
  QuerySingle<User> select({
    bool userId = false,
    bool email = false,
  }) =>
      ExposedForCodeGen.select(asQuery, [userId, email]).first;

  Future<void> update({
    int? userId,
    String? email,
  }) =>
      ExposedForCodeGen.update(asQuery, [userId, email]);

  QuerySingle<User> where(
    Expression<bool> Function(Expression<User> user) conditionBuilder,
  ) =>
      ExposedForCodeGen.where(asQuery, conditionBuilder).first;
}

extension ExpressionUsers on Expression<User> {
  Expression<int> get userId => ExposedForCodeGen.field(this, 'userId');

  Expression<String> get email => ExposedForCodeGen.field(this, 'email');
}

/*----------------------- Stuff for Package -----------------------*/

extension TablePackages on Table<Package> {
  Future<Package> create({
    required String name,
  }) async =>
      throw UnimplementedError();

  Future<Package> update({
    required String name, // always require the primary key
  }) async =>
      throw UnimplementedError();

  Future<void> delete({
    required String name, // always require the primary key
  }) async =>
      throw UnimplementedError();
}

extension QueryPackages on Query<Package> {
  Query<Package> select({
    bool name = false,
  }) =>
      throw UnimplementedError();

  Query<Package> where(
    Expression<bool> Function(Expression<Package> package) conditionBuilder,
  ) =>
      throw UnimplementedError();

  Query<Package> orderBy(
    List<Expression> Function(Expression<Package> package) fieldBuilder, {
    bool descending = false,
  }) =>
      throw UnimplementedError();

  QuerySingle<Package> byKey({
    required String name,
  }) =>
      throw UnimplementedError();
}

extension QuerySinglePackages on QuerySingle<Package> {
  QuerySingle<Package> select({
    bool name = false,
  }) =>
      throw UnimplementedError();

  QuerySingle<Package> where(
    Expression<bool> Function(Expression<Package> package) conditionBuilder,
  ) =>
      throw UnimplementedError();
}

extension ExpressionPackages on Expression<Package> {
  Expression<String> get name => ExposedForCodeGen.field(this, 'name');
}

/*----------------------- Stuff for Likes -----------------------*/

extension TableLikes on Table<Like> {
  Future<Like> create({
    required int userId,
    required String packageName,
  }) async =>
      throw UnimplementedError();

  Future<Like> update({
    required int userId,
    required String packageName,
  }) async =>
      throw UnimplementedError();

  Future<void> delete({
    required int userId,
    required String packageName,
  }) async =>
      throw UnimplementedError();
}

extension QueryLikes on Query<Like> {
  Query<Like> select({
    bool userId = false,
    bool packageName = false,
  }) =>
      throw UnimplementedError();

  Query<Like> where(
    Expression<bool> Function(Expression<Like> like) conditionBuilder,
  ) =>
      throw UnimplementedError();

  Query<Like> orderBy(
    List<Expression> Function(Expression<Like> like) fieldBuilder, {
    bool descending = false,
  }) =>
      throw UnimplementedError();

  QuerySingle<Like> byKey({
    required int userId,
    required String packageName,
  }) =>
      throw UnimplementedError();
}

extension QuerySingleLikes on QuerySingle<Like> {
  QuerySingle<Like> select({
    bool userId = false,
    bool packageName = false,
  }) =>
      throw UnimplementedError();

  QuerySingle<Like> where(
    Expression<bool> Function(Expression<Like> like) conditionBuilder,
  ) =>
      throw UnimplementedError();
}

extension ExpressionLikes on Expression<Like> {
  Expression<int> get userId => ExposedForCodeGen.field(this, 'userId');
  Expression<String> get packageName =>
      ExposedForCodeGen.field(this, 'packageName');
}
