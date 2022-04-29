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

import 'package:vendor/src/config.dart' show VendorState, VendorConfig;
import 'package:vendor/src/action/action.dart' show Action;
import 'package:vendor/src/utils/map_ext.dart' show MapExt;

/// Plan the actions required to go from [currentState] to [desiredState].
List<Action> plan({
  required String rootPackageName,
  required VendorConfig desiredState,
  required VendorConfig currentState,
  required Uri defaultHostedUrl,
}) {
  bool notSameSameSource(String name) {
    final current = currentState.dependencies[name];
    final desired = desiredState.dependencies[name];
    return current != desired &&
        ((current == null || desired == null) ||
            current.package != desired.package ||
            current.version != desired.version ||
            (!current.include.containsAll(desired.include) ||
                !desired.include.containsAll(current.include)));
  }

  return [
    // Vendored folders to be removed
    ...currentState.dependencies.keys
        .where(notSameSameSource)
        .map((name) => Action.removeFolder(_vendoredPackageFolder(name))),

    // Packages to be fetched
    ...desiredState.dependencies.keys
        .where(notSameSameSource)
        .map((name) => Action.fetchPackage(
              _vendoredPackageFolder(name),
              desiredState.dependencies[name]!.package,
              desiredState.dependencies[name]!.version,
              defaultHostedUrl,
              desiredState.dependencies[name]!.include,
            )),

    // For each package to be fetched, we must always rewrite self-imports
    ...desiredState.dependencies.keys
        .where(notSameSameSource)
        .map((name) => Action.rewriteImportPath(
              folder: _vendoredPackageFolder(name),
              from: _packageUri(desiredState.dependencies[name]!.package),
              to: _vendoredPackageUri(rootPackageName, name),
            )),

    // Top-level import rewrites
    ..._rewriteChanges(
      rootPackageName,
      Uri.directory('.'),
      desiredState.rewrites,
      currentState.rewrites,
    ),

    // Import rewrites within vendored packages
    ...desiredState.dependencies.keys
        .map((name) => _rewriteChanges(
              rootPackageName,
              _vendoredPackageFolder(name),
              desiredState.dependencies[name]!.rewrites,
              notSameSameSource(name)
                  ? <String, String>{}
                  : currentState.dependencies[name]!.rewrites,
            ))
        .expand((actions) => actions),

    // Write vendor-state.yaml
    if (currentState != desiredState)
      Action.writeFile(
        Uri.file('lib/src/third_party/vendor-state.yaml'),
        VendorState.fromConfig(desiredState).toYaml(),
      ),
  ];
}

Uri _vendoredPackageFolder(String name) =>
    Uri.directory('lib/src/third_party/$name');

Uri _packageUri(String package) => Uri(
      scheme: 'package',
      path: '$package/',
    );

Uri _vendoredPackageUri(String rootPackageName, String name) => Uri(
      scheme: 'package',
      path: '$rootPackageName/lib/src/third_party/$name/lib/',
    );

Iterable<Action> _rewriteChanges(
  String rootPackageName,
  Uri folder,
  Map<String, String> desiredRewrites,
  Map<String, String> currentRewrites,
) =>
    [
      // Reverse rewrites that have been remvoed
      ...currentRewrites
          .where((from, to) => !desiredRewrites.containsKey(from))
          .mapPairs((from, to) => Action.rewriteImportPath(
                folder: folder,
                from: _vendoredPackageUri(rootPackageName, to),
                to: _packageUri(from),
              )),

      // Update rewrites that have changed
      ...currentRewrites
          .where((from, to) => desiredRewrites[from] != to)
          .where((from, to) => desiredRewrites.containsKey(from))
          .mapPairs((from, to) => Action.rewriteImportPath(
                folder: folder,
                from: _vendoredPackageUri(rootPackageName, to),
                to: _vendoredPackageUri(
                  rootPackageName,
                  desiredRewrites[from]!,
                ),
              )),

      // Add new rewrites
      ...desiredRewrites
          .where((from, to) => !currentRewrites.containsKey(from))
          .mapPairs((from, to) => Action.rewriteImportPath(
                folder: folder,
                from: _packageUri(from),
                to: _vendoredPackageUri(rootPackageName, to),
              )),
    ];
