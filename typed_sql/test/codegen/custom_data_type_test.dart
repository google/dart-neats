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
    name: 'MyCustomType implements CustomDataType<String> works',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<Item> get items;
      }

      @PrimaryKey(['id'])
      abstract final class Item extends Row {
        int get id;
        MyCustomType get value;
      }

      final class MyCustomType implements CustomDataType<String> {
        final String value;

        MyCustomType(this.value);

        factory MyCustomType.fromDatabase(String value) => MyCustomType(value);

        @override
        String toDatabase() => value;
      }
    ''',
    generated: anything,
  );

  testCodeGeneration(
    name: 'Unsupported type parameter for `CustomDataType<T>`',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<Item> get items;
      }

      @PrimaryKey(['id'])
      abstract final class Item extends Row {
        int get id;
        MyCustomType get value;
      }

      final class MyCustomType implements CustomDataType<Exception> {
        final String value;

        MyCustomType(this.value);

        factory MyCustomType.fromDatabase(String value) => MyCustomType(value);

        @override
        String toDatabase() => value;
      }
    ''',
    error: contains('Unsupported type parameter for `CustomDataType<T>`'),
  );

  testCodeGeneration(
    name: 'CustomDataType<T?> is not supported',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<Item> get items;
      }

      @PrimaryKey(['id'])
      abstract final class Item extends Row {
        int get id;
        MyCustomType get value;
      }

      final class MyCustomType implements CustomDataType<String?> {
        final String value;

        MyCustomType(this.value);

        factory MyCustomType.fromDatabase(String value) => MyCustomType(value);

        @override
        String toDatabase() => value;
      }
    ''',
    error: contains('CustomDataType<T?> is not supported'),
  );

  testCodeGeneration(
    name: 'CustomDataType<T> subclasses must have a `fromDatabase`',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<Item> get items;
      }

      @PrimaryKey(['id'])
      abstract final class Item extends Row {
        int get id;
        MyCustomType get value;
      }

      final class MyCustomType implements CustomDataType<String> {
        final String value;

        MyCustomType(this.value);

        @override
        String toDatabase() => value;
      }
    ''',
    error: contains(
      'CustomDataType<T> subclasses must have a `fromDatabase` constructor!',
    ),
  );

  testCodeGeneration(
    name: 'fromDatabase` constructor must take a single argument',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<Item> get items;
      }

      @PrimaryKey(['id'])
      abstract final class Item extends Row {
        int get id;
        MyCustomType get value;
      }

      final class MyCustomType implements CustomDataType<String> {
        final String value;

        MyCustomType(this.value);

        factory MyCustomType.fromDatabase(String value, bool disallowedArgument) => MyCustomType(value);

        @override
        String toDatabase() => value;
      }
    ''',
    error: contains('fromDatabase` constructor must take a single argument'),
  );

  testCodeGeneration(
    name: 'fromDatabase` constructor must match backing type',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<Item> get items;
      }

      @PrimaryKey(['id'])
      abstract final class Item extends Row {
        int get id;
        MyCustomType get value;
      }

      final class MyCustomType implements CustomDataType<String> {
        final String value;

        MyCustomType(this.value);

        factory MyCustomType.fromDatabase(bool value) => MyCustomType(value.toString());

        @override
        String toDatabase() => value;
      }
    ''',
    error: contains(
      'must have a `fromDatabase` constructor whose argument type matches the backing type',
    ),
  );

  testCodeGeneration(
    name: 'Type arguments are allowed on CustomDataType subclasses',
    source: r'''
      import 'package:typed_sql/typed_sql.dart';
      import 'dart:convert';
      import 'dart:typed_data';

      part 'schema.g.dart';

      abstract final class TestDatabase extends Schema {
        Table<Item> get items;
      }

      @PrimaryKey(['id'])
      abstract final class Item extends Row {
        int get id;

        MyCustomTypeAlias get value;
      }

      typedef MyCustomTypeAlias = JsonValue<Uint8List>;

      final class JsonValue<T extends Uint8List> implements CustomDataType<T> {
        final Object? jsonValue;

        JsonValue(this.jsonValue);

        factory JsonValue.fromDatabase(Uint8List bytes) =>
            JsonValue(json.fuse(utf8).decode(bytes));

        @override
        T toDatabase() => json.fuse(utf8).encode(jsonValue) as T;
      }
    ''',
    generated: anything,
  );

  testCodeGeneration(
    name: 'Type arguments not allowed on field types',
    source: r'''
      import 'package:typed_sql/typed_sql.dart';
      import 'dart:convert';
      import 'dart:typed_data';

      part 'schema.g.dart';

      abstract final class TestDatabase extends Schema {
        Table<Item> get items;
      }

      @PrimaryKey(['id'])
      abstract final class Item extends Row {
        int get id;

        JsonValue<Uint8List> get value;
      }

      final class JsonValue<T extends Uint8List> implements CustomDataType<T> {
        final Object? jsonValue;

        JsonValue(this.jsonValue);

        factory JsonValue.fromDatabase(Uint8List bytes) =>
            JsonValue(json.fuse(utf8).decode(bytes));

        @override
        T toDatabase() => json.fuse(utf8).encode(jsonValue) as T;
      }
    ''',
    error: contains('Field types may not have type arguments'),
  );
}
