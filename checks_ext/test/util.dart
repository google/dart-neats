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

/// Guidelines for testing checks extensions:
///
/// 1. **Hybrid Approach for Failure Messages**:
///    - Use `isRejectedBy` for the bulk of tests (empty, one element, multiple)
///      to test the logic and raw rejection data (`which` and `actual`).
///    - Use `throwsFailure().contains('label')` to verify that specific labels
///      (like "has sum") appear in the full failure message, without hardcoding
///      the entire layout which is fragile to core `checks` changes.
///
/// 2. **Test Variants**:
///    - Always test positive cases (succeeds).
///    - Always test negative cases (fails with correct rejection).
///    - Test empty or null cases when applicable.
///    - Test with different types if supported (e.g. numbers, letters).

import 'dart:io';
import 'package:checks/checks.dart';
import 'package:checks/context.dart';
import 'package:stack_trace/stack_trace.dart';

export 'package:checks/checks.dart';
export 'package:checks/context.dart';
import 'package:test/test.dart' show test, markTestSkipped, TestFailure;
export 'package:test/test.dart' hide escape, throws;

// Copied from checks/test/test_shared.dart
extension RejectionChecks<T> on Subject<T> {
  void isRejectedBy(
    Condition<T> condition, {
    Iterable<String>? actual,
    Iterable<String>? which,
  }) {
    late T actualValue;
    var didRunCallback = false;
    final rejection = context.nest<Rejection>(
      () => ['does not meet a condition with a Rejection'],
      (value) {
        actualValue = value;
        didRunCallback = true;
        final failure = softCheck(value, condition);
        if (failure == null) {
          return Extracted.rejection(
            which: [
              'was accepted by the condition checking:',
              ...describe(condition),
            ],
          );
        }
        return Extracted.value(failure.rejection);
      },
    );
    if (didRunCallback) {
      rejection
          .has((r) => r.actual, 'actual')
          .deepEquals(actual ?? literal(actualValue));
    } else {
      rejection
          .has((r) => r.actual, 'actual')
          .context
          .expect(() => ['is left default'], (_) => null);
    }
    if (which == null) {
      rejection.has((r) => r.which, 'which').isNull();
    } else {
      rejection.has((r) => r.which, 'which').isNotNull().deepEquals(which);
    }
  }
}

// Copied from checks/test/failure_message_test.dart
extension FailureMessageChecks on Subject<void Function()> {
  Subject<String> throwsFailure() =>
      throws<TestFailure>().has((f) => f.message, 'message').isNotNull();
}

/// Runs a test with a golden failure message.
///
/// The [expected] string must start with `# <title>` on the first line.
/// If the failure message doesn't match and `UPDATE_GOLDEN` environment variable
/// is set to `true`, it will update the source file with the actual message.
void testCheckGolden(void Function() callback, String expected) {
  final trace = Trace.current();
  final lines = expected.split('\n');
  if (lines.isEmpty || !lines.first.startsWith('# ')) {
    throw ArgumentError('Expected string must start with "# <title>"');
  }
  final title = lines.first.substring(2).trim();

  test(title, () {
    String? failureMessage;
    try {
      callback();
    } on TestFailure catch (e) {
      failureMessage = e.message;
    }

    if (failureMessage == null) {
      throw TestFailure('Expected a failure but it passed.');
    }

    final actual = '# $title\n$failureMessage';
    final expectedTrimmed = expected.trim();
    final actualTrimmed = actual.trim();

    if (actualTrimmed != expectedTrimmed) {
      final updateGolden = Platform.environment['UPDATE_GOLDEN'] == 'true';
      if (updateGolden) {
        Frame? callerFrame;
        for (final frame in trace.frames) {
          final path = frame.uri.toString();
          if (path.contains('test/') && !path.contains('util.dart')) {
            callerFrame = frame;
            break;
          }
        }
        if (callerFrame == null) {
          throw StateError('Cannot find caller file in stack trace');
        }
        final file = File(callerFrame.uri.toFilePath());
        final content = file.readAsStringSync();

        final matches = _countMatches(content, expected);
        if (matches != 1) {
          throw TestFailure(
            'Cannot update golden: found $matches occurrences of the expected string in ${file.path}. It must appear exactly once.',
          );
        }

        final newContent = content.replaceFirst(expected, actual);
        file.writeAsStringSync(newContent);
        markTestSkipped('Golden updated!');
      } else {
        check(actualTrimmed).equals(expectedTrimmed);
      }
    }
  });
}

int _countMatches(String source, String target) {
  var count = 0;
  var index = 0;
  while ((index = source.indexOf(target, index)) != -1) {
    count++;
    index += target.length;
  }
  return count;
}
