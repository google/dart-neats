import 'package:sanitize_html/src/css_sanitizer.dart';
import 'package:test/test.dart';

void main() {
  group('CssSanitizer – inline CSS', () {
    test('allows safe properties', () {
      final result =
          CssSanitizer.sanitizeInline('color: red; font-size: 12px;');
      expect(result, 'color: red; font-size: 12px');
    });

    test('removes unsafe properties', () {
      final result = CssSanitizer.sanitizeInline(
          'color: red; position: absolute; top: 10');
      expect(result, 'color: red');
    });

    test('removes javascript urls', () {
      final result =
          CssSanitizer.sanitizeInline('background: url(javascript:alert(1));');

      expect(result, '',
          reason:
              'background is not in allowedCssProperties → removed entirely');
    });

    test('preserves line-height', () {
      final result = CssSanitizer.sanitizeInline('line-height: 1;');
      expect(result, 'line-height: 1');
    });

    test('adds px to unitless height/width', () {
      final result = CssSanitizer.sanitizeInline('height: 10; width: 20;');
      expect(result, 'height: 10px; width: 20px');
    });

    test('does NOT modify width/height with existing units', () {
      final result = CssSanitizer.sanitizeInline('height: 5em; width: 20rem;');
      expect(result, 'height: 5em; width: 20rem');
    });

    test('normalizes padding whitespace', () {
      final result = CssSanitizer.sanitizeInline('padding: 0px   20px;');
      expect(result, 'padding: 0px 20px');
    });

    test('normalizes border whitespace', () {
      final result =
          CssSanitizer.sanitizeInline('border:  1px   solid   #000;');
      expect(result, 'border: 1px solid #000');
    });

    test('removes forbidden CSS keywords', () {
      final result =
          CssSanitizer.sanitizeInline('width: 100; behavior: url(thing.htc);');
      expect(result, 'width: 100px');
    });

    test('removes unknown CSS properties', () {
      final result =
          CssSanitizer.sanitizeInline('color: red; unknown-prop: 123;');
      expect(result, 'color: red');
    });

    test('removes invalid declarations (no colon)', () {
      final result = CssSanitizer.sanitizeInline('color red; width:10;');
      expect(result, 'width: 10px');
    });

    test('handles empty style input', () {
      expect(CssSanitizer.sanitizeInline('   '), '');
      expect(CssSanitizer.sanitizeInline(';;;'), '');
    });

    test('preserves base64 image values', () {
      final style =
          'background-image: url(data:image/png;base64,AAABBBCCC123==);';

      final result = CssSanitizer.sanitizeInline(style);

      expect(
        result,
        'background-image: url(data:image/png;base64,AAABBBCCC123==)',
      );
    });

    test('drops dangerous expressions', () {
      final result =
          CssSanitizer.sanitizeInline('width: expression(alert(1));');
      expect(result, '');
    });

    test('drops unicode JS payload', () {
      final result = CssSanitizer.sanitizeInline(
          r'background: url(\6a\61\76\61script:evil);');
      expect(result, '');
    });

    test('normalizes multiple declarations', () {
      final result = CssSanitizer.sanitizeInline(
          'color: blue; height: 10; padding: 0px  20px;');
      expect(result, 'color: blue; height: 10px; padding: 0px 20px');
    });

    test('keeps only allowed properties with correct order', () {
      final result = CssSanitizer.sanitizeInline(
          'padding:10px; unknown:1; color:red; border: 1px solid black;');
      expect(result, 'padding: 10px; color: red; border: 1px solid black');
    });

    test('keeps safe url() in background-image', () {
      final result = CssSanitizer.sanitizeInline(
          'background-image: url(/images/header.jpg); padding: 20px;');

      expect(
          result.contains('background-image: url(/images/header.jpg)'), true);
      expect(result.contains('padding: 20px'), true);
    });

    test('keeps https url() in background-image', () {
      final result = CssSanitizer.sanitizeInline(
          'background-image: url(https://example.com/bg.png);');

      expect(result, 'background-image: url(https://example.com/bg.png)');
    });

    test('allows data:image/* base64 url() in background-image', () {
      final result = CssSanitizer.sanitizeInline(
        'background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUA);',
      );

      expect(
        result,
        'background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUA)',
      );
    });

    test('removes javascript: url() but keeps safe properties', () {
      final result = CssSanitizer.sanitizeInline(
          'background-image: url(javascript:evil); color: red;');

      expect(result, 'color: red');
    });

    test('keeps opacity property', () {
      final result = CssSanitizer.sanitizeInline('opacity: 0.9;');
      expect(result, 'opacity: 0.9');
    });

    test('keeps box-shadow property', () {
      final result =
          CssSanitizer.sanitizeInline('box-shadow: 0 2px 5px rgba(0,0,0,0.2);');
      expect(result, 'box-shadow: 0 2px 5px rgba(0,0,0,0.2)');
    });

    test('keeps text-shadow property', () {
      final result =
          CssSanitizer.sanitizeInline('text-shadow: 1px 1px 2px #333;');
      expect(result, 'text-shadow: 1px 1px 2px #333');
    });

    test('keeps display:flex', () {
      final result = CssSanitizer.sanitizeInline('display: flex;');
      expect(result, 'display: flex');
    });

    test('keeps justify-content for flexbox', () {
      final result = CssSanitizer.sanitizeInline(
          'display: flex; justify-content: space-between;');

      expect(result.contains('display: flex'), true);
      expect(result.contains('justify-content: space-between'), true);
    });

    test('keeps align-items for flexbox', () {
      final result =
          CssSanitizer.sanitizeInline('display: flex; align-items: center;');

      expect(result.contains('align-items: center'), true);
    });

    test('keeps flex shorthand', () {
      final result = CssSanitizer.sanitizeInline('flex: 1;');
      expect(result, 'flex: 1');
    });

    test('keeps safe background-image', () {
      final result =
          CssSanitizer.sanitizeInline('background-image: url(/img/bg.png);');

      expect(result, 'background-image: url(/img/bg.png)');
    });

    test('removes unsafe background-image with javascript url()', () {
      final result = CssSanitizer.sanitizeInline(
          'background-image: url(javascript:evil); opacity: 1;');

      expect(result, 'opacity: 1');
    });
  });

  group('CssSanitizer – stylesheet', () {
    test('removes comments & @rules', () {
      final css = '''
        /* comment */
        @media screen { color: red; }
        p { color: blue; position: absolute; }
      ''';

      final result = CssSanitizer.sanitizeStylesheet(css);
      expect(result, 'p { color: blue }');
    });

    test('handles multiple blocks', () {
      final css = '''
      p { color: red; }
      div { height: 10; width: 20; }
      span { position: absolute; }
      ''';

      final result = CssSanitizer.sanitizeStylesheet(css);

      expect(result.contains('p { color: red }'), true);
      expect(result.contains('div { height: 10px; width: 20px }'), true);
      expect(result.contains('span'), false);
    });

    test('ignores @keyframes, @supports, @font-face rules', () {
      final css = '''
      @keyframes myanim { 0% { opacity:0 } }
      @supports(display:flex) { div { color: blue } }
      @font-face { font-family:x; src:url(a) }
      p { color: green }
      ''';

      final result = CssSanitizer.sanitizeStylesheet(css);

      expect(result, 'p { color: green }');
    });

    test('ignores invalid blocks', () {
      final css = '''
      invalidblock
      p color: red }
      { missingselector: 1 }
      span { color: red; }
      ''';

      final result = CssSanitizer.sanitizeStylesheet(css);

      // only valid block should remain
      expect(result, 'span { color: red }');
    });

    test('sanitizes multi-line declarations inside block', () {
      final css = '''
      p {
        padding: 0px
          20px;
        border: 1px
          solid
          #000;
      }
      ''';

      final result = CssSanitizer.sanitizeStylesheet(css);

      expect(result.contains('padding: 0px 20px'), true);
      expect(result.contains('border: 1px solid #000'), true);
    });

    test('drops entire block if all properties unsafe', () {
      final css = '''
      p { position:absolute; top:0 }
      ''';

      final result = CssSanitizer.sanitizeStylesheet(css);

      expect(result.isEmpty, true);
    });

    test('keeps selector but sanitizes properties', () {
      final css = '''
      div { color: red; height: 5 }
      ''';

      final result = CssSanitizer.sanitizeStylesheet(css);

      expect(result, 'div { color: red; height: 5px }');
    });

    test('trims output and removes trailing braces', () {
      final css = '''
      p { color: blue }  
      ''';

      expect(CssSanitizer.sanitizeStylesheet(css), 'p { color: blue }');
    });
  });
}
