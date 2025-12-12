import 'package:html/dom.dart';
import 'package:sanitize_html/src/css_sanitizer.dart';
import 'package:sanitize_html/src/html_sanitize_config.dart';
import 'package:sanitize_html/src/url_validators.dart';

class AttributePolicy {
  /// Pre-normalized attribute validators.
  static final Map<String, Map<String, bool Function(String)>> _validators =
      _normalizeTagAttributeValidators();

  static Map<String, Map<String, bool Function(String)>>
      _normalizeTagAttributeValidators() {
    final out = <String, Map<String, bool Function(String)>>{};
    AttributePolicy.tagAttributeValidators.forEach((tag, attrs) {
      final normalizedTag = tag.toUpperCase();
      out[normalizedTag] = {
        for (final entry in attrs.entries) entry.key.toLowerCase(): entry.value
      };
    });
    return out;
  }

  /// Original validator definitions.
  static final tagAttributeValidators =
      <String, Map<String, bool Function(String)>>{
    'A': {'href': UrlValidators.validLink},
    'IMG': {
      'src': UrlValidators.validImageSource,
      'longdesc': UrlValidators.validImageSource,
    },
    'DIV': {
      'itemscope': (_) => true,
      'itemtype': (_) => true,
    },
    'BLOCKQUOTE': {'cite': UrlValidators.validUrl},
    'DEL': {'cite': UrlValidators.validUrl},
    'INS': {'cite': UrlValidators.validUrl},
    'Q': {'cite': UrlValidators.validUrl},
  };

  static bool isSafeId(String id) =>
      HtmlSanitizeConfig.safeIdPattern.hasMatch(id);

  static bool isSafeClass(String c) =>
      HtmlSanitizeConfig.safeClassPattern.hasMatch(c);

  static bool sanitizeAttribute(
    Element node,
    String attr,
    String value, {
    bool Function(String)? allowId,
    bool Function(String)? allowClass,
  }) {
    final normalizedAttr = attr.toLowerCase();

    // 1. Forbidden attribute → reject immediately
    if (HtmlSanitizeConfig.forbiddenAttributes.contains(normalizedAttr)) {
      return false;
    }

    // 2. ID handling
    if (normalizedAttr == 'id') {
      return allowId != null ? allowId(value) : isSafeId(value);
    }

    // 3. Class handling
    if (normalizedAttr == 'class') {
      final original = node.className;
      if (original.isEmpty) return false;

      final parts = original.split(RegExp(r'\s+'));
      node.classes.clear();

      for (final c in parts) {
        if (c.isEmpty) continue;
        final ok = allowClass != null ? allowClass(c) : isSafeClass(c);
        if (ok) node.classes.add(c);
      }

      return node.classes.isNotEmpty;
    }

    if (normalizedAttr == 'src' || normalizedAttr == 'href') {
      final raw = value.trim().toLowerCase();
      if (raw.startsWith('//')) return false;
    }

    // 4. Inline style sanitization
    if (normalizedAttr == 'style') {
      final sanitized = CssSanitizer.sanitizeInline(value);
      if (sanitized.isEmpty) return false;
      node.attributes['style'] = sanitized;
      return true;
    }

    // 5. Attribute always allowed (e.g., aria-*, role, etc.)
    if (HtmlSanitizeConfig.alwaysAllowedAttributes.contains(normalizedAttr)) {
      return true;
    }

    // 6. Tag-specific attribute validators
    final tagName = node.localName?.toUpperCase();
    if (tagName != null) {
      final tagValidators = _validators[tagName];
      final validator = tagValidators?[normalizedAttr];
      if (validator != null) {
        return validator(value);
      }
    }

    // 7. Reject by default
    return false;
  }
}
