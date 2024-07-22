// Copyright 2023 Google LLC
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

import 'dart:io' as io;

import 'analyzer.dart';

final supportsAnsi = io.stdout.hasTerminal && io.stdout.supportsAnsiEscapes;

// ANSI color codes
final _reset = supportsAnsi ? '\u001b[0m' : '';
final _red = supportsAnsi ? '\u001b[31m' : '';
final _green = supportsAnsi ? '\u001b[32m' : '';
final _yellow = supportsAnsi ? '\u001b[33m' : '';
final _bold = supportsAnsi ? '\u001b[1m' : '';

enum LogLevel {
  debug(0),
  info(1),
  warning(2),
  error(3);

  const LogLevel(this.value);

  final int value;

  bool operator >(LogLevel other) => index > other.index;
}

typedef LogFunction = void Function(String message, LogLevel level);

final class Logger {
  final LogFunction _log;
  Logger(this._log);

  void info(String message) => _log(message, LogLevel.info);
  void debug(String message) => _log(message, LogLevel.debug);
  void warning(String message) => _log(message, LogLevel.warning);
  void error(String message) => _log(message, LogLevel.error);
  void log(String message, LogLevel level) => _log(message, level);
}

class Summary {
  final bool isFailed;
  final int errors;
  final int samples;
  final int files;

  const Summary(this.isFailed, this.errors, this.samples, this.files);

  factory Summary.from(List<DartdocAnalysisResult> results) {
    final isFailed = results.indexWhere((r) => r.errors.isNotEmpty) != -1;
    final errors =
        results.expand((r) => r.errors).where((e) => e.generatedSpan != null);
    final samples = results.map((r) => r.file);
    final files =
        samples.map((s) => s.sample.comment.span.sourceUrl?.path).toSet();
    return Summary(isFailed, errors.length, samples.length, files.length);
  }

  @override
  String toString() {
    var buf = StringBuffer();
    if (isFailed) {
      buf.write('${_red}FAILED$_reset: ');
      buf.write('$errors issues found');
    } else {
      buf.write('${_green}PASSED$_reset: ');
      buf.write('No issues found!');
    }

    buf.write(' (Found $samples code samples in $files files)');

    return buf.toString();
  }
}
