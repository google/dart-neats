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

/// @docImport 'package:typed_sql/typed_sql.dart';
library;

/// Serialized SQL statement(s) that can be executed by a [DatabaseAdapter].
sealed class SqlTask {
  const SqlTask();
}

/// A single SQL statement [sql] with [params].
final class SingleSqlTask extends SqlTask {
  final String sql;
  final List<Object?> params;

  const SingleSqlTask(this.sql, this.params);
}

/// An SQL statement [sql] to be executed once for each element in [paramsList].
final class PipelinedSqlTask extends SqlTask {
  final String sql;
  final Iterable<List<Object?>> paramsList;

  const PipelinedSqlTask(this.sql, this.paramsList);
}

/// An SQL script consisting of multiple [statements].
final class ScriptSqlTask extends SqlTask {
  final List<String> statements;

  /// [statements] separated by `;\n`.
  String get script => [...statements, ''].join(';\n');

  const ScriptSqlTask(this.statements);
}
