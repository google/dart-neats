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

void getAnalysisResult(
  AnalysisContext context,
  CodeSampleFile file,
) async {
  final result = await context.currentSession.getErrors(file.path);
  if (result is ErrorsResult) {
    for (final e in result.errors) {
      if (e.errorCode.type != ErrorType.SYNTACTIC_ERROR &&
          e.errorCode.type != ErrorType.COMPILE_TIME_ERROR) {
        continue;
      }
      final span = toOriginalFileSpanFromSampleError(file, e);
      if (span != null) {
        print(span.start.toolString);
        print(e.message);
        print('\n');
      } else {
        print('this error is caused by generated code.');
        print(e.message);
        print('\n');
      }
    }
  }
}

FileSpan? toOriginalFileSpanFromSampleError(
  CodeSampleFile file,
  AnalysisError error,
) {
  print(error.toString());
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
