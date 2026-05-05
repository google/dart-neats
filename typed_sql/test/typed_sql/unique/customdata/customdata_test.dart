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

part 'customdata_test.g.dart';

abstract final class CustomDataDatabase extends Schema {
  Table<CustomDataItem> get customDataItems;
}

final class CustomIntType implements CustomDataType<int> {
  final int value;
  CustomIntType(this.value);
  factory CustomIntType.fromDatabase(int value) => CustomIntType(value);
  @override
  int toDatabase() => value;
}

final class CustomStringType implements CustomDataType<String> {
  final String value;
  CustomStringType(this.value);
  factory CustomStringType.fromDatabase(String value) =>
      CustomStringType(value);
  @override
  String toDatabase() => value;
}

@PrimaryKey(['id'])
abstract final class CustomDataItem extends Row {
  CustomIntType get id; // Custom type as PK

  @Unique.field()
  @SqlOverride(dialect: 'mysql', columnType: 'VARCHAR(255)')
  CustomStringType get stringVal;
}

void main() {
  final r = TestRunner<CustomDataDatabase>(
    setup: (db) async {
      await db.createTables();
    },
  );

  r.addTest('.byKey() with custom type', (db) async {
    await db.customDataItems
        .insertValue(
          id: CustomIntType(1),
          stringVal: CustomStringType('A'),
        )
        .execute();

    final item = await db.customDataItems.byKey(CustomIntType(1)).fetch();
    check(item).isNotNull().id.has((e) => e.value, 'value').equals(1);
  });

  r.addTest('.byStringVal() with custom type', (db) async {
    await db.customDataItems
        .insertValue(
          id: CustomIntType(1),
          stringVal: CustomStringType('A'),
        )
        .execute();

    final item = await db.customDataItems
        .byStringVal(CustomStringType('A'))
        .fetch();
    check(item).isNotNull().stringVal.has((e) => e.value, 'value').equals('A');
  });

  r.run();
}
