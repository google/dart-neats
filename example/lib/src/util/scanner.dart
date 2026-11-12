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

final _restOfLine = RegExp(r'[^\r\n]*');
final _lineEnding = RegExp(r'\r\n|\r|\n');
final _whitespace = RegExp(r'[ \t]+');
final _nonWhitespace = RegExp(r'[^ \t]+');

extension StringScannerScanExtension on StringScanner {
  /// Scans [pattern] if it matches at [position], returning the matched text or
  /// `''`.
  String scanText(Pattern pattern) => scan(pattern) ? lastMatch![0]! : '';

  /// Advances past the remainder of the current line and its line ending.
  void skipLine() {
    scan(_restOfLine);
    scan(_lineEnding);
  }
}

extension SpanScannerScanExtension on SpanScanner {
  /// Scans to the end of the current line, consumes its line ending if any,
  /// and returns the span of the line without the line ending.
  FileSpan scanLine() {
    scan(_restOfLine);
    final line = lastSpan!;
    scan(_lineEnding);
    return line;
  }
}

extension FileSpanScanExtension on FileSpan {
  /// This span with leading and trailing spaces and tabs removed.
  FileSpan trim() {
    final text = this.text;
    var start = 0;
    var end = text.length;
    while (start < end && _isSpaceOrTab(text.codeUnitAt(start))) {
      start++;
    }
    while (end > start && _isSpaceOrTab(text.codeUnitAt(end - 1))) {
      end--;
    }
    return subspan(start, end);
  }

  /// Non-whitespace tokens (`[^ \t]+`) within this span.
  List<FileSpan> scanTokens() {
    final scanner = SpanScanner.within(this);
    final tokens = <FileSpan>[];
    while (!scanner.isDone) {
      scanner.scan(_whitespace);
      if (scanner.scan(_nonWhitespace)) {
        tokens.add(scanner.lastSpan!);
      }
    }
    return tokens;
  }
}

bool _isSpaceOrTab(int unit) => unit == 0x20 || unit == 0x09;
