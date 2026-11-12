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

import 'package:args/args.dart';
import 'package:path/path.dart' as p;

import 'exception.dart';
import 'executable.dart';
import 'generate.dart';

final _parser =
    ArgParser(usageLineLength: 80)
      ..addFlag(
        'check',
        negatable: false,
        help:
            'Exit with status 1 if any generated .dart file is out of date, '
            'without writing anything.',
      )
      ..addFlag(
        'dry-run',
        abbr: 'n',
        negatable: false,
        help: 'Show which .dart files would be generated without writing them.',
      )
      ..addFlag('help', abbr: 'h', negatable: false, help: 'Show this help.');

const _usage = '''
Usage: dart run re2c [--check] [--dry-run] [<file-or-directory>...]

Compiles every <name>.re file to <name>.dart next to it. With no arguments,
all .re files in the current package are compiled.

Examples:
  dart run re2c                       Compile all .re files in the package
  dart run re2c lib/src/scanner.re    Compile a single .re file
  dart run re2c --check               Verify generated .dart files are up to date
  dart run re2c --dry-run             List .dart files that would be modified

Options:''';

/// Runs the `dart run re2c` command line, returning the exit code.
Future<int> run(List<String> arguments) async {
  final ArgResults args;
  try {
    args = _parser.parse(arguments);
  } on FormatException catch (e) {
    stderr.writeln('${e.message}\n\n$_usage\n${_parser.usage}');
    return 64;
  }
  if (args.flag('help')) {
    stdout.writeln('$_usage\n${_parser.usage}');
    return 0;
  }

  try {
    final files = _findInputs(args.rest);
    if (files.isEmpty) {
      stderr.writeln('No .re files found.');
      return 0;
    }
    final re2c = await findRe2c();
    final stale = <String>[];
    for (final file in files) {
      final String source;
      try {
        source = await file.readAsString();
      } on FileSystemException catch (e) {
        throw Re2cException('Could not read ${file.path}: ${e.message}');
      }
      final result = await generateDart(re2c, source, path: file.path);
      if (result.warnings.isNotEmpty) {
        stderr.write(result.warnings);
      }
      final output = File(p.setExtension(file.path, '.dart'));
      final current =
          await output.exists()
              ? (await output.readAsString()).replaceAll('\r\n', '\n')
              : null;
      if (current == result.dart) {
        continue;
      }
      if (args.flag('check')) {
        stale.add(output.path);
      } else if (args.flag('dry-run')) {
        stdout.writeln('Would generate ${output.path}');
      } else {
        await output.writeAsString(result.dart);
        stdout.writeln('Generated ${output.path}');
      }
    }
    if (stale.isNotEmpty) {
      stderr.writeln(
        'The following files are out of date, run `dart run re2c`:\n'
        '${stale.map((f) => '  $f').join('\n')}\n'
        '(re2c: ${(await Process.run(re2c, ['--version'])).stdout.toString().trim()})',
      );
      return 1;
    }
    return 0;
  } on Re2cException catch (e) {
    stderr.writeln(e.message);
    return 1;
  }
}

/// The `.re` files named by [paths], or all `.re` files in the current
/// package if [paths] is empty.
List<File> _findInputs(List<String> paths) {
  if (paths.isEmpty) {
    paths = [p.relative(_packageRoot())];
  }
  return [
    for (final path in paths)
      if (Directory(path).existsSync())
        ...Directory(path)
            .listSync(recursive: true, followLinks: false)
            .whereType<File>()
            .where((f) => p.extension(f.path) == '.re')
      else
        File(path),
  ];
}

/// The nearest directory containing a `pubspec.yaml`, or the current one.
String _packageRoot() {
  var dir = Directory.current;
  while (true) {
    if (File(p.join(dir.path, 'pubspec.yaml')).existsSync()) {
      return dir.path;
    }
    if (dir.parent.path == dir.path) {
      return Directory.current.path;
    }
    dir = dir.parent;
  }
}
