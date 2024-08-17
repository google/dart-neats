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

import 'command_runner.dart';

/// Handles the `add` command.
///
/// This command creates a test file for dartdoc_test in `test/dartdoc_test.dart`
/// with a default template.
class AddCommand extends DartdocTestCommand {
  @override
  String get name => 'add';

  @override
  String get description =>
      'Add dartdoc_test test file to "test/dartdoc_test.dart"';

  AddCommand() {
    argParser.addFlag(
      'force',
      abbr: 'f',
      help: 'overwrite to "test/dartdoc_test.dart"',
    );
  }

  @override
  Future<void> run() async {
    logger.info('Creating "test/dartdoc_test.dart" ...');

    final testDirectory = Directory(p.join(Directory.current.path, 'test'));

    final path = p.join(testDirectory.path, 'dartdoc_test.dart');
    final force = argResults.flag('force');
    if (!force && File(path).existsSync()) {
      logger.info('"test/dartdoc_test.dart" is already exists.');
      logger.info('if you want to create file forcely, use --force option.');
      return;
    }

    final content = '''
import 'package:dartdoc_test/dartdoc_test.dart';

/// Test code samples in documentation comments in this package.
/// 
/// It extracts code samples from documentation comments in this package and 
/// analyzes them. If there are any errors in the code samples, the test will fail
/// and you can see the problems details.
/// 
/// If you want to test only specific files, you can use [exclude] option.
void main() => runDartdocTest();
''';

    // if not exists, create test directory
    if (!testDirectory.existsSync()) {
      testDirectory.createSync();
    }

    final file = File(p.join(testDirectory.path, 'dartdoc_test.dart'));
    await file.writeAsString(content);
    logger.info('Done! You can run "dart test" to analyze code samples.');
  }
}
