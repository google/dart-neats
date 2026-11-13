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

/// The CLI, run against a real package in a temporary directory.
///
/// Everything below this is unit tested against strings; these tests exist to
/// catch the things only a filesystem can get wrong — which files are found,
/// which package root each one resolves against, what is written, and what
/// the exit code is.
library;

import 'package:checks/checks.dart';
import 'package:example/src/cli/cli.dart';
import 'package:test/scaffolding.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

void main() {
  setUp(() async {
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
  });

  test('update updates a stale document', () async {
    await d.dir('example', [
      d.file('hello.dart', "void main() {\n  print('hi');\n}\n"),
    ]).create();
    await d.file('README.md', '```dart example/hello.dart\n```\n').create();

    final out = StringBuffer();
    await check(runExample(['update', '-C', d.sandbox], out: out))
        .completes((it) => it.equals(0));

    check(out.toString()).contains('updated README.md');
    await d.file('README.md', '''
```dart example/hello.dart
void main() {
  print('hi');
}
```
''').validate();
  });

  test('update --dry-run reports stale files without writing them', () async {
    await d.dir('example', [
      d.file('hello.dart', 'void main() {}\n'),
    ]).create();
    const stale = '```dart example/hello.dart\n```\n';
    await d.file('README.md', stale).create();

    final out = StringBuffer();
    await check(
      runExample(['update', '--dry-run', '-C', d.sandbox], out: out),
    ).completes((it) => it.equals(0));

    check(out.toString()).contains('would update README.md');
    await d.file('README.md', stale).validate();
  });

  test('update is quiet when everything is up to date', () async {
    await d.file('README.md', '# nothing to do\n').create();
    final out = StringBuffer();
    await check(runExample(['update', '-C', d.sandbox], out: out))
        .completes((it) => it.equals(0));
    check(out.toString()).contains('1 markdown files are up to date');
  });

  test('validate fails on a stale document and changes nothing', () async {
    await d.dir('example', [
      d.file('hello.dart', 'void main() {}\n'),
    ]).create();
    const stale = '```dart example/hello.dart\nold;\n```\n';
    await d.file('README.md', stale).create();

    final err = StringBuffer();
    await check(runExample(['validate', '-C', d.sandbox], err: err))
        .completes((it) => it.equals(1));

    check(err.toString()).contains('out of date');
    await d.file('README.md', stale).validate();
  });

  test('validate passes once the document is updated', () async {
    await d.dir('example', [
      d.file('hello.dart', 'void main() {}\n'),
    ]).create();
    await d.file('README.md', '```dart example/hello.dart\n```\n').create();

    await check(runExample(['update', '-C', d.sandbox], out: StringBuffer()))
        .completes((it) => it.equals(0));
    await check(runExample(['validate', '-C', d.sandbox], out: StringBuffer()))
        .completes((it) => it.equals(0));
  });

  test('errors are reported and fail the command', () async {
    await d.file('README.md', '```dart example/missing.dart\n```\n').create();
    final err = StringBuffer();
    await check(runExample(['update', '-C', d.sandbox], err: err))
        .completes((it) => it.equals(1));
    check(err.toString())
      ..contains('README.md')
      ..contains('missing.dart');
  });

  test('a nested package resolves against its own package root', () async {
    // `example/app/` is a package of its own, so `/hello.dart` in its
    // documentation means `example/app/hello.dart`, not `hello.dart`.
    await d.file('hello.dart', 'outer;\n').create();
    await d.dir('example', [
      d.dir('app', [
        d.dir('.dart_tool', [
          d.file('package_config.json', '''
{
  "configVersion": 2,
  "packages": [
    {"name": "demo_app", "rootUri": "../", "packageUri": "lib/"}
  ]
}
'''),
        ]),
        d.file('hello.dart', 'inner;\n'),
        d.file('README.md', '```dart /hello.dart\n```\n'),
      ]),
    ]).create();

    await check(runExample(['update', '-C', d.sandbox], out: StringBuffer()))
        .completes((it) => it.equals(0));
    await d.dir('example', [
      d.dir('app', [
        d.file('README.md', '```dart /hello.dart\ninner;\n```\n'),
      ]),
    ]).validate();
  });

  test('workspace member packages resolve against their own package root',
      () async {
    await d.dir('.dart_tool', [
      d.file('package_config.json', '''
{
  "configVersion": 2,
  "packages": [
    {"name": "workspace", "rootUri": "../", "packageUri": "lib/"},
    {"name": "pkg_a", "rootUri": "../pkgs/a", "packageUri": "lib/"}
  ]
}
'''),
    ]).create();
    await d.file('hello.dart', 'outer;\n').create();
    await d.dir('pkgs', [
      d.dir('a', [
        d.file('hello.dart', 'inner;\n'),
        d.file('README.md', '```dart /hello.dart\n```\n'),
      ]),
    ]).create();

    await check(runExample(['update', '-C', d.sandbox], out: StringBuffer()))
        .completes((it) => it.equals(0));
    await d.dir('pkgs', [
      d.dir('a', [
        d.file('README.md', '```dart /hello.dart\ninner;\n```\n'),
      ]),
    ]).validate();
  });

  test('only requires package_config.json for files with references', () async {
    await d.dir('.dart_tool', [
      d.file('package_config.json', '{"configVersion": 2, "packages": []}'),
    ]).create();
    await d.file('README.md', '```dart\nvoid main() {}\n```\n').create();

    await check(runExample(['validate', '-C', d.sandbox], out: StringBuffer()))
        .completes((it) => it.equals(0));

    await d
        .file('README.md', '# Intro\n\n```dart example/hello.dart\n```\n')
        .create();
    final err = StringBuffer();
    await check(runExample(['validate', '-C', d.sandbox], err: err))
        .completes((it) => it.equals(1));
    check(err.toString())
      ..contains('line 3')
      ..contains('dart pub get');
  });

  test('ignores markdown files in hidden directories and build/', () async {
    await d.file('a.dart', 'void main() {}\n').create();
    const stale = '```dart ../a.dart\n```\n';
    await d.dir('.dart_tool', [d.file('stale.md', stale)]).create();
    await d.dir('build', [d.file('stale.md', stale)]).create();

    await check(runExample(['validate', '-C', d.sandbox], out: StringBuffer()))
        .completes((it) => it.equals(0));
    await check(runExample(['update', '-C', d.sandbox], out: StringBuffer()))
        .completes((it) => it.equals(0));
    await d.dir('.dart_tool', [d.file('stale.md', stale)]).validate();
    await d.dir('build', [d.file('stale.md', stale)]).validate();
  });

  test('-C may come before the command', () async {
    await d.file('README.md', '# hello\n').create();
    await check(runExample(['-C', d.sandbox, 'validate'], out: StringBuffer()))
        .completes((it) => it.equals(0));
  });

  test('a directory that does not exist is an error', () async {
    await check(
      runExample(['validate', '-C', d.path('nope')], err: StringBuffer()),
    ).completes((it) => it.equals(1));
  });

  test('an unknown command is a usage error', () async {
    await check(runExample(['nonsense'], err: StringBuffer()))
        .completes((it) => it.equals(64));
  });
}
