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

import 'dart:io' show Directory, IOException;

import 'package:meta/meta.dart' show sealed;
import 'package:vendor/src/exceptions.dart' show VendorFailure, ExitCode;
import 'package:vendor/src/action/action.dart' show Action, Context;

@sealed
class RemoveFolderAction extends Action {
  final Uri folder;

  RemoveFolderAction(this.folder);

  @override
  String get summary => 'delete $folder';

  @override
  Future<void> apply(Context ctx) async {
    final target = Directory.fromUri(
      ctx.rootPackageFolder.resolveUri(folder),
    );
    try {
      ctx.log('# Apply: Remove folder $folder');
      await target.delete(recursive: true);
    } on IOException catch (e) {
      throw VendorFailure(
        ExitCode.tempFail,
        'unable to delete $folder, failure: $e',
      );
    }
  }
}
