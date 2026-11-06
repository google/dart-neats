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

void main() {
  group('RuleSet:', () {
    test('rejects names the writer cannot write', () {
      for (final name in ['', 'DIV', 'a b', 'a>', 'image']) {
        expect(() => RuleSet({name: ElementRule()}), throwsArgumentError,
            reason: name);
        expect(() => RuleSet.unsafe({name: ElementRule()}), throwsArgumentError,
            reason: name);
      }
      for (final name in ['Title', 'a"b', 'on click', '1x']) {
        expect(
            () => RuleSet({
                  'span': ElementRule(attributes: {name: AttributeRule.any()})
                }),
            throwsArgumentError,
            reason: name);
      }
    });

    test('grant assertions refuse dangerous elements', () {
      for (final tag in [
        'script', 'style', 'base', 'meta', 'link', 'html', 'head', 'body', //
        'frameset', 'frame', 'form', 'object', 'embed', 'applet', 'isindex',
        'noscript', 'noembed', 'noframes', 'svg', 'math',
      ]) {
        expect(() => RuleSet({tag: ElementRule()}), throwsUnsupportedError,
            reason: tag);
        RuleSet.unsafe({tag: ElementRule()}); // Does not throw.
      }
      // Rendering-only oddities are allowed.
      RuleSet({
        for (final t in ['plaintext', 'xmp', 'template']) t: ElementRule()
      });
      // `allow` delegates the host's permissions.
      expect(
          () => RuleSet(const {}, exemptions: [
                ElementPattern('iframe', match: {
                  'src': AttributeRule.url(),
                  'sandbox': AttributeRule.any(),
                  'allow': AttributeRule.any(),
                }),
              ]),
          throwsUnsupportedError);
      // An iframe only as an exemption that matches sandbox.
      expect(() => RuleSet({'iframe': ElementRule()}), throwsUnsupportedError);
      expect(
          () => RuleSet(const {}, exemptions: [
                ElementPattern('iframe', match: {'src': AttributeRule.url()}),
              ]),
          throwsUnsupportedError);
      RuleSet(const {},
          exemptions: [ElementPattern.iframe(where: (_) => true, sandbox: {})]);
      RuleSet.unsafe({'iframe': ElementRule()}); // Does not throw.
    });

    test('grant assertions refuse dangerous attributes', () {
      for (final attribute in [
        'onclick', 'onerror', 'style', 'srcdoc', 'is', 'form', 'formaction', //
        'formtarget', 'ping', 'attributionsrc',
      ]) {
        final rule = ElementRule(attributes: {attribute: AttributeRule.any()});
        expect(() => RuleSet({'div': rule}), throwsUnsupportedError,
            reason: attribute);
        RuleSet.unsafe({'div': rule});
      }
    });

    test('grant assertions require the URL policy on URL attributes', () {
      for (final attribute in [
        'href', 'src', 'cite', 'action', 'poster', 'data', 'xlink:href', //
        'background', 'longdesc',
      ]) {
        for (final rule in [
          AttributeRule.any(),
          AttributeRule.where((_) => true),
          AttributeRule.srcset(),
        ]) {
          expect(
              () => RuleSet({
                    'x': ElementRule(attributes: {attribute: rule})
                  }),
              throwsUnsupportedError,
              reason: attribute);
        }
        RuleSet({
          'x': ElementRule(attributes: {attribute: AttributeRule.url()})
        });
        RuleSet({
          'x': ElementRule(
              attributes: {attribute: AttributeRule.url((_) => true)})
        });
      }
      expect(
          () => RuleSet({
                'img': ElementRule(attributes: {'srcset': AttributeRule.url()})
              }),
          throwsUnsupportedError);
      RuleSet({
        'img': ElementRule(attributes: {'srcset': AttributeRule.srcset()})
      });
      // `rel` only through AttributeRule.rel: `opener` must stay ungrantable.
      expect(
          () => RuleSet({
                'a': ElementRule(attributes: {'rel': AttributeRule.any()})
              }),
          throwsUnsupportedError);
      final rel = RuleSet({
        'a': ElementRule(attributes: {
          'href': AttributeRule.url(),
          'rel': AttributeRule.rel(),
        })
      });
      String s(String html) => sanitizeHtml(html, rules: rel);
      expect(s('<a href="/x" rel="NoFollow me">y</a>'),
          '<a href="/x" rel="NoFollow me">y</a>');
      expect(
          s('<a href="/x" rel="nofollow opener">y</a>'), '<a href="/x">y</a>');
      expect(s('<a href="/x" rel="">y</a>'), '<a href="/x">y</a>');
      expect(
          sanitizeHtml('<a href="/x" rel="ugc me">y</a>',
              rules: RuleSet({
                'a': ElementRule(attributes: {
                  'href': AttributeRule.url(),
                  'rel': AttributeRule.rel((t) => t.contains('ugc')),
                })
              })),
          '<a href="/x" rel="ugc me">y</a>');
    });

    test('grant assertions survive union, without and restrict', () {
      final checked = RuleSet({
        'a': ElementRule(attributes: {'href': AttributeRule.url()})
      });
      final unsafe = RuleSet.unsafe({
        'a': ElementRule(attributes: {'href': AttributeRule.any()})
      });
      // Restricting with anything keeps the URL policy; a union with an
      // unsafe set is unsafe.
      expect(
          sanitizeHtml('<a href="javascript:alert(1)">x</a>',
              rules: checked.restrict(
                  'a', ElementRule(attributes: {'href': AttributeRule.any()}))),
          '<a>x</a>');
      expect(
          sanitizeHtml('<a href="javascript:alert(1)">x</a>',
              rules: checked.union(unsafe)),
          '<a href="javascript:alert(1)">x</a>');
      expect(
          sanitizeHtml('<a href="javascript:alert(1)">x</a>',
              rules: checked.union(unsafe).without({'a'})),
          'x');
    });

    test('rule sets do not alias the caller\'s maps', () {
      final attributes = <String, AttributeRule>{'title': AttributeRule.any()};
      final match = <String, AttributeRule>{'type': AttributeRule.any()};
      final rules = RuleSet({
        'b': ElementRule(attributes: attributes)
      }, exemptions: [
        ElementPattern('input', match: match),
      ]);
      attributes['onclick'] = AttributeRule.any();
      match['onclick'] = AttributeRule.any();
      expect(sanitizeHtml('<b onclick="x" title="t">y</b>', rules: rules),
          '<b title="t">y</b>');
      expect(sanitizeHtml('<input type="t" onclick="x">', rules: rules),
          '<input type="t">');
    });

    test('unsafe rule sets really are unsafe, but still well-formed', () {
      final rules = RuleSet.unsafe({
        'div': ElementRule(attributes: {'onclick': AttributeRule.any()}),
      });
      expect(sanitizeHtml('<div onclick="x<y">a</div>', rules: rules),
          '<div onclick="x&lt;y">a</div>');
    });

    test('ElementRule allows no attributes by default', () {
      final rules = RuleSet({'b': ElementRule()});
      expect(sanitizeHtml('<b title="x" class="y">a</b>', rules: rules),
          '<b>a</b>');
    });

    test('attribute rules', () {
      final rules = RuleSet({
        'a': ElementRule(attributes: {
          'href': AttributeRule.url((u) => u.host == 'example.com'),
          'title': AttributeRule.where((v) => v.length < 5),
          'data-x': AttributeRule.any(),
        }),
        'img': ElementRule(attributes: {
          'srcset': AttributeRule.srcset(
              (urls) => urls.every((u) => u.host == 'example.com')),
        }),
      });
      String s(String html) => sanitizeHtml(html, rules: rules);
      expect(s('<a href="https://example.com/x">a</a>'),
          '<a href="https://example.com/x">a</a>');
      expect(s('<a href="https://evil.com/x">a</a>'), '<a>a</a>');
      expect(s('<a href="/relative">a</a>'), '<a>a</a>'); // host is ''.
      expect(s('<a href="javascript:alert(1)">a</a>'), '<a>a</a>');
      expect(s('<a title="1234">a</a>'), '<a title="1234">a</a>');
      expect(s('<a title="12345">a</a>'), '<a>a</a>');
      expect(s('<a data-x="&lt;">a</a>'), '<a data-x="&lt;">a</a>');
      expect(s('<img srcset="https://example.com/a 1x, //example.com/b 2x">'),
          '<img srcset="https://example.com/a 1x, //example.com/b 2x">');
      expect(s('<img srcset="https://example.com/a 1x, //evil.com/b 2x">'),
          '<img>');
      // A URL runs to the next whitespace, commas included, as in a browser.
      expect(s('<img srcset="https://example.com,evil.com/a 1x">'), '<img>');
      expect(s('<img srcset="https://example.com/a 1x,//example.com/b 2x">'),
          '<img srcset="https://example.com/a 1x,//example.com/b 2x">');
    });

    test('url(where) sees the host the browser will use', () {
      final rules = RuleSet({
        'a': ElementRule(attributes: {
          'href': AttributeRule.url((u) => u.host != 'evil.com'),
        }),
      });
      String s(String html) => sanitizeHtml(html, rules: rules);
      // Forms where RFC 3986 and the WHATWG URL parser find different hosts
      // are refused rather than passed to `where` with a misleading `Uri`.
      for (final href in [
        'https:evil.com/x',
        'https:/evil.com/x',
        'https:///evil.com/x',
        'https://e%76il.com/',
        'https://good.com@evil.com/',
        r'https:\\evil.com/',
        'https://',
        'https:',
      ]) {
        expect(s('<a href="$href">a</a>'), '<a>a</a>', reason: href);
      }
      expect(s('<a href="https://good.com/x">a</a>'),
          '<a href="https://good.com/x">a</a>');
      expect(s('<a href="mailto:x@evil.com">a</a>'),
          '<a href="mailto:x@evil.com">a</a>');
      // Only ASCII whitespace is stripped; U+00A0 makes it a relative URL
      // for the browser and an unknown scheme for the policy.
      expect(s('<a href="\u00A0https://good.com/">a</a>'), '<a>a</a>');
      expect(s('<a href="  https://good.com/ ">a</a>'),
          '<a href="  https://good.com/ ">a</a>');
    });

    test('union keeps elements and attributes allowed by either', () {
      final a = RuleSet({
        'b': ElementRule(attributes: {
          'title': AttributeRule.where((v) => v == 'a'),
        }),
        'i': ElementRule(),
      });
      final b = RuleSet({
        'b': ElementRule(attributes: {
          'title': AttributeRule.where((v) => v == 'b'),
          'lang': AttributeRule.any(),
        }),
        'u': ElementRule(),
      });
      String s(String html) => sanitizeHtml(html, rules: a.union(b));
      expect(s('<i>x</i><u>y</u>'), '<i>x</i><u>y</u>');
      expect(s('<b title="a">x</b>'), '<b title="a">x</b>');
      expect(s('<b title="b">x</b>'), '<b title="b">x</b>');
      expect(s('<b title="c" lang="en">x</b>'), '<b lang="en">x</b>');
    });

    test('without removes elements, rule and exemptions alike', () {
      String s(String html) =>
          sanitizeHtml(html, rules: RuleSet.gfm().without({'img', 'input'}));
      expect(s('<p><img src="/x" alt="a">b</p>'), '<p>b</p>');
      expect(s('<input type="checkbox">c'), 'c');
      expect(s('<b>d</b>'), '<b>d</b>');
      // Removing what is not there is nothing.
      expect(sanitizeHtml('<b>d</b>', rules: RuleSet.gfm().without({'nope'})),
          '<b>d</b>');
    });

    test('restrict narrows named attributes and leaves the rest alone', () {
      final rules = RuleSet.gfm().restrict(
          'a',
          ElementRule(attributes: {
            'href': AttributeRule.url((u) => u.host == 'pub.dev'),
          }));
      String s(String html) => sanitizeHtml(html, rules: rules);
      expect(s('<a href="https://pub.dev/x" title="t" rel="nofollow">y</a>'),
          '<a href="https://pub.dev/x" title="t" rel="nofollow">y</a>');
      expect(s('<a href="https://evil.example/" title="t">y</a>'),
          '<a title="t">y</a>');
      // Other elements and exemptions are untouched.
      expect(s('<input type="checkbox"><b title="t">z</b>'),
          '<input type="checkbox"><b title="t">z</b>');
      // AND with never removes an attribute.
      expect(
          sanitizeHtml('<b title="t">z</b>',
              rules: RuleSet.gfm().restrict(
                  'b',
                  ElementRule(attributes: {
                    'title': AttributeRule.where((_) => false)
                  }))),
          '<b>z</b>');
      // A restriction can only narrow: what has no rule stays without one.
      expect(
          sanitizeHtml('<iframe src="https://x/"></iframe><b nope="1">z</b>',
              rules: RuleSet.gfm().restrict('iframe', ElementRule()).restrict(
                  'b', ElementRule(attributes: {'nope': AttributeRule.any()}))),
          '<b>z</b>');
    });

    test('elements without a rule are unwrapped, not dropped', () {
      expect(sanitizeHtml('<b><x>a<y>b</y>c</x></b>'), '<b>abc</b>');
      // Content the browser never renders as text is not kept either.
      expect(
          sanitizeHtml('<script>a</script><style>b</style><template>c'
              '</template><textarea>d</textarea>'),
          '');
    });

    test('closing an unwrapped element closes what was opened inside it', () {
      for (final tokenizer in [HtmlTokenizer.streaming, HtmlTokenizer.simple]) {
        String s(String html) => sanitizeHtml(html, tokenizer: tokenizer);
        // A browser would also reopen the <a> around " text" (adoption
        // agency); HtmlTokenizer.dom does.
        expect(s('<x><a href="https://e.x/">link</x> text</a><p>more</p>'),
            '<a href="https://e.x/">link</a> text<p>more</p>');
        // A special element (div) above the unwrapped one shields it.
        expect(s('<x><div>in</x>after</div><p>more</p>'),
            '<div>inafter</div><p>more</p>');
      }
    });

    test('a pattern keeps an exact form, judged on the element as written', () {
      final rules = RuleSet(const {}, exemptions: [
        ElementPattern('input', match: {
          'type': AttributeRule.where((v) => v == 'checkbox'),
        }, attributes: {
          'checked': AttributeRule.any(),
        }),
      ]);
      String s(String html) => sanitizeHtml(html, rules: rules);
      expect(s('<input type="checkbox" checked value="x">'),
          '<input type="checkbox" checked="">');
      expect(s('<input type="text">x'), 'x');
      expect(s('<input>x'), 'x');
      // The end tag of an unwrapped element goes with it.
      final div = RuleSet({
        'div': ElementRule(attributes: {'title': AttributeRule.any()})
      }, exemptions: [
        ElementPattern('div', match: {'lang': AttributeRule.any()}),
      ]);
      String d(String html) => sanitizeHtml(html, rules: div);
      expect(d('<div lang="en" title="t"><div title="u">x</div>y</div>'),
          '<div lang="en"><div title="u">x</div>y</div>');
      expect(
        () => RuleSet(const {}, exemptions: [
          ElementPattern('iframe', match: {'src': AttributeRule.any()}),
        ]),
        throwsUnsupportedError,
      );
    });

    test('patterns take precedence over the rule, first match first', () {
      final rules = RuleSet({
        'a': ElementRule(attributes: {
          'href': AttributeRule.url(),
          'title': AttributeRule.any(),
        }),
      }, exemptions: [
        ElementPattern('a', match: {
          'href': AttributeRule.url((u) => u.host == 'a.example'),
        }, attributes: {
          'target': AttributeRule.where((v) => v == '_blank')
        }),
        ElementPattern('a', match: {
          'href': AttributeRule.url((u) => u.host == 'a.example'),
        }, attributes: {
          'title': AttributeRule.any()
        }),
      ]);
      String s(String html) => sanitizeHtml(html, rules: rules);
      // The first pattern decides: `target` kept, `title` not.
      expect(s('<a href="https://a.example/" title="t" target="_blank">x</a>'),
          '<a href="https://a.example/" target="_blank">x</a>');
      // No pattern matches: the rule decides.
      expect(s('<a href="https://b.example/" title="t" target="_blank">x</a>'),
          '<a href="https://b.example/" title="t">x</a>');
    });

    test('union keeps the exemptions of both, this rule set first', () {
      final a = RuleSet(const {}, exemptions: [
        ElementPattern('iframe', match: {
          'src': AttributeRule.url((u) => u.host == 'a.example'),
          'sandbox': AttributeRule.where((v) => v == 'allow-scripts'),
        }),
      ]);
      final b = RuleSet(const {}, exemptions: [
        ElementPattern('iframe', match: {
          'src': AttributeRule.url((u) => u.host == 'b.example'),
          'sandbox': AttributeRule.where((v) => v == ''),
        }, attributes: {
          'width': AttributeRule.any()
        }),
      ]);
      String s(String html) => sanitizeHtml(html, rules: a.union(b));
      expect(s('<iframe src="https://a.example/" sandbox="allow-scripts">'),
          '<iframe src="https://a.example/" sandbox="allow-scripts"></iframe>');
      expect(s('<iframe src="https://b.example/" sandbox width="1">'),
          '<iframe src="https://b.example/" sandbox="" width="1"></iframe>');
      // Neither pattern matches; nothing is borrowed from the other.
      expect(s('<iframe src="https://a.example/"></iframe>x'), 'x');
      expect(
          s('<iframe src="https://b.example/" sandbox="allow-scripts">'), '');
    });

    test('a rule in a union does not loosen a pattern', () {
      final pattern = RuleSet(const {}, exemptions: [
        ElementPattern('iframe', match: {
          'src': AttributeRule.url((u) => u.host == 'a.example'),
          'sandbox': AttributeRule.where((v) => v == 'allow-scripts'),
        }),
      ]);
      final rule = RuleSet.unsafe({
        'iframe': ElementRule(attributes: {'width': AttributeRule.any()}),
      });
      for (final rules in [pattern.union(rule), rule.union(pattern)]) {
        String s(String html) => sanitizeHtml(html, rules: rules);
        expect(s('<iframe src="https://a.example/" width="1">'),
            '<iframe width="1"></iframe>');
        expect(s('<iframe src="https://a.example/" sandbox="allow-scripts">'),
            '<iframe src="https://a.example/" sandbox="allow-scripts"></iframe>');
      }
    });

    test('withExemptions adds exemptions after the rule set\'s own', () {
      String s(String html) => sanitizeHtml(html,
          rules: RuleSet.html().withExemptions([ElementPattern.checkbox()]));
      expect(s('<input type="checkbox" checked disabled value="x">'),
          '<input type="checkbox" checked="" disabled="">');
      expect(s('<input type="text">x'), 'x');
    });

    test('an attribute cannot be both matched and optional', () {
      expect(
        () => ElementPattern('b',
            match: {'title': AttributeRule.any()},
            attributes: {'title': AttributeRule.any()}),
        throwsArgumentError,
      );
    });

    test('a pattern copes with an element without attributes', () {
      final rules = RuleSet(const {}, exemptions: [
        ElementPattern('b', match: const {}),
      ]);
      expect(sanitizeHtml('<b>x</b>', rules: rules), '<b>x</b>');
    });

    test('ElementPattern.iframe keeps embeds from the given origin only', () {
      String s(String html) => sanitizeHtml(
            html,
            rules: RuleSet.gfm().withExemptions([
              ElementPattern.iframe(
                where: (src) =>
                    src.host == 'www.youtube.com' &&
                    src.path.startsWith('/embed/'),
                sandbox: {'allow-scripts', 'allow-same-origin'},
              ),
            ]),
            rewriters: [
              // Tokens in any order and case, as the browser reads them.
              HtmlRewriter.rewriteAttributes(
                  tagName: 'iframe',
                  (a) => a['sandbox'] = 'Allow-Same-Origin allow-scripts'),
            ],
          );
      expect(
        s('<iframe src="https://www.youtube.com/embed/x" width="560" '
            'allow="camera" name="n" allowfullscreen></iframe>'),
        '<iframe src="https://www.youtube.com/embed/x" width="560" '
        'allowfullscreen="" sandbox="Allow-Same-Origin allow-scripts">'
        '</iframe>',
      );
      expect(
          s('<iframe src="https://www.youtube.com/watch?v=x"></iframe>a'), 'a');
      expect(s('<iframe src="https://evil.example/embed/x"></iframe>a'), 'a');
    });
  });
}
