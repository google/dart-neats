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

/// Returns an unescaped name for a FOREIGN KEY constraint.
///
/// The generated name has the following pattern:
/// `<table_name>_fk_<name_or_columns>`
String foreignKeyConstraintName(
  CreateTableStatement table,
  ForeignKeyDefinition key,
) {
  return [
    table.tableName,
    'fk',
    if (key.name.isEmpty) ...key.columns else key.name,
  ].join('_');
}

/// Where the `USING ...` index-type clause goes in `CREATE INDEX`; differs
/// by dialect.
enum IndexTypeClausePosition {
  /// `... ON table USING method (columns)` (PostgreSQL).
  afterOn,

  /// `... USING method ON table (columns)` (MySQL/MariaDB).
  beforeOn,
}

/// Returns the `CREATE INDEX` statements for the indexes defined on [table].
///
/// [supportedMethods] are the [IndexAccessMethod]s supported beyond
/// [IndexAccessMethod.btree]; unsupported methods fall back to a plain index.
/// [supportsCoveringColumns] controls whether `INCLUDE` columns are emitted.
Iterable<String> createIndexStatements(
  CreateTableStatement table,
  String Function(String) escape, {
  Set<IndexAccessMethod> supportedMethods = const {},
  IndexTypeClausePosition typeClausePosition = .afterOn,
  bool supportsCoveringColumns = false,
}) {
  return table.indexes.map((index) {
    final indexName = [
      table.tableName,
      'idx',
      if (index.sqlName == null) ...index.columns else index.sqlName,
    ].join('_');

    final usingClause = switch (index.method) {
      .brin when supportedMethods.contains(IndexAccessMethod.brin) =>
        'USING BRIN',
      .btree => null,
      .gin when supportedMethods.contains(IndexAccessMethod.gin) => 'USING GIN',
      .gist when supportedMethods.contains(IndexAccessMethod.gist) =>
        'USING GIST',
      .hash when supportedMethods.contains(IndexAccessMethod.hash) =>
        'USING HASH',
      .spgist when supportedMethods.contains(IndexAccessMethod.spgist) =>
        'USING SPGIST',
      _ => null,
    };
    final beforeOnClause = typeClausePosition == .beforeOn ? usingClause : null;
    final afterOnClause = typeClausePosition == .afterOn ? usingClause : null;
    final covering = supportsCoveringColumns
        ? index.covering
        : const <String>[];

    return <String>[
      'CREATE INDEX ${escape(indexName)}',
      ?beforeOnClause,
      'ON ${escape(table.tableName)}',
      ?afterOnClause,
      '(${index.columns.map(escape).join(', ')})',
      if (covering.isNotEmpty) 'INCLUDE (${covering.map(escape).join(', ')})',
    ].join(' ');
  });
}
