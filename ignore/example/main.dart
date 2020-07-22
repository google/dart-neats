// Copyright 2020 Google LLC
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

import 'dart:io' show File, Directory;
import 'package:ignore/ignore.dart';
import 'package:path/path.dart' as p;

void main() async {
  // Look at the current directory, read the .gitignore and print which files
  // are ignored following the patterns in the .gitignore file.
  final dir = Directory.current;

  final ignore = Ignore([
    // Read the .gitignore file from dir
    await File.fromUri(dir.uri.resolve('.gitignore')).readAsString(),
  ]);

  // For each file/directory in dir
  await for (final obj in dir.list(recursive: true, followLinks: false)) {
    // Get the relative path relative to the .gitignore file
    var path = p.relative(obj.path, from: dir.path);

    // If obj is a directory, append '/', so that the filter can see this
    if (obj is Directory) {
      path += '/';
    }

    // Print which files are ignored
    if (ignore.ignores(path)) {
      print('Ignores: $path');
    }
  }
}
