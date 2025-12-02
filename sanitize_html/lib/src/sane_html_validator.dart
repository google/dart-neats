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

import 'package:html/parser.dart' as html_parser;
import 'package:sanitize_html/src/node_sanitizer.dart';

/// An implementation of [html.NodeValidator] that only allows sane HTML tags
/// and attributes protecting against XSS.
///
/// Modeled after the [rules employed by Github][1] when sanitizing GFM (Github
/// Flavored Markdown). Notably this excludes CSS styles and other tags that
/// easily interferes with the rest of the page.
///
/// [1]: https://github.com/jch/html-pipeline/blob/master/lib/html/pipeline/sanitization_filter.rb
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

  String sanitize(String html) {
    if (html.isEmpty) return '';

    final doc = html_parser.parse(html);
    final body = doc.body;
    if (body == null) return '';

    _nodeSanitizer.sanitize(body, allowUnwrap: false);

    final output = body.innerHtml;
    return output.isEmpty ? '' : output.trim();
  }
}
