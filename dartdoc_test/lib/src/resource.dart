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

import 'extractor.dart';

const _testPath = '.dartdoc_test';

final currentDir = Directory.current;

/// Directory to store generated code samples
final testDir = Directory(p.join(currentDir.path, _testPath));

/// Context for running tests.
/// manage [resourceProvider].
class TestContext {
  factory TestContext() => _instance;

  static final _instance = TestContext._internal();

  TestContext._internal() {
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

  OverlayResourceProvider get resourceProvider => _resourceProvider;
  AnalysisContext get context => _context;
}

void writeCodeSamples(String filePath, List<DocumentationCodeSample> samples) {
  for (final (i, s) in samples.indexed) {
    final fileName =
        p.basename(filePath).replaceFirst('.dart', '_sample_$i.dart');
    final path = p.join(testDir.path, fileName);
    print(s.wrappedCode);
    TestContext().resourceProvider.setOverlay(
          path,
          content: s.wrappedCode,
          modificationStamp: 0,
        );
  }
}

List<File> getFiles() {
  // TODO: add `include` and `exclude` options
  final files = currentDir
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'))
      .toList();
  return files;
}
