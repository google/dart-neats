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
  testWithContext('rewrite import-path in root package', (ctx) async {
    await d.file('pubspec.yaml', 'name: mypkg').create();
    await d.dir('lib', [
      d.file('mypkg.dart', '''
        import 'package:pkg1/pkg1.dart'
          if (dart.library.io) 'package:pkg1/pkg1_io.dart';
        import 'package:pkg2/pkg2.dart';

        void main() => print('hello world');
      '''),
      d.dir('src', [
        d.dir('third_party/pkg1/lib', [
          d.file('pkg1.dart', '''
            import 'package:pkg1/pkg1.dart';
          '''),
        ]),
      ]),
    ]).create();

    await Action.rewriteImportPath(
      folder: Uri.directory('.'),
      from: Uri(scheme: 'package', pathSegments: ['pkg1']),
      to: Uri(scheme: 'package', pathSegments: [
        'mypkg',
        'lib',
        'src',
        'third_party',
        'pkg1',
        'lib',
      ]),
    ).apply(ctx.context);

    await d.file('pubspec.yaml', 'name: mypkg').validate();
    await d.dir('lib', [
      d.file('mypkg.dart', '''
        import 'package:mypkg/lib/src/third_party/pkg1/lib/pkg1.dart'
          if (dart.library.io) 'package:mypkg/lib/src/third_party/pkg1/lib/pkg1_io.dart';
        import 'package:pkg2/pkg2.dart';

        void main() => print('hello world');
      '''),
      d.dir('src', [
        d.dir('third_party/pkg1/lib', [
          d.file('pkg1.dart', '''
            import 'package:pkg1/pkg1.dart';
          '''),
        ]),
      ]),
    ]).validate();
  });

  testWithContext('rewrite import-path in vendored package', (ctx) async {
    await d.file('pubspec.yaml', 'name: mypkg').create();
    await d.dir('lib', [
      d.file('mypkg.dart', '''
        import 'package:pkg1/pkg1.dart'
          if (dart.library.io) 'package:pkg1/pkg1_io.dart';
        import 'package:pkg2/pkg2.dart';

        void main() => print('hello world');
      '''),
      d.dir('src', [
        d.dir('third_party/pkg1/lib', [
          d.file('pkg1.dart', '''
            import 'package:pkg2/pkg2.dart';
          '''),
        ]),
      ]),
    ]).create();

    await Action.rewriteImportPath(
      folder: Uri.directory('lib/src/third_party/pkg1'),
      from: Uri(scheme: 'package', pathSegments: ['pkg2']),
      to: Uri(scheme: 'package', pathSegments: [
        'mypkg',
        'lib',
        'src',
        'third_party',
        'pkg2',
        'lib',
      ]),
    ).apply(ctx.context);

    await d.file('pubspec.yaml', 'name: mypkg').validate();
    await d.dir('lib', [
      d.file('mypkg.dart', '''
        import 'package:pkg1/pkg1.dart'
          if (dart.library.io) 'package:pkg1/pkg1_io.dart';
        import 'package:pkg2/pkg2.dart';

        void main() => print('hello world');
      '''),
      d.dir('src', [
        d.dir('third_party/pkg1/lib', [
          d.file('pkg1.dart', '''
            import 'package:mypkg/lib/src/third_party/pkg2/lib/pkg2.dart';
          '''),
        ]),
      ]),
    ]).validate();
  });
}
