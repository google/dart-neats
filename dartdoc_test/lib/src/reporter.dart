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

import 'package:path/path.dart' as p;
import 'package:dartdoc_test/src/logger.dart';
import 'package:source_span/source_span.dart';
import 'package:test/test.dart';

/// Reporter for dartdoc_test result.
///
/// This class provides a way to report issues found in code samples. It can be
/// used to output issues to stdout or to create test cases. If [verbose] flag is
/// `true`, all issues will be reported. Otherwise, only issues caused by the
/// code samples will be reported.
///
/// If you want to create a custom reporter, you can extend this class and
/// override the [reportSourceFile] method or create custom methods.
abstract base class Reporter {
  final _issues = <Issue>[];

  /// Report issues in a source file.
  void reportSourceFile(String filename,
      [void Function(SourceFileReporter)? fn]);

  /// Add a new issue.
  void addIssue(Issue issue) => _issues.add(issue);

  /// Create a new reporter for stdout.
  static Reporter stdout({required bool verbose}) =>
      _ReporterForStdout(verbose: verbose);

  /// Create a new reporter for test.
  static Reporter test({required bool verbose}) =>
      _RepoterForTest(verbose: verbose);
}

/// Reporter for source file.
abstract class SourceFileReporter {
  /// Report issues in a code sample.
  /// you can add custom
  void reportCodeSample(Uri generatedUrl,
      [void Function(CodeSampleReporter)? fn]);
}

/// Reporter for code sample.
abstract class CodeSampleReporter {
  /// Report issues
  void reportIssues(Iterable<Issue> issues);
}

/// Reporter by using stdout.
///
/// This reporter outputs issues as text by using [io.stdout].
final class _ReporterForStdout extends Reporter
    implements SourceFileReporter, CodeSampleReporter {
  final Logger logger;

  _ReporterForStdout({required bool verbose})
      : logger = Logger(
          (message, level) {
            if (verbose || LogLevel.debug != level) {
              io.stdout.writeln(message);
            }
          },
        );

  @override
  void reportSourceFile(String filename,
      [void Function(SourceFileReporter)? fn]) {
    fn?.call(this);
    final issues = _issues.where((issue) => issue.path == filename);
    reportIssues(issues);
  }

  @override
  void reportCodeSample(Uri generatedUrl,
      [void Function(CodeSampleReporter)? fn]) {
    fn?.call(this);
    final issues = _issues
        .where((issue) => issue.generatedSpan?.sourceUrl == generatedUrl);
    reportIssues(issues);
  }

  @override
  void reportIssues(Iterable<Issue> issues) {
    for (final issue in issues) {
      _reportIssue(issue);
    }
  }

  void _reportIssue(Issue issue) {
    if (issue.commentSpan == null) {
      logger.debug(
        '${issue.generatedSpan?.format(issue.message)} '
        '(ignored because issue occurs in the generated code)',
      );
    } else {
      logger.debug(
          'original error: ${issue.generatedSpan?.format(issue.message)}');
      logger.info('${issue.commentSpan!.info(issue.message)}\n');
    }
  }
}

/// Reporter for test.
///
/// This reporter outputs issues as test cases by using [test] and [group] from
/// `package:test`.
final class _RepoterForTest extends Reporter
    implements SourceFileReporter, CodeSampleReporter {
  final bool _verbose;
  _RepoterForTest({required bool verbose}) : _verbose = verbose;

  @override
  void reportSourceFile(String filename,
      [void Function(SourceFileReporter)? fn]) {
    final path = p.relative(filename, from: io.Directory.current.path);
    group('[dartdoc_test] $path', () {
      fn?.call(this);
      final issues = _issues.where((issue) => issue.path == filename);
      reportIssues(issues);
    });
  }

  @override
  void reportCodeSample(Uri generatedUrl,
      [void Function(CodeSampleReporter)? fn]) {
    final path = p.relative(generatedUrl.path, from: io.Directory.current.path);
    group('[dartdoc_test] $path', () {
      fn?.call(this);
      final issues = _issues
          .where((issue) => issue.generatedSpan?.sourceUrl == generatedUrl);
      reportIssues(issues);
    });
  }

  @override
  void reportIssues(Iterable<Issue> issues) {
    for (final issue in issues) {
      _reportIssue(issue);
    }
  }

  void _reportIssue(Issue issue) {
    if (issue.commentSpan != null || _verbose) {
      test(
        'test for ${issue.commentSpan?.text}',
        () {
          if (issue.commentSpan != null) {
            fail(issue.commentSpan!.info(issue.message));
          }
        },
      );
    }
  }
}

/// Issue found in code samples.
class Issue {
  /// Path to the file containing a code sample that caused the issue.
  final String path;

  /// Source span of the comment containing code sample from the original file.
  final FileSpan? commentSpan;

  /// Source span of the generated code sample file.
  final FileSpan? generatedSpan;

  /// Message of the issue.
  final String message;

  /// Create a new issue.
  Issue({
    required this.path,
    this.commentSpan,
    this.generatedSpan,
    required this.message,
  });
}

extension on FileSpan {
  String format(String message) {
    StringBuffer buffer = StringBuffer();
    buffer.write(p.prettyUri(sourceUrl));
    buffer.write(':${start.line + 1}:${(start.column + 1)}: ');
    buffer.write(message);
    return buffer.toString();
  }

  String info(String message) {
    final buffer = StringBuffer()
      ..write(p.prettyUri(sourceUrl))
      ..write(':${start.line + 1}:${(start.column + 1)}: ')
      ..write(': $message');

    final highlight = this.highlight();
    if (highlight.isNotEmpty) {
      buffer
        ..writeln()
        ..write(highlight);
    }

    return buffer.toString();
  }
}
