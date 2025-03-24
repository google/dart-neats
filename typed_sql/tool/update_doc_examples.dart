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

// Search markdown files, we can add support for doc comments in dart files later!

// TODO: Split this into a separate package
// TODO: Make a dry-run variant
// TODO: Don't update files not checked into git
// TODO: Make a verifyDocExamplesSynced for tests
// TODO: Output list of unused regions
// TODO: Support examples in dartdoc comments!
// TODO: Detect #region without matching #endregion
// TODO: Detect mispelled "#  region" / "#  endregion" or just support it!
// TODO: Configure exclude directories, like doc/api/

import 'dart:io';
import 'dart:isolate';

import 'package:collection/collection.dart';
import 'package:glob/glob.dart';

final _exclude = [
  Glob('doc/api/**'),
];

void main() {
  final rootUri = Isolate.resolvePackageUriSync(Uri.parse('package:typed_sql/'))
      ?.resolve('../');
  if (rootUri == null) {
    print('Cannot resolve package:typed_sql/');
    exit(1);
  }
  final dotDartTool = rootUri.resolve('.dart_tool/').toFilePath();

  final allFiles = Directory.fromUri(rootUri)
      .listSync(recursive: true, followLinks: false)
      .whereType<File>()
      .where((f) => !f.uri.toFilePath().startsWith(dotDartTool))
      .toList();

  final allMarkdownFiles =
      allFiles.where((f) => f.path.endsWith('.md')).toList();
  final allDartFiles = allFiles.where((f) => f.path.endsWith('.dart')).toList();

  print('Finding regions:');
  final regions = allDartFiles.expand((dartFile) {
    return regionPattern.allMatches(dartFile.readAsStringSync()).map((m) => (
          file:
              dartFile.uri.toFilePath().substring(rootUri.toFilePath().length),
          regionId: m.group(1)!.trim(),
          content: trimLines(m.group(2)!),
        ));
  }).toList();

  final filesWithRegions = regions.map((r) => r.file).toSet().sorted();
  for (final f in filesWithRegions) {
    print('- $f:');
    for (final r in regions.where((r) => r.file == f)) {
      print('    #${r.regionId}');
    }
  }
  print('');

  final usedRegions = <({String file, String regionId, String content})>{};

  print('Updating markdown files:');
  for (final mdFile in allMarkdownFiles) {
    final mdFilePath =
        mdFile.uri.toFilePath().substring(rootUri.toFilePath().length);
    if (_exclude.any((g) => g.matches(mdFilePath))) {
      continue;
    }

    final mdContent = mdFile.readAsStringSync();
    final update = mdContent.splitMapJoin(referencePattern, onMatch: (m) {
      final line = m.group(1)!;
      final file = m.group(2)!;
      final regionId = m.group(3)!;

      final candidateRegions = regions
          .where((r) => r.regionId == regionId && r.file.endsWith(file))
          .toList();

      if (candidateRegions.isEmpty) {
        throw Exception('No region for "$file#$regionId" in "$mdFilePath"');
      }
      if (candidateRegions.length > 1) {
        throw Exception(
          [
            'Multiple regions for "$file#$regionId" in "$mdFilePath":',
            ...candidateRegions.map((r) => '  ${r.file}#${r.regionId}'),
          ].join('\n'),
        );
      }
      final region = candidateRegions.first;
      usedRegions.add(region);
      return '$line\n${region.content}\n```';
    });

    if (mdContent != update) {
      print('- Updated $mdFilePath');
      mdFile.writeAsStringSync(update);
    } else {
      print('- No update for $mdFilePath');
    }
  }

  print('');
  final unusedRegions = regions.whereNot(usedRegions.contains).toList();
  if (unusedRegions.isNotEmpty) {
    print('Unused regions:');
    for (final r in unusedRegions) {
      print('- ${r.file}#${r.regionId}');
    }
  } else {
    print('No unused regions!');
  }
}

/// Trim whitespace at the start of lines in [content]
String trimLines(String content) {
  final indentation = content
      .split('\n')
      .where((line) => line.contains(RegExp(r'[^ \t]')))
      .map(
        (line) => line.indexOf(RegExp(r'[^ ]')),
      )
      .min;
  return content
      .split('\n')
      .map((line) => line.substring(switch (indentation) {
            -1 => 0,
            int i when (i < line.length) => i,
            int _ => line.length,
          }))
      .join('\n');
}

final referencePattern = RegExp(
  r'^(```dart[ \t]+([a-zA-Z0-9_.-]+\.dart)#([a-zA-Z0-9_.-]+))$(?:.(?!^```$))*\n^```$',
  multiLine: true,
  dotAll: true,
);

final regionPattern = RegExp(
  r'^[ \t]*//[ \t]*#region[ \t]+([a-zA-Z0-9_.-]+)[ \t]*$\n((?:.(?!^[ \t]*//[ \t]*#endregion[ \t]*$))*)\n^[ \t]*//[ \t]*#endregion[ \t]*$',
  multiLine: true,
  dotAll: true,
);
