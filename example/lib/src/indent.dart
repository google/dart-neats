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

/// Removes the leading whitespace shared by every non-blank line of [source].
///
/// Blank and whitespace-only lines do not affect the shared prefix and become
/// empty. Leading whitespace is compared character-by-character so mixed tabs
/// and spaces only lose the prefix they actually share.
String stripIndentation(String source) {
  if (source.isEmpty) return '';
  final lines = LineSplitter.split(source).toList();

  String? common;
  for (final line in lines) {
    if (line.trim().isEmpty) continue;
    final indent = line.substring(0, line.length - line.trimLeft().length);
    if (common == null) {
      common = indent;
      continue;
    }
    var i = 0;
    while (i < common.length && i < indent.length && common[i] == indent[i]) {
      i++;
    }
    common = common.substring(0, i);
    if (common.isEmpty) break;
  }

  final prefixLength = common?.length ?? 0;
  final dedented = [
    for (final line in lines)
      line.trim().isEmpty ? '' : line.substring(prefixLength),
  ];
  return '${dedented.join('\n')}${source.endsWith('\n') ? '\n' : ''}';
}
