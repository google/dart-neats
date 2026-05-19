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

/// @docImport '../typed_sql.dart';
library;

import 'parsed_default_value.dart' show ParsedDefaultValue;

final class ParsedLibrary {
  final List<ParsedSchema> schemas;
  final List<ParsedRowClass> rowClasses;

  ParsedLibrary({
    required this.schemas,
    required this.rowClasses,
  });

  bool get isEmpty => schemas.isEmpty && rowClasses.isEmpty;

  @override
  String toString() =>
      'ParsedLibrary(${[
        'schemas: [${schemas.join(', ')}]',
        'rowClasses: [${rowClasses.join(', ')}]',
      ].join(', ')})';
}

final class ParsedSchema {
  final String name;
  final List<ParsedTable> tables;
  final List<ParsedSqlOverride> overrides;

  ParsedSchema({
    required this.name,
    required this.tables,
    required this.overrides,
  });

  @override
  String toString() =>
      'ParsedSchema(${[
        'name: "$name"',
        'tables: [${tables.join(', ')}]',
        'overrides: ${overrides.join(', ')}',
      ].join(', ')})';
}

final class ParsedTable {
  final String name;
  final String? documentation;
  final ParsedRowClass rowClass;
  final List<ParsedSqlOverride> overrides;

  ParsedTable({
    required this.name,
    required this.documentation,
    required this.rowClass,
    required this.overrides,
  });

  /// Reference to the [ParsedSchema] where this table is defined.
  ///
  /// This field is not available during parsing, only after an entire library
  /// has been parsed.
  late final ParsedSchema schema;

  @override
  String toString() =>
      'ParsedTable(${[
        'name: "$name"',
        'rowClass: $rowClass',
        'overrides: ${overrides.join(', ')}',
      ].join(', ')})';
}

final class ParsedRowClass {
  final String name;
  final List<ParsedField> primaryKey;
  final List<ParsedField> fields;
  final List<ParsedForeignKey> foreignKeys;
  final List<ParsedUniqueConstraint> uniqueConstraints;
  final List<ParsedSqlOverride> overrides;

  ParsedRowClass({
    required this.name,
    required this.primaryKey,
    required this.fields,
    required this.foreignKeys,
    required this.uniqueConstraints,
    required this.overrides,
  });

  /// Reference to the [ParsedTable] for which this _row class_ is used.
  ///
  /// This field is not available during parsing, only after an entire library
  /// has been parsed.
  late final ParsedTable table;

  @override
  String toString() =>
      'ParsedRowClass(${[
        'name: "$name"',
        'primaryKey: [${primaryKey.map((f) => '"${f.name}"').join(', ')}]',
        'fields: [${fields.map((f) => '"${f.name}"').join(', ')}]',
        'overrides: ${overrides.join(', ')}',
        // TODO: Add foreign keys and unique
      ].join(', ')})';
}

final class ParsedUniqueConstraint {
  final String? name;
  final List<ParsedField> fields;

  ParsedUniqueConstraint({
    required this.name,
    required this.fields,
  });
}

final class ParsedForeignKey {
  final List<ParsedField> foreignKey;
  final String table;
  final List<String> fields;
  final String? as;
  final String? name;
  final ParsedReferentialAction onDelete;
  final ParsedReferentialAction onUpdate;

  ParsedForeignKey({
    required this.foreignKey,
    required this.table,
    required this.fields,
    required this.as,
    required this.name,
    required this.onDelete,
    required this.onUpdate,
  });

  /// Reference to the [ParsedField]s referenced in [fields].
  ///
  /// This field is not available during parsing, only after an entire library
  /// has been parsed.
  late final List<ParsedField> referencedFields;

  /// Reference to the [ParsedTable] referenced in [table].
  ///
  /// This field is not available during parsing, only after an entire library
  /// has been parsed.
  late final ParsedTable referencedTable;

  @override
  String toString() =>
      'ParsedForeignKey(${[
        'foreignKey: [${foreignKey.map((k) => k.name).join(', ')}]',
        'table: "$table"',
        'fields: [${fields.map((f) => '"$f"').join(', ')}]',
        'as: ${as != null ? '"$as"' : 'null'}',
        'name: ${name != null ? '"$name"' : 'null'}',
      ].join(', ')})';
}

/// Parsed representation of [ReferentialAction].
///
/// This should always stay in sync with the [ReferentialAction] enum.
enum ParsedReferentialAction {
  cascade,
  restrict,
  setNull,
  setDefault,
  noAction,
}

final class ParsedField {
  final String name;
  final String? documentation;
  final String typeName;
  final bool isNullable;
  final String backingType;
  final ParsedDefaultValue? defaultValue;
  final bool autoIncrement;
  final List<ParsedSqlOverride> overrides;

  ParsedField({
    required this.name,
    required this.documentation,
    required this.typeName,
    required this.isNullable,
    required this.backingType,
    required this.defaultValue,
    required this.autoIncrement,
    required this.overrides,
  });

  /// Reference to the [ParsedRowClass] that this field is defined within.
  ///
  /// This field is not available during parsing, only after an entire library
  /// has been parsed.
  late final ParsedRowClass rowClass;

  @override
  String toString() =>
      'ParsedField(${[
        'name: "$name"',
        'typeName: "$typeName"',
        'isNullable: $isNullable',
        'backingType: "$backingType"',
        'defaultValue: ${defaultValue != null ? '"$defaultValue"' : 'null'}',
        'autoIncrement: $autoIncrement',
        'overrides: ${overrides.join(', ')}',
      ].join(', ')})';
}

final class ParsedRecord {
  final List<String> fields;

  ParsedRecord({
    required this.fields,
  });

  @override
  String toString() =>
      'ParsedRecord(${[
        'fields: [${fields.map((f) => '"$f"').join(', ')}]',
      ].join(', ')})';
}

/// Parsed representation of [Nameing].
///
/// This should always stay in sync with the [Nameing] enum.
enum ParsedNaming {
  camelCase,
  // ignore: constant_identifier_names
  snake_case,
}

final class ParsedSqlOverride {
  final String? dialect;
  final String? columnType;
  final String? defaultValue;
  final String? collation;
  final String? name;
  final ParsedNaming? naming;

  ParsedSqlOverride({
    this.dialect,
    this.columnType,
    this.defaultValue,
    this.collation,
    this.name,
    this.naming,
  });

  @override
  String toString() =>
      'ParsedSqlOverride(${[
        'dialect: ${dialect != null ? '"$dialect"' : 'null'}',
        'columnType: ${columnType != null ? '"$columnType"' : 'null'}',
        'defaultValue: ${defaultValue != null ? '"$defaultValue"' : 'null'}',
        'collation: ${collation != null ? '"$collation"' : 'null'}',
        'name: ${name != null ? '"$name"' : 'null'}',
        'naming: ${naming != null ? '"${naming!.name}"' : 'null'}',
      ].join(', ')})';
}
