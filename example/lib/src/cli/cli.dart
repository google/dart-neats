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

/// `dart run example …`
library;

import 'dart:io';

import 'package:args/command_runner.dart';

import '../diagnostic.dart';
import '../runner.dart';

part 'cli.update.dart';
part 'cli.validate.dart';

CommandRunner<int> _commandRunner({
  required StringSink out,
  required StringSink err,
}) {
  final runner = CommandRunner<int>(
    'example',
    'Keep the code samples in your markdown up to date with real programs.',
  )
    ..argParser.addOption(
      'directory',
      abbr: 'C',
      help: 'Run in this directory instead of the current one.',
      valueHelp: 'folder',
    )
    ..addCommand(_UpdateCommand(out: out, err: err))
    ..addCommand(_ValidateCommand(out: out, err: err));
  return runner;
}

/// Runs the CLI and returns the process exit code.
Future<int> runExample(
  List<String> arguments, {
  StringSink? out,
  StringSink? err,
}) async {
  final stdoutSink = out ?? stdout;
  final stderrSink = err ?? stderr;
  try {
    return await _commandRunner(out: stdoutSink, err: stderrSink)
            .run(arguments) ??
        0;
  } on UsageException catch (e) {
    stderrSink.writeln(e);
    return 64; // EX_USAGE
  } on FileSystemException catch (e) {
    stderrSink.writeln(e);
    return 1;
  }
}

abstract base class _Base extends Command<int> {
  final StringSink out;
  final StringSink err;

  _Base({required this.out, required this.err}) {
    // Also accepted before the command name, because both spellings are the
    // first thing people try.
    argParser.addOption(
      'directory',
      abbr: 'C',
      help: 'Run in this directory instead of the current one.',
      valueHelp: 'folder',
    );
  }

  String get directory =>
      argResults?.option('directory') ??
      globalResults?.option('directory') ??
      Directory.current.path;

  /// Prints [diagnostics] to [err] and returns whether there were any errors.
  bool report(List<ExampleFormatException> diagnostics) {
    final color = identical(err, stderr) && stderr.supportsAnsiEscapes;
    for (final diagnostic in diagnostics) {
      err.writeln(diagnostic.toString(color: color));
    }
    return diagnostics.isNotEmpty;
  }
}
