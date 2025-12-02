import 'package:sanitize_html/src/html_sanitize_config.dart';

class CssSanitizer {
  static bool isSafeCssValue(String value) {
    final lower = value.toLowerCase();
    for (final f in HtmlSanitizeConfig.forbiddenCss) {
      if (lower.contains(f)) return false;
    }
    return true;
  }

  static String sanitizeInline(String raw) {
    raw = raw.trim();
    if (raw.isEmpty) return '';

    final buf = StringBuffer();

    final items = raw.split(';');
    for (var d in items) {
      d = d.trim();
      if (d.isEmpty) continue;

      final colon = d.indexOf(':');
      if (colon <= 0) continue;

      final prop = d.substring(0, colon).trim().toLowerCase();
      final val = d.substring(colon + 1).trim();

      if (!HtmlSanitizeConfig.allowedCssProperties.contains(prop)) continue;
      if (!isSafeCssValue(val)) continue;

      if (buf.isNotEmpty) buf.write('; ');
      buf.write(prop);
      buf.write(': ');
      buf.write(val);
    }

    return buf.toString();
  }

  static String sanitizeStylesheet(String css) {
    css = css.replaceAll(HtmlSanitizeConfig.cssCommentPattern, '').trim();
    if (css.isEmpty) return '';

    final buffer = StringBuffer();
    final blocks = css.split('}');

    for (var block in blocks) {
      block = block.trim();
      if (block.isEmpty) continue;

      final brace = block.indexOf('{');
      if (brace <= 0) continue;

      final selector = block.substring(0, brace).trim();
      if (selector.startsWith('@')) continue;

      final declarations = block.substring(brace + 1).trim();
      final sanitized = sanitizeInline(declarations);
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
