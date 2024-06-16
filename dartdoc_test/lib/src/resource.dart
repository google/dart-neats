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
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:analyzer/file_system/overlay_file_system.dart';
import 'package:path/path.dart' as p;

import 'extractor.dart';

final resourceProvider =
    OverlayResourceProvider(PhysicalResourceProvider.INSTANCE);

final _current = Directory.current;

// Directory to store generated code samples
final testDirectory = Directory('${_current.path}/.dartdoc_test');

final _contextCollection = AnalysisContextCollection(
  resourceProvider: resourceProvider,
  includedPaths: [_current.absolute.path],
);

final currentContext = _contextCollection.contextFor(_current.absolute.path);

void writeCodeSamples(String filePath, List<DocumentationCodeSample> samples) {
  for (final (i, s) in samples.indexed) {
    final fileName =
        p.basename(filePath).replaceFirst('.dart', '_sample_$i.dart');
    final path = p.join(testDirectory.path, fileName);
    print(s.wrappedCode);
    resourceProvider.setOverlay(
      path,
      content: s.wrappedCode,
      modificationStamp: 0,
    );
  }
}

List<File> getFiles() {
  // TODO: add `include` and `exclude` options
  final files = _current
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'))
      .toList();
  return files;
}
