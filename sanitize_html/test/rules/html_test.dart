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
  group('RuleSet.html:', () {
    test('html keeps what safevalues keeps, checked by our policies', () {
      String s(String html) => sanitizeHtml(html, rules: RuleSet.html());
      expect(
          s('<article><select><option selected>x</option></select>'
              '<progress max="2" value="1"></progress></article>'),
          '<article><select><option selected="">x</option></select>'
          '<progress max="2" value="1"></progress></article>');
      expect(
          s('<iframe src="/x"></iframe><input><label for="y">a</label>'
              '<button>b</button><link rel="stylesheet" href="x.css">'),
          'ab');
      expect(s('<div id="x" name="y" class="z" style="a" title="t">a</div>'),
          '<div title="t">a</div>');
      expect(s('<a href="/x" target="_blank" rel="noopener">a</a>'),
          '<a href="/x" target="_blank" rel="noopener">a</a>');
      expect(s('<a href="javascript:x" target="top" rel="opener">a</a>'),
          '<a>a</a>');
      expect(
          s('<video src="https://e.x/v" poster="javascript:x" autoplay>'
              '</video>'),
          '<video src="https://e.x/v" autoplay=""></video>');
      expect(s('<bdo dir="rtl">a</bdo><bdo dir="foo">b</bdo>'),
          '<bdo dir="rtl">a</bdo><bdo>b</bdo>');
      expect(s('<q cite="data:x">a</q>'), '<q>a</q>');
      // The seven things dropped on this package's own authority.
      expect(
          s('<select required autofocus><option>x</option></select>'
              '<a href="/f" download>d</a><img src="/i" usemap="#m">'
              '<slot>s</slot><span slot="n" itemref="i">t</span>'),
          '<select><option>x</option></select><a href="/f">d</a>'
          '<img src="/i">s<span>t</span>');
    });
  });
}
