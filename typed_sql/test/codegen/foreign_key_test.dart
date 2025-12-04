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
    name: 'References works',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<Author> get authors;
        Table<Book> get books;
      }

      @PrimaryKey(['authorId'])
      abstract final class Author extends Row {
        int get authorId;
      }

      @PrimaryKey(['bookId'])
      abstract final class Book extends Row {
        int get bookId;

        @References(table: 'authors', field: 'authorId', name: 'author', as: 'books')
        int get authorId;
      }
    ''',
    generated: anything,
  );

  testCodeGeneration(
    name: 'Refences(table: "") is not allowed',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<Author> get authors;
        Table<Book> get books;
      }

      @PrimaryKey(['authorId'])
      abstract final class Author extends Row {
        int get authorId;
      }

      @PrimaryKey(['bookId'])
      abstract final class Book extends Row {
        int get bookId;

        @References(table: '', field: 'authorId', name: 'author', as: 'books')
        int get authorId;
      }
    ''',
    error: contains(
      'References annotation must have `table` and `field` fields',
    ),
  );

  testCodeGeneration(
    name: 'References uses a conflicting "name"',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<Author> get authors;
        Table<Book> get books;
      }

      @PrimaryKey(['authorId'])
      abstract final class Author extends Row {
        int get authorId;
      }

      @PrimaryKey(['bookId'])
      abstract final class Book extends Row {
        int get bookId;

        @References(table: 'authors', field: 'authorId', name: 'bookId', as: 'books')
        int get authorId;
      }
    ''',
    error: contains(
      'References have `name: "bookId"` which conflicts with the field',
    ),
  );

  testCodeGeneration(
    name: 'Foreign key references unknown table',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<Author> get authors;
        Table<Book> get books;
      }

      @PrimaryKey(['authorId'])
      abstract final class Author extends Row {
        int get authorId;
      }

      @PrimaryKey(['bookId'])
      abstract final class Book extends Row {
        int get bookId;

        @References(table: 'wrongTable', field: 'authorId', name: 'author', as: 'books')
        int get authorId;
      }
    ''',
    error: contains('Foreign key references unknown table'),
  );

  testCodeGeneration(
    name: 'Foreign key references unknown field',
    source: r'''
      abstract final class TestDatabase extends Schema {
        Table<Author> get authors;
        Table<Book> get books;
      }

      @PrimaryKey(['authorId'])
      abstract final class Author extends Row {
        int get authorId;
      }

      @PrimaryKey(['bookId'])
      abstract final class Book extends Row {
        int get bookId;

        @References(table: 'authors', field: 'wrongField', name: 'author', as: 'books')
        int get authorId;
      }
    ''',
    error: contains('Foreign key references unknown field'),
  );
}
