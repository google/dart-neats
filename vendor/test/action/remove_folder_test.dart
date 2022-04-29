// Copyright 2022 Google LLC
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

import 'package:vendor/src/action/action.dart' show Action;
import 'package:test_descriptor/test_descriptor.dart' as d;
import '../test_context.dart' show testWithContext;

void main() {
  testWithContext('remove folder', (ctx) async {
    await d.file('pubspec.yaml', 'name: mypkg').create();
    await d.dir('lib/src/vendor/pkg1', [
      d.file('README.md', 'hello world'),
    ]).create();

    await Action.removeFolder(
      Uri.directory(d.path('lib/src/vendor/pkg1')),
    ).apply(ctx.context);

    await d.file('pubspec.yaml', 'name: mypkg').validate();
    await d.dir('lib/src/vendor', []).validate();
  });
}
