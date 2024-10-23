import 'package:sanitize_html/src/sane_html_validator.dart';
import 'package:test/test.dart';

void main() {
  group('validateBase64Image', () {
    test('Valid Base64 PNG image string', () {
      String validBase64PNG = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUA';
      expect(validateBase64Image(validBase64PNG), isTrue);
    });

    test('Valid Base64 JPEG image string', () {
      String validBase64JPEG = 'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQEAAAAAA';
      expect(validateBase64Image(validBase64JPEG), isTrue);
    });

    test('Invalid Base64 image string (missing data:image/)', () {
      String invalidBase64 = 'base64,iVBORw0KGgoAAAANSUhEUgAAAAUA';
      expect(validateBase64Image(invalidBase64), isFalse);
    });

    test('Invalid Base64 image string (not base64 encoded)', () {
      String invalidBase64 = 'data:image/png;notabase64string';
      expect(validateBase64Image(invalidBase64), isFalse);
    });

    test('Valid Base64 SVG image string', () {
      String validBase64SVG = 'data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDov';
      expect(validateBase64Image(validBase64SVG), isTrue);
    });

    test('Invalid Base64 image string (wrong image type)', () {
      String invalidBase64Type = 'data:image/tiff;base64,iVBORw0KGgoAAAANSUhEUgAAAAUA';
      expect(validateBase64Image(invalidBase64Type), isFalse);
    });

    test('Empty string', () {
      String emptyString = '';
      expect(validateBase64Image(emptyString), isFalse);
    });

    test('Non-image Base64 string', () {
      String nonImageBase64 = 'data:text/plain;base64,dGVzdA==';  // Plain text Base64-encoded
      expect(validateBase64Image(nonImageBase64), isFalse);
    });
  });
}
