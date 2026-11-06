// Copyright 2026 Google LLC
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

/// Implements `HtmlRewriter.rewriteAttributes` and `HtmlRewriter.addLinkRel`.
library;

import '../delegating_html_token_sink.dart';
import '../html_rewriter.dart';
import '../url_policy.dart';

/// See `HtmlRewriter.rewriteAttributes`.
HtmlRewriter rewriteAttributes(
  void Function(Map<String, String> attributes) rewrite, {
  String? tagName,
}) =>
    HtmlRewriter((sink) => _RewriteAttributes(tagName, rewrite, sink));

/// See `HtmlRewriter.addLinkRel`.
HtmlRewriter addLinkRel(List<String> Function(Uri href) rel) =>
    rewriteAttributes(tagName: 'a', (attributes) {
      final value = attributes['href'];
      if (value == null) {
        return;
      }
      final href = safeUrl(value);
      if (href == null) {
        return;
      }
      final tokens = rel(href);
      if (tokens.isEmpty) {
        attributes.remove('rel');
      } else {
        attributes['rel'] = tokens.join(' ');
      }
    });

final class _RewriteAttributes extends DelegatingHtmlTokenSink {
  final String? _tagName;
  final void Function(Map<String, String>) _rewrite;

  _RewriteAttributes(this._tagName, this._rewrite, super.sink);

  @override
  void startTag(String name, Map<String, String> attributes) {
    if (_tagName == null || name == _tagName) {
      // Tags without attributes may carry a shared const map.
      if (attributes.isEmpty) {
        attributes = {};
      }
      _rewrite(attributes);
    }
    super.startTag(name, attributes);
  }
}
