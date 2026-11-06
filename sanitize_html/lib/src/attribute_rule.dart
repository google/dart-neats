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

/// Rules for the value of an attribute.
///
/// A rule keeps or drops a value, never rewrites one, so a URL check is
/// never followed by anything that changes the URL it checked.
library;

import 'rules/link_types.dart';
import 'url_policy.dart';
import 'util/space_separated_tokens.dart';

/// Decides whether the value of an allowed attribute is kept.
///
/// ```dart
/// ElementRule(attributes: {
///   'href': AttributeRule.url(),
///   'title': AttributeRule.any(),
///   'class': AttributeRule.where((c) => c == 'hljs'),
/// })
/// ```
sealed class AttributeRule {
  const AttributeRule._();

  /// Keeps any value.
  const factory AttributeRule.any() = _Any;

  /// Keeps `http:`, `https:`, `mailto:` and relative URLs; with [where],
  /// only those for which it returns `true`.
  ///
  /// A checked `RuleSet` requires this rule on every URL-valued attribute.
  ///
  /// [where] receives the URL as the browser will parse it. Its host is the
  /// one the browser will use but is not normalized, so compare it to an
  /// allowlist, not a denylist:
  ///
  /// ```dart
  /// AttributeRule.url((uri) => uri.host == 'example.com')
  /// ```
  const factory AttributeRule.url([bool Function(Uri url)? where]) = _Url;

  /// Keeps a `srcset` whose every candidate URL [url] would keep; with
  /// [where], only if it returns `true` for the candidates.
  const factory AttributeRule.srcset([bool Function(List<Uri> urls)? where]) =
      _Srcset;

  /// Keeps a `rel` whose tokens are all [link types][1] for `<a>` other than
  /// `opener`; with [where], only if it returns `true` for the tokens.
  ///
  /// A checked `RuleSet` requires this rule on `rel`: `opener` restores
  /// `window.opener` for a link opened in a new tab, which could then
  /// navigate the host page. [where] receives the tokens lowercased, as the
  /// browser compares them.
  ///
  /// [1]: https://html.spec.whatwg.org/multipage/links.html#linkTypes
  const factory AttributeRule.rel([bool Function(Set<String> tokens)? where]) =
      _Rel;

  /// Keeps values for which [allow] returns `true`.
  const factory AttributeRule.where(bool Function(String value) allow) = _Where;
}

final class _Any extends AttributeRule {
  const _Any() : super._();
}

final class _Url extends AttributeRule {
  final bool Function(Uri url)? where;
  const _Url([this.where]) : super._();
}

final class _Srcset extends AttributeRule {
  final bool Function(List<Uri> urls)? where;
  const _Srcset([this.where]) : super._();
}

final class _Rel extends AttributeRule {
  final bool Function(Set<String> tokens)? where;
  const _Rel([this.where]) : super._();
}

final class _Where extends AttributeRule {
  final bool Function(String value) allow;
  const _Where(this.allow) : super._();
}

final class _Union extends AttributeRule {
  final AttributeRule a, b;
  const _Union(this.a, this.b) : super._();
}

final class _Intersection extends AttributeRule {
  final AttributeRule a, b;
  const _Intersection(this.a, this.b) : super._();
}

/// Package-private operations on [AttributeRule]; not exported.
extension AttributeRuleExtension on AttributeRule {
  /// Whether an attribute with [value] is kept.
  bool keeps(String value) => switch (this) {
        _Any() => true,
        _Url(:final where) => switch (safeUrl(value)) {
            null => false,
            final url => where == null || where(url),
          },
        _Srcset(:final where) => switch (safeSrcset(value)) {
            null => false,
            final urls => where == null || where(urls),
          },
        _Rel(:final where) => switch (_relTokens(value)) {
            null => false,
            final tokens => where == null || where(tokens),
          },
        _Where(:final allow) => allow(value),
        _Union(:final a, :final b) => a.keeps(value) || b.keeps(value),
        _Intersection(:final a, :final b) => a.keeps(value) && b.keeps(value),
      };

  /// Whether every value this rule keeps passed the URL policy.
  bool get isUrlRestricted => switch (this) {
        _Url() => true,
        _Union(:final a, :final b) => a.isUrlRestricted && b.isUrlRestricted,
        _Intersection(:final a, :final b) =>
          a.isUrlRestricted || b.isUrlRestricted,
        _ => false,
      };

  /// Whether every value this rule keeps is a `rel` without `opener`.
  bool get isRelRestricted => switch (this) {
        _Rel() => true,
        _Union(:final a, :final b) => a.isRelRestricted && b.isRelRestricted,
        _Intersection(:final a, :final b) =>
          a.isRelRestricted || b.isRelRestricted,
        _ => false,
      };

  /// Whether every value this rule keeps is a `srcset` that passed the URL
  /// policy.
  bool get isSrcsetRestricted => switch (this) {
        _Srcset() => true,
        _Union(:final a, :final b) =>
          a.isSrcsetRestricted && b.isSrcsetRestricted,
        _Intersection(:final a, :final b) =>
          a.isSrcsetRestricted || b.isSrcsetRestricted,
        _ => false,
      };

  /// Keeps what this rule or [other] keeps.
  AttributeRule union(AttributeRule other) => switch ((this, other)) {
        (_Any(), _) || (_, _Any()) => const AttributeRule.any(),
        _ when identical(this, other) => this,
        _ => _Union(this, other),
      };

  /// Keeps what both this rule and [other] keep.
  AttributeRule intersection(AttributeRule other) => switch ((this, other)) {
        (_Any(), final rule) || (final rule, _Any()) => rule,
        _ when identical(this, other) => this,
        _ => _Intersection(this, other),
      };
}

/// The lowercased tokens of a `rel` [value], or `null` unless there is at
/// least one and all are in [anchorLinkTypes].
Set<String>? _relTokens(String value) {
  final tokens = {
    for (final token in value.split(asciiWhitespace))
      if (token.isNotEmpty) token.toLowerCase(),
  };
  if (tokens.isEmpty || !tokens.every(anchorLinkTypes.contains)) {
    return null;
  }
  return tokens;
}
