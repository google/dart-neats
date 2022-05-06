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

import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:vendor/src/config.dart';
import 'package:vendor/src/context.dart';

/// Check dependencies for all vendored packages.
///
/// If a dependency of a vendored package must be:
///  * satisfied by the dependency constrant in [rootPubspec],
///  * declared in `dependency_overrides ` in [rootPubspec], or,
///  * rewritten to another vendored package.
///
/// If neither of these scenarios is the case, then this method will print a
/// warning with hints of how to resolve situation.
Future<void> checkDependenciesForVendoredPackages(
  Context ctx, {
  required Pubspec rootPubspec,
  required VendorConfig config,
}) async {
  config.dependencies.forEach((vendoredPackage, vendoredSource) {
    final pubspecFile = ctx.file(
      'lib/src/third_party/$vendoredPackage/vendored-pubspec.yaml',
    );
    try {
      final spec = Pubspec.parse(
        pubspecFile.readAsStringSync(),
        sourceUrl: pubspecFile.uri,
        lenient: true,
      );
      for (final dep in spec.dependencies.keys) {
        if (!vendoredSource.rewrites.containsKey(dep) &&
            !rootPubspec.dependencies.containsKey(dep) &&
            !rootPubspec.dependencyOverrides.containsKey(dep)) {
          ctx.warning(
            'Vendored package $vendoredPackage depends on $dep not provided!',
          );
        }
      }
    } catch (e) {
      ctx.warning('Failed to check dependencies for $vendoredPackage');
    }
  });
  // TODO: Provide hints about dependencies that could be added `dart pub add`
}
