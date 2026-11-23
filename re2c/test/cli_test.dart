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

import 'package:checks/checks.dart';
import 'package:path/path.dart' as p;
import 'package:re2c/src/syntax/dart_syntax.g.dart';
import 'package:test/scaffolding.dart';

Future<({int exitCode, String stdout, String stderr})> re2c(
  List<String> args, {
  Map<String, String>? environment,
  String? workingDirectory,
}) async {
  final result = await Process.run(
    Platform.resolvedExecutable,
    ['run', p.absolute('bin/re2c.dart'), ...args],
    environment: environment,
    workingDirectory: workingDirectory,
  );
  return (
    exitCode: result.exitCode,
    stdout: result.stdout as String,
    stderr: result.stderr as String,
  );
}

void main() {
  test('embedded dartSyntax matches dart.syntax', () {
    final onDisk = File(
      p.join('lib', 'src', 'syntax', 'dart.syntax'),
    ).readAsStringSync().replaceAll('\r\n', '\n');
    check(dartSyntax).equals(onDisk);
  });

  test('--check passes for committed files', () async {
    final result = await re2c(['--check', 'example', 'test/scanners']);
    check(result.stderr).isEmpty();
    check(result.exitCode).equals(0);
  });

  test('--check and --dry-run report a stale file', () async {
    final dir = await Directory.systemTemp.createTemp('re2c-test-');
    addTearDown(() => dir.delete(recursive: true));
    final input = File(p.join(dir.path, 'scanner.re'));
    await File('test/scanners/defaults_test.re').copy(input.path);

    final stale = await re2c(['--check', input.path]);
    check(stale.exitCode).equals(1);
    check(stale.stderr).contains('scanner.dart');

    final dryRun = await re2c(['--dry-run', input.path]);
    check(dryRun.exitCode).equals(0);
    check(dryRun.stdout).contains('scanner.dart');
    check(File(p.join(dir.path, 'scanner.dart')).existsSync()).isFalse();

    final generate = await re2c([input.path]);
    check(generate.exitCode).equals(0);
    check(generate.stdout).contains('scanner.dart');

    final fresh = await re2c(['--check', input.path]);
    check(fresh.exitCode).equals(0);
  });

  test('errors in the .re file are reported with the real path', () async {
    final dir = await Directory.systemTemp.createTemp('re2c-test-');
    addTearDown(() => dir.delete(recursive: true));
    final input = File(p.join(dir.path, 'broken.re'));
    await input.writeAsString('''
int f(String yyinput, int yycursor, int yylimit) {
  /*!re2c
    [0-9+ { return 1; }
  */
}
''');
    final result = await re2c([input.path]);
    check(result.exitCode).equals(1);
    check(result.stderr).contains('${input.path}:3:');
  });

  test('a missing re2c executable is explained', () async {
    final result = await re2c(
      ['--check', 'example'],
      environment: {'RE2C_EXECUTABLE': p.join('does', 'not', 'exist')},
    );
    check(result.exitCode).equals(1);
    check(result.stderr)
      ..contains('RE2C_EXECUTABLE')
      ..contains('brew install re2c');
  });

  test('an action that does not return or continue fails to compile', () async {
    final dir = await Directory.systemTemp.createTemp('re2c-test-');
    addTearDown(() => dir.delete(recursive: true));
    final input = File(p.join(dir.path, 'non_terminating.re'));
    await input.writeAsString('''
int f(String yyinput, int yycursor, int yylimit) {
  /*!re2c
    * { yycursor; }
    \$ { return 0; }
  */
}
''');
    final generated = await re2c([input.path]);
    check(generated.exitCode).equals(0);

    final analyzed = await Process.run(Platform.resolvedExecutable, [
      'analyze',
      p.join(dir.path, 'non_terminating.dart'),
    ]);
    check(analyzed.exitCode).not((it) => it.equals(0));
    check(analyzed.stdout as String).contains('yyactionMustReturnOrContinue');
  });

  test('passing a non-.re file fails without overwriting it', () async {
    final dir = await Directory.systemTemp.createTemp('re2c-test-');
    addTearDown(() => dir.delete(recursive: true));
    final dartFile = File(p.join(dir.path, 'handwritten.dart'));
    await dartFile.writeAsString('void main() {}\n');

    final result = await re2c([dartFile.path]);
    check(result.exitCode).equals(1);
    check(result.stderr).contains('Expected a .re file');
    check(await dartFile.readAsString()).equals('void main() {}\n');
  });

  test(
    'directory discovery skips hidden dirs and top-level build/ only, sorted',
    () async {
      final dir = await Directory.systemTemp.createTemp('re2c-test-');
      addTearDown(() => dir.delete(recursive: true));
      await File(p.join(dir.path, 'pubspec.yaml')).writeAsString('name: pkg\n');
      final template =
          await File('test/scanners/hello_world_test.re').readAsString();
      for (final rel in [
        '.dart_tool/cached.re',
        'build/top_level.re',
        'lib/z.re',
        'lib/build/nested.re',
        'lib/a.re',
      ]) {
        final f = File(p.join(dir.path, p.joinAll(rel.split('/'))));
        await f.parent.create(recursive: true);
        await f.writeAsString(template);
      }

      final dryRun = await re2c(['--dry-run'], workingDirectory: dir.path);
      check(dryRun.exitCode).equals(0);
      final lines = dryRun.stdout.trim().split('\n');
      check(lines).deepEquals([
        'Would generate ${p.join('lib', 'a.dart')}',
        'Would generate ${p.join('lib', 'build', 'nested.dart')}',
        'Would generate ${p.join('lib', 'z.dart')}',
      ]);
    },
  );
}
