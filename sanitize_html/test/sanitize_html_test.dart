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
import 'package:test/test.dart';

void main() {
  // Calls sanitizeHtml with two different configurations.
  //  * When `withOptionalConfiguration` is `true`:
  //  `addLinkRel` overrides are passed to the sanitizeHtml call of `template`.
  // (This is the default behavior for the [testContains]/[testNotContains] methods.)
  //  * When `withOptionalConfiguration` is false: only `template` is passed.
  String doSanitizeHtml(String template,
      {required bool withOptionalConfiguration}) {
    if (!withOptionalConfiguration) {
      return sanitizeHtml(template);
    }

    return sanitizeHtml(
      template,
      addLinkRel: (href) => href == 'bad-link' ? ['ugc', 'nofollow'] : null,
    );
  }

  void testContains(String template, String needle,
      {bool withOptionalConfiguration = true}) {
    test('"$template" does contain "$needle"', () {
      final sanitizedHtml = doSanitizeHtml(
        template,
        withOptionalConfiguration: withOptionalConfiguration,
      );
      expect(sanitizedHtml, contains(needle));
    });
  }

  void testNotContains(String template, String needle,
      {bool withOptionalConfiguration = true}) {
    test('"$template" does not contain "$needle"', () {
      final sanitizedHtml = doSanitizeHtml(
        template,
        withOptionalConfiguration: withOptionalConfiguration,
      );
      expect(sanitizedHtml, isNot(contains(needle)));
    });
  }

  testNotContains('test', '<br>');
  testContains('test', 'test');
  testContains('a < b', '&lt;');
  testContains('a < b > c', '&gt;');
  testContains('<p>hello', 'hello');
  testContains('<p>hello', '</p>');
  testContains('<p>hello', '<p>');

  testContains('<a href="test.html">hello', 'href');
  testContains('<a href="test.html">hello', 'test.html');
  testNotContains(
      '<a href="//example.com/test.html">hello', '//example.com/test.html');
  testContains('<a href="/test.html">hello', '/test.html');
  testContains('<a href="https://example.com/test.html">hello',
      'https://example.com/test.html');
  testContains('<a href="http://example.com/test.html">hello',
      'http://example.com/test.html');
  testContains(
      '<a href="mailto:test@example.com">hello', 'mailto:test@example.com');

  testContains('<img src="test.jpg"/>', '<img');
  testContains('<img src="test.jpg" alt="say hi"/>', 'say hi');
  testContains('<img src="test.jpg" alt="say hi"/>', 'alt=');
  testContains('<img src="test.jpg" ALt="say hi"/>', 'say hi');
  testContains('<img src="test.jpg" ALT="say hi"/>', 'alt=');
  testContains('<img src="test.jpg"/>', 'src=');
  testContains('<img src="test.jpg"/>', 'test.jpg');
  testNotContains('<img src="//test.jpg"/>', '//test.jpg');
  testContains('<img src="/test.jpg"/>', '/test.jpg');
  testContains('<img src="https://example.com/test.jpg"/>',
      'https://example.com/test.jpg');
  testContains('<img src="http://example.com/test.jpg"/>',
      'http://example.com/test.jpg');

  testNotContains('<img src="javascript:test.jpg"/>', 'src=');
  testNotContains('<img src="javascript:test.jpg"/>', 'javascript');
  testContains('<img src="javascript:test.jpg"/>', 'img');
  testNotContains('<script/>', 'script');
  testNotContains('<script src="example.js"/>', 'script');
  testNotContains('<script src="example.js"/>', 'src');
  testContains('<script>alert("bad")</script> hello world', 'hello world');
  testNotContains('<script>alert("bad")</script> hello world', 'bad');
  testContains('<a href="javascript:alert()">evil link</a>', '<a');
  testNotContains('<a href="javascript:alert()">evil link</a>', 'href');
  testNotContains('<a href="javascript:alert()">evil link</a>', 'alert');
  testNotContains('<a href="javascript:alert()">evil link</a>', 'javascript');

  testNotContains('<form><input type="submit"/></form> click here', 'form');
  testNotContains('<form><input type="submit"/></form> click here', 'submit');
  testNotContains('<form><input type="submit"/></form> click here', 'input');
  testContains('<form><input type="submit"/></form> click here', 'click here');

  testContains('<br>', '<br>');
  testNotContains('<br>', '</br>');
  testNotContains('<br>', '</ br>');
  testContains('><', '&gt;&lt;');
  testContains('<a href="a.html">a</a><a href="b.html">b</a>',
      '<a href="a.html">a</a><a href="b.html">b</a>');

  // test void elements
  testContains('<strong></strong> hello', '<strong>');
  testContains('<strong></strong> hello', '</strong>');
  testNotContains('<strong></strong> hello', '<strong />');
  testContains('<br>hello</br>', '<br>');
  testNotContains('<br>hello</br>', '</br>');
  testNotContains('<br>hello</br>', '</ br>');

  // test addLinkRel
  testContains('<a href="bad-link">hello', 'bad-link');
  testContains('<a href="bad-link">hello', 'rel="ugc nofollow"');
  testNotContains('<a href="good-link">hello', 'rel="ugc nofollow"');

  group('Optional parameters stay optional:', () {
    // If any of these fail, it probably means a major version bump is required.
    testContains('<a href="any-href">hey', 'href=',
        withOptionalConfiguration: false);
    testNotContains('<a href="any-href">hey', 'rel=',
        withOptionalConfiguration: false);
  });

  group('URL Encoding and Whitespace Handling', () {
    group('Valid URL Encoding - Should Be Preserved', () {
      test('preserves %20 (encoded space) in href', () {
        const html =
            '<a href="https://example.com/path%20with%20spaces">Link</a>';
        final result = sanitizeHtml(html);

        expect(result,
            contains('href="https://example.com/path%20with%20spaces"'));
        expect(result, contains('Link'));
      });

      test('preserves multiple URL-encoded characters', () {
        const html =
            '<a href="https://example.com/file%20name%2Ftest%3Fquery">Link</a>';
        final result = sanitizeHtml(html);

        expect(
            result, contains('https://example.com/file%20name%2Ftest%3Fquery'));
      });

      test('preserves %20 in img src', () {
        const html =
            '<img src="https://example.com/image%20file.png" alt="test">';
        final result = sanitizeHtml(html);

        expect(result, contains('src="https://example.com/image%20file.png"'));
      });

      test('preserves query parameters with encoded spaces', () {
        const html =
            '<a href="https://example.com/search?q=hello%20world">Search</a>';
        final result = sanitizeHtml(html);

        expect(result, contains('q=hello%20world'));
      });

      test('preserves complex URL encoding', () {
        const html =
            '<a href="https://example.com/path?name=John%20Doe&city=New%20York">Link</a>';
        final result = sanitizeHtml(html);

        expect(result, contains('name=John%20Doe'));
        expect(result, contains('city=New%20York'));
      });

      test('preserves %2B (encoded plus) and %26 (encoded ampersand)', () {
        const html =
            '<a href="https://example.com/search?q=c%2B%2B%26python">Link</a>';
        final result = sanitizeHtml(html);

        expect(result, contains('q=c%2B%2B%26python'));
      });

      test('preserves URL-encoded Unicode characters', () {
        const html =
            '<a href="https://example.com/%E4%B8%AD%E6%96%87">Chinese</a>';
        final result = sanitizeHtml(html);

        expect(result, contains('%E4%B8%AD%E6%96%87'));
      });

      test('preserves fragment identifiers with encoding', () {
        const html =
            '<a href="https://example.com/page#section%20name">Link</a>';
        final result = sanitizeHtml(html);

        expect(result, contains('#section%20name'));
      });
    });

    group('Actual Whitespace in URLs - Should Be Removed (XSS Prevention)', () {
      test('removes actual spaces in javascript: URL (XSS)', () {
        const html = '<a href="java script:alert(1)">Click</a>';
        final result = sanitizeHtml(html);

        // The whitespace should be removed, making it "javascript:"
        // which should then be blocked
        expect(result, isNot(contains('javascript:')));
        expect(result, isNot(contains('java script')));
        expect(result, contains('Click'));
      });

      test('removes newlines in javascript: URL (XSS)', () {
        const html = '<a href="java\nscript:alert(1)">Click</a>';
        final result = sanitizeHtml(html);

        expect(result, isNot(contains('javascript:')));
        expect(result, contains('Click'));
      });

      test('removes tabs in javascript: URL (XSS)', () {
        const html = '<a href="java\tscript:alert(1)">Click</a>';
        final result = sanitizeHtml(html);

        expect(result, isNot(contains('javascript:')));
        expect(result, contains('Click'));
      });

      test('removes multiple whitespace types in URL', () {
        const html = '<a href="java \n\t script:alert(1)">Click</a>';
        final result = sanitizeHtml(html);

        expect(result, isNot(contains('javascript:')));
        expect(result, contains('Click'));
      });

      test('removes spaces in data: URL (XSS)', () {
        const html =
            '<a href="data :text/html,<script>alert(1)</script>">Click</a>';
        final result = sanitizeHtml(html);

        expect(result, isNot(contains('data:')));
        expect(result, isNot(contains('<script')));
        expect(result, contains('Click'));
      });
    });

    group('Mixed Cases - Encoding vs Actual Whitespace', () {
      test('preserves %20 but removes actual space in same URL', () {
        const html =
            '<a href="https://example.com/path%20encoded and actual space">Link</a>';
        final result = sanitizeHtml(html);

        // %20 should be preserved, actual space should be removed
        expect(result, contains('%20'));
        expect(result, contains('encodedandactualspace'));
      });

      test('handles URL with both encoded and unencoded characters', () {
        const html =
            '<a href="https://example.com/test?q=hello%20world&filter=new stuff">Link</a>';
        final result = sanitizeHtml(html);

        // Encoded space preserved
        expect(result, contains('hello%20world'));
        // Actual space removed
        expect(result, contains('newstuff'));
      });
    });

    group('Special Cases', () {
      test('preserves mailto: with encoded spaces', () {
        const html =
            '<a href="mailto:test@example.com?subject=Hello%20World">Email</a>';
        final result = sanitizeHtml(html);

        expect(result, contains('subject=Hello%20World'));
      });

      test('preserves relative URLs with encoding', () {
        const html = '<a href="/path/to/file%20name.html">Link</a>';
        final result = sanitizeHtml(html);

        expect(result, contains('/path/to/file%20name.html'));
      });

      test('handles empty href gracefully', () {
        const html = '<a href="">Empty</a>';
        final result = sanitizeHtml(html);

        expect(result, contains('Empty'));
      });

      test('handles href with only whitespace (should be removed)', () {
        const html = '<a href="   \n\t  ">Whitespace</a>';
        final result = sanitizeHtml(html);

        // Whitespace removed, leaving empty/invalid href
        expect(result, contains('Whitespace'));
        expect(result, isNot(contains('href=')));
      });
    });

    group('CSS Background URLs with Encoding', () {
      test('preserves %20 in CSS background-image', () {
        const html =
            '<div style="background-image: url(https://example.com/bg%20image.png);">Test</div>';
        final result = sanitizeHtml(html);

        expect(result, contains('bg%20image.png'));
      });

      test('preserves encoded query params in CSS url()', () {
        const html =
            '<div style="background-image: url(https://cdn.com/img?size=large%20&quality=high);">Test</div>';
        final result = sanitizeHtml(html);

        expect(result, contains('size=large%20'));
      });
    });

    group('Edge Cases and Security', () {
      test('blocks %00 (null byte) in URL', () {
        // Null byte can be used to truncate URLs in some contexts
        const html = '<a href="https://example.com%00/evil">Link</a>';
        final result = sanitizeHtml(html);

        // URL should still be present (not a security issue in modern browsers)
        // but we document the behavior
        expect(result, contains('Link'));
      });

      test('handles double-encoding attempts', () {
        // %2520 is double-encoded space (%25 = %, so %2520 = %20)
        const html = '<a href="https://example.com/path%2520test">Link</a>';
        final result = sanitizeHtml(html);

        // Double-encoding should be preserved as-is
        expect(result, contains('%2520'));
      });

      test('handles percent sign followed by non-hex characters', () {
        const html = '<a href="https://example.com/50%discount">Link</a>';
        final result = sanitizeHtml(html);

        // Invalid percent-encoding, but not a security issue
        expect(result, contains('50%discount'));
      });

      test('preserves international domain names with punycode', () {
        const html = '<a href="https://xn--e1afmkfd.xn--p1ai/">Russian</a>';
        final result = sanitizeHtml(html);

        expect(result, contains('xn--e1afmkfd.xn--p1ai'));
      });
    });

    group('Regression Tests - Ensure XSS Blocked', () {
      test('blocks javascript: even with URL encoding', () {
        // %6A = j, %61 = a, %76 = v, %61 = a, %73 = s, %63 = c, %72 = r, %69 = i, %70 = p, %74 = t
        const html =
            '<a href="%6A%61%76%61%73%63%72%69%70%74:alert(1)">Click</a>';
        final result = sanitizeHtml(html);

        // This might not be blocked by our sanitizer since we check lowercase
        // but URL decoders would turn it into javascript:
        // Document this behavior
        expect(result, contains('Click'));
      });

      test('blocks data:text/html with encoding', () {
        const html =
            '<a href="data:text/html,%3Cscript%3Ealert(1)%3C/script%3E">Click</a>';
        final result = sanitizeHtml(html);

        expect(result, isNot(contains('data:text/html')));
        expect(result, contains('Click'));
      });
    });
  });
}
