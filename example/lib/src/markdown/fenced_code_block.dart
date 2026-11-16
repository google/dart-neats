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

import 'dart:convert' show LineSplitter;

import 'package:source_span/source_span.dart';

/// A [fenced code block][1] located in the raw source of a markdown document.
///
/// [contentSpan] covers the exact range of whole lines that `update` replaces:
///
/// ```dart
/// final updated = source.replaceRange(
///   block.contentSpan.start.offset,
///   block.contentSpan.end.offset,
///   replacement,
/// );
/// ```
///
/// [1]: https://spec.commonmark.org/0.31.2/#fenced-code-blocks
final class FencedCodeBlock {
  /// Span of the opening fence delimiter (e.g. ```` ``` ```` or `~~~`).
  final FileSpan openFence;

  /// Span of the closing fence delimiter, or `null` if the block is unclosed.
  final FileSpan? closeFence;

  /// Span of the trimmed info string after [openFence].
  final FileSpan infoSpan;

  /// Span of the content lines, including their prefixes and line terminators;
  /// empty when the block has no content lines.
  final FileSpan contentSpan;

  /// Prefix before the content on each line: enclosing block quote markers,
  /// list item indentation, and the opening fence's own indentation.
  final String linePrefix;

  const FencedCodeBlock({
    required this.openFence,
    required this.closeFence,
    required this.infoSpan,
    required this.contentSpan,
    required this.linePrefix,
  });

  /// The fence character, either `` ` `` or `~`.
  String get fenceChar => openFence.text[0];

  /// Number of [fenceChar]s in [openFence]; always at least 3.
  int get fenceLength => openFence.length;

  /// The info string, trimmed.
  String get infoString => infoSpan.text;

  /// The logical content of the block: each line of [contentSpan] with up to
  /// [linePrefix] removed, terminated by `\n`.
  String get content {
    if (contentSpan.length == 0) return '';
    final buffer = StringBuffer();
    for (final line in LineSplitter.split(contentSpan.text)) {
      var i = 0;
      while (i < linePrefix.length &&
          i < line.length &&
          line.codeUnitAt(i) == linePrefix.codeUnitAt(i)) {
        i++;
      }
      buffer.writeln(line.substring(i));
    }
    return buffer.toString();
  }

  /// Line terminator of the opening fence line, or `'\n'` if it has none.
  String get newline {
    final tail = openFence.file.getText(
      infoSpan.end.offset,
      contentSpan.start.offset,
    );
    if (tail.endsWith('\r\n')) return '\r\n';
    if (tail.endsWith('\r')) return '\r';
    return '\n';
  }
}
