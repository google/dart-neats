import 'package:sanitize_html/src/html_sanitize_config.dart';

class UrlValidators {
  /// Common internal URI validator used by validLink() and validUrl().
  static Uri? _tryParse(String input) {
    if (input.isEmpty) return null;

    try {
      return Uri.parse(input);
    } catch (_) {
      return null;
    }
  }

  /// Validates a hyperlink (<a href>)
  ///
  /// Allowed:
  /// - http
  /// - https
  /// - mailto
  /// - URLs without scheme (relative links)
  static bool validLink(String url) {
    final uri = _tryParse(url);
    if (uri == null) return false;

    return uri.isScheme('https') ||
        uri.isScheme('http') ||
        uri.isScheme('mailto') ||
        !uri.hasScheme;
  }

  /// Validates a general URL (non-mailto)
  ///
  /// Allowed:
  /// - http
  /// - https
  /// - URLs without scheme
  static bool validUrl(String url) {
    final uri = _tryParse(url);
    if (uri == null) return false;

    return uri.isScheme('https') || uri.isScheme('http') || !uri.hasScheme;
  }

  /// Check base64 image header
  static bool validBase64Image(String v) {
    return HtmlSanitizeConfig.base64ImageRegex.hasMatch(v);
  }

  /// Check cid:xxx inline attachments
  static bool validCIDImage(String cid) {
    return cid.startsWith('cid:');
  }

  /// Unified image source validator for <img src>
  ///
  /// Allowed:
  /// - http/https or no-scheme URLs
  /// - data:image/*;base64
  /// - cid:xxxxx
  static bool validImageSource(String url) {
    return validUrl(url) || validBase64Image(url) || validCIDImage(url);
  }
}
