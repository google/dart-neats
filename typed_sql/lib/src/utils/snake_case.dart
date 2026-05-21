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

/// Convert [camelCase] to `snake_case`.
String snakeCase(String camelCase) {
  // 1. Handle acronyms followed by a CamelCase word
  // (e.g., HTMLParser -> HTML_Parser)
  final exp1 = RegExp(r'([A-Z]+)([A-Z][a-z])');

  // 2. Handle normal camelCase boundaries (lower case or digit to upper case)
  // (e.g., userId -> user_Id, address1Line -> address1_Line)
  final exp2 = RegExp(r'([a-z\d])([A-Z])');

  return camelCase
      .replaceAllMapped(exp1, (Match m) => '${m[1]}_${m[2]}')
      .replaceAllMapped(exp2, (Match m) => '${m[1]}_${m[2]}')
      .toLowerCase();
}
