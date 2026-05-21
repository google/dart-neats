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

part 'legacy_names_test.g.dart';

@immutable
final class Color implements CustomDataType<int> {
  final int value;
  const Color(this.value);
  factory Color.fromDatabase(int value) => Color(value);
  @override
  int toDatabase() => value;
}

abstract final class LegacyDatabase extends Schema {
  @SqlOverride.tableName(name: 't_user_data')
  Table<LegacyUser> get users;

  @SqlOverride.tableName(name: 't_user_comments')
  Table<LegacyComment> get comments;
}

@PrimaryKey(['tenantId', 'userId'])
@Unique(fields: ['firstName', 'lastName'])
abstract final class LegacyUser extends Row {
  @SqlOverride.field(name: 'INT_tenant_id')
  int get tenantId;

  @SqlOverride.field(name: 'INT_user_id')
  int get userId;

  @SqlOverride.field(name: 'str_First_Name')
  @SqlOverride.field(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String get firstName;

  @SqlOverride.field(name: 'str_Last_Name')
  @SqlOverride.field(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String get lastName;

  @Unique.field()
  @SqlOverride.field(name: 'str_Email')
  @SqlOverride.field(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String get email;

  @SqlOverride.field(name: 'col_color')
  Color get color;
}

@PrimaryKey(['commentId'])
@ForeignKey(['tId', 'uId'], table: 'users', fields: ['tenantId', 'userId'])
abstract final class LegacyComment extends Row {
  @SqlOverride.field(name: 'c_id')
  @AutoIncrement()
  int get commentId;

  @SqlOverride.field(name: 't_id')
  int get tId;

  @SqlOverride.field(name: 'u_id')
  int get uId;

  @SqlOverride.field(name: 'c_text')
  String get text;
}

void main() {
  final r = TestRunner<LegacyDatabase>(
    setup: (db) async {
      await db.createTables();
    },
  );

  r.addTest('insert and query with legacy names', (db) async {
    await db.users
        .insert(
          tenantId: toExpr(1),
          userId: toExpr(100),
          firstName: toExpr('Clark'),
          lastName: toExpr('Kent'),
          email: toExpr('superman@example.com'),
          color: const Color(0x0000FF).asExpr,
        )
        .execute();

    await db.comments
        .insert(
          tId: toExpr(1),
          uId: toExpr(100),
          text: toExpr('Up, up and away!'),
        )
        .execute();

    final comments = await db.comments
        .where((c) => c.uId.equals(toExpr(100)))
        .select((c) => (c.text,))
        .fetch();

    check(comments).unorderedEquals(['Up, up and away!']);
  });

  r.run();
}
