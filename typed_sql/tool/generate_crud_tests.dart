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
    'name': 'integer',
    'type': 'int',
    'initialValue': '42',
    'updatedValue': '21',
    'emptyValue': '0',
    'otherValue': '-5',
    'equality': 'equals',
  },
  {
    'name': 'text',
    'type': 'String',
    'initialValue': '\'hello\'',
    'updatedValue': '\'hello world\'',
    'emptyValue': '\'\'',
    'otherValue': '\'-\'',
    'equality': 'equals',
  },
  {
    'name': 'boolean',
    'type': 'bool',
    'initialValue': 'true',
    'updatedValue': 'false',
    'emptyValue': 'false',
    'otherValue': 'true',
    'equality': 'equals',
  },
  {
    'name': 'real',
    'type': 'double',
    'initialValue': '42.2',
    'updatedValue': '43.2',
    'emptyValue': '0.0',
    'otherValue': '-5.2',
    'equality': 'equals',
  },
  {
    'name': 'datetime',
    'type': 'DateTime',
    'initialValue': 'DateTime(2024).toUtc()',
    'updatedValue': 'DateTime(2025).toUtc()',
    'emptyValue': 'DateTime.utc(0)',
    'otherValue': 'DateTime.utc(1)',
    'equality': 'equals',
  },
  {
    'name': 'blob',
    'type': 'Uint8List',
    'initialValue': 'Uint8List.fromList([1, 2, 3])',
    'updatedValue': 'Uint8List.fromList([1, 2, 3, 4])',
    'emptyValue': 'Uint8List.fromList([])',
    'otherValue': 'Uint8List.fromList([0])',
    'equality': 'deepEquals',
  },
  {
    'name': 'json',
    'type': 'JsonValue',
    'initialValue': 'JsonValue({\'x\': 1})',
    'updatedValue': 'JsonValue({\'x\': 2})',
    'emptyValue': 'JsonValue([])',
    'otherValue': 'JsonValue(true)',
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
abstract final class Item extends Row {
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
  final emptyValue = {{emptyValue}};
  final otherValue = {{otherValue}};

  r.addTest('.insert()', (db) async {
    await db.items
        .insert(
          id: toExpr(1),
          value: toExpr(initialValue),
        )
        .execute();

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.{{equality}}(initialValue);
  });

  r.addTest('.insert(value: empty)', (db) async {
    await db.items
        .insert(
          id: toExpr(1),
          value: toExpr(emptyValue),
        )
        .execute();

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.{{equality}}(emptyValue);
  });

  r.addTest('.insert(value: other)', (db) async {
    await db.items
        .insert(
          id: toExpr(1),
          value: toExpr(otherValue),
        )
        .execute();

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.{{equality}}(otherValue);
  });

  r.addTest('.insert().returnInserted()', (db) async {
    final item = await db.items
        .insert(
          id: toExpr(1),
          value: toExpr(initialValue),
        )
        .returnInserted()
        .executeAndFetch();
    check(item).isNotNull().value.{{equality}}(initialValue);
  });

  r.addTest('.insert().returning(.value)', (db) async {
    final value = await db.items
        .insert(
          id: toExpr(1),
          value: toExpr(initialValue),
        )
        .returning((item) => (item.value,))
        .executeAndFetch();
    check(value).isNotNull().{{equality}}(initialValue);
  });

  r.addTest('.update()', (db) async {
    await db.items
        .insert(
          id: toExpr(1),
          value: toExpr(initialValue),
        )
        .execute();

    await db.items
        .update((item, set) => set(
              value: toExpr(updatedValue),
            ))
        .execute();

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.{{equality}}(updatedValue);
  });

  r.addTest('.update().returnUpdated()', (db) async {
    await db.items
        .insert(
          id: toExpr(1),
          value: toExpr(initialValue),
        )
        .execute();

    final updatedItems = await db.items
        .update((item, set) => set(
              value: toExpr(updatedValue),
            ))
        .returnUpdated()
        .executeAndFetch();

    check(updatedItems)
      ..length.equals(1)
      ..first.value.{{equality}}(updatedValue);

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.{{equality}}(updatedValue);
  }, skipMysql: 'UPDATE RETURNING not supported');

  r.addTest('.update().returning(.value)', (db) async {
    await db.items
        .insert(
          id: toExpr(1),
          value: toExpr(initialValue),
        )
        .execute();

    final values = await db.items
        .update((item, set) => set(
              value: toExpr(updatedValue),
            ))
        .returning((item) => (item.value,))
        .executeAndFetch();

    check(values)
      ..length.equals(1)
      ..first.{{equality}}(updatedValue);

    final item = await db.items.first.fetch();
    check(item).isNotNull().value.{{equality}}(updatedValue);
  }, skipMysql: 'UPDATE RETURNING not supported');

  r.addTest('.delete()', (db) async {
    await db.items
        .insert(
          id: toExpr(1),
          value: toExpr(initialValue),
        )
        .execute();

    final item1 = await db.items.first.fetch();
    check(item1).isNotNull();

    await db.items.where((i) => i.id.equalsValue(1)).delete().execute();

    final item2 = await db.items.first.fetch();
    check(item2).isNull();
  });

  r.addTest('.delete().returnDeleted()', (db) async {
    await db.items
        .insert(
          id: toExpr(1),
          value: toExpr(initialValue),
        )
        .execute();

    final item1 = await db.items.first.fetch();
    check(item1).isNotNull();

    final deletedItems = await db.items
        .where((i) => i.id.equalsValue(1))
        .delete()
        .returnDeleted()
        .executeAndFetch();
    check(deletedItems)
      ..length.equals(1)
      ..first.value.{{equality}}(initialValue);

    final item2 = await db.items.first.fetch();
    check(item2).isNull();
  });

  r.addTest('.delete().returning(.value)', (db) async {
    await db.items
        .insert(
          id: toExpr(1),
          value: toExpr(initialValue),
        )
        .execute();

    final item1 = await db.items.first.fetch();
    check(item1).isNotNull();

    final values = await db.items
        .where((i) => i.id.equalsValue(1))
        .delete()
        .returning((item) => (item.value,))
        .executeAndFetch();
    check(values)
      ..length.equals(1)
      ..first.{{equality}}(initialValue);

    final item2 = await db.items.first.fetch();
    check(item2).isNull();
  });

  r.run();
}
''';
