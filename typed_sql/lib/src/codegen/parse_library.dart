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

import 'package:analyzer/dart/constant/value.dart' show DartObject;
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart' show log;
import 'package:collection/collection.dart';
import 'package:source_gen/source_gen.dart';

import '../typed_sql.dart' show SqlOverride;

import '../types/json_value.dart' show JsonValue;
import 'parsed_default_value.dart';
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
  final fieldToElement = <ParsedField, Element>{};
  final foreignKeyToElement = <ParsedForeignKey, Element>{};

  final schemas = targetLibrary.classes.where((cls) {
    final supertype = cls.supertype;
    return supertype != null && schemaTypeChecker.isExactlyType(supertype);
  }).map((cls) {
    final s = _parseSchema(
      ctx,
      cls,
      rowClassCache,
      foreignKeyToElement,
      fieldToElement,
    );
    schemaToElement[s] = cls;
    return s;
  }).toList();

  final rowClasses = targetLibrary.classes.where((cls) {
    final supertype = cls.supertype;
    return supertype != null && rowTypeChecker.isExactlyType(supertype);
  }).map((cls) {
    return rowClassCache.putIfAbsent(
      cls,
      () => _parseRowClass(ctx, cls, foreignKeyToElement, fieldToElement),
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

  final library = ParsedLibrary(schemas: schemas, rowClasses: rowClasses);

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

  // Check that AutoIncrement is only used on non-composite primary keys
  for (final schema in schemas) {
    for (final table in schema.tables) {
      for (final field in table.rowClass.fields) {
        if (field.autoIncrement) {
          if (!table.rowClass.primaryKey.contains(field)) {
            throw InvalidGenerationSource(
              'AutoIncrement is only allowed on primary key fields',
              element: fieldToElement[field],
            );
          }
          if (table.rowClass.primaryKey.length != 1) {
            throw InvalidGenerationSource(
              'AutoIncrement is only allowed on non-composite primary key fields',
              element: fieldToElement[field],
            );
          }
        }
      }
    }
  }

  // Check references in foreign keys can be resolved
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

  // Sanity check foreign keys
  for (final schema in schemas) {
    for (final table in schema.tables) {
      for (final fk in table.rowClass.foreignKeys) {
        // Check we equal fields
        if (fk.foreignKey.length != fk.referencedFields.length) {
          throw InvalidGenerationSource(
            'Foreign key fields and referenced fields must have the same length',
            element: foreignKeyToElement[fk],
          );
        }

        // Check referenced foreign keys have matching types
        for (var i = 0; i < fk.foreignKey.length; i++) {
          final fkField = fk.foreignKey[i];
          final referencedField = fk.referencedFields[i];
          if (fkField.typeName != referencedField.typeName) {
            throw InvalidGenerationSource(
              'Foreign key field "${fkField.name}" has type '
              '"${fkField.typeName}" but references field '
              '"${referencedField.name}" with type '
              '"${referencedField.typeName}" in table "${fk.table}". '
              'Types must match!',
              element: foreignKeyToElement[fk],
            );
          }
        }

        // Check that backingType is never JsonValue
        if (fk.foreignKey.any((f) => f.backingType == 'JsonValue')) {
          throw InvalidGenerationSource(
            'JsonValue field cannot be used in foreign keys',
            element: foreignKeyToElement[fk],
          );
        }
      }
    }
  }

  // Check that JsonValue is not used in UNIQUE constraints
  for (final schema in schemas) {
    for (final table in schema.tables) {
      for (final uc in table.rowClass.uniqueConstraints) {
        final f = uc.fields.firstWhereOrNull(
          (f) => f.backingType == 'JsonValue',
        );
        if (f != null) {
          throw InvalidGenerationSource(
            'JsonValue field cannot be used in a `Unique` annotation',
            element: fieldToElement[f],
          );
        }
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
  Map<ParsedField, Element> fieldToElement,
) {
  log.info('Found schema "${cls.name}"');

  if (!cls.isAbstract || !cls.isFinal) {
    throw InvalidGenerationSource(
      'subclasses of `Schema` must be `abstract final`',
      element: cls,
    );
  }

  if (cls.methods.isNotEmpty) {
    throw InvalidGenerationSource(
      'subclasses of `Schema` cannot have methods',
      element: cls.methods.first,
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
    if (typeArgElement == null) {
      throw InvalidGenerationSource(
        'Unable to resolve T in `Table<T>` properties, may need to include it in the `build.yaml` sources',
        element: a,
      );
    }
    if (typeArgElement is! ClassElement) {
      throw InvalidGenerationSource(
        'T in `Table<T>` must be a subclass of `Row`',
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

    tables.add(
      ParsedTable(
        name: a.name!,
        documentation: a.documentationComment,
        rowClass: rowClassCache.putIfAbsent(
          typeArgElement,
          () => _parseRowClass(
            ctx,
            typeArgElement,
            foreignKeyToElement,
            fieldToElement,
          ),
        ),
      ),
    );
  }

  return ParsedSchema(name: cls.name!, tables: tables);
}

ParsedRowClass _parseRowClass(
  ParserContext ctx,
  ClassElement cls,
  Map<ParsedForeignKey, Element> foreignKeyToElement,
  Map<ParsedField, Element> fieldToElement,
) {
  log.info('Found row class "${cls.name}"');

  if (!cls.isAbstract || !cls.isFinal) {
    throw InvalidGenerationSource(
      'subclasses of `Row` must be `abstract final`',
      element: cls,
    );
  }

  if (cls.methods.isNotEmpty) {
    throw InvalidGenerationSource(
      'subclasses of `Row` cannot have methods',
      element: cls.methods.first,
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
        throw InvalidGenerationSource('Unsupported data-type', element: a);
      }
      final customDataType = aReturnTypeElement.allSupertypes
          .firstWhereOrNull(
            (e) => customDataTypeTypeChecker.isExactly(e.element),
          )
          ?.element;

      if (customDataType is! ClassElement) {
        throw InvalidGenerationSource('Unsupported data-type', element: a);
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
        final constructor = returnType.constructors.firstWhereOrNull(
          (c) => c.name == 'fromDatabase',
        );
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
        final constructorArgType = _tryGetColumnType(
          constructor.formalParameters.first.type,
        );
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
        throw InvalidGenerationSource('Unsupported data-type', element: a);
      }
    }

    // Check for AutoIncrement
    final autoIncrement = autoIncrementTypeChecker.hasAnnotationOf(a);
    if (autoIncrement && type != 'int') {
      throw InvalidGenerationSource(
        'AutoIncrement is only allowed for int fields',
        element: a,
      );
    }

    // Create the parsed field
    final field = ParsedField(
      name: a.name!,
      documentation: a.documentationComment,
      typeName: type!,
      isNullable: a.returnType.nullabilitySuffix != NullabilitySuffix.none,
      backingType: backingType,
      autoIncrement: autoIncrement,
      defaultValue: _parseDefaultValue(a, type),
      sqlOverrides: sqlOverrideTypeChecker.annotationsOf(a).map((annotation) {
        return SqlOverride(
          dialect: annotation.getField('dialect')?.toStringValue(),
          columnType: annotation.getField('columnType')?.toStringValue(),
        );
      }).toList(),
    );
    fieldToElement[field] = a;
    fields.add(field);
  }

  // Extract @Unique.field() annotations
  final uniqueConstraints = <ParsedUniqueConstraint>[];
  for (final a in cls.getters) {
    // Find the annotated field
    final field = fields.firstWhere((f) => f.name == a.name!);

    // Check for Unique.field annotation
    final uniques = uniqueTypeChecker.annotationsOf(a);
    if (uniques.length > 1) {
      throw InvalidGenerationSource(
        'Only one `Unique.field` annotation is allowed per field',
        element: a,
      );
    }
    if (uniques.isNotEmpty) {
      final u = uniques.first;
      final name = u.getField('_name')?.toStringValue() ?? field.name;
      final fields = u.getField('_fields')?.toListValue();
      if (fields != null) {
        throw InvalidGenerationSource(
          '`Unique()` cannot be used on fields, use `Unique.fields` instead',
          element: a,
        );
      }

      if (name != '-' && !isValidIdentifier(name)) {
        throw InvalidGenerationSource(
          '`Unique.field(name: "$name")`: name is not a valid Dart identifier',
          element: a,
        );
      }

      uniqueConstraints.add(ParsedUniqueConstraint(
        name: name == '-' ? null : name,
        fields: [field],
      ));
    }
  }

  // Extract @Unique annotations
  for (final a in uniqueTypeChecker.annotationsOfExact(cls)) {
    final name = a.getField('_name')?.toStringValue();
    final uniqueFields = a
        .getField('_fields')
        ?.toListValue()
        ?.map((v) => v.toStringValue()!)
        .toList();

    // Forbid use of Unique.field() on classes
    if (name == null || uniqueFields == null) {
      throw InvalidGenerationSource(
        '`Unique.field()` cannot be used on classes, use `Unique()` instead',
        element: cls,
      );
    }

    // Check name is valid, if present
    if (name != '-' && !isValidIdentifier(name)) {
      throw InvalidGenerationSource(
        '`Unique(name: "$name")`: name is not a valid Dart identifier',
        element: cls,
      );
    }

    if (uniqueFields.isEmpty) {
      throw InvalidGenerationSource(
        '`Unique()` annotation must have non-empty `fields`!',
        element: cls,
      );
    }

    // Throw exception, when [f] cannot be found
    Never throwUnknownField(String field) {
      throw InvalidGenerationSource(
        '`Unique()` annotation references unknown field "$field", '
        'no such field on row class "${cls.name}".',
        element: cls,
      );
    }

    uniqueConstraints.add(ParsedUniqueConstraint(
      name: name == '-' ? null : name,
      fields: uniqueFields.map((field) {
        return fields.firstWhere(
          (f) => f.name == field,
          orElse: () => throwUnknownField(field),
        );
      }).toList(),
    ));
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
      if (table == null || field == null || table.isEmpty || field.isEmpty) {
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
    if (field.backingType == 'JsonValue') {
      throw InvalidGenerationSource(
        'JsonValue field cannot be used in PrimaryKey annotation',
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
    uniqueConstraints: uniqueConstraints,
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
  } else if (jsonValueTypeChecker.isExactlyType(t)) {
    return 'JsonValue';
  }
  return null;
}

Never _throwInternalDefaultValue(Element field) =>
    throw InvalidGenerationSource(
      'Invalid DefaultValue annotation, internal invariant violated!',
      element: field,
    );

/// Parsed [DefaultValue] annotations from [field] with [type].
ParsedDefaultValue? _parseDefaultValue(Element field, String type) {
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
  final value_ = annotation.getField('_value');
  if (value_ == null) {
    throw _throwInternalDefaultValue(field);
  }

  final valueRecord = value_.toRecordValue();
  final kind = valueRecord?.named['kind']?.toStringValue();
  final value = valueRecord?.named['value'];
  if (kind == null || value == null) {
    _throwInternalDefaultValue(field);
  }

  if (kind == 'raw') {
    return _parseDefaultRawValue(field, type, value);
  }

  if (kind == 'datetime' && value.toStringValue() == 'epoch') {
    if (type != 'DateTime') {
      throw InvalidGenerationSource(
        '@DefaultValue.epoch is only allowed for DateTime fields',
        element: field,
      );
    }
    return ParsedDefaultDateTimeEpochValue();
  }

  if (kind == 'datetime' && value.toStringValue() == 'now') {
    if (type != 'DateTime') {
      throw InvalidGenerationSource(
        '@DefaultValue.now is only allowed for DateTime fields',
        element: field,
      );
    }
    return ParsedDefaultDateTimeNow();
  }

  if (kind == 'datetime') {
    return _parseDefaultDateTimeValue(field, type, value);
  }

  _throwInternalDefaultValue(field);
}

ParsedDefaultValue? _parseDefaultDateTimeValue(
  Element field,
  String type,
  DartObject value,
) {
  if (type != 'DateTime') {
    throw InvalidGenerationSource(
      '@DefaultValue.dateTime(...) is only allowed for DateTime fields',
      element: field,
    );
  }

  final args = value
      .toRecordValue()
      ?.positional
      .map((v) => v.toIntValue())
      .nonNulls
      .toList();
  if (args == null || args.length != 8) {
    _throwInternalDefaultValue(field);
  }

  return ParsedDefaultDateTimeValue(
    args[0],
    args[1],
    args[2],
    args[3],
    args[4],
    args[5],
    args[6],
    args[7],
  );
}

ParsedDefaultValue? _parseDefaultRawValue(
    Element field, String type, DartObject value) {
  final defaultValue = value.toBoolValue() ??
      value.toIntValue() ??
      value.toDoubleValue() ??
      value.toStringValue() ??
      value.toJsonValue();

  if (defaultValue == null) {
    throw InvalidGenerationSource(
      'Disallowed value in @DefaultValue(value) annotation. '
      'Only bool, int, double and String are allowed.',
      element: field,
    );
  }

  if (defaultValue is String) {
    if (type != 'String') {
      throw InvalidGenerationSource(
        '@DefaultValue(String) is only allowed for String fields',
        element: field,
      );
    }
    return ParsedDefaultStringValue(defaultValue);
  }

  if (defaultValue is bool) {
    if (type != 'bool') {
      throw InvalidGenerationSource(
        '@DefaultValue(bool) is only allowed for bool fields',
        element: field,
      );
    }
    return ParsedDefaultBoolValue(defaultValue);
  }

  if (defaultValue is int) {
    // Allow casting an int to a double (so long as it's safe)
    if (type == 'double') {
      // A double can represent integers precisely up to 2^53.
      if (defaultValue.abs() > 9007199254740991) {
        throw InvalidGenerationSource(
          '@DefaultValue(int) cannot be cast to double. '
          'A double can safely represent '
          'integers in the range [-(2^53 - 1), 2^53 - 1].',
          element: field,
        );
      }
      return ParsedDefaultDoubleValue(defaultValue.toDouble());
    }
    if (type != 'int') {
      throw InvalidGenerationSource(
        '@DefaultValue(int) is only allowed for int or double fields',
        element: field,
      );
    }
    return ParsedDefaultIntValue(defaultValue);
  }

  if (defaultValue is double) {
    if (type != 'double') {
      throw InvalidGenerationSource(
        '@DefaultValue(double) is only allowed for double fields',
        element: field,
      );
    }
    return ParsedDefaultDoubleValue(defaultValue);
  }

  if (defaultValue is JsonValue) {
    if (type != 'JsonValue') {
      throw InvalidGenerationSource(
        '@DefaultValue(JsonValue) is only allowed for JsonValue fields',
        element: field,
      );
    }
    return ParsedDefaultJsonValue(defaultValue);
  }

  _throwInternalDefaultValue(field);
}

bool isValidIdentifier(String id) =>
    RegExp(r'^[A-Za-z][A-Za-z0-9_]*$').hasMatch(id);

extension on DartObject {
  /// Return a [JsonValue] corresponding to the [JsonValue] being represented
  /// by this [DartObject], or `null` if:
  ///  * this object is not of type 'JsonValue',
  ///  * the value of the object being represented is not known, or
  ///  * the value of the object being represented is null.
  JsonValue? toJsonValue() {
    // Check if defaultValue is actually a JsonValue object
    final valueType = type;
    if (valueType == null || !jsonValueTypeChecker.isExactlyType(valueType)) {
      return null;
    }

    if (!hasKnownValue) {
      return null;
    }

    Object? decodeValue(DartObject v) {
      if (v.isNull) {
        return null;
      }
      if (v.toBoolValue() case final bool b) {
        return b;
      }
      if (v.toDoubleValue() case final double d) {
        return d;
      }
      if (v.toIntValue() case final int i) {
        return i;
      }
      if (v.toStringValue() case final String s) {
        return s;
      }
      if (v.toListValue() case final List<DartObject> l) {
        return l.map(decodeValue).toList();
      }
      if (v.toMapValue() case final Map<DartObject, DartObject> m) {
        return Map.fromEntries(m.entries.map((e) {
          final k = decodeValue(e.key);
          if (k is! String) {
            throw const FormatException('Expected String key');
          }
          return MapEntry(
            k,
            decodeValue(e.value),
          );
        }));
      }
      throw const FormatException('Invalid JSON value');
    }

    try {
      final v = getField('value');
      if (v == null) {
        return null;
      }
      return JsonValue(decodeValue(v));
    } on FormatException {
      return null;
    }
  }
}
