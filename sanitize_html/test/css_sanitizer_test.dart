import 'package:sanitize_html/src/css_sanitizer.dart';
import 'package:test/test.dart';

void main() {
  group('CssSanitizer', () {
    test('sanitizeInline allows safe properties', () {
      final result =
          CssSanitizer.sanitizeInline('color: red; font-size: 12px;');
      expect(result, 'color: red; font-size: 12px');
    });

    test('sanitizeInline removes unsafe properties', () {
      final result =
          CssSanitizer.sanitizeInline('color: red; position: absolute;');
      expect(result, 'color: red');
    });

    test('sanitizeInline removes javascript', () {
      final result = CssSanitizer.sanitizeInline(
          'color: red; background: url(javascript:alert(1));');
      expect(result, 'color: red');
    });

    test('sanitizeStylesheet removes comments & @rules', () {
      final css = '''
      /* comment */
      @media screen { color: red; }
      p { color: blue; position: absolute; }
      ''';

      final result = CssSanitizer.sanitizeStylesheet(css);

      expect(result, 'p { color: blue }');
    });
  });
}
