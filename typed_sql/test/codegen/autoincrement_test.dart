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
    name: '@AutoIncrement on int primary key',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<Item> get items;
      }

      @PrimaryKey(['id'])
      abstract final class Item extends Row {
        @AutoIncrement()
        int get id;

        String get value;
      }
    ''',
    generated: contains('extends Item'),
  );

  // TODO: Forbid AutoIncrement on anything that isn't a primary key.
  //       Possibly forbid in composite primary keys too.

  testCodeGeneration(
    name: '@AutoIncrement not allowed on String',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<Item> get items;
      }

      @PrimaryKey(['id'])
      abstract final class Item extends Row {
        String get id;

        @AutoIncrement()
        String get autoId;
      }
    ''',
    error: contains('AutoIncrement is only allowed for int fields'),
  );

  testCodeGeneration(
    name: '@AutoIncrement not allowed on bool',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<Item> get items;
      }

      @PrimaryKey(['id'])
      abstract final class Item extends Row {
        String get id;

        @AutoIncrement()
        bool get autoId;
      }
    ''',
    error: contains('AutoIncrement is only allowed for int fields'),
  );
}
