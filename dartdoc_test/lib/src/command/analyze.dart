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

import '../dartdoc_test.dart';
import '../logger.dart';
import 'command_runner.dart';

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
    argParser.addOption(
      'output',
      abbr: 'o',
      help: 'Output code samples to file',
    );
  }

  @override
  Future<void> run() async {
    final dartdocTest = DartdocTest(DartdocTestOptions(
      write: argResults.flag('write'),
      verbose: globalResults.flag('verbose'),
      out: argResults.option('output'),
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
          logger.debug('original error: ${e.error}');
          logger.info(e.span!.message((e.error.message)));
          logger.info('\n');
        }
      }
    }
    logger.info(Summary.from(result).toString());
  }
}
