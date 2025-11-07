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

part 'blog_test.g.dart';

// #region schema
abstract final class BlogDatabase extends Schema {
  Table<Post> get posts;
  Table<Comment> get comments;
}

@PrimaryKey(['author', 'slug'])
abstract final class Post extends Row {
  @SqlOverride(dialect: 'mysql', columnType: 'VARCHAR(255)') // #hide
  String get author;
  @SqlOverride(dialect: 'mysql', columnType: 'VARCHAR(255)') // #hide
  String get slug;

  String get content;
}

@PrimaryKey(['commentId'])
@ForeignKey(
  ['author', 'postSlug'],
  table: 'posts',
  fields: ['author', 'slug'],
  name: 'post',
  as: 'comments',
)
abstract final class Comment extends Row {
  int get commentId;

  // composite foreign key
  @SqlOverride(dialect: 'mysql', columnType: 'VARCHAR(255)') // #hide
  String get author;
  @SqlOverride(dialect: 'mysql', columnType: 'VARCHAR(255)') // #hide
  String get postSlug;

  String get comment;
}
// #endregion

void main() {
  final r = TestRunner<BlogDatabase>(
    setup: (db) async {
      await db.createTables();
    },
  );

  r.addTest('sanity tests', (db) async {
    await db.posts
        .insert(
          author: 'tom'.asExpr,
          slug: 'mice-traps-101'.asExpr,
          content: 'TODO: Buy cheese'.asExpr,
        )
        .execute();

    await db.comments
        .insert(
          commentId: 1.asExpr,
          author: 'tom'.asExpr,
          postSlug: 'mice-traps-101'.asExpr,
          comment: 'Authentic swiss cheese, please -- jerry'.asExpr,
        )
        .execute();
  });

  r.run();
}
