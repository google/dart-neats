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
import 'package:vendor/src/exceptions.dart';
import 'package:vendor/src/validate.dart';
import 'package:vendor/src/exceptions.dart' show VendorFailure;
import 'package:test_descriptor/test_descriptor.dart' as d;

import 'dart:convert' show jsonEncode;

void main() {
  group('validateConfig', () {
    test('validates empty config', () {
      validateConfig(VendorConfig.fromYaml(jsonEncode({
        'import_rewrites': {},
        'vendored_dependencies': {},
      })));
      validateConfig(VendorConfig.fromYaml(jsonEncode({
        'import_rewrites': null,
        'vendored_dependencies': null,
      })));
      validateConfig(VendorConfig.fromYaml(jsonEncode({})));
    });

    test('validates simple config', () {
      final c = VendorConfig.fromYaml(jsonEncode({
        'import_rewrites': {'foo': 'foo'},
        'vendored_dependencies': {
          'foo': {
            'package': 'foo',
            'version': '1.0.0',
            'import_rewrites': {},
          },
        },
      }));

      validateConfig(c);
    });

    test('validates config with two packages', () {
      final c = VendorConfig.fromYaml(jsonEncode({
        'import_rewrites': {'foo': 'foo'},
        'vendored_dependencies': {
          'foo': {
            'package': 'foo',
            'version': '1.0.0',
            'import_rewrites': {
              'bar': 'bar',
            },
          },
          'bar': {
            'package': 'bar',
            'version': '1.2.3',
            'import_rewrites': {},
          },
        },
      }));

      validateConfig(c);
    });

    test('validates config with circular dependency', () {
      final c = VendorConfig.fromYaml(jsonEncode({
        'import_rewrites': {'foo': 'foo'},
        'vendored_dependencies': {
          'foo': {
            'package': 'foo',
            'version': '1.0.0',
            'import_rewrites': {
              'bar': 'bar',
            },
          },
          'bar': {
            'package': 'bar',
            'version': '1.2.3',
            'import_rewrites': {
              'foo': 'foo',
            },
          },
        },
      }));

      validateConfig(c);
    });

    test('validates config with package renaming', () {
      final c = VendorConfig.fromYaml(jsonEncode({
        'import_rewrites': {'foo': 'foobar'},
        'vendored_dependencies': {
          'foobar': {
            'package': 'foo',
            'version': '1.0.0',
            'import_rewrites': {
              'bar': 'bar',
            },
          },
          'bar': {
            'package': 'bar',
            'version': '1.2.3',
            'import_rewrites': {},
          },
        },
      }));

      validateConfig(c);
    });

    test('rejects config with missing rewrite', () {
      final c = VendorConfig.fromYaml(jsonEncode({
        'import_rewrites': {'foo': 'foobar'},
        'vendored_dependencies': {},
      }));

      expect(() => validateConfig(c), throwsFormatException);
    });

    test('rejects config irrevesable rewrites', () {
      final c = VendorConfig.fromYaml(jsonEncode({
        'import_rewrites': {
          'foo': 'foobar',
          'foobar': 'foobar',
        },
        'vendored_dependencies': {
          'foobar': {
            'package': 'foo',
            'version': '1.0.0',
            'import_rewrites': {
              'bar': 'bar',
            },
          },
        },
      }));

      expect(() => validateConfig(c), throwsFormatException);
    });
  });

  group('validateState', () {
    test('validates VendorState.empty', () async {
      await validateState(VendorState.empty, Uri.directory(d.sandbox));
    });

    test('validates VendorState from 0.9.0', () async {
      final s = VendorState.fromYaml(jsonEncode({
        'version': '0.9.0',
        'config': {
          'import_rewrites': {},
          'vendored_dependencies': {},
        },
      }));

      await validateState(s, Uri.directory(d.sandbox));
    });

    test('rejects VendorState from 999.9.9', () async {
      final s = VendorState.fromYaml(jsonEncode({
        'version': '999.9.9',
        'config': {
          'import_rewrites': {},
          'vendored_dependencies': {},
        },
      }));

      expect(
        validateState(s, Uri.directory(d.sandbox)),
        throwsA(isA<VendorFailure>()),
      );
    });
  });
}
