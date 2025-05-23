// Copyright 2025 Google LLC
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

import 'package:build_verify/build_verify.dart';
import 'package:test/test.dart';

void main() {
  // We only run this when CI=true, because it requires a pristine git clone
  final ci = (Platform.environment['CI'] ?? '').toLowerCase();
  final isCI = ci != 'false' && ci != '0' && ci.isNotEmpty;

  test(
    'ensure_build',
    () async {
      await expectBuildClean(
        packageRelativeDirectory: 'typed_sql',
      );
    },
    skip: isCI ? null : 'Only runs with CI=true',
    timeout: const Timeout(Duration(minutes: 5)),
  );
}
