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
import 'package:html/dom.dart' show Element, Text;
import 'package:html/parser.dart' show parseFragment;
import 'package:sanitize_html/sanitize_html.dart';
import 'package:test/test.dart';
import '../helpers.dart';

const _gfmElements = {
  'a', 'abbr', 'b', 'bdo', 'blockquote', 'br', 'caption', 'cite', 'code', //
  'dd', 'del', 'details', 'dfn', 'div', 'dl', 'dt', 'em', 'figcaption',
  'figure', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'h7', 'h8', 'hr', 'i', 'img',
  'ins', 'kbd', 'li', 'mark', 'ol', 'p', 'picture', 'pre', 'q', 'rp', 'rt',
  'ruby', 's', 'samp', 'small', 'source', 'span', 'strike', 'strong', 'sub',
  'summary', 'sup', 'table', 'tbody', 'td', 'tfoot', 'th', 'thead', 'time',
  'tr', 'tt', 'ul', 'var', 'wbr',
};

const _urlAttributes = {'cite', 'href', 'src', 'srcset'};
final _ignoredInUrls = RegExp(r'[\x00-\x20]');
final _dangerousScheme = RegExp(r'^(javascript|data|vbscript):');

const _adversarialInputs = [
  '<img src=x onerror=alert(1)>',
  '<svg><script>alert(1)</script></svg>',
  '<svg></p><style><a id="</style><img src=1 onerror=alert(1)>">',
  '<math><mtext><table><mglyph><style><img src=x onerror=alert(1)>',
  '<noscript><p title="</noscript><img src=x onerror=alert(1)>">',
  '<textarea><p title="</textarea><img src=x onerror=alert(1)>">',
  '<iframe srcdoc="<script>alert(1)</script>"></iframe>',
  '<a href="javascript&colon;alert(1)">x</a>',
  '<a href="&#x6A;avascript:alert(1)">x</a>',
  '<form><input name="attributes"><input name="attributes"></form>',
  '<<script>script>alert(1)<</script>/script>',
  '<script<script>>alert(1)</script</script>>',
  '<!--><script>alert(1)</script>-->',
  '<!-- --!><script>alert(1)</script>-->',
  '<style><img src=x onerror=alert(1)></style>',
  '<p>a &lt;img src=x onerror=alert(1)&gt; b</p>',
  '<p title="&lt;img src=x onerror=alert(1)&gt;">x</p>',
  '<div><p>unclosed <b>bold <i>italic</div>after',
  '<table><tr><td>cell<td>cell2</table>',
  '<a href="x"><a href="y">nested</a></a>',
  '<plaintext><script>alert(1)</script>',
  '<xmp><script>alert(1)</script></xmp>',
  '<template><script>alert(1)</script></template>',
  '<base href="javascript:alert(1)//"><a href="x">x</a>',
  '<body onload=alert(1)><div>x</div>',
  '<p>&amp;lt;script&amp;gt;alert(1)&amp;lt;/script&amp;gt;</p>',
  '<div title="&quot;&gt;&lt;script&gt;alert(1)&lt;/script&gt;">x</div>',
  '<img src="x" alt="a&quot; onerror=&quot;alert(1)">',
  '<a href="/x" rel="\'><script>alert(1)</script>">x</a>',
  '<my-tag foo"onload="alert(1)"=bar>content</my-tag>',
  '<a title="</a><script>alert(1)</script>">x</a>',
  '</div title="><script>alert(1)</script>"><p>x</p>',
  '<![CDATA[<script>alert(1)</script>]]>',
  '<?xml version="1.0"?><script>alert(1)</script>',
  '<b/onclick=alert(1)>x</b>',
  '<a href=`javascript:alert(1)`>x</a>',
  '<img src="data:image/svg+xml,<svg onload=alert(1)>">',
  '<img name="getElementById" src="x">',
  '<svg/>x<svg>y</svg>z',
  '<math><annotation-xml encoding="text/html"><script>alert(1)</script></annotation-xml></math>',
  '<image src=x onerror=alert(1)>',
  '<a href="https://good.com@evil.com/">x</a>',
];

void main() {
  group('Text character references:', () {
    test('references are preserved, lone ampersands escaped', () {
      for (final MapEntry(key: name, value: tokenizer) in tokenizers.entries) {
        String sanitize(String html) =>
            sanitizeHtml(html, tokenizer: tokenizer);
        // The DOM tokenizer decodes references; the result renders the same.
        final copy =
            name == 'dom' ? '\u00A9 \u00A9 \u00A9' : '&copy; &#169; &#xA9;';
        expect(sanitize('&amp; &lt;b&gt; &copy; &#169; &#xA9;'),
            '&amp; &lt;b&gt; $copy',
            reason: name);
        expect(sanitize('a & b &; c &&amp; e &'),
            'a &amp; b &amp;; c &amp;&amp; e &amp;',
            reason: name);
        // Double-encoded input stays double-encoded (no double decoding).
        expect(sanitize('&amp;lt;b&amp;gt;'), '&amp;lt;b&amp;gt;',
            reason: name);
      }
    });
    test('unknown and invalid references are left for the browser', () {
      expect(sanitizeHtml('&bogus; &#0000; &#xD800; &#x1010FFFF;'),
          '&bogus; &#0000; &#xD800; &#x1010FFFF;');
    });
  });

  group('Attribute character references:', () {
    test('named and numeric references are decoded', () {
      expect(sanitizeHtml('<a title="&rarr; &#8594; &#x2192; &amp;lt;">x</a>'),
          '<a title="\u2192 \u2192 \u2192 &amp;lt;">x</a>');
    });
    test('legacy references without semicolon follow browser rules', () {
      expect(sanitizeHtml('<a title="&copy 2024 &copy;2024">x</a>'),
          '<a title="\u00A9 2024 \u00A92024">x</a>');
      // Not decoded before `=` or an alphanumeric, so query strings survive.
      expect(sanitizeHtml('<a href="/?a=1&copy=2&notit=3">x</a>'),
          '<a href="/?a=1&amp;copy=2&amp;notit=3">x</a>');
    });
    test('invalid numeric references become U+FFFD', () {
      expect(sanitizeHtml('<a title="&#0;&#xD800;&#x110000;">x</a>'),
          '<a title="\uFFFD\uFFFD\uFFFD">x</a>');
      expect(sanitizeHtml('<a title="&#x80;&#150;">x</a>'),
          '<a title="\u20AC\u2013">x</a>');
    });
  });

  test('dom tokenizer survives numeric character references beyond 2^63', () {
    expect(
        sanitizeHtml('a&#9223372036854775808;b&#x10000000000000000;c',
            tokenizer: HtmlTokenizer.dom),
        'a&#9223372036854775808;b&#x10000000000000000;c');
  });

  group('All tokenizers:', () {
    for (final MapEntry(key: name, value: tokenizer) in tokenizers.entries) {
      String sanitize(String html) => sanitizeHtml(html, tokenizer: tokenizer);

      test('$name: basic sanitization', () {
        expect(
          sanitize(
              '<div><p>Hello <a href="https://example.com" onclick="alert(1)">World</a></p></div>'),
          '<div><p>Hello <a href="https://example.com">World</a></p></div>',
        );
        expect(
            sanitize('<a href="javascript:alert(1)">evil</a>'), '<a>evil</a>');
        expect(sanitize('<script>alert("secret")</script>hello'), 'hello');
        expect(sanitize('<div><p>unclosed paragraph'), endsWith('</p></div>'));
        expect(sanitize('<svg/>x<svg>y</svg>z'), 'xyz');
      });

      test('$name: output re-parses to allowed elements only', () {
        // Property check with an independent HTML5 parser: whatever the
        // tokenizer did, the output must only contain allowed elements and
        // attributes with safe URLs, and must be stable under re-sanitizing
        // and under re-parsing (no mutation XSS).
        for (final input in _adversarialInputs) {
          final output = sanitize(input);
          final reason = '$name: "$input" -> "$output"';
          expect(sanitize(output), output, reason: reason);
          final fragment = parseFragment(output);
          final stack = [...fragment.nodes];
          while (stack.isNotEmpty) {
            final node = stack.removeLast();
            if (node is Element) {
              expect(_gfmElements, contains(node.localName), reason: reason);
              for (final MapEntry(:key, :value) in node.attributes.entries) {
                final attribute = key.toString();
                expect(attribute, isNot(startsWith('on')), reason: reason);
                if (_urlAttributes.contains(attribute)) {
                  // Browsers ignore these characters when parsing a scheme.
                  final url =
                      value.replaceAll(_ignoredInUrls, '').toLowerCase();
                  expect(url, isNot(matches(_dangerousScheme)), reason: reason);
                }
              }
            } else {
              expect(node, isA<Text>());
            }
            stack.addAll(node.nodes);
          }
          // Serializing and re-parsing the output's DOM must not change it.
          final serialized = fragment.outerHtml;
          expect(parseFragment(serialized).outerHtml, serialized,
              reason: reason);
        }
      });
    }
  });
}
