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

part 'self_foreign_key_test.g.dart';

abstract final class TestDatabase extends Schema {
  Table<Category> get categories;
  Table<Node> get nodes;
}

/// Single-column self-reference: `parentId` -> `categoryId`.
@PrimaryKey(['categoryId'])
@ForeignKey(
  ['parentId'],
  table: 'categories',
  fields: ['categoryId'],
  name: 'parent',
  as: 'children',
)
abstract final class Category extends Row {
  int get categoryId;

  String get name;

  int? get parentId;
}

/// Multi-column self-reference: (`parentRegion`, `parentCode`) ->
/// (`region`, `code`).
@PrimaryKey(['region', 'code'])
@ForeignKey(
  ['parentRegion', 'parentCode'],
  table: 'nodes',
  fields: ['region', 'code'],
  name: 'parent',
  as: 'children',
)
abstract final class Node extends Row {
  @SqlOverride.field(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String get region;

  @SqlOverride.field(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String get code;

  @SqlOverride.field(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String? get parentRegion;

  @SqlOverride.field(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String? get parentCode;

  int get weight;
}

final _testCategories = [
  (categoryId: 1, name: 'root', parentId: null),
  (categoryId: 2, name: 'a', parentId: 1),
  (categoryId: 3, name: 'b', parentId: 1),
  (categoryId: 4, name: 'a1', parentId: 2),
  (categoryId: 5, name: 'other-root', parentId: null),
];

final _testNodes = [
  (region: 'eu', code: 'r', parentRegion: null, parentCode: null, weight: 1),
  (region: 'eu', code: 'a', parentRegion: 'eu', parentCode: 'r', weight: 2),
  (region: 'us', code: 'a', parentRegion: 'eu', parentCode: 'r', weight: 4),
  (region: 'us', code: 'x', parentRegion: 'us', parentCode: 'a', weight: 8),
  // Same code as 'eu'/'a', but different region: must not match its children.
  (region: 'us', code: 'r', parentRegion: null, parentCode: null, weight: 16),
];

void main() {
  final r = TestRunner<TestDatabase>(
    setup: (db) async {
      await db.createTables();

      for (final v in _testCategories) {
        await db.categories
            .insert(
              categoryId: toExpr(v.categoryId),
              name: toExpr(v.name),
              parentId: toExpr(v.parentId),
            )
            .execute();
      }
      for (final v in _testNodes) {
        await db.nodes
            .insert(
              region: toExpr(v.region),
              code: toExpr(v.code),
              parentRegion: toExpr(v.parentRegion),
              parentCode: toExpr(v.parentCode),
              weight: toExpr(v.weight),
            )
            .execute();
      }
    },
  );

  // Single-column

  r.addTest('categories.select(name, parent.name)', (db) async {
    final result = await db.categories
        .select((c) => (c.name, c.parent.name))
        .fetch();
    check(result).unorderedEquals([
      ('root', null),
      ('a', 'root'),
      ('b', 'root'),
      ('a1', 'a'),
      ('other-root', null),
    ]);
  });

  r.addTest('categories.where(.children.count() >= 2)', (db) async {
    final result = await db.categories
        .where((c) => c.children.count() >= toExpr(2))
        .select((c) => (c.name,))
        .fetch();
    check(result).unorderedEquals(['root']);
  });

  r.addTest('categories.where(.parent.name == a)', (db) async {
    final result = await db.categories
        .where((c) => c.parent.name.equalsValue('a'))
        .select((c) => (c.name,))
        .fetch();
    check(result).unorderedEquals(['a1']);
  });

  r.addTest('categories.join(categories).usingParent()', (db) async {
    final result = await db.categories
        .join(db.categories)
        .usingParent()
        .select((child, parent) => (child.name, parent.name))
        .fetch();
    check(result).unorderedEquals([
      ('a', 'root'),
      ('b', 'root'),
      ('a1', 'a'),
    ]);
  });

  r.addTest('categories.join(categories).usingChildren()', (db) async {
    final result = await db.categories
        .join(db.categories)
        .usingChildren()
        .select((parent, child) => (parent.name, child.name))
        .fetch();
    check(result).unorderedEquals([
      ('root', 'a'),
      ('root', 'b'),
      ('a', 'a1'),
    ]);
  });

  // Multi-column

  r.addTest('nodes.select(code, parent.code)', (db) async {
    final result = await db.nodes
        .select((n) => (n.region, n.code, n.parent.region, n.parent.code))
        .fetch();
    check(result).unorderedEquals([
      ('eu', 'r', null, null),
      ('eu', 'a', 'eu', 'r'),
      ('us', 'a', 'eu', 'r'),
      ('us', 'x', 'us', 'a'),
      ('us', 'r', null, null),
    ]);
  });

  r.addTest('nodes.where(.children.count() >= 2)', (db) async {
    final result = await db.nodes
        .where((n) => n.children.count() >= toExpr(2))
        .select((n) => (n.region, n.code))
        .fetch();
    check(result).unorderedEquals([('eu', 'r')]);
  });

  r.addTest('nodes.select(.children.sum(.weight))', (db) async {
    final result = await db.nodes
        .select(
          (n) => (
            n.region,
            n.code,
            n.children.select((c) => (c.weight,)).sum(),
          ),
        )
        .fetch();
    check(result).unorderedEquals([
      ('eu', 'r', 6),
      ('eu', 'a', 0),
      ('us', 'a', 8),
      ('us', 'x', 0),
      ('us', 'r', 0),
    ]);
  }, skipMysql: 'TODO: Fix nested subqueries in mysql');

  r.addTest('nodes.join(nodes).usingParent()', (db) async {
    final result = await db.nodes
        .join(db.nodes)
        .usingParent()
        .select(
          (child, parent) => (
            child.region,
            child.code,
            parent.region,
            parent.code,
          ),
        )
        .fetch();
    check(result).unorderedEquals([
      ('eu', 'a', 'eu', 'r'),
      ('us', 'a', 'eu', 'r'),
      ('us', 'x', 'us', 'a'),
    ]);
  });

  r.addTest('nodes.join(nodes).usingChildren()', (db) async {
    final result = await db.nodes
        .join(db.nodes)
        .usingChildren()
        .select(
          (parent, child) => (
            parent.region,
            parent.code,
            child.region,
            child.code,
          ),
        )
        .fetch();
    check(result).unorderedEquals([
      ('eu', 'r', 'eu', 'a'),
      ('eu', 'r', 'us', 'a'),
      ('us', 'a', 'us', 'x'),
    ]);
  });

  r.run();
}
