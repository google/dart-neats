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

import 'package:analyzer/dart/analysis/results.dart';

import 'src/analyzer.dart';
import 'src/extractor.dart';
import 'src/resource.dart';

class DartDocTest {
  const DartDocTest();

  Future<void> run() async {
    print("Extracting code samples ...");

    final session = TestContext().context.currentSession;
    for (final file in getFilesFrom(currentDir)) {
      final result = session.getParsedUnit(file.path);

      if (result is ParsedUnitResult) {
        final samples = extractFile(result);
        writeCodeSamples(file.path, samples);
      }
    }
  }

  Future<void> runAnalyze() async {
    await run();

    final samples = TestContext().getSamplesFilePath();

    print("Analyzing code samples ...");

    for (final s in samples) {
      final result = await getAnalysisResult(s);
      for (final e in result.errors) {
        print(e);
      }
    }
  }
}
