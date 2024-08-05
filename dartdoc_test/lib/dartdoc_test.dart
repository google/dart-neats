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

import 'src/dartdoc_test.dart' show DartdocTest, DartdocTestOptions;
import 'src/logger.dart';
import 'src/reporter.dart';

/// Test code samples in documentation comments in this package.
///
/// this function creates test cases that analyze code samples in documentation
/// and you can call this function in your test file and run it with `dart test`.
/// The easiest way to create a test file for code samples is to use the
/// command `dart run dartdoc_test add`.
///
/// In default, this function will test all code samples in your project. if you
/// want to test only specific files, you can use [exclude] option.
/// and if you need more logs, you can set [verbose] to true.
void runDartdocTest({
  List<String> exclude = const [],
  bool verbose = false,
}) async {
  final options = DartdocTestOptions(
    exclude: exclude,
    verbose: verbose,
  );
  final dartdocTest = DartdocTest(options);

  final logger = Logger((message, level) {
    if (verbose || LogLevel.debug != level) {
      stdout.writeln(message);
    }
  });

  logger.info('Extracting code samples ...');
  dartdocTest.extract();

  logger.info('Analyzing code samples ...');
  final result = await dartdocTest.analyze();

  final reporter = Reporter.test(verbose: verbose);
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
  final files = dartdocTest.getFiles();
  for (final file in files) {
    reporter.reportSourceFile(file.path);
  }
}
