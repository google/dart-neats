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
      ?.resolve('../test/typed_sql/default/');
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
    'name': 'default_integer',
    'type': 'int',
    'defaultValue': '42',
    'nonDefaultValue': '21',
  },
  {
    'name': 'default_text',
    'type': 'String',
    'defaultValue': '\'hello\'',
    'nonDefaultValue': '\'hello world\'',
  },
  {
    'name': 'default_boolean',
    'type': 'bool',
    'defaultValue': 'true',
    'nonDefaultValue': 'false',
  },
  {
    'name': 'default_real',
    'type': 'double',
    'defaultValue': '42.2',
    'nonDefaultValue': '3.14',
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

import '../../testrunner.dart';

part '{{name}}_test.g.dart';

abstract final class TestDatabase extends Schema {
  Table<Item> get items;
}

const _defaultValue = {{defaultValue}};
const _nonDefaultValue = {{nonDefaultValue}};

@PrimaryKey(['id'])
abstract final class Item extends Model {
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
          id: literal(1),
          value: literal(_nonDefaultValue),
        )
        .execute();

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.equals(_nonDefaultValue);
  });

  r.addTest('.insertLiteral() without default', (db) async {
    await db.items
        .insertLiteral(
          id: 1,
          value: _nonDefaultValue,
        )
        .execute();

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.equals(_nonDefaultValue);
  });

  r.addTest('.insert() with default', (db) async {
    await db.items
        .insert(
          id: literal(1),
        )
        .execute();

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.equals(_defaultValue);
  });

  r.addTest('.insertLiteral() with default', (db) async {
    await db.items
        .insertLiteral(
          id: 1,
        )
        .execute();

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.equals(_defaultValue);
  });

  r.addTest('.update() default value', (db) async {
    await db.items
        .insert(
          id: literal(1),
        )
        .execute();

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.equals(_defaultValue);

    await db.items.byKey(id: 1).update((item, set) => set(
          value: literal(_nonDefaultValue),
        ));

    final updateItem = await db.items.first.fetch();
    check(updateItem).isNotNull().value.equals(_nonDefaultValue);
  });

  r.run();
}
''';
