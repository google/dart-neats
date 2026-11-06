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

/// Which attributes an element keeps.
library;

import 'attribute_rule.dart';

/// The attributes an allowed element keeps.
///
/// Each is filtered by its [AttributeRule]; attributes without a rule are
/// dropped. The element itself is always kept.
///
/// ```dart
/// ElementRule(attributes: {
///   'href': AttributeRule.url(),
///   'title': AttributeRule.any(),
/// })
/// ```
final class ElementRule {
  final Map<String, AttributeRule> _attributes;

  ElementRule({Map<String, AttributeRule> attributes = const {}})
      : _attributes = Map.unmodifiable(attributes);
}

/// Package-private operations on [ElementRule]; not exported.
extension ElementRuleExtension on ElementRule {
  /// The attribute rules.
  Map<String, AttributeRule> get attributes => _attributes;

  /// [attributes] with those this rule does not keep removed.
  Map<String, String> apply(Map<String, String> attributes) {
    if (attributes.isEmpty) {
      return attributes;
    }
    attributes.removeWhere(
      (name, value) => !(_attributes[name]?.keeps(value) ?? false),
    );
    return attributes;
  }

  /// Keeps what this rule or [other] keeps.
  ElementRule union(ElementRule other) => ElementRule(attributes: {
        ..._attributes,
        for (final MapEntry(key: name, value: rule)
            in other._attributes.entries)
          name: switch (_attributes[name]) {
            null => rule,
            final mine => mine.union(rule),
          },
      });
}
