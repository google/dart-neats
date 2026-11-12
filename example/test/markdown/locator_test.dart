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
import 'package:source_span/source_span.dart';
import 'package:test/scaffolding.dart';

import '../checks_ext.dart';

List<FencedCodeBlock> locate(String source) =>
    locateFencedCodeBlocks(SourceFile.fromString(source).span(0)).toList();

void main() {
  group('locates', () {
    test('a simple block', () {
      const source = '''
Hello

```dart
void main() {}
```

Bye
''';
      check(locate(source)).single
        ..infoString.equals('dart')
        ..fenceChar.equals('`')
        ..fenceLength.equals(3)
        ..contentSpan.text.equals('void main() {}\n')
        ..content.equals('void main() {}\n');
    });

    test('an empty block', () {
      const source = '```dart\n```\n';
      check(locate(source)).single
        ..content.equals('')
        ..contentSpan.startOffset.equals(8)
        ..contentSpan.endOffset.equals(8);
    });

    test('a block with no info string', () {
      check(locate('```\nx\n```\n')).single
        ..infoString.equals('')
        ..content.equals('x\n');
    });

    test('a block with a long info string', () {
      const source = '```dart example/hello.dart#greeting {.copy}\nx\n```\n';
      check(locate(source))
          .single
          .infoString
          .equals('dart example/hello.dart#greeting {.copy}');
    });

    test('a tilde fence whose info string contains backticks', () {
      check(locate('~~~dart `x`\ncontent\n~~~\n')).single
        ..fenceChar.equals('~')
        ..infoString.equals('dart `x`')
        ..content.equals('content\n');
    });

    test('a longer fence containing a shorter one', () {
      const source = '````md\n```dart\nx\n```\n````\n';
      check(locate(source)).single
        ..fenceLength.equals(4)
        ..content.equals('```dart\nx\n```\n');
    });

    test('a closing fence longer than the opening one', () {
      check(locate('```\nx\n`````\n')).single
        ..fenceLength.equals(3)
        ..closeFence.isNotNull().length.equals(5)
        ..content.equals('x\n');
    });

    test('an indented fence', () {
      const source = '   ```dart\n     x\n   ```\n';
      check(locate(source)).single
        ..linePrefix.equals('   ')
        ..content.equals('  x\n');
    });

    test('an unclosed fence', () {
      const source = '```dart\nx\n';
      check(locate(source)).single
        ..closeFence.isNull()
        ..content.equals('x\n');
    });

    test('several blocks', () {
      final blocks = locate('```a\n1\n```\n\ntext\n\n```b\n2\n```\n');
      check(blocks.map((b) => (b.infoString, b.content))).deepEquals([
        ('a', '1\n'),
        ('b', '2\n'),
      ]);
    });

    test('two byte-identical blocks', () {
      final blocks = locate('```dart\nx\n```\n\n```dart\nx\n```\n');
      check(blocks).length.equals(2);
      check(blocks[0].openFence.start.offset)
          .not((it) => it.equals(blocks[1].openFence.start.offset));
    });
  });

  group('containers', () {
    test('a block quote', () {
      const source = '> ```dart\n> void main() {}\n> ```\n';
      check(locate(source)).single
        ..linePrefix.equals('> ')
        ..content.equals('void main() {}\n');
    });

    test('a nested block quote', () {
      check(locate('> > ```dart\n> > x\n> > ```\n')).single
        ..linePrefix.equals('> > ')
        ..content.equals('x\n');
    });

    test('a block quote terminated by a blank line', () {
      check(locate('> ```dart\n> x\n\nafter\n')).single
        ..closeFence.isNull()
        ..content.equals('x\n');
    });

    test('a list item', () {
      const source = '''
1. First:

   ```dart
   void main() {}
   ```

2. Second
''';
      check(locate(source)).single
        ..linePrefix.equals('   ')
        ..content.equals('void main() {}\n');
    });

    test('a bullet list item', () {
      check(locate('- item\n\n  ```dart\n  x\n  ```\n')).single
        ..linePrefix.equals('  ')
        ..content.equals('x\n');
    });

    test('a fence on the same line as the list marker', () {
      check(locate('- ```dart\n  x\n  ```\n')).single
        ..linePrefix.equals('  ')
        ..content.equals('x\n');
    });

    test('a blank line inside a list item block', () {
      check(locate('- ```dart\n  a\n\n  b\n  ```\n'))
          .single
          .content
          .equals('a\n\nb\n');
    });
  });

  group('does not mistake', () {
    test('an indented code block for a fence', () {
      check(locate('    ```dart\n    x\n')).isEmpty();
    });

    test('a fence inside a code block for a block', () {
      check(locate('````\n```\n````\n')).single.content.equals('```\n');
    });

    test('inline code for a block', () {
      check(locate('Some `code` and ``more`` here.\n')).isEmpty();
    });

    test('a closing fence with an info string', () {
      check(locate('```\nx\n``` not a close\n```\n'))
          .single
          .content
          .equals('x\n``` not a close\n');
    });
  });

  group('line endings', () {
    test('crlf', () {
      check(locate('```dart\r\nx\r\n```\r\n')).single
        ..newline.equals('\r\n')
        ..content.equals('x\n');
    });

    test('no trailing newline', () {
      check(locate('```dart\nx\n```')).single
        ..closeFence.isNotNull()
        ..content.equals('x\n');
    });

    test('empty document', () {
      check(locate('')).isEmpty();
    });
  });
}
