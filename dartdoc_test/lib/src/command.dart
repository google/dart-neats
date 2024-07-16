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

import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;

import 'dartdoc_test.dart';
import 'logger.dart';
import 'resource.dart';

final class DartdocTestCommandRunner extends CommandRunner<void> {
  DartdocTestCommandRunner()
      : super(
          'dartdoc_test',
          'A tool to extract and analyze code samples in Dart projects.',
        ) {
    argParser.addFlag(
      'verbose',
      abbr: 'v',
      help: 'Print verbose output',
    );

    addCommand(AnalyzeCommand());
    addCommand(AddCommand());
  }

  late final Logger logger;

  @override
  Future<void> run(Iterable<String> args) async {
    // run AnalyzeCommand when no command is specified.
    final result = parse(args);
    if (result.command == null) {
      // only print help message when -h flag is set.
      if (parse(args).flag('help')) {
        printUsage();
        return;
      }
      args = [AnalyzeCommand().name, ...args];
    }

    final verbose = result.flag('verbose');
    logger = Logger((message, level) {
      if (verbose || LogLevel.debug != level) {
        stdout.writeln(message);
      }
    });

    return super.run(args);
  }
}

abstract class DartdocTestCommand extends Command<void> {
  Logger get logger => (runner as DartdocTestCommandRunner).logger;
}

class AnalyzeCommand extends DartdocTestCommand {
  @override
  String get name => 'analyze';

  @override
  String get description => 'Analyze code samples in the current directory.';

  AnalyzeCommand() {
    argParser.addFlag(
      'write',
      abbr: 'w',
      help: 'Write code samples to file.',
    );
  }

  @override
  Future<void> run() async {
    final dartdocTest = DartdocTest(DartdocTestOptions(
      write: argResults?.flag('write') ?? false,
      verbose: globalResults?.flag('verbose') ?? false,
    ));
    logger.info('Extracting code samples ...');
    await dartdocTest.extract();

    logger.info('Analyzing code samples ...');
    final result = await dartdocTest.analyze();

    for (final r in result) {
      if (r.errors.isEmpty) {
        logger.info('No issues found!');
      }

      for (final e in r.errors) {
        if (e.span == null) {
          logger.debug(
            'Error found in generated code.\n'
            '${e.error}\n',
          );
        } else {
          logger.info(e.span!.message((e.error.message)));
          logger.info('\n');
        }
      }
    }

    printSummary(logger, result);
  }
}

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
