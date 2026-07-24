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

part 'fetch_page_basic_test.g.dart';

abstract final class TestDatabase extends Schema {
  Table<Item> get items;
}

@PrimaryKey(['id'])
abstract final class Item extends Row {
  @AutoIncrement()
  int get id;

  String get name;
  int get value;
}

void main() {
  final r = TestRunner<TestDatabase>(
    setup: (db) async {
      await db.createTables();
    },
  );

  Future<void> insertItems(Database<TestDatabase> db, int count) async {
    for (var i = 1; i <= count; i++) {
      await db.items
          .insertValue(id: i, name: 'item-$i', value: i * 10)
          .execute();
    }
  }

  r.addTest('.fetchPage() on an empty table', (db) async {
    final page = await db.items.fetchPage(const ItemPageRequest(pageSize: 10));
    check(page.items).isEmpty();
    check(page.hasMore).isFalse();
    check(page.nextCursor).isNull();
    check(page.nextPageRequest).isNull();
  });

  r.addTest(
    '.fetchPage() walks all rows, exact multiple of pageSize',
    (db) async {
      await insertItems(db, 20);

      final page1 = await db.items.fetchPage(
        const ItemPageRequest(pageSize: 10),
      );
      check(page1.items.map((i) => i.id).toList()).deepEquals(
        List.generate(10, (i) => i + 1),
      );
      check(page1.hasMore).isTrue();
      check(page1.nextCursor).isNotNull();
      check(page1.nextPageRequest).isNotNull();

      final page2 = await db.items.fetchPage(page1.nextPageRequest!);
      check(page2.items.map((i) => i.id).toList()).deepEquals(
        List.generate(10, (i) => i + 11),
      );
      check(page2.hasMore).isFalse();
      check(page2.nextCursor).isNull();
      check(page2.nextPageRequest).isNull();
    },
  );

  r.addTest(
    '.fetchPage() walks all rows, non-exact multiple of pageSize',
    (db) async {
      await insertItems(db, 25);

      final seen = <int>[];
      PageRequest<Item, ItemCursor>? request = const ItemPageRequest(
        pageSize: 10,
      );
      while (request != null) {
        final page = await db.items.fetchPage(request);
        seen.addAll(page.items.map((i) => i.id));
        request = page.nextPageRequest;
      }
      check(seen).deepEquals(List.generate(25, (i) => i + 1));
    },
  );

  r.addTest('.fetchPage() with pageSize larger than row count', (db) async {
    await insertItems(db, 5);

    final page = await db.items.fetchPage(const ItemPageRequest(pageSize: 100));
    check(page.items).length.equals(5);
    check(page.hasMore).isFalse();
    check(page.nextCursor).isNull();
    check(page.nextPageRequest).isNull();
  });

  r.addTest('.fetchPage() composes with .where()', (db) async {
    await insertItems(db, 10);

    final page = await db.items
        .where((i) => i.value > 50.asExpr)
        .fetchPage(const ItemPageRequest(pageSize: 3));
    check(page.items.map((i) => i.id).toList()).deepEquals([6, 7, 8]);
    check(page.hasMore).isTrue();
  });

  r.addTest(
    '.fetchPage() cursor is stable under concurrent inserts',
    (db) async {
      await insertItems(db, 5); // ids 1..5

      final page1 = await db.items.fetchPage(
        const ItemPageRequest(pageSize: 3),
      );
      check(page1.items.map((i) => i.id).toList()).deepEquals([1, 2, 3]);
      final cursor = page1.nextCursor;
      check(cursor).isNotNull();

      // Insert a row before the cursor -- must not reappear on the next page.
      //
      // Uses a negative id rather than 0: MySQL/MariaDB treats a literal `0`
      // in an AUTO_INCREMENT column the same as `NULL` (i.e. "auto-assign"),
      // so it wouldn't actually land before the cursor there.
      await db.items.insertValue(id: -1, name: 'before', value: 0).execute();
      // Insert a row after all existing rows -- must appear on the next page.
      await db.items.insertValue(id: 100, name: 'after', value: 100).execute();

      final page2 = await db.items.fetchPage(page1.nextPageRequest!);
      check(page2.items.map((i) => i.id).toList()).deepEquals([4, 5, 100]);
      check(page2.hasMore).isFalse();
    },
  );

  r.addTest(
    '.fetchPage() cursor extracted from a page can be serialized and '
    'reconstructed to resume pagination independently of nextPageRequest',
    (db) async {
      await insertItems(db, 10);

      final page1 = await db.items.fetchPage(
        const ItemPageRequest(pageSize: 4),
      );
      final cursor = page1.nextCursor!;

      // Simulate persisting just the cursor's own field (e.g. in a URL) and
      // reconstructing it later using the cursor's own const constructor,
      // rather than keeping the original cursor or PageRequest object alive.
      final serialized = cursor.id;
      final reconstructed = ItemCursor(id: serialized);

      final resumed = await db.items.fetchPage(
        ItemPageRequest(pageSize: 4, cursor: reconstructed),
      );
      check(resumed.items.map((i) => i.id).toList()).deepEquals([5, 6, 7, 8]);
    },
  );

  r.addTest('.fetchPage() throws for non-positive pageSize', (db) async {
    await check(
      db.items.fetchPage(const ItemPageRequest(pageSize: 0)),
    ).throws<ArgumentError>();
    await check(
      db.items.fetchPage(const ItemPageRequest(pageSize: -1)),
    ).throws<ArgumentError>();
  });

  r.addTest('.fetchPage() with a descending direction', (db) async {
    await insertItems(db, 10);

    final page1 = await db.items.fetchPage(
      const ItemPageRequest(
        pageSize: 4,
        direction: ItemDirection(id: Order.descending),
      ),
    );
    check(page1.items.map((i) => i.id).toList()).deepEquals([10, 9, 8, 7]);
    check(page1.hasMore).isTrue();

    // `nextPageRequest` carries `pageSize` (4) forward too, so walk the rest.
    final seen = <int>[];
    var request = page1.nextPageRequest;
    while (request != null) {
      final page = await db.items.fetchPage(request);
      seen.addAll(page.items.map((i) => i.id));
      request = page.nextPageRequest;
    }
    check(seen).deepEquals([6, 5, 4, 3, 2, 1]);
  });

  r.run();
}
