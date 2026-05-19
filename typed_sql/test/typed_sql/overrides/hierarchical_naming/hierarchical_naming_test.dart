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

part 'hierarchical_naming_test.g.dart';

@immutable
final class Color implements CustomDataType<int> {
  final int value;
  const Color(this.value);
  factory Color.fromDatabase(int value) => Color(value);
  @override
  int toDatabase() => value;
}

@SqlOverride.schema(naming: .snake_case)
abstract final class HierarchyDatabase extends Schema {
  @SqlOverride.tableName(name: 'tbl_users')
  Table<HierarchyUser> get hierarchyUsers;

  Table<HierarchyProfile> get hierarchyProfiles;
}

@SqlOverride.table(naming: .camelCase)
@PrimaryKey(['userId'])
@Unique(fields: ['firstName', 'lastName'])
abstract final class HierarchyUser extends Row {
  @AutoIncrement()
  int get userId;

  @SqlOverride.field(name: 'str_first_name')
  @SqlOverride.field(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String get firstName;

  @SqlOverride.field(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String get lastName;

  @Unique.field()
  @SqlOverride.field(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String get emailAddress;

  Color get userColor;
}

@PrimaryKey(['profileId'])
@ForeignKey(['userRefId'], table: 'hierarchyUsers', fields: ['userId'])
abstract final class HierarchyProfile extends Row {
  @AutoIncrement()
  int get profileId;

  int get userRefId;

  @Unique.field()
  @SqlOverride.field(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String get profileType;
}

void main() {
  final r = TestRunner<HierarchyDatabase>(
    setup: (db) async {
      await db.createTables();
    },
  );

  r.addTest('insert and query with hierarchical overrides', (db) async {
    final userId = await db.hierarchyUsers
        .insert(
          firstName: toExpr('Jane'),
          lastName: toExpr('Smith'),
          emailAddress: toExpr('jane@example.com'),
          userColor: const Color(0x00FF00).asExpr,
        )
        .returning((u) => (u.userId,))
        .executeAndFetch();

    await db.hierarchyProfiles
        .insert(userRefId: toExpr(userId), profileType: toExpr('moderator'))
        .execute();

    final users = await db.hierarchyUsers
        .where((u) => u.firstName.equals(toExpr('Jane')))
        .select((u) => (u.emailAddress,))
        .fetch();

    check(users).unorderedEquals(['jane@example.com']);
  });

  r.run();
}
