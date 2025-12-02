class UrlValidators {
  static final RegExp _base64ImageRegex = RegExp(
    r'^data:image\/(png|jpeg|jpg|gif|bmp|svg\+xml);base64,[A-Za-z0-9+/]+={0,2}$',
  );

  static bool validLink(String url) {
    if (url.isEmpty) return false;

    try {
      final uri = Uri.parse(url);

      return uri.isScheme('https') ||
          uri.isScheme('http') ||
          uri.isScheme('mailto') ||
          !uri.hasScheme;
    } catch (_) {
      return false;
    }
  }

  static bool validUrl(String url) {
    if (url.isEmpty) return false;

    try {
      final uri = Uri.parse(url);

      return uri.isScheme('https') || uri.isScheme('http') || !uri.hasScheme;
    } catch (_) {
      return false;
    }
  }

  static bool validBase64Image(String v) {
    return _base64ImageRegex.hasMatch(v);
  }

  static bool validCIDImage(String cid) {
    return cid.startsWith('cid:');
  }

  static bool validImageSource(String url) {
    return validUrl(url) || validBase64Image(url) || validCIDImage(url);
  }
}
