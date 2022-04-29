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

import 'dart:io' show File, IOException;

import 'package:meta/meta.dart' show sealed;
import 'package:vendor/src/exceptions.dart' show VendorFailure, ExitCode;
import 'package:vendor/src/action/action.dart' show Action, Context;

@sealed
class WriteFileAction extends Action {
  final Uri file;
  final String contents;

  WriteFileAction(this.file, this.contents);

  @override
  String get summary => 'write $file';

  @override
  Future<void> apply(Context ctx) async {
    final target = File.fromUri(ctx.rootPackageFolder.resolveUri(file));
    try {
      ctx.log('# Apply: Writing $file');
      await target.parent.create(recursive: true);
      await target.writeAsString(contents);
    } on IOException catch (e) {
      throw VendorFailure(ExitCode.tempFail, 'Failed to write $file: $e');
    }
  }
}
