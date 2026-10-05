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

extension RegExpMatchChecksExt on Subject<RegExpMatch> {
  /// Extracts the string matched by the named group [name].
  ///
  /// {@example /example/core/regexpmatch/named_group.dart}
  Subject<String?> namedGroup(String name) => context.nest(
    () => ['has namedGroup($name)'],
    (m) => Extracted.value(m.namedGroup(name)),
  );

  /// The names of the named groups in the match.
  Subject<Iterable<String>> get groupNames =>
      has((m) => m.groupNames, 'groupNames');
}
