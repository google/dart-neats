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

import '../testrunner.dart';

part 'paged_by_order_class_test.g.dart';

abstract final class TestDatabase extends Schema {
  Table<Order> get orders;
  Table<Stream> get streams;
}

/// A row class named `Order` shadows the [Order] enum from typed_sql, in this
/// library and the generated code.
@PrimaryKey(['orderId'])
abstract final class Order extends Row {
  int get orderId;

  int get quantity;
}

/// A row class named `Stream` shadows [Stream] from `dart:async`.
@PrimaryKey(['streamId'])
abstract final class Stream extends Row {
  int get streamId;

  int get viewers;
}

void main() {
  final r = TestRunner<TestDatabase>(
    setup: (db) async {
      await db.createTables();
      for (final orderId in [2, 1, 3]) {
        await db.orders
            .insert(orderId: toExpr(orderId), quantity: toExpr(1))
            .execute();
        await db.streams
            .insert(streamId: toExpr(orderId), viewers: toExpr(1))
            .execute();
      }
    },
  );

  r.addTest('orders.pagedByKey()', (db) async {
    final result = await db.orders
        .pagedByKey(order: .descending, pageSize: 2)
        .map((o) => o.orderId)
        .toList();
    check(result).deepEquals([3, 2, 1]);
  });

  r.addTest('streams.pagedByKey()', (db) async {
    final result = await db.streams
        .pagedByKey(pageSize: 2)
        .map((s) => s.streamId)
        .toList();
    check(result).deepEquals([1, 2, 3]);
  });

  r.run();
}
