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

/// An exact form of an element, kept as an exemption.
///
/// A pattern is judged on the element as written, with its own rules, and
/// is never merged with another.
library;

import 'attribute_rule.dart';
import 'util/space_separated_tokens.dart';

/// An element kept in one exact form, as an exemption from the rules.
///
/// Matches a `tagName` element that has every attribute in `match`, each
/// passing its rule, judged on the element as written. It then keeps
/// those attributes and the ones in `attributes` that pass, nothing else.
/// Patterns are tried before the element's `ElementRule`; the first match
/// decides.
///
/// For elements acceptable only in one form, which per-attribute rules
/// cannot say:
///
/// ```dart
/// // An <input> only as a checkbox.
/// ElementPattern('input', match: {
///   'type': AttributeRule.where((v) => v == 'checkbox'),
/// }, attributes: {
///   'checked': AttributeRule.any(),
///   'disabled': AttributeRule.any(),
/// })
///
/// // An <iframe> only from one origin, and only sandboxed.
/// ElementPattern('iframe', match: {
///   'src': AttributeRule.url((u) => u.host == 'www.youtube.com'),
///   'sandbox': AttributeRule.where((v) => v == 'allow-scripts allow-same-origin'),
/// }, attributes: {
///   'width': AttributeRule.any(),
///   'height': AttributeRule.any(),
/// })
/// ```
///
/// A pattern is never merged with other rules: no `RuleSet.union` can make
/// the frame above match another origin. Two acceptable forms are two
/// patterns.
///
/// Throws if an attribute is in both `match` and `attributes`.
final class ElementPattern {
  final String _tagName;
  final Map<String, AttributeRule> _match;
  final Map<String, AttributeRule> _attributes;

  ElementPattern(
    String tagName, {
    required Map<String, AttributeRule> match,
    Map<String, AttributeRule> attributes = const {},
  })  : _tagName = tagName,
        _match = Map.unmodifiable(match),
        _attributes = Map.unmodifiable(attributes) {
    for (final name in attributes.keys) {
      if (match.containsKey(name)) {
        throw ArgumentError.value(name, 'attributes', 'is also in match');
      }
    }
  }

  /// `<input type="checkbox">` with optional `checked` and `disabled`: the
  /// one `<input>` that can neither be typed into nor submitted.
  factory ElementPattern.checkbox() => ElementPattern(
        'input',
        match: {'type': AttributeRule.where((value) => value == 'checkbox')},
        attributes: {
          'checked': AttributeRule.any(),
          'disabled': AttributeRule.any(),
        },
      );

  /// An `<iframe>` whose `src` [where] accepts and whose `sandbox` is
  /// present with exactly the tokens in [sandbox].
  ///
  /// Keeps `width`, `height`, `title`, `loading` and `allowfullscreen`, but
  /// not:
  ///
  ///  * `allow`: delegates the host's permissions;
  ///  * `name`: catches the host's `target`s.
  ///
  /// ```dart
  /// RuleSet.gfm().withExemptions([
  ///   ElementPattern.iframe(
  ///     where: (src) =>
  ///         src.host == 'www.youtube.com' && src.path.startsWith('/embed/'),
  ///     sandbox: {'allow-scripts', 'allow-same-origin'},
  ///   ),
  /// ])
  /// ```
  ///
  /// A checked `RuleSet` allows `<iframe>` only through a pattern like this
  /// one. Authors rarely write `sandbox`; add it with
  /// `HtmlRewriter.rewriteAttributes` before the rules. The YouTube player
  /// needs `allow-same-origin` (it reads its cookies), which is safe for a
  /// frame from another origin; never grant it together with
  /// `allow-scripts` to a frame from the host's own origin, which could then
  /// remove its sandbox.
  factory ElementPattern.iframe({
    required bool Function(Uri src) where,
    required Set<String> sandbox,
  }) =>
      ElementPattern(
        'iframe',
        match: {
          'src': AttributeRule.url(where),
          'sandbox': AttributeRule.where((value) {
            final tokens = _tokens(value);
            return tokens.length == sandbox.length &&
                tokens.every(sandbox.contains);
          }),
        },
        attributes: {
          'allowfullscreen': const AttributeRule.any(),
          'height': const AttributeRule.any(),
          'loading': AttributeRule.where(const {'eager', 'lazy'}.contains),
          'title': const AttributeRule.any(),
          'width': const AttributeRule.any(),
        },
      );
}

/// Package-private operations on [ElementPattern]; not exported.
extension ElementPatternExtension on ElementPattern {
  /// The element this pattern applies to.
  String get tagName => _tagName;

  /// Attributes that must be present and pass their rule.
  Map<String, AttributeRule> get match => _match;

  /// Attributes kept when present and passing their rule.
  Map<String, AttributeRule> get attributes => _attributes;

  /// Whether every attribute in [match] is present in [attributes] and
  /// passes.
  bool matches(Map<String, String> attributes) {
    for (final MapEntry(key: name, value: rule) in match.entries) {
      final value = attributes[name];
      if (value == null || !rule.keeps(value)) {
        return false;
      }
    }
    return true;
  }

  /// [attributes], which must match, with those this pattern does not keep
  /// removed.
  Map<String, String> apply(Map<String, String> attributes) {
    if (attributes.isEmpty) {
      return attributes;
    }
    attributes.removeWhere(
      (name, value) =>
          !match.containsKey(name) &&
          !(this.attributes[name]?.keeps(value) ?? false),
    );
    return attributes;
  }
}

/// The lowercased tokens of a space-separated [value].
Set<String> _tokens(String value) => {
      for (final token in value.split(asciiWhitespace))
        if (token.isNotEmpty) token.toLowerCase(),
    };
