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

import 'package:cli_util/cli_util.dart' show dartExecutable;
import 'package:path/path.dart' as p;

import 'exception.dart';
import 'executable.dart';
import 'syntax/dart_syntax.g.dart';

/// Compiles the `.re` [source] at [path] to formatted Dart code.
///
/// [re2c] is the `re2c` executable path (see [findRe2c]). When [files] is
/// provided (under `build_runner`), those POSIX-keyed package files are
/// materialized into the temporary workspace instead of resolving includes from
/// disk, and [languageVersion] is passed to `dart format`.
///
/// Throws [Re2cException] if `re2c` or `dart format` fails.
Future<({String dart, String warnings})> generateDart(
  String re2c,
  String source, {
  required String path,
  Map<String, String>? files,
  String? languageVersion,
}) async {
  // re2c does not accept an absolute path for --syntax (it is resolved
  // relative to the working directory and include paths), so run it in a
  // temporary directory holding a copy of the syntax file.
  final tmp = await Directory.systemTemp.createTemp('re2c-');
  try {
    await File(p.join(tmp.path, 'dart.syntax')).writeAsString(dartSyntax);
    final srcRoot = p.join(tmp.path, 'src');
    final File input;
    final String includeDir;
    final pathMappings = <(String, String)>[];

    if (files != null) {
      for (final MapEntry(:key, :value) in files.entries) {
        final file = File(p.join(srcRoot, p.joinAll(p.posix.split(key))));
        await file.parent.create(recursive: true);
        await file.writeAsString(value);
        pathMappings.add((file.path, key));
      }
      input = File(p.join(srcRoot, p.joinAll(p.posix.split(path))));
      includeDir = p.dirname(input.path);
    } else {
      await Directory(srcRoot).create(recursive: true);
      input = File(p.join(srcRoot, p.basename(path)));
      await input.writeAsString(source);
      includeDir = p.dirname(p.absolute(path));
      pathMappings.add((input.path, path));
    }

    final result = await Process.run(
      re2c,
      [
        '--lang', 'none', '--syntax', 'dart.syntax',
        // 16-bit code units; re2c ignores `re2c:encoding:ucs2` in syntax files.
        '-w',
        '-W',
        '-I', includeDir,
        input.path,
      ],
      workingDirectory: tmp.path,
      stdoutEncoding: utf8,
      stderrEncoding: utf8,
    );
    var stderr = result.stderr as String;
    for (final (tempPath, displayPath) in pathMappings) {
      stderr = stderr
          .replaceAll(tempPath.replaceAll(r'\', r'\\'), displayPath)
          .replaceAll(tempPath, displayPath);
    }
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
        languageVersion: languageVersion,
      ),
      warnings: stderr,
    );
  } finally {
    await tmp.delete(recursive: true);
  }
}

/// Formats [dart] as `dart format` would format the file at [path].
Future<String> _format(
  String dart,
  String path, {
  String? languageVersion,
}) async {
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
    if (languageVersion != null) '--language-version=$languageVersion',
    '--stdin-name=${languageVersion != null ? path : p.absolute(path)}',
  ]);
  final stdoutFuture = process.stdout.transform(utf8.decoder).join();
  final stderrFuture = process.stderr.transform(utf8.decoder).join();
  try {
    process.stdin.write(dart);
    await process.stdin.close();
  } on IOException {
    // If `dart format` exits early on invalid syntax, ignore broken pipe so we
    // report its stderr below.
  }
  final (exitCode, stdout, stderr) =
      await (process.exitCode, stdoutFuture, stderrFuture).wait;
  if (exitCode != 0) {
    throw Re2cException(
      'Generated Dart code for $path failed to parse:\n$stderr',
    );
  }
  return stdout.replaceAll('\r\n', '\n');
}
