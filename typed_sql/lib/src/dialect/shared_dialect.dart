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

enum ReferentialEvent { delete, update }

/// Returns the default SQL clause expression for the given [event] [action].
///
/// SQL dialects may not support all values or may use different expression.
/// Override it in the database-specific dialect.
String defaultReferentialActionClause(
  ReferentialEvent event,
  ReferentialAction action,
) {
  final eventClause = () {
    switch (event) {
      case ReferentialEvent.delete:
        return 'ON DELETE';
      case ReferentialEvent.update:
        return 'ON UPDATE';
    }
  }();
  final actionClause = () {
    switch (action) {
      case ReferentialAction.cascade:
        return 'CASCADE';
      case ReferentialAction.noAction:
        return 'NO ACTION';
      case ReferentialAction.restrict:
        return 'RESTRICT';
      case ReferentialAction.setDefault:
        return 'SET DEFAULT';
      case ReferentialAction.setNull:
        return 'SET NULL';
    }
  }();
  return '$eventClause $actionClause';
}
