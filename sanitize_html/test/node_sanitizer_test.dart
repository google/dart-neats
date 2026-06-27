import 'package:html/parser.dart';
import 'package:sanitize_html/src/node_sanitizer.dart';
import 'package:test/test.dart';

void main() {
  group('NodeSanitizer', () {
    late NodeSanitizer sanitizer;

    setUp(() {
      sanitizer = NodeSanitizer(
        allowId: null,
        allowClass: null,
        addLinkRel: null,
        allowAttributes: null,
        allowTags: null,
      );
    });

    test('removes forbidden tags', () {
      final doc = parse('<script>alert(1)</script><p>Hello</p>');
      sanitizer.sanitize(doc.body!, allowUnwrap: false);

      expect(doc.body!.innerHtml.trim(), '<p>Hello</p>');
    });

    test('sanitizes STYLE inside <head> (default html parser behavior)', () {
      final doc = parse('<style>p { color: red; position: absolute; }</style>');

      expect(doc.head!.innerHtml.contains('position'), true);

      sanitizer.sanitize(doc.head!, allowUnwrap: false);

      expect(
        doc.head!.innerHtml.trim(),
        '<style>p { color: red }</style>',
      );
    });

    test('sanitizes STYLE inside fragment (email HTML case)', () {
      final doc = parse(
        '<style>p { color: red; position: absolute; }</style>',
      );

      if (doc.head != null) sanitizer.sanitize(doc.head!, allowUnwrap: false);

      expect(
        doc.head!.innerHtml.trim(),
        '<style>p { color: red }</style>',
      );
    });

    test('sanitizes attributes correctly', () {
      final doc = parse(
        '<p onclick="alert(1)" style="color:red; position:absolute;">Hi</p>',
      );

      sanitizer.sanitize(doc.body!, allowUnwrap: false);

      expect(doc.body!.innerHtml, '<p style="color: red">Hi</p>');
    });

    test('sanitize document head + body together', () {
      final doc = parse('''
        <style>p { color: blue; position:absolute; }</style>
        <p onclick="x" style="color:red; position:absolute;">Hello</p>
      ''');

      if (doc.head != null) sanitizer.sanitize(doc.head!, allowUnwrap: false);
      if (doc.body != null) sanitizer.sanitize(doc.body!, allowUnwrap: false);

      expect(
        doc.head!.innerHtml.trim(),
        '<style>p { color: blue }</style>',
      );

      expect(
        doc.body!.innerHtml.trim(),
        '<p style="color: red">Hello</p>',
      );
    });

    group('_shouldStripText – backslash-hex false-positive regression', () {
      // Before the unicodeEscapeReg tightening, any text node containing
      // \XX (backslash + two hex digits) was stripped. This caused plain-text
      // emails with PHP namespace separators like \Sabre\DAV to go blank.

      test('preserves text node with single \\XX sequence (PHP namespace separator)', () {
        final doc = parse('<p>throw new \\Sabre\\DAV\\Exception\\Forbidden()</p>');
        sanitizer.sanitize(doc.body!, allowUnwrap: false);
        expect(doc.body!.innerHtml, contains('Forbidden'));
      });

      test('preserves text node with \\App\\DB\\Exception\\AuthFailed pattern', () {
        final doc = parse('<p>throw new \\App\\DB\\Exception\\AuthFailed("denied")</p>');
        sanitizer.sanitize(doc.body!, allowUnwrap: false);
        expect(doc.body!.innerHtml, contains('AuthFailed'));
      });

      test('still strips text node with many consecutive \\XX sequences (encoded "javascript")', () {
        // \6a\61\76\61\73\63\72\69\70\74 = "javascript" — must still be caught.
        final doc = parse(
          '<p>href=\\6a\\61\\76\\61\\73\\63\\72\\69\\70\\74:alert(1)</p>',
        );
        sanitizer.sanitize(doc.body!, allowUnwrap: false);
        expect(doc.body!.innerHtml, isNot(contains('\\6a\\61\\76')));
      });
    });
  });
}
