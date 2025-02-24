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

final class ParsedLibrary {
  final List<ParsedSchema> schemas;
  final List<ParsedModel> models;

  ParsedLibrary({
    required this.schemas,
    required this.models,
  });

  bool get isEmpty => schemas.isEmpty && models.isEmpty;

  @override
  String toString() => 'ParsedLibrary(${[
        'schemas: [${schemas.join(', ')}]',
        'models: [${models.join(', ')}]',
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
  final ParsedModel model;

  ParsedTable({
    required this.name,
    required this.model,
  });

  @override
  String toString() => 'ParsedTable(${[
        'name: "$name"',
        'model: $model',
      ].join(', ')})';
}

final class ParsedModel {
  final String name;
  final List<ParsedField> primaryKey;
  final List<ParsedField> fields;

  ParsedModel({
    required this.name,
    required this.primaryKey,
    required this.fields,
  });

  @override
  String toString() => 'ParsedModel(${[
        'name: "$name"',
        'primaryKey: [${primaryKey.map((f) => '"${f.name}"').join(', ')}]',
        'fields: [${fields.map((f) => '"${f.name}"').join(', ')}]',
      ].join(', ')})';
}

final class ParsedField {
  final String name;
  final String typeName;
  final bool isNullable;
  final bool unique;

  ParsedField({
    required this.name,
    required this.typeName,
    required this.isNullable,
    required this.unique,
  });

  @override
  String toString() => 'ParsedField(${[
        'name: "$name"',
        'typeName: "$typeName"',
        'isNullable: $isNullable',
        'unique: $unique',
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
