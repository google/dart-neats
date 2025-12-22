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

    // Data URL that contains javascript in base64 payload (heuristic check)
    if (lower.startsWith('data:text') &&
        lower.contains('base64') &&
        RegExp(r'amF2YXNjcmlwdA', caseSensitive: false).hasMatch(lower)) {
      return true;
    }

    return false;
  }

  bool _shouldStripText(Text node) {
    final text = node.text.trim();
    if (text.isEmpty) return false;

    final lower = text.toLowerCase();

    // Strip literal CDATA markers (especially inside SVG)
     if (lower.contains('<![cdata[') || lower.contains(']]>')) {
       return true;
     }

    // Parser-breaking patterns
    if (lower.contains('<script') ||
    lower.contains(']]&gt;')) {
    return true;
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
        // Note: srcset and xlink:href are handled separately in _sanitizeAttributes
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
      final explicitlyAllowed = allowAttributes?.contains(attrLower) == true;

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
              lower.startsWith('vbscript:') ||
              lower.startsWith('data:application') ||
              lower.startsWith('data:text') ||
              _isEncodedJs(lower)) {
            continue;
          }

          // Allow http/https and relative URLs
          // Block protocol-relative URLs (//) which can bypass scheme checks
          if (lower.startsWith('//')) {
            continue;
          }

          // Allow data:image URLs for inline images (restrict to safe formats)
          if (lower.startsWith('data:image/')) {
            // Only allow safe raster formats, not SVG
            if (HtmlSanitizeConfig.safeBase64ImageRegex.hasMatch(lower)) {
              safeEntries.add(trimmed);
              continue;
            }
            continue; // skip unsafe data:image types
          }

          safeEntries.add(trimmed);
        }

        if (safeEntries.isEmpty) {
          return true; // drop attribute
        }

        node.attributes['srcset'] = safeEntries.join(', ');
        return false; // keep sanitized srcset
      }

      if (attrLower == 'xlink:href') {
        // normalize whitespace
        var normalized = _normalizeUrl(value).trim();
        var lower = normalized.toLowerCase();

        // strip CSS-style comments (to block ja/*x*/vascript:)
        normalized =
            normalized.replaceAll(RegExp(r'/\*.*?\*/', dotAll: true), '');
        lower = normalized.toLowerCase().trim();

        // block dangerous schemes
        if (lower.startsWith('javascript:') ||
            lower.startsWith('vbscript:') ||
            lower.startsWith('data:application') ||
            lower.startsWith('data:text') ||
            _isEncodedJs(lower)) {
          return true; // remove attribute
        }

        // block data:image/svgxml (SVG can contain scripts)
        if (lower.startsWith('data:image/svg')) {
          return true; // remove
        }

        // restrict data:image to safe raster formats only
        if (lower.startsWith('data:image/')) {
          if (!HtmlSanitizeConfig.safeBase64ImageRegex.hasMatch(lower)) {
            return true; // remove unsafe data:image
          }
        }

        // block protocol-relative URL
        if (lower.startsWith('//')) {
          return true; // remove
        }

        // write normalized version back to attribute
        node.attributes[attr] = normalized;
        value = normalized; // update value for subsequent checks
        // fall through to HTML markup, SVG animation, and AttributePolicy checks
      }

      // === Handle URL attributes ===
      if (_isUrlAttribute(attrLower)) {
        // Normalize whitespace (java script: → javascript:, etc.)
        final normalized = _normalizeUrl(value);
        value = normalized;
        node.attributes[attr] = normalized;

        final lower = normalized.toLowerCase();

        // Block dangerous URL schemes
        if (lower.startsWith('javascript:') ||
            lower.startsWith('vbscript:') ||
            lower.startsWith('data:application') ||
            lower.startsWith('data:text')) {
          return true;
        }

        // block data:image/svgxml (SVG can contain scripts)
        if (lower.startsWith('data:image/svg')) {
          return true;
        }

        // restrict data:image to safe raster formats only
        if (lower.startsWith('data:image/')) {
          if (!HtmlSanitizeConfig.safeBase64ImageRegex.hasMatch(lower)) {
            return true; // remove unsafe data:image
          }
        }

        // Block encoded / obfuscated JS payloads
        if (_isEncodedJs(normalized)) {
          return true;
        }
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

      // If explicitly allowed by name, keep the attribute after value checks.
      if (explicitlyAllowed) {
        return false;
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
      for (final child in node.nodes.toList()) {
        sanitize(child, allowUnwrap: true);
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
    final isAllowedTag = HtmlSanitizeConfig.allowedElements
            .contains(tagUpper) ||
        (allowTags?.map((t) => t.toUpperCase()).contains(tagUpper) ?? false);

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
