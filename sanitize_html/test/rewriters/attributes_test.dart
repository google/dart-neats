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
  group('HtmlRewriter.rewriteAttributes and addLinkRel:', () {
    test('HtmlRewriter.rewriteAttributes runs before the rules', () {
      String sanitize(String html) => sanitizeHtml(html, rewriters: [
            HtmlRewriter.rewriteAttributes(tagName: 'h2', (attributes) {
              attributes['id'] = 'heading';
              attributes['onclick'] = 'alert(1)';
            }),
          ]);
      // The rules keep only prefixed ids, so the rewrite is filtered out.
      expect(sanitize('<h2>x</h2>'), '<h2>x</h2>');
      String withIds(String html) => sanitizeHtml(
            html,
            rewriters: [
              HtmlRewriter.rewriteAttributes(
                  tagName: 'h2',
                  (attributes) => attributes['id'] = 'user-content-heading'),
            ],
          );
      expect(withIds('<h2 id="x">x</h2><h3 id="user-content-y">y</h3>'),
          '<h2 id="user-content-heading">x</h2><h3 id="user-content-y">y</h3>');
    });

    test('HtmlRewriter.addLinkRel replaces the author\'s rel', () {
      String sanitize(String html) => sanitizeHtml(
            html,
            rewriters: [
              HtmlRewriter.addLinkRel((href) => ['ugc', 'nofollow'])
            ],
          );
      // An author token the rules refuse must not cost the link the host's.
      expect(sanitize('<a href="/x" rel="opener noreferrer">x</a>'),
          '<a href="/x" rel="ugc nofollow">x</a>');
      expect(sanitize('<a>x</a>'), '<a>x</a>');
      expect(
          sanitizeHtml('<a href="/x" rel="nofollow">x</a>',
              rewriters: [HtmlRewriter.addLinkRel((_) => const [])]),
          '<a href="/x">x</a>');
    });

    test('HtmlRewriter.rewriteAttributes can target every element', () {
      expect(
          sanitizeHtml('<p title="a">x</p><b title="b">y</b>',
              rules: RuleSet.html(),
              rewriters: [
                HtmlRewriter.rewriteAttributes((attributes) {
                  if (attributes['title'] != 'a') {
                    attributes.remove('title');
                  }
                })
              ]),
          '<p title="a">x</p><b>y</b>');
    });
  });
}
