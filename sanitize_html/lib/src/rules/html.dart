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

/// The rules for arbitrary HTML, `RuleSet.html`.
///
/// The element and attribute tables of [safevalues][1], the sanitizer behind
/// Google's safe HTML types, copied verbatim: it is maintained, published,
/// and applies the test this package applies — keep what cannot reach
/// outside the sanitized content. Each deviation is forced by the checked
/// `RuleSet()` constructor or by a check safevalues leaves to its callers,
/// except the one opinion stated last.
///
///  * `<link>` and `formenctype`: the constructor refuses them
///    (`rel=stylesheet` loads CSS, `rel=preload` fetches on the host's
///    behalf). `enctype` goes with them: with no form element it does
///    nothing.
///  * URL attributes (`href`, `src`, `srcset`, `poster`, `cite`) go through
///    this package's URL policy; safevalues does not check resource URLs.
///  * `rel` only with the link types defined for `<a>`, never `opener`;
///    safevalues keeps any `rel`.
///  * `target` only `_self` or `_blank`, `dir` only `ltr`, `rtl` or `auto`,
///    `loading` only `eager` or `lazy`: the sets safevalues normalizes to.
///
/// Like safevalues, no `id`, `name`, `class` or `style`: identifiers can
/// shadow properties of `window` and `document` or ids the host relies on,
/// classes hook into the host's stylesheet. Add them with `union` where the
/// host can afford it.
///
/// The one opinion of this package's own: seven things safevalues keeps are
/// dropped because each binds the content to something the host owns — its
/// focus, its URLs, its shadow tree, its ids or its form — rather than
/// composing with it as embedded HTML does (a heading joins the host's
/// outline, a `<select>` appears in an enclosing form: those are kept). It
/// is the test safevalues applies to `<label>`, `<iframe>`, `<title>` and
/// `tabindex`, carried to the end of its table:
///
///  * `autofocus`: moves focus, and scrolls, to the content on load — the
///    same page-global state as `tabindex`, which safevalues denies.
///  * `download`: turns a link to the host's own origin into a file download
///    — the one host-navigation modifier left after `target`, `ping` and
///    `rel=opener`.
///  * `itemref` and `usemap`: references by id or name into the host
///    document — the two safevalues' identifier rule missed. With `id` and
///    `name` denied, a content `usemap` can only bind to a host image map.
///  * `required`: does nothing in the content, where no form is allowed, but
///    a content `<select required>` inside a host form blocks the host's
///    submission.
///  * `slot` and `<slot>`: inert outside a shadow tree; inside a shadow root
///    the host created, the attribute moves content into the host's slots
///    and the element captures the host's own children. The one call with no
///    safevalues precedent.
///
/// Hosts that want any of them add it back with `union`.
///
/// [1]: https://github.com/google/safevalues/blob/main/src/builders/html_sanitizer/sanitizer_table/default_sanitizer_table.ts
library;

import '../attribute_rule.dart';
import '../element_rule.dart';
import '../rule_set.dart';

/// safevalues `ALLOWED_ELEMENTS`.
const _elements = <String>{
  'article', 'section', 'nav', 'aside', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6',
  'header', 'footer', 'address', 'p', 'hr', 'pre', 'blockquote', 'ol', 'ul',
  'lh', 'li', 'dl', 'dt', 'dd', 'figure', 'figcaption', 'main', 'div', 'em',
  'strong', 'small', 's', 'cite', 'q', 'dfn', 'abbr', 'ruby', 'rb', 'rt',
  'rtc', 'rp', 'data', 'time', 'code', 'var', 'samp', 'kbd', 'sub', 'sup',
  'i', 'b', 'u', 'mark', 'bdi', 'bdo', 'span', 'br', 'wbr', 'nobr', 'ins',
  'del', 'picture', 'param', 'track', 'map', 'table', 'caption', 'colgroup',
  'col', 'tbody', 'thead', 'tfoot', 'tr', 'td', 'th', 'select', 'datalist',
  'optgroup', 'option', 'output', 'progress', 'meter', 'fieldset', 'legend',
  'details', 'summary', 'menu', 'dialog', 'canvas', 'font', 'center',
  'acronym', 'basefont', 'big', 'dir', 'hgroup', 'strike', 'tt',
  // safevalues `ELEMENT_POLICIES`, without `link`.
  'a', 'area', 'source', 'img', 'video', 'audio',
};

/// safevalues `ALLOWED_GLOBAL_ATTRIBUTES` and `GLOBAL_ATTRIBUTE_POLICIES`.
final _globalAttributes = <String, AttributeRule>{
  for (final name in const [
    'title',
    'aria-atomic',
    'aria-autocomplete',
    'aria-busy',
    'aria-checked',
    'aria-current',
    'aria-disabled',
    'aria-dropeffect',
    'aria-expanded',
    'aria-haspopup',
    'aria-hidden',
    'aria-invalid',
    'aria-label',
    'aria-level',
    'aria-live',
    'aria-multiline',
    'aria-multiselectable',
    'aria-orientation',
    'aria-posinset',
    'aria-pressed',
    'aria-readonly',
    'aria-relevant',
    'aria-required',
    'aria-selected',
    'aria-setsize',
    'aria-sort',
    'aria-valuemax',
    'aria-valuemin',
    'aria-valuenow',
    'aria-valuetext',
    'alt',
    'align',
    'autocapitalize',
    'autocomplete',
    'autocorrect',
    'autoplay',
    'bgcolor',
    'border',
    'cellpadding',
    'cellspacing',
    'checked',
    'color',
    'cols',
    'colspan',
    'controls',
    'controlslist',
    'coords',
    'crossorigin',
    'datetime',
    'disabled',
    'draggable',
    'face',
    'frameborder',
    'height',
    'hreflang',
    'hidden',
    'inert',
    'ismap',
    'label',
    'lang',
    'loop',
    'max',
    'maxlength',
    'media',
    'minlength',
    'min',
    'multiple',
    'muted',
    'nonce',
    'open',
    'playsinline',
    'placeholder',
    'preload',
    'reversed',
    'role',
    'rows',
    'rowspan',
    'selected',
    'shape',
    'size',
    'sizes',
    'span',
    'spellcheck',
    'start',
    'step',
    'summary',
    'translate',
    'type',
    'valign',
    'value',
    'width',
    'wrap',
    'itemscope',
    'itemtype',
    'itemid',
    'itemprop',
  ])
    name: const AttributeRule.any(),
  'cite': const AttributeRule.url(), // URL policy
  'rel': AttributeRule.rel(),
  'poster': const AttributeRule.url(), // safevalues: resource URL policy
  'dir': AttributeRule.where(const {'auto', 'ltr', 'rtl'}.contains),
  'async': AttributeRule.where((v) => v == 'async'),
  'loading': AttributeRule.where(const {'eager', 'lazy'}.contains),
  'target': AttributeRule.where(const {'_self', '_blank'}.contains),
};

/// safevalues `ELEMENT_POLICIES`, with URL attributes bound to the policy.
const _elementAttributes = <String, Map<String, AttributeRule>>{
  'a': {'href': AttributeRule.url()},
  'area': {'href': AttributeRule.url()},
  'source': {'src': AttributeRule.url(), 'srcset': AttributeRule.srcset()},
  'img': {'src': AttributeRule.url(), 'srcset': AttributeRule.srcset()},
  'video': {'src': AttributeRule.url()},
  'audio': {'src': AttributeRule.url()},
};

/// See `RuleSet.html`.
final htmlRuleSet = RuleSet({
  for (final element in _elements)
    element: ElementRule(
      attributes: switch (_elementAttributes[element]) {
        null => _globalAttributes,
        final specific => {..._globalAttributes, ...specific},
      },
    ),
});
