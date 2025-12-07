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

import 'test_code_generation.dart';

void main() {
  testCodeGeneration(
    name: 'Unique.field works on single field',
    source: r'''
      abstract final class BankVault extends Schema {
        Table<Account> get accounts;
      }

      @PrimaryKey(['accountId'])
      abstract final class Account extends Row {
        int get accountId;

        @Unique.field()
        String get accountNumber;
      }
    ''',
    generated: contains('byAccountNumber'),
  );

  testCodeGeneration(
    name: 'Unique.field(name: ...) works on single field',
    source: r'''
      abstract final class BankVault extends Schema {
        Table<Account> get accounts;
      }

      @PrimaryKey(['accountId'])
      abstract final class Account extends Row {
        int get accountId;

        @Unique.field(name: 'accNr')
        String get accountNumber;
      }
    ''',
    generated: contains('byAccNr'),
  );

  testCodeGeneration(
    name: 'Unique.field(name: \'-\') omits by<name>',
    source: r'''
      abstract final class BankVault extends Schema {
        Table<Account> get accounts;
      }

      @PrimaryKey(['accountId'])
      abstract final class Account extends Row {
        int get accountId;

        @Unique.field(name: '-')
        String get accountNumber;
      }
    ''',
    generated: isNot(contains('byAccountNumber')),
  );

  testCodeGeneration(
    name: 'Only one Unique.field annotation is allowed',
    source: r'''
      abstract final class BankVault extends Schema {
        Table<Account> get accounts;
      }

      @PrimaryKey(['accountId'])
      abstract final class Account extends Row {
        int get accountId;

        @Unique.field()
        @Unique.field(name: 'foo')
        String get accountNumber;
      }
    ''',
    error: contains('Only one `Unique.field` annotation is allowed per field'),
  );

  testCodeGeneration(
    name: 'Unique() cannot be used on fields',
    source: r'''
      abstract final class BankVault extends Schema {
        Table<Account> get accounts;
      }

      @PrimaryKey(['accountId'])
      abstract final class Account extends Row {
        int get accountId;

        @Unique(fields: ['accountNumber'])
        String get accountNumber;
      }
    ''',
    error: contains(
      '`Unique()` cannot be used on fields, use `Unique.fields` instead',
    ),
  );

  testCodeGeneration(
    name: 'Unique.field(name: "hello world") is an invalid identifier',
    source: r'''
      abstract final class BankVault extends Schema {
        Table<Account> get accounts;
      }

      @PrimaryKey(['accountId'])
      abstract final class Account extends Row {
        int get accountId;

        @Unique.field(name: 'hello world')
        String get accountNumber;
      }
    ''',
    error: contains(
      '`Unique.field(name: "hello world")`: name is not a valid Dart identifier',
    ),
  );

  //
  testCodeGeneration(
    name: 'Cannot use Unique.field() on row class level',
    source: r'''
      abstract final class BankVault extends Schema {
        Table<Account> get accounts;
      }

      @PrimaryKey(['accountId'])
      @Unique.field()
      abstract final class Account extends Row {
        int get accountId;

        String get accountNumber;
      }
    ''',
    error: contains(
      '`Unique.field()` cannot be used on classes, use `Unique()` instead',
    ),
  );

  testCodeGeneration(
    name: 'Unique is not allowed on JsonValue',
    source: r'''
      abstract final class BankVault extends Schema {
        Table<Account> get accounts;
      }

      @PrimaryKey(['accountId'])
      abstract final class Account extends Row {
        int get accountId;

        @Unique.field()
        JsonValue get accountNumber;
      }
    ''',
    error: contains('JsonValue field cannot be used in a `Unique` annotation'),
  );

  testCodeGeneration(
    name: '`Unique()` on row class works',
    source: r'''
      abstract final class BankVault extends Schema {
        Table<Account> get accounts;
      }

      @PrimaryKey(['accountId'])
      @Unique(name: 'accountNr', fields: ['accountNumber'])
      abstract final class Account extends Row {
        int get accountId;
        String get accountNumber;
      }
    ''',
    generated: contains('byAccountNr'),
  );

  testCodeGeneration(
    name: '`Unique(name: "hello world")` is not a valid Dart identifier',
    source: r'''
      abstract final class BankVault extends Schema {
        Table<Account> get accounts;
      }

      @PrimaryKey(['accountId'])
      @Unique(name: 'hello world', fields: ['accountNumber'])
      abstract final class Account extends Row {
        int get accountId;

        String get accountNumber;
      }
    ''',
    error: contains(
      '`Unique(name: "hello world")`: name is not a valid Dart identifier',
    ),
  );

  testCodeGeneration(
    name: 'Fields are required in @Unique(fields: [])',
    source: r'''
      abstract final class BankVault extends Schema {
        Table<Account> get accounts;
      }

      @PrimaryKey(['accountId'])
      @Unique(name: 'accountNr', fields: [])
      abstract final class Account extends Row {
        int get accountId;
        String get accountNumber;
      }
    ''',
    error: contains('`Unique()` annotation must have non-empty `fields`'),
  );

  testCodeGeneration(
    name: 'Unknown field in @Unique(fields: [...])',
    source: r'''
      abstract final class BankVault extends Schema {
        Table<Account> get accounts;
      }

      @PrimaryKey(['accountId'])
      @Unique(name: 'accountNr', fields: ['noSuchField'])
      abstract final class Account extends Row {
        int get accountId;
        String get accountNumber;
      }
    ''',
    error: contains(
      '`Unique()` annotation references unknown field "noSuchField"',
    ),
  );
}
