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
  group('HtmlRewriter.dropElements:', () {
    test('HtmlRewriter.dropElements removes subtrees', () {
      String s(String html) => sanitizeHtml(
            html,
            rewriters: [
              HtmlRewriter.dropElements(tagNames: {'x', 'br'})
            ],
          );
      expect(s('a<x>b<x>c</x>d</x>e<br>f'), 'aef');
    });

    test('a misnested end tag ends the dropped element, as in a browser', () {
      for (final tokenizer in [HtmlTokenizer.streaming, HtmlTokenizer.dom]) {
        expect(
            sanitizeHtml('<div><x>a</div>b</x>c',
                tokenizer: tokenizer,
                rewriters: [
                  HtmlRewriter.dropElements(tagNames: {'x'})
                ]),
            '<div></div>bc');
      }
    });

    test('HtmlRewriter.dropElements by attribute, with or without names', () {
      const html = '<p class="ad">x</p><b class="ad">y</b><p>z</p>';
      expect(
          sanitizeHtml(html, rules: RuleSet.html(), rewriters: [
            HtmlRewriter.dropElements(where: (a) => a['class'] == 'ad')
          ]),
          '<p>z</p>');
      expect(
          sanitizeHtml(html, rules: RuleSet.html(), rewriters: [
            HtmlRewriter.dropElements(
                tagNames: {'b'}, where: (a) => a['class'] == 'ad')
          ]),
          '<p>x</p><p>z</p>');
    });
  });
}
