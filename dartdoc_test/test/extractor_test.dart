import 'package:dartdoc_test/src/extractor.dart';
import 'package:test/test.dart';

void main() {
  group('strip comments', () {
    test('can strip javaDocStyle', () {
      final javaDocStyle = '''
/**
 * This is a JavaDoc style comment.
 * ```dart
 * final x = 1;
 * ```
 */''';
      final expectText = '''
This is a JavaDoc style comment.
```dart
final x = 1;
```''';

      expect(stripComments(javaDocStyle), expectText);
    });

    test('can strip cSharpStyle', () {
      final cSharpStyle = '''
/// This is a C# style comment.
/// ```dart
/// final x = 1;
/// ```''';
      final expectText = '''
This is a C# style comment.
```dart
final x = 1;
```''';
      expect(stripComments(cSharpStyle), expectText);
    });

    test('can remove leading whitespaces', () {
      final leadingSpacedComment = '''
  /// This is a leading spaced comment.
  /// ```dart
  /// final x = 1;
  /// ```''';
      final expectText = '''
This is a leading spaced comment.
```dart
final x = 1;
```''';
      expect(stripComments(leadingSpacedComment), expectText);
    });

    group('line breaks', () {
      test('can strip CRLF (windows) line breaks', () {
        final actualText =
            '/// This is a windows line break comment.\r\n/// ```dart\r\n/// final x = 1;\r\n/// ```';
        final expectText = '''
This is a windows line break comment.
```dart
final x = 1;
```''';

        expect(stripComments(actualText), expectText);
      });

      test('can strip LF (linux) line breaks', () {
        final actualText =
            '/// This is a linux line break comment.\n/// ```dart\n/// final x = 1;\n/// ```';
        final expectText = '''
This is a linux line break comment.
```dart
final x = 1;
```''';

        expect(stripComments(actualText), expectText);
      });
    });
  });
}
