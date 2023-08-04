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

  // Propogate all exports
  var changed = true;
  // Iterate until there are no changes, this is probably not the fastest way to
  // do this!
  while (changed) {
    changed = false;
    for (final library in package.libraries.values) {
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
          final existingFilter = library.exports[uri];
          if (existingFilter != null) {
            library.exports[uri] = existingFilter.mergeFilter(filter);
            // This works because `applyFilter` and `mergeFilter` will return
            // the existing filter if there are no changes.
            // Hence, eventually calling `mergeFilter` will just return
            // `existingFilter`.
            // TODO: This might require a proof, or something like that. It's
            //       not entirely trivially obivous.
            // TODO: We could also build a tree of filters such that each filter
            //       object have a map to larger filter objects. Effectively,
            //       we'd have some sort of interning. That would be extremely
            //       fast, but we'd be unable to free memory. That's probably
            //       not an issue as we could release it when we're done with
            //       the analysis :D
            //       Imagine that NamespaceShowFilter is a linked list, that
            //       always starts with the empty list. And is always
            //       alphabetically sorted. Then the set {A, B} would get the
            //       same node as {B, A}. Obviously, each node would have to
            //       know which possible successors exists.
            //       So NamespaceShowFilter would have properties:
            //         * final String symbol
            //         * final NamespaceShowFilter? previous
            //         * final Map<String, NamespaceShowFilter> next
            //       Given a NamespaceShowFilter object, you'd read [symbol] and
            //       walk along [previous] until `previous == null`.
            //       And if you have an NamespaceShowFilter object and want to
            //       extend it to also show the symbol "foo", then you'd walk
            //       up [previous] until you see `symbol < "foo"` at which point
            //       you'd check `next["foo"]` to see if a node already exists
            //       and if not, create one under there + all the ones necessary
            //       to represent the full set.
            //       Or something like that, the idea being that there is a
            //       only ever a single [NamespaceShowFilter] representing a
            //       single set, a system where two distint filter objects
            //       always imply different show sets.
            //       Probably not performance critical, but could be fun to
            //       build :D
            if (library.exports[uri] != existingFilter) {
              changed = true;
            }
          } else {
            library.exports[uri] = filter;
            changed = true;
          }
          library.exports.update(
            uri,
            (existingFilter) => existingFilter.mergeFilter(filter),
            ifAbsent: () => filter,
          );
        }
        // TODO: Track if anything changed! :D
      });
    }

    for (final MapEntry(key: eu, value: ef) in library.exports.entries) {
      final exportedLibrary = package.libraries[u];
      if (exportedLibrary == null) {
        continue;
      }
      // Everything exported from exportedLibrary is also exported from library
      for (final MapEntry(key: u, value: f) in library.exports.entries) {
        library.exports.update(
          u,
          (existingFilter) => existingFilter.mergeFilter(f.applyFilter(ef)),
          ifAbsent: () => f.applyFilter(ef),
        );
      }
    }

    for (final MapEntry(key: eu, value: ef) in library.exports.entries) {
      final exportedLibrary = package.libraries[u];
      if (exportedLibrary == null) {
        continue;
      }
      // Everything exported from exportedLibrary is also exported from library
      for (final MapEntry(key: u, value: f) in library.exports.entries) {
        library.exports.update(
          u,
          (existingFilter) => existingFilter.mergeFilter(f.applyFilter(ef)),
          ifAbsent: () => f.applyFilter(ef),
        );
      }
    }
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
