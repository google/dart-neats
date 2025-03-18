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
      ?.resolve('../test/typed_sql/crud/');
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
  }
}

final instances = [
  {
    'name': 'integer',
    'type': 'int',
    'initialValue': '42',
    'updatedValue': '21',
    'equality': 'equals',
  },
  {
    'name': 'text',
    'type': 'String',
    'initialValue': '\'hello\'',
    'updatedValue': '\'hello world\'',
    'equality': 'equals',
  },
  {
    'name': 'boolean',
    'type': 'bool',
    'initialValue': 'true',
    'updatedValue': 'false',
    'equality': 'equals',
  },
  {
    'name': 'real',
    'type': 'double',
    'initialValue': '42.2',
    'updatedValue': '43.2',
    'equality': 'equals',
  },
  {
    'name': 'datetime',
    'type': 'DateTime',
    'initialValue': 'DateTime(2024).toUtc()',
    'updatedValue': 'DateTime(2025).toUtc()',
    'equality': 'equals',
  },
  {
    'name': 'blob',
    'type': 'Uint8List',
    'initialValue': 'Uint8List.fromList([1, 2, 3])',
    'updatedValue': 'Uint8List.fromList([1, 2, 3, 4])',
    'equality': 'deepEquals',
  },
];

final template = '''
// GENERATED CODE - DO NOT MODIFY BY HAND
//
// See tool/generate_crud_tests.dart

// ignore: unused_import
import 'dart:typed_data';

import 'package:typed_sql/typed_sql.dart';

import '../../testrunner.dart';

part '{{name}}_test.g.dart';

abstract final class TestDatabase extends Schema {
  Table<Item> get items;
}

@PrimaryKey(['id'])
abstract final class Item extends Model {
  @AutoIncrement()
  int get id;

  {{type}} get value;
}

void main() {
  final r = TestRunner<TestDatabase>(
    setup: (db) async {
      await db.createTables();
    },
  );

  final initialValue = {{initialValue}};
  final updatedValue = {{updatedValue}};

  r.addTest('insert', (db) async {
    await db.items
        .insert(
          id: literal(1),
          value: literal(initialValue),
        )
        .execute();

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.{{equality}}(initialValue);
  });

  r.addTest('update', (db) async {
    await db.items
        .insert(
          id: literal(1),
          value: literal(initialValue),
        )
        .execute();

    await db.items.updateAll((item, set) => set(
          value: literal(updatedValue),
        ));

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.{{equality}}(updatedValue);
  });

  r.addTest('delete', (db) async {
    await db.items
        .insert(
          id: literal(1),
          value: literal(initialValue),
        )
        .execute();

    final item1 = await db.items.first.fetch();
    check(item1).isNotNull();

    await db.items.where((i) => i.id.equalsLiteral(1)).delete();

    final item2 = await db.items.first.fetch();
    check(item2).isNull();
  });

  r.run();
}
''';
