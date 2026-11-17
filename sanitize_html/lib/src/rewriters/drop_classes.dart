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

/// Implements `HtmlRewriter.dropClasses`.
library;

import '../delegating_html_token_sink.dart';
import '../html_rewriter.dart';
import '../util/space_separated_tokens.dart';

/// See `HtmlRewriter.dropClasses`.
HtmlRewriter dropClasses(bool Function(String className) where) =>
    HtmlRewriter((sink) => _DropClasses(where, sink));

final class _DropClasses extends DelegatingHtmlTokenSink {
  final bool Function(String) _where;

  _DropClasses(this._where, super.sink);

  @override
  void startTag(String name, Map<String, String> attributes) {
    final value = attributes['class'];
    if (value != null) {
      final kept = value
          .split(asciiWhitespace)
          .where((c) => c.isNotEmpty && !_where(c))
          .join(' ');
      if (kept.isEmpty) {
        attributes.remove('class');
      } else {
        attributes['class'] = kept;
      }
    }
    super.startTag(name, attributes);
  }
}
