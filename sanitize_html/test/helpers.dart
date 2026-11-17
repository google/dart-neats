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

const tokenizers = {
  'streaming': HtmlTokenizer.streaming,
  'simple': HtmlTokenizer.simple,
  'dom': HtmlTokenizer.dom,
};

/// A sanitizer with any id / class allowed on `<span>` by the rules and
/// limited by a rewriter, an extra element and a `rel` rewriter, exercising
/// the configuration surface.
String configured(String html) => sanitizeHtml(
      html,
      rules: RuleSet.gfm().union(RuleSet({
        'only-allowed-tag': ElementRule(),
        'span': ElementRule(attributes: {
          'id': AttributeRule.any(),
          'class': AttributeRule.any(),
        }),
      })),
      rewriters: [
        HtmlRewriter(LimitIdAndClass.new),
        HtmlRewriter.addLinkRel(
            (href) => href.path == 'bad-link' ? ['ugc', 'nofollow'] : const []),
      ],
    );

/// Keeps only `id="only-allowed-id"` and the class `only-allowed-class`.
final class LimitIdAndClass extends HtmlTokenSink {
  final HtmlTokenSink _next;
  LimitIdAndClass(this._next);

  @override
  void text(String source, int start, int end) =>
      _next.text(source, start, end);

  @override
  void startTag(String name, Map<String, String> attributes) {
    if (attributes.isNotEmpty) {
      if (attributes['id'] != 'only-allowed-id') {
        attributes.remove('id');
      }
      final classes = attributes['class']
          ?.split(' ')
          .where((c) => c == 'only-allowed-class')
          .join(' ');
      if (classes == null || classes.isEmpty) {
        attributes.remove('class');
      } else {
        attributes['class'] = classes;
      }
    }
    _next.startTag(name, attributes);
  }

  @override
  void endTag(String name) => _next.endTag(name);

  @override
  void close() => _next.close();
}

/// Expects [needle] in the sanitized [template].
void testContains(String template, String needle,
    {bool withConfiguration = true}) {
  test('"$template" does contain "$needle"', () {
    final sanitize = withConfiguration ? configured : sanitizeHtml;
    expect(sanitize(template), contains(needle));
  });
}

void testNotContains(String template, String needle,
    {bool withConfiguration = true}) {
  test('"$template" does not contain "$needle"', () {
    final sanitize = withConfiguration ? configured : sanitizeHtml;
    expect(sanitize(template), isNot(contains(needle)));
  });
}
