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
import 'package:analyzer/error/error.dart';
import 'package:dartdoc_test/src/resource.dart';
import 'package:source_span/source_span.dart';

import 'logger.dart';

Future<DartdocAnalysisResult> getAnalysisResult(
  AnalysisContext context,
  CodeSampleFile file,
) async {
  final result = await context.currentSession.getErrors(file.path);
  if (result is ErrorsResult) {
    final errors = result.errors.map((e) {
      final span = toOriginalFileSpanFromSampleError(file, e);
      return DartdocErrorResult(e, span);
    }).toList();

    for (final e in result.errors) {
      final span = toOriginalFileSpanFromSampleError(file, e);
      if (span != null) {
        log(span.message((e.message)));
        log('\n');
      } else {
        log(
          'Error found in generated code.\n'
          '$e\n',
          LogLevel.debug,
        );
      }
    }

    return DartdocAnalysisResult(file, errors);
  }

  return DartdocAnalysisResult(file, []);
}

FileSpan? toOriginalFileSpanFromSampleError(
  CodeSampleFile file,
  AnalysisError error,
) {
  final (start, end) = (error.offset, error.offset + error.length - 1);
  final codeSampleSpan = file.sourceFile.span(start, end);
  final span = getOriginalSubSpan(
    sample: codeSampleSpan,
    original: file.sample.comment.span,
  );
  return span;
}

// get original file span from sample file span
FileSpan? getOriginalSubSpan({
  required FileSpan sample,
  required FileSpan original,
}) {
  final offset = original.text.indexOf(sample.text);
  if (offset == -1) {
    return null;
  }
  return original.subspan(offset, offset + sample.length);
}

class DartdocErrorResult {
  final AnalysisError error;
  final FileSpan? span;

  DartdocErrorResult(this.error, this.span);
}

class DartdocAnalysisResult {
  final CodeSampleFile file;
  final List<DartdocErrorResult> errors;

  DartdocAnalysisResult(this.file, this.errors);
}
