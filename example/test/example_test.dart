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

import 'package:checks/checks.dart';
import 'package:example/example.dart';
import 'package:test/scaffolding.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

void main() {
  test('examples are up to date', () async {
    await validateExamples();
  });

  test('throws AssertionError when a block is out of date', () async {
    await d.dir('.dart_tool', [
      d.file('package_config.json', '''
{
  "configVersion": 2,
  "packages": [
    {"name": "demo", "rootUri": "../", "packageUri": "lib/"}
  ]
}
'''),
    ]).create();
    await d.file('a.dart', 'void main() {}\n').create();
    await d.file('README.md', '```dart a.dart\n```\n').create();

    await check(validateExamples(directory: d.sandbox)).throws<AssertionError>(
      (it) => it
          .has((e) => e.message.toString(), 'message')
          .contains('out of date'),
    );
  });
}
