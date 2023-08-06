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

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/file_system/file_system.dart';
import 'package:analyzer/file_system/overlay_file_system.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:collection/collection.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:pubspec_parse/pubspec_parse.dart';

import '../common.dart'
    show LanguageVersionCompatibilityExt, fail, PackageSchemeExt;
import '../pubapi.dart';
import 'shapes.dart';

typedef LibraryMemberShapeModification = ({
  LibraryMemberShape prev,
  LibraryMemberShape next,
});

typedef LibraryShapeChange = ({
  List<LibraryMemberShape> added,
  List<LibraryMemberShape> removed,
  List<LibraryMemberShapeModification> modified,
});

LibraryShapeChange diffLibraryShapes(LibraryShape prev, LibraryShape next) {
  final prevMembers = prev.exportedShapes;
  final nextMembers = next.exportedShapes;

  final prevMemberNames = prevMembers.keys.toSet();
  final nextMemberNames = nextMembers.keys.toSet();

  return (
    added: nextMembers.entries
        .where((m) => !prevMemberNames.contains(m.key))
        .map((m) => m.value)
        .toList(),
    removed: prevMembers.entries
        .where((m) => !nextMemberNames.contains(m.key))
        .map((m) => m.value)
        .toList(),
    modified: prevMembers.entries
        .where((m) =>
            nextMemberNames.contains(m.key) && m.value != nextMembers[m.key]!)
        .map((m) => (
              prev: m.value,
              next: nextMembers[m.key]!,
            ))
        .toList(),
  );
}

const _usage = '''Usage:
- analyze.dart local <package-path>
- analyze.dart hosted <package-name>''';
const _commands = ['local', 'hosted'];

Future<void> main(List<String> args) async {
  if (args.length != 2 || !_commands.contains(args[0])) {
    print(_usage);
    return;
  }

  if (args[0] == _commands[0]) {
    final packagePath = Directory.current.uri.resolve(args[1]);
    final packageShape = await analyzePackage(packagePath.toFilePath());
    print(JsonEncoder.withIndent('  ')
        .convert(packageShape.toJsonNormalPublicSummary()));
  } else if (args[0] == _commands[1]) {
    await PubApi.withApi((api) async {
      final t = args[1];
      final info = await api.listVersions(t);
      // Sort versions in ascending order.
      final versions = info.versions.sortedByCompare(
        (pv) => pv.version,
        (a, b) => a.compareTo(b),
      );

      PackageShape? prevShape;
      for (final pv in versions) {
        if (!pv.pubspec.dart3Compatible) {
          continue;
        }

        final files = await api.fetchPackage(pv.archiveUrl);
        final packagePath = '/pkg';
        final fs = OverlayResourceProvider(PhysicalResourceProvider.INSTANCE);
        for (final f in files) {
          fs.setOverlay(
            '$packagePath/${f.path}',
            content: utf8.decode(f.bytes, allowMalformed: true),
            modificationStamp: 0,
          );
        }
        final lv = pv.pubspec.languageVersion;
        fs.setOverlay(
          '$packagePath/.dart_tool/package_config.json',
          content: json.encode({
            'configVersion': 2,
            'packages': [
              {
                'name': pv.pubspec.name,
                'rootUri': packagePath,
                'packageUri': 'lib/',
                'languageVersion': '${lv.major}.${lv.minor}'
              }
            ],
            'generated': DateTime.now().toUtc().toIso8601String(),
            'generator': 'pub',
            'generatorVersion': '3.0.5'
          }),
          modificationStamp: 0,
        );

        final packageShape = await analyzePackage(packagePath, fs: fs);

        if (prevShape != null) {
          final libraryChanges = <Uri, LibraryShapeChange>{};

          // TODO: handle libraries that have been added or removed between package versions.
          final commonPublicLibraries = packageShape.libraries.entries
              .map((e) => e.key)
              .where((l) => prevShape!.libraries.containsKey(l))
              .where((l) => !l.isInPrivateLibrary);
          for (final libraryKey in commonPublicLibraries) {
            final change = diffLibraryShapes(
              prevShape.libraries[libraryKey]!,
              packageShape.libraries[libraryKey]!,
            );
            if (change.added.isNotEmpty ||
                change.removed.isNotEmpty ||
                change.modified.isNotEmpty) {
              assert(!libraryChanges.containsKey(libraryKey));
              libraryChanges[libraryKey] = change;
            }
          }

          if (libraryChanges.isNotEmpty) {
            print(
                '====== ${packageShape.name}: ${prevShape.version.toString()} -> ${packageShape.version.toString()} ======');
            for (final change in libraryChanges.entries) {
              print('  ${change.key.toString()}');
              if (change.value.added.isNotEmpty) {
                print('    ADDED:');
              }
              for (final addedLibrary in change.value.added) {
                print('     - ${jsonEncode(addedLibrary.toJson())}');
              }
              if (change.value.removed.isNotEmpty) {
                print('    REMOVED:');
              }
              for (final removedLibrary in change.value.removed) {
                print('     - ${jsonEncode(removedLibrary.toJson())}');
              }
              if (change.value.modified.isNotEmpty) {
                print('    MODIFIED:');
              }
              for (final modifiedLibrary in change.value.modified) {
                print('     - ${jsonEncode(modifiedLibrary.prev.toJson())}');
                print('       ->');
                print('       ${jsonEncode(modifiedLibrary.next.toJson())}');
              }
            }
          }
        }

        prevShape = packageShape;
      }
    });
  } else {
    throw StateError('Unknown command.');
  }
}

Future<PackageShape> analyzePackage(
  String packagePath, {
  ResourceProvider? fs,
}) async {
  final collection = AnalysisContextCollection(
    includedPaths: [packagePath],
    resourceProvider: fs,
  );
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
      fail('Failed to parse "$u"');
    }

    package.addLibrary(library);
  }

  // Mark the defined functions as exported.
  for (final lib in package.libraries.values) {
    assert(lib.exports.isEmpty);
    lib.exportedShapes.addEntries(
        lib.definedShapes.entries.whereNot((e) => e.value.isPrivate));
  }

  // Propogate all exports
  bool changed;
  do {
    changed = false;
    for (final lib in package.libraries.values) {
      changed = changed || package.propagateExports(lib);
    }
  } while (changed);
  return package;
}

extension on PackageShape {
  void addLibrary(ParsedLibraryResult library) {
    final libraryUnit = library.units.where((u) => u.isLibrary).firstOrNull;
    if (libraryUnit == null) {
      fail('Could not find libraryUnit for $library');
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

  // TODO: is the opposite of 'transitive export', 'direct export'?
  /// Iterate over the direct exports of this library and merge the set of
  /// exported shapes of those libraries into this one.
  /// Returns [true] if the shape of [library] has been changed as a result.
  bool propagateExports(LibraryShape library) {
    var changed = false;
    for (final exportEntry in library.exports.entries) {
      final exportedLibrary = libraries[exportEntry.key];
      if (exportedLibrary == null) {
        // TODO: In this case, consider the shapes of the dependencies of this package.
        print(
            'The library ${exportEntry.key.toString()} appears in an export, but it does not exist in the definition of this package');
        continue;
      }
      final exportFilter = exportEntry.value;

      // The symbols made available by this direct export. Note that despite the
      // fact that the export is direct, [propagateExports] may have been already
      // called on the exported library, so these symbols are not necessarily ones
      // which have been defined in the exported library.
      // TODO: maybe instead of `bool isVisible(String symbol)` we could have `List<String> visibleSymbols(List<String> symbols)` to reflect the common use of a method of this kind?
      final exportedSymbols = exportedLibrary.exportedShapes.entries
          .where((e) => exportFilter.isVisible(e.key));

      // If two non-identical symbols are exported under the same name but are not
      // defined in this library, we cannot continue.
      for (final symbol in exportedSymbols) {
        if (library.definedShapes.containsKey(symbol.key)) {
          // The current library defines a symbol with this name, which shadows any imported symbol.
          continue;
        } else if (library.exportedShapes.containsKey(symbol.key) &&
            library.exportedShapes[symbol.key]! != symbol.value) {
          // A symbol sharing the same name, but with a different shape, is exported in this library, which is a compile error.
          fail(
              'Two symbols found to be exported with the same name ${symbol.key}, but different shapes.');
        } else if (library.exportedShapes.containsKey(symbol.key)) {
          // A symbol with the same name and shape is already exported.
          continue;
        }
        library.exportedShapes[symbol.key] = symbol.value;
        changed = true;
      }
    }
    return changed;
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
      name: d.name.lexeme,
      namedParameters: parameters
          .where((p) => p.isNamed)
          .map((p) => NamedParameterShape(
              name: p.name!.lexeme, isRequired: p.isRequired))
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
        fail('Unnamed variable $v');
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
      fail('${shape.name} is defined more than once!');
    }
    definedShapes[shape.name] = shape;
  }
}

extension on NamedCompilationUnitMember {
  String get nameAsString {
    final n = name.value();
    if (n is! String) {
      fail('Top-level member has no name: $this');
    }
    return n;
  }
}

extension on NodeList<SimpleIdentifier> {
  Set<String> toStringSet() => map((i) => i.name).toSet();
}
