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

extension MatchChecksExt on Subject<Match> {
  /// The index in the string where the match starts.
  ///
  /// {@example /example/core/match/start.dart}
  Subject<int> get start => has((m) => m.start, 'start');

  /// The index in the string after the last character of the match.
  Subject<int> get end => has((m) => m.end, 'end');

  /// Returns the number of captured groups in the match.
  Subject<int> get groupCount => has((m) => m.groupCount, 'groupCount');

  /// The string on which this match was computed.
  Subject<String> get input => has((m) => m.input, 'input');

  /// Extracts the string matched by the given [group] index.
  ///
  /// {@example /example/core/match/group.dart}
  Subject<String?> group(int index) => context.nest(
    () => ['has group($index)'],
    (m) => Extracted.value(m.group(index)),
  );

  /// The string matched by the given [group] index.
  Subject<String?> operator [](int index) => group(index);
}
