// Copyright 2019 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
import 'package:sanitize_html/sanitize_html.dart';
import 'package:test/test.dart';
import 'helpers.dart';

void main() {
  group('DOMPurify adversarial test cases:', () {
    testNotContains('<a href="javascript   :alert(1)">foo</a>', 'href');
    testNotContains('<a href="javascript :alert(1)">foo</a>', 'href');
    testNotContains('<a href="java\x00script:alert(1)">foo</a>', 'href');
    testNotContains('<a href="java%00script:alert(1)">foo</a>', 'href');
    testNotContains('<a href="&#14;  javascript:alert(1)">foo</a>', 'href');
    testNotContains('<a href="\u2028javascript:alert(1)">foo</a>', 'href');
    testNotContains('<a href="\uFEFFjavascript:alert(1)">foo</a>', 'href');
    testNotContains('<a href="&#x200B;javascript:alert(1)">foo</a>', 'href');
    testNotContains('<a href="&#xA0;javascript:alert(1)">foo</a>', 'href');
    testNotContains('<a href="&#x1680;javascript:alert(1)">foo</a>', 'href');
    testNotContains('<a href="&#x3000;javascript:alert(1)">foo</a>', 'href');
    testNotContains('<a href="data:,evilnastystuff">foo</a>', 'href');
    testNotContains(
        '<a href="data:text/html,<script>alert(1)</script>">foo</a>', 'href');
    testNotContains(
        '<img src="data:image/svg+xml,<svg onload=alert(1)>">', 'data:');
    testNotContains(
        '<form onmouseover="alert(1)"><input name="attributes"><input name="attributes">',
        'onmouseover');
    testNotContains('<img src=x onerror=alert(1)>', 'onerror');
    // `name` is a clobbering surface like `id`; gfm drops it.
    testNotContains('<a name="anchor">top</a>', 'name=');
    testNotContains(
        '<div onclick=alert(0)><form onsubmit=alert(1)><input onfocus=alert(2) name=parentNode>123</form></div>',
        'on');
    testNotContains('<details ontoggle="alert(1)">foo</details>', 'ontoggle');
    testNotContains(
        '<div onanimationstart="alert(1)">foo</div>', 'onanimationstart');
    testContains(
        '<div aria-labelledby="msg--title"><span aria-label="close">close</span></div>',
        'aria-label="close"',
        withConfiguration: false);
    testNotContains(r'''<a href="javascript:alert('XSS');">foo</a>''', 'href');
    testNotContains(
        r'''<a href="javascript    :   alert('XSS');">foo</a>''', 'href');
  });

  group('package:html & html5lib test cases:', () {
    testNotContains(
        '<svg><style>&lt;img src=x onerror=alert(1)&gt;</style></svg>',
        'onerror');
    testNotContains(
        '<math><iframe>&lt;img src=x onerror=alert(1)&gt;</iframe></math>',
        'onerror');
    testNotContains(
        '<svg><xmp>&lt;img src=x onerror=alert(1)&gt;</xmp></svg>', 'onerror');
    testContains('&;', '&amp;;');
    testContains('<a href="http://example.com?a=1&b=2">link</a>',
        'href="http://example.com?a=1&amp;b=2"');
    testContains('<p a="&">link</p>', 'link');
    test('Non-void element self-closing <div/>', () {
      expect(sanitizeHtml('<div/>hello</div>'), '<div>hello</div>');
    });
    test('Void element self-closing <br/>', () {
      expect(sanitizeHtml('<br/>'), '<br>');
      expect(sanitizeHtml('<br foo="bar"/>'), '<br>');
    });
    test('Unescaped </ and stray tags', () {
      expect(sanitizeHtml('</'), '&lt;/');
      expect(sanitizeHtml('</1>'), '');
      expect(sanitizeHtml('</>'), '');
      expect(sanitizeHtml('<>'), '&lt;&gt;');
    });
  });

  group('parse5 & browser tokenizer edge cases:', () {
    testNotContains(
        '<script/xss src="http://xx.com/xss.js"></script>', 'script');
    testNotContains('<script/src="http://xx.com/xss.js"></script>', 'script');
    testNotContains('<b/onclick=alert(1)>bold</b>', 'onclick');
    testContains('<b/onclick=alert(1)>bold</b>', '<b>bold</b>');
    testContains('<A HREF="http://example.com">foo</A>',
        '<a href="http://example.com">foo</a>');
    testContains('<DIV>hello</DIV>', '<div>hello</div>');
    testContains('<img src=http://example.com/pic.png>',
        '<img src="http://example.com/pic.png">');
    // A `/` in an unquoted attribute value is part of the value.
    testContains('<img src=http://example.com/pic.png/>',
        '<img src="http://example.com/pic.png/">');
    testNotContains('<a href=`javascript:alert(1)`>foo</a>', 'href');
    testNotContains('<img src=`javascript:alert(1)`>', 'src');
    testNotContains('<img src="javascript:alert(1)"', 'javascript');
    testNotContains('<script src="http://xss.rocks/xss.js"', 'script');
    testNotContains('<<SCRIPT>alert("XSS");//<</SCRIPT>', 'alert');
    testNotContains('<IMG """><SCRIPT>alert("XSS")</SCRIPT>">', 'alert');
    testNotContains('<SCRIPT SRC=http://xss.rocks/xss.js?<B>', 'script');
    testNotContains('<a href="jav\tascript:alert(1)">foo</a>', 'href');
    testNotContains('<a href="jav\nascript:alert(1)">foo</a>', 'href');
    testNotContains('<a href="jav\rascript:alert(1)">foo</a>', 'href');
    testNotContains(
        '<a href="&#x6A&#x61&#x76&#x61&#x73&#x63&#x72&#x69&#x70&#x74&#x3A&#x61&#x6C&#x65&#x72&#x74&#x28&#x27&#x58&#x53&#x53&#x27&#x29">foo</a>',
        'href');
    test('Unterminated tags at EOF produce no element', () {
      expect(sanitizeHtml('x<y'), 'x');
      expect(sanitizeHtml('<y'), '');
      expect(sanitizeHtml('text<a href="x"'), 'text');
    });
    test('End tags may carry (ignored) quoted attributes', () {
      expect(sanitizeHtml('</div title=">"><p>content</p>'), '<p>content</p>');
    });
  });

  group('Mozilla Bleach test suite cases:', () {
    test('Idempotency: clean(clean(x)) == clean(x)', () {
      final cases = [
        'a < b',
        'link http://link.com',
        'text<em>',
        '<span>text & </span>',
        'jim &current joe',
        '&&nbsp; &nbsp;&',
        'jim &xx; joe',
        '<a href="http://example.com?foo=bar&bar=foo&amp;biz=bash">test</a>',
        '<img src="http://example.com?foo=bar&bar=foo&amp;biz=bash">',
        'an <strong>allowed</strong> tag',
        '<p>One<p>Two',
        '<div><p>Paragraph</p></div>',
        '&amp;lt;b&amp;gt; &#x27; &#39; &bogus; & &# &#; &amp',
        '<a title="&quot;&amp;&lt;">x</a>',
      ];
      for (final MapEntry(key: name, value: tokenizer) in tokenizers.entries) {
        String sanitize(String html) =>
            sanitizeHtml(html, tokenizer: tokenizer);
        for (final c in cases) {
          final once = sanitize(c);
          expect(sanitize(once), once, reason: 'Not idempotent: "$c" ($name)');
        }
      }
    });

    test('Unclosed tags', () {
      expect(sanitizeHtml('a <em>fixed tag'), 'a <em>fixed tag</em>');
      expect(sanitizeHtml('<script src=http://xx.com/xss.js<b>'), '');
      expect(sanitizeHtml('<script src="http://xx.com/xss.js"<b>'), '');
      expect(sanitizeHtml('<script src="http://xx.com/xss.js" <b>'), '');
    });

    test('Nested script tags', () {
      // Script content is never text; what is left is escaped text.
      final result1 = sanitizeHtml('<<script>script>evil()<</script>/script>');
      expect(result1, contains('&lt;'));
      expect(result1, isNot(contains('evil')));

      final result2 = sanitizeHtml('<<x>script>evil()<</x>/script>');
      expect(result2, contains('&lt;'));
      expect(result2, isNot(contains('<script')));

      final result3 = sanitizeHtml('<script<script>>evil()</script</script>>');
      expect(result3, isNot(contains('<script')));
    });

    test('Bare entities get escaped correctly', () {
      expect(sanitizeHtml('an & entity'), 'an &amp; entity');
      expect(sanitizeHtml('an < entity'), 'an &lt; entity');
      expect(sanitizeHtml('tag < <em>and</em> entity'),
          'tag &lt; <em>and</em> entity');
      expect(sanitizeHtml('x < y'), 'x &lt; y');
      expect(sanitizeHtml('< y'), '&lt; y');
    });

    test('Comments with surrounding text', () {
      expect(sanitizeHtml('<!-- comment -->text'), 'text');
      expect(sanitizeHtml('<!--comment-->text'), 'text');
      expect(sanitizeHtml('text<!-- comment -->'), 'text');
      expect(sanitizeHtml('text<!--comment-->'), 'text');
      expect(sanitizeHtml('<!-- open comment'), '');
    });
  });
}
