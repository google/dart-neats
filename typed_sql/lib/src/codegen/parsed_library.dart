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

import '../typed_sql.dart' show SqlOverride;
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
  String toString() => 'ParsedLibrary(${[
        'schemas: [${schemas.join(', ')}]',
        'rowClasses: [${rowClasses.join(', ')}]',
      ].join(', ')})';
}

final class ParsedSchema {
  final String name;
  final List<ParsedTable> tables;

  ParsedSchema({
    required this.name,
    required this.tables,
  });

  @override
  String toString() => 'ParsedSchema(${[
        'name: "$name"',
        'tables: [${tables.join(', ')}]',
      ].join(', ')})';
}

final class ParsedTable {
  final String name;
  final String? documentation;
  final ParsedRowClass rowClass;

  ParsedTable({
    required this.name,
    required this.documentation,
    required this.rowClass,
  });

  @override
  String toString() => 'ParsedTable(${[
        'name: "$name"',
        'rowClass: $rowClass',
      ].join(', ')})';
}

final class ParsedRowClass {
  final String name;
  final List<ParsedField> primaryKey;
  final List<ParsedField> fields;
  final List<ParsedForeignKey> foreignKeys;
  final List<ParsedUniqueConstraint> uniqueConstraints;

  ParsedRowClass({
    required this.name,
    required this.primaryKey,
    required this.fields,
    required this.foreignKeys,
    required this.uniqueConstraints,
  });

  @override
  String toString() => 'ParsedRowClass(${[
        'name: "$name"',
        'primaryKey: [${primaryKey.map((f) => '"${f.name}"').join(', ')}]',
        'fields: [${fields.map((f) => '"${f.name}"').join(', ')}]',
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

  ParsedForeignKey({
    required this.foreignKey,
    required this.table,
    required this.fields,
    required this.as,
    required this.name,
  });

  late final List<ParsedField> referencedFields;
  late final ParsedTable referencedTable;

  @override
  String toString() => 'ParsedForeignKey(${[
        'foreignKey: [${foreignKey.map((k) => k.name).join(', ')}]',
        'table: "$table"',
        'fields: [${fields.map((f) => '"$f"').join(', ')}]',
        'as: ${as != null ? '"$as"' : 'null'}',
        'name: ${name != null ? '"$name"' : 'null'}',
      ].join(', ')})';
}

final class ParsedField {
  final String name;
  final String? documentation;
  final String typeName;
  final bool isNullable;
  final String backingType;
  final ParsedDefaultValue? defaultValue;
  final bool autoIncrement;
  final List<SqlOverride> sqlOverrides;

  ParsedField({
    required this.name,
    required this.documentation,
    required this.typeName,
    required this.isNullable,
    required this.backingType,
    required this.defaultValue,
    required this.autoIncrement,
    required this.sqlOverrides,
  });

  @override
  String toString() => 'ParsedField(${[
        'name: "$name"',
        'typeName: "$typeName"',
        'isNullable: $isNullable',
        'backingType: "$backingType"',
        'defaultValue: ${defaultValue != null ? '"$defaultValue"' : 'null'}',
        'autoIncrement: $autoIncrement',
      ].join(', ')})';
}

final class ParsedRecord {
  final List<String> fields;

  ParsedRecord({
    required this.fields,
  });

  @override
  String toString() => 'ParsedRecord(${[
        'fields: [${fields.map((f) => '"$f"').join(', ')}]',
      ].join(', ')})';
}
