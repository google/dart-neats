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

/// Wraps [body] (field declarations, optionally `@Index...`-annotated)
/// inside the `BankVault`/`Account` schema boilerplate shared by (almost)
/// every test in this file.
///
/// [classAnnotations], if given, is inserted directly above the `Account`
/// class declaration (e.g. for a class-level `@Index(...)` or
/// `@SqlOverride.table(...)`).
String schema({String classAnnotations = '', required String body}) =>
    '''
  abstract final class BankVault extends Schema {
    Table<Account> get accounts;
  }

  @PrimaryKey(['accountId'])
  $classAnnotations
  abstract final class Account extends Row {
    int get accountId;

$body
  }
''';

/// All index access methods, and their quirks: whether each supports
/// indexing a `JsonValue` field, and whether each supports `covering`
/// columns.
const _methods = [
  (name: 'brin', allowsJson: false, allowsCovering: false),
  (name: 'btree', allowsJson: false, allowsCovering: true),
  (name: 'gin', allowsJson: true, allowsCovering: false),
  (name: 'gist', allowsJson: false, allowsCovering: true),
  (name: 'hash', allowsJson: false, allowsCovering: false),
  (name: 'spgist', allowsJson: false, allowsCovering: false),
];

void main() {
  testCodeGeneration(
    name: 'Index.field() works on single field',
    source: schema(
      body: '''
    @Index.field()
    String get accountNumber;
''',
    ),
    output: (s) => s.contains('indexDefinition'),
  );

  testCodeGeneration(
    name: 'Index.field() covers the annotated column',
    source: schema(
      body: '''
    @Index.field()
    String get accountNumber;
''',
    ),
    output: (s) => s.contains("columns: ['accountNumber']"),
  );

  testCodeGeneration(
    name: 'Index.field() does NOT generate a by<Name> lookup method',
    source: schema(
      body: '''
    @Index.field()
    String get accountNumber;
''',
    ),
    output: (s) => s.not((s) => s.contains('byAccountNumber')),
  );

  testCodeGeneration(
    name: 'Index() on row class works',
    source: schema(
      classAnnotations:
          "@Index(name: 'ownerName', fields: ['lastName', "
          "'firstName'])",
      body: '''
    String get firstName;
    String get lastName;
''',
    ),
    output: (s) => s.contains("name: 'ownerName'"),
  );

  testCodeGeneration(
    name: 'Index() name is converted using the schema naming rules',
    source: schema(
      classAnnotations: '''
@SqlOverride.table(naming: .snake_case)
  @Index(name: 'ownerName', fields: ['lastName', 'firstName'])''',
      body: '''
    String get firstName;
    String get lastName;
''',
    ),
    output: (s) {
      // The raw name is preserved, and `sqlName` carries the converted name.
      s.contains("name: 'ownerName'");
      s.contains("sqlName: 'owner_name'");
    },
  );

  testCodeGeneration(
    name: 'Multiple Index() annotations on a row class are allowed',
    source: schema(
      classAnnotations: '''
@Index(fields: ['firstName'])
  @Index(fields: ['lastName'])''',
      body: '''
    String get firstName;
    String get lastName;
''',
    ),
    output: (s) {
      s.contains("columns: ['firstName']");
      s.contains("columns: ['lastName']");
    },
  );

  testCodeGeneration(
    name: 'Index() cannot be used on fields',
    source: schema(
      body: '''
    @Index(fields: ['accountNumber'])
    String get accountNumber;
''',
    ),
    error: (s) => s.contains(
      '`Index()` cannot be used on fields, use `Index.field()` instead',
    ),
  );

  testCodeGeneration(
    name: 'Index.field() cannot be used on classes',
    source: schema(
      classAnnotations: '@Index.field()',
      body: '    String get accountNumber;',
    ),
    error: (s) => s.contains(
      '`Index.field()` cannot be used on classes, use `Index()` instead',
    ),
  );

  testCodeGeneration(
    name: 'Index(name: "hello world") is an invalid identifier',
    source: schema(
      classAnnotations:
          "@Index(name: 'hello world', fields: ['accountNumber'])",
      body: '    String get accountNumber;',
    ),
    error: (s) => s.contains(
      '`Index(name: "hello world")`: name is not a valid identifier',
    ),
  );

  testCodeGeneration(
    name: 'Fields are required in @Index(fields: [])',
    source: schema(
      classAnnotations: '@Index(fields: [])',
      body: '    String get accountNumber;',
    ),
    error: (s) =>
        s.contains('`Index()` annotation must have non-empty `fields`'),
  );

  testCodeGeneration(
    name: 'Unknown field in @Index(fields: [...])',
    source: schema(
      classAnnotations: "@Index(fields: ['noSuchField'])",
      body: '    String get accountNumber;',
    ),
    error: (s) => s.contains(
      '`Index()` annotation references unknown field "noSuchField"',
    ),
  );

  testCodeGeneration(
    name: 'Index.field() without method defaults to btree',
    source: schema(
      body: '''
    @Index.field()
    String get accountNumber;
''',
    ),
    output: (s) => s.contains('method: .btree'),
  );

  // Every IndexAccessMethod shares the same shape of tests: works as a
  // single-field and composite index, its JsonValue support (only `.gin`
  // allows it), and its `covering` support (only `.btree` and `.gist` allow
  // it).
  for (final m in _methods) {
    testCodeGeneration(
      name: 'Index.field(method: .${m.name}) is allowed on a regular field',
      source: schema(
        body:
            '''
    @Index.field(method: .${m.name})
    String get accountNumber;
''',
      ),
      output: (s) {
        s.contains("columns: ['accountNumber']");
        s.contains('method: .${m.name}');
      },
    );

    testCodeGeneration(
      name:
          'Index(fields: [...], method: .${m.name}) is allowed on regular '
          'fields',
      source: schema(
        classAnnotations:
            "@Index(fields: ['firstName', 'lastName'], method: .${m.name})",
        body: '''
    String get firstName;
    String get lastName;
''',
      ),
      output: (s) {
        s.contains("columns: ['firstName', 'lastName']");
        s.contains('method: .${m.name}');
      },
    );

    testCodeGeneration(
      name:
          'Index.field(method: .${m.name}) '
          '${m.allowsJson ? 'is allowed' : 'is not allowed'} '
          'on JsonValue fields',
      source: schema(
        body:
            '''
    @Index.field(method: .${m.name})
    JsonValue get metadata;
''',
      ),
      output: m.allowsJson
          ? (s) {
              s.contains("columns: ['metadata']");
              s.contains('method: .${m.name}');
            }
          : null,
      error: m.allowsJson
          ? null
          : (s) => s.contains(
              'JsonValue field cannot be used in an `Index` annotation',
            ),
    );

    testCodeGeneration(
      name:
          'Index(fields: [...], method: .${m.name}) '
          '${m.allowsJson ? 'is allowed' : 'is not allowed'} '
          'on JsonValue fields',
      source: schema(
        classAnnotations: "@Index(fields: ['metadata'], method: .${m.name})",
        body: '    JsonValue get metadata;',
      ),
      output: m.allowsJson
          ? (s) {
              s.contains("columns: ['metadata']");
              s.contains('method: .${m.name}');
            }
          : null,
      error: m.allowsJson
          ? null
          : (s) => s.contains(
              'JsonValue field cannot be used in an `Index` annotation',
            ),
    );

    testCodeGeneration(
      name:
          'covering: [...] '
          '${m.allowsCovering ? 'is allowed' : 'is not allowed'} '
          'together with method: .${m.name}',
      source: schema(
        body:
            '''
    @Index.field(method: .${m.name}, covering: ['balance'])
    String get accountNumber;

    int get balance;
''',
      ),
      output: m.allowsCovering
          ? (s) {
              s.contains('method: .${m.name}');
              s.contains("covering: ['balance']");
            }
          : null,
      error: m.allowsCovering
          ? null
          : (s) => s.contains(
              '`Index.field(covering: ...)` is only supported for '
              '`method: .btree` or `method: .gist` indexes',
            ),
    );
  }

  testCodeGeneration(
    name: 'Index.field(covering: [...]) covers additional columns',
    source: schema(
      body: '''
    @Index.field(covering: ['balance'])
    String get accountNumber;

    int get balance;
''',
    ),
    output: (s) {
      s.contains("columns: ['accountNumber']");
      s.contains("covering: ['balance']");
    },
  );

  testCodeGeneration(
    name: 'Index(fields: [...], covering: [...]) covers additional columns',
    source: schema(
      classAnnotations:
          "@Index(fields: ['lastName', 'firstName'], covering: ['balance'])",
      body: '''
    String get firstName;
    String get lastName;
    int get balance;
''',
    ),
    output: (s) {
      s.contains("columns: ['lastName', 'firstName']");
      s.contains("covering: ['balance']");
    },
  );

  testCodeGeneration(
    name: 'Index without covering: [...] defaults to an empty list',
    source: schema(
      body: '''
    @Index.field()
    String get accountNumber;
''',
    ),
    output: (s) => s.contains('covering: []'),
  );

  testCodeGeneration(
    name: 'Index.field(covering: [...]) rejects unknown field',
    source: schema(
      body: '''
    @Index.field(covering: ['noSuchField'])
    String get accountNumber;
''',
    ),
    error: (s) => s.contains(
      '`Index.field(covering: ...)` references unknown field "noSuchField"',
    ),
  );

  testCodeGeneration(
    name: 'Index.field(covering: [...]) rejects field already in the key',
    source: schema(
      body: '''
    @Index.field(covering: ['accountNumber'])
    String get accountNumber;
''',
    ),
    error: (s) => s.contains(
      '`Index.field(covering: ...)` references field "accountNumber", '
      'which is already part of the index key.',
    ),
  );

  testCodeGeneration(
    name: 'Index(covering: [...]) rejects field already in the key',
    source: schema(
      classAnnotations:
          "@Index(fields: ['firstName'], covering: "
          "['firstName'])",
      body: '    String get firstName;',
    ),
    error: (s) => s.contains(
      '`Index(covering: ...)` references field "firstName", '
      'which is already part of the index key.',
    ),
  );

  testCodeGeneration(
    name: 'covering: [...] on a JsonValue field is allowed',
    source: schema(
      body: '''
    @Index.field(covering: ['metadata'])
    String get accountNumber;

    JsonValue get metadata;
''',
    ),
    output: (s) => s.contains("covering: ['metadata']"),
  );
}
