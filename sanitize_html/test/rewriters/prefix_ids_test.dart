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
  group('HtmlRewriter.prefixIds:', () {
    test('HtmlRewriter.prefixIds prefixes ids and fragments once', () {
      String s(String html) => sanitizeHtml(
            html,
            rewriters: [HtmlRewriter.prefixIds('user-content-')],
          );
      expect(
          s('<h2 id="a">x</h2><a href="#a">y</a><a href="#">z</a>'),
          '<h2 id="user-content-a">x</h2><a href="#user-content-a">y</a>'
          '<a href="#">z</a>');
      expect(s('<h2 id="user-content-a">x</h2><a href="#user-content-a">y</a>'),
          '<h2 id="user-content-a">x</h2><a href="#user-content-a">y</a>');
      expect(s('<a name="a" href="/p#a">y</a>'), '<a href="/p#a">y</a>');
    });
  });
}
