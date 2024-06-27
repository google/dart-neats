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

import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:dartdoc_test/dartdoc_test.dart';
import 'package:dartdoc_test/src/resource.dart';
import 'package:source_span/source_span.dart';

void getAnalysisResult(
  AnalysisContext context,
  CodeSampleFile file,
) async {
  final result = await context.currentSession.getErrors(file.path);
  if (result is ErrorsResult) {
    for (final e in result.errors) {
      final span = toOriginalFileSpanFromSampleError(file, e);
      if (span != null) print(span.toString());
      print(e.message);
    }
  }
}

class AnalyzeResult {
  final String filePath;
  final FileSpan span;
  final List<String> errors;

  AnalyzeResult({
    required this.filePath,
    required this.span,
    required this.errors,
  });
}
