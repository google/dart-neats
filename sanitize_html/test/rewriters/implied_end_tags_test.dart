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
import 'dart:math';

import 'package:test/test.dart';

import '../helpers.dart';

void main() {
  group('HtmlRewriter.impliedEndTags:', () {
    testContains('<p>hello', '</p>');
    testContains('<div><p>Unclosed paragraph at EOF', '</p></div>');
    test('Stray closing tags are dropped', () {
      expect(sanitizeHtml('<div>hello</div></div></div>'), '<div>hello</div>');
    });
    test('Non-void self-closing tags stay open', () {
      expect(sanitizeHtml('<div />hello</div>'), '<div>hello</div>');
    });
    test('<p> is auto-closed by block-level element', () {
      expect(sanitizeHtml('<p>paragraph<div>block</div></p>'),
          '<p>paragraph</p><div>block</div>');
    });
    test('Nested <a> tags are auto-closed', () {
      expect(
          sanitizeHtml(
              '<a href="https://a.com">first<a href="https://b.com">second</a></a>'),
          '<a href="https://a.com">first</a><a href="https://b.com">second</a>');
    });
    test('Nested <li> tags are auto-closed', () {
      expect(sanitizeHtml('<ul><li>one<li>two</ul>'),
          '<ul><li>one</li><li>two</li></ul>');
    });
    test('End tags close everything opened after the matching element', () {
      expect(sanitizeHtml('<div><b>bold</div>after'),
          '<div><b>bold</b></div>after');
    });
    test('Implied end tags follow the tree builder scopes', () {
      expect(sanitizeHtml('<ul><li><p>a<li>b</ul>'),
          '<ul><li><p>a</p></li><li>b</li></ul>');
      expect(sanitizeHtml('<p>a<hr>b'), '<p>a</p><hr>b');
      expect(
          sanitizeHtml('<p><b>a<div>b</div>'), '<p><b>a</b></p><div>b</div>');
      expect(sanitizeHtml('<table><tr><td>a<div>b<td>c</table>'),
          '<table><tr><td>a<div>b</div></td><td>c</td></tr></table>');
      expect(sanitizeHtml('<h1>a<h2>b'), '<h1>a</h1><h2>b</h2>');
      // A <button> is a scope boundary: the <div> does not close the <p>.
      final withButton =
          RuleSet.gfm().union(RuleSet({'button': ElementRule()}));
      expect(
        sanitizeHtml('<p><button>x<div>y', rules: withButton),
        '<p><button>x<div>y</div></button></p>',
      );
      // ... even when the button itself is unwrapped: a browser re-parsing
      // the output would close the <p>, which only changes nesting.
      expect(sanitizeHtml('<p><button>x<div>y'), '<p>x<div>y</div></p>');
    });

    test('start tags close only what the tree builder closes', () {
      final rules = RuleSet.html().union(RuleSet({
        'li': ElementRule(),
        'nav': ElementRule(),
        'option': ElementRule(),
      }));
      String s(String html) => sanitizeHtml(html, rules: rules, rewriters: [
            HtmlRewriter.dropElements(where: (a) => a['class'] == 'drop'),
          ]);
      // An <li> start tag stops at a special element other than
      // address/div/p: the inner <li> does not close the outer one.
      expect(
          s('<li class=drop><blockquote><li>a</li>b</blockquote>c</li>after'),
          'after');
      // A heading start tag pops only a heading that is the current node.
      expect(s('<h1 class=drop><b><h2>a</h2>b</b>c</h1>after'), 'after');
      expect(sanitizeHtml('<h1>a<h2>b</h2>'), '<h1>a</h1><h2>b</h2>');
      // Likewise <option>.
      expect(
          s('<option class=drop><b><option>a</option>b</b>c</option>x'), 'x');
      // Since the 2025 "customizable select" parser, `select` is no longer
      // its own insertion mode: `</nav>` closes a <nav> through it.
      expect(
          s('<nav class=drop><select></nav>a</select>b</nav>after'), 'abafter');
    });

    test('is the identity on a stream the tree builder already shaped', () {
      // HtmlTokenizer.dom emits a browser-built tree; a faithful emulation
      // of the tree builder changes nothing about it. (No tables, whose
      // foster parenting nests what "in body" would not; no select/option,
      // for which package:html still implements the pre-2025 insertion
      // mode.)
      final random = Random(7);
      const atoms = [
        '<p>',
        '</p>',
        '<li>',
        '</li>',
        '<ul>',
        '</ul>',
        '<dd>',
        '<dt>',
        '<dl>',
        '</dl>',
        '<h1>',
        '</h1>',
        '<h2>',
        '</h2>',
        '<b>',
        '</b>',
        '<a href=x>',
        '</a>',
        '<div>',
        '</div>',
        '<blockquote>',
        '</blockquote>',
        '<input>',
        '<textarea>',
        '</textarea>',
        '<button>',
        '</button>',
        '<nav>',
        '</nav>',
        '<section>',
        '<pre>',
        '</pre>',
        '<span>',
        '</span>',
        '<br>',
        '<img>',
        'x',
        ' ',
      ];
      for (var n = 0; n < 2000; n++) {
        final html = [
          for (var i = 0; i < 6 + random.nextInt(10); i++)
            atoms[random.nextInt(atoms.length)]
        ].join();
        final plain = _Tokens();
        HtmlTokenizer.dom.tokenize(html, plain);
        final balanced = _Tokens();
        HtmlTokenizer.dom
            .tokenize(html, HtmlRewriter.impliedEndTags().bind(balanced));
        expect(balanced.tokens, plain.tokens, reason: html);
      }
    });
  });
}

final class _Tokens extends HtmlTokenSink {
  final tokens = <String>[];

  @override
  void text(String source, int start, int end) =>
      tokens.add(source.substring(start, end));

  @override
  void startTag(String name, Map<String, String> attributes) =>
      tokens.add('<$name>');

  @override
  void endTag(String name) => tokens.add('</$name>');

  @override
  void close() => tokens.add('EOF');
}
