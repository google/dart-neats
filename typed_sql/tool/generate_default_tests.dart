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

import 'dart:convert' show json;
import 'dart:io';
import 'dart:isolate';

void main() {
  final outUri = Isolate.resolvePackageUriSync(Uri.parse('package:typed_sql/'))
      ?.resolve('../test/typed_sql/default/types/');
  if (outUri == null) {
    print('Cannot resolve package:typed_sql/');
    exit(1);
  }

  for (final i in instances) {
    final name = i['name'];
    final target = File.fromUri(
      outUri.resolve('$name/${name}_test.dart'),
    );
    print('Creating: ${target.path}');
    target.parent.createSync(recursive: true);

    target.writeAsStringSync(i.entries.fold(
      template,
      (template, entry) => template.replaceAll('{{${entry.key}}}', entry.value),
    ));

    if (Process.runSync('dart', ['fix', '--apply', target.absolute.path])
            .exitCode !=
        0) {
      print('Failed to dart fix: ${target.path}');
      exit(1);
    }

    if (Process.runSync('dart', ['format', target.absolute.path]).exitCode !=
        0) {
      print('Failed to format: ${target.path}');
      exit(1);
    }
  }
}

final instances = [
  {
    'name': 'default_integer',
    'type': 'int',
    'defaultValue': '42',
    'nonDefaultValue': '21',
    'equality': 'equals',
  },
  {
    'name': 'default_text',
    'type': 'String',
    'defaultValue': '\'hello\'',
    'nonDefaultValue': '\'hello world\'',
    'equality': 'equals',
  },
  {
    'name': 'default_boolean',
    'type': 'bool',
    'defaultValue': 'true',
    'nonDefaultValue': 'false',
    'equality': 'equals',
  },
  {
    'name': 'default_real',
    'type': 'double',
    'defaultValue': '42.2',
    'nonDefaultValue': '3.14',
    'equality': 'equals',
  },
  {
    'name': 'default_zero_real',
    'type': 'double',
    'defaultValue': '0.0',
    'nonDefaultValue': '3.14',
    'equality': 'equals',
  },
  {
    'name': 'default_json',
    'type': 'JsonValue',
    'defaultValue': 'JsonValue({\'hello\': \'world\', \'count\': 42})',
    'nonDefaultValue': 'JsonValue({\'count\': 43})',
    'equality': 'deepEquals',
  },
  {
    'name': 'default_json_single_quote',
    'type': 'JsonValue',
    'defaultValue':
        'JsonValue({\'description\': \'it\\\'s working\', \'count\': 42})',
    'nonDefaultValue': 'JsonValue({\'count\': 43})',
    'equality': 'deepEquals',
  },
  {
    'name': 'default_json_nested_structures',
    'type': 'JsonValue',
    'defaultValue': 'JsonValue(${json.encode({
          'string': 'hello world',
          'int': 42,
          'double': 3.14,
          'bool': true,
          'null': null,
          'object': {
            'string': 'hello world',
            'int': 42,
            'double': 3.14,
            'bool': true,
            'null': null,
            'array': [1, 2, 3],
            'object': {
              'string': 'hello world',
            }
          },
          'array': [
            'hello world',
            42,
            3.14,
            true,
            null,
          ],
        })})',
    'nonDefaultValue': 'JsonValue({\'count\': 43})',
    'equality': 'deepEquals',
  },
  // TODO: Add support for default DateTime
  /*{
    'name': 'default_datetime',
    'type': 'DateTime',
    'defaultValue': 'DateTime(2024).toUtc()',
    'nonDefaultValue': 'DateTime(2025).toUtc()',
  },*/
];

final template = '''
// GENERATED CODE - DO NOT MODIFY BY HAND
//
// See tool/generate_default_tests.dart

import 'package:typed_sql/typed_sql.dart';

import '../../../testrunner.dart';

part '{{name}}_test.g.dart';

abstract final class TestDatabase extends Schema {
  Table<Item> get items;
}

const _defaultValue = {{defaultValue}};
const _nonDefaultValue = {{nonDefaultValue}};

@PrimaryKey(['id'])
abstract final class Item extends Row {
  @AutoIncrement()
  int get id;

  @DefaultValue(_defaultValue)
  {{type}} get value;
}

void main() {
  final r = TestRunner<TestDatabase>(
    setup: (db) async {
      await db.createTables();
    },
  );

  r.addTest('.insert() without default', (db) async {
    await db.items
        .insert(
          id: toExpr(1),
          value: toExpr(_nonDefaultValue),
        )
        .execute();

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.{{equality}}(_nonDefaultValue);
  });

  r.addTest('.insert() with default', (db) async {
    await db.items
        .insert(
          id: toExpr(1),
        )
        .execute();

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.{{equality}}(_defaultValue);
  });

  r.addTest('.update() default value', (db) async {
    await db.items
        .insert(
          id: toExpr(1),
        )
        .execute();

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.{{equality}}(_defaultValue);

    await db.items
        .byKey(1)
        .update((item, set) => set(
              value: toExpr(_nonDefaultValue),
            ))
        .execute();

    final updateItem = await db.items.first.fetch();
    check(updateItem).isNotNull().value.{{equality}}(_nonDefaultValue);
  });

  r.run();
}
''';
