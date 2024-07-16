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

import 'package:test/test.dart';

import 'src/dartdoc_test.dart' show DartdocTest, DartdocTestOptions;
import 'src/logger.dart';

/// Test code samples in documentation comments.
///
/// In default, this function will test all code samples in your project. if you
/// want to test only specific files, you can use [include] and [exclude] options.
void runDartdocTest({
  List<String> include = const [],
  List<String> exclude = const [],
  bool verbose = false,
}) async {
  test('dartdoc_test', () async {
    final options = DartdocTestOptions(
      include: include,
      exclude: exclude,
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

    if (result.isEmpty) {
      logger.info('No issues found.');
    } else {
      logger.error('Found ${result.length} issues:');
      for (final issue in result) {
        logger.error(issue.toString());
      }
    }
  });
}
