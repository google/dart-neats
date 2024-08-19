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
import 'model.dart';

const _testPath = '.dartdoc_test';

final _currentDir = Directory.current;

/// Context for running dartdoc_test
///
/// It manages [OverlayResourceProvider] and [context] to provide a way to
/// generate code samples and analyze the code. and also have [codeSampleFiles]
/// that contains all generated code samples file.
class DartdocTestContext {
  /// Create a [DartdocTestContext] with [options].
  DartdocTestContext(this.options) {
    _resourceProvider = OverlayResourceProvider(
      PhysicalResourceProvider.INSTANCE,
    );
    _contextCollection = AnalysisContextCollection(
      includedPaths: [_currentDir.path],
      resourceProvider: _resourceProvider,
    );

    _testDir = Directory(p.join(_currentDir.path, options.out ?? _testPath));

    if (options.write) {
      if (_testDir.existsSync()) {
        _testDir.deleteSync(recursive: true);
      }
      _testDir.createSync();
    }

    _context = _contextCollection.contextFor(_currentDir.path);
  }

  /// Options for running dartdoc_test
  final DartdocTestOptions options;

  late final OverlayResourceProvider _resourceProvider;
  late final AnalysisContextCollection _contextCollection;
  late final AnalysisContext _context;

  /// Directory to store generated code samples
  late final Directory _testDir;

  final _files = <CodeSampleFile>{};

  /// Analysis context for the current directory
  AnalysisContext get context => _context;

  /// The generated code samples files that are not excluded with `no-test` tag.
  Set<CodeSampleFile> get codeSampleFiles =>
      _files.where((f) => !f.sample.noTest).toSet();

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

  /// Write code samples to the file.
  ///
  /// In default, it will write to the overlay (in-memory) file system. But,
  /// if [options.write] is true, it will write to the pyscial file system.
  void writeCodeSamples(
    String filePath,
    List<DocumentationCodeSample> samples,
  ) {
    for (final (i, s) in samples.indexed) {
      if (s.noTest) {
        continue;
      }

      final fileName = p.basename(filePath).replaceFirst('.dart', '_$i.dart');
      final path = p.join(_testDir.path, fileName);
      _writeFile(path, s);
    }
  }

  bool _exclude(File file) {
    final path = p.relative(file.path);
    return !options.exclude.any((glob) => glob.matches(path));
  }

  /// Get all dart files in the current directory.
  ///
  /// If [options.exclude] is provided, it will exclude files that match the
  /// patterns.
  List<File> getFiles() {
    final files = _currentDir
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))
        .where(_exclude)
        .toList();
    return files;
  }
}
