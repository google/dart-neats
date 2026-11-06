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
import 'package:sanitize_html/sanitize_html.dart';
import 'package:test/test.dart';

void main() {
  group('HtmlRewriter:', () {
    final prefix = HtmlRewriter.prefixIds('p-');
    final upper = HtmlRewriter.rewriteAttributes(
        (a) => a.update('id', (id) => id.toUpperCase(), ifAbsent: () => ''));
    String run(HtmlRewriter rewriter) => sanitizeHtml('<h2 id="x">y</h2>',
        rules: RuleSet.gfm().union(RuleSet({
          'h2': ElementRule(attributes: {'id': const AttributeRule.any()}),
        })),
        rewriters: [rewriter]);

    test('fuse runs this, then next', () {
      expect(run(prefix.fuse(upper)), '<h2 id="P-X">y</h2>');
      expect(run(upper.fuse(prefix)), '<h2 id="p-X">y</h2>');
    });

    test('a sequence fuses in order; none is the identity', () {
      expect(run([prefix, upper].fuse()), '<h2 id="P-X">y</h2>');
      expect(run(<HtmlRewriter>[].fuse()), '<h2 id="x">y</h2>');
      expect(run(const HtmlRewriter.identity()), '<h2 id="x">y</h2>');
    });
  });
}
