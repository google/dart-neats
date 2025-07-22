import 'package:sanitize_html/src/sane_html_validator.dart';
import 'package:test/test.dart';

void main() {
  group('validateCIDImage', () {
    test('returns true for valid cid string', () {
      expect(validateCIDImage('cid:12345'), true);
    });

    test('returns false for string without cid', () {
      expect(validateCIDImage('https://example.com/image.png'), false);
    });

    test('returns false for empty string', () {
      expect(validateCIDImage(''), false);
    });
  });
}
