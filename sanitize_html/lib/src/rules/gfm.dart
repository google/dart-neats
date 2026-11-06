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

/// The rules for rendered Markdown, [RuleSet.gfm].
///
/// Two sources, each rule annotated with its own:
///
///  * [html-pipeline][1] v3.2.4, the open-source origin of GitHub's Markdown
///    pipeline and the only published description of the raw HTML READMEs
///    rely on (`<details>`, `<kbd>`, `<img width align>`, ...).
///  * [package:markdown][2] with `ExtensionSet.gitHubWeb`: the `class`, `id`
///    and `data-` attributes it emits that html-pipeline would not keep.
///
/// Deviations from html-pipeline, each because the attribute reaches
/// outside the content, the test Google's [safevalues][3] applies:
///
///  * `id` only with the `user-content-` prefix GitHub, GitLab and Gitea use:
///    an unprefixed id can shadow a property of `window` or `document`
///    ([DOM clobbering][4]) or an id the host relies on.
///  * `name` dropped: the same clobbering surface, and never emitted.
///  * `class` only with what `package:markdown` emits: `markdown-*`, and
///    `language-*` on `<code>` (the CommonMark convention).
///  * Form attributes (`accept`, `accept-charset`, `action`, `enctype`,
///    `method`, `prompt`, `for`) dropped: no form element is allowed, and
///    `for` attaches a label to a host control.
///  * `accesskey` (host keyboard shortcuts), `tabindex` (host tab order),
///    `usemap` (no `<map>`), `aria-describedby` and `aria-labelledby` (host
///    ids) dropped.
///  * `rel` only with [link types][5] that describe the link (`nofollow`,
///    `noopener`, `noreferrer`, `ugc`, `sponsored`, `external`, `help`), not
///    the document it is in (`me`, `license`, `alternate`, ...); github.com
///    replaces any author `rel`.
///  * `srcset` parsed and every candidate checked; html-pipeline does not.
///
/// [1]: https://github.com/gjtorikian/html-pipeline/blob/c99d76dbfe817598387c371af342e25abdccd363/lib/html_pipeline/sanitization_filter.rb
/// [2]: https://pub.dev/packages/markdown
/// [3]: https://github.com/google/safevalues/blob/main/src/builders/html_sanitizer/sanitizer_table/default_sanitizer_table.ts
/// [4]: https://html.spec.whatwg.org/multipage/nav-history-apis.html#named-access-on-the-window-object
/// [5]: https://html.spec.whatwg.org/multipage/links.html#linkTypes
library;

import '../attribute_rule.dart';
import '../element_pattern.dart';
import '../element_rule.dart';
import '../util/space_separated_tokens.dart';
import 'link_types.dart';
import '../rule_set.dart';

/// Elements, from html-pipeline unless noted.
const gfmElements = <String>{
  'a',
  'abbr',
  'b',
  'bdo',
  'blockquote',
  'br',
  'caption',
  'cite',
  'code',
  'dd',
  'del',
  'details',
  'dfn',
  'div',
  'dl',
  'dt',
  'em',
  'figcaption',
  'figure',
  'h1',
  'h2',
  'h3',
  'h4',
  'h5',
  'h6',
  'hr',
  'i',
  'img',
  'ins',
  'kbd',
  'li',
  'mark',
  'ol',
  'p',
  'picture',
  'pre',
  'q',
  'rp',
  'rt',
  'ruby',
  's',
  'samp',
  'section', // package:markdown footnotes; kept as raw HTML by github.com too
  'small',
  'source',
  'span',
  'strike',
  'strong',
  'sub',
  'summary',
  'sup',
  'table',
  'tbody',
  'td',
  'tfoot',
  'th',
  'thead',
  'time',
  'tr',
  'tt',
  'ul',
  'var',
  'wbr',
};

/// Attributes allowed on every element: html-pipeline's `all:` list minus
/// the deviations in the library comment, plus `id` and `class` as
/// `package:markdown` emits them.
final _globalAttributes = <String, AttributeRule>{
  'abbr': AttributeRule.any(),
  'align': AttributeRule.any(),
  'alt': AttributeRule.any(),
  'aria-hidden': AttributeRule.any(),
  'aria-label': AttributeRule.any(),
  'axis': AttributeRule.any(),
  'border': AttributeRule.any(),
  'char': AttributeRule.any(),
  'charoff': AttributeRule.any(),
  'charset': AttributeRule.any(),
  'checked': AttributeRule.any(),
  'class': AttributeRule.where(_isMarkdownClassList),
  'clear': AttributeRule.any(),
  'cols': AttributeRule.any(),
  'colspan': AttributeRule.any(),
  'compact': AttributeRule.any(),
  'coords': AttributeRule.any(),
  'datetime': AttributeRule.any(),
  'dir': AttributeRule.any(),
  'disabled': AttributeRule.any(),
  'frame': AttributeRule.any(),
  'headers': AttributeRule.any(),
  'height': AttributeRule.any(),
  'hreflang': AttributeRule.any(),
  'hspace': AttributeRule.any(),
  'id': AttributeRule.where(_isUserContentId),
  'ismap': AttributeRule.any(),
  'itemprop': AttributeRule.any(),
  'label': AttributeRule.any(),
  'lang': AttributeRule.any(),
  'maxlength': AttributeRule.any(),
  'media': AttributeRule.any(),
  'multiple': AttributeRule.any(),
  'nohref': AttributeRule.any(),
  'noshade': AttributeRule.any(),
  'nowrap': AttributeRule.any(),
  'open': AttributeRule.any(),
  'progress': AttributeRule.any(),
  'readonly': AttributeRule.any(),
  'rel': AttributeRule.rel(_describesTheLink),
  'rev': AttributeRule.any(),
  'role': AttributeRule.any(),
  'rows': AttributeRule.any(),
  'rowspan': AttributeRule.any(),
  'rules': AttributeRule.any(),
  'scope': AttributeRule.any(),
  'selected': AttributeRule.any(),
  'shape': AttributeRule.any(),
  'size': AttributeRule.any(),
  'span': AttributeRule.any(),
  'start': AttributeRule.any(),
  'summary': AttributeRule.any(),
  'title': AttributeRule.any(),
  'type': AttributeRule.any(),
  'valign': AttributeRule.any(),
  'value': AttributeRule.any(),
  'width': AttributeRule.any(),
};

/// Attributes allowed on specific elements, in addition to the global ones.
final _elementAttributes = <String, Map<String, AttributeRule>>{
  'a': {'href': AttributeRule.url()}, // html-pipeline
  'blockquote': {'cite': AttributeRule.url()}, // html-pipeline
  'code': {
    // package:markdown: `language-<info>` on fenced code blocks.
    'class': AttributeRule.where(_isCodeClassList),
  },
  'del': {'cite': AttributeRule.url()}, // html-pipeline
  'div': {
    'itemscope': AttributeRule.any(), // html-pipeline
    'itemtype': AttributeRule.any(), // html-pipeline
  },
  'img': {
    'loading': AttributeRule.any(), // html-pipeline
    'longdesc': AttributeRule.url(), // html-pipeline
    'src': AttributeRule.url(), // html-pipeline
  },
  'ins': {'cite': AttributeRule.url()}, // html-pipeline
  'pre': {
    // package:markdown: the info string after the language.
    'data-metadata': AttributeRule.any(),
  },
  'q': {'cite': AttributeRule.url()}, // html-pipeline
  'source': {'srcset': AttributeRule.srcset()}, // html-pipeline
};

/// `package:markdown` task lists: `<input type="checkbox" checked>`. Any
/// other `<input>` is unwrapped. A checkbox without a `name` is never
/// submitted with a host form; `disabled` keeps it from being toggled.
final gfmCheckbox = ElementPattern(
  'input',
  match: {'type': AttributeRule.where((value) => value == 'checkbox')},
  attributes: {..._globalAttributes}..remove('type'),
);

/// Class names `package:markdown` emits that do not yet carry the
/// `markdown-` prefix.
// TODO: Remove once package:markdown emits `markdown-*` names.
const _legacyMarkdownClasses = <String>{
  'contains-task-list',
  'footnote-backref',
  'footnote-ref',
  'footnotes',
  'gfm-color_chip',
  'task-list-item',
};

bool _isMarkdownClassList(String value) => everyToken(value, _isMarkdownClass);

bool _isCodeClassList(String value) => everyToken(
      value,
      (token) => token.startsWith('language-') || _isMarkdownClass(token),
    );

bool _isMarkdownClass(String token) =>
    token.startsWith('markdown-') || _legacyMarkdownClasses.contains(token);

bool _isUserContentId(String value) => value.startsWith('user-content-');

/// See `RuleSet.gfm`.
final gfmRuleSet = RuleSet({
  for (final element in gfmElements)
    element: ElementRule(
      attributes: switch (_elementAttributes[element]) {
        null => _globalAttributes,
        final specific => {..._globalAttributes, ...specific},
      },
    ),
}, exemptions: [
  gfmCheckbox,
]);

bool _describesTheLink(Set<String> tokens) =>
    tokens.every(linkDescribingTypes.contains);
