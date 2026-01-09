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
  });
}
