// Copyright 2026 Google LLC
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
import 'dart:math';

import 'package:sanitize_html/sanitize_html.dart';
import 'package:test/test.dart';

/// Tags from the rule sets, scope boundaries the rules unwrap, content the
/// tokenizers never report, and junk.
const _atoms = [
  '<p>',
  '</p>',
  '<div>',
  '</div>',
  '<span>',
  '</span>',
  '<b>',
  '</b>',
  '<i>',
  '</i>',
  '<a href="/x">',
  '</a>',
  '<ul>',
  '</ul>',
  '<ol>',
  '</ol>',
  '<li>',
  '</li>',
  '<dl>',
  '<dt>',
  '<dd>',
  '</dl>',
  '<h1>',
  '</h1>',
  '<h2>',
  '</h2>',
  '<blockquote>',
  '</blockquote>',
  '<pre>',
  '</pre>',
  '<code>',
  '</code>',
  '<table>',
  '</table>',
  '<tr>',
  '</tr>',
  '<td>',
  '</td>',
  '<th>',
  '<tbody>',
  '<caption>',
  '</caption>',
  '<details>',
  '<summary>',
  '</summary>',
  '</details>',
  '<section>',
  '</section>',
  '<br>',
  '<hr>',
  '<img src="/i">',
  '<button>',
  '</button>',
  '<object>',
  '</object>',
  '<applet>',
  '</applet>',
  '<marquee>',
  '</marquee>',
  '<template>',
  '</template>',
  '<select>',
  '</select>',
  '<option>',
  '</option>',
  '<nav>',
  '</nav>',
  '<form>',
  '</form>',
  '<x>',
  '</x>',
  '<my-el>',
  '</my-el>',
  '<script>',
  '</script>',
  '<style>',
  '</style>',
  '<textarea>',
  '</textarea>',
  '<title>',
  '</title>',
  '<xmp>',
  '</xmp>',
  '<plaintext>',
  '<svg>',
  '</svg>',
  '<input type="checkbox">',
  '<input>',
  '<label>',
  '</label>',
  'x',
  ' ',
  '&amp;',
  '&',
  '<',
  '>',
  '"',
  '</',
  '<!--',
  '-->',
  '<p/>',
  '<br/>',
];

void main() {
  // `impliedEndTags` runs before the rules and honours scope boundaries the
  // rules then unwrap, so one pass is not always a fixed point; two are.
  test('two passes of sanitizeHtml reach a fixed point', () {
    final random = Random(2026);
    for (final (name, tokenizer, rules) in [
      ('streaming/gfm', HtmlTokenizer.streaming, RuleSet.gfm()),
      ('streaming/html', HtmlTokenizer.streaming, RuleSet.html()),
      ('simple/gfm', HtmlTokenizer.simple, RuleSet.gfm()),
      ('simple/html', HtmlTokenizer.simple, RuleSet.html()),
    ]) {
      for (var i = 0; i < 2000; i++) {
        final input = [
          for (var k = 0; k < 4 + random.nextInt(14); k++)
            _atoms[random.nextInt(_atoms.length)]
        ].join();
        String s(String h) =>
            sanitizeHtml(h, rules: rules, tokenizer: tokenizer);
        final twice = s(s(input));
        expect(s(twice), twice, reason: '$name: $input');
      }
    }
  });
}
