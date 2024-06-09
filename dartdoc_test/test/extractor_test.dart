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
  });
}
