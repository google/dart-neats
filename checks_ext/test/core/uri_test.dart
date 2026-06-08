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

import 'package:checks_ext/src/core/uri.dart';
import '../util.dart';

void main() {
  group('UriChecks', () {
    test('properties extract correct values', () {
      final uri = Uri.parse(
        'https://example.com:8080/path/to/res?id=42#fragment',
      );
      check(uri)
        ..scheme.equals('https')
        ..authority.equals('example.com:8080')
        ..host.equals('example.com')
        ..port.equals(8080)
        ..path.equals('/path/to/res')
        ..query.equals('id=42')
        ..fragment.equals('fragment')
        ..pathSegments.deepEquals(['path', 'to', 'res'])
        ..queryParameters.deepEquals({'id': '42'})
        ..queryParametersAll.deepEquals({
          'id': ['42'],
        });
    });

    test('isAbsolute succeeds when absolute', () {
      final uri = Uri.parse('https://example.com');
      check(uri).isAbsolute();
    });

    test('isAbsolute fails when relative', () {
      final uri = Uri.parse('/path');
      check(
        uri,
      ).isRejectedBy((it) => it.isAbsolute(), which: ['is not absolute']);
    });

    test('hasScheme succeeds when matching', () {
      final uri = Uri.parse('https://example.com');
      check(uri).hasScheme('https');
    });

    test('hasScheme fails when not matching', () {
      final uri = Uri.parse('https://example.com');
      check(uri).isRejectedBy(
        (it) => it.hasScheme('http'),
        which: ["has scheme 'https'"],
      );
    });
    testCheckGolden(
      () {
        final uri = Uri.parse('/path');
        check(uri).isAbsolute();
      },
      '''
# isAbsolute failure message golden
Expected: a Uri that:
  is absolute
Actual: </path>
Which: is not absolute''',
    );

    testCheckGolden(
      () {
        final uri = Uri.parse('https://example.com');
        check(uri).isNotAbsolute();
      },
      '''
# isNotAbsolute failure message golden
Expected: a Uri that:
  is not absolute
Actual: <https://example.com>
Which: is absolute''',
    );
  });
}
