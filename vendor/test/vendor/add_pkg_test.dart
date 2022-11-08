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

import 'package:test_descriptor/test_descriptor.dart' as d;
import 'package:vendor/src/vendor.dart';
import '../test_context.dart';
import 'package:test/test.dart';

void main() {
  testWithContext('Add new package using vendor', (ctx) async {
    // Create a root package we can run vendor on
    await d.dir('.', [
      d.file('vendor.yaml', '''
        import_rewrites:
          foo: foo
        vendored_dependencies:
          foo:
            package: foo
            version: 1.2.3
      '''),
      d.file('pubspec.yaml', 'name: myapp'),
      d.dir('lib', [
        d.file('myapp.dart', '''
          import 'package:foo/foo.dart';

          void main() => sayHello();
        '''),
      ]),
    ]).create();

    // Add package foo to server
    ctx.server.add(d.dir('foo', [
      d.file('pubspec.yaml', '''{
        "name": "foo",
        "version": "1.2.3",
        "environment": {"sdk": ">2.12.0 <=3.0.0"}
      }'''),
      d.file('README.md', '# foo for dart'),
      d.dir('lib', [
        d.file('foo.dart', '''
          void sayHello() => print('Hello world');
        '''),
      ]),
    ]));

    // Run the vendoring
    await vendor(ctx.context);

    // Assert the resulting state
    await d.dir('.', [
      d.file('vendor.yaml', anything),
      d.file('pubspec.yaml', 'name: myapp'),
      d.dir('lib', [
        d.file('myapp.dart', '''
          import 'package:myapp/src/third_party/foo/lib/foo.dart';

          void main() => sayHello();
        '''),
        d.dir('src', [
          d.dir('third_party', [
            d.file('vendor-state.yaml', contains('vendored_dependencies')),
            d.dir('foo', [
              d.file('vendored-pubspec.yaml', contains('1.2.3')),
              d.file('README.md', '# foo for dart'),
              d.dir('lib', [
                d.file('foo.dart', contains('void sayHello() =>')),
              ]),
            ]),
          ]),
        ]),
      ]),
    ]).validate();
  });
}
