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

/// Whether the environment in which it is executed supports ANSI.
final supportsAnsi = io.stdout.hasTerminal && io.stdout.supportsAnsiEscapes;

// ANSI color codes
final _reset = supportsAnsi ? '\u001b[0m' : '';
final _red = supportsAnsi ? '\u001b[31m' : '';
final _green = supportsAnsi ? '\u001b[32m' : '';

/// A enum type for defining logging levels.
enum LogLevel {
  /// debug information.
  debug,

  /// standard information.
  info,

  /// warning.
  warning,

  /// error.
  error;

  /// operator to compare [LogLevel]s.
  bool operator >=(LogLevel other) => index >= other.index;
}

/// type of logger callback.
typedef LogFunction = void Function(String message, LogLevel level);

/// A simple logger class that logs messages with different levels.
///
/// you can set a custom log function by passing a [LogFunction] to the
/// constructor and use the [LogLevel] to log messages with different levels.
final class Logger {
  final LogFunction _log;

  /// Create a new [Logger] with [LogFunction]
  Logger(this._log);

  /// Log a message with [LogLevel.info]
  void info(String message) => _log(message, LogLevel.info);

  /// Log a message with [LogLevel.debug]
  void debug(String message) => _log(message, LogLevel.debug);

  /// Log a message with [LogLevel.warning]
  void warning(String message) => _log(message, LogLevel.warning);

  /// Log a message with [LogLevel.error]
  void error(String message) => _log(message, LogLevel.error);

  /// Log a message with any [LogLevel]
  void log(String message, LogLevel level) => _log(message, level);
}

/// Summary for code samples analysis results.
class Summary {
  /// Whether the analysis results contain errors
  final bool isFailed;

  /// Count of analysis errors caused by code samples (error location in main function)
  final int errors;

  /// Total count of code samples in analyzed directory.
  final int samples;

  /// Count of dart files in anaalyzed directory.
  final int files;

  /// Constructor
  const Summary(this.isFailed, this.errors, this.samples, this.files);

  /// Get summery from [DartdocAnalysisResult].
  factory Summary.from(List<DartdocAnalysisResult> results) {
    final isFailed = results.indexWhere((r) => r.errors.isNotEmpty) != -1;
    final errors =
        results.expand((r) => r.errors).where((e) => e.commentSpan != null);
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
