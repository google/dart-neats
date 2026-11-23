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
///
/// {@category guide}
Builder re2cBuilder(BuilderOptions options) => _Re2cBuilder();

Future<({String executable, String version})>? _re2c;

// Matches `/*!include:re2c "..." */`, `%{include "..." %}`, and `!include "...";`.
final _includePattern = RegExp(
  r'(?:/\*!include:re2c|%\{include|!include)[ \t]+"((?:[^"\\\n]|\\.)*)"',
);

final class _Re2cBuilder implements Builder {
  @override
  final buildExtensions = const {
    '.re': ['.dart'],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    final input = buildStep.inputId;
    final files = await _readWithIncludes(buildStep, input);
    final languageVersion =
        (await buildStep.packageConfig)[input.package]?.languageVersion;
    final String executable;
    try {
      (:executable, version: _) = await (_re2c ??= findRe2c());
    } catch (_) {
      _re2c = null;
      rethrow;
    }
    final result = await generateDart(
      executable,
      files[input.path]!,
      path: input.path,
      files: files,
      languageVersion: languageVersion?.toString(),
    );
    if (result.warnings.isNotEmpty) {
      log.warning(result.warnings);
    }
    await buildStep.writeAsString(input.changeExtension('.dart'), result.dart);
  }
}

/// Reads [root] and any transitively included files in the same package via
/// [buildStep] so `build_runner` tracks them as inputs.
Future<Map<String, String>> _readWithIncludes(
  BuildStep buildStep,
  AssetId root,
) async {
  final files = <String, String>{};
  final queue = [root];
  while (queue.isNotEmpty) {
    final id = queue.removeLast();
    if (files.containsKey(id.path)) continue;
    final content = await buildStep.readAsString(id);
    files[id.path] = content;
    for (final match in _includePattern.allMatches(content)) {
      final raw = match
          .group(1)!
          .replaceAllMapped(RegExp(r'\\(.)'), (m) => m.group(1)!);
      final targetPath = p.posix.normalize(
        p.posix.join(p.posix.dirname(id.path), raw),
      );
      if (p.posix.isWithin('.', targetPath)) {
        final target = AssetId(id.package, targetPath);
        if (await buildStep.canRead(target)) {
          queue.add(target);
        }
      }
    }
  }
  return files;
}
