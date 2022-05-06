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

void main() {
  test('VendorConfig.fromYaml', () {
    final c = VendorConfig.fromYaml(
      '''
import_rewrites:
  pem: pem
vendored_dependencies:
  pem:
    package: pem
    version: 1.0.1
    import_rewrites: {}
''',
      sourceUri: Uri.file('/tmp/test.yaml'),
    );

    expect(c.rewrites, containsPair('pem', 'pem'));
    expect(c.rewrites, hasLength(1));
    expect(c.dependencies, contains('pem'));
    final pem = c.dependencies['pem']!;
    expect(pem.package, equals('pem'));
    expect(pem.version.major, equals(1));
    expect(pem.version.minor, equals(0));
    expect(pem.version.patch, equals(1));
    expect(pem.rewrites, hasLength(0));
  });

  test('VendorState.empty', () {
    final s = VendorState.empty;
    expect(s.config.rewrites, hasLength(0));
    expect(s.config.dependencies, hasLength(0));
  });

  test('VendorState.fromConfig / toYaml / fromYaml', () {
    final c = VendorConfig.fromYaml(
      '''
import_rewrites:
  pem: pem
vendored_dependencies:
  pem:
    package: pem
    version: 1.0.1
    import_rewrites: {}
''',
      sourceUri: Uri.file('/tmp/test.yaml'),
    );
    final s = VendorState.fromConfig(c);
    expect(s.config.rewrites, hasLength(1));
    expect(s.config.dependencies, hasLength(1));

    final y = s.toYaml();
    expect(y, isNotEmpty);

    final s2 = VendorState.fromYaml(y);
    expect(s2.config.rewrites, hasLength(1));
    expect(s2.config.dependencies, hasLength(1));
  });
}
