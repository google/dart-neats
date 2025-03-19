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
      ?.resolve('../test/typed_sql/nullable/');
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
    'name': 'nullable_integer',
    'type': 'int',
    'value': '42',
  },
  {
    'name': 'nullable_text',
    'type': 'String',
    'value': '\'hello\'',
  },
  {
    'name': 'nullable_boolean',
    'type': 'bool',
    'value': 'true',
  },
  {
    'name': 'nullable_real',
    'type': 'double',
    'value': '42.2',
  },
  {
    'name': 'nullable_datetime',
    'type': 'DateTime',
    'value': 'DateTime(2024).toUtc()',
  },
];

final template = '''
// GENERATED CODE - DO NOT MODIFY BY HAND
//
// See tool/generate_default_tests.dart

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

  {{type}}? get value;
}

final _value = {{value}};

void main() {
  final r = TestRunner<TestDatabase>(
    setup: (db) async {
      await db.createTables();
    },
  );

  r.addTest('.insert() non-null value', (db) async {
    await db.items
        .insert(
          id: literal(1),
          value: literal(_value),
        )
        .execute();

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.equals(_value);
  });

  r.addTest('.insertLiteral() non-null value', (db) async {
    await db.items
        .insertLiteral(
          id: 1,
          value: _value,
        )
        .execute();

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.equals(_value);
  });

  r.addTest('.insert() null by default', (db) async {
    await db.items
        .insert(
          id: literal(1),
        )
        .execute();

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.isNull();
  });

  r.addTest('.insertLiteral() null by default', (db) async {
    await db.items
        .insertLiteral(
          id: 1,
        )
        .execute();

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.isNull();
  });

  r.addTest('.insert() null explicitly', (db) async {
    await db.items
        .insert(
          id: literal(1),
          value: literal(null),
        )
        .execute();

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.isNull();
  });

  r.addTest('.update() null by default', (db) async {
    await db.items
        .insert(
          id: literal(1),
        )
        .execute();

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.isNull();

    await db.items
        .byKey(id: 1)
        .update((item, set) => set(
              value: literal(_value),
            ))
        .execute();

    final updateItem = await db.items.first.fetch();
    check(updateItem).isNotNull().value.equals(_value);
  });

  r.addTest('.update() null explicitly', (db) async {
    await db.items
        .insert(
          id: literal(1),
          value: literal(null),
        )
        .execute();

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.isNull();

    await db.items
        .byKey(id: 1)
        .update((item, set) => set(
              value: literal(_value),
            ))
        .execute();

    final updateItem = await db.items.first.fetch();
    check(updateItem).isNotNull().value.equals(_value);
  });

  r.run();
}
''';
