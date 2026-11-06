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
import 'package:markdown/markdown.dart' as md;
import 'package:sanitize_html/sanitize_html.dart';
import 'package:test/test.dart';

void main() {
  group('RuleSet.gfm:', () {
    test('gfm keeps what package:markdown emits', () {
      String s(String html) => sanitizeHtml(html);
      expect(s('<h2 id="user-content-usage">Usage</h2>'),
          '<h2 id="user-content-usage">Usage</h2>');
      expect(s('<h2 id="usage">Usage</h2>'), '<h2>Usage</h2>');
      expect(s('<a name="x" id="getElementById">y</a>'), '<a>y</a>');
      expect(
          s('<pre data-metadata="title=x"><code class="language-dart">'
              'a</code></pre>'),
          '<pre data-metadata="title=x"><code class="language-dart">a</code>'
          '</pre>');
      expect(s('<div class="language-dart">a</div>'), '<div>a</div>');
      expect(s('<div class="markdown-alert markdown-alert-note">a</div>'),
          '<div class="markdown-alert markdown-alert-note">a</div>');
      expect(s('<div class="markdown-alert host">a</div>'), '<div>a</div>');
      expect(
          s('<ul class="contains-task-list"><li class="task-list-item">'
              '<input type="checkbox" checked="true">x</li></ul>'),
          '<ul class="contains-task-list"><li class="task-list-item">'
          '<input type="checkbox" checked="true">x</li></ul>');
      expect(s('<input type="text" value="x">'), '');
      // `rel` describing the link stays; a claim about the host page does not.
      expect(s('<a href="/x" rel="nofollow noopener">y</a>'),
          '<a href="/x" rel="nofollow noopener">y</a>');
      expect(s('<a href="/x" rel="me nofollow">y</a>'), '<a href="/x">y</a>');
      expect(
          sanitizeHtml('<a href="/x" rel="me license">y</a>',
              rules: RuleSet.html()),
          '<a href="/x" rel="me license">y</a>');
      // As on github.com: `srcset` on <source>, not on <img>.
      expect(
          s('<picture><source srcset="https://e.x/d.png 2x"><img src="https://e.x/a.png" srcset="https://e.x/b.png 2x" sizes="100vw"></picture>'),
          '<picture><source srcset="https://e.x/d.png 2x"><img src="https://e.x/a.png"></picture>');
      expect(s('<input>'), '');
      expect(
          s('<ol start="3"><li>x</li></ol>'), '<ol start="3"><li>x</li></ol>');
      expect(s('<td align="center">x</td>'), '<td align="center">x</td>');
      expect(
          s('<section class="footnotes"><ol><li id="user-content-fn-1">'
              '<a href="#user-content-fnref-1" class="footnote-backref">↩</a>'
              '</li></ol></section>'),
          '<section class="footnotes"><ol><li id="user-content-fn-1">'
          '<a href="#user-content-fnref-1" class="footnote-backref">↩</a>'
          '</li></ol></section>');
      expect(s('<a href="/x" accesskey="a" tabindex="1" for="y">x</a>'),
          '<a href="/x">x</a>');
      expect(s('<h7>x</h7><a href="/x" target="_blank">y</a>'),
          'x<a href="/x">y</a>');
    });
    test('package:markdown gitHubWeb output survives gfm', () {
      const source = '''
# Heading *em* `code`

Para with **strong**, ~~del~~, <https://x.y>, [link](http://a.b "t"),
![img](http://i.j/k.png "t"), foo[^1], `#ff0000`.

- [ ] task
- [x] done

3. three

| a | b |
|:--|--:|
| 1 | 2 |

```dart title=x
void main() {}
```

> [!NOTE]
> alert

Line  
break

---

[^1]: note
''';
      final rendered = md.markdownToHtml(
        source,
        extensionSet: md.ExtensionSet.gitHubWeb,
      );
      final sanitized = sanitizeHtml(
        rendered,
        rewriters: [HtmlRewriter.prefixIds('user-content-')],
      );
      // What the renderer wrote, modulo the writer's normalization, the id
      // prefix, and the colour chip's inline style (which no checked rule
      // set can keep).
      final expected = rendered
          .replaceAll(' />', '>')
          .replaceAll('</input>', '')
          .replaceAll(' id="', ' id="user-content-')
          .replaceAll(' href="#', ' href="#user-content-')
          .replaceAll(RegExp(' style="[^"]*"'), '');
      expect(sanitized, expected);
      expect(sanitizeHtml(sanitized), sanitized);
    });
  });
}
