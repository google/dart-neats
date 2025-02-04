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
    ExposedForCodeGen.applyMigration(this, '''
CREATE TABLE users (
  userId INT,
  name TEXT,
  email TEXT UNIQUE
);
''');
  }
}

extension PrimaryDatabaseSchema on DatabaseContext<PrimaryDatabase> {
  Table<User> get users => ExposedForCodeGen.declareTable(
        context: this,
        tableName: 'users',
        columns: ['userId', 'name', 'email'],
        deserialize: (List<Object?> fields) {
          return _$User(
            fields[0] as int?,
            fields[1] as String?,
            fields[2] as String?,
          );
        },
        // TODO: Include some information about relations, and constraints like unique
      );
}

/*----------------------- Stuff for User -----------------------*/

final class _$User extends User {
  _$User(
    this._userId,
    this._name,
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

  final String? _name;
  @override
  String get name {
    final name = _name;
    if (name == null) {
      throw StateError('Query was made with .select(name: false)');
    }
    return name;
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
  String toString() => 'User(userId: $userId, name: "$name", email: "$email")';
}

extension TableUsers on Table<User> {
  Future<User> create({
    required int userId,
    required String name,
    required String email,
  }) =>
      ExposedForCodeGen.insertInto(
        table: this,
        values: [userId, name, email],
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
    bool name = false,
    bool email = false,
  }) =>
      ExposedForCodeGen.select(this, [userId, name, email]);

  Future<void> updateAll({
    int? userId,
    String? name,
    String? email,
  }) =>
      ExposedForCodeGen.update(this, [userId, name, email]);

  Query<User> where(
    Expr<bool> Function(Expr<User> user) conditionBuilder,
  ) =>
      ExposedForCodeGen.where(this, conditionBuilder);

  Query<User> orderBy(
    Expr Function(Expr<User> user) fieldBuilder, {
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
    bool name = false,
    bool email = false,
  }) =>
      ExposedForCodeGen.select(asQuery, [userId, name, email]).first;

  Future<void> update({
    int? userId,
    String? name,
    String? email,
  }) =>
      ExposedForCodeGen.update(asQuery, [userId, name, email]);

  QuerySingle<User> where(
    Expr<bool> Function(Expr<User> user) conditionBuilder,
  ) =>
      ExposedForCodeGen.where(asQuery, conditionBuilder).first;
}

extension ExpressionUsers on Expr<User> {
  Expr<int> get userId => ExposedForCodeGen.field(this, 'userId');
  Expr<String> get name => ExposedForCodeGen.field(this, 'name');
  Expr<String> get email => ExposedForCodeGen.field(this, 'email');
}
