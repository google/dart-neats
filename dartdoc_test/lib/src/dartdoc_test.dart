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
import 'package:args/args.dart';
import 'package:path/path.dart' as p;

import 'package:analyzer/dart/analysis/results.dart';

import 'analyzer.dart';
import 'extractor.dart';
import 'resource.dart';

class DartdocTest {
  DartdocTest(this.options) : _testContext = DartdocTestContext(options);

  final DartdocTestOptions options;
  final DartdocTestContext _testContext;

  /// Extract code samples from the currrent directory.
  Future<void> run() async {
    print("Extracting code samples ...");

    final session = _testContext.context.currentSession;
    for (final file in getFilesFrom(currentDir)) {
      final result = session.getParsedUnit(file.path);

      if (result is ParsedUnitResult) {
        final samples = extractFile(result);
        _testContext.writeCodeSamples(file.path, samples);
      }
    }
  }

  /// Analyze code samples.
  Future<void> analyze() async {
    await run();

    final files = _testContext.codeSampleFiles;

    print("Analyzing code samples ...");

    for (final f in files) {
      getAnalysisResult(_testContext.context, f);
    }
  }

  Future<void> generate() async {
    print("Generating code samples ...");

    final content = '''
import 'package:dartdoc_test/dartdoc_test.dart';
import 'package:test/test.dart';

void main() {
  test('analyze documentation code samples', () {
    DartdocTest(DartdocTestOptions(write: false)).analyze();
  });
}
''';

    // if not exists, create test directory
    final testDir = Directory(p.join(currentDir.path, 'test'));
    if (!testDir.existsSync()) {
      testDir.createSync();
    }

    final file = File(p.join(testDir.path, 'dartdoc_test.dart'));
    await file.writeAsString(content);

    print("Done! Run 'dart test' to analyze code samples.");
  }
}

class DartdocTestOptions {
  final bool write;
  final List<String> include;
  final List<String> exclude;

  const DartdocTestOptions({
    this.write = false,
    this.include = const [],
    this.exclude = const [],
  });

  factory DartdocTestOptions.fromArg([ArgResults? args]) {
    if (args == null || args.arguments.isEmpty) {
      return DartdocTestOptions();
    }
    return DartdocTestOptions(
      write: args.flag('write'),
    );
  }
}
