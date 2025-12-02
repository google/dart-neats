import 'package:html/dom.dart';
import 'package:sanitize_html/src/attribute_policy.dart';
import 'package:sanitize_html/src/css_sanitizer.dart';
import 'package:sanitize_html/src/html_sanitize_config.dart';

class NodeSanitizer {
  final bool Function(String)? allowId;
  final bool Function(String)? allowClass;
  final Iterable<String>? Function(String)? addLinkRel;
  final List<String>? allowAttributes;
  final List<String>? allowTags;

  NodeSanitizer({
    required this.allowId,
    required this.allowClass,
    required this.addLinkRel,
    required this.allowAttributes,
    required this.allowTags,
  }) {
    _validateOverrideLists();
  }

  void _validateOverrideLists() {
    final forbiddenTags = HtmlSanitizeConfig.forbiddenTags;
    final forbiddenAttrs = HtmlSanitizeConfig.forbiddenAttributes;

    if (allowTags != null) {
      for (final tag in allowTags!) {
        final upper = tag.toUpperCase();
        if (forbiddenTags.contains(upper)) {
          throw ArgumentError(
            'Tag "$tag" cannot be allowed because it is forbidden '
            '(${forbiddenTags.join(', ')}).',
          );
        }
      }
    }

    if (allowAttributes != null) {
      for (final attr in allowAttributes!) {
        final lower = attr.toLowerCase();
        if (forbiddenAttrs.contains(lower)) {
          throw ArgumentError(
            'Attribute "$attr" cannot be allowed because it is forbidden '
            '(${forbiddenAttrs.join(', ')}).',
          );
        }
      }
    }
  }

  bool _isEncodedJs(String s) {
    final lower = s.toLowerCase().trim();
    if (lower.isEmpty) return false;

    // percent-encoded "javascript"
    if (lower.contains('%6a%61%76%61%73%63%72%69%70%74')) return true;

    // unicode-escaped (\6a\61...)
    if (HtmlSanitizeConfig.unicodeEscapeReg.hasMatch(lower)) return true;

    // base64 encoded javascript
    if (lower.startsWith('data:text') &&
        lower.contains('base64') &&
        RegExp(r'(?=.*amF2YXNjcmlwdA)(?=.*YWxlcnQ)', caseSensitive: false)
            .hasMatch(lower)) {
      return true;
    }

    return false;
  }

  bool _isDangerousRawJs(String s) {
    final trimmed = s.trim();
    if (trimmed.isEmpty) return false;

    for (final pattern in HtmlSanitizeConfig.signaturesDangerousRawJs) {
      if (trimmed.contains(pattern)) return true;
    }
    return false;
  }

  bool _shouldStripText(Text node) {
    final text = node.text;
    return _isDangerousRawJs(text) || _isEncodedJs(text);
  }

  bool _isUrlAttribute(String attrLower) {
    switch (attrLower) {
      case 'href':
      case 'src':
      case 'formaction':
      case 'poster':
      case 'data':
      case 'background':
        return true;
      default:
        return false;
    }
  }

  void _removeDangerousNamespaces(Element element) {
    element.attributes.removeWhere((k, v) {
      final key = k.toString().toLowerCase();
      return key.startsWith('xmlns') || key.contains(':');
    });
  }

  bool _containsHtmlMarkup(String v) {
    if (v.isEmpty) return false;
    final lower = v.toLowerCase();
    for (final p in HtmlSanitizeConfig.dangerousPatternsHtmlMarkup) {
      if (lower.contains(p)) return true;
    }
    return false;
  }

  void _sanitizeAttributes(Element node, String tagUpper) {
    _removeDangerousNamespaces(node);

    node.attributes.removeWhere((attr, value) {
      final attrLower = attr.toString().toLowerCase();

      if (allowAttributes?.contains(attrLower) == true) {
        return false;
      }

      if (_containsHtmlMarkup(value)) return true;

      if (_isUrlAttribute(attrLower) && _isEncodedJs(value)) {
        return true;
      }

      final ok = AttributePolicy.sanitizeAttribute(
        node,
        attrLower,
        value,
        allowId: allowId,
        allowClass: allowClass,
      );

      return !ok;
    });
  }

  void sanitize(Node node, {required bool allowUnwrap}) {
    if (node.nodeType == Node.COMMENT_NODE) {
      node.remove();
      return;
    }

    if (node is Text) {
      if (_shouldStripText(node)) {
        node.remove();
      }
      return;
    }

    if (node is! Element) {
      for (final c in node.nodes.toList()) {
        sanitize(c, allowUnwrap: true);
      }
      return;
    }

    final tagUpper = node.localName!.toUpperCase();

    if (HtmlSanitizeConfig.forbiddenTags.contains(tagUpper)) {
      node.remove();
      return;
    }

    if (tagUpper == 'STYLE') {
      final css = CssSanitizer.sanitizeStylesheet(node.text);
      if (css.isEmpty) {
        node.remove();
      } else {
        node.text = css;
      }
      return;
    }

    final isAllowedTag =
        HtmlSanitizeConfig.allowedElements.contains(tagUpper) ||
            (allowTags?.contains(tagUpper.toLowerCase()) ?? false);

    if (!isAllowedTag && allowUnwrap) {
      final parent = node.parent;
      if (parent == null) {
        node.remove();
        return;
      }

      final index = parent.nodes.indexOf(node);
      final children = node.nodes.toList();
      node.nodes.clear();

      parent.nodes
        ..removeAt(index)
        ..insertAll(index, children);

      for (final c in children) {
        sanitize(c, allowUnwrap: true);
      }
      return;
    }

    _sanitizeAttributes(node, tagUpper);

    if (tagUpper == 'A') {
      final attrs = node.attributes;
      final href = attrs['href'];
      if (href != null) {
        final rels = addLinkRel?.call(href);
        if (rels != null && rels.isNotEmpty) {
          final existing = attrs['rel']?.split(' ') ?? const [];
          attrs['rel'] = {...existing, ...rels}.join(' ');
        }
      }
    }

    for (final c in node.nodes.toList()) {
      sanitize(c, allowUnwrap: true);
    }
  }
}
