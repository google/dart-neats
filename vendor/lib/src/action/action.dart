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

import 'package:meta/meta.dart' show sealed;
import 'package:pub_semver/pub_semver.dart' show Version;
import 'package:vendor/src/action/import_rewrite.dart' show ImportRewriteAction;
import 'package:vendor/src/action/fetch_package.dart' show FetchPackageAction;
import 'package:vendor/src/action/remove_folder.dart' show RemoveFolderAction;
import 'package:vendor/src/action/write_file.dart' show WriteFileAction;
import 'package:vendor/src/context.dart' show Context;

export 'package:vendor/src/context.dart' show Context;

/// An [Action] is a step that can be planned for execution when vendoring.
///
/// This allows for steps to first be planned and then executed. Thus, we can
/// a dry-run that only creates actions and displays them, but doesn't actually
/// execute the actions.
@sealed
abstract class Action {
  /// Short single-line humand readable description of this action.
  String get summary;

  /// Long-form human readable description of what this action entails.
  ///
  /// Usually a single line summary, followed by a few lines of details.
  String get description => summary;

  /// Execute this action in the given [ctx].
  Future<void> apply(Context ctx);

  /// Rewrite import/export statements pointing to [from] in [folder], such that
  /// they now point to [to].
  static Action rewriteImportPath({
    required Uri folder,
    required Uri from,
    required Uri to,
  }) =>
      ImportRewriteAction(
        folder: folder,
        from: from,
        to: to,
      );

  /// Fetch [package] [version] from [hostedUrl] into [folder].
  ///
  /// Only includes files that match a `package:glob` pattern from [include].
  static Action fetchPackage(
    Uri folder,
    String package,
    Version version,
    Uri hostedUrl,
    Set<String> include,
  ) =>
      FetchPackageAction(
        folder: folder,
        package: package,
        version: version,
        hostedUrl: hostedUrl,
        include: include,
      );

  /// Remove [folder].
  static Action removeFolder(
    Uri folder,
  ) =>
      RemoveFolderAction(folder);

  /// Write [contents] to [file].
  static Action writeFile(
    Uri file,
    String contents,
  ) =>
      WriteFileAction(file, contents);
}
