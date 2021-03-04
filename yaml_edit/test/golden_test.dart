// Copyright 2020 Google LLC
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
import 'dart:isolate';

import 'test_case.dart';

/// This script performs snapshot testing of the inputs in the testing directory
/// against golden files if they exist, and creates the golden files otherwise.
///
/// Input directory should be in `test/test_cases`, while the golden files should
/// be in `test/test_cases_golden`.
///
/// For more information on the expected input and output, refer to the README
/// in the testdata folder
Future<void> main() async {
  final packageUri = await Isolate.resolvePackageUri(
      Uri.parse('package:yaml_edit/yaml_edit.dart'));

  final testdataUri = packageUri!.resolve('../test/testdata/');
  final inputDirectory = Directory.fromUri(testdataUri.resolve('input/'));
  final goldDirectoryUri = testdataUri.resolve('output/');

  if (!inputDirectory.existsSync()) {
    throw FileSystemException(
        'Testing Directory does not exist!', inputDirectory.path);
  }

  final testCases =
      await TestCases.getTestCases(inputDirectory.uri, goldDirectoryUri);

  testCases.test();
}
