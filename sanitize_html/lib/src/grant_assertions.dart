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

/// The checks a `RuleSet()` runs on its rules when built.
///
/// They refuse rules that could let through:
///
///  * script running in the page's origin;
///  * control over the host document, navigating it included;
///  * a URL the URL policy never saw.
///
/// `RuleSet.unsafe()` skips them. Elements that only make content disappear
/// or render as text (`plaintext`, `xmp`, `template`, `title`, `textarea`)
/// pass. An `iframe` passes only as an exemption that matches `sandbox`:
/// unsandboxed, a frame from the host's own origin scripts the host page,
/// and one from any origin can navigate it on a click.
library;

import 'attribute_rule.dart';

/// Elements a checked rule set may not allow.
///
///  * `script`: executes. `noscript`, `noembed`, `noframes`: RAWTEXT only
///    when scripting, plugins or frames are enabled, so one output parses two
///    ways.
///  * `style`, `link`, `base`, `meta`, `html`, `head`, `body`: alter the host
///    document (`base` rebases every relative URL, `meta` refreshes, the
///    parser copies `html`/`body` attributes onto the host's elements).
///  * `frameset`, `frame`, `form`: hijack the host's frames and controls.
///    `object`, `embed`, `applet`: plugin content.
///  * `isindex`: older parsers, `package:html` included, expand it into a
///    `<form>`.
///  * `svg`, `math`: foreign content, with case-sensitive attributes
///    (`xlink:href`), `<animate>` retargeting `href`, `<foreignObject>` back
///    into HTML, and a history of mutation XSS.
const forbiddenElements = <String>{
  'applet',
  'base',
  'body',
  'embed',
  'form',
  'frame',
  'frameset',
  'head',
  'html',
  'isindex',
  'link',
  'math',
  'meta',
  'noembed',
  'noframes',
  'noscript',
  'object',
  'script',
  'style',
  'svg',
};

/// Attributes a checked rule set may not allow on any element.
///
///  * `style`: positions content over the host page.
///  * [`srcdoc`][1]: an inline document for `<iframe>`.
///  * [`is`][2]: upgrades the element to a host-defined built-in.
///  * [`form`][3], `formaction`, `formtarget`, `formmethod`, `formenctype`:
///    bind a control to, or override the submission of, a host form.
///  * [`ping`][4], `attributionsrc`: requests to arbitrary URLs on click.
///  * [`popovertarget`][5], `popovertargetaction`, [`command`][6],
///    `commandfor`: a button acting on any host element by id.
///  * [`shadowrootmode`][7]: a `<template>` that becomes its parent's shadow
///    root.
///  * [`allow`][9], `allowpaymentrequest`: delegate the host's permissions to
///    an `<iframe>`.
///
/// [Event handlers][8] (`on*`) are refused by prefix.
///
/// [1]: https://html.spec.whatwg.org/multipage/iframe-embed-object.html#attr-iframe-srcdoc
/// [2]: https://html.spec.whatwg.org/multipage/custom-elements.html#attr-is
/// [3]: https://html.spec.whatwg.org/multipage/form-control-infrastructure.html#attr-fae-form
/// [4]: https://html.spec.whatwg.org/multipage/links.html#ping
/// [5]: https://html.spec.whatwg.org/multipage/popover.html#attr-popovertarget
/// [6]: https://html.spec.whatwg.org/multipage/form-elements.html#attr-button-commandfor
/// [7]: https://html.spec.whatwg.org/multipage/scripting.html#attr-template-shadowrootmode
/// [8]: https://html.spec.whatwg.org/multipage/webappapis.html#event-handler-content-attributes
/// [9]: https://html.spec.whatwg.org/multipage/iframe-embed-object.html#attr-iframe-allow
const forbiddenAttributes = <String>{
  'allow',
  'allowpaymentrequest',
  'attributionsrc',
  'command',
  'commandfor',
  'form',
  'formaction',
  'formenctype',
  'formmethod',
  'formtarget',
  'is',
  'ping',
  'popovertarget',
  'popovertargetaction',
  'shadowrootmode',
  'srcdoc',
  'style',
};

/// Attributes a browser reads as URLs; a checked rule set must bind them to
/// [AttributeRule.url] (`srcset` to [AttributeRule.srcset]). Broad on
/// purpose, so it holds without knowing the element; see the [attribute
/// index][1].
///
/// [1]: https://html.spec.whatwg.org/multipage/indices.html#attributes-3
const urlAttributes = <String>{
  'action',
  'background',
  'cite',
  'codebase',
  'data',
  'dynsrc',
  'formaction',
  'href',
  'icon',
  'longdesc',
  'lowsrc',
  'manifest',
  'poster',
  'src',
  'srcset',
  'xlink:href',
};

/// Elements a checked rule set allows only as an exemption matching the
/// attribute that decides what they do.
const _onlyAsPatternMatching = <String, String>{
  'iframe': 'sandbox',
};

/// Checks a rule for [tagName] with [attributes] against the lists above;
/// [matched] are the attributes an exemption requires.
///
/// Throws if it grants something a checked rule set refuses.
void checkGrants(
  String tagName,
  Map<String, AttributeRule> attributes, {
  Set<String> matched = const {},
}) {
  if (forbiddenElements.contains(tagName)) {
    throw UnsupportedError(
      '<$tagName> cannot be allowed by RuleSet(); '
      'use RuleSet.unsafe() if you really mean it',
    );
  }
  if (_onlyAsPatternMatching[tagName] case final attribute?
      when !matched.contains(attribute)) {
    throw UnsupportedError(
      '<$tagName> can only be allowed by RuleSet() as an ElementPattern that '
      'matches $attribute; use RuleSet.unsafe() if you really mean it',
    );
  }
  for (final MapEntry(key: name, value: rule) in attributes.entries) {
    if (forbiddenAttributes.contains(name) || name.startsWith('on')) {
      throw UnsupportedError(
        '<$tagName $name=""> cannot be allowed by RuleSet(); '
        'use RuleSet.unsafe() if you really mean it',
      );
    }
    if (name == 'rel' && !rule.isRelRestricted) {
      throw UnsupportedError(
        '<$tagName rel=""> must use AttributeRule.rel() in RuleSet(); '
        'use RuleSet.unsafe() if you really mean it',
      );
    }
    if (!urlAttributes.contains(name)) {
      continue;
    }
    if (name == 'srcset' ? !rule.isSrcsetRestricted : !rule.isUrlRestricted) {
      throw UnsupportedError(
        '<$tagName $name=""> must use AttributeRule.'
        '${name == 'srcset' ? 'srcset' : 'url'}() '
        'in RuleSet(); use RuleSet.unsafe() if you really mean it',
      );
    }
  }
}
