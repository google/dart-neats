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

import 'dartdoc_test.dart';
import 'extractor.dart';

const _testPath = '.dartdoc_test';

final currentDir = Directory.current;

/// Context for running tests.
/// manage [resourceProvider].
class DartdocTestContext {
  DartdocTestContext(this.options) {
    _resourceProvider = OverlayResourceProvider(
      PhysicalResourceProvider.INSTANCE,
    );
    _contextCollection = AnalysisContextCollection(
      includedPaths: [currentDir.path],
      resourceProvider: _resourceProvider,
    );

    _testDir = Directory(p.join(currentDir.path, options.out ?? _testPath));

    if (options.write) {
      if (_testDir.existsSync()) {
        _testDir.deleteSync(recursive: true);
      }
      _testDir.createSync();
    }

    _context = _contextCollection.contextFor(currentDir.path);
  }

  final DartdocTestOptions options;

  late final OverlayResourceProvider _resourceProvider;
  late final AnalysisContextCollection _contextCollection;
  late final AnalysisContext _context;

  /// Directory to store generated code samples
  late final Directory _testDir;

  final _files = <CodeSampleFile>{};

  Set<CodeSampleFile> get codeSampleFiles =>
      _files.where((f) => !f.sample.ignore).toSet();
  AnalysisContext get context => _context;

  void _writeFile(String path, DocumentationCodeSample sample) {
    final content = sample.wrappedCode(_testDir);
    if (options.write) {
      // write for new file
      final file = _resourceProvider.getFile(path);
      file.writeAsStringSync(content);
    } else {
      _resourceProvider.setOverlay(
        path,
        content: content,
        modificationStamp: 0,
      );
    }
    final sourceFile = SourceFile.fromString(content, url: Uri.file(path));
    _files.add(CodeSampleFile(
      path: path,
      sourceFile: sourceFile,
      sample: sample,
    ));
  }

  void writeCodeSamples(
    String filePath,
    List<DocumentationCodeSample> samples,
  ) {
    for (final (i, s) in samples.indexed) {
      final fileName = p.basename(filePath).replaceFirst('.dart', '_$i.dart');
      final path = p.join(_testDir.path, fileName);
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
