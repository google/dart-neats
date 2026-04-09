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

import '../typed_sql.dart';

/// Returns the default SQL clause expression for the given referential actions.
///
/// SQL dialects may not support all values or may use different expression.
/// Override it in the database-specific dialect.
String defaultReferentialActionClause({
  required ReferentialAction onDelete,
  required ReferentialAction onUpdate,
}) => 'ON DELETE ${onDelete.sql} ON UPDATE ${onUpdate.sql}';

extension ReferentialActionSql on ReferentialAction {
  String get sql => switch (this) {
    .cascade => 'CASCADE',
    .noAction => 'NO ACTION',
    .restrict => 'RESTRICT',
    .setDefault => 'SET DEFAULT',
    .setNull => 'SET NULL',
  };
}
