// Copyright 2019 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:html/dom.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:sanitize_html/src/css_sanitizer.dart';
import 'package:sanitize_html/src/extracted_style.dart';
import 'package:sanitize_html/src/node_sanitizer.dart';

/// An implementation of [html.NodeValidator] that only allows sane HTML tags
/// and attributes protecting against XSS.
///
/// Modeled after the [rules employed by Github][1] when sanitizing GFM (Github
/// Flavored Markdown). Notably this excludes CSS styles and other tags that
/// easily interferes with the rest of the page.
///
/// [1]: https://github.com/jch/html-pipeline/blob/master/lib/html/pipeline/sanitization_filter.rb
///
///
/// Sanitizes HTML nodes using a DOM-based filtering approach
/// to mitigate XSS vectors.
///
/// This validator:
/// - removes all HTML comments (normal or malformed)
/// - filters elements and attributes based on NodeSanitizer rules
/// - returns only safe HTML content
///
/// Behavior follows common HTML email sanitization principles.
class SaneHtmlValidator {
  final bool Function(String)? allowElementId;
  final bool Function(String)? allowClassName;
  final Iterable<String>? Function(String)? addLinkRel;
  final List<String>? allowAttributes;
  final List<String>? allowTags;

  late final NodeSanitizer _nodeSanitizer;

  SaneHtmlValidator({
    required this.allowElementId,
    required this.allowClassName,
    required this.addLinkRel,
    required this.allowAttributes,
    required this.allowTags,
  }) {
    _nodeSanitizer = NodeSanitizer(
      allowId: allowElementId,
      allowClass: allowClassName,
      addLinkRel: addLinkRel,
      allowAttributes: allowAttributes,
      allowTags: allowTags,
    );
  }

  /// Remove all HTML comments, including malformed cases:
  /// - Standard comment: <!-- ... -->
  /// - Broken comment missing '-->'
  ///   → treat the first '>' after '<!--' as the end of the comment
  ///
  /// If no closing '>' is found, the remainder of the string is discarded.
  String _stripHtmlComments(String html) {
    final buffer = StringBuffer();
    var index = 0;

    while (index < html.length) {
      final start = html.indexOf('<!--', index);
      if (start == -1) {
        buffer.write(html.substring(index));
        break;
      }

      // Write text before comment
      buffer.write(html.substring(index, start));

      final commentStart = start + 4;
      final normalEnd = html.indexOf('-->', commentStart);

      if (normalEnd != -1) {
        index = normalEnd + 3;
        continue;
      }

      final fallback = html.indexOf('>', commentStart);
      if (fallback == -1) break;

      index = fallback + 1;
    }

    return buffer.toString();
  }

  /// Extracts raw CSS text from all <style> tags.
  /// - Preserves order
  /// - Removes <style> nodes from DOM after extraction
  List<ExtractedStyle> extractStyleTags(Document document) {
    final result = <ExtractedStyle>[];

    final styleElements = document.querySelectorAll('style');
    for (final style in styleElements) {
      final css = style.text.trim();
      if (css.isEmpty) {
        style.remove();
        continue;
      }

      result.add(
        ExtractedStyle(
          css: css,
          media: style.attributes['media'],
        ),
      );

      style.remove();
    }

    return result;
  }

  String rebuildStyleBlock(List<ExtractedStyle> styles) {
    if (styles.isEmpty) return '';

    return styles.map((s) {
      final mediaAttr = s.media != null ? ' media="${s.media}"' : '';
      return '<style$mediaAttr>${s.css}</style>';
    }).join('\n');
  }

  /// Sanitizes HTML:
  /// - strips comments
  /// - parses DOM
  /// - applies NodeSanitizer to <body>
  /// - returns sanitized inner HTML
  String sanitize(String html) {
    if (html.isEmpty) return '';

    final noComments = _stripHtmlComments(html);
    final document = html_parser.parse(noComments);

    // Extract internal CSS
    final extractedStyles = extractStyleTags(document);

    // Sanitize body
    final body = document.body;
    if (body == null) return '';

    _nodeSanitizer.sanitize(body, allowUnwrap: false);

    // Sanitize CSS
    final safeStyles = extractedStyles.map((s) {
      final safeCss = CssSanitizer.sanitizeStylesheet(s.css);
      return ExtractedStyle(css: safeCss, media: s.media);
    }).toList();

    // Rebuild HTML
    final styleBlock = rebuildStyleBlock(safeStyles);

    final output = body.innerHtml.trim();
    if (output.isEmpty) return '';

    // Avoid triple-quote indentation artifacts.
    // Keep styleBlock only when non-empty and always return a trimmed result.
    final pieces = <String>[
      if (styleBlock.trim().isNotEmpty) styleBlock.trim(),
      output,
    ];

    return pieces.join('\n').trim();
  }
}
