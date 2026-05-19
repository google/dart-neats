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

import 'test_code_generation.dart';

void main() {
  testCodeGeneration(
    name: 'Example works without overrides',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<UserAccount> get userAccounts;
      }

      @PrimaryKey(['userId'])
      abstract final class UserAccount extends Row {
        int get userId;
        String get firstName;
      }
    ''',
    generated: anything,
  );

  testCodeGeneration(
    name: 'Example with empty overrides',
    source: r'''
      @SqlOverride.schema()
      abstract final class TestDatabase extends Schema {
        @SqlOverride.tableName()
        Table<UserAccount> get userAccounts;
      }

      @SqlOverride.table()
      @PrimaryKey(['userId'])
      abstract final class UserAccount extends Row {
        @SqlOverride.field()
        int get userId;

        @SqlOverride.field()
        String get firstName;
      }
    ''',
    generated: anything,
  );

  // Testing use of the wrong constructor

  testCodeGeneration(
    name: 'SqlOverride.field disallowed on schema class',
    source: r'''
      @SqlOverride.field()
      abstract final class TestDatabase extends Schema {
        Table<UserAccount> get userAccounts;
      }

      @PrimaryKey(['userId'])
      abstract final class UserAccount extends Row {
        int get userId;
        String get firstName;
      }
    ''',
    error: contains('should not be used on'),
  );

  testCodeGeneration(
    name: 'SqlOverride.tableName disallowed on schema class',
    source: r'''
      @SqlOverride.tableName()
      abstract final class TestDatabase extends Schema {
        Table<UserAccount> get userAccounts;
      }

      @PrimaryKey(['userId'])
      abstract final class UserAccount extends Row {
        int get userId;
        String get firstName;
      }
    ''',
    error: contains('should not be used on'),
  );

  testCodeGeneration(
    name: 'SqlOverride.table disallowed on schema class',
    source: r'''
      @SqlOverride.table()
      abstract final class TestDatabase extends Schema {
        Table<UserAccount> get userAccounts;
      }

      @PrimaryKey(['userId'])
      abstract final class UserAccount extends Row {
        int get userId;
        String get firstName;
      }
    ''',
    error: contains('should not be used on'),
  );

  testCodeGeneration(
    name: 'SqlOverride.table disallowed on table definition',
    source: r'''
      abstract final class TestDatabase extends Schema {
        @SqlOverride.table()
        Table<UserAccount> get userAccounts;
      }

      @PrimaryKey(['userId'])
      abstract final class UserAccount extends Row {
        int get userId;
        String get firstName;
      }
    ''',
    error: contains('should not be used on'),
  );

  testCodeGeneration(
    name: 'SqlOverride.schema disallowed on table definition',
    source: r'''
      abstract final class TestDatabase extends Schema {
        @SqlOverride.schema()
        Table<UserAccount> get userAccounts;
      }

      @PrimaryKey(['userId'])
      abstract final class UserAccount extends Row {
        int get userId;
        String get firstName;
      }
    ''',
    error: contains('should not be used on'),
  );

  testCodeGeneration(
    name: 'SqlOverride.field disallowed on table definition',
    source: r'''
      abstract final class TestDatabase extends Schema {
        @SqlOverride.field()
        Table<UserAccount> get userAccounts;
      }

      @PrimaryKey(['userId'])
      abstract final class UserAccount extends Row {
        int get userId;
        String get firstName;
      }
    ''',
    error: contains('should not be used on'),
  );

  testCodeGeneration(
    name: 'SqlOverride.field disallowed on row class',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<UserAccount> get userAccounts;
      }

      @SqlOverride.field()
      @PrimaryKey(['userId'])
      abstract final class UserAccount extends Row {
        int get userId;
        String get firstName;
      }
    ''',
    error: contains('should not be used on'),
  );

  testCodeGeneration(
    name: 'SqlOverride.schema disallowed on row class',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<UserAccount> get userAccounts;
      }

      @SqlOverride.schema()
      @PrimaryKey(['userId'])
      abstract final class UserAccount extends Row {
        int get userId;
        String get firstName;
      }
    ''',
    error: contains('should not be used on'),
  );

  testCodeGeneration(
    name: 'SqlOverride.tableName disallowed on row class',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<UserAccount> get userAccounts;
      }

      @SqlOverride.tableName()
      @PrimaryKey(['userId'])
      abstract final class UserAccount extends Row {
        int get userId;
        String get firstName;
      }
    ''',
    error: contains('should not be used on'),
  );

  testCodeGeneration(
    name: 'SqlOverride.tableName disallowed on field',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<UserAccount> get userAccounts;
      }

      @PrimaryKey(['userId'])
      abstract final class UserAccount extends Row {
        @SqlOverride.tableName()
        int get userId;
        String get firstName;
      }
    ''',
    error: contains('should not be used on'),
  );

  testCodeGeneration(
    name: 'SqlOverride.table disallowed on field',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<UserAccount> get userAccounts;
      }

      @PrimaryKey(['userId'])
      abstract final class UserAccount extends Row {
        @SqlOverride.table()
        int get userId;
        String get firstName;
      }
    ''',
    error: contains('should not be used on'),
  );

  testCodeGeneration(
    name: 'SqlOverride.schema disallowed on field',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<UserAccount> get userAccounts;
      }

      @PrimaryKey(['userId'])
      abstract final class UserAccount extends Row {
        @SqlOverride.schema()
        int get userId;
        String get firstName;
      }
    ''',
    error: contains('should not be used on'),
  );

  // Test annotation with constants to make sure analyze resolution is correct

  testCodeGeneration(
    name: 'Annotation with constant works',
    source: r'''
      const c = SqlOverride.field();

      abstract final class TestDatabase extends Schema {
        Table<UserAccount> get userAccounts;
      }

      @PrimaryKey(['userId'])
      abstract final class UserAccount extends Row {
        @c
        int get userId;
        String get firstName;
      }
    ''',
    generated: anything,
  );

  testCodeGeneration(
    name: 'We can resolve constructor when annotated with constant',
    source: r'''
      const c = SqlOverride.schema();

      abstract final class TestDatabase extends Schema {
        Table<UserAccount> get userAccounts;
      }

      @PrimaryKey(['userId'])
      abstract final class UserAccount extends Row {
        @c
        int get userId;
        String get firstName;
      }
    ''',
    error: contains('should not be used on'),
  );

  // Test name and naming cannot be dialect specific

  testCodeGeneration(
    name: 'name cannot be dialect specific',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<UserAccount> get userAccounts;
      }

      @PrimaryKey(['userId'])
      abstract final class UserAccount extends Row {
        @SqlOverride.field(name: 'uid', dialect: 'sqlite')
        int get userId;
        String get firstName;
      }
    ''',
    error: contains('cannot override `name` for a specific `dialect`'),
  );

  testCodeGeneration(
    name: 'naming cannot be dialect specific',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<UserAccount> get userAccounts;
      }

      @PrimaryKey(['userId'])
      abstract final class UserAccount extends Row {
        @SqlOverride.field(naming: .snake_case, dialect: 'sqlite')
        int get userId;
        String get firstName;
      }
    ''',
    error: contains('cannot override `naming` for a specific `dialect`'),
  );

  // Test naming override

  testCodeGeneration(
    name: 'SqlOverride.schema(.snake_case)',
    source: r'''
      @SqlOverride.schema(naming: .snake_case)
      abstract final class TestDatabase extends Schema {
        Table<UserAccount> get userAccounts;
      }

      @PrimaryKey(['userId'])
      abstract final class UserAccount extends Row {
        int get userId;
        String get firstName;
      }
    ''',
    generated: allOf([
      // Table name should be snake_cased
      contains("'user_accounts'"),
      // Column names should be snake_cased
      contains("'user_id'"),
      contains("'first_name'"),
    ]),
  );

  testCodeGeneration(
    name: 'SqlOverride.table(.snake_case)',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<UserAccount> get userAccounts;
      }

      @SqlOverride.table(naming: .snake_case)
      @PrimaryKey(['userId'])
      abstract final class UserAccount extends Row {
        int get userId;
        String get firstName;
      }
    ''',
    generated: allOf([
      isNot(contains("'user_accounts'")),
      // Column names should be snake_cased
      contains("'user_id'"),
      contains("'first_name'"),
    ]),
  );

  testCodeGeneration(
    name: 'SqlOverride.field(.snake_case)',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<UserAccount> get userAccounts;
      }

      @PrimaryKey(['userId'])
      abstract final class UserAccount extends Row {
        @SqlOverride.field(naming: .snake_case)
        int get userId;
        String get firstName;
      }
    ''',
    generated: allOf([
      isNot(contains("'user_accounts'")),
      contains("'user_id'"),
      isNot(contains("'first_name'")),
    ]),
  );

  testCodeGeneration(
    name: 'SqlOverride.schema(.snake_case) can be overwritten',
    source: r'''
      @SqlOverride.schema(naming: .snake_case)
      abstract final class TestDatabase extends Schema {
        @SqlOverride.tableName(name: 'tbl_userAccounts')
        Table<UserAccount> get userAccounts;
      }

      @PrimaryKey(['userId'])
      abstract final class UserAccount extends Row {
        @SqlOverride.field(name: 'uid')
        int get userId;

        @SqlOverride.field(naming: .camelCase)
        String get firstName;
      }
    ''',
    generated: allOf([
      isNot(contains("'user_accounts'")),
      contains("'tbl_userAccounts'"),
      contains("'uid'"),
      isNot(contains("'first_name'")),
    ]),
  );

  // Test columnType override

  testCodeGeneration(
    name: 'SqlOverride.field supports columnTypes overrides',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<Item> get items;
      }

      @PrimaryKey(['id'])
      abstract final class Item extends Row {
        @SqlOverride.field(columnType: 'BIGGER_INT')
        int get id;

        JsonValue get data;
      }
    ''',
    generated: allOf([
      contains("columnType: 'BIGGER_INT',"),
    ]),
  );

  testCodeGeneration(
    name: 'SqlOverride.field supports dialect-specific columnTypes',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<Item> get items;
      }

      @PrimaryKey(['id'])
      abstract final class Item extends Row {
        int get id;

        @SqlOverride.field(dialect: 'postgres', columnType: 'FOO_JSONB')
        @SqlOverride.field(dialect: 'sqlite', columnType: 'BAR_TEXT')
        JsonValue get data;
      }
    ''',
    generated: allOf([
      contains("dialect: 'postgres',"),
      contains("columnType: 'FOO_JSONB',"),
      contains("dialect: 'sqlite',"),
      contains("columnType: 'BAR_TEXT',"),
    ]),
  );

  // Test collation override

  testCodeGeneration(
    name: 'SqlOverride.field supports collation override',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<Item> get items;
      }

      @PrimaryKey(['id'])
      abstract final class Item extends Row {
        int get id;

        @SqlOverride.field(collation: 'NOCASE')
        String get category;
      }
    ''',
    generated: allOf([
      contains("collation: 'NOCASE',"),
    ]),
  );

  testCodeGeneration(
    name: 'SqlOverride.table supports collation override',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<Item> get items;
      }

      @SqlOverride.table(collation: 'NOCASE')
      @PrimaryKey(['id'])
      abstract final class Item extends Row {
        int get id;

        String get category;
      }
    ''',
    generated: allOf([
      contains("collation: 'NOCASE',"),
    ]),
  );

  // Test defaultValue override

  testCodeGeneration(
    name: 'SqlOverride.field supports defaultValue override',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<Item> get items;
      }

      @PrimaryKey(['id'])
      abstract final class Item extends Row {
        int get id;

        @SqlOverride.field(defaultValue: 'UNKNOWN')
        String get category;
      }
    ''',
    generated: allOf([
      contains("defaultValue: 'UNKNOWN'"),
    ]),
  );

  // Test conflicting overrides
  testCodeGeneration(
    name: 'Multiple name overrides on the same field picks the last one',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<UserAccount> get userAccounts;
      }

      @PrimaryKey(['userId'])
      abstract final class UserAccount extends Row {
        @SqlOverride.field(name: 'first_id')
        @SqlOverride.field(name: 'second_id')
        int get userId;
      }
    ''',
    generated: allOf([
      contains("'second_id'"),
      isNot(contains("'first_id'")),
    ]),
  );
}
