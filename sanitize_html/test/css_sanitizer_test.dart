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

  group(
      'CssSanitizer.sanitizeInline – protocol-relative URL (//domain) blocking',
      () {
    test('blocks protocol-relative URL in background-image', () {
      final result = CssSanitizer.sanitizeInline(
        'background-image: url(//evil.com/a.png);',
      );

      expect(
        result.contains('background-image'),
        false,
        reason: 'background-image with protocol-relative URL must be removed',
      );
    });

    test('blocks protocol-relative URL with whitespace', () {
      final result = CssSanitizer.sanitizeInline(
        'background-image: url(   //evil.com/a.png   ); color: red;',
      );

      expect(result.contains('color: red'), true);
      expect(result.contains('background-image'), false);
    });

    test('blocks protocol-relative URL without url()', () {
      final result = CssSanitizer.sanitizeInline(
        'background: //evil.com/bg.jpg; font-size: 14px;',
      );

      expect(result.contains('background'), false);
      expect(result.contains('font-size: 14px'), true);
    });

    test('blocks mixed-case protocol-relative URL', () {
      final result = CssSanitizer.sanitizeInline(
        'background-image: url(//EVIL.com/a.png);',
      );

      expect(
        result.contains('background-image'),
        false,
        reason: 'mixed-case //EVIL.com must still be blocked',
      );
    });

    test('does not block safe http URL', () {
      final result = CssSanitizer.sanitizeInline(
        'background-image: url(http://example.com/x.png);',
      );

      expect(result, 'background-image: url(http://example.com/x.png)');
    });

    test('does not block safe https URL', () {
      final result = CssSanitizer.sanitizeInline(
        'background-image: url(https://example.com/x.png);',
      );

      expect(result, 'background-image: url(https://example.com/x.png)');
    });

    test('does not block data:image/png;base64 (safe base64)', () {
      final result = CssSanitizer.sanitizeInline(
        'background-image: url(data:image/png;base64,AAA);',
      );

      expect(result, 'background-image: url(data:image/png;base64,AAA)');
    });

    test('blocks protocol-relative URL when inside shorthand background', () {
      final result = CssSanitizer.sanitizeInline(
        'background: url(//evil.com/x.png) no-repeat center;',
      );

      expect(
        result.contains('background'),
        false,
        reason: 'Any background containing // must be removed',
      );
    });

    test('multiple declarations – only unsafe is removed', () {
      final result = CssSanitizer.sanitizeInline(
        'padding: 10px; background-image: url(//evil.com/a.png); margin: 5px;',
      );

      expect(result.contains('padding: 10px'), true);
      expect(result.contains('margin: 5px'), true);
      expect(
        result.contains('background-image'),
        false,
        reason: 'unsafe declaration should be removed without affecting others',
      );
    });

    test('protocol-relative URL with comments (obfuscation attempt)', () {
      final result = CssSanitizer.sanitizeInline(
        'background-image: url(/*x*/ //evil.com/hack.png);',
      );

      expect(
        result.contains('background-image'),
        false,
        reason: 'comments should not allow bypass of // rule',
      );
    });

    test('protocol-relative URL inside quotes', () {
      final result = CssSanitizer.sanitizeInline(
        'background-image: url("//evil.com/a.png");',
      );

      expect(
        result.contains('background-image'),
        false,
        reason: 'quoted protocol-relative URL must also be blocked',
      );
    });

    test('protocol-relative URL with escaped slashes', () {
      final result = CssSanitizer.sanitizeInline(
        r'background-image: url(\/\//evil.com/a.png);',
      );

      expect(result.contains('background-image'), false);
    });

    test('blocks Unicode-escaped slashes', () {
      final result = CssSanitizer.sanitizeInline(
        r'background-image: url(\u002F\u002Fevil.com);',
      );
      expect(result.contains('background-image'), false);
    });

    test('blocks percent-encoded protocol-relative', () {
      final result = CssSanitizer.sanitizeInline(
        'background-image: url(%2F%2Fevil.com);',
      );
      expect(result.contains('background-image'), false);
    });

    test('blocks obfuscated javascript url inside multi-token background', () {
      final result = CssSanitizer.sanitizeInline(
        'background: red url(java/**/script:alert(1)) no-repeat;',
      );

      expect(result.contains('background'), false);
    });

    test('keeps safe https url inside multi-token background', () {
      final result = CssSanitizer.sanitizeInline(
        'background: #fff url(https://example.com/bg.png) no-repeat;',
      );

      expect(
          result, 'background: #fff url(https://example.com/bg.png) no-repeat');
    });

    test('blocks malformed url without closing parenthesis', () {
      final result = CssSanitizer.sanitizeInline(
        'background: url(https://example.com/bg.png;',
      );

      expect(result.contains('background'), false);
    });
  });

  group('CssSanitizer.sanitizeInline – overflow rules', () {
    test('keeps overflow: hidden when allowed', () {
      final result = CssSanitizer.sanitizeInline(
        'overflow: hidden; white-space: nowrap;',
      );

      expect(result.contains('overflow: hidden'), true);
      expect(result.contains('white-space: nowrap'), true);
    });

    test('keeps overflow-x: scroll when allowed', () {
      final result = CssSanitizer.sanitizeInline(
        'overflow-x: scroll; color: red;',
      );

      expect(result.contains('overflow-x: scroll'), true);
      expect(result.contains('color: red'), true);
    });

    test('keeps overflow-y: auto when allowed', () {
      final result = CssSanitizer.sanitizeInline(
        'overflow-y: auto; font-size: 14px;',
      );

      expect(result.contains('overflow-y: auto'), true);
      expect(result.contains('font-size: 14px'), true);
    });

    test('removes overflow with disallowed value', () {
      final result = CssSanitizer.sanitizeInline(
        'overflow: visiblex; color: blue;',
      );

      expect(result.contains('overflow'), false,
          reason: 'Only visible/hidden/scroll/auto allowed');
      expect(result.contains('color: blue'), true);
    });

    test('removes overflow that contains expression() attack', () {
      final result = CssSanitizer.sanitizeInline(
        'overflow: expression(alert(1));',
      );

      expect(result.contains('overflow'), false);
    });

    test('removes overflow with javascript: url attack', () {
      final result = CssSanitizer.sanitizeInline(
        'overflow-x: url(javascript:alert(1));',
      );

      expect(result.contains('overflow-x'), false);
    });

    test('removes overflow with protocol-relative URL //evil.com', () {
      final result = CssSanitizer.sanitizeInline(
        'overflow: //evil.com; text-align: center;',
      );

      expect(result.contains('overflow'), false);
      expect(result.contains('text-align: center'), true);
    });

    test('keeps valid ellipsis chain overflow + white-space + text-overflow',
        () {
      final result = CssSanitizer.sanitizeInline(
        'overflow: hidden; white-space: nowrap; text-overflow: ellipsis;',
      );

      expect(result.contains('overflow: hidden'), true);
      expect(result.contains('white-space: nowrap'), true);
      expect(result.contains('text-overflow: ellipsis'), true);
    });

    test('keeps overflow: auto when multiple declarations exist', () {
      final result = CssSanitizer.sanitizeInline(
        'color: red; overflow: auto; padding: 10px;',
      );

      expect(result.contains('overflow: auto'), true);
      expect(result.contains('color: red'), true);
      expect(result.contains('padding: 10px'), true);
    });

    test('normalizes units before applying overflow rule', () {
      final result = CssSanitizer.sanitizeInline(
        'width: 100px; overflow: hidden; height: 2em;',
      );

      expect(result.contains('width: 100px'), true);
      expect(result.contains('height: 2em'), true);
      expect(result.contains('overflow: hidden'), true);
    });

    test('keeps overflow with normalized sibling properties', () {
      final result = CssSanitizer.sanitizeInline(
        'overflow: auto; max-width: 50%; padding: 10px;',
      );

      expect(result.contains('overflow: auto'), true);
      expect(result.contains('max-width: 50%'), true);
      expect(result.contains('padding: 10px'), true);
    });

    test('property order does not affect sanitize result', () {
      final resultA = CssSanitizer.sanitizeInline(
        'overflow: hidden; white-space: nowrap; text-overflow: ellipsis;',
      );

      final resultB = CssSanitizer.sanitizeInline(
        'text-overflow: ellipsis; overflow: hidden; white-space: nowrap;',
      );

      expect(resultA.contains('overflow: hidden'), true);
      expect(resultA.contains('white-space: nowrap'), true);
      expect(resultA.contains('text-overflow: ellipsis'), true);

      expect(resultB.contains('overflow: hidden'), true);
      expect(resultB.contains('white-space: nowrap'), true);
      expect(resultB.contains('text-overflow: ellipsis'), true);
    });

    test('reordering with mix of safe and unsafe properties', () {
      final out = CssSanitizer.sanitizeInline(
        'color: red; overflow: hidden; expression: test; padding: 4px;',
      );

      expect(out.contains('expression'), false);
      expect(out.contains('color: red'), true);
      expect(out.contains('padding: 4px'), true);
      expect(out.contains('overflow: hidden'), true);
    });

    test('removes overflow if value contains comment obfuscation', () {
      final result = CssSanitizer.sanitizeInline(
        'overflow: /*evil*/ hidden;',
      );
      expect(result.contains('overflow'), false,
          reason: 'Comment obfuscation must not bypass overflow value rule');
    });

    test('removes overflow if comment splits value (hidden)', () {
      final result = CssSanitizer.sanitizeInline(
        'overflow: h/*x*/idden;',
      );
      expect(result.contains('overflow'), false);
    });

    test('blocks comment-wrapped value overflow: /*x*/auto', () {
      final result = CssSanitizer.sanitizeInline(
        'overflow: /*x*/auto;',
      );
      expect(result.contains('overflow'), false);
    });

    test('blocks hidden with trailing comment overflow: hidden/*x*/', () {
      final result = CssSanitizer.sanitizeInline(
        'overflow: hidden/*x*/;',
      );
      expect(result.contains('overflow'), false);
    });

    test('does not allow comment to bypass protocol-relative // attack', () {
      final result = CssSanitizer.sanitizeInline(
        'overflow: /*x*/ //evil.com;',
      );
      expect(result.contains('overflow'), false);
    });

    test('blocks unicode escaped "hidden" (h\\0069dden)', () {
      final result = CssSanitizer.sanitizeInline(
        r'overflow: h\0069dden;',
      );

      expect(result.contains('overflow'), false);
    });

    test('blocks unicode escaped "auto" (\\0061uto)', () {
      final result = CssSanitizer.sanitizeInline(
        r'overflow: \0061uto;',
      );

      expect(result.contains('overflow'), false);
    });

    test('blocks multi-digit unicode encoding (h\\000069dden)', () {
      final result = CssSanitizer.sanitizeInline(
        r'overflow: h\000069dden;',
      );

      expect(result.contains('overflow'), false);
    });

    test('blocks hidden with zero-width space injection', () {
      final zwsp = '\u200B';
      final result = CssSanitizer.sanitizeInline(
        'overflow: h${zwsp}idden;',
      );

      expect(result.contains('overflow'), false);
    });

    test('blocks hidden with mixed zero-width chars', () {
      final zw1 = '\u200B';
      final zw2 = '\u200C';
      final zw3 = '\u200D';

      final result = CssSanitizer.sanitizeInline(
        'overflow: h${zw1}i${zw2}d${zw3}den;',
      );

      expect(result.contains('overflow'), false);
    });

    test('blocks hidden split across multiple comments h/*x*//*y*/idden', () {
      final result = CssSanitizer.sanitizeInline(
        'overflow: h/*x*//*y*/idden;',
      );

      expect(result.contains('overflow'), false);
    });

    test('blocks comment before + after + inside "auto"', () {
      final result = CssSanitizer.sanitizeInline(
        'overflow: /*a*/a/*b*/u/*c*/t/*d*/o/*e*/;',
      );

      expect(result.contains('overflow'), false);
    });

    test('blocks hidden using character reference (&#104;idden)', () {
      final result = CssSanitizer.sanitizeInline(
        'overflow: &#104;idden;',
      );

      expect(result.contains('overflow'), false);
    });

    test('blocks auto using entity (a&#117;to)', () {
      final result = CssSanitizer.sanitizeInline(
        'overflow: a&#117;to;',
      );

      expect(result.contains('overflow'), false);
    });

    test('blocks scroll using numeric entities (scr&#111;ll)', () {
      final result = CssSanitizer.sanitizeInline(
        'overflow: scr&#111;ll;',
      );

      expect(result.contains('overflow'), false);
    });

    test('blocks hybrid attack: h\\0069d/*x*/d\\0065n + zero-width', () {
      final result = CssSanitizer.sanitizeInline(
        'overflow: h\\0069d/*x*/d\\0065n\u200B;',
      );

      expect(result.contains('overflow'), false);
    });

    test('blocks //evil.com hidden behind unicode or comment', () {
      final result = CssSanitizer.sanitizeInline(
        r'overflow: /*x*/ \002F\002Fevil.com;',
      );

      expect(result.contains('overflow'), false);
    });

    test('allows case-insensitive overflow: HIDDEN', () {
      final result = CssSanitizer.sanitizeInline(
        'overflow: HIDDEN; color: red;',
      );

      expect(result.contains('overflow: HIDDEN'), true);
      expect(result.contains('color: red'), true);
    });

    test('allows case-insensitive overflow: Hidden', () {
      final result = CssSanitizer.sanitizeInline(
        'overflow: Hidden; padding: 5px;',
      );

      expect(result.contains('overflow: Hidden'), true);
      expect(result.contains('padding: 5px'), true);
    });

    test('allows case-insensitive overflow-x: AUTO', () {
      final result = CssSanitizer.sanitizeInline(
        'overflow-x: AUTO; margin: 10px;',
      );

      expect(result.contains('overflow-x: AUTO'), true);
      expect(result.contains('margin: 10px'), true);
    });

    test('allows case-insensitive overflow-y: Scroll', () {
      final result = CssSanitizer.sanitizeInline(
        'overflow-y: Scroll; width: 100px;',
      );

      expect(result.contains('overflow-y: Scroll'), true);
      expect(result.contains('width: 100px'), true);
    });

    test('allows case-insensitive overflow: VISIBLE', () {
      final result = CssSanitizer.sanitizeInline(
        'overflow: VISIBLE; height: 50px;',
      );

      expect(result.contains('overflow: VISIBLE'), true);
      expect(result.contains('height: 50px'), true);
    });

    test('blocks invalid overflow value regardless of case', () {
      final result = CssSanitizer.sanitizeInline(
        'overflow: INVALID; color: blue;',
      );

      expect(result.contains('overflow'), false);
      expect(result.contains('color: blue'), true);
    });

    test('keeps original case for inherit', () {
      final result = CssSanitizer.sanitizeInline('overflow: inherit;');
      expect(result, 'overflow: inherit');
    });

    test('keeps original case for InHeRiT', () {
      final result = CssSanitizer.sanitizeInline('overflow: InHeRiT;');
      expect(result, 'overflow: InHeRiT');
    });

    test('keeps original case for INITIAL', () {
      final result = CssSanitizer.sanitizeInline('overflow: INITIAL;');
      expect(result, 'overflow: INITIAL');
    });

    test('keeps original case for UnSeT', () {
      final result = CssSanitizer.sanitizeInline('overflow: UnSeT;');
      expect(result, 'overflow: UnSeT');
    });

    test('keeps original case for ReVeRt', () {
      final result = CssSanitizer.sanitizeInline('overflow: ReVeRt;');
      expect(result, 'overflow: ReVeRt');
    });

    test('blocks invalid "none"', () {
      final result = CssSanitizer.sanitizeInline('overflow: none;');
      expect(result.contains('overflow'), false);
    });

    test('blocks random value', () {
      final result = CssSanitizer.sanitizeInline('overflow: abcxyz;');
      expect(result.contains('overflow'), false);
    });

    test('blocks inherit obfuscated with comments', () {
      final result = CssSanitizer.sanitizeInline('overflow: in/**/her/**/it;');
      expect(result.contains('overflow'), false);
    });

    test('blocks inherit + js attempt', () {
      final result =
          CssSanitizer.sanitizeInline('overflow: inherit javascript:alert(1)');
      expect(result.contains('overflow'), false);
    });

    test('blocks ReVeRt + garbage', () {
      final result = CssSanitizer.sanitizeInline('overflow: ReVeRt xxx;');
      expect(result.contains('overflow'), false);
    });

    test('keeps casing but trims spaces', () {
      final result = CssSanitizer.sanitizeInline('  overflow :   INITIAL  ;  ');
      expect(result, 'overflow: INITIAL');
    });
  });
}
