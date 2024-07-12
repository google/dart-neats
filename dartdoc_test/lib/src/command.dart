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

import 'package:args/command_runner.dart';
import 'package:dartdoc_test/src/dartdoc_test.dart';

class DartdocTestCommandRunner extends CommandRunner<void> {
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

  @override
  Future<void> run(Iterable<String> args) async {
    // run AnalyzeCommand when no command is specified.
    if (parse(args).command == null) {
      // only print help message when -h flag is set.
      if (parse(args).flag('help')) {
        printUsage();
        return;
      }
      args = [AnalyzeCommand().name, ...args];
    }
    return super.run(args);
  }
}

class AnalyzeCommand extends Command<void> {
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
    await dartdocTest.analyze();
  }
}

class AddCommand extends Command<void> {
  @override
  String get name => 'add';

  @override
  String get description => 'Generate dartdoc_test test file.';

  AddCommand();

  @override
  Future<void> run() async {
    final dartdocTest = DartdocTest(DartdocTestOptions());
    await dartdocTest.generate();
  }
}
