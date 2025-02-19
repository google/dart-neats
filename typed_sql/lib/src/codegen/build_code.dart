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
import 'package:collection/collection.dart';

import '../utils/camelcase.dart';
import 'parsed_library.dart';

Iterable<Spec> buildCode(ParsedLibrary library) sync* {
  yield* library.schemas.map(buildSchema).flattened;
  yield* library.models.map(buildModel).flattened;
}

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
              ..returns = refer('Table<${table.model.name}>')
              ..lambda = true
              ..body = Code('''
                ExposedForCodeGen.declareTable(
                  context: this,
                  tableName: '${table.name}',
                  columns: _\$${table.model.name}._\$fields,
                  deserialize: _\$${table.model.name}.new,
                )
              '''),
          ),
        ),
      ),
  );
}

/// Generate code for [Model] subclass, parsed into [model].
Iterable<Spec> buildModel(ParsedModel model) sync* {
  final modelName = model.name;
  final modelInstanceName = lowerCamelCase(modelName);

  // Create implementation class for model
  yield Class(
    (b) => b
      ..name = '_\$$modelName'
      ..modifier = ClassModifier.final$
      ..extend = refer(model.name)
      ..fields.add(Field(
        (b) => b
          ..name = r'_$get'
          ..modifier = FieldModifier.final$
          ..type = refer('Object? Function(int index)'),
      ))
      ..constructors.add(Constructor(
        (b) => b
          ..requiredParameters.add(
            Parameter(
              (b) => b
                ..name = r'_$get'
                ..toThis = true,
            ),
          ),
      ))
      ..fields.addAll(model.fields.mapIndexed((i, field) => Field(
            (b) => b
              ..name = field.name
              ..annotations.add(refer('override'))
              ..modifier = FieldModifier.final$
              ..late = true
              ..assignment = Code('_\$get($i) as ${field.type}'),
          )))
      ..fields.add(Field(
        (b) => b
          ..name = r'_$fields'
          ..static = true
          ..modifier = FieldModifier.constant
          ..assignment = literal(model.fields.map((f) => f.name).toList()).code,
      ))
      ..methods.add(Method(
        (b) => b
          ..name = 'toString'
          ..annotations.add(refer('override'))
          ..returns = refer('String')
          ..lambda = true
          ..body = Code(
            // TODO: Avoid "" around types that don't need it when rendered to
            //       string, like int, double, bool, etc.
            '\'$modelName(${model.fields.map((field) => '${field.name}: "\$${field.name}"').join(', ')})\'',
          ),
      )),
  );

  // Extension for Table<model>
  yield Extension(
    (b) => b
      ..name = 'Table${modelName}Ext'
      ..on = refer('Table<$modelName>')
      ..methods.add(Method(
        (b) => b
          ..name = 'create'
          ..docs.add('/// TODO: document create')
          ..optionalParameters.addAll(model.fields.asRequiredNamedParameters)
          ..returns = refer('Future<$modelName>')
          ..lambda = true
          ..body = Code('''
            ExposedForCodeGen.insertInto(
              table: this,
              values: [
                ${model.fields.map((field) => 'literal(${field.name})').join(', ')},
              ],
            )
          '''),
      ))
      ..methods.add(Method(
        (b) => b
          ..name = 'insert'
          ..docs.add('/// TODO: document insert')
          ..optionalParameters
              .addAll(model.fields.asRequiredNamedExprParameters)
          ..returns = refer('Future<$modelName>')
          ..lambda = true
          ..body = Code('''
            ExposedForCodeGen.insertInto(
              table: this,
              values: [
                ${model.fields.map((field) => field.name).join(', ')},
              ],
            )
          '''),
      ))
      ..methods.add(Method(
        (b) => b
          ..name = 'delete'
          ..docs.add('/// TODO: document delete')
          ..returns = refer('Future<void>')
          ..optionalParameters.addAll(
            model.primaryKey.asRequiredNamedParameters,
          )
          ..body = refer('byKey')
              .call([], {
                for (final field in model.primaryKey)
                  field.name: refer(field.name),
              })
              .property('delete')
              .call([])
              .code,
      )),
  );

  // Extension for Query<(Expr<model>,)>
  yield Extension(
    (b) => b
      ..name = 'Query${modelName}Ext'
      ..on = refer('Query<(Expr<$modelName>,)>')
      ..methods.add(Method(
        (b) => b
          ..name = 'byKey'
          ..docs.add('/// TODO: document lookup by PrimaryKey')
          ..returns = refer('QuerySingle<(Expr<$modelName>,)>')
          ..optionalParameters.addAll(
            model.primaryKey.asRequiredNamedParameters,
          )
          ..lambda = true
          ..body = Code(
            // TODO: Consider an auxiliary method on ExposedForCodeGen to make
            //       this much easier!
            'where(($modelInstanceName) => ${model.primaryKey.map(
                  (f) =>
                      '$modelInstanceName.${f.name}.equalsLiteral(${f.name})',
                ).reduce((a, b) => '$a.and($b)')}).first',
          ),
      ))
      ..methods.add(Method(
        (b) => b
          ..name = 'updateAll'
          ..docs.add('/// TODO: document updateAll()')
          ..returns = refer('Future<void>')
          ..requiredParameters.add(Parameter(
            (b) => b
              ..type = refer('''
                  Update<$modelName> Function(
                    Expr<$modelName> $modelInstanceName,
                    Update<$modelName> Function({
                      ${model.fields.map((field) => 'Expr<${field.type}> ${field.name}').join(', ')},
                    }) set,
                  )
                ''')
              ..name = 'updateBuilder',
          ))
          ..lambda = true
          ..body = Code('''
            ExposedForCodeGen.update<$modelName>(
              this,
              ($modelInstanceName) => updateBuilder($modelInstanceName, ({
                  ${model.fields.map((field) => 'Expr<${field.type}>? ${field.name}').join(', ')},
                }) =>
                  ExposedForCodeGen.buildUpdate<$modelName>([
                   ${model.fields.map((field) => field.name).join(', ')},
                  ]),
              ),
            )
          '''),
      ))
      ..methods.add(Method(
        (b) => b
          ..name = 'updateAllLiteral'
          ..docs.add('/// TODO: document updateAllLiteral()')
          ..docs.add('/// WARNING: This cannot set properties to `null`!')
          ..returns = refer('Future<void>')
          ..optionalParameters.addAll(model.fields.asOptionalNamedParameters)
          ..lambda = true
          ..body = Code('''
            ExposedForCodeGen.update<$modelName>(
              this,
              ($modelInstanceName) => ExposedForCodeGen.buildUpdate<$modelName>([
                ${model.fields.map((field) => '${field.name} != null ? literal(${field.name}) : null').join(', ')},
              ]),
            )
          '''),
      ))
      ..methods.addAll(model.fields.where((field) => field.unique).map(
            (field) => Method(
              (b) => b
                ..name = 'by${upperCamelCase(field.name)}'
                ..docs.add('/// TODO: document byXXX()}')
                ..returns = refer('QuerySingle<(Expr<$modelName>,)>')
                ..requiredParameters.add(Parameter(
                  (b) => b
                    ..name = field.name
                    ..type = refer(field.type),
                ))
                ..lambda = true
                ..body = Code('''
                  where(($modelInstanceName) =>
                    $modelInstanceName.${field.name}.equalsLiteral(${field.name})
                  ).first
                '''),
            ),
          )),
    // TODO: Add utility methods for easy lookup by field for each unique field!
  );

  // Extension for QuerySingle<(Expr<model>,)>
  yield Extension((b) => b
    ..name = 'QuerySingle${modelName}Ext'
    ..on = refer('QuerySingle<(Expr<$modelName>,)>')
    ..methods.add(Method(
      (b) => b
        ..name = 'update'
        ..docs.add('/// TODO: document update()')
        ..returns = refer('Future<void>')
        ..requiredParameters.add(Parameter(
          (b) => b
            ..type = refer('''
                Update<$modelName> Function(
                  Expr<$modelName> $modelInstanceName,
                  Update<$modelName> Function({
                    ${model.fields.map((field) => 'Expr<${field.type}> ${field.name}').join(', ')},
                  }) set,
                )
              ''')
            ..name = 'updateBuilder',
        ))
        ..lambda = true
        ..body = Code('''
            ExposedForCodeGen.update<$modelName>(
              asQuery,
              ($modelInstanceName) => updateBuilder($modelInstanceName, ({
                  ${model.fields.map((field) => 'Expr<${field.type}>? ${field.name}').join(', ')},
                }) =>
                  ExposedForCodeGen.buildUpdate<$modelName>([
                   ${model.fields.map((field) => field.name).join(', ')},
                  ]),
              ),
            )
          '''),
    ))
    ..methods.add(Method(
      (b) => b
        ..name = 'updateLiteral'
        ..docs.add('/// TODO: document updateLiteral()')
        ..docs.add('/// WARNING: This cannot set properties to `null`!')
        ..returns = refer('Future<void>')
        ..optionalParameters.addAll(model.fields.asOptionalNamedParameters)
        ..lambda = true
        ..body = Code('''
            ExposedForCodeGen.update<$modelName>(
              asQuery,
              ($modelInstanceName) => ExposedForCodeGen.buildUpdate<$modelName>([
                ${model.fields.map((field) => '${field.name} != null ? literal(${field.name}) : null').join(', ')},
              ]),
            )
          '''),
    )));

  // Extension for Expression<model>
  yield Extension(
    (b) => b
      ..name = 'Expression${modelName}Ext'
      ..on = refer('Expr<$modelName>')
      ..methods.addAll(model.fields.mapIndexed((i, field) => Method(
            (b) => b
              ..name = field.name
              ..docs.add('/// TODO: document ${field.name}')
              ..type = MethodType.getter
              ..returns = refer('Expr<${field.type}>')
              ..lambda = true
              ..body = Code('ExposedForCodeGen.field(this, $i)'),
          ))),
  );
}

extension on List<ParsedField> {
  Iterable<Parameter> get asRequiredNamedParameters => map((field) => Parameter(
        (b) => b
          ..name = field.name
          ..named = true
          ..required = true
          ..type = refer(field.type),
      ));

  Iterable<Parameter> get asRequiredNamedExprParameters =>
      map((field) => Parameter(
            (b) => b
              ..name = field.name
              ..named = true
              ..required = true
              ..type = refer('Expr<${field.type}>'),
          ));

  Iterable<Parameter> get asOptionalNamedParameters => map((field) => Parameter(
        (b) => b
          ..name = field.name
          ..type = TypeReference(
            (b) => b
              ..symbol = field.type
              ..isNullable = true,
          )
          ..named = true,
      ));
}
