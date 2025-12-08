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

import 'dart:io';
import 'dart:isolate';

void main() {
  final outUri = Isolate.resolvePackageUriSync(Uri.parse('package:typed_sql/'))
      ?.resolve('../test/typed_sql/unique/types/');
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
    'name': 'unique_integer',
    'type': 'int',
    'sqlOverride': '',
    'value1': '42',
    'value2': '21',
    'equality': 'equals',
  },
  {
    'name': 'unique_text',
    'type': 'String',
    'sqlOverride': "@SqlOverride(dialect: 'mysql', columnType: 'VARCHAR(255)')",
    'value1': '\'hello world\'',
    'value2': '\'Hej verden\'',
    'equality': 'equals',
  },
  {
    'name': 'unique_boolean',
    'type': 'bool',
    'sqlOverride': '',
    'value1': 'true',
    'value2': 'false',
    'equality': 'equals',
  },
  {
    'name': 'unique_real',
    'type': 'double',
    'sqlOverride': '',
    'value1': '42.2',
    'value2': '3.14',
    'equality': 'equals',
  },
  {
    'name': 'unique_zero_real',
    'type': 'double',
    'sqlOverride': '',
    'value1': '0.0',
    'value2': '3.14',
    'equality': 'equals',
  },
];

final template = '''
// GENERATED CODE - DO NOT MODIFY BY HAND
//
// See tool/generate_unique_tests.dart

import 'package:typed_sql/typed_sql.dart';

import '../../../testrunner.dart';

part '{{name}}_test.g.dart';

final _value1 = {{value1}};
final _value2 = {{value2}};

abstract final class PrimaryDatabase extends Schema {
  Table<Item> get items;
}

@PrimaryKey(['id'])
abstract final class Item extends Row {
  @AutoIncrement()
  int get id;

  @Unique.field()
  {{sqlOverride}}
  {{type}} get value;
}

void main() {
  final r = TestRunner<PrimaryDatabase>(
    setup: (db) async {
      await db.createTables();
    },
  );

  r.addTest('db.items.insert', (db) async {
    await db.items.insert(value: toExpr(_value1)).execute();
    await db.items.insert(value: toExpr(_value2)).execute();
  });

  r.addTest('db.items.insert (unique violation)', (db) async {
    await db.items.insert(value: toExpr(_value1)).execute();
    try {
      await db.items.insert(value: toExpr(_value1)).execute();
      fail('expected violation of unique constraint!');
    } on OperationException {
      return;
    }
  });

  r.addTest('db.items.byValue()', (db) async {
    await db.items.insert(value: toExpr(_value1)).execute();
    await db.items.insert(value: toExpr(_value2)).execute();

    final item = await db.items.byValue(_value1).fetch();
    check(item).isNotNull().value.{{equality}}(_value1);
  });

  r.addTest('db.items.byValue() - not found', (db) async {
    await db.items.insert(value: toExpr(_value1)).execute();

    final item = await db.items.byValue(_value2).fetch();
    check(item).isNull();
  });

  r.run();
}

''';
