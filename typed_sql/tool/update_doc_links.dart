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

/// Category documentation in `doc/` cannot have `[MyClass]` style-links to
/// things in dartdoc. Nor can they link to other categories.
///
/// This tool adds and updates a bunch of `[<identifier>]: <url>` lines to the
/// bottom of these markdown files, such that it's easy to make such lines.
library;

import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:collection/collection.dart';
import 'package:markdown/markdown.dart';

final _marker = '<!-- GENERATED DOCUMENTATION LINKS -->';

void main() async {
  final rootUri = Isolate.resolvePackageUriSync(Uri.parse('package:typed_sql/'))
      ?.resolve('../');
  if (rootUri == null) {
    print('Cannot resolve package:typed_sql/');
    exit(1);
  }

  final indexFile = File.fromUri(rootUri.resolve('doc/api/index.json'));

  if (!await indexFile.exists()) {
    print('# Running dartdoc');
    final dartdoc = await Process.start(
      Platform.executable,
      ['doc'],
      includeParentEnvironment: true,
      workingDirectory: rootUri.toFilePath(),
    );
    await Future.wait([
      dartdoc.exitCode,
      stdout.addStream(dartdoc.stdout),
      stderr.addStream(dartdoc.stderr),
    ]);
    if ((await dartdoc.exitCode) != 0) {
      print('dartdoc failed');
      exit(1);
    }
    print('# Finished dartdoc');
  }

  final indexJson = json.decode(await indexFile.readAsString()) as List;
  final index = indexJson
      .whereType<Map<String, Object?>>()
      .map((e) => (
            name: e['name'] as String,
            qualifiedName: e['qualifiedName'] as String,
            href: e['href'] as String,
          ))
      .toList();

  final markdownFiles = Directory.fromUri(rootUri.resolve('doc'))
      .listSync(recursive: false, followLinks: false)
      .whereType<File>()
      .where((f) => f.path.endsWith('.md'))
      .toList()
      .sortedBy((f) => f.path);

  for (final mdFile in markdownFiles) {
    print('# ${mdFile.path.substring(rootUri.toFilePath().length)}');
    final content = await mdFile.readAsString();
    final parts = content.split(_marker);
    if (parts.length == 1) {
      print('- Missing marker!');
      exit(1);
    }
    if (parts.length > 2) {
      print('- Multiple marker!');
      exit(1);
    }
    final md = parts[0];
    final oldRefs = parts[1];
    final contentAfterMarker = oldRefs
        .split('\n')
        .where((line) =>
            line.isNotEmpty &&
            !RegExp(r'^\s*$').hasMatch(line) &&
            !RegExp(r'^\[[A-Za-z0-9_ .-]+\]: .+$').hasMatch(line))
        .join('\n');
    if (contentAfterMarker.isNotEmpty) {
      print('- Contains content after marker!');
      print(contentAfterMarker);
      exit(1);
    }

    // Collect unresolved references
    final unresolvedLinks = <String>{};
    final parser = Document(
        extensionSet: ExtensionSet.gitHubWeb,
        linkResolver: (name, [String? title]) {
          unresolvedLinks.add(name);
          return null;
        });
    parser.parse(md);

    final references = <String, String>{};
    for (final ref in unresolvedLinks.sorted()) {
      final candidates = index
          .where((e) =>
              // Ignore empty references
              ref.isNotEmpty &&
              // If name = qualifiedName it's probably a category
              ((e.name == e.qualifiedName && e.qualifiedName == ref) ||
                  // If it contains a dot and not equal to qualified name, then
                  // skip the first dot and compare to qualified name!
                  (e.name != e.qualifiedName &&
                      e.qualifiedName.contains('.') &&
                      e.qualifiedName.split('.').skip(1).join('.') == ref)))
          .toList();
      if (candidates.isEmpty && ref.isNotEmpty) {
        // we only look at named constructors if we have no other matches!
        candidates.addAll(index.where((e) {
          if (e.name == e.qualifiedName) {
            return false; // ignore categories
          }
          final parts = e.qualifiedName.split('.');
          if (parts.length < 4) {
            return false;
          }
          // only named constructors!
          if (parts[1] != parts[2]) {
            return false;
          }
          return parts.skip(2).join('.') == ref;
        }));
      }

      if (candidates.isEmpty) {
        print('  [$ref]: Could not be resolved!');
        exit(1);
      }
      if (candidates.length > 1) {
        print('  [$ref]: Ambigious resolution, options:');
        for (final c in candidates) {
          print('- ${c.qualifiedName}: ${c.href}');
        }
        exit(1);
      }
      if (candidates.length == 1) {
        final link = candidates.first;
        final target = Uri.parse('..').resolve(link.href).toString();
        print('  [$ref]: $target');
        references[ref] = target;
      }
    }

    if (references.isEmpty) {
      await mdFile.writeAsString('$md$_marker\n');
      continue;
    }

    final newRefs = references.entries
        .sortedBy((e) => e.key)
        .map((e) => '[${e.key}]: ${e.value}')
        .join('\n');

    await mdFile.writeAsString('$md$_marker\n$newRefs\n');
  }

  print('# Successfully updated documentation links');
}
