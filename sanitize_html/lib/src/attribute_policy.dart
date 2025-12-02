import 'package:html/dom.dart';
import 'package:sanitize_html/src/css_sanitizer.dart';
import 'package:sanitize_html/src/html_sanitize_config.dart';
import 'package:sanitize_html/src/url_validators.dart';

class AttributePolicy {
  static final Map<String, Map<String, bool Function(String)>> _validators =
      _preNormalizeTagValidators();

  static Map<String, Map<String, bool Function(String)>>
      _preNormalizeTagValidators() {
    final out = <String, Map<String, bool Function(String)>>{};
    AttributePolicy.tagAttributeValidators.forEach((tag, attrs) {
      final normalized = tag.toUpperCase();
      final newMap = <String, bool Function(String)>{};
      attrs.forEach((a, fn) {
        newMap[a.toLowerCase()] = fn;
      });
      out[normalized] = newMap;
    });
    return out;
  }

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
    final a = attr.toLowerCase();

    if (HtmlSanitizeConfig.forbiddenAttributes.contains(a)) return false;

    if (a == 'id') {
      return allowId != null ? allowId(value) : isSafeId(value);
    }

    if (a == 'class') {
      final original = node.className;
      if (original.isEmpty) return false;

      final parts = original.split(' ');
      node.classes.clear();

      for (final c in parts) {
        if (c.isEmpty) continue;
        final ok = allowClass != null ? allowClass(c) : isSafeClass(c);
        if (ok) node.classes.add(c);
      }

      return node.classes.isNotEmpty;
    }

    if (a == 'style') {
      final sanitized = CssSanitizer.sanitizeInline(value);
      if (sanitized.isEmpty) return false;
      node.attributes['style'] = sanitized;
      return true;
    }

    if (HtmlSanitizeConfig.alwaysAllowedAttributes.contains(a)) return true;

    final tagName = node.localName?.toUpperCase();
    if (tagName != null) {
      final validators = _validators[tagName];
      if (validators != null) {
        final fn = validators[a];
        if (fn != null) return fn(value);
      }
    }

    return false;
  }
}
