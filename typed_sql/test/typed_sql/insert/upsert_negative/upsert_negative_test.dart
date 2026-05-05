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

part 'upsert_negative_test.g.dart';

abstract final class NegativeDatabase extends Schema {
  Table<NotNullItem> get notNullItems;
}

@PrimaryKey(['id'])
abstract final class NotNullItem extends Row {
  @AutoIncrement()
  int get id;

  String get name;
}

void main() {
  final r = TestRunner<NegativeDatabase>(
    setup: (db) async {
      await db.createTables();
    },
  );

  r.addTest(
    'NOT NULL violation should fail despite onConflict',
    (db) async {
      try {
        await db.notNullItems
            .insert(
              id: toExpr(1),
              name: (toExpr(null) as Expr<String?>)
                  .asNotNull(), // Force null into non-nullable field
            )
            .onConflict(NotNullItemConflict.primaryKey)
            .doNothing()
            .execute();
        fail('Expected OperationException due to NOT NULL violation');
      } on OperationException {
        // Expected
      }
    },
    skipMysql: 'mysql does not support ON CONFLICT clauses',
  );

  r.run();
}
