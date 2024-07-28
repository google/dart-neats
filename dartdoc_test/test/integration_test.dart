// Copyright 2023 Google LLC
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

import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';
import 'package:test_process/test_process.dart';

void main() {
  testWithGolden('show help', ['-h']);
  testWithGolden('run analyze command', ['analyze']);
  testWithGolden('run analyze command by default', ['']);
  testWithGolden('run analyze command by default with verbose flag', ['-v']);
  testWithGolden('run analyze command with verbose flag', ['analyze', '-v']);

  group('extractor', () {
    test('extract code samples in example directory', () async {
      final process =
          await execute(['analyze', '-w', '-o', 'test/testdata/codeSample']);
      await process.shouldExit(0);
    });
  });

  group('dart test', () {
    test('run dartdoc_test', () async {
      final args = [
        'test',
        '--no-color',
        '-r',
        'expanded',
        'example/test/dartdoc_test.dart'
      ];
      final process = await Process.run(
        'dart',
        args,
        workingDirectory: Directory.current.path,
      );

      final golden = File('test/testdata/dartdoc_test.txt');
      golden
        ..createSync(recursive: true)
        ..writeAsStringSync(process.stdout.toString());
    });

    test('run dartdoc_test in example directory', () async {
      final directory = p.join(Directory.current.path, 'example');
      final process = await Process.run(
        'dart',
        ['test', '--no-color', '-r', 'expanded'],
        workingDirectory: directory,
      );

      final golden = File('test/testdata/dartdoc_test_example.txt');
      golden
        ..createSync(recursive: true)
        ..writeAsString(process.stdout.toString());
    });
  });
}

void testWithGolden(String name, List<String> args) {
  const separator = '======== separator ========\n'; // TODO: use separator
  final golden = File('test/testdata/$name.txt');
  test('integration_test: $name', () async {
    // run name in command line
    final buf = StringBuffer();
    buf.writeln(_formatCommand(args));
    final process = await execute(args);
    final output = await process.stdoutStream().toList();
    buf.writeAll(output, '\n');

    golden
      ..createSync(recursive: true)
      ..writeAsStringSync(buf.toString());
  });
}

Future<TestProcess> execute(List<String> args) {
  return TestProcess.start(
    Platform.resolvedExecutable,
    ['bin/dartdoc_test.dart', ...args],
  );
}

String _formatCommand(List<String> args) {
  return '\$ dart run bin/dartdoc_test.dart ${args.join(' ')}';
}
