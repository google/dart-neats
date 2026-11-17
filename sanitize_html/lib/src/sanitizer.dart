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

/// The rewriter that applies a `RuleSet`.
///
/// Every start tag goes through the rules; an element they do not keep is
/// unwrapped. Whether it was kept can depend on its attributes, so end tags
/// are matched against a stack of start tags, capped at the writer's
/// `maxDepth` and popped as the writer pops: closing a kept element pops
/// everything above it, closing an unwrapped one pops only itself.
library;

import 'html_rewriter.dart';
import 'html_token_sink.dart';
import 'html_writer.dart' show isVoidElement, maxDepth;
import 'rule_set.dart';

/// See `HtmlRewriter.sanitizer`.
HtmlRewriter sanitizer(RuleSet rules) =>
    HtmlRewriter((sink) => _Sanitizer(rules, sink));

final class _Sanitizer extends HtmlTokenSink {
  final RuleSet _rules;
  final HtmlTokenSink _sink;

  /// Open elements, with whether each was kept.
  final List<(String, bool)> _open = [];

  _Sanitizer(this._rules, this._sink);

  @override
  void text(String source, int start, int end) =>
      _sink.text(source, start, end);

  @override
  void startTag(String name, Map<String, String> attributes) {
    final kept = _rules.apply(name, attributes);
    if (!isVoidElement(name)) {
      if (_open.length >= maxDepth) {
        _open.removeLast();
      }
      _open.add((name, kept != null));
    }
    if (kept != null) {
      _sink.startTag(name, kept);
    }
  }

  @override
  void endTag(String name) {
    for (var i = _open.length - 1; i >= 0; i--) {
      final (openName, kept) = _open[i];
      if (openName != name) {
        continue;
      }
      if (kept) {
        _open.length = i;
        _sink.endTag(name);
      } else {
        _open.removeAt(i);
      }
      return;
    }
  }

  @override
  void close() {
    _open.clear();
    _sink.close();
  }
}
