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
import 'package:source_span/source_span.dart';

import 'model.dart';

/// Get analysis result for a code sample file.
Future<DartdocAnalysisResult> getAnalysisResult(
  AnalysisContext context,
  CodeSampleFile file,
) async {
  final result = await context.currentSession.getErrors(file.path);
  if (result is ErrorsResult) {
    final errors = result.errors.map((e) {
      final (start, end) = (e.offset, e.offset + e.length);
      final generatedSpan = file.sourceFile.span(start, end);
      final commentSpan = getOriginalSubSpan(
        sample: generatedSpan,
        original: file.sample.comment.span,
      );
      return DartdocErrorResult(
        error: e,
        commentSpan: commentSpan,
        generatedSpan: generatedSpan,
      );
    }).toList();

    return DartdocAnalysisResult(file, errors);
  }

  return DartdocAnalysisResult(file, []);
}

/// get original file span from sample file span.
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

/// Dartdoc error result
class DartdocErrorResult {
  /// Error description
  final AnalysisError error;

  /// Source span of the comment containing code sample from the original file.
  final FileSpan? commentSpan;

  /// Source span of the generated code sample file.
  final FileSpan? generatedSpan;

  /// Create a new instance of [DartdocErrorResult]
  DartdocErrorResult({
    required this.error,
    required this.commentSpan,
    required this.generatedSpan,
  });
}

/// Dartdoc analysis result
class DartdocAnalysisResult {
  /// generated code sample file
  final CodeSampleFile file;

  /// list of analysis errors
  final List<DartdocErrorResult> errors;

  /// Wheather the analysis result has error
  bool get hasError => errors.any((e) => e.commentSpan != null);

  /// Create a new instance of [DartdocAnalysisResult]
  DartdocAnalysisResult(this.file, this.errors);
}
