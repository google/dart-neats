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

import 'package:source_span/source_span.dart';
import 'package:test/test.dart';

abstract class Reporter {
  void reportSourceFile(String filename, void Function(SourceFileReporter) fn);
}

abstract class SourceFileReporter {
  void reportCodeSample(
      String identifier, int number, void Function(CodeSampleReporter) fn);
}

abstract class CodeSampleReporter {
  void issues(SourceSpan span, String message);
}

final class ReporterForStdout
    implements Reporter, SourceFileReporter, CodeSampleReporter {
  ReporterForStdout();
  @override
  void reportSourceFile(String filename, void Function(SourceFileReporter) fn) {
    fn(this);
  }

  @override
  void reportCodeSample(
      String identifier, int number, void Function(CodeSampleReporter p1) fn) {}

  @override
  void issues(span, String message) {}
}

final class RepoterForTest
    implements Reporter, SourceFileReporter, CodeSampleReporter {
  final _issues = <(SourceSpan, String)>[];

  @override
  void reportSourceFile(String filename, void Function(SourceFileReporter) fn) {
    group(filename, () {
      fn(this);
    });
  }

  @override
  void reportCodeSample(
      String identifier, int number, void Function(CodeSampleReporter) fn) {
    test('$identifier-($number)', () {
      fn(this);
      if (_issues.isNotEmpty) {
        for (final issue in _issues) {
          final (span, message) = issue;
          printOnFailure(span.message(message));
        }
        // print issues and make sure test fails.
        fail('code sample has ${_issues.length} issues');
      }
    });
  }

  @override
  void issues(SourceSpan span, String message) => _issues.add((span, message));
}
