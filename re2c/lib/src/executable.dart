// Copyright 2026 Google LLC
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

import 'exception.dart';

/// Oldest `re2c` that understands every configuration in `dart.syntax`.
const minimumVersion = (major: 4, minor: 4);

final _installHint = '''
Install re2c >= ${minimumVersion.major}.${minimumVersion.minor} and make sure
it is on PATH, or set RE2C_EXECUTABLE to point to it. For example:
  * brew install re2c
  * conda install -c conda-forge re2c''';

/// Finds a usable `re2c` executable.
///
/// Looks at `RE2C_EXECUTABLE` first, then `PATH`, and checks the version
/// of whatever it finds.
///
/// Throws [Re2cException] if no executable is found, or if it is too old.
Future<String> findRe2c() async {
  var executable = Platform.environment['RE2C_EXECUTABLE'];
  if (executable == null || executable.isEmpty) {
    executable = 're2c';
  }

  final ProcessResult result;
  try {
    result = await Process.run(executable, ['--version']);
  } on ProcessException catch (e) {
    throw Re2cException(
      'Could not run "$executable --version": ${e.message}\n$_installHint',
    );
  }
  final output = result.stdout.toString().trim();
  final version = RegExp(r'(\d+)\.(\d+)').firstMatch(output);
  if (result.exitCode != 0 || version == null) {
    throw Re2cException(
      '"$executable --version" did not report a version, got: "$output"\n'
      '$_installHint',
    );
  }
  final major = int.parse(version.group(1)!);
  final minor = int.parse(version.group(2)!);
  if (major < minimumVersion.major ||
      major == minimumVersion.major && minor < minimumVersion.minor) {
    throw Re2cException('"$executable" is too old: $output\n$_installHint');
  }
  return executable;
}
