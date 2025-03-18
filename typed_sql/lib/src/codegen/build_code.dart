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

// ignore_for_file: prefer_const_constructors

import 'package:code_builder/code_builder.dart';
import 'package:collection/collection.dart';

import '../utils/camelcase.dart';
import 'parsed_library.dart';
import 'type_args.dart';

Iterable<Spec> buildCode(
  ParsedLibrary library,
  List<ParsedRecord> records, {
  required bool createChecksExtensions,
}) sync* {
  yield* library.schemas.expand(buildSchema);
  yield* records.expand(buildRecord);

  if (createChecksExtensions) {
    yield* library.schemas
        .expand((s) => s.tables)
        .map((t) => t.model)
        .toSet()
        .sortedBy((m) => m.name)
        .expand(buildChecksForModel);
  }
}

/// Generate extensions for use with `package:checks`
Iterable<Spec> buildChecksForModel(ParsedModel model) sync* {
  // Create extension for Subject<Model>
  yield Extension((b) => b
    ..name = '${model.name}Checks'
    ..on = TypeReference(
      (b) => b
        ..symbol = 'Subject'
        ..types.add(refer(model.name)),
    )
    ..methods.addAll(model.fields.map((field) => Method(
          (b) => b
            ..name = field.name
            ..returns = refer('Subject<${field.type}>')
            ..type = MethodType.getter
            ..lambda = true
            ..body = Code('has((m) => m.${field.name}, \'${field.name}\')'),
        ))));
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
      ..methods.addAll([
        ...schema.tables.map(
          (table) => Method(
            (b) => b
              ..name = table.name
              ..docs.add('/// TODO: Propagate documentation for tables!')
              ..type = MethodType.getter
              ..returns = refer('Table<${table.model.name}>')
              ..lambda = true
              ..body = Code('''
                ExposedForCodeGen.declareTable(
                  this,
                  _\$${table.model.name}._\$table,
                )
              '''),
          ),
        ),
        Method(
          (b) => b
            ..name = 'createTables'
            ..modifier = MethodModifier.async
            ..returns = refer('Future<void>')
            ..lambda = true
            ..body = Code('''
              ExposedForCodeGen.createTables(
                context: this,
                tables: _\$tables,
              )
            '''),
        ),
      ])
      ..fields.add(Field(
        (b) => b
          ..name = '_\$tables'
          ..static = true
          ..modifier = FieldModifier.constant
          ..assignment = Code('''[
              ${schema.tables.map(
                    (table) => '_\$${table.model.name}._\$table',
                  ).join(', ')}
            ]
          '''),
      )),
  );

  // Create tables
  yield Method(
    (b) => b
      ..name = 'create${schema.name}Tables'
      ..returns = refer('String')
      ..requiredParameters.add(Parameter(
        (b) => b
          ..type = refer('SqlDialect')
          ..name = 'dialect',
      ))
      ..lambda = true
      ..body = Code('''
        ExposedForCodeGen.createTableSchema(
          dialect: dialect,
          tables: ${schema.name}Schema._\$tables,
        )
      '''),
  );

  for (final table in schema.tables) {
    yield* buildTable(table, schema);
  }
}

/// Generate code for [Model] subclasses used by [table]
Iterable<Spec> buildTable(ParsedTable table, ParsedSchema schema) sync* {
  final model = table.model;
  final modelName = model.name;
  final modelInstanceName = lowerCamelCase(modelName);

  final referencedFrom = schema.tables
      .expand((t) => t.model.foreignKeys.map((fk) => (table: t, fk: fk)))
      .where((ref) => ref.fk.as != null)
      .where((ref) => ref.fk.referencedTable == table)
      .toList();

  String readFromRowReader(String rowReader, ParsedField field) {
    var readBackingType = switch (field.backingType) {
      'String' => '$rowReader.readString()',
      'int' => '$rowReader.readInt()',
      'double' => '$rowReader.readDouble()',
      'bool' => '$rowReader.readBool()',
      'DateTime' => '$rowReader.readDateTime()',
      'Uint8List' => '$rowReader.readUint8List()',
      _ => throw UnsupportedError(
          'Unsupported type "${field.typeName}"',
        ),
    };
    if (field.backingType == field.typeName) {
      return readBackingType;
    }
    return '''
      ExposedForCodeGen.customDataTypeOrNull(
        $readBackingType,
        ${field.typeName}.fromDatabase,
      )
    ''';
  }

  String fieldBackingType(ParsedField field) {
    return switch (field.backingType) {
      'String' => 'ExposedForCodeGen.text',
      'int' => 'ExposedForCodeGen.integer',
      'double' => 'ExposedForCodeGen.real',
      'bool' => 'ExposedForCodeGen.boolean',
      'DateTime' => 'ExposedForCodeGen.dateTime',
      'Uint8List' => 'ExposedForCodeGen.blob',
      _ => throw UnsupportedError(
          'Unsupported type "${field.typeName}"',
        ),
    };
  }

  String fieldType(ParsedField field) {
    var backingTypeName = fieldBackingType(field);
    if (field.backingType == field.typeName) {
      return backingTypeName;
    }
    return '''
      ExposedForCodeGen.customDataType(
        $backingTypeName,
        ${field.typeName}.fromDatabase,
      )
    ''';
  }

  // Create implementation class for model
  yield Class(
    (b) => b
      ..name = '_\$$modelName'
      ..modifier = ClassModifier.final$
      ..extend = refer(model.name)
      ..constructors.add(Constructor(
        (b) => b
          ..name = '_'
          ..requiredParameters.addAll(model.fields.map((field) => Parameter(
                (b) => b
                  ..name = field.name
                  ..toThis = true,
              ))),
      ))
      ..fields.addAll(model.fields.mapIndexed((i, field) => Field(
            (b) => b
              ..name = field.name
              ..annotations.add(refer('override'))
              ..type = refer(field.type)
              ..modifier = FieldModifier.final$,
          )))
      ..fields.add(Field(
        (b) => b
          ..name = '_\$table'
          ..static = true
          ..modifier = FieldModifier.constant
          ..assignment = Code('''
            (
              tableName: '${table.name}',
              columns: <String>[${model.fields.map((f) => '\'${f.name}\'').join(', ')}],
              columnInfo: <({
                    ColumnType type,
                    bool isNotNull,
                    Object? defaultValue,
                    bool autoIncrement,
                  })>[
                ${model.fields.map((f) => '''
                  (
                    type: ${fieldBackingType(f)},
                    isNotNull: ${!f.isNullable},
                    defaultValue: ${literal(f.defaultValue)},
                    autoIncrement: ${f.autoIncrement},
                  )
                ''').join(', ')}
              ],
              primaryKey: <String>[${model.primaryKey.map((f) => '\'${f.name}\'').join(', ')}],
              unique: <List<String>>[
                ${model.fields.where((f) => f.unique).map(
                    (f) => '[\'${f.name}\']',
                  ).join(', ')}
              ],
              foreignKeys: <({
                    String name,
                    List<String> columns,
                    String referencedTable,
                    List<String> referencedColumns,
                  })>[
                ${model.foreignKeys.map((fk) => '''
                  (
                    name: '${fk.name}',
                    columns: ['${fk.key.name}'],
                    referencedTable: '${fk.table}',
                    referencedColumns: ['${fk.field}'],
                  )
                ''').join(',')}
              ],
              readModel: _\$${model.name}._\$fromDatabase,
            )
          '''),
      ))
      ..methods.addAll([
        Method(
          (b) => b
            ..name = '_\$fromDatabase'
            ..returns = refer('$modelName?')
            ..static = true
            ..requiredParameters.add(
              Parameter(
                (b) => b
                  ..name = 'row'
                  ..type = refer('RowReader'),
              ),
            )
            ..body = Code([
              for (final field in model.fields)
                'final ${field.name} = ${readFromRowReader('row', field)};',
              'if (${model.fields.map((f) => '${f.name} == null').join(' &&  ')}) {',
              'return null;',
              '}',
              'return _\$$modelName._(${model.fields.map((f) => f.name + (f.isNullable ? '' : '!')).join(', ')});',
            ].join('\n')),
        ),
        Method(
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
        ),
      ]),
  );

  // Extension for Table<model>
  yield Extension(
    (b) => b
      ..name = 'Table${modelName}Ext'
      ..on = refer('Table<$modelName>')
      ..methods.add(Method(
        (b) => b
          ..name = 'insertLiteral'
          ..docs.add(
              '/// TODO: document insertLiteral (this cannot explicitly insert NULL for nullable fields with a default value)')
          ..optionalParameters.addAll(model.fields.map((field) {
            final hasDefault = field.defaultValue != null || field.isNullable;
            final addNullable = hasDefault && !field.isNullable ? '?' : '';
            return Parameter(
              (b) => b
                ..name = field.name
                ..named = true
                ..required = !hasDefault
                ..type = refer('${field.type}$addNullable'),
            );
          }))
          ..returns = refer('Future<$modelName>')
          ..lambda = true
          ..body = Code('''
            ExposedForCodeGen.insertInto(
              table: this,
              values: [
                ${model.fields.map((field) {
            final hasDefault = field.defaultValue != null || field.isNullable;
            if (hasDefault) {
              return '${field.name} != null ? literal(${field.name}) : null';
            }
            return 'literal(${field.name})';
          }).join(', ')},
              ],
            )
          '''),
      ))
      ..methods.add(Method(
        (b) => b
          ..name = 'insert'
          ..docs.add('/// TODO: document insert')
          ..optionalParameters.addAll(model.fields.map((field) {
            final hasDefault = field.defaultValue != null || field.isNullable;
            final nullable = hasDefault ? '?' : '';
            return Parameter(
              (b) => b
                ..name = field.name
                ..named = true
                ..required = !hasDefault
                ..type = refer('Expr<${field.type}>$nullable'),
            );
          }))
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
              _\$${model.name}._\$table,
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
              _\$${model.name}._\$table,
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
          ))
      ..methods.add(Method(
        (b) => b
          ..name = 'delete'
          ..docs.add('/// TODO: document delete()}')
          ..returns = refer('Future<int>')
          ..lambda = true
          ..body = Code('''
              ExposedForCodeGen.delete(this, _\$${model.name}._\$table)
            '''),
      )),
    // TODO: Add utility methods for easy lookup by field for each unique field!
  );

  // Extension for QuerySingle<(Expr<model>,)>
  yield Extension(
    (b) => b
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
              _\$${model.name}._\$table,
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
              _\$${model.name}._\$table,
              ($modelInstanceName) => ExposedForCodeGen.buildUpdate<$modelName>([
                ${model.fields.map((field) => '${field.name} != null ? literal(${field.name}) : null').join(', ')},
              ]),
            )
          '''),
      ))
      ..methods.add(Method(
        (b) => b
          ..name = 'delete'
          ..docs.add('/// TODO: document delete()')
          ..returns = refer('Future<int>')
          ..lambda = true
          ..body = Code('asQuery.delete()'),
      )),
  );

  // Extension for Expression<model>
  yield Extension((b) => b
    ..name = 'Expression${modelName}Ext'
    ..on = refer('Expr<$modelName>')
    ..methods.addAll([
      ...model.fields.mapIndexed((i, field) => Method(
            (b) => b
              ..name = field.name
              ..docs.add('/// TODO: document ${field.name}')
              ..type = MethodType.getter
              ..returns = refer('Expr<${field.type}>')
              ..lambda = true
              ..body = Code(
                'ExposedForCodeGen.field(this, $i, ${fieldType(field)})',
              ),
          )),
      ...referencedFrom.map((ref) => Method(
            (b) => b
              ..name = ref.fk.as!
              ..docs.add('/// TODO: document references')
              ..type = MethodType.getter
              ..returns = refer('SubQuery<(Expr<${ref.table.model.name}>,)>')
              ..lambda = true
              ..body = Code('''
                ExposedForCodeGen.subqueryTable(
                  this,
                  _\$${ref.table.model.name}._\$table
                ).where((r) => r.${ref.fk.key.name}.equals(${ref.fk.field}))
              '''),
          )),
      ...model.foreignKeys.where((fk) => fk.name != null).map((fk) {
        var nullable = '?';
        var firstAssertNotNull = 'first';
        if (!fk.key.isNullable) {
          nullable = '';
          firstAssertNotNull = 'first.assertNotNull()';
        }
        return Method(
          (b) => b
            ..name = fk.name
            ..docs.add('/// TODO: document references')
            ..type = MethodType.getter
            ..returns = refer('Expr<${fk.referencedTable.model.name}$nullable>')
            ..lambda = true
            ..body = Code('''
              ExposedForCodeGen.subqueryTable(
                this,
                _\$${fk.referencedTable.model.name}._\$table
              ).where(
                (r) => r.${fk.field}.equals(${fk.key.name})
              ).$firstAssertNotNull
            '''),
        );
      }),
    ]));
}

/// Generate code for using `Query<T>` where `T` is a named record!
Iterable<Spec> buildRecord(ParsedRecord record) sync* {
  final positionalQueryType =
      refer('Query<${typArgedExprTuple(record.fields.length)}>');
  final namedQueryType = refer('Query<${record.type}>');

  yield Extension((b) => b
    ..name = 'Query${record.fields.map(upperCamelCase).join('')}Named'
    ..on = namedQueryType
    ..types.addAll(typeArg.take(record.fields.length).map(refer))
    ..methods.add(
      Method(
        (b) => b
          ..name = '_asPositionalQuery'
          ..returns = positionalQueryType
          ..type = MethodType.getter
          ..lambda = true
          ..body = Code('''
              ExposedForCodeGen.renamedRecord(this, (e) => (${record.fields.map(
                    (f) => 'e.$f',
                  ).join(', ')},))
            '''),
      ),
    )
    ..methods.add(Method(
      (b) => b
        ..name = '_fromPositionalQuery'
        ..returns = namedQueryType
        ..static = true
        ..types.addAll(typeArg.take(record.fields.length).map(refer))
        ..requiredParameters.add(Parameter(
          (b) => b
            ..name = 'query'
            ..type = positionalQueryType,
        ))
        ..lambda = true
        ..body = Code('''
            ExposedForCodeGen.renamedRecord(query, (e) => (${record.fields.mapIndexed(
                  (i, f) => '$f: e.\$${i + 1}',
                ).join(', ')},))
          '''),
    ))
    ..methods.add(Method(
      (b) => b
        ..name = '_wrapBuilder'
        ..returns = refer(
            'T Function(${typArgedExprArgumentList(record.fields.length)})')
        ..static = true
        ..types.add(refer('T'))
        ..types.addAll(typeArg.take(record.fields.length).map(refer))
        ..requiredParameters.add(Parameter(
          (b) => b
            ..name = 'builder'
            ..type = refer('T Function(${record.type} e)'),
        ))
        ..lambda = true
        ..body = Code('''
            (${arg.take(record.fields.length).join(', ')}) =>
              builder((${record.fields.mapIndexed((i, f) => '$f: ${arg[i]}').join(', ')},))
          '''),
    ))
    ..methods.add(Method(
      (b) => b
        ..name = 'fetch'
        ..returns = refer('Stream<${record.returnType}>')
        ..modifier = MethodModifier.asyncStar
        ..body = Code('''
            yield* _asPositionalQuery.fetch().map((e) => (${record.fields.mapIndexed(
                  (i, f) => '$f: e.\$${i + 1}',
                ).join(', ')},));
          '''),
    ))
    ..methods.add(Method(
      (b) => b
        ..name = 'offset'
        ..returns = namedQueryType
        ..requiredParameters.add(Parameter(
          (b) => b
            ..name = 'offset'
            ..type = refer('int'),
        ))
        ..lambda = true
        ..body = Code('''
            _fromPositionalQuery(_asPositionalQuery.offset(offset))
          '''),
    ))
    ..methods.add(Method(
      (b) => b
        ..name = 'limit'
        ..returns = namedQueryType
        ..requiredParameters.add(Parameter(
          (b) => b
            ..name = 'limit'
            ..type = refer('int'),
        ))
        ..lambda = true
        ..body = Code('''
            _fromPositionalQuery(_asPositionalQuery.limit(limit))
          '''),
    ))
    ..methods.add(Method(
      (b) => b
        ..name = 'select'
        ..returns = refer('Query<T>')
        ..types.add(refer('T extends Record'))
        ..requiredParameters.add(Parameter(
          (b) => b
            ..name = 'projectionBuilder'
            ..type = refer('T Function(${record.type} expr)'),
        ))
        ..lambda = true
        ..body = Code(
          '_asPositionalQuery.select(_wrapBuilder(projectionBuilder))',
        ),
    ))
    ..methods.add(Method(
      (b) => b
        ..name = 'where'
        ..returns = namedQueryType
        ..requiredParameters.add(Parameter(
          (b) => b
            ..name = 'conditionBuilder'
            ..type = refer('Expr<bool> Function(${record.type} expr)'),
        ))
        ..lambda = true
        ..body = Code('''
            _fromPositionalQuery(_asPositionalQuery.where(
              _wrapBuilder(conditionBuilder)
            ))
          '''),
    ))
    ..methods.add(Method(
      (b) => b
        ..name = 'orderBy'
        ..returns = namedQueryType
        ..types.add(refer('T'))
        ..requiredParameters.add(Parameter(
          (b) => b
            ..name = 'expressionBuilder'
            ..type = refer('Expr<T> Function(${record.type} expr)'),
        ))
        ..optionalParameters.add(Parameter(
          (b) => b
            ..name = 'descending'
            ..required = false
            ..named = true
            ..type = refer('bool')
            ..defaultTo = Code('false'),
        ))
        ..lambda = true
        ..body = Code('''
            _fromPositionalQuery(_asPositionalQuery.orderBy(
              _wrapBuilder(expressionBuilder),
              descending: descending,
            ))
          '''),
      // TODO: Add first when QuerySingle is supported!
    )));
}

extension on ParsedRecord {
  String get type => '({${fields.mapIndexed(
        (i, f) => 'Expr<${typeArg[i]}> $f',
      ).join(', ')},})';

  String get returnType => '({${fields.mapIndexed(
        (i, f) => '${typeArg[i]} $f',
      ).join(', ')},})';
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
          ..type = refer(field.nullable)
          ..named = true,
      ));
}

extension on ParsedField {
  String get type => isNullable ? '$typeName?' : typeName;

  String get nullable => '$typeName?';
}
