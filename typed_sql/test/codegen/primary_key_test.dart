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
    name: 'PrimaryKey annotation is required',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<Item> get items;
      }

      abstract final class Item extends Row {
        int get id;

        String get value;
      }
    ''',
    error: contains(
      'subclasses of `Row` must have one `PrimaryKey` annotation',
    ),
  );

  testCodeGeneration(
    name: 'PrimaryKey annotation references unknown field',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<Item> get items;
      }

      @PrimaryKey(['wrong_id'])
      abstract final class Item extends Row {
        int get id;

        String get value;
      }
    ''',
    error: contains('PrimaryKey annotation references unknown field'),
  );

  testCodeGeneration(
    name: 'PrimaryKey annotation must be non-empty',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<Item> get items;
      }

      @PrimaryKey([])
      abstract final class Item extends Row {
        int get id;

        String get value;
      }
    ''',
    error: contains(
      'subclasses of `Row` must have a non-empty `PrimaryKey` annotation',
    ),
  );

  testCodeGeneration(
    name: 'PrimaryKey annotation may not have duplicate entries',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<Item> get items;
      }

      @PrimaryKey(['id', 'id'])
      abstract final class Item extends Row {
        int get id;

        String get value;
      }
    ''',
    error: contains(
      'subclasses of `Row` cannot have duplicate fields in `PrimaryKey`',
    ),
  );

  testCodeGeneration(
    name: 'PrimaryKey fields cannot be nullable',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<Item> get items;
      }

      @PrimaryKey(['id'])
      abstract final class Item extends Row {
        int? get id;

        String get value;
      }
    ''',
    error: contains(
      'PrimaryKey fields cannot be nullable',
    ),
  );
}
