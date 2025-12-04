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
    name: 'DefaultValue works for String',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<Item> get items;
      }

      @PrimaryKey(['id'])
      abstract final class Item extends Row {
        @AutoIncrement()
        int get id;

        @DefaultValue('hello world')
        String get value;
      }
    ''',
    generated: allOf(contains('extends Item'), contains('hello world')),
  );

  testCodeGeneration(
    name: 'Only one DefaultValue is allowed',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<Item> get items;
      }

      @PrimaryKey(['id'])
      abstract final class Item extends Row {
        @AutoIncrement()
        int get id;

        @DefaultValue('hello world')
        @DefaultValue('choose')
        String get value;
      }
    ''',
    error: contains('Only one DefaultValue annotation is allowed'),
  );

  testCodeGeneration(
    name: 'DefaultValue.epoch on DateTime fields only',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<Item> get items;
      }

      @PrimaryKey(['id'])
      abstract final class Item extends Row {
        @AutoIncrement()
        int get id;

        @DefaultValue.epoch
        String get value;
      }
    ''',
    error: contains('DefaultValue.epoch is only allowed for DateTime fields'),
  );

  testCodeGeneration(
    name: 'DefaultValue.now on DateTime fields only',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<Item> get items;
      }

      @PrimaryKey(['id'])
      abstract final class Item extends Row {
        @AutoIncrement()
        int get id;

        @DefaultValue.now
        String get value;
      }
    ''',
    error: contains('DefaultValue.now is only allowed for DateTime fields'),
  );

  testCodeGeneration(
    name: 'DefaultValue.dateTime(...) on DateTime fields only',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<Item> get items;
      }

      @PrimaryKey(['id'])
      abstract final class Item extends Row {
        @AutoIncrement()
        int get id;

        @DefaultValue.dateTime(2025, 1, 1)
        String get value;
      }
    ''',
    error: contains(
      'DefaultValue.dateTime(...) is only allowed for DateTime fields',
    ),
  );

  testCodeGeneration(
    name: 'DefaultValue(const Deprecated("nonsense")) is disallowed!',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<Item> get items;
      }

      @PrimaryKey(['id'])
      abstract final class Item extends Row {
        @AutoIncrement()
        int get id;

        @DefaultValue(const Deprecated('nosense'))
        String get value;
      }
    ''',
    error: contains('Disallowed value in @DefaultValue(value) annotation'),
  );

  testCodeGeneration(
    name: 'DefaultValue(String) only allowed for String fields',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<Item> get items;
      }

      @PrimaryKey(['id'])
      abstract final class Item extends Row {
        @AutoIncrement()
        int get id;

        @DefaultValue('hello world')
        int get value;
      }
    ''',
    error: contains('DefaultValue(String) is only allowed for String fields'),
  );

  testCodeGeneration(
    name: 'DefaultValue(bool) only allowed for bool fields',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<Item> get items;
      }

      @PrimaryKey(['id'])
      abstract final class Item extends Row {
        @AutoIncrement()
        int get id;

        @DefaultValue(true)
        int get value;
      }
    ''',
    error: contains('DefaultValue(bool) is only allowed for bool fields'),
  );

  testCodeGeneration(
    name: 'DefaultValue(int) cannot be cast to double',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<Item> get items;
      }

      @PrimaryKey(['id'])
      abstract final class Item extends Row {
        @AutoIncrement()
        int get id;

        @DefaultValue(9007199254740992)
        double get value;
      }
    ''',
    error: contains(
      'DefaultValue(int) cannot be cast to double',
    ),
  );

  testCodeGeneration(
    name: 'DefaultValue(int) only allowed for int fields',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<Item> get items;
      }

      @PrimaryKey(['id'])
      abstract final class Item extends Row {
        @AutoIncrement()
        int get id;

        @DefaultValue(42)
        String get value;
      }
    ''',
    error: contains(
      'DefaultValue(int) is only allowed for int or double fields',
    ),
  );

  testCodeGeneration(
    name: 'DefaultValue(double) only allowed for double fields',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<Item> get items;
      }

      @PrimaryKey(['id'])
      abstract final class Item extends Row {
        @AutoIncrement()
        int get id;

        @DefaultValue(3.14)
        String get value;
      }
    ''',
    error: contains(
      'DefaultValue(double) is only allowed for double fields',
    ),
  );
}
