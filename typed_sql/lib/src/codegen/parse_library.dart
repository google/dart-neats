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
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart' show log;
import 'package:collection/collection.dart';
import 'package:source_gen/source_gen.dart';

import 'parsed_library.dart';

final _typedSqlSrcUri = Uri.parse('package:typed_sql/src/typed_sql.dart');

final _schemaTypeChecker = TypeChecker.fromUrl(
  _typedSqlSrcUri.resolve('#Schema'),
);
final _modelTypeChecker = TypeChecker.fromUrl(
  _typedSqlSrcUri.resolve('#Model'),
);
final _tableTypeChecker = TypeChecker.fromUrl(
  _typedSqlSrcUri.resolve('#Table'),
);
final _uniqueTypeChecker = TypeChecker.fromUrl(
  _typedSqlSrcUri.resolve('#Unique'),
);
final _primaryKeyTypeChecker = TypeChecker.fromUrl(
  _typedSqlSrcUri.resolve('#PrimaryKey'),
);

final _dateTimeTypeChecker = TypeChecker.fromUrl('dart:core#DateTime');

Future<ParsedLibrary> parseLibrary(LibraryReader library) async {
  // Cache models when parsing, this saves time, but more importantly ensures
  // that we can use identity equivalence on ParsedModel objects.
  final modelCache = <ClassElement, ParsedModel>{};

  final schemas = library.classes
      .where((cls) {
        final supertype = cls.supertype;
        return supertype != null && _schemaTypeChecker.isExactlyType(supertype);
      })
      .map((cls) => _parseSchema(cls, modelCache))
      .toList();

  final models = library.classes
      .where((cls) {
        final supertype = cls.supertype;
        return supertype != null && _modelTypeChecker.isExactlyType(supertype);
      })
      .map((cls) => modelCache.putIfAbsent(cls, () => _parseModel(cls)))
      .toList();

  return ParsedLibrary(
    schemas: schemas,
    models: models,
  );
}

ParsedSchema _parseSchema(
  ClassElement cls,
  Map<ClassElement, ParsedModel> modelCache,
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
        !_tableTypeChecker.isExactly(returnTypeElement)) {
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
        !_modelTypeChecker.isExactlyType(typeArgSupertype)) {
      throw InvalidGenerationSource(
        'T in `Table<T>` must be a subclass of `Model`',
        element: a,
      );
    }

    tables.add(ParsedTable(
      name: a.name,
      model: modelCache.putIfAbsent(
        typeArgElement,
        () => _parseModel(typeArgElement),
      ),
    ));
  }

  return ParsedSchema(
    name: cls.name,
    tables: tables,
  );
}

ParsedModel _parseModel(ClassElement cls) {
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
    } else if (_dateTimeTypeChecker.isExactlyType(returnType)) {
      type = 'DateTime';
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

    fields.add(ParsedField(
      name: a.name,
      type: type,
      // TODO: Support Unique(given: [...])
      unique: _uniqueTypeChecker.hasAnnotationOf(a),
    ));
  }
  // Check number of fields, as we're using a 64 bit integer as (bitfield) to
  // track fields are fetched, we can't have more than 64 fields in a row!
  if (fields.length > 64) {
    throw InvalidGenerationSource(
      'subclasses of `Model` can at-most have 64 fields',
      element: cls,
    );
  }

  // Extract primary key!
  final pks = _primaryKeyTypeChecker.annotationsOfExact(cls);
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

  return ParsedModel(
    name: cls.name,
    primaryKey: primaryKey,
    fields: fields,
  );
}
