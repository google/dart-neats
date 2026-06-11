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

import '../util.dart';

extension RegExpChecksExt on Subject<RegExp> {
  /// The source pattern string of this regular expression.
  ///
  /// {@example /example/core/regexp/pattern.dart}
  Subject<String> get pattern => has((r) => r.pattern, 'pattern');

  /// Whether this regular expression matches case-insensitively.
  Subject<bool> get isCaseSensitive =>
      has((r) => r.isCaseSensitive, 'isCaseSensitive');

  /// Whether this regular expression matches multiple lines.
  Subject<bool> get isMultiLine => has((r) => r.isMultiLine, 'isMultiLine');

  /// Whether "." matches line terminators.
  Subject<bool> get isDotAll => has((r) => r.isDotAll, 'isDotAll');

  /// Whether this regular expression uses Unicode mode.
  Subject<bool> get isUnicode => has((r) => r.isUnicode, 'isUnicode');

  /// Extracts the first match of this regular expression in [input].
  ///
  /// {@example /example/core/regexp/first_match.dart}
  Subject<RegExpMatch?> firstMatch(String input) => context.nest(
    () => prefixFirst('has firstMatch on ', literal(input)),
    (r) => Extracted.value(r.firstMatch(input)),
  );

  /// Extracts all matches of this regular expression in [input].
  ///
  /// {@example /example/core/regexp/all_matches.dart}
  Subject<Iterable<RegExpMatch>> allMatches(String input) => context.nest(
    () => prefixFirst('has allMatches on ', literal(input)),
    (r) => Extracted.value(r.allMatches(input)),
  );

  /// Expects that this regular expression has at least one match in [input].
  ///
  /// {@example /example/core/regexp/has_match.dart}
  void hasMatch(String input) {
    context.expect(() => prefixFirst('matches ', literal(input)), (actual) {
      if (actual.hasMatch(input)) return null;
      return Rejection(
        which: [...prefixFirst('does not match ', literal(input))],
      );
    });
  }

  /// Expects that this regular expression has no matches in [input].
  ///
  /// {@example /example/core/regexp/has_no_match.dart}
  void hasNoMatch(String input) {
    context.expect(() => prefixFirst('does not match ', literal(input)), (
      actual,
    ) {
      final match = actual.firstMatch(input);
      if (match == null) return null;

      final start = match.start;
      var lineStart = input.lastIndexOf('\n', start);
      if (lineStart == -1) {
        lineStart = 0;
      } else {
        lineStart += 1;
      }

      var lineEnd = input.indexOf('\n', start);
      if (lineEnd == -1) {
        lineEnd = input.length;
      }

      final line = input.substring(lineStart, lineEnd);
      final offset = start - lineStart;
      final spaces = ' ' * offset;

      return Rejection(
        which: [
          ...prefixFirst(
            'matched ',
            postfixLast(' at index $start:', literal(match[0])),
          ),
          line,
          '$spaces^',
        ],
      );
    });
  }
}
