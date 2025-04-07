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

import 'package:test/test.dart';
import 'package:typed_sql/typed_sql.dart';

import '../testrunner.dart';

part 'model_documentation_test.g.dart';

abstract final class TestDatabase extends Schema {
  /// Table of authors that have written or edited books.
  ///
  /// Notice, that we can write multi-line comments here.
  Table<Author> get authors;

  // We don't have to write documentation comments, code-gen works without them
  // too -- at-least that's what we're testing here!
  Table<Book> get books;
}

/// Represents a row in the `authors` table.
@PrimaryKey(['authorId'])
abstract final class Author extends Model {
  /// Primary key for the `authors` table.
  @AutoIncrement()
  int get authorId;

  /// Name of the author.
  ///
  /// This is the fullname, which is important to say, so that we test
  /// multi-line documentation comments on fields as well!
  String get name;

  /// `bookId` of this authors favorite book, if any.
  @References(
    table: 'books',
    field: 'bookId',
    name: 'favoriteBook',
    as: 'favoritedBy',
  )
  int? get favoriteBookId;
}

@PrimaryKey(['bookId'])
abstract final class Book extends Model {
  @AutoIncrement()
  int get bookId;

  String get title;

  @References(table: 'authors', field: 'authorId', name: 'author', as: 'books')
  int get authorId;

  /// Not all books have an editor.
  @References(
    table: 'authors',
    field: 'authorId',
    name: 'editor',
    as: 'booksEditedBy',
  )
  int? get editorId;

  int get stock;
}

void main() {
  test('nothing', () {
    // The test here is really mostly that we don't get analysis errors from
    // invalid references in documentation comments in the generated files.
  });
}
