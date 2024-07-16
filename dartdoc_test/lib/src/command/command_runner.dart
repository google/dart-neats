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

import '../logger.dart';
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
