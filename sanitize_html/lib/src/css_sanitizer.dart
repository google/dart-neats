import 'package:sanitize_html/src/html_sanitize_config.dart';

class CssSanitizer {
  /// Check safe url(...)
  static bool _isSafeUrlValue(String raw) {
    final clean = raw.trim().toLowerCase();

    // url(x) extract
    if (!clean.startsWith("url(") || !clean.endsWith(")")) return false;

    final rawInside = clean.substring(4, clean.length - 1).trim();

    String inside = rawInside.trim().toLowerCase();

    // Remove comments to avoid bypass
    inside = inside.replaceAll(RegExp(r'/\*.*?\*/', dotAll: true), '').trim();

    // Block protocol-relative URL
    if (inside.startsWith("//")) return false;

    // Block javascript: data: vbscript:
    if (inside.startsWith("javascript:")) return false;
    if (inside.startsWith("vbscript:")) return false;

    // Allow base64 image
    if (HtmlSanitizeConfig.base64ImageRegex.hasMatch(inside)) return true;

    // Allow http, https, relative path
    if (inside.startsWith("/")
        || inside.startsWith("http://")
        || inside.startsWith("https://")) {
      return true;
    }

    return false;
  }

  /// Check forbidden CSS keywords (javascript: / expression / url("javascript:") / ...)
  static bool isSafeCssValue(String value) {
    final lower = value.toLowerCase().trim();

    if (lower.startsWith("url(")) {
      return _isSafeUrlValue(value);
    }

    for (final forbidden in HtmlSanitizeConfig.forbiddenCss) {
      if (lower.contains(forbidden)) return false;
    }
    return true;
  }

  /// Normalize whitespace: "0px   20px\n  " → "0px 20px"
  static String _normalizeWhitespace(String value) =>
      value.replaceAll(RegExp(r'\s+'), ' ').trim();

  /// Add px to pure integer width/height values:
  /// height: 10   → height: 10px
  static String _normalizeLengthUnits(String prop, String value) {
    if ((prop == 'height' ||
        prop == 'width' ||
        prop == 'min-height' ||
        prop == 'max-height' ||
        prop == 'min-width' ||
        prop == 'max-width') &&
        HtmlSanitizeConfig.unitlessNumberPattern.hasMatch(value)) {
      return '${value}px';
    }
    return value;
  }

  /// Special-case normalization for certain CSS properties
  static String _normalizeCommonProperties(String prop, String value) {
    switch (prop) {
      case 'padding':
      case 'border':
        return _normalizeWhitespace(value);
      default:
        return value;
    }
  }

  static List<String> _splitCssDeclarations(String raw) {
    final result = <String>[];
    final buffer = StringBuffer();

    var inSingleQuote = false;
    var inDoubleQuote = false;
    var parenDepth = 0;

    for (var i = 0; i < raw.length; i++) {
      final ch = raw[i];

      if (ch == "'" && !inDoubleQuote) {
        inSingleQuote = !inSingleQuote;
        buffer.write(ch);
        continue;
      }
      if (ch == '"' && !inSingleQuote) {
        inDoubleQuote = !inDoubleQuote;
        buffer.write(ch);
        continue;
      }

      if (!inSingleQuote && !inDoubleQuote) {
        if (ch == '(') {
          parenDepth++;
          buffer.write(ch);
          continue;
        }
        if (ch == ')') {
          if (parenDepth > 0) parenDepth--;
          buffer.write(ch);
          continue;
        }

        if (ch == ';' && parenDepth == 0) {
          final part = buffer.toString().trim();
          if (part.isNotEmpty) {
            result.add(part);
          }
          buffer.clear();
          continue;
        }
      }

      buffer.write(ch);
    }

    final tail = buffer.toString().trim();
    if (tail.isNotEmpty) {
      result.add(tail);
    }

    return result;
  }

  /// Main CSS inline sanitizer for style="..."
  static String sanitizeInline(String raw) {
    raw = raw.trim();
    if (raw.isEmpty) return '';

    final buf = StringBuffer();
    final declarations = _splitCssDeclarations(raw);

    for (var d in declarations) {
      d = d.trim();
      if (d.isEmpty) continue;

      final colon = d.indexOf(':');
      if (colon <= 0) continue;

      final prop = d.substring(0, colon).trim().toLowerCase();
      var val = d.substring(colon + 1).trim();

      // Normalize raw value for quick safety check
      final rawVal = val.trim().toLowerCase();
        // Block protocol-relative URL used directly as value
      if (rawVal.startsWith("//")) {
        continue;
      }

      // Property not allowed → skip
      if (!HtmlSanitizeConfig.allowedCssProperties.contains(prop)) continue;

      // Special safe check for overflow properties
      if (prop == 'overflow' || prop == 'overflow-x' || prop == 'overflow-y') {
        final cleaned = val.trim();
        if (!HtmlSanitizeConfig.safeOverflowValues.contains(cleaned)) {
          continue;
        }
      }

      // Forbidden keywords → skip
      if (!isSafeCssValue(val)) continue;

      // Normalize units & whitespace based on property
      val = _normalizeLengthUnits(prop, val);
      val = _normalizeCommonProperties(prop, val);

      // Append to buffer
      if (buf.isNotEmpty) buf.write('; ');
      buf.write('$prop: $val');
    }

    return buf.toString();
  }

  /// Stylesheet sanitizer
  static String sanitizeStylesheet(String css) {
    css = css.replaceAll(HtmlSanitizeConfig.cssCommentPattern, '').trim();
    if (css.isEmpty) return '';

    final buffer = StringBuffer();
    final blocks = css.split('}');

    for (var block in blocks) {
      block = block.trim();
      if (block.isEmpty) continue;

      final braceIdx = block.indexOf('{');
      if (braceIdx <= 0) continue;

      final selector = block.substring(0, braceIdx).trim();

      // Block @media, @supports, @keyframes, @xyz (Gmail/Roundcube behavior)
      if (selector.startsWith('@')) continue;

      final rawDeclarations = block.substring(braceIdx + 1).trim();
      final sanitized = sanitizeInline(rawDeclarations);

      if (sanitized.isEmpty) continue;

      buffer
        ..write(selector)
        ..write(' { ')
        ..write(sanitized)
        ..writeln(' }');
    }

    return buffer.toString().trim();
  }
}
