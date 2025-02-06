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

/// @docImport 'package:typed_sql/typed_sql.dart';
library;

import 'package:code_builder/code_builder.dart';
import 'package:typed_sql/src/codegen/parsed_schema.dart';
import 'package:typed_sql/typed_sql.dart';

/// Generate code for [Schema] subclass, parsed into [schema].
Iterable<Spec> buildSchema(ParsedSchema schema) sync* {
  // Create the extension for the `Schema` subclass, example:
  // extension PrimaryDatabaseSchema on DatabaseContext<PrimaryDatabase> {...}
  yield Extension(
    (b) => b
      ..name = '${schema.name}Schema'
      ..on = TypeReference(
        (b) => b
          ..symbol = 'DatabaseContext'
          ..types.add(refer(schema.name)),
      )
      ..methods.addAll(
        schema.tables.map(
          (table) => Method(
            (b) => b
              ..name = table.name
              ..docs.add('/// TODO: Propagate documentation for tables!')
              ..type = MethodType.getter
              ..returns = TypeReference(
                (b) => b
                  ..symbol = 'Table'
                  ..types.add(refer(table.model.name)),
              )
              ..lambda = true
              ..body =
                  refer('ExposedForCodeGen').property('declareTable').call([], {
                'context': refer('this'),
                'tableName': literal(table.name),
                'columns':
                    refer('_\$${table.model.name}').property(r'_$fields'),
                'deserialize':
                    refer('_\$${table.model.name}').property(r'_$deserialize'),
              }).code,
          ),
        ),
      ),
  );
}
