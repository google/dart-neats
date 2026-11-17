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

/// Assembles tokenizer, rewriters and writer into [sanitizeHtml].
library;

import 'dart:convert';

import 'attribute_rule.dart';
import 'element_rule.dart';
import 'rules/gfm.dart' show gfmElements;
import 'html_rewriter.dart';
import 'html_tokenizer.dart';
import 'html_writer.dart';
import 'rule_set.dart';

/// Sanitizes [html] with [rules].
///
/// Returns HTML with only the elements and attributes [rules] allow, by
/// default [RuleSet.gfm], with text and attribute values escaped. Elements
/// not allowed are unwrapped: tags removed, content kept.
///
/// ```dart
/// print(sanitizeHtml('<a href="javascript:alert();">evil link</a>'));
/// // Prints: <a>evil link</a>
///
/// final safe = sanitizeHtml(
///   untrusted,
///   rewriters: [
///     HtmlRewriter.prefixIds('user-content-'),
///     HtmlRewriter.addLinkRel((href) => ['ugc', 'nofollow']),
///   ],
/// );
/// ```
///
/// [rewriters] run before the rules, so they cannot add anything the rules
/// would not allow. [tokenizer] chooses how the input is split into tags and
/// text; the tokenizers differ in speed and in fidelity to browsers on broken
/// markup, not in safety.
///
/// The output is safe to insert where an HTML parser is in its data state,
/// such as inside `<div>` or `<body>`, but not into:
///
///  * attribute values;
///  * `<script>`, `<style>`, `<textarea>` or `<title>`;
///  * `<svg>`, `<math>` or XML documents.
///
/// No script runs. With the default rules, interference with the host page
/// is limited too: no unprefixed `id`, no `name`, no CSS, no forms, `class`
/// only as Markdown renderers emit it. Content that is merely misleading,
/// such as links to malicious sites, is not prevented.
///
/// [allowElementId], [allowClassName] and [addLinkRel] are the version 2
/// parameters, kept so that existing calls compile: `id`s and `class` tokens
/// are kept when the callback returns `true`, and `rel` of links with an
/// `href` is set to what the callback returns. Throws if they are combined
/// with [rules] or [rewriters].
String sanitizeHtml(
  String html, {
  RuleSet? rules,
  List<HtmlRewriter> rewriters = const [],
  HtmlTokenizer tokenizer = HtmlTokenizer.streaming,
  @Deprecated('Use rewriters: [HtmlRewriter.prefixIds(\'user-content-\')], '
      'or rules: RuleSet.gfm().union(...) with HtmlRewriter.rewriteAttributes')
  bool Function(String id)? allowElementId,
  @Deprecated('Use rules: RuleSet.gfm().union(...) and '
      'rewriters: [HtmlRewriter.dropClasses(...)]')
  bool Function(String className)? allowClassName,
  @Deprecated('Use rewriters: [HtmlRewriter.addLinkRel(...)]')
  Iterable<String>? Function(String href)? addLinkRel,
}) {
  // Compatibility with sanitize_html version 2.
  if (allowElementId != null || allowClassName != null || addLinkRel != null) {
    if (rules != null || rewriters.isNotEmpty) {
      throw ArgumentError(
        'allowElementId, allowClassName and addLinkRel cannot be combined '
        'with rules or rewriters',
      );
    }
    rules = _legacyRules;
    final allowId = allowElementId ?? _never;
    final allowClass = allowClassName ?? _never;
    rewriters = [
      HtmlRewriter.rewriteAttributes((attributes) {
        if (attributes['id'] case final id? when !allowId(id)) {
          attributes.remove('id');
        }
      }),
      HtmlRewriter.dropClasses((c) => !allowClass(c)),
      if (addLinkRel != null)
        HtmlRewriter.addLinkRel(
          (href) => addLinkRel(href.toString())?.toList() ?? const [],
        ),
    ];
  }

  late final String output;
  final writer =
      htmlWriter(StringConversionSink.withCallback((s) => output = s));
  tokenizer.tokenize(
      html,
      [
        if (!tokenizer.buildsTree) HtmlRewriter.impliedEndTags(),
        ...rewriters,
        HtmlRewriter.sanitizer(rules ?? RuleSet.gfm()),
      ].fuse().bind(writer));
  return output;
}

bool _never(String _) => false;

/// [RuleSet.gfm] with any `id` and `class` on every element, as version 2
/// allowed them before its callbacks filtered the values.
final _legacyRules = RuleSet.gfm().union(RuleSet({
  for (final element in gfmElements)
    element: ElementRule(attributes: {
      'id': const AttributeRule.any(),
      'class': const AttributeRule.any(),
    }),
}));
