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

import 'package:test/test.dart';
import 'package:vendor/src/action/action.dart' show Action;
import 'package:test_descriptor/test_descriptor.dart' as d;
import 'package:pub_semver/pub_semver.dart' show Version;
import '../test_context.dart' show testWithContext;

void main() {
  testWithContext('fetch mypkg 3.0.1', (ctx) async {
    ctx.server.add(d.dir('mypkg', [
      d.file('pubspec.yaml', '''{
        "name": "mypkg",
        "version": "3.0.1",
        "environment": {"sdk": ">2.12.0 <=3.0.0"}
      }'''),
      d.file('README.md', '# mypkg for dart'),
      d.file('test/exclude.dart', '// Excluded file'),
    ]));

    await d.file('pubspec.yaml', 'name: mypkg').create();
    await d.dir('lib', []).create();

    await Action.fetchPackage(
      Uri.directory(d.path('lib/src/third_party/mypkg-3')),
      'mypkg',
      Version.parse('3.0.1'),
      ctx.context.defaultHostedUrl,
      {
        'README.md',
      },
    ).apply(ctx.context);

    await d.file('pubspec.yaml', 'name: mypkg').validate();
    await d
        .file(
          'lib/src/third_party/mypkg-3/README.md',
          contains('mypkg for dart'),
        )
        .validate();

    await d.nothing('lib/src/third_party/mypkg-3/test/exclude.dart').validate();
  });
}
