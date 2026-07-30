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

part 'brin_index_test.g.dart';

abstract final class EventLog extends Schema {
  Table<Event> get events;
}

@PrimaryKey(['id'])
abstract final class Event extends Row {
  @AutoIncrement()
  int get id;

  @Index.field(method: .brin)
  DateTime get createdAt;
}

void main() {
  final r = TestRunner<EventLog>(
    setup: (db) async {
      await db.createTables();
    },
  );

  r.addTest('createTables() succeeds with a BRIN index', (db) async {
    final now = DateTime.utc(2026, 7, 27);
    await db.events.insertValue(createdAt: now).execute();

    final item = await db.events.first.fetch();
    check(item).isNotNull().createdAt.equals(now);
  });

  r.run();
}
