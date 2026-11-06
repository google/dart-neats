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
  testNotContains('test', '<br>');
  testContains('test', 'test');
  testContains('a < b', '&lt;');
  testContains('a < b > c', '&gt;');
  testContains('<p>hello', 'hello');
  testContains('<p>hello', '</p>');
  testContains('<p>hello', '<p>');

  // test id filtering..
  testContains('<span id="only-allowed-id">hello</span>', 'id');
  testContains('<span id="only-allowed-id">hello</span>', 'only-allowed-id');
  testNotContains('<span id="disallowed-id">hello</span>', 'id');
  testNotContains('<span id="disallowed-id">hello</span>', 'only-allowed-id');

  // test class filtering
  testContains('<span class="only-allowed-class">hello</span>', 'class');
  testContains(
      '<span class="only-allowed-class">hello</span>', 'only-allowed-class');
  testContains('<span class="only-allowed-class disallowed-class">hello</span>',
      'class="only-allowed-class"');
  testNotContains('<span class="disallowed-class">hello</span>', 'class');
  testNotContains(
      '<span class="disallowed-class">hello</span>', 'only-allowed-class');

  testContains('<a href="test.html">hello', 'href');
  testContains('<a href="test.html">hello', 'test.html');
  testContains(
      '<a href="//example.com/test.html">hello', '//example.com/test.html');
  testContains('<a href="/test.html">hello', '/test.html');
  testContains('<a href="https://example.com/test.html">hello',
      'https://example.com/test.html');
  testContains('<a href="http://example.com/test.html">hello',
      'http://example.com/test.html');
  testContains(
      '<a href="mailto:test@example.com">hello', 'mailto:test@example.com');

  testContains('<img src="test.jpg"/>', '<img');
  testContains('<img src="test.jpg" alt="say hi"/>', 'say hi');
  testContains('<img src="test.jpg" alt="say hi"/>', 'alt=');
  testContains('<img src="test.jpg" ALt="say hi"/>', 'say hi');
  testContains('<img src="test.jpg" ALT="say hi"/>', 'alt=');
  testContains('<img src="test.jpg"/>', 'src=');
  testContains('<img src="test.jpg"/>', 'test.jpg');
  testContains('<img src="//test.jpg"/>', '//test.jpg');
  testContains('<img src="/test.jpg"/>', '/test.jpg');
  testContains('<img src="https://example.com/test.jpg"/>',
      'https://example.com/test.jpg');
  testContains('<img src="http://example.com/test.jpg"/>',
      'http://example.com/test.jpg');

  testNotContains('<img src="javascript:test.jpg"/>', 'src=');
  testNotContains('<img src="javascript:test.jpg"/>', 'javascript');
  testContains('<img src="javascript:test.jpg"/>', 'img');

  // <picture> and <source> survive sanitization, including the fallback <img>.
  // A bad URL in srcset drops only the attribute, not the element.
  testContains('<picture><img src="banner.webp"/></picture>', '<picture>');
  testContains('<picture><img src="banner.webp"/></picture>', '<img');
  testContains(
      '<picture><source srcset="dark.webp"><img src="light.webp"/></picture>',
      '<source');
  testContains('<source srcset="banner.webp">', 'srcset');
  testContains('<source srcset="banner.webp">', 'banner.webp');
  testContains(
      '<source media="(prefers-color-scheme: dark)" srcset="dark.webp">',
      'media=');
  testContains('<source srcset="a.webp 1x, b.webp 2x">', 'b.webp 2x');
  testContains('<source srcset="/img/banner.webp">', '/img/banner.webp');
  testContains('<source srcset="https://example.com/b.webp">',
      'https://example.com/b.webp');
  testNotContains('<source srcset="javascript:alert()">', 'srcset');
  testNotContains('<source srcset="javascript:alert()">', 'javascript');
  testContains('<source srcset="javascript:alert()">', '<source');
  testNotContains('<source srcset="ok.webp, javascript:alert()">', 'srcset');
  testNotContains(
      '<source srcset="ok.webp, javascript:alert()">', 'javascript');

  // A descriptor must be a width (`640w`) or density (`1.5x`); nothing else.
  testContains('<source srcset="a.webp 640w">', '640w');
  testContains('<source srcset="a.webp 1.5x">', '1.5x');
  testNotContains('<source srcset="a.webp totally-bogus">', 'srcset');
  testNotContains('<source srcset="a.webp totally-bogus">', 'totally-bogus');
  testContains('<source srcset="a.webp totally-bogus">', '<source');
  testNotContains('<source srcset="a.webp 1x 2x">', 'srcset');
  testNotContains('<source srcset="a.webp 1x, b.webp bogus">', 'srcset');

  testNotContains('<script/>', 'script');
  testNotContains('<script src="example.js"/>', 'script');
  testNotContains('<script src="example.js"/>', 'src');
  testContains('<script>alert("bad")</script> hello world', 'hello world');
  testNotContains('<script>alert("bad")</script> hello world', 'bad');
  testContains('<a href="javascript:alert()">evil link</a>', '<a');
  testNotContains('<a href="javascript:alert()">evil link</a>', 'href');
  testNotContains('<a href="javascript:alert()">evil link</a>', 'alert');
  testNotContains('<a href="javascript:alert()">evil link</a>', 'javascript');

  testNotContains('<form><input type="submit"/></form> click here', 'form');
  testNotContains('<form><input type="submit"/></form> click here', 'submit');
  testNotContains('<form><input type="submit"/></form> click here', 'input');
  testContains('<form><input type="submit"/></form> click here', 'click here');

  testContains('<br>', '<br>');
  testNotContains('<br>', '</br>');
  testContains('><', '&gt;&lt;');
  testContains('<div><div id="x">a</div></div>', '<div><div>a</div></div>');
  testContains('<a href="a.html">a</a><a href="b.html">b</a>',
      '<a href="a.html">a</a><a href="b.html">b</a>');

  // test void elements
  testContains('<strong></strong> hello', '<strong>');
  testContains('<strong></strong> hello', '</strong>');
  testNotContains('<strong></strong> hello', '<strong />');
  testContains('<br>hello</br>', '<br>');
  testNotContains('<br>hello</br>', '</br>');

  // test addLinkRel
  testContains('<a href="bad-link">hello', 'bad-link');
  testContains('<a href="bad-link">hello', 'rel="ugc nofollow"');
  testNotContains('<a href="good-link">hello', 'rel="ugc nofollow"');

  // test extra elements via union
  testContains(
      '<only-allowed-tag>hello</only-allowed-tag>', '<only-allowed-tag>');
  testContains('<only-allowed-tag>hello</only-allowed-tag>', 'hello');
  testNotContains('<disallowed-tag>hello</disallowed-tag>', 'disallowed-tag');
  testContains('<disallowed-tag>hello</disallowed-tag>', 'hello');

  // test <picture> and <source>
  testContains('<picture><img src="banner.webp"/></picture>', '<picture>');
  testContains('<picture><img src="banner.webp"/></picture>', '<img');
  testContains(
      '<picture><source srcset="dark.webp"><img src="light.webp"/></picture>',
      '<source');
  testContains('<source srcset="banner.webp">', 'srcset');
  testContains('<source srcset="banner.webp">', 'banner.webp');
  testContains(
      '<source media="(prefers-color-scheme: dark)" srcset="dark.webp">',
      'media=');
  testContains('<source srcset="a.webp 1x, b.webp 2x">', 'b.webp 2x');
  testContains('<source srcset="/img/banner.webp">', '/img/banner.webp');
  testContains('<source srcset="https://example.com/b.webp">',
      'https://example.com/b.webp');
  testNotContains('<source srcset="javascript:alert()">', 'srcset');
  testNotContains('<source srcset="javascript:alert()">', 'javascript');
  testContains('<source srcset="javascript:alert()">', '<source');
  testNotContains('<source srcset="ok.webp, javascript:alert()">', 'srcset');
  testNotContains(
      '<source srcset="ok.webp, javascript:alert()">', 'javascript');
  testContains('<source srcset="a.webp 640w">', '640w');
  testContains('<source srcset="a.webp 1.5x">', '1.5x');
  testNotContains('<source srcset="a.webp totally-bogus">', 'srcset');
  testNotContains('<source srcset="a.webp totally-bogus">', 'totally-bogus');
  testContains('<source srcset="a.webp totally-bogus">', '<source');
  testNotContains('<source srcset="a.webp 1x 2x">', 'srcset');
  testNotContains('<source srcset="a.webp 1x, b.webp bogus">', 'srcset');

  group('Content-less elements:', () {
    testNotContains('<style>body { color: red; }</style>', 'color');
    testNotContains('<textarea><img src=x onerror=alert(1)></textarea>', 'img');
    testNotContains('<title><img src=x onerror=alert(1)></title>', 'img');
    testNotContains('<xmp><img src=x onerror=alert(1)></xmp>', 'img');
    testNotContains('<iframe><script>alert(1)</script></iframe>', 'script');
    testNotContains('<noscript><img src=x onerror=alert(1)></noscript>', 'img');
    testNotContains('<template><img src=x onerror=alert(1)></template>', 'img');
    testNotContains('<svg><script>alert(1)</script></svg>', 'script');
    testNotContains(
        '<svg><style><img src=x onerror=alert(1)></style></svg>', 'img');
    testNotContains(
        '<math><annotation-xml><script>alert(1)</script></annotation-xml></math>',
        'script');
    testContains('<svg/>hello', 'hello');
    testNotContains('<svg/>hello', 'svg');
    testContains('<svg><svg></svg></svg>hello', 'hello');
    testNotContains('<svg><svg></svg></svg>hello', 'svg');
    testNotContains(
        '<plaintext>should be dropped<script>alert(1)</script>', 'dropped');
    testNotContains(
        '<script><!-- <script> alert(1); </script> --> alert(1); </script>',
        'alert');
  });

  group('Comments & declarations:', () {
    testNotContains('<!-- comment -->', 'comment');
    testNotContains('<!-- --!><img src=x onerror=alert(1)>-->', 'onerror');
    testContains('<!-->hello', 'hello');
    testContains('<!--->hello', 'hello');
    testNotContains('<!DOCTYPE html>hello', 'DOCTYPE');
    testContains('<!DOCTYPE html>hello', 'hello');
    testNotContains('<![CDATA[<script>alert(1)</script>]]>hello', 'script');
    testContains('<![CDATA[text]]>hello', 'hello');
    testNotContains('<?xml version="1.0"?>hello', 'xml');
    testContains('<?xml version="1.0"?>hello', 'hello');
  });

  group('Attribute injection & escaping:', () {
    test('Attribute quotes are safely escaped', () {
      final sanitized = sanitizeHtml(
          '<img src="a.jpg" alt="test&quot; onerror=alert(1) x=&quot;">');
      expect(sanitized, isNot(contains('" onerror=')));
      expect(sanitized, contains('alt="test&quot; onerror=alert(1) x=&quot;"'));
    });
    test('Missing whitespace between attributes', () {
      final sanitized =
          sanitizeHtml('<a title="foo"onclick="alert(1)">link</a>');
      expect(sanitized, isNot(contains('onclick')));
      expect(sanitized, contains('title="foo"'));
    });
    test('Quote injection in rel attribute is neutralized', () {
      final sanitized = configured(
          '<a href="bad-link" rel=\'ugc" onmouseover="alert(1)\'>test</a>');
      expect(sanitized, isNot(contains('onmouseover=')));
      // The host's `rel` replaces the author's.
      expect(sanitized, '<a href="bad-link" rel="ugc nofollow">test</a>');
    });
    test('< and > in attribute values are escaped', () {
      expect(
        sanitizeHtml('<a title="</a><script>">x</a>'),
        '<a title="&lt;/a&gt;&lt;script&gt;">x</a>',
      );
    });
  });

  group('Performance & complexity resistance:', () {
    test('Many ampersands without quadratic slowdown', () {
      expect(sanitizeHtml('&' * 5000), '&amp;' * 5000);
    });
    test('Deeply nested tags do not exhaust memory', () {
      final deepTags = '${'<div>' * 200}hello${'</div>' * 200}';
      expect(sanitizeHtml(deepTags), contains('hello'));
    });
    test('Many attributes and escaped script data stay linear', () {
      // Each of these took tens of seconds when the per-tag scan for `&` or
      // for `-->` ran to the end of the input.
      final stopwatch = Stopwatch()..start();
      sanitizeHtml('<b a="x">' * 30000);
      sanitizeHtml('<script><!--${'<' * 200000}');
      expect(stopwatch.elapsed, lessThan(const Duration(seconds: 5)));
    });
  });

  group('Defaults:', () {
    testContains('<a href="any-href">hey', 'href=', withConfiguration: false);
    testNotContains('<a href="any-href">hey', 'rel=', withConfiguration: false);
    testContains('<any-tag>hello</any-tag>', 'hello', withConfiguration: false);
    testNotContains('<any-tag>hello</any-tag>', 'any-tag',
        withConfiguration: false);
    testNotContains('<span id="any-id">hello</span>', 'id=',
        withConfiguration: false);
    testNotContains('<span class="any-class">hello</span>', 'class=',
        withConfiguration: false);
    testContains(
        '<a rel="nofollow noreferrer">x</a>', 'rel="nofollow noreferrer"',
        withConfiguration: false);
    testNotContains('<a rel="nofollow x-y_1">x</a>', 'rel',
        withConfiguration: false);
    testNotContains('<a rel="noopener opener">x</a>', 'rel',
        withConfiguration: false);
  });

  group('Review findings regression tests:', () {
    test('Self-closing script/style does not leak content', () {
      expect(sanitizeHtml('<script />alert("leak")</script>'), '');
      expect(sanitizeHtml('<script/src="evil.js"/>alert("leak")</script>'), '');
      expect(sanitizeHtml('<style />body { color: red; }</style>'), '');
      expect(sanitizeHtml('<textarea />secret text</textarea>'), '');
      expect(sanitizeHtml('<title />hidden title</title>'), '');
    });

    test('Responsive image srcset is preserved', () {
      expect(
        sanitizeHtml('<source srcset="pic-1x.png 1x, pic-2x.png 2x">'),
        '<source srcset="pic-1x.png 1x, pic-2x.png 2x">',
      );
      // Commas may appear inside a candidate URL.
      expect(
        sanitizeHtml(
            '<source srcset="https://cdn.example/w_100,h_100/pic.png 1x">'),
        '<source srcset="https://cdn.example/w_100,h_100/pic.png 1x">',
      );
    });

    test('Max depth nesting bounds tags without leaving unclosed output', () {
      final output = sanitizeHtml(
          '${'<div>' * 140}<div><p>deep</p></div>${'</div>' * 140}');
      // Every element is written, balanced, at most 128 deep: like Blink,
      // a start tag at the cap becomes a sibling of the innermost element.
      expect('<div>'.allMatches(output).length, 141);
      expect('</div>'.allMatches(output).length, 141);
      var depth = 0, maxDepth = 0;
      for (final tag in RegExp('</?(div|p)>').allMatches(output)) {
        depth += tag[0]!.startsWith('</') ? -1 : 1;
        maxDepth = depth > maxDepth ? depth : maxDepth;
      }
      expect(depth, 0);
      expect(maxDepth, 128);
      expect(output, contains('<p>deep</p></div>'));
    });

    test('Void elements and end tags at max depth stay consistent', () {
      // `<b>` at the cap becomes a sibling of `<p>`; the later `</p>` finds
      // no open `p` and is not written, so the browser never has to answer a
      // stray `</p>` with an extra `<p>`.
      final output = sanitizeHtml('${'<div>' * 127}<p>x<b>y<hr>z</p>w');
      expect(output, contains('<p>x</p><b>y<hr>zw</b></div>'));
    });

    test('Implied end tags stay linear for deep open stacks', () {
      final stopwatch = Stopwatch()..start();
      sanitizeHtml('${'<b>' * 40000}${'<div>' * 40000}');
      sanitizeHtml('${'<b>' * 40000}${'</i>' * 40000}');
      sanitizeHtml('${'<x>' * 40000}${'</y>' * 40000}');
      expect(stopwatch.elapsed, lessThan(const Duration(seconds: 5)));
    });

    test('xmp and plaintext close an open paragraph', () {
      final rules = RuleSet.gfm().union(RuleSet({
        'xmp': ElementRule(),
        'plaintext': ElementRule(),
      }));
      expect(sanitizeHtml('<p>a<xmp>b</xmp>c</p>', rules: rules),
          '<p>a</p><xmp></xmp>c');
      expect(sanitizeHtml('<p>a<plaintext>b', rules: rules),
          '<p>a</p><plaintext></plaintext>');
    });

    test('Multi-dash comments <!-- ---> do not swallow subsequent markup', () {
      expect(sanitizeHtml('<!-- ---><p>Visible</p>'), '<p>Visible</p>');
      expect(sanitizeHtml('<!-- ---------><p>Visible</p>'), '<p>Visible</p>');
      expect(sanitizeHtml('<!-- ---!><p>Visible</p>'), '<p>Visible</p>');
    });

    test('Repeated RAWTEXT start tags do not swallow the document', () {
      expect(sanitizeHtml('<style><style></style><p>Hello World</p>'),
          '<p>Hello World</p>');
      expect(sanitizeHtml('<textarea><textarea></textarea><p>Hello World</p>'),
          '<p>Hello World</p>');
    });

    test('Simple tokenizer handles non-tag < correctly', () {
      String sanitize(String html) =>
          sanitizeHtml(html, tokenizer: HtmlTokenizer.simple);
      expect(sanitize('a < b'), 'a &lt; b');
      expect(sanitize('<3'), '&lt;3');
      expect(sanitize('</>'), '');
      expect(sanitize('<STYLE>x</STYLE><p>y</p>'), '<p>y</p>');
    });

    test('Disallowed void elements do not swallow the rest of the document',
        () {
      expect(sanitizeHtml('<input type="text"> hello'), ' hello');
      expect(
          sanitizeHtml('<link rel="stylesheet" href="x.css">hello'), 'hello');
    });

    test('Disallowed non-void self-closing tags are unwrapped', () {
      expect(sanitizeHtml('<custom-disallowed />secret</custom-disallowed>'),
          'secret');
      expect(sanitizeHtml('<x><x/>a</x>b</x>c'), 'abc');
    });

    test('Attribute name breakout on custom elements is strictly blocked', () {
      final rules = RuleSet({'my-tag': ElementRule()});
      expect(
        sanitizeHtml('<my-tag foo"onload="alert(1)"=bar>content</my-tag>',
            rules: rules),
        '<my-tag>content</my-tag>',
      );
    });
  });

  group('Compatibility:', () {
    test('deprecated version 2 parameters still mean the same', () {
      // ignore: deprecated_member_use_from_same_package
      String s(String html) => sanitizeHtml(
            html,
            // ignore: deprecated_member_use_from_same_package
            allowElementId: (id) => id.startsWith('ok-'),
            // ignore: deprecated_member_use_from_same_package
            allowClassName: (c) => c.startsWith('ok-'),
            // ignore: deprecated_member_use_from_same_package
            addLinkRel: (href) => href.startsWith('http') ? ['ugc'] : null,
          );
      expect(s('<h2 id="ok-a" class="ok-b bad">x</h2><p id="bad">y</p>'),
          '<h2 id="ok-a" class="ok-b">x</h2><p>y</p>');
      expect(s('<a href="https://e.x/">a</a><a href="/b">b</a>'),
          '<a href="https://e.x/" rel="ugc">a</a><a href="/b">b</a>');
      // Version 2 had no <input> at all; the checkbox is gfm's, as is.
      expect(s('<input type="checkbox" id="ok-c" class="ok-d bad">'),
          '<input type="checkbox">');
      expect(s('<input type="password" class="ok-c" name="pw">x'), 'x');
      expect(
        // ignore: deprecated_member_use_from_same_package
        () => sanitizeHtml('x',
            rules: RuleSet.gfm(), allowClassName: (_) => true),
        throwsArgumentError,
      );
    });
  });
}
