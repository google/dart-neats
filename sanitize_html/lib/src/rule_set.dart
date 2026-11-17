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

/// The rules a sanitizer applies.
library;

import 'rules/gfm.dart' show gfmRuleSet;
import 'rules/html.dart' show htmlRuleSet;
import 'grant_assertions.dart';
import 'html_writer.dart' show isWritableAttributeName, isWritableTagName;
import 'attribute_rule.dart';
import 'element_pattern.dart';
import 'element_rule.dart';

/// The elements a sanitizer keeps, and with which attributes.
///
/// Per element, an [ElementRule] filters attributes one by one and
/// [ElementPattern]s are exemptions for exact forms. The first matching
/// pattern decides; otherwise the rule; with neither, the element is
/// unwrapped: tags dropped, content kept.
///
/// ```dart
/// final rules = RuleSet.gfm()
///     .union(RuleSet({
///       'video': ElementRule(attributes: {
///         'src': AttributeRule.url(),
///         'controls': AttributeRule.any(),
///       }),
///     }))
///     .withExemptions([
///       ElementPattern.iframe(
///         where: (src) => src.host == 'www.youtube.com',
///         sandbox: {'allow-scripts', 'allow-same-origin'},
///       ),
///     ]);
/// ```
final class RuleSet {
  final Map<String, ElementRule> _rules;

  /// Exemptions by element name, in order of precedence.
  final Map<String, List<ElementPattern>> _patterns;

  /// A rule set allowing exactly the elements in [rules] and the forms in
  /// [exemptions].
  ///
  /// Exemptions are for narrow forms the rules do not allow, such as an
  /// `<iframe>` from one origin. A matching exemption decides the element
  /// by itself and keeps only what it lists, so do not use one to be
  /// stricter than the rules; that is a job for an `HtmlRewriter`.
  ///
  /// Throws if:
  ///  * a tag name does not match `[a-z][a-z0-9._-]*`, or an attribute name
  ///    `[a-z][a-z0-9_:.-]*`;
  ///  * a rule allows one of the elements `script`, `style`, `base`, `meta`,
  ///    `link`, `html`, `head`, `body`, `frameset`, `frame`, `form`,
  ///    `object`, `embed`, `applet`, `isindex`, `noscript`, `noembed`,
  ///    `noframes`, `svg`, `math`;
  ///  * a rule allows one of the attributes `on*`, `style`, `srcdoc`, `is`,
  ///    `form*`, `ping`, `attributionsrc`, `popovertarget*`, `command`,
  ///    `commandfor`, `shadowrootmode`;
  ///  * a URL attribute (`href`, `src`, `cite`, `poster`, ...) is not bound
  ///    to [AttributeRule.url], or `srcset` not to [AttributeRule.srcset];
  ///  * `rel` is not bound to [AttributeRule.rel];
  ///  * an `iframe` is allowed other than by an exemption that matches
  ///    `sandbox`, such as [ElementPattern.iframe].
  ///
  /// The last five checks above can be waived using [RuleSet.unsafe].
  RuleSet(
    Map<String, ElementRule> rules, {
    List<ElementPattern> exemptions = const [],
  }) : this._(rules, exemptions, checked: true);

  /// [RuleSet.new] without the grant checks.
  ///
  /// > [!WARNING]
  /// > These rules can allow script to run, for example through an `on*`
  /// > attribute or `<script src>`; nothing in this package prevents it.
  ///
  /// Throws if a tag name does not match `[a-z][a-z0-9._-]*`, or an
  /// attribute name `[a-z][a-z0-9_:.-]*`.
  ///
  /// Output is still well-formed and contains only the elements and
  /// attributes the rules allow.
  RuleSet.unsafe(
    Map<String, ElementRule> rules, {
    List<ElementPattern> exemptions = const [],
  }) : this._(rules, exemptions, checked: false);

  RuleSet._(
    Map<String, ElementRule> rules,
    List<ElementPattern> exemptions, {
    required bool checked,
  })  : _rules = Map.unmodifiable(rules),
        _patterns = _byTagName(exemptions) {
    for (final MapEntry(key: name, value: rule) in rules.entries) {
      _check(name, rule.attributes, checked: checked);
    }
    for (final pattern in exemptions) {
      final matched = pattern.match.keys.toSet();
      _check(pattern.tagName, pattern.match,
          checked: checked, parameter: 'exemptions', matched: matched);
      _check(pattern.tagName, pattern.attributes,
          checked: checked, parameter: 'exemptions', matched: matched);
    }
  }

  static void _check(
    String name,
    Map<String, AttributeRule> attributes, {
    required bool checked,
    String parameter = 'rules',
    Set<String> matched = const {},
  }) {
    if (!isWritableTagName(name)) {
      throw ArgumentError.value(name, parameter, 'not a writable tag name');
    }
    for (final attribute in attributes.keys) {
      if (!isWritableAttributeName(attribute)) {
        throw ArgumentError.value(
          attribute,
          parameter,
          'not a writable attribute name on <$name>',
        );
      }
    }
    if (checked) {
      checkGrants(name, attributes, matched: matched);
    }
  }

  static Map<String, List<ElementPattern>> _byTagName(
    Iterable<ElementPattern> patterns,
  ) {
    final result = <String, List<ElementPattern>>{};
    for (final pattern in patterns) {
      (result[pattern.tagName] ??= []).add(pattern);
    }
    return result;
  }

  RuleSet._combined(this._rules, this._patterns);

  /// The rules for Markdown rendered by `package:markdown` with
  /// `ExtensionSet.gitHubWeb` or `gitHubFlavored`, raw HTML included.
  ///
  /// [html-pipeline][1]'s allowlist, the open-source origin of GitHub's
  /// Markdown pipeline, plus what `package:markdown` emits, minus what
  /// reaches outside the content:
  ///
  ///  * `id` only with the `user-content-` prefix (see
  ///    `HtmlRewriter.prefixIds`), `name` never;
  ///  * `class` only with `markdown-*` tokens, and `language-*` on `<code>`;
  ///  * `rel` only with `nofollow`, `noopener`, `noreferrer`, `ugc`,
  ///    `sponsored`, `external` and `help`, the link types that describe the
  ///    link rather than the page it is on;
  ///  * no `accesskey`, `tabindex`, `for`, `usemap`, `aria-describedby`,
  ///    `aria-labelledby` or form attributes;
  ///  * `<input>` only as a checkbox.
  ///
  /// [1]: https://github.com/gjtorikian/html-pipeline/blob/c99d76dbfe817598387c371af342e25abdccd363/lib/html_pipeline/sanitization_filter.rb
  factory RuleSet.gfm() => gfmRuleSet;

  /// The rules for arbitrary HTML: what cannot reach outside the content.
  ///
  /// The tables of [safevalues][1], Google's HTML sanitizer, with:
  ///
  ///  * URL attributes checked by this package's policy;
  ///  * `rel` only with the link types defined for `<a>`, never `opener`;
  ///    `target` only `_self` or `_blank`;
  ///  * no `<link>`;
  ///  * no `autofocus`, `download`, `itemref`, `usemap`, `required`, `slot`
  ///    or `<slot>`, which bind the content to the host page.
  ///
  /// Like safevalues it keeps no `id`, `name`, `class`, `style`, `<iframe>`,
  /// `<form>`, `<input>`, `<button>`, `<textarea>` or `<label>`; add what the
  /// host can afford with [union].
  ///
  /// [1]: https://github.com/google/safevalues/blob/main/src/builders/html_sanitizer/sanitizer_table/default_sanitizer_table.ts
  factory RuleSet.html() => htmlRuleSet;

  /// What either rule set allows: attributes kept by either rule, and the
  /// exemptions of both, this rule set's first.
  ///
  /// A union with a [RuleSet.unsafe] is as unsafe as that rule set.
  RuleSet union(RuleSet other) => RuleSet._combined(
        {
          ..._rules,
          for (final MapEntry(key: name, value: rule) in other._rules.entries)
            name: switch (_rules[name]) {
              null => rule,
              final mine => mine.union(rule),
            },
        },
        {
          ..._patterns,
          for (final MapEntry(key: name, value: theirs)
              in other._patterns.entries)
            name: [...?_patterns[name], ...theirs],
        },
      );

  /// This rule set without [elements], their rules and their exemptions.
  ///
  /// ```dart
  /// RuleSet.gfm().without({'img', 'picture', 'source'})
  /// ```
  RuleSet without(Set<String> elements) => RuleSet._combined(
        {
          for (final MapEntry(key: name, value: rule) in _rules.entries)
            if (!elements.contains(name)) name: rule,
        },
        {
          for (final MapEntry(key: name, value: patterns) in _patterns.entries)
            if (!elements.contains(name)) name: patterns,
        },
      );

  /// This rule set with [element]'s rule narrowed by [rule].
  ///
  /// An attribute [rule] names is kept only if both keep it; everything else
  /// is unchanged. An [element] or attribute without a rule here stays
  /// without one.
  ///
  /// ```dart
  /// RuleSet.gfm().restrict('a', ElementRule(attributes: {
  ///   'href': AttributeRule.url((u) => u.host == 'pub.dev'),
  /// }))
  /// ```
  RuleSet restrict(String element, ElementRule rule) {
    final mine = _rules[element];
    if (mine == null) {
      return this;
    }
    return RuleSet._combined(
      {
        ..._rules,
        element: ElementRule(attributes: {
          for (final MapEntry(key: name, value: theirs)
              in mine.attributes.entries)
            name: switch (rule.attributes[name]) {
              null => theirs,
              final narrower => theirs.intersection(narrower),
            },
        }),
      },
      _patterns,
    );
  }

  /// This rule set with [exemptions] added after its own.
  RuleSet withExemptions(List<ElementPattern> exemptions) =>
      union(RuleSet(const {}, exemptions: exemptions));
}

/// Package-private operations on [RuleSet]; not exported.
extension RuleSetExtension on RuleSet {
  /// What an element called [name] keeps of [attributes], which may be
  /// modified and returned, or `null` if it is unwrapped.
  Map<String, String>? apply(String name, Map<String, String> attributes) {
    for (final pattern in _patterns[name] ?? const <ElementPattern>[]) {
      if (pattern.matches(attributes)) {
        return pattern.apply(attributes);
      }
    }
    return _rules[name]?.apply(attributes);
  }
}
