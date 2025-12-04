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
    name: 'Row classes works when "abstract final"',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<Item> get items;
      }

      @PrimaryKey(['id'])
      abstract final class Item extends Row {
        int get id;

        String get value;
      }
    ''',
    generated: contains('extends Item'),
  );

  testCodeGeneration(
    name: 'Row classes must be "final"',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<Item> get items;
      }

      @PrimaryKey(['id'])
      abstract class Item extends Row {
        int get id;

        String get value;
      }
    ''',
    error: contains('final'),
  );

  testCodeGeneration(
    name: 'Row classes must be "abstract"',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<Item> get items;
      }

      @PrimaryKey(['id'])
      final class Item extends Row {
        int get id;

        String get value;
      }
    ''',
    error: contains('abstract'),
  );

  testCodeGeneration(
    name: 'Row classes can only be used for one table',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<Item> get items1;
        Table<Item> get items2;
      }

      @PrimaryKey(['id'])
      abstract final class Item extends Row {
        int get id;

        String get value;
      }
    ''',
    error: contains('"Item" is used in more than one table'),
  );

  testCodeGeneration(
    name: 'Row classes cannot have methods',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<Item> get items;
      }

      @PrimaryKey(['id'])
      abstract final class Item extends Row {
        int get id;

        String get value;

        void sayHello() {
          print('hello world');
        }
      }
    ''',
    error: contains('subclasses of `Row` cannot have methods'),
  );

  testCodeGeneration(
    name: 'Row classes cannot have setters',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<Item> get items;
      }

      @PrimaryKey(['id'])
      abstract final class Item extends Row {
        int get id;

        String get value;
        set value(String value);
      }
    ''',
    error: contains('subclasses of `Row` cannot have setters'),
  );

  testCodeGeneration(
    name: 'Row classes cannot have concrete getters',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<Item> get items;
      }

      @PrimaryKey(['id'])
      abstract final class Item extends Row {
        int get id;

        String get value => 42;
      }
    ''',
    error: contains('subclasses of `Row` can only abstract getters'),
  );

  testCodeGeneration(
    name: 'Row classes cannot have Exception fields',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<Item> get items;
      }

      @PrimaryKey(['id'])
      abstract final class Item extends Row {
        int get id;

        Exception get value;
      }
    ''',
    error: contains('Unsupported data-type'),
  );
}
