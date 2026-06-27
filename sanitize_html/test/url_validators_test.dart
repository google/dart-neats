import 'package:sanitize_html/src/url_validators.dart';
import 'package:test/test.dart';

void main() {
  group('UrlValidators', () {
    test('validLink accepts http/https/mailto', () {
      expect(UrlValidators.validLink('https://google.com'), true);
      expect(UrlValidators.validLink('http://example.com'), true);
      expect(UrlValidators.validLink('mailto:test@example.com'), true);
    });

    test('validLink rejects javascript', () {
      expect(UrlValidators.validLink('javascript:alert(1)'), false);
    });

    test('validUrl accepts http/https', () {
      expect(UrlValidators.validUrl('https://abc.com'), true);
      expect(UrlValidators.validUrl('http://xyz.com'), true);
    });

    test('validUrl rejects mailto', () {
      expect(UrlValidators.validUrl('mailto:abc'), false);
    });

    test('validBase64Image Valid Base64 PNG image string', () {
      String validBase64PNG =
          'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUA';
      expect(UrlValidators.validBase64Image(validBase64PNG), isTrue);
    });

    test('validBase64Image Valid Base64 JPEG image string', () {
      String validBase64JPEG =
          'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQEAAAAAA';
      expect(UrlValidators.validBase64Image(validBase64JPEG), isTrue);
    });

    test('validBase64Image Invalid Base64 image string (missing data:image/)',
        () {
      String invalidBase64 = 'base64,iVBORw0KGgoAAAANSUhEUgAAAAUA';
      expect(UrlValidators.validBase64Image(invalidBase64), isFalse);
    });

    test('validBase64Image Invalid Base64 image string (not base64 encoded)',
        () {
      String invalidBase64 = 'data:image/png;notabase64string';
      expect(UrlValidators.validBase64Image(invalidBase64), isFalse);
    });

    test('validBase64Image Invalid Base64 image string (wrong image type)', () {
      String invalidBase64Type =
          'data:image/tiff;base64,iVBORw0KGgoAAAANSUhEUgAAAAUA';
      expect(UrlValidators.validBase64Image(invalidBase64Type), isFalse);
    });

    test('validBase64Image rejects SVG data URLs', () {
      const svgData =
          'data:image/svg+xml;base64,PHN2ZyBvbmxvYWQ9ImFsZXJ0KDEpIj48L3N2Zz4=';
      expect(UrlValidators.validBase64Image(svgData), isFalse);
    });

    test('validBase64Image Empty string', () {
      String emptyString = '';
      expect(UrlValidators.validBase64Image(emptyString), isFalse);
    });

    test('validBase64Image Non-image Base64 string', () {
      String nonImageBase64 = 'data:text/plain;base64,dGVzdA==';
      expect(UrlValidators.validBase64Image(nonImageBase64), isFalse);
    });

    test('validCIDImage returns true for valid cid string', () {
      expect(UrlValidators.validCIDImage('cid:12345'), true);
    });

    test('validCIDImage returns false for string without cid', () {
      expect(
        UrlValidators.validCIDImage('https://example.com/image.png'),
        false,
      );
    });

    test('validCIDImage returns false for empty string', () {
      expect(UrlValidators.validCIDImage(''), false);
    });

    test('validImageSource covers URL/Base64/CID', () {
      expect(UrlValidators.validImageSource('cid:12'), true);
      expect(UrlValidators.validImageSource('https://abc.com'), true);
      expect(
        UrlValidators.validImageSource(
          'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQEAYABgAAD',
        ),
        true,
      );
    });
  });
}
