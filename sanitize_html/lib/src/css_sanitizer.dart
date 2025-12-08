import 'package:sanitize_html/src/html_sanitize_config.dart';

class CssSanitizer {
  /// Check forbidden CSS keywords (javascript: / expression / url("javascript:") / ...)
  static bool isSafeCssValue(String value) {
    final lower = value.toLowerCase().trim();

    // Allow safe data:image URLs inside url(...)
    if (lower.startsWith('url(')) {
      final inside = lower.substring(4, lower.endsWith(')') ? lower.length - 1 : lower.length).trim();
      if (HtmlSanitizeConfig.base64ImageRegex.hasMatch(inside)) {
        return true;
      }
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

  /// Main CSS inline sanitizer for style="..."
  static String sanitizeInline(String raw) {
    raw = raw.trim();
    if (raw.isEmpty) return '';

    final buf = StringBuffer();
    final declarations = raw.split(';');

    for (var d in declarations) {
      d = d.trim();
      if (d.isEmpty) continue;

      final colon = d.indexOf(':');
      if (colon <= 0) continue;

      final prop = d.substring(0, colon).trim().toLowerCase();
      var val = d.substring(colon + 1).trim();

      // Property not allowed → skip
      if (!HtmlSanitizeConfig.allowedCssProperties.contains(prop)) continue;

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
