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

/// These mirror dartdoc's `test/example_path_resolution_test.dart`, because
/// the two tools are supposed to accept the same references. A divergence
/// should show up here as a deliberate change, not as a surprise in someone's
/// repository.
library;

import 'package:checks/checks.dart';
import 'package:example/src/diagnostic.dart';
import 'package:example/src/resolve.dart';
import 'package:path/path.dart' as p;
import 'package:test/scaffolding.dart';

import 'checks_ext.dart';

const root = '/pkg';

String resolve(String reference, {String document = '/pkg/README.md'}) =>
    resolveReference(
      packageRoot: root,
      documentPath: document,
      reference: reference,
    );

void main() {
  test('a relative path is relative to the document', () {
    check(resolve('example/hello.dart'))
        .equals(p.normalize('/pkg/example/hello.dart'));
    check(resolve('hello.dart', document: '/pkg/doc/guide.md'))
        .equals(p.normalize('/pkg/doc/hello.dart'));
    check(resolve('../example/hello.dart', document: '/pkg/doc/guide.md'))
        .equals(p.normalize('/pkg/example/hello.dart'));
  });

  test('a leading slash is relative to the package root', () {
    check(resolve('/example/hello.dart', document: '/pkg/doc/deep/guide.md'))
        .equals(p.normalize('/pkg/example/hello.dart'));
  });

  test('`.` segments are normalised away', () {
    check(resolve('./example/./hello.dart'))
        .equals(p.normalize('/pkg/example/hello.dart'));
  });

  test('`..` is clamped at the package root', () {
    // URI resolution runs out of path rather than escaping, which is what
    // dartdoc relies on; the `isWithin` check below is the safety net.
    check(resolve('../../../etc/passwd'))
        .equals(p.normalize('/pkg/etc/passwd'));
  });

  test('percent-encoding is decoded', () {
    check(resolve('example/hello%20world.dart'))
        .equals(p.normalize('/pkg/example/hello world.dart'));
  });

  test('spaces in the document directory are not double-encoded', () {
    check(resolve('hello.dart', document: '/pkg/docs dir/guide.md'))
        .equals(p.normalize('/pkg/docs dir/hello.dart'));
  });

  test('the fragment is not part of the path', () {
    check(resolve('example/hello.dart#greeting'))
        .equals(p.normalize('/pkg/example/hello.dart'));
  });

  test('a scheme is an error', () {
    check(() => resolve('file:///etc/passwd'))
        .throws<ExampleFormatException>()
        .message
        .contains('scheme');
    check(() => resolve('https://example.com/hello.dart'))
        .throws<ExampleFormatException>();
  });

  test('an authority is an error', () {
    check(() => resolve('//example.com/hello.dart'))
        .throws<ExampleFormatException>()
        .message
        .contains('authority');
  });

  test('an empty reference is an error', () {
    check(() => resolve('')).throws<ExampleFormatException>();
    check(() => resolve('#region')).throws<ExampleFormatException>();
  });
}
