// Copyright 2026 Google LLC
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

part 'advanced_composite_fk_test.g.dart';

abstract final class BlogDatabase extends Schema {
  Table<Post> get posts;
  Table<Comment> get comments;
}

@PrimaryKey(['author', 'slug'])
abstract final class Post extends Row {
  @SqlOverride.field(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String get author;
  @SqlOverride.field(dialect: 'mysql', columnType: 'VARCHAR(255)')
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
  @AutoIncrement()
  int get commentId;

  @SqlOverride.field(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String get author;
  @SqlOverride.field(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String get postSlug;

  String get comment;
}

void main() {
  final r = TestRunner<BlogDatabase>(
    setup: (db) async {
      await db.createTables();
    },
  );

  r.addTest('Query with composite FK subquery', (db) async {
    await db.posts
        .insertValue(author: 'alice', slug: 'hello', content: 'world')
        .execute();
    await db.comments
        .insertValue(author: 'alice', postSlug: 'hello', comment: 'nice')
        .execute();

    final result = await db.comments
        .select(
          (c) => (
            c.comment,
            c.post.content,
          ),
        )
        .fetch();

    check(result).unorderedEquals([
      ('nice', 'world'),
    ]);
  });

  r.addTest('Query with composite FK reverse lookup (as comments)', (db) async {
    await db.posts
        .insertValue(author: 'alice', slug: 'hello', content: 'world')
        .execute();
    await db.comments
        .insertValue(author: 'alice', postSlug: 'hello', comment: 'nice1')
        .execute();
    await db.comments
        .insertValue(author: 'alice', postSlug: 'hello', comment: 'nice2')
        .execute();

    final result = await db.posts
        .select(
          (p) => (
            p.slug,
            p.comments.count(),
          ),
        )
        .fetch();

    check(result).unorderedEquals([
      ('hello', 2),
    ]);
  });

  r.run();
}
