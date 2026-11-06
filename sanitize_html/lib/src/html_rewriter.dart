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

/// A step in the pipeline between tokenizer and writer.
library;

import 'attribute_rule.dart';
import 'html_token_sink.dart';
import 'html_tokenizer.dart';
import 'rewriters/attributes.dart';
import 'rewriters/implied_end_tags.dart';
import 'rewriters/drop_elements.dart';
import 'rewriters/drop_classes.dart';
import 'rewriters/prefix_ids.dart';
import 'rule_set.dart';
import 'sanitizer.dart' show sanitizer;

/// Rewrites the token stream between tokenizer and writer.
///
/// A rewriter wraps an [HtmlTokenSink] in a sink of its own; a custom one
/// is `HtmlRewriter(MySink.new)` where `MySink(HtmlTokenSink sink)`.
/// `a.fuse(b)` runs `a` then `b`, as does `[a, b].fuse()`; [bind] attaches
/// the sink at the end.
///
/// ```dart
/// sanitizeHtml(html, rewriters: [
///   HtmlRewriter.addLinkRel((href) => ['ugc', 'nofollow']),
///   HtmlRewriter.rewriteAttributes(tagName: 'h2', (attributes) {
///     attributes['id'] ??= slugify(attributes['title'] ?? '');
///   }),
/// ]);
/// ```
final class HtmlRewriter {
  final HtmlTokenSink Function(HtmlTokenSink sink) _bind;

  /// A rewriter that wraps a sink with the sink [bind] returns for it.
  const HtmlRewriter(this._bind);

  /// A rewriter that changes nothing.
  const HtmlRewriter.identity() : _bind = _identity;

  /// Calls [rewrite] with the attributes of every element, or of every
  /// [tagName] element, which it may change in place.
  factory HtmlRewriter.rewriteAttributes(
    void Function(Map<String, String> attributes) rewrite, {
    String? tagName,
  }) =>
      rewriteAttributes(rewrite, tagName: tagName);

  /// Adds `rel="..."` to `<a href="url">` tags, replacing any existing `rel`.
  ///
  /// Every `<a>` whose `href` the URL policy accepts gets the tokens [rel]
  /// returns, as in `HtmlRewriter.addLinkRel((href) => ['ugc', 'nofollow'])`
  /// to [qualify outbound links][1]. The author's `rel` is replaced, so that
  /// a token the rules refuse cannot cost the link the host's; an empty list
  /// removes `rel`.
  ///
  /// [rel] sees the `href` as [AttributeRule.url] will; a link whose `href`
  /// the policy refuses is left alone, since the rules drop that `href`.
  ///
  /// [1]: https://support.google.com/webmasters/answer/96569
  factory HtmlRewriter.addLinkRel(List<String> Function(Uri href) rel) =>
      addLinkRel(rel);

  /// Prefixes every `id`, and every `href` fragment (`#x`) to match, with
  /// [prefix] unless it already has it.
  ///
  /// Keeps author ids from clobbering the host page's, as GitHub does with
  /// `user-content-`, the only prefix `RuleSet.gfm` keeps.
  factory HtmlRewriter.prefixIds(String prefix) => prefixIds(prefix);

  /// Drops the class names for which [where] returns `true`, and `class`
  /// itself when none is left.
  ///
  /// Rules keep or drop a value whole; this drops the names a rule would
  /// refuse, e.g. `dropClasses((c) => !c.startsWith('language-'))`.
  factory HtmlRewriter.dropClasses(bool Function(String className) where) =>
      dropClasses(where);

  /// Drops elements with their content.
  ///
  /// An element is dropped when its name is in [tagNames], or [tagNames] is
  /// omitted, and its attributes satisfy [where], or [where] is omitted.
  ///
  /// Rules only unwrap what they do not keep; use this for whole subtrees,
  /// e.g. `dropElements(tagNames: {'nav', 'aside'})`.
  factory HtmlRewriter.dropElements({
    Set<String>? tagNames,
    bool Function(Map<String, String> attributes)? where,
  }) =>
      dropElements(tagNames: tagNames, where: where);

  /// Closes elements as the browser's tree builder would, so that every end
  /// tag after it closes exactly the innermost open element.
  ///
  ///  * an end tag also closes everything opened after its element, and an
  ///    end tag with no open element is dropped;
  ///  * `<p>` is closed by block elements;
  ///  * `<li>`, `<dt>`, `<dd>`, `<option>` and headings by the next of their
  ///    kind;
  ///  * cells, rows and row groups by the next cell, row or row group;
  ///  * an open `<a>` by a nested `<a>`.
  ///
  /// `sanitizeHtml` applies it first, except after [HtmlTokenizer.dom],
  /// whose tokens already form the tree a browser builds.
  factory HtmlRewriter.impliedEndTags() => impliedEndTags();

  /// Keeps the elements [rules] allow, with their attributes filtered, and
  /// unwraps every other element: its tags are dropped, its content kept.
  ///
  /// Must be the last rewriter before the writer.
  factory HtmlRewriter.sanitizer(RuleSet rules) => sanitizer(rules);

  /// This rewriter followed by [next].
  HtmlRewriter fuse(HtmlRewriter next) =>
      HtmlRewriter((sink) => bind(next.bind(sink)));

  /// The sink that applies this rewriter and pushes the result into [sink].
  HtmlTokenSink bind(HtmlTokenSink sink) => _bind(sink);
}

HtmlTokenSink _identity(HtmlTokenSink sink) => sink;

/// Composition of a sequence of [HtmlRewriter]s.
extension HtmlRewriters on Iterable<HtmlRewriter> {
  /// These rewriters in order; an empty sequence is [HtmlRewriter.identity].
  HtmlRewriter fuse() => fold(
        const HtmlRewriter.identity(),
        (fused, next) => fused.fuse(next),
      );
}
