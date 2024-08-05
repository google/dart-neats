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

import 'package:dartdoc_test/src/reporter.dart';

import '../dartdoc_test.dart';
import '../logger.dart';
import 'command_runner.dart';

class AnalyzeCommand extends DartdocTestCommand {
  @override
  String get name => 'analyze';

  @override
  String get description =>
      'Analyze code samples in documentation comments in this project.';

  AnalyzeCommand() {
    argParser
      ..addFlag(
        'write',
        abbr: 'w',
        help: 'Write code samples to physical files.',
      )
      ..addOption(
        'output',
        abbr: 'o',
        help: 'Directory to write code samples.',
      )
      ..addMultiOption(
        'exclude',
        abbr: 'x',
        help: 'Directories or files to exclude from analysis.',
      );
  }

  @override
  Future<void> run() async {
    final dartdocTest = DartdocTest(DartdocTestOptions(
      write: argResults.flag('write'),
      verbose: globalResults.flag('verbose'),
      out: argResults.option('output'),
      exclude: argResults.multiOption('exclude'),
    ));
    logger.info('Extracting code samples ...');
    await dartdocTest.extract();

    logger.info('Analyzing code samples ...');
    final result = await dartdocTest.analyze();

    for (final r in result) {
      for (final e in r.errors) {
        reporter.addIssue(Issue(
          path: r.file.sample.comment.path,
          message: e.error.message,
          commentSpan: e.commentSpan,
          generatedSpan: e.generatedSpan,
        ));
      }
    }

    final hasIssues = result.any((r) => r.hasError);
    if (!hasIssues) {
      logger.info('No issues found.');
    }

    final files = dartdocTest.getFiles();
    for (final file in files) {
      reporter.reportSourceFile(file.path);
    }
    logger.info(Summary.from(result).toString());
  }
}
