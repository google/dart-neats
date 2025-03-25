// Copyright 2025 Google LLC
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

import 'package:code_builder/code_builder.dart';
import 'package:collection/collection.dart';

extension MethodBuilderExt on MethodBuilder {
  void documentation(String content) {
    docs.addAll(_documentationCommentLines(content));
  }
}

Iterable<String> _documentationCommentLines(String content) =>
    _trimLines(content)
        .split('\n')
        .skipWhile((l) => l.trim().isEmpty)
        .toList()
        .reversed
        .skipWhile((l) => l.trim().isEmpty)
        .toList()
        .reversed
        .map((l) {
      l = l.trimRight();
      if (l.isEmpty) {
        return '///';
      }
      return '/// $l';
    });

/// Trim whitespace at the start of lines in [content]
String _trimLines(String content) {
  final indentation = content
      .split('\n')
      .where((line) => line.contains(RegExp(r'[^ \t]')))
      .map(
        (line) => line.indexOf(RegExp(r'[^ ]')),
      )
      .min;
  return content
      .split('\n')
      .map((line) => line.substring(switch (indentation) {
            -1 => 0,
            int i when (i < line.length) => i,
            int _ => line.length,
          }))
      .join('\n');
}
