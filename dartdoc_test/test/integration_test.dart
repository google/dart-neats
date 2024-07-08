import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:test/test.dart';
import 'package:test_process/test_process.dart';

void main() {
  testWithGolden('extract');
  testWithGolden('analyze');
}

void testWithGolden(String name) {
  const separator = '======== separator ========\n';
  final golden = File('test/testdata/$name.txt');
  test(name, () async {
    // run name in command line
    final buf = StringBuffer();
    final process = await runDartdocTest([name]);
    final output = await process.stdoutStream().toList();
    buf.writeAll(output, '\n');

    golden
      ..createSync(recursive: true)
      ..writeAsStringSync(buf.toString());
  });
}

final _dartdoctestPath =
    path.canonicalize(path.join('bin', 'dartdoc_test.dart'));

Future<TestProcess> runDartdocTest(List<String> args) {
  return TestProcess.start(
    Platform.resolvedExecutable,
    ['bin/dartdoc_test.dart', ...args],
  );
}
