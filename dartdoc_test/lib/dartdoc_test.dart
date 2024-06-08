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

import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:dartdoc_test/src/resource.dart';

import 'src/extractor.dart';

class DartDocTest {
  const DartDocTest();

  Future<void> run() async {
    final rootFolder = Directory.current.absolute.path;
    final contextCollection = AnalysisContextCollection(
      includedPaths: [rootFolder],
      resourceProvider: PhysicalResourceProvider.INSTANCE,
    );

    final ctx = contextCollection.contextFor(rootFolder);
    final session = ctx.currentSession;

    // TODO: add `include` and `exclude` options
    final files = Directory(rootFolder)
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'))
        .toList();
    for (final file in files) {
      final result = session.getParsedUnit(file.path);
      if (result is ParsedUnitResult) {
        final comments = extractDocumentationComments(result);
        for (final c in comments) {
          final samples = extractCodeSamples(c);
          for (final s in samples) {
            print(s.comment.span.start.toolString);
            print(s.code);
          }
          writeCodeSamples(file.path, samples);
        }
      }
    }
  }

  Future<void> runAnalyze() async {}
}

String wrapCode(String path, String code) {
  return '''
import "$path";

void main() {
  $code
}
''';
}

void writeCodeSamples(String filePath, List<DocumentationCodeSample> samples) {
  for (final (i, s) in samples.indexed) {
    final path = filePath.replaceAll('.dart', '_sample_$i.dart');
    final code = wrapCode(filePath, s.code);
    resourceProvider.setOverlay(path, content: code, modificationStamp: 0);
  }
}
