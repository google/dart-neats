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

import 'dart:io' show File, Platform;

import 'package:bench_press/bench_press.dart';
import 'package:markdown/markdown.dart' show markdownToHtml;
import 'package:sanitize_html/sanitize_html.dart';

Future<void> main(List<String> args) async {
  final testFile = Platform.script.resolve('testdata/lorem-ipsum.md');
  final testData = await File(testFile.toFilePath()).readAsString();
  final html = markdownToHtml(testData);

  final rules = RuleSet.gfm();
  String streaming(String html) =>
      sanitizeHtml(html, rules: rules, tokenizer: HtmlTokenizer.streaming);
  String simple(String html) =>
      sanitizeHtml(html, rules: rules, tokenizer: HtmlTokenizer.simple);
  String dom(String html) =>
      sanitizeHtml(html, rules: rules, tokenizer: HtmlTokenizer.dom);
  String withRel(String html) => sanitizeHtml(
        html,
        rules: rules,
        rewriters: [
          HtmlRewriter.addLinkRel((_) => const ['ugc', 'nofollow'])
        ],
      );

  final group = BenchmarkGroup.compare(
    name: 'HtmlSanitizer',
    baseline: ('HtmlTokenizer.streaming', () => streaming(html)),
    candidates: {
      'HtmlTokenizer.simple': () => simple(html),
      'HtmlTokenizer.dom (package:html)': () => dom(html),
      'streaming + addLinkRel': () => withRel(html),
      'sanitizeHtml (default rules)': () => sanitizeHtml(html),
      'markdownToHtml': () => markdownToHtml(testData),
      'markdownToHtml + sanitizeHtml': () =>
          streaming(markdownToHtml(testData)),
    },
    throughput: ByteThroughput(html.length),
  );

  await mainBenchmarkGroup(group, args);
}
