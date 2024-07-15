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

import 'package:dartdoc_test/src/analyzer.dart';
import 'package:source_span/source_span.dart';
import 'package:test/test.dart';

void main() {
  group('getOriginalSubSpan', () {
    test('should return SourceSpan if span is found in original', () {
      final originalText =
          '/// Example:```dart\n/// final x = sample();\n/// ```\nint sample() {\n  return 1;\n}\n';

      final sampleText = 'void main() {\n  final x = sample();\n}\n';

      final original = SourceFile.fromString(originalText)
          .span(0, 48); // span of comment section.
      final sample =
          SourceFile.fromString(sampleText).span(26, 34); // span of 'sample()'.
      final result = getOriginalSubSpan(sample: sample, original: original);

      expect(result, isNotNull);
      expect(result?.start.offset, 34);
      expect(result?.text, 'sample()');
    });

    test('should return null if span is not found in original', () {
      final originalText =
          '/// Example:```dart\n/// final x = sample();\n/// ```\nint sample() {\n  return 1;\n}\n';
      final sampleText =
          'import \'dart:convert\';  void main() {\n  final x = sample();\n}\n';

      final original = SourceFile.fromString(originalText)
          .span(0, 48); // span of comment section.
      final sample =
          SourceFile.fromString(sampleText).span(0, 6); // span of 'import'.
      final result = getOriginalSubSpan(sample: sample, original: original);

      expect(result, isNull); // not found.
    });
  });

  // TODO: add emoji offset test
}
