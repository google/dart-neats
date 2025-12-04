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
    name: 'Schema classes works when "abstract final"',
    source: r'''
      abstract final class TestDatabase extends Schema {}
    ''',
    generated: contains('TestDatabaseSchema on Database<TestDatabase>'),
  );

  testCodeGeneration(
    name: 'Schema classes must be "abstract"',
    source: r'''
      final class TestDatabase extends Schema {}
    ''',
    error: contains('abstract'),
  );

  testCodeGeneration(
    name: 'Schema classes must be "final"',
    source: r'''
      abstract class TestDatabase extends Schema {}
    ''',
    error: contains('final'),
  );

  testCodeGeneration(
    name: 'Only one Schema per library',
    source: r'''
      abstract final class TestDatabase extends Schema {}
      abstract final class TestDatabase2 extends Schema {}
    ''',
    error: contains('Only one Schema per library is allowed'),
  );

  testCodeGeneration(
    name: 'Schema classes cannot have methods',
    source: r'''
      abstract final class TestDatabase extends Schema {
        void sayHello() {
          print('Hello');
        }
      }
    ''',
    error: contains('subclasses of `Schema` cannot have methods'),
  );

  testCodeGeneration(
    name: 'Schema classes cannot have setters',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<Item> get items;
        set items(Table<Item> value);
      }

      @PrimaryKey(['id'])
      abstract final class Item extends Row {
        int get id;
        String get value;
      }
    ''',
    error: contains('subclasses of `Schema` cannot have setters'),
  );

  testCodeGeneration(
    name: 'Schema classes cannot have concrete getters',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<Item> get items => throw UnimplementedError();
      }

      @PrimaryKey(['id'])
      abstract final class Item extends Row {
        int get id;
        String get value;
      }
    ''',
    error: contains('subclasses of `Schema` can only abstract getters'),
  );

  testCodeGeneration(
    name: 'Schema classes must have Table properties',
    source: r'''
      abstract final class TestDatabase extends Schema {
        String get items;
      }
    ''',
    error: contains('subclasses of `Schema` can only have `Table` properties'),
  );

  testCodeGeneration(
    name: 'T in `Table<T>` must be resolvable',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<UnknownItem> get items;
      }
    ''',
    error: contains('Unable to resolve T in `Table<T>` properties'),
  );

  testCodeGeneration(
    name: 'T in `Table<T>` must be a class',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<int> get items;
      }
    ''',
    error: contains('T in `Table<T>` must be a subclass of `Row`'),
  );

  testCodeGeneration(
    name: 'T in `Table<T>` must be a subclass of `Row`',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<Exception> get items;
      }
    ''',
    error: contains('T in `Table<T>` must be a subclass of `Row`'),
  );
}
