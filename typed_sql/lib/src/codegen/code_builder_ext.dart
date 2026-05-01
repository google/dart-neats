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

extension ExtensionBuilderExt on ExtensionBuilder {
  void documentation(String content) {
    docs.addAll(_documentationCommentLines(content));
  }
}

Iterable<String> _documentationCommentLines(String content) sync* {
  final lines = _trimLines(content).split('\n');

  // Find the boundaries to naturally skip leading and trailing empty lines
  final startIndex = lines.indexWhere((l) => l.trim().isNotEmpty);
  if (startIndex == -1) {
    return;
  }
  final endIndex = lines.lastIndexWhere((l) => l.trim().isNotEmpty);

  var previousWasEmpty = false;

  for (var i = startIndex; i <= endIndex; i++) {
    final line = lines[i].trimRight();
    final isEmpty = line.isEmpty;

    // Collapse multiple empty lines into one
    if (isEmpty && previousWasEmpty) {
      continue;
    }

    previousWasEmpty = isEmpty;
    yield isEmpty ? '///' : '/// $line';
  }
}

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
      .map(
        (line) => line.substring(switch (indentation) {
          -1 => 0,
          int i when (i < line.length) => i,
          int _ => line.length,
        }),
      )
      .join('\n');
}
