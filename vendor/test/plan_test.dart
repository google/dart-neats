// Copyright 2022 Google LLC
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
import 'package:vendor/src/config.dart';
import 'package:vendor/src/plan.dart';

import 'dart:convert' show jsonEncode;

void main() {
  test('plan empty config', () {
    final actions = plan(
      rootPackageName: 'myapp',
      desiredState: VendorConfig.fromYaml(jsonEncode({})),
      currentState: VendorConfig.fromYaml(jsonEncode({})),
      defaultHostedUrl: Uri.parse('https://pub.dartlang.org/'),
    );

    expect(actions.map((a) => a.summary), []);
  });

  test('plan add foo', () {
    final actions = plan(
      rootPackageName: 'myapp',
      desiredState: VendorConfig.fromYaml(jsonEncode({
        'vendored_dependencies': {
          'foo': {
            'package': 'foo',
            'version': '1.0.0',
            'import_rewrites': {},
          },
        },
      })),
      currentState: VendorConfig.fromYaml(jsonEncode({})),
      defaultHostedUrl: Uri.parse('https://pub.dartlang.org/'),
    );

    expect(actions.map((a) => a.summary), [
      'fetch foo:1.0.0 -> lib/src/third_party/foo/ (from https://pub.dartlang.org/)',
      'rewrite import "package:foo/" -> "package:myapp/lib/src/third_party/foo/lib/" in lib/src/third_party/foo/',
      'write lib/src/third_party/vendor-state.yaml',
    ]);
  });

  test('plan retains foo, with no changes', () {
    final actions = plan(
      rootPackageName: 'myapp',
      desiredState: VendorConfig.fromYaml(jsonEncode({
        'vendored_dependencies': {
          'foo': {
            'package': 'foo',
            'version': '1.0.0',
            'import_rewrites': {},
          },
        },
      })),
      currentState: VendorConfig.fromYaml(jsonEncode({
        'vendored_dependencies': {
          'foo': {
            'package': 'foo',
            'version': '1.0.0',
            'import_rewrites': {},
          },
        },
      })),
      defaultHostedUrl: Uri.parse('https://pub.dartlang.org/'),
    );

    expect(actions.map((a) => a.summary), []);
  });

  test('plan upgrade foo', () {
    final actions = plan(
      rootPackageName: 'myapp',
      desiredState: VendorConfig.fromYaml(jsonEncode({
        'vendored_dependencies': {
          'foo': {
            'package': 'foo',
            'version': '1.2.3',
            'import_rewrites': {},
          },
        },
      })),
      currentState: VendorConfig.fromYaml(jsonEncode({
        'vendored_dependencies': {
          'foo': {
            'package': 'foo',
            'version': '1.0.0',
            'import_rewrites': {},
          },
        },
      })),
      defaultHostedUrl: Uri.parse('https://pub.dartlang.org/'),
    );

    expect(actions.map((a) => a.summary), [
      'delete lib/src/third_party/foo/',
      'fetch foo:1.2.3 -> lib/src/third_party/foo/ (from https://pub.dartlang.org/)',
      'rewrite import "package:foo/" -> "package:myapp/lib/src/third_party/foo/lib/" in lib/src/third_party/foo/',
      'write lib/src/third_party/vendor-state.yaml',
    ]);
  });

  test('plan vendoring bar used by foo', () {
    final actions = plan(
      rootPackageName: 'myapp',
      desiredState: VendorConfig.fromYaml(jsonEncode({
        'vendored_dependencies': {
          'foo': {
            'package': 'foo',
            'version': '1.0.0',
            'import_rewrites': {
              'bar': 'mybar',
            },
          },
          'mybar': {
            'package': 'mybar',
            'version': '1.2.3',
            'import_rewrites': {},
          },
        },
      })),
      currentState: VendorConfig.fromYaml(jsonEncode({
        'vendored_dependencies': {
          'foo': {
            'package': 'foo',
            'version': '1.0.0',
            'import_rewrites': {},
          },
        },
      })),
      defaultHostedUrl: Uri.parse('https://pub.dartlang.org/'),
    );

    expect(actions.map((a) => a.summary), [
      'fetch mybar:1.2.3 -> lib/src/third_party/mybar/ (from https://pub.dartlang.org/)',
      'rewrite import "package:mybar/" -> "package:myapp/lib/src/third_party/mybar/lib/" in lib/src/third_party/mybar/',
      'rewrite import "package:bar/" -> "package:myapp/lib/src/third_party/mybar/lib/" in lib/src/third_party/foo/',
      'write lib/src/third_party/vendor-state.yaml',
    ]);
  });

  test('plan unvendoring bar used by foo', () {
    final actions = plan(
      rootPackageName: 'myapp',
      desiredState: VendorConfig.fromYaml(jsonEncode({
        'vendored_dependencies': {
          'foo': {
            'package': 'foo',
            'version': '1.0.0',
            'import_rewrites': {},
          },
        },
      })),
      currentState: VendorConfig.fromYaml(jsonEncode({
        'vendored_dependencies': {
          'foo': {
            'package': 'foo',
            'version': '1.0.0',
            'import_rewrites': {
              'bar': 'mybar',
            },
          },
          'mybar': {
            'package': 'mybar',
            'version': '1.2.3',
            'import_rewrites': {},
          },
        },
      })),
      defaultHostedUrl: Uri.parse('https://pub.dartlang.org/'),
    );

    expect(actions.map((a) => a.summary), [
      'delete lib/src/third_party/mybar/',
      'rewrite import "package:myapp/lib/src/third_party/mybar/lib/" -> "package:bar/" in lib/src/third_party/foo/',
      'write lib/src/third_party/vendor-state.yaml',
    ]);
  });

  test('plan rewrite for foobar', () {
    final actions = plan(
      rootPackageName: 'myapp',
      desiredState: VendorConfig.fromYaml(jsonEncode({
        'import_rewrites': {
          'foobar': 'foo',
        },
        'vendored_dependencies': {
          'foo': {
            'package': 'foo',
            'version': '1.0.0',
            'import_rewrites': {},
          },
        },
      })),
      currentState: VendorConfig.fromYaml(jsonEncode({
        'vendored_dependencies': {
          'foo': {
            'package': 'foo',
            'version': '1.0.0',
            'import_rewrites': {},
          },
        },
      })),
      defaultHostedUrl: Uri.parse('https://pub.dartlang.org/'),
    );

    expect(actions.map((a) => a.summary), [
      'rewrite import "package:foobar/" -> "package:myapp/lib/src/third_party/foo/lib/" in ./',
      'write lib/src/third_party/vendor-state.yaml',
    ]);
  });
}
