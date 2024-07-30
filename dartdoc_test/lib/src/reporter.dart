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

import 'package:dartdoc_test/src/resource.dart';
import 'package:path/path.dart' as p;
import 'package:dartdoc_test/src/logger.dart';
import 'package:source_span/source_span.dart';
import 'package:test/test.dart';

abstract base class Reporter {
  Reporter({required bool verbose}) : _verbose = verbose;
  final _issues = <Issue>[];
  final bool _verbose;

  get reportedIssues => _issues;

  void reportSourceFile(String filename,
      [void Function(SourceFileReporter)? fn]);

  void addIssue(Issue issue) => _issues.add(issue);

  static Reporter stdout({required bool verbose}) =>
      _ReporterForStdout(verbose: verbose);
  static Reporter test({required bool verbose}) =>
      _RepoterForTest(verbose: verbose);
}

abstract class SourceFileReporter {
  void reportCodeSample(Uri generatedUrl,
      [void Function(CodeSampleReporter)? fn]);
}

abstract class CodeSampleReporter {
  void reportIssues(Iterable<Issue> issues);
}

final class _ReporterForStdout extends Reporter
    implements SourceFileReporter, CodeSampleReporter {
  final Logger logger;

  _ReporterForStdout({required super.verbose})
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
    final issues = _issues
        .where((issue) => issue.commentSpan?.sourceUrl?.path == filename);
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

final class _RepoterForTest extends Reporter
    implements SourceFileReporter, CodeSampleReporter {
  _RepoterForTest({required super.verbose});

  @override
  void reportSourceFile(String filename,
      [void Function(SourceFileReporter)? fn]) {
    final path = p.relative(filename, from: currentDir.path);
    group('[dartdoc_test] $path', () {
      fn?.call(this);
      final issues = _issues.where((issue) => issue.path == filename);
      reportIssues(issues);
    });
  }

  @override
  void reportCodeSample(Uri generatedUrl,
      [void Function(CodeSampleReporter)? fn]) {
    final path = p.relative(generatedUrl.path, from: currentDir.path);
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
    test(
      'test for ${issue.commentSpan?.text}',
      () {
        if (issue.commentSpan != null) {
          fail(issue.commentSpan!.info(issue.message));
        }
      },
      // skip: !_verbose && issue.generatedSpan == null,
    );
  }
}

class Issue {
  final String path;
  final FileSpan? commentSpan;
  final FileSpan? generatedSpan;
  final String message;

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
