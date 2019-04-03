// Copyright 2019 Google LLC
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

import 'package:sanitize_html/sanitize_html.dart' show sanitizeHtml;
import 'dart:io' show Platform, File;
import 'package:markdown/markdown.dart' show markdownToHtml;
import 'dart:math' as math;

Duration measure(void Function() fn, [int iterations = 1]) {
  final w = Stopwatch();
  w.start();
  for (var i = 0; i < iterations; i++) {
    fn();
  }
  w.stop();
  return Duration(microseconds: w.elapsedMicroseconds);
}

void benchmark(String name, void Function() fn) {
  final initialIterations = 100;
  final d = measure(fn, initialIterations) ~/ initialIterations;
  final iterations = math.max(
    Duration(seconds: 10).inMicroseconds ~/ d.inMicroseconds,
    5,
  );
  final time = measure(fn, iterations) ~/ iterations;
  print('$name took ${time.inMicroseconds} μs ($iterations iterations)');
}

Future<void> main() async {
  final testFile = Platform.script.resolve('testdata/lorem-ipsum.md');
  final testData = await File(testFile.toFilePath()).readAsString();

  benchmark('renderMarkdown', () {
    markdownToHtml(testData);
  });

  final html = markdownToHtml(testData);
  benchmark('sanitizeHtml', () {
    sanitizeHtml(
      html,
      allowClassName: (_) => true,
      allowElementId: (_) => true,
    );
  });

  benchmark('renderMarkdown + sanitizeHtml', () {
    sanitizeHtml(
      markdownToHtml(testData),
      allowClassName: (_) => true,
      allowElementId: (_) => true,
    );
  });
}
