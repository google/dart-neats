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
import 'package:test/scaffolding.dart';

Future<({int exitCode, String stdout, String stderr})> re2c(
  List<String> args, {
  Map<String, String>? environment,
}) async {
  final result = await Process.run(Platform.resolvedExecutable, [
    'run',
    're2c',
    ...args,
  ], environment: environment);
  return (
    exitCode: result.exitCode,
    stdout: result.stdout as String,
    stderr: result.stderr as String,
  );
}

void main() {
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
}
