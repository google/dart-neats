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
import 'code_builder_ext.dart';
import 'docs.dart' as docs;
import 'parsed_library.dart';
import 'type_args.dart';

Iterable<Spec> buildCode(
  ParsedLibrary library,
  List<ParsedRecord> records, {
  required bool createChecksExtensions,
}) sync* {
  yield* library.schemas.expand(buildSchema);
  yield* records.expand(buildRecord);

  yield* _buildCustomTypeExtensions(library);

  if (createChecksExtensions) {
    yield* library.schemas
        .expand((s) => s.tables)
        .map((t) => t.model)
        .toSet()
        .sortedBy((m) => m.name)
        .expand(buildChecksForModel);
  }
}

/// Generate extensions for `CustomDataType<T>` subclasses used in fields.
Iterable<Spec> _buildCustomTypeExtensions(ParsedLibrary library) sync* {
  // Find the unique set of CustomDataType classes used
  final customTypes = library.models
      .expand((model) => model.fields)
      .where((field) => field.typeName != field.backingType)
      .map((field) => (
            typeName: field.typeName,
            backingTypeExpr: backingExprType(field.backingType)
          ))
      .toSet()
      .sortedBy((e) => e.typeName);

  for (final (:typeName, :backingTypeExpr) in customTypes) {
    // Extension for creating an literal Expr<T> from T, when
    // T extends CustomDataType<T>
    yield Extension(
      (b) => b
        ..name = '${typeName}Ext'
        ..on = refer(typeName)
        ..documentation('''
          Wrap this [$typeName] as [Expr<$typeName>] for use queries with
          `package:typed_sql`.
        ''')
        // We define a static exprType here, and use it in other parts of the
        // generated code!
        ..fields.add(Field(
          (b) => b
            ..name = '_exprType'
            ..modifier = FieldModifier.final$
            ..static = true
            ..assignment = Code('''
              ExposedForCodeGen.customDataType(
                $backingTypeExpr,
                $typeName.fromDatabase,
              )
            '''),
        ))
        ..methods.add(Method(
          (b) => b
            ..name = 'asExpr'
            ..documentation(docs.customDataTypeAsExpr(typeName, ''))
            ..returns = refer('Expr<$typeName>')
            ..type = MethodType.getter
            ..lambda = true
            ..body = Code('''
              ExposedForCodeGen.literalCustomDataType(
                this,
                _exprType,
              ).asNotNull()
            '''),
        )),
    );

    // Extension for creating an literal Expr<T?> from T, when
    // T extends CustomDataType<T>
    yield Extension(
      (b) => b
        ..name = '${typeName}NullableExt'
        ..on = refer('$typeName?')
        ..documentation('''
          Wrap this [$typeName] as [Expr<$typeName>] for use queries with
          `package:typed_sql`.
        ''')
        ..methods.add(Method(
          (b) => b
            ..name = 'asExpr'
            ..documentation(docs.customDataTypeAsExpr(typeName, '?'))
            ..returns = refer('Expr<$typeName?>')
            ..type = MethodType.getter
            ..lambda = true
            ..body = Code('''
              ExposedForCodeGen.literalCustomDataType(
                this,
                ${typeName}Ext._exprType,
              )
            '''),
        )),
    );

    //yield Extension();
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
    ..documentation('''
      Extension methods for assertions on [${model.name}] using
      [`package:checks`][1].

      [1]: https://pub.dev/packages/checks
    ''')
    ..methods.addAll(model.fields.map((field) => Method(
          (b) => b
            ..name = field.name
            ..documentation('''
              Create assertions on [${model.name}.${field.name}].
            ''')
            ..returns = refer('Subject<${field.type}>')
            ..type = MethodType.getter
            ..lambda = true
            ..body = Code('has((m) => m.${field.name}, \'${field.name}\')'),
        ))));
}

/// Generate code for [Schema] subclass, parsed into [schema].
Iterable<Spec> buildSchema(ParsedSchema schema) sync* {
  // Create the extension for the `Schema` subclass, example:
  // extension PrimaryDatabaseSchema on Database<PrimaryDatabase> {...}
  yield Extension(
    (b) => b
      ..name = '${schema.name}Schema'
      ..documentation('''
        Extension methods for a [Database] operating on [${schema.name}].
      ''')
      ..on = TypeReference(
        (b) => b
          ..symbol = 'Database'
          ..types.add(refer(schema.name)),
      )
      ..methods.addAll([
        ...schema.tables.map(
          (table) => Method(
            (b) => b
              ..name = table.name
              ..docs.add(table.documentation ?? '')
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
            ..documentation('''
              Create tables defined in [${schema.name}].

              Calling this on an empty database will create the tables
              defined in [${schema.name}]. In production it's often better to
              use [create${schema.name}Tables] and manage migrations using
              external tools.

              This method is mostly useful for testing.

              > [!WARNING]
              > If the database is **not empty** behavior is undefined, most
              > likely this operation will fail.
            ''')
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
      ..documentation('''
        Get SQL [DDL statements][1] for tables defined in [${schema.name}].

        This returns a SQL script with multiple DDL statements separated by `;`
        using the specified [dialect].

        Executing these statements in an empty database will create the tables
        defined in [${schema.name}]. In practice, this method is often used for
        printing the DDL statements, such that migrations can be managed by
        external tools.

        [1]: https://en.wikipedia.org/wiki/Data_definition_language
      ''')
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
                    type: ${backingExprType(f.backingType)},
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
      ..documentation('''
        Extension methods for table defined in [$modelName].
      ''')
      ..on = refer('Table<$modelName>')
      ..methods.add(Method(
        (b) => b
          ..name = 'insert'
          ..documentation('''
            Insert row into the `${table.name}` table.

            Returns a [InsertSingle] statement on which `.execute` must be
            called for the row to be inserted.
          ''')
          ..optionalParameters.addAll(model.fields.map((field) {
            final hasDefault = field.defaultValue != null ||
                field.isNullable ||
                field.autoIncrement;
            final nullable = hasDefault ? '?' : '';
            return Parameter(
              (b) => b
                ..name = field.name
                ..named = true
                ..required = !hasDefault
                ..type = refer('Expr<${field.type}>$nullable'),
            );
          }))
          ..returns = refer('InsertSingle<$modelName>')
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
          ..documentation('''
            Delete a single row from the `${table.name}` table, specified by
            _primary key_.

            Returns a [DeleteSingle] statement on which `.execute()` must be
            called for the row to be deleted.

            To delete multiple rows, using `.where()` to filter which rows
            should be deleted. If you wish to delete all rows, use
            `.where((_) => toExpr(true)).delete()`.
          ''')
          ..returns = refer('DeleteSingle<$modelName>')
          ..requiredParameters.addAll(model.primaryKey.map((pk) => Parameter(
                (b) => b
                  ..name = pk.name
                  ..type = refer(pk.type),
              )))
          ..lambda = true
          ..body = Code('''
            ExposedForCodeGen.deleteSingle(
              byKey(
                ${model.primaryKey.map((f) => f.name).join(', ')}
              ),
              _\$${model.name}._\$table,
            )
          '''),
      )),
  );

  // Extension for Query<(Expr<model>,)>
  yield Extension(
    (b) => b
      ..name = 'Query${modelName}Ext'
      ..documentation('''
        Extension methods for building queries against the `${table.name}` table.
      ''')
      ..on = refer('Query<(Expr<$modelName>,)>')
      ..methods.add(Method(
        (b) => b
          ..name = 'byKey'
          ..documentation('''
            Lookup a single row in `${table.name}` table using the _primary key_.

            Returns a [QuerySingle] object, which returns at-most one row,
            when `.fetch()` is called.
          ''')
          ..returns = refer('QuerySingle<(Expr<$modelName>,)>')
          ..requiredParameters.addAll(model.primaryKey.map((pk) => Parameter(
                (b) => b
                  ..name = pk.name
                  ..type = refer(pk.type),
              )))
          ..lambda = true
          ..body = Code('where(($modelInstanceName) => ${model.primaryKey.map(
                (f) => '$modelInstanceName.${f.name}.equalsLiteral(${f.name})',
              ).join(' & ')}).first'),
      ))
      ..methods.add(Method(
        (b) => b
          ..name = 'update'
          ..documentation('''
            Update all rows in the `${table.name}` table matching this [Query].

            The changes to be applied to each row matching this [Query] are
            defined using the [updateBuilder], which is given an [Expr]
            representation of the row being updated and a `set` function to
            specify which fields should be updated. The result of the `set`
            function should always be returned from the `updateBuilder`.

            Returns an [Update] statement on which `.execute()` must be called
            for the rows to be updated.

            **Example:** decrementing `1` from the `value` field for each row
            where `value > 0`.
            ```dart
            await db.mytable
              .where((row) => row.value > toExpr(0))
              .update((row, set) => set(
                value: row.value - toExpr(1),
              ))
              .execute();
            ```

            > [!WARNING]
            > The `updateBuilder` callback does not make the update, it builds
            > the expressions for updating the rows. You should **never** invoke
            > the `set` function more than once, and the result should always
            > be returned immediately.
          ''')
          ..returns = refer('Update<$modelName>')
          ..requiredParameters.add(Parameter(
            (b) => b
              ..type = refer('''
                  UpdateSet<$modelName> Function(
                    Expr<$modelName> $modelInstanceName,
                    UpdateSet<$modelName> Function({
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
      ..methods.addAll(model.fields.where((field) => field.unique).map(
            (field) => Method(
              (b) => b
                ..name = 'by${upperCamelCase(field.name)}'
                ..documentation('''
                  Lookup a single row in `${table.name}` table using the
                  `${field.name}` field.

                  We know that lookup by the `${field.name}` field returns
                  at-most one row because the `${field.name}` has an [Unique]
                  annotation in [$modelName].

                  Returns a [QuerySingle] object, which returns at-most one row,
                  when `.fetch()` is called.
                ''')
                ..returns = refer('QuerySingle<(Expr<$modelName>,)>')
                ..requiredParameters.add(Parameter(
                  (b) => b
                    ..name = field.name
                    ..type = refer(field.typeName),
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
          ..documentation('''
            Delete all rows in the `${table.name}` table matching this [Query].

            Returns a [Delete] statement on which `.execute()` must be called
            for the rows to be deleted.
          ''')
          ..returns = refer('Delete<$modelName>')
          ..lambda = true
          ..body = Code('''
              ExposedForCodeGen.delete(this, _\$${model.name}._\$table)
            '''),
      )),
  );

  // Extension for QuerySingle<(Expr<model>,)>
  yield Extension(
    (b) => b
      ..name = 'QuerySingle${modelName}Ext'
      ..documentation('''
        Extension methods for building point queries against the `${table.name}` table.
      ''')
      ..on = refer('QuerySingle<(Expr<$modelName>,)>')
      ..methods.add(Method(
        (b) => b
          ..name = 'update'
          ..documentation('''
            Update the row (if any) in the `${table.name}` table matching this
            [QuerySingle].

            The changes to be applied to the row matching this [QuerySingle] are
            defined using the [updateBuilder], which is given an [Expr]
            representation of the row being updated and a `set` function to
            specify which fields should be updated. The result of the `set`
            function should always be returned from the `updateBuilder`.

            Returns an [UpdateSingle] statement on which `.execute()` must be
            called for the row to be updated. The resulting statement will
            **not** fail, if there are no rows matching this query exists.

            **Example:** decrementing `1` from the `value` field the row with
            `id = 1`.
            ```dart
            await db.mytable
              .byKey(1)
              .update((row, set) => set(
                value: row.value - toExpr(1),
              ))
              .execute();
            ```

            > [!WARNING]
            > The `updateBuilder` callback does not make the update, it builds
            > the expressions for updating the rows. You should **never** invoke
            > the `set` function more than once, and the result should always
            > be returned immediately.
          ''')
          ..returns = refer('UpdateSingle<$modelName>')
          ..requiredParameters.add(Parameter(
            (b) => b
              ..type = refer('''
                UpdateSet<$modelName> Function(
                  Expr<$modelName> $modelInstanceName,
                  UpdateSet<$modelName> Function({
                    ${model.fields.map((field) => 'Expr<${field.type}> ${field.name}').join(', ')},
                  }) set,
                )
              ''')
              ..name = 'updateBuilder',
          ))
          ..lambda = true
          ..body = Code('''
            ExposedForCodeGen.updateSingle<$modelName>(
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
          ..name = 'delete'
          ..documentation('''
            Delete the row (if any) in the `${table.name}` table matching this [QuerySingle].

            Returns a [DeleteSingle] statement on which `.execute()` must be called
            for the row to be deleted. The resulting statement will **not**
            fail, if there are no rows matching this query exists.
          ''')
          ..returns = refer('DeleteSingle<$modelName>')
          ..lambda = true
          ..body = Code(
            'ExposedForCodeGen.deleteSingle(this, _\$${model.name}._\$table)',
          ),
      )),
  );

  // Extension for Expression<model>Ext
  yield Extension((b) => b
    ..name = 'Expression${modelName}Ext'
    ..documentation('''
      Extension methods for expressions on a row in the `${table.name}` table.
    ''')
    ..on = refer('Expr<$modelName>')
    ..methods.addAll([
      ...model.fields.mapIndexed((i, field) => Method(
            (b) => b
              ..name = field.name
              ..docs.add(field.documentation ?? '')
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
              ..documentation('''
                Get [SubQuery] of rows from the `${ref.table.name}` table which
                reference [${ref.fk.field}] in the `${ref.fk.key.name}` field.

                This returns a [SubQuery] of [${ref.table.model.name}] rows,
                where [${ref.table.model.name}.${ref.fk.key.name}] is references
                [$modelName.${ref.fk.field}] in this row.
              ''')
              ..type = MethodType.getter
              ..returns = refer('SubQuery<(Expr<${ref.table.model.name}>,)>')
              ..lambda = true
              ..body = Code('''
                ExposedForCodeGen.subqueryTable(
                  _\$${ref.table.model.name}._\$table
                ).where((r) => r.${ref.fk.key.name}.equals(${ref.fk.field}))
              '''),
          )),
      ...model.foreignKeys.where((fk) => fk.name != null).map((fk) {
        var nullable = '?';
        var ifAnyDocs = ', if any';
        var firstAsNotNull = 'first';
        if (!fk.key.isNullable) {
          nullable = '';
          ifAnyDocs = '';
          firstAsNotNull = 'first.asNotNull()';
        }
        return Method(
          (b) => b
            ..name = fk.name
            ..documentation('''
              Do a subquery lookup of the row from table
              `${fk.referencedTable.name}` referenced in [${fk.key.name}].

              The gets the row from table `${fk.referencedTable.name}` where
              [${fk.referencedTable.model.name}.${fk.field}] is equal to
              [${fk.key.name}]$ifAnyDocs.
            ''')
            ..type = MethodType.getter
            ..returns = refer('Expr<${fk.referencedTable.model.name}$nullable>')
            ..lambda = true
            ..body = Code('''
              ExposedForCodeGen.subqueryTable(
                _\$${fk.referencedTable.model.name}._\$table
              ).where(
                (r) => r.${fk.field}.equals(${fk.key.name})
              ).$firstAsNotNull
            '''),
        );
      }),
    ]));

  // Extension for ExpressionNullable<model>Ext
  yield Extension((b) => b
    ..name = 'ExpressionNullable${modelName}Ext'
    ..on = refer('Expr<$modelName?>')
    ..methods.addAll([
      ...model.fields.mapIndexed((i, field) => Method(
            (b) => b
              ..name = field.name
              ..docs.add(field.documentation ?? '')
              ..type = MethodType.getter
              ..returns = refer('Expr<${field.typeName}?>')
              ..lambda = true
              ..body = Code(
                'ExposedForCodeGen.field(this, $i, ${fieldType(field)})',
              ),
          )),
      ...referencedFrom.map((ref) => Method(
            (b) => b
              ..name = ref.fk.as!
              ..documentation('''
                Get [SubQuery] of rows from the `${ref.table.name}` table which
                reference [${ref.fk.field}] in the `${ref.fk.key.name}` field.

                This returns a [SubQuery] of [${ref.table.model.name}] rows,
                where [${ref.table.model.name}.${ref.fk.key.name}] is references
                [$modelName.${ref.fk.field}] in this row, if any.

                If this row is `NULL` the subquery is always be empty.
              ''')
              ..type = MethodType.getter
              ..returns = refer('SubQuery<(Expr<${ref.table.model.name}>,)>')
              ..lambda = true
              ..body = Code('''
                ExposedForCodeGen.subqueryTable(
                  _\$${ref.table.model.name}._\$table
                ).where((r) =>
                  ${ref.fk.field}.isNotNull() &
                  r.${ref.fk.key.name}.equals(${ref.fk.field})
                )
              '''),
          )),
      ...model.foreignKeys.where((fk) => fk.name != null).map((fk) {
        return Method(
          (b) => b
            ..name = fk.name
            ..documentation('''
              Do a subquery lookup of the row from table
              `${fk.referencedTable.name}` referenced in [${fk.key.name}].

              The gets the row from table `${fk.referencedTable.name}` where
              [${fk.referencedTable.model.name}.${fk.field}] is equal to
              [${fk.key.name}], if any.

              If this row is `NULL` the subquery is always return `NULL`.
            ''')
            ..type = MethodType.getter
            ..returns = refer('Expr<${fk.referencedTable.model.name}?>')
            ..lambda = true
            ..body = Code('''
              ExposedForCodeGen.subqueryTable(
                _\$${fk.referencedTable.model.name}._\$table
              ).where(
                (r) =>
                  ${fk.key.name}.isNotNull() &
                  r.${fk.field}.equals(${fk.key.name})
              ).first
            '''),
        );
      }),
      Method(
        (b) => b
          ..name = 'isNotNull'
          ..documentation('''
            Check if the row is not `NULL`.

            This will check if _primary key_ fields in this row are `NULL`.

            If this is a reference lookup by subquery it might be more efficient
            to check if the referencing field is `NULL`.
          ''')
          ..returns = refer('Expr<bool>')
          ..lambda = true
          ..body = Code(
            model.primaryKey.map((pk) => '${pk.name}.isNotNull()').join(' & '),
          ),
      ),
      Method(
        (b) => b
          ..name = 'isNull'
          ..documentation('''
            Check if the row is `NULL`.

            This will check if _primary key_ fields in this row are `NULL`.

            If this is a reference lookup by subquery it might be more efficient
            to check if the referencing field is `NULL`.
          ''')
          ..returns = refer('Expr<bool>')
          ..lambda = true
          ..body = Code('isNotNull().not()'),
      ),
    ]));
}

/// Generate code for using `Query<T>` where `T` is a named record!
Iterable<Spec> buildRecord(ParsedRecord record) sync* {
  final positionalQueryType =
      refer('Query<${typArgedExprTuple(record.fields.length)}>');
  final namedQueryType = refer('Query<${record.type}>');

  yield Extension((b) => b
    ..name = 'Query${record.fields.map(upperCamelCase).join('')}Named'
    ..documentation('''
      Extension methods for building queries projected to a named record.
    ''')
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
        ..name = 'stream'
        ..documentation(docs.streamQuery)
        ..returns = refer('Stream<${record.returnType}>')
        ..modifier = MethodModifier.asyncStar
        ..body = Code('''
            yield* _asPositionalQuery.stream().map((e) => (${record.fields.mapIndexed(
                  (i, f) => '$f: e.\$${i + 1}',
                ).join(', ')},));
          '''),
    ))
    ..methods.add(Method(
      (b) => b
        ..name = 'fetch'
        ..documentation(docs.fetchQuery)
        ..returns = refer('Future<List<${record.returnType}>>')
        ..modifier = MethodModifier.async
        ..lambda = true
        ..body = Code('await stream().toList()'),
    ))
    ..methods.add(Method(
      (b) => b
        ..name = 'offset'
        ..documentation(docs.offset('Query'))
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
        ..documentation(docs.limit('Query'))
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
        ..documentation(docs.select('Query'))
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
        ..documentation(docs.where('Query'))
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
    )));
  // TODO: Add first when QuerySingle is supported!
  // TODO: Add orderBy as below, when we have named tuple support for OrderedQuery...
  /*..methods.add(Method(
      (b) => b
        ..name = 'orderBy'
        ..documentation(docs.orderBy('Query'))
        ..returns = namedQueryType
        ..requiredParameters.add(Parameter(
          (b) => b
            ..name = 'builder'
            ..type = refer(
              'List<(Expr<Comparable?>, Order)> Function(${record.type} expr)',
            ),
        ))
        ..lambda = true
        ..body = Code('''
            _fromPositionalQuery(_asPositionalQuery.orderBy(
              _wrapBuilder(builder),
            ))
          '''),
    ))*/
}

extension on ParsedRecord {
  String get type => '({${fields.mapIndexed(
        (i, f) => 'Expr<${typeArg[i]}> $f',
      ).join(', ')},})';

  String get returnType => '({${fields.mapIndexed(
        (i, f) => '${typeArg[i]} $f',
      ).join(', ')},})';
}

extension on ParsedField {
  String get type => isNullable ? '$typeName?' : typeName;
}

String backingExprType(String backingType) {
  return switch (backingType) {
    'String' => 'ExposedForCodeGen.text',
    'int' => 'ExposedForCodeGen.integer',
    'double' => 'ExposedForCodeGen.real',
    'bool' => 'ExposedForCodeGen.boolean',
    'DateTime' => 'ExposedForCodeGen.dateTime',
    'Uint8List' => 'ExposedForCodeGen.blob',
    _ => throw UnsupportedError(
        'Unsupported backingType: "$backingType"',
      ),
  };
}

String fieldType(ParsedField field) {
  var backingTypeName = backingExprType(field.backingType);
  if (field.backingType == field.typeName) {
    return backingTypeName;
  }
  return '${field.typeName}Ext._exprType';
}
