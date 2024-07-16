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

import '../resource.dart';
import 'command_runner.dart';

class AddCommand extends DartdocTestCommand {
  @override
  String get name => 'add';

  @override
  String get description => 'Generate dartdoc_test test file.';

  AddCommand() {
    argParser.addFlag(
      'force',
      abbr: 'f',
      help: 'overwrite to "test/dartdoc_test.dart"',
    );
  }

  @override
  Future<void> run() async {
    logger.info('Creating \'test/dartdoc_test.dart\' ...');

    final path = p.join(currentDir.path, 'test', 'dartdoc_test.dart');
    final force = argResults?.flag('force') ?? false;
    if (!force && File(path).existsSync()) {
      logger.info('\'test/dartdoc_test.dart\' is already exists.');
      logger.info('if you want to create forcely, use --force option.');
      return;
    }

    final content = '''
import 'package:dartdoc_test/dartdoc_test.dart';

/// [runDartdocTest] is a test function that tests code samples.
void main() => runDartdocTest();

''';

    // if not exists, create test directory
    final testDir = Directory(p.join(currentDir.path, 'test'));
    if (!testDir.existsSync()) {
      testDir.createSync();
    }

    final file = File(p.join(testDir.path, 'dartdoc_test.dart'));
    await file.writeAsString(content);
    logger.info('Done! Run \'dart test\' to analyze code samples.');
  }
}
