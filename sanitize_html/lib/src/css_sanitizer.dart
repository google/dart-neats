import 'package:sanitize_html/src/html_sanitize_config.dart';

class CssSanitizer {
  /// Check safe url(...)
  static bool _isSafeUrlValue(String raw) {
    final clean = raw.trim().toLowerCase();

    // url(x) extract
    if (!clean.startsWith("url(") || !clean.endsWith(")")) return false;

    String inside = clean.substring(4, clean.length - 1).trim();

    // Remove comments to avoid bypass
    inside = inside.replaceAll(RegExp(r'/\*.*?\*/', dotAll: true), '').trim();

    // Strip optional wrapping quotes: url("...") or url('...')
    if ((inside.startsWith('"') && inside.endsWith('"')) ||
        (inside.startsWith("'") && inside.endsWith("'"))) {
      inside = inside.substring(1, inside.length - 1).trim();
    }

    // Block protocol-relative URL
    if (inside.startsWith("//")) return false;

    // Block javascript: data: vbscript:
    if (inside.startsWith("javascript:")) return false;
    if (inside.startsWith("vbscript:")) return false;

    // Block non-image data: URIs
    if (inside.startsWith("data:") &&
        !HtmlSanitizeConfig.base64ImageRegex.hasMatch(inside)) {
      return false;
    }

    // Allow base64 image
    if (HtmlSanitizeConfig.base64ImageRegex.hasMatch(inside)) return true;

    // Allow http, https, relative path
    if (inside.startsWith("/") ||
        inside.startsWith("http://") ||
        inside.startsWith("https://")) {
      return true;
    }

    return false;
  }

  // Strip CSS comments inside a value (/* ... */).
  static String _stripCssComments(String value) {
    if (!HtmlSanitizeConfig.cssCommentPattern.hasMatch(value)) {
      return value;
    }
    return value.replaceAll(HtmlSanitizeConfig.cssCommentPattern, ' ');
  }

  static int _findMatchingParen(String s, int startIndex) {
    bool inSingle = false;
    bool inDouble = false;
    int depth = 1;

    for (var i = startIndex; i < s.length; i++) {
      final c = s[i];

      if (c == "'" && !inDouble && _isNotEscaped(s, i)) {
        inSingle = !inSingle;
        continue;
      }
      if (c == '"' && !inSingle && _isNotEscaped(s, i)) {
        inDouble = !inDouble;
        continue;
      }

      if (inSingle || inDouble) continue;

      if (c == '(') {
        depth++;
      } else if (c == ')') {
        depth--;
        if (depth == 0) return i;
      }
    }
    return -1;
  }

  static bool _areAllUrlsSafeInValue(String original) {
    final lower = original.toLowerCase();
    var index = 0;

    while (true) {
      final urlIndex = lower.indexOf('url(', index);
      if (urlIndex == -1) break;

      final openParen = urlIndex + 4;
      final closeParen = _findMatchingParen(original, openParen);
      if (closeParen == -1) {
        return false;
      }

      final urlChunk = original.substring(urlIndex, closeParen + 1).trim();
      if (!_isSafeUrlValue(urlChunk)) {
        return false;
      }

      index = closeParen + 1;
    }

    return true;
  }

  /// Check forbidden CSS keywords (javascript: / expression / url("javascript:") / ...)
  static bool isSafeCssValue(String value) {
    if (value.isEmpty) return false;

    final withoutComments = _stripCssComments(value);
    var v = withoutComments.trim();
    if (v.isEmpty) return false;

    final lower = v.toLowerCase();

    if (lower.contains('url(')) {
      if (!_areAllUrlsSafeInValue(v)) {
        return false;
      }
    }

    for (final forbidden in HtmlSanitizeConfig.forbiddenCss) {
      if (lower.contains(forbidden)) {
        return false;
      }
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

      if (ch == "'" && !inDoubleQuote && _isNotEscaped(raw, i)) {
        inSingleQuote = !inSingleQuote;
        buffer.write(ch);
        continue;
      }
      if (ch == '"' && !inSingleQuote && _isNotEscaped(raw, i)) {
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

  static bool _isNotEscaped(String raw, int i) {
    if (i == 0) return true;
    // Count consecutive backslashes before position i
    var backslashCount = 0;
    for (var j = i - 1; j >= 0 && raw[j] == '\\'; j--) {
      backslashCount++;
    }

    // Even number of backslashes (including 0) means not escaped
    return backslashCount % 2 == 0;
  }

  /// Main CSS inline sanitizer for style="..."
  /// NOTE:
  /// For now we normalize only a subset of properties (sizes, common text layout).
  /// This keeps the sanitizer strict and simple. If we later see many benign
  /// styles being dropped, we can extend `_normalizeCommonProperties` and add
  /// per-property safe enums (similar to `safeOverflowValues`).
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
        final cleanedLowered = val.trim().toLowerCase();
        if (!HtmlSanitizeConfig.safeOverflowValues.contains(cleanedLowered)) {
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

  // Remove comments that exist outside any rule block.
// This avoids removing comments inside url() or property values.
  static String _stripTopLevelCssComments(String css) {
    final sb = StringBuffer();
    bool inComment = false;
    int i = 0;

    while (i < css.length) {
      if (!inComment &&
          i + 1 < css.length &&
          css[i] == '/' &&
          css[i + 1] == '*') {
        inComment = true;
        i += 2;
        continue;
      }

      if (inComment &&
          i + 1 < css.length &&
          css[i] == '*' &&
          css[i + 1] == '/') {
        inComment = false;
        i += 2;
        continue;
      }

      if (!inComment) sb.write(css[i]);

      i++;
    }

    return sb.toString();
  }

  /// NOTE ON PARSING LIMITATION
  /// ---------------------------
  /// This sanitizer uses a simple CSS block splitter based on the `}` character.
  /// It does *not* implement a full CSS parser and does *not* track string
  /// boundaries inside CSS rules.
  ///
  /// For example, CSS like:
  ///   content: '}';
  /// contains a `}` inside a quoted literal. Because the sanitizer splits blocks
  /// using `}`, such rules may be incorrectly parsed or rejected.
  ///
  /// This limitation is intentional for a security-focused sanitizer:
  /// - It avoids complexity of a full CSS parser
  /// - It prevents obfuscation attacks using crafted CSS strings
  /// - It may reject uncommon but valid CSS, which is acceptable in sanitized email HTML
  ///
  /// Developers should be aware that styles containing `}` inside string literals
  /// may be dropped by design.
  static String sanitizeStylesheet(String css) {
    css = css.trim();
    if (css.isEmpty) return '';

    // Remove top-level comments (outside declaration blocks)
    css = _stripTopLevelCssComments(css).trim();

    final buffer = StringBuffer();

    // Split by block }
    final blocks = css.split('}');

    for (var block in blocks) {
      block = block.trim();
      if (block.isEmpty) continue;

      final braceIdx = block.indexOf('{');
      if (braceIdx <= 0) continue;

      final selector = block.substring(0, braceIdx).trim();

      // Block @media, @supports, @keyframes, etc.
      if (selector.startsWith('@')) continue;

      final rawDeclarations = block.substring(braceIdx + 1).trim();

      // Use the same inline sanitizer so that:
      // - url() comment stripping works
      // - forbiddenCss inspection works uniformly
      // - multi-token url() checks are applied consistently
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
