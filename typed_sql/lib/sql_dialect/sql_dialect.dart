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

import 'package:typed_sql/sql_dialect/sqlite.dart';
import 'package:typed_sql/typed_sql.dart';

abstract base class SqlDialect {
  static SqlDialect sqlite() => sqliteDialect();

  /// Insert [columns] into [table] returning columns mentioned in [returning].
  ///
  /// ```sql
  /// INSERT INTO [table] ([columns]) VALUES ($1, ...) RETURNING [returning]
  /// ```
  (String, List<Object?>) insertInto(
    String table,
    List<String> columns,
    List<Object?> values,
    List<String> returning,
  );

  /// Select [columns] from [table] aliased as [alias].
  ///
  /// This returns rows satisfying the [where] expression.
  /// Results start from [offset].
  /// At most [limit] rows are returned, use -1 for no limit.
  ///
  /// Rows are ordered by [orderBy], if given.
  (String, List<Object?>) selectFrom(
    String table,
    String alias,
    List<String> columns,
    int limit, // -1, if there is no limit
    int offset,
    Expression<bool> where,
    ({bool descending, Expression term})? orderBy, // default to null
  );

  /// Update [columns] from [table] aliased as [alias] with [values].
  ///
  /// This updates rows satisfying the [where] expression.
  /// Only updates rows starting from [offset].
  /// At most [limit] rows are updated, use -1 for no limit.
  ///
  /// Rows are ordered by [orderBy], if given.
  (String, List<Object?>) update(
    String table,
    String alias,
    List<String> columns,
    List<Expression> values,
    int limit, // -1, if there is no limit
    int offset,
    Expression<bool> where,
    ({bool descending, Expression term})? orderBy, // default to null
  );

  /// Delete from [table] aliased as [alias].
  ///
  /// Delete rows satisfying the [where] expression.
  /// Delete results starting from [offset].
  /// Delete at-most [limit] (-1 for no limit).
  /// Rows ordered by [orderBy], if given.
  ///
  /// This SQL statement should not return any rows,
  /// all return values are read but ignored.
  (String, List<Object?>) deleteFrom(
    String table,
    String alias,
    int limit, // -1, if there is no limit
    int offset,
    Expression<bool> where,
    ({bool descending, Expression term})? orderBy, // default to null
  );
}

// NOTE: All Expression subclasses are sealed, so we can do exhaustive switching
//       over them.
