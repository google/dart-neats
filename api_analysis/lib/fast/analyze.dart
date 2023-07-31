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
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/file_system/overlay_file_system.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:api_analysis/pubapi.dart';
import 'package:collection/collection.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'shapes.dart';

final _targets = [
  'retry',
  'path',
  'http',
];

extension on Pubspec {
  Version get languageVersion {
    final sdk = (environment ?? {})['sdk'];
    if (sdk is VersionRange) {
      final min = sdk.min ?? Version(0, 0, 0);
      return Version(min.major, min.minor, 0);
    }
    // Note: Techincally there are other options
    return Version(0, 0, 0);
  }

  bool get dart3Compatible => languageVersion >= Version(2, 12, 0);
}

Future<void> main(List<String> args) async {
  await PubApi.withApi((api) async {
    for (final t in _targets) {
      final info = await api.listVersions(t);
      // Sort to lowest version first
      final versions = info.versions.sortedByCompare(
        (pv) => pv.version,
        (a, b) => a.compareTo(b),
      );

      bool isFirst = true;
      final since = <String, String>{};
      for (final pv in versions) {
        if (!pv.pubspec.dart3Compatible) {
          continue;
        }

        final files = await api.fetchPackage(pv.archiveUrl);
        final shape = await analyzePackage((
          name: pv.pubspec.name,
          version: pv.version,
          pubspec: pv.pubspec,
          files: files,
        ));
        print('package:${info.name}-${pv.version}');
        //print(shape.topLevelNames);

        // Use empty string for the first version, just to ignore things that
        // are straight up boring...
        final v = isFirst ? '' : pv.version.toString();
        isFirst = false;
        for (final n in shape.topLevelNames) {
          since.putIfAbsent(n, () => v);
        }
      }

      print('# $t');
      since.forEach((key, value) {
        if (value.isNotEmpty) {
          print(key.padRight(25) + value.toString());
        }
      });
    }
  });

  /*
  if (args.length != 1) {
    print('Usage: analyze.dart <target>');
    return;
  }
*/
}

typedef AnalysisTarget = ({
  String name,
  Version version,
  Pubspec pubspec,
  List<FileEntry> files,
});

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

Future<PackageShape> analyzePackage(AnalysisTarget target) async {
  final fs = OverlayResourceProvider(PhysicalResourceProvider.INSTANCE);
  for (final f in target.files) {
    fs.setOverlay(
      '/pkg/${f.path}',
      content: utf8.decode(f.bytes, allowMalformed: true),
      modificationStamp: 0,
    );
  }
  final lv = target.pubspec.languageVersion;
  fs.setOverlay(
    '/pkg/.dart_tool/package_config.json',
    content: json.encode({
      'configVersion': 2,
      'packages': [
        {
          'name': target.name,
          'rootUri': '/pkg',
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

  final packagePath = '/pkg';
  final collection = AnalysisContextCollection(
    includedPaths: [packagePath],
    resourceProvider: fs,
  );
  final context = collection.contextFor(packagePath);
  final session = context.currentSession;

  final shape = PackageShape(
    name: target.pubspec.name,
    version: target.version,
  );

  // Add all libraries to the PackageShape
  final consumedLibraries = <Uri>{};
  for (final f in context.contextRoot.analyzedFiles()) {
    final u = session.uriConverter.pathToUri(f);
    if (u == null || !u.isInPackage(shape.name) || !u.path.endsWith('.dart')) {
      continue;
    }
    final library = session.getParsedLibrary(f);
    if (library is! ParsedLibraryResult) {
      _fail('Failed to parse "$u"');
    }
    final libraryUnit = library.units.where((u) => u.isLibrary).firstOrNull;
    if (libraryUnit == null) {
      _fail('Could not find libraryUnit for $library');
    }
    // Ignore libraries we've seen before
    if (!consumedLibraries.add(libraryUnit.uri)) {
      continue;
    }

    for (final d in library.units.expand((u) => u.unit.declarations)) {
      switch (d) {
        case NamedCompilationUnitMember d:
          final name = d.name.lexeme;
          if (!name.startsWith('_')) {
            shape.topLevelNames.add(name);
          }

        case TopLevelVariableDeclaration d:
          for (final v in d.variables.variables) {
            final name = v.name.value();
            if (name is String && !name.startsWith('_')) {
              shape.topLevelNames.add(name);
            }
          }
      }
    }
  }
  return shape;
}

extension on Uri {
  /// True, if this [Uri] points to a resource in [package].
  bool isInPackage(String package) =>
      isScheme('package') && pathSegments.firstOrNull == package;
}
