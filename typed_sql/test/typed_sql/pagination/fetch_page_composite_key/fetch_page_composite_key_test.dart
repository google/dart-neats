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

part 'fetch_page_composite_key_test.g.dart';

abstract final class TestDatabase extends Schema {
  Table<Item> get items;
}

@PrimaryKey(['id', 'name'])
abstract final class Item extends Row {
  int get id;

  @SqlOverride.field(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String get name;

  String? get value;
}

// Repeated `id` values with distinct `name`s, so page boundaries can land
// mid-group and exercise the `id == cursor.id & name > cursor.name`
// (or `<` for descending) tie-breaking term, not just the leading
// `id > cursor.id` term.
const _keys = [
  (id: 1, name: 'a'),
  (id: 1, name: 'b'),
  (id: 1, name: 'c'),
  (id: 2, name: 'a'),
  (id: 2, name: 'b'),
];

void main() {
  final r = TestRunner<TestDatabase>(
    setup: (db) async {
      await db.createTables();
    },
  );

  Future<void> insertKeys(Database<TestDatabase> db) async {
    for (final k in _keys) {
      await db.items.insert(id: toExpr(k.id), name: toExpr(k.name)).execute();
    }
  }

  r.addTest(
    '.fetchPage() walks a composite key across group boundaries',
    (db) async {
      await insertKeys(db);

      final page1 = await db.items.fetchPage(
        const ItemPageRequest(pageSize: 2),
      );
      check(page1.items.map((i) => (i.id, i.name)).toList()).deepEquals([
        (1, 'a'),
        (1, 'b'),
      ]);
      check(page1.hasMore).isTrue();

      final page2 = await db.items.fetchPage(page1.nextPageRequest!);
      check(page2.items.map((i) => (i.id, i.name)).toList()).deepEquals([
        (1, 'c'),
        (2, 'a'),
      ]);
      check(page2.hasMore).isTrue();

      final page3 = await db.items.fetchPage(page2.nextPageRequest!);
      check(page3.items.map((i) => (i.id, i.name)).toList()).deepEquals([
        (2, 'b'),
      ]);
      check(page3.hasMore).isFalse();
      check(page3.nextCursor).isNull();
      check(page3.nextPageRequest).isNull();
    },
  );

  r.addTest(
    '.fetchPage() full walk matches an unpaginated .orderBy()',
    (db) async {
      await insertKeys(db);

      final expected = await db.items
          .orderBy((i) => [(i.id, .ascending), (i.name, .ascending)])
          .select((i) => (i.id, i.name))
          .fetch();

      final seen = <(int, String)>[];
      PageRequest<Item, ItemCursor>? request = const ItemPageRequest(
        pageSize: 2,
      );
      while (request != null) {
        final page = await db.items.fetchPage(request);
        seen.addAll(page.items.map((i) => (i.id, i.name)));
        request = page.nextPageRequest;
      }
      check(seen).deepEquals(expected);
    },
  );

  r.addTest(
    '.fetchPage() cursor round-trips through its fields, independently of '
    'nextPageRequest',
    (db) async {
      await insertKeys(db);

      final page1 = await db.items.fetchPage(
        const ItemPageRequest(pageSize: 2),
      );
      final cursor = page1.nextCursor;
      check(cursor).isNotNull();

      // Simulate persisting the cursor's fields (e.g. in a URL) and
      // reconstructing it later, rather than keeping the original cursor or
      // PageRequest object around.
      final reconstructed = ItemCursor(id: cursor!.id, name: cursor.name);

      final expected = await db.items.fetchPage(page1.nextPageRequest!);
      final actual = await db.items.fetchPage(
        ItemPageRequest(pageSize: 2, cursor: reconstructed),
      );
      check(actual.items.map((i) => (i.id, i.name)).toList()).deepEquals(
        expected.items.map((i) => (i.id, i.name)).toList(),
      );
    },
  );

  r.addTest(
    '.fetchPage() with independent per-field directions (id asc, name desc)',
    (db) async {
      await insertKeys(db);

      final expected = await db.items
          .orderBy((i) => [(i.id, .ascending), (i.name, .descending)])
          .select((i) => (i.id, i.name))
          .fetch();

      final seen = <(int, String)>[];
      PageRequest<Item, ItemCursor>? request = const ItemPageRequest(
        pageSize: 2,
        direction: ItemDirection(name: Order.descending),
      );
      while (request != null) {
        final page = await db.items.fetchPage(request);
        seen.addAll(page.items.map((i) => (i.id, i.name)));
        request = page.nextPageRequest;
      }
      check(seen).deepEquals(expected);
    },
  );

  r.run();
}
