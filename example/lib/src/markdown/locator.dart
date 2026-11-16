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

import 'package:source_span/source_span.dart';
import 'package:string_scanner/string_scanner.dart';

import '../util/scanner.dart';
import 'fenced_code_block.dart';

/// Leading block quote markers (`> `), up to three spaces before each `>`.
final _blockquotePrefix = RegExp(r'(?: {0,3}> ?)+');

/// Optional spaces/tabs to the end of the line (including its line ending).
final _blankRestOfLine = RegExp(r'[ \t]*(?:\r\n|\r|\n|$)');

/// A list item marker (`-`, `+`, `*`, or `1.`) and the spaces after it.
final _listMarker = RegExp(r' {0,3}(?:[-+*]|\d{1,9}[.)]) +');

/// Up to three spaces of indentation before a code fence.
final _fenceIndent = RegExp(r' {0,3}');

/// An opening fence delimiter (` ``` ` with no backticks in its info string, or
/// `~~~`).
final _openFenceDelimiter = RegExp(r'`{3,}(?=[^`\r\n]*(?:\r|\n|$))|~{3,}');

/// A candidate closing fence delimiter (` ``` ` or `~~~`).
final _closeFenceDelimiter = RegExp(r'`{3,}|~{3,}');

/// Finds the fenced code blocks in [source] in document order.
Iterable<FencedCodeBlock> locateFencedCodeBlocks(FileSpan source) sync* {
  final scanner = SpanScanner.within(source);
  if (!scanner.string.contains('```') && !scanner.string.contains('~~~')) {
    return;
  }

  var listIndent = 0;
  while (!scanner.isDone) {
    final quotePrefix = scanner.scanText(_blockquotePrefix);
    if (scanner.scan(_blankRestOfLine)) continue;

    if (scanner.scan(_listMarker)) {
      listIndent = scanner.lastSpan!.length;
    } else if (!scanner.scan(' ' * listIndent)) {
      listIndent = 0;
    }
    final containerPrefix = '$quotePrefix${' ' * listIndent}';

    final indent = scanner.scanText(_fenceIndent);
    if (!scanner.scan(_openFenceDelimiter)) {
      scanner.skipLine();
      continue;
    }

    final openFence = scanner.lastSpan!;
    final infoSpan = scanner.scanLine().trim();
    final fenceChar = openFence.text[0];
    final fenceLength = openFence.length;
    final bareContainer = containerPrefix.trimRight();
    final contentStart = scanner.position;

    var contentEnd = contentStart;
    FileSpan? closeFence;
    while (!scanner.isDone) {
      final lineStart = scanner.position;

      if (scanner.scan(containerPrefix)) {
        scanner.scan(_fenceIndent);
        if (scanner.scan(_closeFenceDelimiter)) {
          final candidate = scanner.lastSpan!;
          if (candidate.text[0] == fenceChar &&
              candidate.length >= fenceLength &&
              scanner.scan(_blankRestOfLine)) {
            closeFence = candidate;
            break;
          }
        }
        scanner.skipLine();
      } else if (!scanner.scan(bareContainer) ||
          !scanner.scan(_blankRestOfLine)) {
        // The enclosing block quote or list item ended before a closing fence.
        scanner.position = lineStart;
        break;
      }
      contentEnd = scanner.position;
    }

    yield FencedCodeBlock(
      openFence: openFence,
      closeFence: closeFence,
      infoSpan: infoSpan,
      contentSpan: scanner.spanFromPosition(contentStart, contentEnd),
      linePrefix: '$containerPrefix$indent',
    );
  }
}
