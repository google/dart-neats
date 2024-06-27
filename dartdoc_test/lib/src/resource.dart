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

import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:analyzer/file_system/overlay_file_system.dart';
import 'package:path/path.dart' as p;
import 'package:source_span/source_span.dart';

import 'extractor.dart';

const _testPath = '.dartdoc_test';

final currentDir = Directory.current;

/// Directory to store generated code samples
final testDir = Directory(p.join(currentDir.path, _testPath));

/// Context for running tests.
/// manage [resourceProvider].
class DartDocTestContext {
  DartDocTestContext() {
    _resourceProvider = OverlayResourceProvider(
      PhysicalResourceProvider.INSTANCE,
    );
    _contextCollection = AnalysisContextCollection(
      includedPaths: [currentDir.absolute.path],
      resourceProvider: _resourceProvider,
    );
    _context = _contextCollection.contextFor(currentDir.absolute.path);
  }

  late final OverlayResourceProvider _resourceProvider;
  late final AnalysisContextCollection _contextCollection;
  late final AnalysisContext _context;
  final _files = <CodeSampleFile>{};

  Set<CodeSampleFile> get codeSampleFiles => _files;
  AnalysisContext get context => _context;

  void _writeFile(String path, DocumentationCodeSample sample) {
    // write for new file
    // final file = _resourceProvider.getFile(path);
    // file.writeAsStringSync(content);
    final content = sample.wrappedCode;
    _resourceProvider.setOverlay(
      path,
      content: sample.wrappedCode,
      modificationStamp: 0,
    );
    final sourceFile = SourceFile.fromString(content, url: Uri.parse(path));
    _files.add(CodeSampleFile(
      path: path,
      sourceFile: sourceFile,
      sample: sample,
    ));
  }

  List<String> getSamplesFilePath() {
    final files = _resourceProvider
        .getFolder(testDir.path)
        .getChildren()
        .map((e) => e.path)
        .toList();
    return files;
  }

  void writeCodeSamples(
    String filePath,
    List<DocumentationCodeSample> samples,
  ) {
    for (final (i, s) in samples.indexed) {
      final fileName =
          p.basename(filePath).replaceFirst('.dart', '_sample_$i.dart');
      final path = p.join(testDir.absolute.path, fileName);
      _writeFile(path, s);
    }
  }
}

List<File> getFilesFrom(Directory dir) {
  // TODO: add `include` and `exclude` options
  final files = dir
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'))
      .toList();
  return files;
}

class CodeSampleFile {
  final String path;
  final SourceFile sourceFile;
  final DocumentationCodeSample sample;

  CodeSampleFile({
    required this.path,
    required this.sourceFile,
    required this.sample,
  });
}
