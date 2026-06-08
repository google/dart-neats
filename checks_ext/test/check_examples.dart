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

/// A test helper to check that your examples files print output matching their `//`-comments.
/// This ensures your documentation stays up to date!
///
/// To use it, create a file `test/examples_test.dart`:
///
/// ```dart
/// import 'check_examples.dart';
///
/// void main() => checkExamples();
/// ```
///
/// Then write your example files in the `example/` directory like this:
///
/// ```dart
/// void main() {
///   /// Prints hello world (this line is not part of expected output)
///   print('hello world');
///   // hello world
/// }
/// ```
///
/// The test runner will run the example and verify that the combined stdout/stderr
/// matches lines starting with `//` (ignoring `///`). Empty lines are ignored.
///
/// ### Dartdoc `@example` Directive
///
/// To include these examples in your dartdoc generated documentation,
/// use the `{@example}` directive:
///
/// ```dart
/// /// My function that does stuff...
/// ///
/// /// {@example /example/my_function_example.dart}
/// void myFunction() { ... }
/// ```
///
/// This will pull the code from the example file into the generated documentation!
library;

import 'dart:convert';
import 'dart:io';
import 'package:checks/checks.dart';
import 'package:test/test.dart' show group, test;

void checkExamples({String directory = 'example'}) {
  group('Examples in "$directory"', () {
    final exampleDir = Directory(directory);
    if (!exampleDir.existsSync()) return;

    final exampleFiles = exampleDir
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'));

    for (final file in exampleFiles) {
      final filename = file.uri.pathSegments.last;

      test('"$filename" output matches comments', () async {
        final expected = file
            .readAsLinesSync()
            .map((l) => l.trim())
            .where((l) => l.startsWith('//') && !l.startsWith('///'))
            .map((l) => l.startsWith('// ') ? l.substring(3) : l.substring(2))
            .where((l) => l.trim().isNotEmpty)
            .join('\n');

        // Run the example as a process
        final p = await Process.start(Platform.resolvedExecutable, [file.path]);

        final outputBuffer = StringBuffer();
        await Future.wait([
          p.stdout.transform(utf8.decoder).forEach(outputBuffer.write),
          p.stderr.transform(utf8.decoder).forEach(outputBuffer.write),
          p.exitCode,
        ]);

        final output = const LineSplitter()
            .convert(outputBuffer.toString())
            .where((l) => l.trim().isNotEmpty)
            .join('\n');

        check(output).equals(expected);
      });
    }
  });
}
