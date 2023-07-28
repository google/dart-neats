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
import 'dart:io' show Directory, IOException, gzip;
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/file_system/memory_file_system.dart';
import 'package:analyzer/file_system/overlay_file_system.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:async/async.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';
import 'package:tar/tar.dart';
import 'shapes.dart';

Future<void> main(List<String> args) async {
  /*
  if (args.length != 1) {
    print('Usage: analyze.dart <target>');
    return;
  }

  final packagePath = Directory.current.uri.resolve(args.first);
  await analyzePackage(packagePath.toFilePath());
  */
  final t = Stopwatch()..start();
  await analyzePackage('retry', '3.0.0');
  print('fetch + analysis: ${t.elapsedMilliseconds} ms\n');

  t.reset();
  await analyzePackage('retry', '3.1.0');
  print('fetch + analysis: ${t.elapsedMilliseconds} ms\n');

  t.reset();
  await analyzePackage('retry', '3.1.1');
  print('fetch + analysis: ${t.elapsedMilliseconds} ms\n');

  t.reset();
  await analyzePackage('retry', '3.1.2');
  print('fetch + analysis: ${t.elapsedMilliseconds} ms\n');
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

final _pubHostedUrl = Uri.parse('https://pub.dev/');

Future<PackageShape> analyzePackage(String packageName, String version) async {
  print('fetch $packageName version $version');
  final pkgUri = _pubHostedUrl.resolve(
    'packages/$packageName/versions/$version.tar.gz',
  );
  final pkgGzip = await retry(
    () => http.readBytes(pkgUri).timeout(Duration(seconds: 30)),
    retryIf: (e) => e is TimeoutException || e is IOException,
  );
  final pkgBytes = gzip.decode(pkgGzip);

  final fs = OverlayResourceProvider(PhysicalResourceProvider.INSTANCE);

  await TarReader.forEach(Stream.value(pkgBytes), (entry) async {
    if (entry.type == TypeFlag.reg) {
      fs.setOverlay(
        '/pkg/${entry.name}',
        content: utf8.decode(await collectBytes(entry.contents)),
        modificationStamp: 0,
      );
    }
  });
  fs.setOverlay(
    '/pkg/.dart_tool/package_config.json',
    content: json.encode({
      "configVersion": 2,
      "packages": [
        {
          "name": packageName,
          "rootUri": "/pkg",
          "packageUri": "lib/",
          "languageVersion": "3.0"
        }
      ],
      "generated": "2023-07-28T09:37:20.214485Z",
      "generator": "pub",
      "generatorVersion": "3.0.5"
    }),
    modificationStamp: 0,
  );

  final sw = Stopwatch()..start();
  final packagePath = '/pkg';
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
  final consumedLibraries = <Uri>{};
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
            package.topLevelNames.add(name);
          }

        case TopLevelVariableDeclaration d:
          for (final v in d.variables.variables) {
            final name = v.name.value();
            if (name is String && !name.startsWith('_')) {
              package.topLevelNames.add(name);
            }
          }
      }
    }
  }
  print('analysis took: ${sw.elapsedMilliseconds} ms');
  print(package.toJson());
  return package;
}

extension on Uri {
  /// True, if this [Uri] points to a resource in [package].
  bool isInPackage(String package) =>
      isScheme('package') && pathSegments.firstOrNull == package;
}
