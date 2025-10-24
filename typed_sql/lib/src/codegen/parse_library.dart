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

// ignore_for_file: deprecated_member_use
// See: https://github.com/dart-lang/build/issues/3977

/// @docImport '../typed_sql.dart';
library;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart' show log;
import 'package:collection/collection.dart';
import 'package:source_gen/source_gen.dart';

import 'parsed_library.dart';
import 'type_checkers.dart';

final class ParserContext {
  ParserContext();
}

Future<ParsedLibrary> parseLibrary(
  ParserContext ctx,
  LibraryReader targetLibrary,
) async {
  // Cache row classes when parsing, this saves time, but more importantly
  // ensures that we can use identity equivalence on ParsedRowClass objects.
  final rowClassCache = <ClassElement, ParsedRowClass>{};

  // We maintain maps to elements so we can make better errors later!
  final schemaToElement = <ParsedSchema, ClassElement>{};
  final foreignKeyToElement = <ParsedForeignKey, Element>{};

  final schemas = targetLibrary.classes.where((cls) {
    final supertype = cls.supertype;
    return supertype != null && schemaTypeChecker.isExactlyType(supertype);
  }).map((cls) {
    final s = _parseSchema(ctx, cls, rowClassCache, foreignKeyToElement);
    schemaToElement[s] = cls;
    return s;
  }).toList();

  final rowClasses = targetLibrary.classes.where((cls) {
    final supertype = cls.supertype;
    return supertype != null && rowTypeChecker.isExactlyType(supertype);
  }).map((cls) {
    return rowClassCache.putIfAbsent(
      cls,
      () => _parseRowClass(ctx, cls, foreignKeyToElement),
    );
  }).toList();

  // At this point we only support one schema per library.
  if (schemas.length > 1) {
    throw InvalidGenerationSource(
      'Only one Schema per library is allowed! '
      'Consider splitting into one library per schema.',
      element: schemaToElement[schemas[1]],
    );
  }

  final library = ParsedLibrary(
    schemas: schemas,
    rowClasses: rowClasses,
  );

  // We only allow a Row subclass to be used for one table!
  final allTables = schemas.expand((s) => s.tables);
  for (final schema in schemas) {
    for (final table in schema.tables) {
      if (allTables.any((t) => t != table && t.rowClass == table.rowClass)) {
        throw InvalidGenerationSource(
          'Row subclass "${table.rowClass.name}" is used in more than one table!',
          element: rowClassCache.entries
              .firstWhere((e) => e.value == table.rowClass)
              .key,
        );
      }
    }
  }

  for (final schema in schemas) {
    for (final table in schema.tables) {
      for (final fk in table.rowClass.foreignKeys) {
        // Resolve referencedTable
        final referencedTable = schema.tables.firstWhereOrNull(
          (t) => t.name == fk.table,
        );
        if (referencedTable == null) {
          throw InvalidGenerationSource(
            'Foreign key references unknown table "${fk.table}"',
            element: foreignKeyToElement[fk],
          );
        }
        fk.referencedTable = referencedTable;

        // Throw exception, when [f] cannot be found
        Never throwUnknownField(String field) {
          throw InvalidGenerationSource(
            'Foreign key references unknown field "$field", '
            'no such field on table "${fk.table}".\n'
            'Available fields: '
            '${referencedTable.rowClass.fields.map((f) => f.name).join(', ')}.',
            element: foreignKeyToElement[fk],
          );
        }

        // Resolve referencedField
        fk.referencedFields = fk.fields.map((field) {
          return referencedTable.rowClass.fields.firstWhere(
            (f) => f.name == field,
            orElse: () => throwUnknownField(field),
          );
        }).toList();
      }
    }
  }

  return library;
}

ParsedSchema _parseSchema(
  ParserContext ctx,
  ClassElement cls,
  Map<ClassElement, ParsedRowClass> rowClassCache,
  Map<ParsedForeignKey, Element> foreignKeyToElement,
) {
  log.info('Found schema "${cls.name}"');

  if (!cls.isAbstract || !cls.isFinal) {
    throw InvalidGenerationSource(
      'subclasses of `Schema` must be `abstract final`',
      element: cls,
    );
  }

  if (cls.methods.isNotEmpty) {
    throw InvalidGenerationSource('subclasses of `Schema` cannot have methods',
        element: cls.methods.first);
  }

  final firstNonGetter = cls.fields.where((f) => f.getter == null).firstOrNull;
  if (firstNonGetter != null) {
    throw InvalidGenerationSource(
      'subclasses of `Schema` cannot have fields or setters',
      element: firstNonGetter,
    );
  }

  final tables = <ParsedTable>[];
  if (cls.setters.isNotEmpty) {
    throw InvalidGenerationSource(
      'subclasses of `Schema` cannot have setters',
      element: cls.setters.first,
    );
  }
  for (final a in cls.getters) {
    if (!a.isAbstract) {
      throw InvalidGenerationSource(
        'subclasses of `Schema` can only abstract getters',
        element: a,
      );
    }

    final returnType = a.returnType;
    final returnTypeElement = returnType.element;
    if (returnType is! ParameterizedType ||
        returnTypeElement == null ||
        !tableTypeChecker.isExactly(returnTypeElement)) {
      throw InvalidGenerationSource(
        'subclasses of `Schema` can only have `Table` properties',
        element: a,
      );
    }

    final typeArg = returnType.typeArguments.first;
    final typeArgElement = typeArg.element;
    if (typeArgElement is! ClassElement) {
      throw InvalidGenerationSource(
        'T must be a class in `Table<T>` properties',
        element: a,
      );
    }
    final typeArgSupertype = typeArgElement.supertype;
    if (typeArgSupertype == null ||
        !rowTypeChecker.isExactlyType(typeArgSupertype)) {
      throw InvalidGenerationSource(
        'T in `Table<T>` must be a subclass of `Row`',
        element: a,
      );
    }

    tables.add(ParsedTable(
      name: a.name!,
      documentation: a.documentationComment,
      rowClass: rowClassCache.putIfAbsent(
        typeArgElement,
        () => _parseRowClass(ctx, typeArgElement, foreignKeyToElement),
      ),
    ));
  }

  return ParsedSchema(
    name: cls.name!,
    tables: tables,
  );
}

ParsedRowClass _parseRowClass(
  ParserContext ctx,
  ClassElement cls,
  Map<ParsedForeignKey, Element> foreignKeyToElement,
) {
  log.info('Found row class "${cls.name}"');

  if (!cls.isAbstract || !cls.isFinal) {
    throw InvalidGenerationSource(
      'subclasses of `Row` must be `abstract final`',
      element: cls,
    );
  }

  if (cls.methods.isNotEmpty) {
    throw InvalidGenerationSource('subclasses of `Row` cannot have methods',
        element: cls.methods.first);
  }

  if (!cls.fields.any((f) => f.getter != null)) {
    throw InvalidGenerationSource(
      'subclasses of `Row` cannot have fields or setters',
      element: cls.fields.first,
    );
  }

  // Find parsed fields
  final fields = <ParsedField>[];
  if (cls.setters.isNotEmpty) {
    throw InvalidGenerationSource(
      'subclasses of `Row` cannot have setters',
      element: cls.setters.first,
    );
  }
  for (final a in cls.getters) {
    if (!a.isAbstract) {
      throw InvalidGenerationSource(
        'subclasses of `Row` can only abstract getters',
        element: a,
      );
    }

    var type = _tryGetColumnType(a.returnType);
    var backingType = type;
    if (type != null) {
      backingType = type;
    } else {
      final aReturnTypeElement = a.returnType.extensionTypeErasure.element;
      if (aReturnTypeElement is! ClassElement) {
        throw InvalidGenerationSource(
          'Unsupported data-type',
          element: a,
        );
      }
      final customDataType = aReturnTypeElement.allSupertypes
          .firstWhereOrNull((e) =>
              e.element3.name3 == 'CustomDataType' &&
              e.element3.library2.uri ==
                  Uri.parse('package:typed_sql/src/typed_sql.dart'))
          ?.element;

      if (customDataType is! ClassElement) {
        throw InvalidGenerationSource(
          'Unsupported data-type',
          element: a,
        );
      }

      final customDataTypeVariant = a.returnType.asInstanceOf(customDataType);
      if (customDataTypeVariant != null) {
        final T = customDataTypeVariant.typeArguments.first;
        backingType = _tryGetColumnType(T);
        if (backingType == null) {
          throw InvalidGenerationSource(
            'Unsupported type parameter for `CustomDataType<T>`!',
            element: a,
          );
        }
        if (T.nullabilitySuffix != NullabilitySuffix.none) {
          throw InvalidGenerationSource(
            'CustomDataType<T?> is not supported',
            element: a,
          );
        }

        var returnType = a.returnType as InterfaceType;

        // Check that there is a fromDatabase constructor
        final constructor = returnType.constructors
            .firstWhereOrNull((c) => c.name == 'fromDatabase');
        if (constructor == null) {
          throw InvalidGenerationSource(
            'CustomDataType<T> subclasses must have a `fromDatabase` constructor!',
            element: a,
          );
        }
        if (constructor.formalParameters.length != 1) {
          throw InvalidGenerationSource(
            'CustomDataType<T> subclasses must have a `fromDatabase` '
            'constructor must take a single argument!',
            element: a,
          );
        }
        final constructorArgType =
            _tryGetColumnType(constructor.formalParameters.first.type);
        if (constructorArgType != backingType) {
          throw throw InvalidGenerationSource(
            'CustomDataType<T> subclasses must have a `fromDatabase` '
            'constructor whose argument type matches the backing type `T`!',
            element: a,
          );
        }

        final alias = returnType.alias;
        if (alias != null) {
          if (alias.typeArguments.isNotEmpty) {
            throw InvalidGenerationSource(
              'Field types may not have type arguments, '
              'use a typedef to create an alias without type arguments.',
              element: a,
            );
          }
          type = alias.element.name;
        } else {
          if (returnType.typeArguments.isNotEmpty) {
            throw InvalidGenerationSource(
              'Field types may not have type arguments, '
              'use a typedef to create an alias without type arguments.',
              element: a,
            );
          }
          type = returnType.element.name;
        }
      } else {
        // TODO: Add support for dart:typed_data fields
        // TODO: Consider support for Duration
        // TODO: Consider support for List, Set, Map, Record (probably not)
        // TODO: Consider support for enums
        throw InvalidGenerationSource(
          'Unsupported data-type',
          element: a,
        );
      }
    }

    final autoIncrement = autoIncrementTypeChecker.hasAnnotationOf(a);
    if (autoIncrement && type != 'int') {
      throw InvalidGenerationSource(
        'AutoIncrement is only allowed for int fields',
        element: a,
      );
    }

    final field = ParsedField(
      name: a.name!,
      documentation: a.documentationComment,
      typeName: type!,
      isNullable: a.returnType.nullabilitySuffix != NullabilitySuffix.none,
      backingType: backingType,
      // TODO: Support Unique(given: [...])
      unique: uniqueTypeChecker.hasAnnotationOf(a),
      autoIncrement: autoIncrement,
      defaultValue: _parseDefaultValue(a, type),
    );
    fields.add(field);
  }

  // Extract @References annotations
  final foreignKeys = <ParsedForeignKey>[];
  for (final a in [...cls.getters, ...cls.setters]) {
    for (final annotation in referencesTypeChecker.annotationsOf(a)) {
      final key = a.name;
      final table = annotation.getField('table')?.toStringValue();
      final field = annotation.getField('field')?.toStringValue();
      final as = annotation.getField('as')?.toStringValue();
      final name = annotation.getField('name')?.toStringValue();
      if (table == null || field == null) {
        throw InvalidGenerationSource(
          'References annotation must have `table` and `field` fields!',
          element: a,
        );
      }
      if (fields.any((f) => f.name == name)) {
        throw InvalidGenerationSource(
          'References have `name: "$name"` which conflicts with the field '
          'that has the same name!',
          element: a,
        );
      }

      final fk = ParsedForeignKey(
        foreignKey: [fields.firstWhere((f) => f.name == key)],
        table: table,
        fields: [field],
        as: as,
        name: name,
      );
      foreignKeyToElement[fk] = a;
      foreignKeys.add(fk);
    }
  }

  // Extract @ForeignKey annotations
  for (final annotation in foreignKeyTypeChecker.annotationsOfExact(cls)) {
    final foreignKey = annotation
        .getField('foreignKey')!
        .toListValue()!
        .map((v) => v.toStringValue()!)
        .map((field) {
      return fields.firstWhere((f) => f.name == field);
    }).toList();

    final fk = ParsedForeignKey(
      foreignKey: foreignKey,
      table: annotation.getField('table')!.toStringValue()!,
      fields: annotation
          .getField('fields')!
          .toListValue()!
          .map((v) => v.toStringValue()!)
          .toList(),
      as: annotation.getField('as')?.toStringValue(),
      name: annotation.getField('name')?.toStringValue(),
    );
    foreignKeyToElement[fk] = cls;
    foreignKeys.add(fk);
  }

  // Extract primary key!
  final pks = primaryKeyTypeChecker.annotationsOfExact(cls);
  if (pks.isEmpty || pks.length > 1) {
    throw InvalidGenerationSource(
      'subclasses of `Row` must have one `PrimaryKey` annotation',
      element: cls,
    );
  }
  final primaryKey = pks.first
      .getField('fields')!
      .toListValue()!
      .map((v) => v.toStringValue()!)
      .map((key) {
    final field = fields.firstWhereOrNull((field) => field.name == key);
    if (field == null) {
      throw InvalidGenerationSource(
        'PrimaryKey annotation references unknown field "$field"',
        element: cls,
      );
    }
    return field;
  }).toList();

  if (primaryKey.isEmpty) {
    throw InvalidGenerationSource(
      'subclasses of `Row` must have a non-empty `PrimaryKey` annotation',
      element: cls,
    );
  }
  if (primaryKey.length != primaryKey.toSet().length) {
    throw InvalidGenerationSource(
      'subclasses of `Row` cannot have duplicate fields in `PrimaryKey`',
      element: cls,
    );
  }
  if (primaryKey.any((f) => f.isNullable)) {
    throw InvalidGenerationSource(
      'PrimaryKey fields cannot be nullable',
      element: cls,
    );
  }

  return ParsedRowClass(
    name: cls.name!,
    primaryKey: primaryKey,
    fields: fields,
    foreignKeys: foreignKeys,
  );
}

String? _tryGetColumnType(DartType t) {
  if (t.isDartCoreBool) {
    return 'bool';
  } else if (t.isDartCoreString) {
    return 'String';
  } else if (t.isDartCoreDouble) {
    return 'double';
  } else if (t.isDartCoreInt) {
    return 'int';
  } else if (dateTimeTypeChecker.isExactlyType(t)) {
    return 'DateTime';
  } else if (uint8ListTypeChecker.isExactlyType(t)) {
    return 'Uint8List';
  }
  return null;
}

/// Parsed [DefaultValue] annotations from [field] with [type].
Object? _parseDefaultValue(Element field, String type) {
  final defaultValueAnnotations = defaultValueTypeChecker.annotationsOfExact(
    field,
  );
  if (defaultValueAnnotations.isEmpty) {
    return null;
  }
  if (defaultValueAnnotations.length > 1) {
    throw InvalidGenerationSource(
      'Only one DefaultValue annotation is allowed',
      element: field,
    );
  }

  final annotation = defaultValueAnnotations.first;
  final value = annotation.getField('value');
  if (value == null) {
    throw InvalidGenerationSource(
      'DefaultValue annotation must have a non-null value',
      element: field,
    );
  }
  final defaultValue = value.toBoolValue() ??
      value.toIntValue() ??
      value.toDoubleValue() ??
      value.toStringValue();
  // TODO: Support parsing date-time!
  if (defaultValue == null) {
    throw InvalidGenerationSource(
      'Unsupported DefaultValue',
      element: field,
    );
  }
  if (defaultValue is String && type != 'String') {
    throw InvalidGenerationSource(
      'DefaultValue of type String is only allowed for String fields',
      element: field,
    );
  }
  if (defaultValue is bool && type != 'bool') {
    throw InvalidGenerationSource(
      'DefaultValue of type bool is only allowed for bool fields',
      element: field,
    );
  }
  if (defaultValue is int && type != 'int') {
    throw InvalidGenerationSource(
      'DefaultValue of type int is only allowed for int fields',
      element: field,
    );
  }
  if (defaultValue is double && type != 'double') {
    throw InvalidGenerationSource(
      'DefaultValue of type double is only allowed for double fields',
      element: field,
    );
  }

  return defaultValue;
}
