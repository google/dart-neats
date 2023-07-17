// Copyright 2023 Google LLC
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

import 'package:pub_semver/pub_semver.dart';

class PackageShape {
  final String name;
  final Version version;
  final Set<LibraryShape> libraries = {};

  PackageShape({
    required this.name,
    required this.version,
  });
}

class LibraryShape {
  final Uri uri;
  final List<ImportShape> imports = [];
  final List<ExportShape> exports = [];

  final Set<FunctionShape> functions = {};
  final Set<EnumShape> enums = {};
  final Set<ClassShape> classes = {};
  final Set<MixinShape> mixins = {};
  final Set<ExtensionShape> extensions = {};
  final Set<FunctionTypeAliasShape> functionTypeAliases = {};
  final Set<ClassTypeAliasShape> classTypeAliases = {};
  final Set<VariableShape> variables = {};

  LibraryShape({required this.uri});
}

final class NamespaceShape {
  bool get showAll => show == null;
  final Set<String>? show;
  final Set<String> hide;

  NamespaceShape({required this.show, required this.hide});
}

final class ImportShape {
  final Uri uri;
  final String? prefix;
  final Set<String> show;
  final Set<String> hide;

  /// Library being imported, null if unresolved.
  LibraryShape? library;

  ImportShape({
    required this.uri,
    required this.prefix,
    required this.show,
    required this.hide,
  });
}

final class ExportShape {
  final Uri uri;
  final Set<String> show;
  final Set<String> hide;

  /// Library being exported, null if unresolved.
  LibraryShape? library;

  ExportShape({
    required this.uri,
    required this.show,
    required this.hide,
  });
}

sealed class LibraryMemberShape {
  final String name;

  LibraryMemberShape({
    required this.name,
  });
}

final class FunctionShape extends LibraryMemberShape {
  final List<PositionalParameterShape> positionalParameters;
  final List<NamedParameterShape> namedParameters;

  FunctionShape({
    required super.name,
    required this.positionalParameters,
    required this.namedParameters,
  });
}

final class EnumShape extends LibraryMemberShape {
  EnumShape({required super.name});
}

final class ClassShape extends LibraryMemberShape {
  ClassShape({required super.name});
}

final class MixinShape extends LibraryMemberShape {
  MixinShape({required super.name});
}

final class ExtensionShape extends LibraryMemberShape {
  ExtensionShape({required super.name});
}

final class FunctionTypeAliasShape extends LibraryMemberShape {
  FunctionTypeAliasShape({required super.name});
}

final class ClassTypeAliasShape extends LibraryMemberShape {
  ClassTypeAliasShape({required super.name});
}

final class VariableShape extends LibraryMemberShape {
  final bool hasGetter;
  final bool hasSetter;

  VariableShape({
    required super.name,
    required this.hasGetter,
    required this.hasSetter,
  });
}

final class PositionalParameterShape {
  final bool isOptional;

  PositionalParameterShape({
    required this.isOptional,
  });
}

final class NamedParameterShape {
  final String name;
  final bool isRequired;

  NamedParameterShape({
    required this.name,
    required this.isRequired,
  });
}

extension PackageShapeGetters on PackageShape {
  LibraryShape? operator [](Uri uri) =>
      libraries.where((lib) => lib.uri == uri).firstOrNull;
}

extension LibraryShapeGetters on LibraryShape {
  Set<LibraryMemberShape> get members => {
        ...functions,
        ...enums,
        ...classes,
        ...mixins,
        ...extensions,
        ...functionTypeAliases,
        ...classTypeAliases,
        ...variables,
      };

  LibraryMemberShape? operator [](String name) =>
      members.where((m) => m.name == name).firstOrNull;
}

extension LibraryMemberShapeGetters on LibraryMemberShape {
  bool get isPrivate => name.startsWith('_');
}
