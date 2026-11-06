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

/// Helpers for [space-separated token][1] attribute values such as `class`,
/// `rel` and `srcset` candidates.
///
/// [1]: https://html.spec.whatwg.org/multipage/common-microsyntaxes.html#space-separated-tokens
library;

/// [ASCII whitespace][1]: the separators of a space-separated token list.
///
/// [1]: https://infra.spec.whatwg.org/#ascii-whitespace
final asciiWhitespace = RegExp(r'[ \t\n\f\r]+');

/// Whether [value] is a non-empty space-separated list whose every token
/// satisfies [test].
bool everyToken(String value, bool Function(String token) test) {
  final tokens = value.split(asciiWhitespace).where((t) => t.isNotEmpty);
  return tokens.isNotEmpty && tokens.every(test);
}
