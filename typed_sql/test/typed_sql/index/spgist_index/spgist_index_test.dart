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

part 'spgist_index_test.g.dart';

abstract final class DirectoryDatabase extends Schema {
  Table<Entry> get entries;
}

@PrimaryKey(['id'])
abstract final class Entry extends Row {
  @AutoIncrement()
  int get id;

  @Index.field(method: .spgist)
  @SqlOverride.field(dialect: 'mysql', columnType: 'VARCHAR(255)')
  String get name;
}

void main() {
  final r = TestRunner<DirectoryDatabase>(
    setup: (db) async {
      await db.createTables();
    },
  );

  r.addTest('createTables() succeeds with an SP-GiST index', (db) async {
    await db.entries.insertValue(name: 'jane').execute();

    final item = await db.entries.first.fetch();
    check(item).isNotNull().name.equals('jane');
  });

  r.run();
}
