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
import 'package:args/args.dart';
import 'package:path/path.dart' as p;

import 'src/analyzer.dart';
import 'src/extractor.dart';
import 'src/resource.dart';

class DartDocTest {
  DartDocTest(this.options) : _testContext = DartDocTestContext(options);

  final DartDocTestOptions options;
  final DartDocTestContext _testContext;

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
    DartDocTest(DartDocTestOptions(write: false)).analyze();
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

class DartDocTestOptions {
  final bool write;

  const DartDocTestOptions({required this.write});

  factory DartDocTestOptions.parse(List<String> args) {
    final parser = ArgParser()
      ..addFlag(
        'write',
        abbr: 'w',
        help: 'Write sample code to file',
        defaultsTo: false,
      );
    final argResults = parser.parse(args);

    return DartDocTestOptions(write: argResults['write'] as bool);
  }
}
