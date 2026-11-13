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
import 'dart:math' show max;

import 'fenced_code_block.dart';

/// Returns [source] with the content of [block] replaced by [content].
///
/// [content] is the logical content: no container prefix, no indentation,
/// `\n` line endings. This function adds [FencedCodeBlock.linePrefix] back,
/// lengthens the fences if [content] needs it, and uses the line ending of the
/// block's opening fence.
///
/// The [block] must have a closing fence.
String spliceContent(
  String source,
  FencedCodeBlock block,
  String content,
) {
  final close = block.closeFence!;

  final body = _body(block.linePrefix, content, block.newline);
  final contentStart = block.contentSpan.start.offset;
  final contentEnd = block.contentSpan.end.offset;

  final fence = _requiredFenceLength(block, content);
  if (fence == block.fenceLength) {
    return source.replaceRange(contentStart, contentEnd, body);
  }

  final extra = block.fenceChar * (fence - block.fenceLength);
  final open = block.openFence;
  return source
      .replaceRange(close.start.offset, close.start.offset, extra)
      .replaceRange(contentStart, contentEnd, body)
      .replaceRange(open.start.offset, open.start.offset, extra);
}

/// The fence length [block] needs in order to hold [content].
int _requiredFenceLength(FencedCodeBlock block, String content) {
  var longest = 0;
  for (final line in LineSplitter.split(content)) {
    final trimmed = line.trimLeft();
    var run = 0;
    while (run < trimmed.length && trimmed[run] == block.fenceChar) {
      run++;
    }
    longest = max(longest, run);
  }
  return max(block.fenceLength, longest + 1);
}

String _body(String prefix, String content, String newline) {
  if (content.isEmpty) return '';
  final blankPrefix = prefix.trimRight();

  final buffer = StringBuffer();
  for (final line in LineSplitter.split(content)) {
    buffer
      ..write(line.isEmpty ? blankPrefix : '$prefix$line')
      ..write(newline);
  }
  return buffer.toString();
}
