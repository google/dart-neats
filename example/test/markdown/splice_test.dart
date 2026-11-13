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

import 'package:checks/checks.dart';
import 'package:example/src/markdown/fenced_code_block.dart';
import 'package:example/src/markdown/locator.dart';
import 'package:example/src/markdown/splice.dart';
import 'package:source_span/source_span.dart';
import 'package:test/scaffolding.dart';

List<FencedCodeBlock> locate(String source) =>
    locateFencedCodeBlocks(SourceFile.fromString(source).span(0)).toList();

/// Content chosen to break out of a code block if anything can.
const _nasty = [
  'x;\n',
  '',
  '```\n',
  '````\n~~~\n',
  'a\n\nb\n',
  '\t indented\n',
  '> quoted\n',
  '- item\n',
  '<div>\n',
  '# heading\n',
  '    four spaces\n',
  'trailing space \n',
];

/// Splices every closed block of [source] and checks that re-locating yields
/// the spliced content and leaves every other block intact.
void checkSplice(String source) {
  final before = locate(source);

  for (var i = 0; i < before.length; i++) {
    if (before[i].closeFence == null) continue;
    for (final content in _nasty) {
      final updated = spliceContent(source, before[i], content);
      final after = locate(updated);

      final where = 'block ${i + 1} of ${before.length} with '
          '${_visible(content)}';
      check(after, because: '$where: block count').length.equals(before.length);
      for (var j = 0; j < after.length; j++) {
        check(after[j].content, because: '$where: content of block ${j + 1}')
            .equals(j == i ? content : before[j].content);
        check(
          after[j].infoString,
          because: '$where: info string of block ${j + 1}',
        ).equals(before[j].infoString);
      }
    }
  }
}

String _visible(String s) =>
    "'${s.replaceAll('\n', r'\n').replaceAll('\t', r'\t')}'";

void main() {
  const documents = {
    'plain': '```dart\nx;\n```\n',
    'empty': '```dart\n```\n',
    'quoted': '> ```dart\n> x;\n> ```\n',
    'twice quoted': '> > ```dart\n> > x;\n> > ```\n',
    'in a list': '- item\n\n  ```dart\n  x;\n  ```\n',
    'in a numbered list': '10. item\n\n    ```dart\n    x;\n    ```\n',
    'indented fence': '   ```dart\n   x;\n   ```\n',
    'tilde fence': '~~~dart\nx;\n~~~\n',
    'long fence': '`````dart\nx;\n`````\n',
    'crlf': '```dart\r\nx;\r\n```\r\n',
    'two blocks': '```dart\nx;\n```\n\n```dart\nx;\n```\n',
    'nested fences': '````markdown\n```dart\nx;\n```\n````\n',
    'after a paragraph': 'prose\n\n```dart\nx;\n```\n\nmore prose\n',
  };

  for (final MapEntry(key: name, value: source) in documents.entries) {
    test(name, () => checkSplice(source));
  }
}
