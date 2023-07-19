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

/// Intermediate data-structures for collection of data from an unresolved AST
/// inorder to eventually produce a `PackageOutline`.
library;

import 'package:pub_semver/pub_semver.dart';

class PackageShape {
  final String name;
  final Version version;
  final Map<Uri, LibraryShape> libraries = {};

  PackageShape({
    required this.name,
    required this.version,
  });
}

class LibraryShape {
  final Uri uri;

  /// Map from prefix to map from imported [Uri] to namespace filter applied.
  ///
  /// The empty prefix / key points to libraries imported without any prefix.
  final Map<String, Map<Uri, NamespaceFilter>> imports = {};
  final Map<Uri, NamespaceFilter> exports = {};

  /// Top-level elements defined in this library.
  final Map<String, LibraryMemberShape> definedShapes = {};

  /// Top-level elements exported from this library.
  ///
  /// This includes all shapes exported from `export` statements pointing to
  /// other libraries in this package.
  final Map<String, LibraryMemberShape> exportedShapes = {};

  /// Top-level elements imported into this library.
  ///
  /// For prefixed imports the key will include the prefix.
  /// This includes all shapes imported from `import` statements pointing to
  /// other libaries in this package.
  final Map<String, LibraryMemberShape> importedShapes = {};

  LibraryShape({required this.uri});
}

/// A filter on an imported namespace in the form of `show ... hide ...`.
sealed class NamespaceFilter {
  NamespaceFilter();

  /// A filter that shows everything in a namespace.
  ///
  /// In other words a [NamespaceHideFilter] that doesn't hide anything.
  factory NamespaceFilter.everything() => NamespaceHideFilter({});

  /// Apply a further filter.
  NamespaceFilter applyFilter(NamespaceFilter other);

  /// Is [symbol] visible once this filter is applied?
  bool isVisible(String symbol);

  /// `true`, if this filter is known to be empty.
  ///
  /// The filter might be empty when applied against a set of known symbols.
  /// This is only true, if it's trivial to determine that the filter is empty.
  bool get isTriviallyEmpty;
}

/// Filter on an imported/exported namespace on the form `show foo, bar, ...`
final class NamespaceShowFilter extends NamespaceFilter {
  final Set<String> show;

  NamespaceShowFilter(this.show);

  @override
  NamespaceFilter applyFilter(NamespaceFilter other) {
    switch (other) {
      case NamespaceShowFilter other:
        return NamespaceShowFilter(show.intersection(other.show));

      case NamespaceHideFilter other:
        return NamespaceShowFilter(show.difference(other.hide));
    }
  }

  @override
  bool isVisible(String symbol) => show.contains(symbol);

  @override
  bool get isTriviallyEmpty => show.isEmpty;
}

/// Filter on an imported/exported namespace on the form `hide foo, bar, ...`
final class NamespaceHideFilter extends NamespaceFilter {
  final Set<String> hide;

  NamespaceHideFilter(this.hide);

  @override
  NamespaceFilter applyFilter(NamespaceFilter other) {
    switch (other) {
      case NamespaceShowFilter other:
        return NamespaceShowFilter(other.show.difference(hide));

      case NamespaceHideFilter other:
        return NamespaceHideFilter(hide.union(other.hide));
    }
  }

  @override
  bool isVisible(String symbol) => !hide.contains(symbol);

  @override
  bool get isTriviallyEmpty => false;
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

extension LibraryMemberShapeGetters on LibraryMemberShape {
  bool get isPrivate => name.startsWith('_');
}
