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

import 'package:analyzer/dart/analysis/results.dart';
import 'package:glob/glob.dart';

import 'analyzer.dart';
import 'extractor.dart';
import 'resource.dart';

/// Dartdoc test
class DartdocTest {
  /// Create a new [DartdocTest] with [options].
  DartdocTest(this.options) : _testContext = DartdocTestContext(options);

  /// The options for running dartdoc_test.
  final DartdocTestOptions options;
  final DartdocTestContext _testContext;

  /// Extract code samples from the currrent directory.
  Future<void> extract() async {
    final session = _testContext.context.currentSession;
    for (final file in getFiles()) {
      final result = session.getParsedUnit(file.path);

      if (result is ParsedUnitResult) {
        final samples = extractFile(result);
        _testContext.writeCodeSamples(file.path, samples);
      }
    }
  }

  /// Analyze code samples.
  Future<List<DartdocAnalysisResult>> analyze() async {
    final files = _testContext.codeSampleFiles;

    final results = <DartdocAnalysisResult>[];
    for (final f in files) {
      final result = await getAnalysisResult(_testContext.context, f);
      results.add(result);
    }

    return results;
  }

  /// Get all dart files in the current directory.
  List<File> getFiles() => _testContext.getFiles();
}

/// Options for running dartdoc_test
class DartdocTestOptions {
  /// Whether to write generated code samples to physical files.
  final bool write;

  /// Whether to output verbose information.
  final bool verbose;

  /// The glob patterns to exclude files from analysis.
  final List<Glob> exclude;

  /// The output directory for generated code samples (optional).
  /// if it is `null`, the default output directory is `.dart_tool/dartdoc_test`.
  final String? out;

  /// Create a new [DartdocTestOptions].
  DartdocTestOptions({
    this.write = false,
    this.verbose = false,
    List<String> exclude = const [],
    this.out,
  }) : exclude = exclude.map((e) => Glob(e)).toList();
}
