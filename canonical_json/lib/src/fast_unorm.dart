// Copyright 2019 Google LLC
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

import 'package:unorm_dart/unorm_dart.dart' show nfc;

/// Fast path Unicode Normalization Form C
///
/// Following [macchiato NFC FAQ][1] code-points below `\u0300` will never need
/// normalization. Most strings are just ASCII and this will allow them through
/// the fast path.
///
/// [1] http://www.macchiato.com/unicode/nfc-faq#TOC-Parsing-tokens-is-very-performance-sensitive-won-t-normalizing-be-too-costly-
String fastNfc(String s) {
  for (var i = 0; i < s.length; i++) {
    if (s.codeUnitAt(i) >= 300) {
      return nfc(s);
    }
  }
  return s;
}
