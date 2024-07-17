import 'dart:io';

import 'package:dartdoc_test/src/dartdoc_test.dart';
import 'package:test/test.dart';
import 'package:test_process/test_process.dart';

void main() {
  testWithGolden('run analyze command', ['analyze']);
  testWithGolden('run analyze command by default', ['']);
  testWithGolden('run analyze command with verbose flag', ['analyze', '-v']);

  group('extractor', () {
    final dartdocTest = DartdocTest(DartdocTestOptions());
    test('extract code samples', () async {
      await dartdocTest.extract();
    });
  });
}

void testWithGolden(String name, List<String> args) {
  // const separator = '======== separator ========\n';
  final golden = File('test/testdata/$name.txt');
  test('integration_test: $name', () async {
    // run name in command line
    final buf = StringBuffer();
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
