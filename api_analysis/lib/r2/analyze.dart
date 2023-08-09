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

/// Extraction of a PackageShape using only AST analysis.
library;

import 'dart:io' show Directory;
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:collection/collection.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'shapes.dart';

Future<void> main(List<String> args) async {
  if (args.length != 1) {
    print('Usage: analyze.dart <target>');
    return;
  }

  final packagePath = Directory.current.uri.resolve(args.first);
  await analyzePackage(packagePath.toFilePath());
}

/// Thrown when shape analysis fails.
///
/// This typically happens because the Dart code being analyzed is invalid, or
/// because the analysis is unable to handle the code in question.
class ShapeAnalysisException implements Exception {
  final String message;
  ShapeAnalysisException._(this.message);

  @override
  String toString() => message;
}

Never _fail(String message) => throw ShapeAnalysisException._(message);

Future<PackageShape> analyzePackage(String packagePath) async {
  final collection = AnalysisContextCollection(includedPaths: [packagePath]);
  final context = collection.contextFor(packagePath);
  final session = context.currentSession;

  final pubspecFile =
      session.resourceProvider.getFile('$packagePath/pubspec.yaml');
  final pubspec = Pubspec.parse(
    pubspecFile.readAsStringSync(),
    lenient: true,
    sourceUrl: pubspecFile.toUri(),
  );

  final package = PackageShape(
    name: pubspec.name,
    version: pubspec.version ?? Version(0, 0, 0),
  );

  // Add all libraries to the PackageShape
  for (final f in context.contextRoot.analyzedFiles()) {
    final u = session.uriConverter.pathToUri(f);
    if (u == null ||
        !u.isInPackage(package.name) ||
        !u.path.endsWith('.dart')) {
      continue;
    }
    final library = session.getParsedLibrary(f);
    if (library is! ParsedLibraryResult) {
      _fail('Failed to parse "$u"');
    }

    package.addLibrary(library);
  }

  // Initiate exportedBy with all directly exported libraries
  for (final library in package.libraries.values) {
    for (final exportedLibraryUri in library.exports.keys) {
      final exportedLibrary = package.libraries[exportedLibraryUri];
      if (exportedLibrary == null) {
        continue;
      }
      exportedLibrary.exportedBy.add(library);
    }
  }

  void propogateExports(LibraryShape library) {
    var changed = false;
    library.exports.forEach((exportUri, exportFilter) {
      // Find the exportLibrary that is exported from library
      final exportLibrary = package.libraries[exportUri];
      if (exportLibrary == null) {
        return;
      }

      // Everything exported by exportLibrary is also exported from library,
      // but obviously only when the exportFilter is applied to futher restrict
      // what is visible.
      final propogatedExports = exportLibrary.exports.entries.map(
        (e) => (e.key, e.value.applyFilter(exportFilter)),
      );

      for (final (uri, filter) in propogatedExports) {
        library.exports.update(
          uri,
          (existingFilter) {
            // If we have an existing filter, then we're already exporting this
            // library, but the filter might have changed, so we should merge it
            final updatedFilter = existingFilter.mergeFilter(filter);
            // Notice that .mergeFilter will always return the [existingFilter]
            // if the two filters are equal, so eventually [changed] won't be
            // true, and recursion should stop.
            changed = changed || updatedFilter != existingFilter;
            return updatedFilter;
          },
          ifAbsent: () {
            // If [uri] is not already in our exports, then we've found a new
            // library that is being transitively exported.
            changed = true;
            // Update exportedBy on the library we're now exporting
            final exportedLibrary = package.libraries[uri];
            if (exportedLibrary != null) {
              exportedLibrary.exportedBy.add(library);
            }
            return filter;
          },
        );
      }
    });

    // If we changed something then we'll update all libraries that this library
    // is exportedBy. This leads to recursion, with a little luck this will
    // never enter infinite recursion because [changed] will eventually be false
    if (changed) {
      for (final exportingLibrary in library.exportedBy) {
        propogateExports(exportingLibrary);
      }
    }
  }

  // Propogate exports for all libraries
  package.libraries.values.forEach(propogateExports);

  // Populate exportedShapes for all libraries
  for (final library in package.libraries.values) {
    // All defined non-private shapes are exported
    library.exportedShapes.addEntries(
      library.definedShapes.entries.where((e) => !e.value.isPrivate),
    );

    // Transtive exported shapes, using `null` to indicate that we have
    // conflicting names.
    final transitivelyExportedShapes = <String, LibraryMemberShape?>{};
    library.exports.forEach((uri, filter) {
      final exportedLibrary = package.libraries[uri];
      if (exportedLibrary == null) {
        return;
      }
      for (final shape in exportedLibrary.definedShapes.values) {
        // Ignore shapes where:
        //  - name indicates that it's private,
        //  - it's not visible through the export filter,
        //  - the library defines a shape with the same name!
        if (shape.isPrivate ||
            !filter.isVisible(shape.name) ||
            library.definedShapes.containsKey(shape.name)) {
          continue;
        }
        transitivelyExportedShapes.update(
          shape.name,
          (existingShape) {
            // If the existing shape exported here is the exact same shape, then
            // that's fine. Otherwise, if we have to export statements that try
            // to transitively export the same thing, then we have a conflict.
            // We indicate conflicts by storing `null`.
            // Note: we intentionally use identity equality, since if the exact
            //       same member is defined twice, it's still a conflict!
            if (existingShape == shape) {
              return existingShape;
            }
            return null;
          },
          // If there is nothing exported with this name, then clearly there is
          // no conflict, and we just insert [shape].
          ifAbsent: () => shape,
        );
      }
    });

    // Add all the transitive exported shapes.
    // Ignore the values that are null, because these are used to indicated
    // transitive export conflicts.
    library.exportedShapes.addEntries(
      transitivelyExportedShapes.values
          .whereNotNull()
          .map((shape) => MapEntry(shape.name, shape)),
    );
  }

  return package;
}

extension on PackageShape {
  void addLibrary(ParsedLibraryResult library) {
    final libraryUnit = library.units.where((u) => u.isLibrary).firstOrNull;
    if (libraryUnit == null) {
      _fail('Could not find libraryUnit for $library');
    }
    // Find the URI for this library
    final uri = libraryUnit.uri;

    // Check if library shape has been added before, this can happen if a
    // library has multiple parts.
    if (libraries[uri] != null) {
      return;
    }

    final shape = libraries[uri] = LibraryShape(uri: uri);

    // Extract import / export statements
    for (final d in library.units.expand((u) => u.unit.directives)) {
      switch (d) {
        case ExportDirective d:
          shape.addExport(d);

        case ImportDirective d:
          shape.addImport(d);

        case LibraryDirective():
        case PartDirective() || PartOfDirective():
        case AugmentationImportDirective() || LibraryAugmentationDirective():
      }
    }

    // Find all top-level declarations
    for (final d in library.units.expand((u) => u.unit.declarations)) {
      switch (d) {
        case FunctionDeclaration d:
          if (d.isGetter || d.isSetter) {
            if (shape.definedShapes.containsKey(d.nameAsString)) {
              continue; // we've seen the other getter or setter already
              // TODO: Check that the other thing we saw was a getter/setter!
            }
            final accessors = library.units
                .expand((u) => u.unit.declarations)
                .whereType<FunctionDeclaration>()
                .where((dOther) => d.nameAsString == dOther.nameAsString);
            shape.define(VariableShape(
              name: d.nameAsString,
              hasGetter: accessors.any((a) => a.isGetter),
              hasSetter: accessors.any((a) => a.isSetter),
            ));
          } else {
            shape.defineFunction(d);
          }

        case EnumDeclaration d:
          shape.defineEnum(d);

        case ClassDeclaration d:
          shape.defineClass(d);

        case MixinDeclaration d:
          shape.defineMixin(d);

        case ExtensionDeclaration d:
          shape.defineExtension(d);

        case ClassTypeAlias d:
          shape.defineClassTypeAlias(d);

        case FunctionTypeAlias d:
          shape.defineFunctionTypeAlias(d);

        case TopLevelVariableDeclaration d:
          shape.defineTopLevelVariable(d);
      }
    }
  }
}

extension on LibraryShape {
  void addExport(ExportDirective d) {
    final u = uri.resolve(d.uri.stringValue!);
    final filter = d.combinators.fold(
      NamespaceFilter.everything(),
      (f, c) => f.applyFilter(switch (c) {
        (ShowCombinator c) => NamespaceShowFilter(c.shownNames.toStringSet()),
        (HideCombinator c) => NamespaceHideFilter(c.hiddenNames.toStringSet()),
      }),
    );

    exports.update(u, (f) => f.mergeFilter(filter), ifAbsent: () => filter);
  }

  void addImport(ImportDirective d) {
    final u = uri.resolve(d.uri.stringValue!);
    final filter = d.combinators.fold(
      NamespaceFilter.everything(),
      (f, c) => f.applyFilter(switch (c) {
        (ShowCombinator c) => NamespaceShowFilter(c.shownNames.toStringSet()),
        (HideCombinator c) => NamespaceHideFilter(c.hiddenNames.toStringSet()),
      }),
    );
    final prefix = d.prefix?.name ?? '';
    imports
        .putIfAbsent(prefix, () => {})
        .update(u, (f) => f.mergeFilter(filter), ifAbsent: () => filter);
  }

  void defineFunction(FunctionDeclaration d) {
    assert(!d.isGetter && !d.isSetter);
    final parameters = d.functionExpression.parameters!.parameters;
    define(FunctionShape(
      name: d.nameAsString,
      namedParameters: parameters
          .where((p) => p.isNamed)
          .map((p) => NamedParameterShape(
              name: p.name!.value() as String, isRequired: p.isRequired))
          .toList(),
      positionalParameters: parameters
          .where((p) => p.isPositional)
          .map((p) => PositionalParameterShape(isOptional: p.isOptional))
          .toList(),
    ));
  }

  void defineEnum(EnumDeclaration d) {
    define(EnumShape(
      name: d.nameAsString,
    ));
  }

  void defineClass(ClassDeclaration d) {
    define(ClassShape(
      name: d.nameAsString,
    ));
  }

  void defineMixin(MixinDeclaration d) {
    define(MixinShape(
      name: d.nameAsString,
    ));
  }

  void defineExtension(ExtensionDeclaration d) {
    final name = d.name?.stringValue;
    // Ignore unnamed extensions they are not exported, and they cannot
    // influence the existence of other names.
    if (name != null) {
      define(ExtensionShape(
        name: name,
      ));
    }
  }

  void defineClassTypeAlias(ClassTypeAlias d) {
    define(ClassTypeAliasShape(
      name: d.nameAsString,
    ));
  }

  void defineFunctionTypeAlias(FunctionTypeAlias d) {
    define(FunctionTypeAliasShape(
      name: d.nameAsString,
    ));
  }

  void defineTopLevelVariable(TopLevelVariableDeclaration d) {
    for (final v in d.variables.variables) {
      final name = v.name.value();
      if (name is! String) {
        throw _fail('Unnamed variable $v');
      }
      define(VariableShape(
        name: name,
        hasGetter: true,
        hasSetter: !d.variables.isConst && !d.variables.isFinal,
      ));
    }
  }

  void define(LibraryMemberShape shape) {
    if (definedShapes.containsKey(shape.name)) {
      _fail('${shape.name} is defined more than once!');
    }
    definedShapes[shape.name] = shape;
  }
}

extension on NamedCompilationUnitMember {
  String get nameAsString {
    final n = name.value();
    if (n is! String) {
      _fail('Top-level member has no name: $this');
    }
    return n;
  }
}

extension on NodeList<SimpleIdentifier> {
  Set<String> toStringSet() => map((i) => i.name).toSet();
}

extension on Uri {
  /// True, if this [Uri] points to a resource in [package].
  bool isInPackage(String package) =>
      isScheme('package') && pathSegments.firstOrNull == package;
}
