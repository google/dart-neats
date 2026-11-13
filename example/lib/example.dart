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

/// Keep the code samples in your markdown files up to date with real, analyzed
/// code in `example/` and `test/`.
///
/// Write the example once, in a file that compiles and is analyzed
/// (or tested by `dart test`) like the rest of your code:
///
/// {@example /example/hello_world.dart}
///
/// Point a fenced code block at it, and leave the block empty:
///
/// ````markdown
/// ```dart example/hello_world.dart#greeting
/// ```
/// ````
///
/// Then fill it in, and keep it filled in:
///
/// ```console
/// $ dart run example update     # update the markdown
/// $ dart run example validate   # fail if it is out of date (for CI)
/// ```
///
/// To check in `dart test` that all markdown examples are up to date, call
/// [validateExamples] from a test:
///
/// ```dart
/// // test/example_test.dart
/// import 'package:example/example.dart';
/// import 'package:test/test.dart';
///
/// void main() {
///   test('examples are up to date', () async {
///     await validateExamples();
///   });
/// }
/// ```
library;

export 'src/runner.dart' show validateExamples;
