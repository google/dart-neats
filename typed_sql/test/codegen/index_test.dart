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
    name: 'Index.field() works on single field',
    source: r'''
      abstract final class BankVault extends Schema {
        Table<Account> get accounts;
      }

      @PrimaryKey(['accountId'])
      abstract final class Account extends Row {
        int get accountId;

        @Index.field()
        String get accountNumber;
      }
    ''',
    output: (s) => s.contains('indexDefinition'),
  );

  testCodeGeneration(
    name: 'Index.field() covers the annotated column',
    source: r'''
      abstract final class BankVault extends Schema {
        Table<Account> get accounts;
      }

      @PrimaryKey(['accountId'])
      abstract final class Account extends Row {
        int get accountId;

        @Index.field()
        String get accountNumber;
      }
    ''',
    output: (s) => s.contains("columns: ['accountNumber']"),
  );

  testCodeGeneration(
    name: 'Index.field() does NOT generate a by<Name> lookup method',
    source: r'''
      abstract final class BankVault extends Schema {
        Table<Account> get accounts;
      }

      @PrimaryKey(['accountId'])
      abstract final class Account extends Row {
        int get accountId;

        @Index.field()
        String get accountNumber;
      }
    ''',
    output: (s) => s.not((s) => s.contains('byAccountNumber')),
  );

  testCodeGeneration(
    name: 'Index() on row class works',
    source: r'''
      abstract final class BankVault extends Schema {
        Table<Account> get accounts;
      }

      @PrimaryKey(['accountId'])
      @Index(name: 'ownerName', fields: ['lastName', 'firstName'])
      abstract final class Account extends Row {
        int get accountId;
        String get firstName;
        String get lastName;
      }
    ''',
    output: (s) => s.contains("name: 'ownerName'"),
  );

  testCodeGeneration(
    name: 'Index() name is converted using the schema naming rules',
    source: r'''
      abstract final class BankVault extends Schema {
        Table<Account> get accounts;
      }

      @SqlOverride.table(naming: .snake_case)
      @PrimaryKey(['accountId'])
      @Index(name: 'ownerName', fields: ['lastName', 'firstName'])
      abstract final class Account extends Row {
        int get accountId;
        String get firstName;
        String get lastName;
      }
    ''',
    output: (s) {
      // The raw name is preserved, and `sqlName` carries the converted name.
      s.contains("name: 'ownerName'");
      s.contains("sqlName: 'owner_name'");
    },
  );

  testCodeGeneration(
    name: 'Multiple Index() annotations on a row class are allowed',
    source: r'''
      abstract final class BankVault extends Schema {
        Table<Account> get accounts;
      }

      @PrimaryKey(['accountId'])
      @Index(fields: ['firstName'])
      @Index(fields: ['lastName'])
      abstract final class Account extends Row {
        int get accountId;
        String get firstName;
        String get lastName;
      }
    ''',
    output: (s) {
      s.contains("columns: ['firstName']");
      s.contains("columns: ['lastName']");
    },
  );

  testCodeGeneration(
    name: 'Index() cannot be used on fields',
    source: r'''
      abstract final class BankVault extends Schema {
        Table<Account> get accounts;
      }

      @PrimaryKey(['accountId'])
      abstract final class Account extends Row {
        int get accountId;

        @Index(fields: ['accountNumber'])
        String get accountNumber;
      }
    ''',
    error: (s) => s.contains(
      '`Index()` cannot be used on fields, use `Index.field()` instead',
    ),
  );

  testCodeGeneration(
    name: 'Index.field() cannot be used on classes',
    source: r'''
      abstract final class BankVault extends Schema {
        Table<Account> get accounts;
      }

      @PrimaryKey(['accountId'])
      @Index.field()
      abstract final class Account extends Row {
        int get accountId;
        String get accountNumber;
      }
    ''',
    error: (s) => s.contains(
      '`Index.field()` cannot be used on classes, use `Index()` instead',
    ),
  );

  testCodeGeneration(
    name: 'Index(name: "hello world") is an invalid identifier',
    source: r'''
      abstract final class BankVault extends Schema {
        Table<Account> get accounts;
      }

      @PrimaryKey(['accountId'])
      @Index(name: 'hello world', fields: ['accountNumber'])
      abstract final class Account extends Row {
        int get accountId;
        String get accountNumber;
      }
    ''',
    error: (s) => s.contains(
      '`Index(name: "hello world")`: name is not a valid identifier',
    ),
  );

  testCodeGeneration(
    name: 'Fields are required in @Index(fields: [])',
    source: r'''
      abstract final class BankVault extends Schema {
        Table<Account> get accounts;
      }

      @PrimaryKey(['accountId'])
      @Index(fields: [])
      abstract final class Account extends Row {
        int get accountId;
        String get accountNumber;
      }
    ''',
    error: (s) =>
        s.contains('`Index()` annotation must have non-empty `fields`'),
  );

  testCodeGeneration(
    name: 'Unknown field in @Index(fields: [...])',
    source: r'''
      abstract final class BankVault extends Schema {
        Table<Account> get accounts;
      }

      @PrimaryKey(['accountId'])
      @Index(fields: ['noSuchField'])
      abstract final class Account extends Row {
        int get accountId;
        String get accountNumber;
      }
    ''',
    error: (s) => s.contains(
      '`Index()` annotation references unknown field "noSuchField"',
    ),
  );

  testCodeGeneration(
    name: 'Index is not allowed on JsonValue',
    source: r'''
      abstract final class BankVault extends Schema {
        Table<Account> get accounts;
      }

      @PrimaryKey(['accountId'])
      abstract final class Account extends Row {
        int get accountId;

        @Index.field()
        JsonValue get metadata;
      }
    ''',
    error: (s) =>
        s.contains('JsonValue field cannot be used in an `Index` annotation'),
  );
}
