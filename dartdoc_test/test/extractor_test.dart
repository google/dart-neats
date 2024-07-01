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

import 'package:dartdoc_test/src/extractor.dart';
import 'package:test/test.dart';

void main() {
  group('strip comments', () {
    test('can strip javaDocStyle', () {
      // replace to inline.
      final javaDocStyle =
          '/**\n * This is a JavaDoc style comment.\n * ```dart\n * final x = 1;\n * ```\n */';
      final expectText =
          'This is a JavaDoc style comment.\n```dart\nfinal x = 1;\n```';
      expect(stripComments(javaDocStyle), expectText);
    });

    test('can strip cSharpStyle', () {
      final cSharpStyle =
          '/// This is a C# style comment.\n/// ```dart\n/// final x = 1;\n/// ```';
      final expectText =
          'This is a C# style comment.\n```dart\nfinal x = 1;\n```';
      expect(stripComments(cSharpStyle), expectText);
    });

    test('can remove leading whitespaces', () {
      final leadingSpacedComment =
          '  /// This is a leading spaced comment.\n  /// ```dart\n  /// final x = 1;\n  /// ```';
      final expectText =
          'This is a leading spaced comment.\n```dart\nfinal x = 1;\n```';
      expect(stripComments(leadingSpacedComment), expectText);
    });

    group('line breaks', () {
      test('can strip CRLF (windows) line breaks', () {
        final actualText =
            '/// This is a windows line break comment.\r\n/// ```dart\r\n/// final x = 1;\r\n/// ```';
        final expectText =
            'This is a windows line break comment.\n```dart\nfinal x = 1;\n```';
        expect(stripComments(actualText), expectText);
      });

      test('can strip LF (linux) line breaks', () {
        final actualText =
            '/// This is a linux line break comment.\n/// ```dart\n/// final x = 1;\n/// ```';
        final expectText =
            'This is a linux line break comment.\n```dart\nfinal x = 1;\n```';
        expect(stripComments(actualText), expectText);
      });
    });
  });
}
