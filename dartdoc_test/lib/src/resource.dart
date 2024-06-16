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
