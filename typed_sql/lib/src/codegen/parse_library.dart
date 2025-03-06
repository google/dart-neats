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

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart' show log;
import 'package:collection/collection.dart';
import 'package:source_gen/source_gen.dart';

import 'parsed_library.dart';
import 'type_checkers.dart';

Future<ParsedLibrary> parseLibrary(LibraryReader targetLibrary) async {
  // Cache models when parsing, this saves time, but more importantly ensures
  // that we can use identity equivalence on ParsedModel objects.
  final modelCache = <ClassElement, ParsedModel>{};

  // We maintain maps to elements so we can make better errors later!
  final schemaToElement = <ParsedSchema, ClassElement>{};
  final foreignKeyToElement = <ParsedForeignKey, Element>{};

  final schemas = targetLibrary.classes.where((cls) {
    final supertype = cls.supertype;
    return supertype != null && schemaTypeChecker.isExactlyType(supertype);
  }).map((cls) {
    final s = _parseSchema(cls, modelCache, foreignKeyToElement);
    schemaToElement[s] = cls;
    return s;
  }).toList();

  final models = targetLibrary.classes.where((cls) {
    final supertype = cls.supertype;
    return supertype != null && modelTypeChecker.isExactlyType(supertype);
  }).map((cls) {
    return modelCache.putIfAbsent(
      cls,
      () => _parseModel(cls, foreignKeyToElement),
    );
  }).toList();

  // At this point we only support one schema per library.
  if (schemas.length > 1) {
    throw InvalidGenerationSource(
      'Only one Schema per library is a allowed!',
      element: schemaToElement[schemas[1]],
    );
  }

  final library = ParsedLibrary(
    schemas: schemas,
    models: models,
  );

  // We only allow a Model subclass to be used for one table!
  final allTables = schemas.expand((s) => s.tables);
  for (final schema in schemas) {
    for (final table in schema.tables) {
      if (allTables.any((t) => t != table && t.model == table.model)) {
        throw InvalidGenerationSource(
          'Model subclass "${table.model.name}" is used in more than one table!',
          element:
              modelCache.entries.firstWhere((e) => e.value == table.model).key,
        );
      }
    }
  }

  for (final schema in schemas) {
    for (final table in schema.tables) {
      for (final fk in table.model.foreignKeys) {
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

        // Resolve referencedField
        final referencedField = referencedTable.model.fields.firstWhereOrNull(
          (f) => f.name == fk.field,
        );
        if (referencedField == null) {
          throw InvalidGenerationSource(
            'Foreign key references unknown field "${fk.field}"',
            element: foreignKeyToElement[fk],
          );
        }
        fk.referencedField = referencedField;
      }
    }
  }

  return library;
}

ParsedSchema _parseSchema(
  ClassElement cls,
  Map<ClassElement, ParsedModel> modelCache,
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

  if (!cls.fields.any((f) => f.getter != null)) {
    throw InvalidGenerationSource(
      'subclasses of `Schema` cannot have fields or setters',
      element: cls.fields.first,
    );
  }

  final tables = <ParsedTable>[];
  for (final a in cls.accessors) {
    if (a.isSetter) {
      throw InvalidGenerationSource(
        'subclasses of `Schema` cannot have setters',
        element: a,
      );
    }
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
        !modelTypeChecker.isExactlyType(typeArgSupertype)) {
      throw InvalidGenerationSource(
        'T in `Table<T>` must be a subclass of `Model`',
        element: a,
      );
    }

    tables.add(ParsedTable(
      name: a.name,
      model: modelCache.putIfAbsent(
        typeArgElement,
        () => _parseModel(typeArgElement, foreignKeyToElement),
      ),
    ));
  }

  return ParsedSchema(
    name: cls.name,
    tables: tables,
  );
}

ParsedModel _parseModel(
  ClassElement cls,
  Map<ParsedForeignKey, Element> foreignKeyToElement,
) {
  log.info('Found model "${cls.name}"');

  if (!cls.isAbstract || !cls.isFinal) {
    throw InvalidGenerationSource(
      'subclasses of `Model` must be `abstract final`',
      element: cls,
    );
  }

  if (cls.methods.isNotEmpty) {
    throw InvalidGenerationSource('subclasses of `Model` cannot have methods',
        element: cls.methods.first);
  }

  if (!cls.fields.any((f) => f.getter != null)) {
    throw InvalidGenerationSource(
      'subclasses of `Model` cannot have fields or setters',
      element: cls.fields.first,
    );
  }

  // Find parsed fields
  final fields = <ParsedField>[];
  for (final a in cls.accessors) {
    if (a.isSetter) {
      throw InvalidGenerationSource(
        'subclasses of `Model` cannot have setters',
        element: a,
      );
    }
    if (!a.isAbstract) {
      throw InvalidGenerationSource(
        'subclasses of `Model` can only abstract getters',
        element: a,
      );
    }

    final String type;
    final returnType = a.returnType;
    if (returnType.isDartCoreBool) {
      type = 'bool';
    } else if (returnType.isDartCoreString) {
      type = 'String';
    } else if (returnType.isDartCoreDouble) {
      type = 'double';
    } else if (returnType.isDartCoreInt) {
      type = 'int';
    } else if (dateTimeTypeChecker.isExactlyType(returnType)) {
      type = 'DateTime';
    } else if (uint8ListTypeChecker.isExactlyType(returnType)) {
      type = 'Uint8List';
    } else {
      // TODO: Add support for dart:typed_data fields
      // TODO: Add support custom types (maybe using extension methods!)
      // TODO: Consider support for Duration
      // TODO: Consider support for List, Set, Map, Record (probably not)
      // TODO: Consider support for enums
      throw InvalidGenerationSource(
        'Unsupported data-type',
        element: a,
      );
    }

    final autoIncrement = autoIncrementTypeChecker.hasAnnotationOf(a);
    if (autoIncrement && type != 'int') {
      throw InvalidGenerationSource(
        'AutoIncrement is only allowed for int fields',
        element: a,
      );
    }

    final field = ParsedField(
      name: a.name,
      typeName: type,
      isNullable: returnType.nullabilitySuffix != NullabilitySuffix.none,
      // TODO: Support Unique(given: [...])
      unique: uniqueTypeChecker.hasAnnotationOf(a),
      autoIncrement: autoIncrement,
      defaultValue: _parseDefaultValue(a, type),
    );
    fields.add(field);
  }
  // Check number of fields, as we're using a 64 bit integer as (bitfield) to
  // track fields are fetched, we can't have more than 64 fields in a row!
  if (fields.length > 64) {
    throw InvalidGenerationSource(
      'subclasses of `Model` can at-most have 64 fields',
      element: cls,
    );
  }

  // Extract @References annotations
  final foreignKeys = <ParsedForeignKey>[];
  for (final a in cls.accessors) {
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
        key: fields.firstWhere((f) => f.name == key),
        table: table,
        field: field,
        as: as,
        name: name,
      );
      foreignKeyToElement[fk] = a;
      foreignKeys.add(fk);
    }
  }

  // Extract primary key!
  final pks = primaryKeyTypeChecker.annotationsOfExact(cls);
  if (pks.isEmpty || pks.length > 1) {
    throw InvalidGenerationSource(
      'subclasses of `Model` must have one `PrimaryKey` annotation',
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
      'subclasses of `Model` must have a non-empty `PrimaryKey` annotation',
      element: cls,
    );
  }
  if (primaryKey.length != primaryKey.toSet().length) {
    throw InvalidGenerationSource(
      'subclasses of `Model` cannot have duplicate fields in `PrimaryKey`',
      element: cls,
    );
  }
  if (primaryKey.any((f) => f.isNullable)) {
    throw InvalidGenerationSource(
      'PrimaryKey fields cannot be nullable',
      element: cls,
    );
  }

  return ParsedModel(
    name: cls.name,
    primaryKey: primaryKey,
    fields: fields,
    foreignKeys: foreignKeys,
  );
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
