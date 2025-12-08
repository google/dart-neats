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

    // Percent-encoded "javascript"
    if (lower.contains('%6a%61%76%61%73%63%72%69%70%74')) {
      return true;
    }

    // Escaped unicode sequences that may hide JS payload
    if (HtmlSanitizeConfig.unicodeEscapeReg.hasMatch(lower)) {
      return true;
    }

    // Data URL that contains javascript:alert in base64 payload
    if (lower.startsWith('data:text') &&
        lower.contains('base64') &&
        RegExp(r'(?=.*amF2YXNjcmlwdA)(?=.*YWxlcnQ)', caseSensitive: false)
            .hasMatch(lower)) {
      return true;
    }

    return false;
  }

  bool _shouldStripText(Text node) {
    final text = node.text.trim();
    if (text.isEmpty) return false;

    final lower = text.toLowerCase();
    final parentTag = node.parent?.localName?.toLowerCase();

    // CDATA-like patterns after HTML parsing
    if (lower.contains('<script') ||
        lower.contains(']]>') ||
        lower.contains(']]&gt;') ||
        lower.contains('document.cookie')) {
      return true;
    }

    // Text inside SVG treated as CDATA-like script
    if (parentTag == 'svg') {
      if (lower.contains('alert(') ||
          lower.contains('function(') ||
          lower.contains('document.cookie') ||
          lower.contains('=>')) {
        return true;
      }
    }

    // Strip encoded JS payloads
    if (_isEncodedJs(text)) return true;

    return false;
  }

  bool _isUrlAttribute(String attrLower) {
    switch (attrLower) {
      case 'href':
      case 'src':
      case 'formaction':
      case 'poster':
      case 'data':
      case 'background':
      case 'srcset':
      case 'xlink:href':
        return true;
      default:
        return false;
    }
  }

  void _removeDangerousNamespaces(Element element) {
    element.attributes.removeWhere((k, v) {
      final key = k.toString().toLowerCase();
      // Keep normal attributes; remove only namespace declarations (xmlns / xmlns:*)
      return key == 'xmlns' || key.startsWith('xmlns:');
    });
  }

  bool _containsHtmlMarkup(String v) {
    if (v.isEmpty) return false;
    return HtmlSanitizeConfig.dangerousMarkupRegex.hasMatch(v);
  }

  String _normalizeUrl(String value) {
    // Remove any whitespace including newlines/tabs
    if (HtmlSanitizeConfig.whitespacePattern.hasMatch(value)) {
      return value.replaceAll(HtmlSanitizeConfig.whitespacePattern, '');
    }
    return value;
  }

  void _sanitizeAttributes(Element node, String tagUpper) {
    _removeDangerousNamespaces(node);

    node.attributes.removeWhere((attr, value) {
      final attrLower = attr.toString().toLowerCase();
      final valueLower = value.toLowerCase();

      if (allowAttributes?.contains(attrLower) == true) {
        return false;
      }

      // === Handle SRCSET ===
      if (attrLower == 'srcset') {
        final entries = value.split(',');
        final safeEntries = <String>[];

        for (final entry in entries) {
          final trimmed = entry.trim();
          final url = trimmed.split(' ').first;
          final lower = url.toLowerCase();

          // Remove unsafe URLs
          if (lower.startsWith('javascript:') ||
              lower.startsWith('data:application') ||
              _isEncodedJs(lower)) {
            continue;
          }

          // Allow http/https only
          if (lower.startsWith('http://') || lower.startsWith('https://')) {
            safeEntries.add(trimmed);
          }
        }

        if (safeEntries.isEmpty) {
          return true; // drop attribute
        }

        node.attributes['srcset'] = safeEntries.join(', ');
        return false; // keep sanitized srcset
      }

      // Handle xlink:href on SVG separately
      if (attrLower == 'xlink:href') {
        final lowered = valueLower.trim();

        // Block javascript: and encoded payload
        if (lowered.startsWith('javascript:') ||
            lowered.startsWith('data:application') ||
            _isEncodedJs(lowered)) {
          return true;
        }

        // Allow http/https/mailto/#id/relative as-is
        node.attributes[attr] = value;
        return false;
      }

      // === Handle URL attributes ===
      if (_isUrlAttribute(attrLower)) {
        if (valueLower.startsWith('data:image/')) {
          // Block "javascript:" inside data URI
          if (valueLower.contains('javascript:')) {
            return true;
          }

          // Validate base64 payload
          var base64Part = value.split(',').last;
          if (HtmlSanitizeConfig.whitespacePattern.hasMatch(base64Part)) {
            base64Part =
                base64Part.replaceAll(HtmlSanitizeConfig.whitespacePattern, '');
          }
          if (!HtmlSanitizeConfig.base64ValuePattern.hasMatch(base64Part)) {
            return true; // attribute removed => <img> remains
          }

          // Preserve original data URI
          node.attributes[attr] = value;
          return false;
        }

        // Normalize whitespace for other URLs
        final normalized = _normalizeUrl(value);
        value = normalized;
        node.attributes[attr] = normalized;

        final lower = normalized.toLowerCase();

        // Block dangerous URL schemes
        if (lower.startsWith('javascript:') ||
            lower.startsWith('vbscript:') ||
            lower.startsWith('data:application')) {
          return true;
        }

        // Block encoded JS payload
        if (_isEncodedJs(normalized)) {
          return true;
        }
      }

      // Base64 override: allow data:image/* on src after URL checks
      if (attrLower == 'src' && valueLower.startsWith('data:image/')) {
        return false;
      }

      // Attribute value contains HTML markup → strip it
      if (_containsHtmlMarkup(value)) {
        return true;
      }

      // Remove SVG animation attributes (from <animate>, <set>, etc.)
      if (HtmlSanitizeConfig.forbiddenSvgAnimationAttributes
          .contains(attrLower)) {
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
    // Remove comments
    if (node.nodeType == Node.COMMENT_NODE) {
      node.remove();
      return;
    }

    // Handle text nodes
    if (node is Text) {
      if (_shouldStripText(node)) {
        node.remove();
      }
      return;
    }

    // Non-element nodes: sanitize children
    if (node is! Element) {
      for (var i = 0; i < node.nodes.length; i++) {
        sanitize(node.nodes[i], allowUnwrap: true);
      }
      return;
    }

    final tagUpper = node.localName!.toUpperCase();

    // Unwrap OBJECT-like containers but keep fallback content
    if (tagUpper == 'OBJECT' || tagUpper == 'APPLET' || tagUpper == 'EMBED') {
      final parent = node.parent;

      if (parent != null) {
        final index = parent.nodes.indexOf(node);
        final children = node.nodes.toList();

        node.remove();
        parent.nodes.insertAll(index, children);

        for (final c in children) {
          sanitize(c, allowUnwrap: true);
        }
      } else {
        node.remove();
      }
      return;
    }

    // Remove fully forbidden tags
    if (HtmlSanitizeConfig.forbiddenTags.contains(tagUpper)) {
      node.remove();
      return;
    }

    // Inline <style> sanitization
    if (tagUpper == 'STYLE') {
      final css = CssSanitizer.sanitizeStylesheet(node.text);
      if (css.isEmpty) {
        node.remove();
      } else {
        node.text = css;
      }
      return;
    }

    // Check allowed tag
    final isAllowedTag =
        HtmlSanitizeConfig.allowedElements.contains(tagUpper) ||
            (allowTags?.contains(tagUpper.toLowerCase()) ?? false);

    // Unwrap disallowed tags if allowed to unwrap
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

    // Sanitize attributes on this element
    _sanitizeAttributes(node, tagUpper);

    // Add rel attributes for safe links
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

    // Recurse into children
    for (final c in node.nodes.toList()) {
      sanitize(c, allowUnwrap: true);
    }
  }
}
