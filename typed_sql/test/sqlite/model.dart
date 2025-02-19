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

import 'package:typed_sql/typed_sql.dart';

part 'model.g.dart';

abstract final class PrimaryDatabase extends Schema {
  Table<User> get users;
  Table<Package> get packages;
  Table<Like> get likes;
}

@PrimaryKey(['userId'])
abstract final class User extends Model {
  int get userId;

  String get name;

  @Unique()
  String get email;
}

@PrimaryKey(['packageName'])
abstract final class Package extends Model {
  String get packageName;

  int get likes;

  // TODO: Support references!
  int get ownerId;
}

@PrimaryKey(['userId', 'packageName'])
abstract final class Like extends Model {
  // TODO: Support references
  int get userId;

  // TODO: Support references
  String get packageName;
}

extension DatabaseAdaptorExtensions on DatabaseAdaptor {
  Future<void> createTables() async {
    await query(
      '''CREATE TABLE users (${[
        'userId INTEGER',
        'name TEXT NOT NULL',
        'email TEXT NOT NULL',
        'PRIMARY KEY (userId)',
      ].join(', ')})''',
      [],
    ).drain<void>();

    await query(
      '''CREATE TABLE packages (${[
        'packageName TEXT NOT NULL',
        'likes INTEGER NOT NULL',
        'ownerId INTEGER NOT NULL',
        'PRIMARY KEY (packageName)',
        'FOREIGN KEY (ownerId) REFERENCES users(userId)',
      ].join(', ')})''',
      [],
    ).drain<void>();

    await query(
      '''CREATE TABLE likes (${[
        'packageName TEXT NOT NULL',
        'userId INTEGER NOT NULL',
        'PRIMARY KEY (userId, packageName)',
        'FOREIGN KEY (userId) REFERENCES users(userId)',
        'FOREIGN KEY (packageName) REFERENCES packages(packageName)',
      ].join(', ')})''',
      [],
    ).drain<void>();
  }
}
