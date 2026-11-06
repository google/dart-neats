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
import 'dart:convert';

import 'package:sanitize_html/sanitize_html.dart';
import 'package:test/test.dart';

void main() {
  group('htmlWriter:', () {
    HtmlTokenSink writer([void Function(String)? output]) =>
        htmlWriter(StringConversionSink.withCallback(output ?? (_) {}));

    test('throws on names it cannot write', () {
      expect(() => writer().startTag('DIV', const {}), throwsArgumentError);
      expect(() => writer().startTag('image', const {}), throwsArgumentError);
      expect(() => writer().startTag('div', {'on click': ''}),
          throwsArgumentError);
    });

    test('balances and escapes', () {
      late final String output;
      writer((s) => output = s)
        ..startTag('p', {'title': 'a"b<c>&'})
        ..text('x <y> & &amp; &#1; &;', 0, 21)
        ..startTag('br', const {})
        ..startTag('b', const {})
        ..endTag('p')
        ..endTag('nope')
        ..startTag('i', const {})
        ..close();
      expect(output,
          '<p title="a&quot;b&lt;c&gt;&amp;">x &lt;y&gt; &amp; &amp; &#1; &amp;;<br><b></b></p><i></i>');
    });

    test('refuses tokens after close', () {
      final w = writer()..close();
      expect(() => w.text('x', 0, 1), throwsStateError);
      expect(() => w.close(), throwsStateError);
    });
  });
}
