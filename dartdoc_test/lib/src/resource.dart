import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:analyzer/file_system/overlay_file_system.dart';

final resourceProvider =
    OverlayResourceProvider(PhysicalResourceProvider.INSTANCE);

final _current = Directory.current;

void currentContext = AnalysisContextCollection(
  resourceProvider: resourceProvider,
  includedPaths: [_current.absolute.path],
).contextFor(_current.absolute.path);
