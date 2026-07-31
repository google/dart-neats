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

/// PostgreSQL-only extensions for `package:typed_sql`.
///
/// Import this library _alongside_ `package:typed_sql/typed_sql.dart` to
/// get access to expressions that only work with PostgreSQL, such as JSONB
/// containment (`@>`, `<@`) and key-existence (`?`, `?|`, `?&`) operators.
///
/// > [!WARNING]
/// > Queries using these operators will throw `UnsupportedError` if executed
/// > against SQLite or MySQL/MariaDB. Only import this library in code that
/// > specifically targets PostgreSQL.
library;

export 'src/typed_sql.dart' show PostgresJsonConditions;
