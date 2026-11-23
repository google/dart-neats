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

/// Implements `HtmlRewriter.prefixIds`.
library;

import '../delegating_html_token_sink.dart';
import '../html_rewriter.dart';

/// See `HtmlRewriter.prefixIds`.
HtmlRewriter prefixIds(String prefix) =>
    HtmlRewriter((sink) => _PrefixIds(prefix, sink));

final class _PrefixIds extends DelegatingHtmlTokenSink {
  final String _prefix;

  _PrefixIds(this._prefix, super.sink);

  @override
  void startTag(String name, Map<String, String> attributes) {
    if (attributes.isEmpty) {
      super.startTag(name, attributes);
      return;
    }
    final id = attributes['id'];
    if (id != null && !id.startsWith(_prefix)) {
      attributes['id'] = '$_prefix$id';
    }
    final href = attributes['href'];
    if (href != null &&
        href.length > 1 &&
        href.startsWith('#') &&
        !href.startsWith(_prefix, 1)) {
      attributes['href'] = '#$_prefix${href.substring(1)}';
    }
    super.startTag(name, attributes);
  }
}
