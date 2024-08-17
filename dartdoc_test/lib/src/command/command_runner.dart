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

import 'package:args/args.dart';
import 'package:args/command_runner.dart';

import '../logger.dart';
import '../reporter.dart';
import 'add.dart';
import 'analyze.dart';

final class DartdocTestCommandRunner extends CommandRunner<void> {
  DartdocTestCommandRunner()
      : super(
          'dartdoc_test',
          'A tool to extract and analyze code samples in Dart projects.',
        ) {
    argParser.addFlag(
      'verbose',
      abbr: 'v',
      help: 'Print detailed logging.',
    );

    addCommand(AnalyzeCommand());
    addCommand(AddCommand());
  }

  late final Logger logger;

  late final Reporter reporter;

  @override
  Future<void> run(Iterable<String> args) async {
    // run AnalyzeCommand when no command is specified.
    if (args.isEmpty || !commands.keys.contains(args.first)) {
      if (args.contains('-h') || args.contains('--help')) {
        printUsage();
        return;
      }
      args = [AnalyzeCommand().name, ...args];
    }
    final result = parse(args);

    final verbose = result.flag('verbose');
    logger = Logger((message, level) {
      if (verbose || LogLevel.debug != level) {
        stdout.writeln(message);
      }
    });

    reporter = Reporter.stdout(verbose: verbose);

    return super.run(args);
  }
}

/// The base class for dartdoc_test commands.
abstract class DartdocTestCommand extends Command<void> {
  Logger get logger => (runner as DartdocTestCommandRunner).logger;
  Reporter get reporter => (runner as DartdocTestCommandRunner).reporter;

  @override
  ArgResults get argResults {
    final arg = super.argResults;
    if (arg == null) {
      throw Exception('argResults is null');
    }
    return arg;
  }

  @override
  ArgResults get globalResults {
    final arg = super.globalResults;
    if (arg == null) {
      throw Exception('globalResults is null');
    }
    return arg;
  }
}
