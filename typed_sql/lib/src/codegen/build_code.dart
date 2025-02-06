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
import 'package:typed_sql/src/codegen/parsed_library.dart';
import 'package:typed_sql/src/utils/camelcase.dart';

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
      ..fields.addAll(model.fields.map((field) => Field(
            (b) => b
              ..name = '_\$${field.name}'
              ..type = TypeReference(
                (b) => b
                  ..symbol = field.type
                  ..isNullable = true,
              )
              ..modifier = FieldModifier.final$,
          )))
      ..fields.add(Field(
        (b) => b
          ..name = r'_$fields'
          ..static = true
          ..modifier = FieldModifier.constant
          ..assignment = literal(model.fields.map((f) => f.name).toList()).code,
      ))
      ..constructors.add(Constructor(
        (b) => b
          ..requiredParameters.addAll(
            model.fields.map((field) => Parameter(
                  (b) => b
                    ..name = '_\$${field.name}'
                    ..toThis = true,
                )),
          ),
      ))
      ..methods.add(Method(
        (b) => b
          ..name = r'_$deserialize'
          ..static = true
          ..requiredParameters.add(
            Parameter(
              (b) => b
                ..name = 'fields'
                ..type = refer('List<Object?>'),
            ),
          )
          ..returns = refer(model.name)
          ..body = refer('_\$$modelName')
              .call(model.fields.mapIndexed((i, field) =>
                  refer('fields').index(literal(i)).asA(TypeReference(
                        (b) => b
                          ..symbol = field.type
                          ..isNullable = true,
                      ))))
              .code,
      ))
      ..methods.addAll(model.fields.map((field) => Method(
            (b) => b
              ..name = field.name
              ..annotations.add(refer('override'))
              ..type = MethodType.getter
              ..returns = refer(field.type)
              ..body = Code('''
                final value = _\$${field.name};
                if (value == null) {
                  throw StateError('Query did not fetch "${field.name}"');
                }
                return value;
              '''),
          )))
      ..methods.add(Method(
        (b) => b
          ..name = 'toString'
          ..annotations.add(refer('override'))
          ..returns = refer('String')
          ..lambda = true
          ..body = Code(
            // TODO: Avoid "" around types that don't need it when rendered to
            //       string, like int, double, bool, etc.
            '\'$modelName(${model.fields.map((field) => '${field.name}: "\${_\$${field.name}}"').join(', ')})\'',
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
          ..body = refer('ExposedForCodeGen').property('insertInto').call([], {
            'table': refer('this'),
            'values':
                literalList(model.fields.map((field) => refer(field.name))),
          }).code,
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

  // Extension for Query<model>
  yield Extension(
    (b) => b
      ..name = 'Query${modelName}Ext'
      ..on = refer('Query<$modelName>')
      ..methods.add(Method(
        (b) => b
          ..name = 'byKey'
          ..docs.add('/// TODO: document lookup by PrimaryKey')
          ..returns = refer('QuerySingle<$modelName>')
          ..optionalParameters.addAll(
            model.primaryKey.asRequiredNamedParameters,
          )
          ..lambda = true
          ..body = Code(
            // TODO: Consider an auxiliary method on ExposedForCodeGen to make
            //       this much easier!
            'where(($modelInstanceName) => ${model.primaryKey.map(
                  (f) =>
                      '$modelInstanceName.${f.name}.equals.literal(${f.name})',
                ).reduce((a, b) => '$a.and($b)')}).first',
          ),
      ))
      ..methods.add(Method(
        (b) => b
          ..name = 'where'
          ..docs.add('/// TODO: document where()')
          ..returns = refer('Query<$modelName>')
          ..requiredParameters.add(Parameter(
            (b) => b
              ..name = 'conditionBuilder'
              ..type = refer(
                  'Expr<bool> Function(Expr<$modelName> $modelInstanceName)'),
          ))
          ..lambda = true
          ..body = Code('''
            ExposedForCodeGen.where(this, conditionBuilder)
          '''),
      ))
      ..methods.add(Method(
        (b) => b
          ..name = 'orderBy'
          ..docs.add('/// TODO: document orderBy()')
          ..returns = refer('Query<$modelName>')
          ..requiredParameters.add(Parameter(
            (b) => b
              ..name = 'fieldBuilder'
              ..type =
                  refer('Expr Function(Expr<$modelName> $modelInstanceName)'),
          ))
          ..optionalParameters.add(Parameter(
            (b) => b
              ..name = 'descending'
              ..type = refer('bool')
              ..named = true
              ..defaultTo = literal(false).code,
          ))
          ..lambda = true
          ..body = Code('''
            ExposedForCodeGen.orderBy(this, fieldBuilder, descending: descending)
          '''),
      ))
      ..methods.add(Method(
        (b) => b
          ..name = 'select'
          ..docs.add('/// TODO: document select()')
          ..returns = refer('Query<$modelName>')
          ..optionalParameters
              .addAll(model.fields.asBoolNamedParametersDefaultFalse)
          ..lambda = true
          ..body = Code('''
            ExposedForCodeGen.select(this, [${model.fields.map((field) => field.name).join(', ')}])
          '''),
      ))
      ..methods.add(Method(
        (b) => b
          ..name = 'updateAll'
          ..docs.add('/// TODO: document updateAll()')
          ..returns = refer('Future<void>')
          ..optionalParameters.addAll(model.fields.asOptionalNamedParameters)
          ..lambda = true
          ..body = Code('''
            ExposedForCodeGen.update(this, [${model.fields.map((field) => field.name).join(', ')}])
          '''),
      ))
      ..methods.addAll(model.fields.where((field) => field.unique).map(
            (field) => Method(
              (b) => b
                ..name = 'by${upperCamelCase(field.name)}'
                ..docs.add('/// TODO: document byXXX()}')
                ..returns = refer('QuerySingle<$modelName>')
                ..requiredParameters.add(Parameter(
                  (b) => b
                    ..name = field.name
                    ..type = refer(field.type),
                ))
                ..lambda = true
                ..body = Code('''
                  where(($modelInstanceName) =>
                    $modelInstanceName.${field.name}.equals.literal(${field.name})
                  ).first
                '''),
            ),
          )),
    // TODO: Add utility methods for easy lookup by field for each unique field!
  );

  // Extension for QuerySingle<model>
  yield Extension((b) => b
    ..name = 'QuerySingle${modelName}Ext'
    ..on = refer('QuerySingle<$modelName>')
    ..methods.add(Method(
      (b) => b
        ..name = 'select'
        ..docs.add('/// TODO document select()')
        ..returns = refer('QuerySingle<$modelName>')
        ..optionalParameters
            .addAll(model.fields.asBoolNamedParametersDefaultFalse)
        ..lambda = true
        ..body = Code('''
            ExposedForCodeGen.select(asQuery, [${model.fields.map((field) => field.name).join(', ')}]).first
          '''),
    ))
    ..methods.add(Method(
      (b) => b
        ..name = 'update'
        ..docs.add('/// TODO document update()')
        ..returns = refer('Future<void>')
        ..optionalParameters.addAll(model.fields.asOptionalNamedParameters)
        ..lambda = true
        ..body = Code('''
            ExposedForCodeGen.update(asQuery, [${model.fields.map((field) => field.name).join(', ')}])
          '''),
    ))
    ..methods.add(Method(
      (b) => b
        ..name = 'where'
        ..docs.add('/// TODO document where()')
        ..returns = refer('QuerySingle<$modelName>')
        ..requiredParameters.add(Parameter(
          (b) => b
            ..name = 'conditionBuilder'
            ..type = refer(
                'Expr<bool> Function(Expr<$modelName> $modelInstanceName)'),
        ))
        ..lambda = true
        ..body = Code('''
            ExposedForCodeGen.where(asQuery, conditionBuilder).first
          '''),
    )));

  // Extension for Expression<model>
  yield Extension(
    (b) => b
      ..name = 'Expression${modelName}Ext'
      ..on = refer('Expr<$modelName>')
      ..methods.addAll(model.fields.map((field) => Method(
            (b) => b
              ..name = field.name
              ..docs.add('/// TODO: document ${field.name}')
              ..type = MethodType.getter
              ..returns = refer('Expr<${field.type}>')
              ..lambda = true
              ..body = Code('ExposedForCodeGen.field(this, \'${field.name}\')'),
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

  Iterable<Parameter> get asBoolNamedParametersDefaultFalse =>
      map((field) => Parameter(
            (b) => b
              ..name = field.name
              ..type = refer('bool')
              ..named = true
              ..defaultTo = literal(false).code,
          ));
}
