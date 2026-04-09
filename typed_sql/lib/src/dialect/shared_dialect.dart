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
}) {
  String formatEventAction(String event, ReferentialAction action) {
    switch (action) {
      case ReferentialAction.cascade:
        return '$event CASCADE';
      case ReferentialAction.noAction:
        return '$event NO ACTION';
      case ReferentialAction.restrict:
        return '$event RESTRICT';
      case ReferentialAction.setDefault:
        return '$event SET DEFAULT';
      case ReferentialAction.setNull:
        return '$event SET NULL';
    }
  }

  return [
    formatEventAction('ON DELETE', onDelete),
    formatEventAction('ON UPDATE', onUpdate),
  ].join(' ');
}
