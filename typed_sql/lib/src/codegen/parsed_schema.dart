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

final class ParsedSchema {
  final String name;
  final List<ParsedTable> tables;

  ParsedSchema({
    required this.name,
    required this.tables,
  });
}

final class ParsedTable {
  final String name;
  final ParsedModel model;

  ParsedTable({
    required this.name,
    required this.model,
  });
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
}

final class ParsedField {
  final String name;
  final String type;
  final bool unique;

  ParsedField({
    required this.name,
    required this.type,
    required this.unique,
  });
}
