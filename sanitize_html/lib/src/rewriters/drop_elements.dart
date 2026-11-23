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

/// Implements `HtmlRewriter.dropElements`.
library;

import '../delegating_html_token_sink.dart';
import '../html_rewriter.dart';
import '../html_writer.dart' show isVoidElement;

/// See `HtmlRewriter.dropElements`.
HtmlRewriter dropElements({
  Set<String>? tagNames,
  bool Function(Map<String, String> attributes)? where,
}) =>
    HtmlRewriter((sink) => _DropElements(tagNames, where, sink));

/// Drops matching elements with their content, counting same-name nesting
/// so that `<x><x></x>still dropped</x>` drops the whole subtree.
final class _DropElements extends DelegatingHtmlTokenSink {
  final Set<String>? _tagNames;
  final bool Function(Map<String, String>)? _where;
  String? _droppedName;
  int _droppedDepth = 0;

  _DropElements(this._tagNames, this._where, super.sink);

  @override
  void text(String source, int start, int end) {
    if (_droppedDepth > 0) {
      return;
    }
    super.text(source, start, end);
  }

  @override
  void startTag(String name, Map<String, String> attributes) {
    if (_droppedDepth > 0) {
      if (name == _droppedName) {
        _droppedDepth++;
      }
      return;
    }
    if ((_tagNames?.contains(name) ?? true) &&
        (_where?.call(attributes) ?? true)) {
      if (!isVoidElement(name)) {
        _droppedName = name;
        _droppedDepth = 1;
      }
      return;
    }
    super.startTag(name, attributes);
  }

  @override
  void endTag(String name) {
    if (_droppedDepth > 0) {
      if (name == _droppedName) {
        _droppedDepth--;
      }
      return;
    }
    super.endTag(name);
  }
}
