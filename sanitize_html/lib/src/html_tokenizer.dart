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

/// The tokenizers: how input is split into tags and text.
library;

import 'html_token_sink.dart';
import 'tokenizer/dom_tokenizer.dart';
import 'tokenizer/simple_tokenizer.dart';
import 'tokenizer/streaming_tokenizer.dart';

/// Splits HTML into tokens.
///
/// The tokenizers differ in speed and in fidelity to browsers on broken
/// markup, not in safety.
final class HtmlTokenizer {
  final void Function(String html, HtmlTokenSink sink) _tokenize;
  final bool _buildsTree;

  const HtmlTokenizer._(this._tokenize, {bool buildsTree = false})
      : _buildsTree = buildsTree;

  /// The default: follows the WHATWG tokenizer states, including comments,
  /// script data escaping and RAWTEXT and RCDATA elements, without building
  /// a tree.
  static const streaming = HtmlTokenizer._(tokenizeStreaming);

  /// A small tokenizer for well-formed HTML that degrades gracefully on
  /// everything else.
  static const simple = HtmlTokenizer._(tokenizeSimple);

  /// Parses a tree with `package:html` and walks it, so misnested markup is
  /// handled as browsers do.
  ///
  /// Slowest, and superlinear on deep nesting.
  static const dom = HtmlTokenizer._(tokenizeDom, buildsTree: true);

  /// Feeds the tokens of [html] to [sink], then closes it.
  void tokenize(String html, HtmlTokenSink sink) => _tokenize(html, sink);
}

/// Package-private operations on [HtmlTokenizer]; not exported.
extension HtmlTokenizerExtension on HtmlTokenizer {
  /// Whether the tokens already form a tree, as a browser would build it,
  /// so that `HtmlRewriter.impliedEndTags` has nothing to add.
  bool get buildsTree => _buildsTree;
}
