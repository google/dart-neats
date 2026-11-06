import 'package:sanitize_html/src/srcset_parser.dart';
import 'package:test/test.dart';

void main() {
  group('SrcsetParser', () {
    test('splits candidates and keeps descriptors', () {
      expect(SrcsetParser.parse('a.png 1x, b.png 2x'), [
        SrcsetCandidate('a.png', '1x'),
        SrcsetCandidate('b.png', '2x'),
      ]);
    });

    test('keeps commas inside a data URL', () {
      expect(SrcsetParser.parse('data:image/png;base64,AAAA 1x'), [
        SrcsetCandidate('data:image/png;base64,AAAA', '1x'),
      ]);
    });

    test('keeps commas inside an https URL', () {
      expect(SrcsetParser.parse('https://h/a,b.png 300w'), [
        SrcsetCandidate('https://h/a,b.png', '300w'),
      ]);
    });

    test('splits URLs without descriptors on a trailing comma', () {
      expect(SrcsetParser.parse('a.png, b.png'), [
        SrcsetCandidate('a.png', ''),
        SrcsetCandidate('b.png', ''),
      ]);
    });

    test('reads a comma without whitespace as part of the URL', () {
      expect(SrcsetParser.parse('a.png,b.png'), [
        SrcsetCandidate('a.png,b.png', ''),
      ]);
    });

    test('closes parentheses at the first ")" like the browser', () {
      expect(SrcsetParser.parse('a.png 1x (( ), file:///etc/passwd 2x'), [
        SrcsetCandidate('a.png', '1x (( )'),
        SrcsetCandidate('file:///etc/passwd', '2x'),
      ]);
    });

    test('parses a long comma run in linear time', () {
      final commas = ',' * 200000;
      expect(SrcsetParser.parse('a${commas}a,'), [
        SrcsetCandidate('a${commas}a', ''),
      ]);
    }, timeout: const Timeout(Duration(seconds: 5)));

    test('skips empty candidates', () {
      expect(SrcsetParser.parse('a.png 1x,,, '), [
        SrcsetCandidate('a.png', '1x'),
      ]);
      expect(SrcsetParser.parse(''), isEmpty);
      expect(SrcsetParser.parse(' , ,'), isEmpty);
    });

    test('keeps a non-ASCII space inside the URL like the browser', () {
      expect(SrcsetParser.parse('https://h.example/a\u00a0b.png 2x'), [
        SrcsetCandidate('https://h.example/a\u00a0b.png', '2x'),
      ]);
    });
  });
}
