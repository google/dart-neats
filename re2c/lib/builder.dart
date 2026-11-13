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

/// A `build_runner` builder compiling `.re` files to `.dart` files.
///
/// Applied automatically to packages depending on `package:re2c`.
library;

import 'package:build/build.dart';
import 'package:path/path.dart' as p;

import 'src/executable.dart';
import 'src/generate.dart';

/// Creates the builder compiling `<name>.re` to `<name>.dart`.
Builder re2cBuilder(BuilderOptions options) => _Re2cBuilder();

Future<String>? _re2c;

final class _Re2cBuilder implements Builder {
  @override
  final buildExtensions = const {
    '.re': ['.dart'],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    final input = buildStep.inputId;
    final source = await buildStep.readAsString(input);
    final String re2c;
    try {
      re2c = await (_re2c ??= findRe2c());
    } catch (_) {
      _re2c = null;
      rethrow;
    }
    final result = await generateDart(
      re2c,
      source,
      path: p.absolute(input.path),
    );
    if (result.warnings.isNotEmpty) {
      log.warning(result.warnings);
    }
    await buildStep.writeAsString(input.changeExtension('.dart'), result.dart);
  }
}
