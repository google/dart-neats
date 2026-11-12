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

import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:cli_util/cli_util.dart' show dartExecutable;
import 'package:path/path.dart' as p;

import 'exception.dart';
import 'executable.dart';

/// Compiles the `.re` [source] at [path] to formatted Dart code.
///
/// [re2c] is the `re2c` executable path (see [findRe2c]).
///
/// Throws [Re2cException] if `re2c` or `dart format` fails.
Future<({String dart, String warnings})> generateDart(
  String re2c,
  String source, {
  required String path,
}) async {
  final syntax = File.fromUri(
    (await Isolate.resolvePackageUri(
      Uri.parse('package:re2c/src/syntax/dart.syntax'),
    ))!,
  );

  // re2c does not accept an absolute path for --syntax (it is resolved
  // relative to the working directory and include paths), so run it in a
  // temporary directory holding a copy of the syntax file. The source is
  // copied there as well, with the real directory on the include path so
  // `/*!include:re2c "..." */` still resolves relative to the real file.
  final tmp = await Directory.systemTemp.createTemp('re2c-');
  try {
    await syntax.copy(p.join(tmp.path, 'dart.syntax'));
    final input = File(p.join(tmp.path, p.basename(path)));
    await input.writeAsString(source);
    final result = await Process.run(
      re2c,
      [
        '--lang', 'none', '--syntax', 'dart.syntax',
        // 16-bit code units; re2c ignores `re2c:encoding:ucs2` in syntax files.
        '-w',
        '-W',
        '-I', p.dirname(p.absolute(path)),
        input.path,
      ],
      workingDirectory: tmp.path,
      stdoutEncoding: utf8,
      stderrEncoding: utf8,
    );
    final stderr = (result.stderr as String).replaceAll(input.path, path);
    if (result.exitCode != 0) {
      throw Re2cException(
        'Failed to compile $path (re2c exited with ${result.exitCode})\n'
        '$stderr',
      );
    }
    return (
      dart: await _format(
        result.stdout as String,
        p.setExtension(path, '.dart'),
      ),
      warnings: stderr,
    );
  } finally {
    await tmp.delete(recursive: true);
  }
}

/// Formats [dart] as `dart format` would format the file at [path].
Future<String> _format(String dart, String path) async {
  // Platform.resolvedExecutable is not `dart` when running from an AOT
  // snapshot, as build_runner does, hence package:cli_util.
  final executable = dartExecutable;
  if (executable == null) {
    throw Re2cException('Could not find the Dart SDK to run `dart format`.');
  }
  final process = await Process.start(executable, [
    'format',
    '--output=show',
    '--summary=none',
    '--stdin-name=${p.absolute(path)}',
  ]);
  final stdout = process.stdout.transform(utf8.decoder).join();
  final stderr = process.stderr.transform(utf8.decoder).join();
  process.stdin.write(dart);
  await process.stdin.close();
  if (await process.exitCode != 0) {
    throw Re2cException(
      'Generated Dart code for $path failed to parse:\n${await stderr}',
    );
  }
  return await stdout;
}
