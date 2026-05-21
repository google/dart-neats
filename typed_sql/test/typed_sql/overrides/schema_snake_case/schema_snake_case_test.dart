// Copyright 2026 Google LLC
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

import 'package:meta/meta.dart';
import 'package:typed_sql/typed_sql.dart';

import '../../testrunner.dart';

part 'schema_snake_case_test.g.dart';

@immutable
final class Color implements CustomDataType<int> {
  final int value;
  const Color(this.value);
  factory Color.fromDatabase(int value) => Color(value);
  @override
  int toDatabase() => value;
}

@SqlOverride.schema(naming: .snake_case)
abstract final class SnakeDatabase extends Schema {
  Table<SnakeUser> get snakeUsers;
  Table<SnakeProfile> get snakeProfiles;
}

@PrimaryKey(['userId'])
@Unique(fields: ['firstName', 'lastName'])
abstract final class SnakeUser extends Row {
  @AutoIncrement()
  int get userId;

  @SqlOverride.field(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String get firstName;

  @SqlOverride.field(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String get lastName;

  @Unique.field()
  @SqlOverride.field(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String get emailAddress;

  Color get favoriteColor;
}

@PrimaryKey(['profileId'])
@ForeignKey(['userRefId'], table: 'snakeUsers', fields: ['userId'])
abstract final class SnakeProfile extends Row {
  @AutoIncrement()
  int get profileId;

  int get userRefId;

  @Unique.field()
  @SqlOverride.field(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String get profileType;
}

void main() {
  final r = TestRunner<SnakeDatabase>(
    setup: (db) async {
      await db.createTables();
    },
  );

  r.addTest('insert and query with global snake_case', (db) async {
    final userId = await db.snakeUsers
        .insert(
          firstName: toExpr('John'),
          lastName: toExpr('Doe'),
          emailAddress: toExpr('john@example.com'),
          favoriteColor: const Color(0xFF0000).asExpr,
        )
        .returning((u) => (u.userId,))
        .executeAndFetch();

    await db.snakeProfiles
        .insert(userRefId: toExpr(userId), profileType: toExpr('admin'))
        .execute();

    final profiles = await db.snakeProfiles
        .where((p) => p.userRefId.equals(toExpr(userId)))
        .select((p) => (p.profileType,))
        .fetch();

    check(profiles).unorderedEquals(['admin']);
  });

  r.run();
}
