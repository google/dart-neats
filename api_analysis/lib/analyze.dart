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

  // Resolve library on all import/exports
  for (final lib in package.libraries) {
    for (final import in lib.imports) {
      if (import.uri.isInPackage(package.name)) {
        import.library = package[import.uri];
        if (import.library == null) {
          _fail('Unable to resolve import ${import.uri}');
        }
      }
    }
    for (final export in lib.exports) {
      if (export.uri.isInPackage(package.name)) {
        export.library = package[export.uri];
        if (export.library == null) {
          _fail('Unable to resolve export ${export.uri}');
        }
      }
    }
  }

  // Propogate all exports
  for (final lib in package.libraries) {
    for (final e in lib.exports) {
      // TODO: Continue here
      print(e.uri);
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

    // Check if library shape has been added before, this can happen if a
    // library has multiple parts.
    if (libraries.any((lib) => lib.uri == libraryUnit.uri)) {
      return;
    }

    final shape = LibraryShape(uri: libraryUnit.uri);
    libraries.add(shape);

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
            if (shape[name] == null) {
              return; // we've seen the other getter or setter already
            }
            final accessors = library.units
                .expand((u) => u.unit.declarations)
                .whereType<FunctionDeclaration>()
                .where((d) => d.name.value() == name);
            shape.variables.add(VariableShape(
              name: name,
              hasGetter: accessors.any((d) => d.isGetter),
              hasSetter: accessors.any((d) => d.isSetter),
            ));
          } else {
            shape.addFunction(d);
          }

        case EnumDeclaration d:
          shape.addEnum(d);

        case ClassDeclaration d:
          shape.addClass(d);

        case MixinDeclaration d:
          shape.addMixin(d);

        case ExtensionDeclaration d:
          shape.addExtension(d);

        case ClassTypeAlias d:
          shape.addClassTypeAlias(d);

        case FunctionTypeAlias d:
          shape.addFunctionTypeAlias(d);

        case TopLevelVariableDeclaration d:
          shape.addTopLevelVariable(d);
      }
    }

    // TODO: Sanity check we don't have two things with the same name, this
    // shouldn't be possible in valid Dart code. But who knows, maybe it's not
    // valid code. In either case, we should print a warning.
  }

  void propogateExports(LibraryShape library) {
    for (final lib in libraries) {
      lib.exports.where((e) => e.uri == library.uri);
      // TODO: Finish this...
    }
  }
}

extension on LibraryShape {
  void addExport(ExportDirective d) {
    // TODO: merge all export directives for the same uri!
    // TODO: Fix the shownNames and hiddenNames, this interpretation is wrong!
    // TODO: Also fix this for Imports...
    final e = ExportShape(
      uri: uri.resolve(d.uri.stringValue!),
      show: d.shownNames,
      hide: d.hiddenNames,
    );
    final ee = exports.where((e) => e.uri == e.uri).firstOrNull;
    exports.add(ee == null ? e : ee.merge(e));
  }

  void addImport(ImportDirective d) {
    imports.add(ImportShape(
      uri: uri.resolve(d.uri.stringValue!),
      prefix: d.prefix?.name,
      show: d.shownNames,
      hide: d.hiddenNames,
    ));
  }

  void addFunction(FunctionDeclaration d) {
    assert(!d.isGetter && !d.isSetter);
    final parameters = d.functionExpression.parameters!.parameters;
    functions.add(FunctionShape(
      name: d.nameAsString,
      namedParameters: parameters
          .where((p) => p.isNamed)
          .map((p) => NamedParameterShape(
              name: p.name!.stringValue!, isRequired: p.isRequired))
          .toList(),
      positionalParameters: parameters
          .where((p) => p.isPositional)
          .map((p) => PositionalParameterShape(isOptional: p.isOptional))
          .toList(),
    ));
  }

  void addEnum(EnumDeclaration d) {
    enums.add(EnumShape(
      name: d.nameAsString,
    ));
  }

  void addClass(ClassDeclaration d) {
    classes.add(ClassShape(
      name: d.nameAsString,
    ));
  }

  void addMixin(MixinDeclaration d) {
    mixins.add(MixinShape(
      name: d.nameAsString,
    ));
  }

  void addExtension(ExtensionDeclaration d) {
    final name = d.name?.stringValue;
    // Ignore unnamed extensions they are not exported, and they cannot
    // influence the existence of other names.
    if (name != null) {
      extensions.add(ExtensionShape(
        name: name,
      ));
    }
  }

  void addClassTypeAlias(ClassTypeAlias d) {
    classTypeAliases.add(ClassTypeAliasShape(
      name: d.nameAsString,
    ));
  }

  void addFunctionTypeAlias(FunctionTypeAlias d) {
    functionTypeAliases.add(FunctionTypeAliasShape(
      name: d.nameAsString,
    ));
  }

  void addTopLevelVariable(TopLevelVariableDeclaration d) {
    for (final v in d.variables.variables) {
      final name = v.name.value();
      if (name is! String) {
        throw _fail('Unnamed variable $v');
      }
      variables.add(VariableShape(
        name: name,
        hasGetter: true,
        hasSetter: !d.variables.isConst && !d.variables.isFinal,
      ));
    }
  }
}

extension on ExportShape {
  /// Create a new [ExportShape] by merging [other] with this [ExportShape].
  ExportShape merge(ExportShape other) {
    throw UnimplementedError('TODO');
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

extension on NamespaceDirective {
  Set<String> get shownNames => combinators
      .whereType<ShowCombinator>()
      .expand((c) => c.shownNames.map((i) => i.name))
      .toSet();

  Set<String> get hiddenNames => combinators
      .whereType<HideCombinator>()
      .expand((c) => c.hiddenNames.map((i) => i.name))
      .toSet();
}

extension on Uri {
  /// True, if this [Uri] points to a resource in [package].
  bool isInPackage(String package) =>
      isScheme('package') && pathSegments.firstOrNull == package;
}
