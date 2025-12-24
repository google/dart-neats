class CssDangerousPatterns {
  CssDangerousPatterns._();

  // @import statements
  static final import =
  RegExp(r'@import\s+[^;]+;', caseSensitive: false);

  // Dangerous protocols
  static final javascript =
  RegExp(r'javascript\s*:', caseSensitive: false);
  static final vbscript =
  RegExp(r'vbscript\s*:', caseSensitive: false);

  // Legacy / dangerous functions
  static final expression =
  RegExp(r'expression\s*\(', caseSensitive: false);

  // SVG / HTML event handlers: onload=, onclick=, onerror=, ...
  static final eventHandler =
  RegExp(r'on[a-z]+\s*=', caseSensitive: false);

  // data:text/* (explicit block)
  static final dataText =
  RegExp(r'data\s*:\s*text\/[a-z0-9.+-]+', caseSensitive: false);

  // Any data:<type>/<subtype>
  static final dataAny =
  RegExp(r'data\s*:\s*([a-z0-9.+-]+)\/([a-z0-9.+-]+)',
      caseSensitive: false);
}
