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
import 'package:test/test.dart';
import 'helpers.dart';

void main() {
  group('URI obfuscation & entity encoding attacks:', () {
    testNotContains('<a href="jav&#x09;ascript:alert(1)">link</a>', 'href');
    testNotContains('<a href="jav&#x0A;ascript:alert(1)">link</a>', 'href');
    testNotContains('<a href="jav&#x0D;ascript:alert(1)">link</a>', 'href');
    testNotContains('<a href="&Tab;javascript:alert(1)">link</a>', 'href');
    testNotContains('<a href="&NewLine;javascript:alert(1)">link</a>', 'href');
    testNotContains('<a href="javascript&#58;alert(1)">link</a>', 'href');
    testNotContains('<a href="javascript&colon;alert(1)">link</a>', 'href');
    testNotContains(
        '<a href="&#106;&#97;&#118;&#97;&#115;&#99;&#114;&#105;&#112;&#116;:alert(1)">link</a>',
        'href');
    testNotContains(
        '<a href="&#x6a;&#x61;&#x76;&#x61;&#x73;&#x63;&#x72;&#x69;&#x70;&#x74;:alert(1)">link</a>',
        'href');
    testNotContains('<a href="&#0000106;avascript:alert(1)">link</a>', 'href');
    testNotContains('<a href="  javascript:alert(1)">link</a>', 'href');
    testNotContains('<a href="\x01javascript:alert(1)">link</a>', 'href');
    testNotContains(
        '<a href="data:text/html;base64,PHNjcmlwdD5hbGVydCgxKTwvc2NyaXB0Pg==">link</a>',
        'href');
    testNotContains('<a href="vbscript:msgbox(1)">link</a>', 'href');
    testNotContains('<a href="feed:javascript:alert(1)">link</a>', 'href');
    testNotContains(r'<a href="\\evil.com">link</a>', 'href');
    testNotContains(r'<a href="/\evil.com">link</a>', 'href');
    testNotContains(r'<a href="///\evil.com">link</a>', 'href');
    testNotContains(r'<a href="\evil.com">link</a>', 'href');
    testNotContains(r'<a href="https://example.com/foo\bar">link</a>', 'href');
    testNotContains('<a href="https://good.com@evil.com/">link</a>', 'href');
    testNotContains('<a href="//good.com@evil.com/">link</a>', 'href');
    testNotContains('<a href="https://good.com\\@evil.com/">link</a>', 'href');
    testContains('<a href="https://example.com/?u=a@b">link</a>', 'href');
    testContains('<a href="https://example.com/#@x">link</a>', 'href');
  });

  group('Authority must be present:', () {
    // Against an http(s) base a browser skips the extra slashes and goes to
    // evil.com, while `Uri` sees an empty host.
    testNotContains('<a href="///evil.com">link</a>', 'href');
    testNotContains('<a href="https:///evil.com">link</a>', 'href');
    testNotContains('<a href="//">link</a>', 'href');
    testNotContains('<a href="//?x">link</a>', 'href');
    testNotContains('<a href="https://">link</a>', 'href');
    testNotContains('<a href="mailto://a@b">link</a>', 'href');
    testContains('<a href="//example.com">link</a>', 'href');
    testContains('<a href="mailto:a@b">link</a>', 'href');
  });

  group('Browser preprocessing:', () {
    testContains('<a href="HTTPS://EXAMPLE.COM/">link</a>', 'href');
    testContains('<a href="  https://example.com/  ">link</a>', 'href');
    testContains('<a href="https://exam\nple.com/">link</a>', 'href');
    testNotContains('<a href="https://example.com/\x7F">link</a>', 'href');
  });
}
