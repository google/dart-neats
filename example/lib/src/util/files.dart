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

import 'dart:io';

import 'package:collection/collection.dart';
import 'package:path/path.dart' as p;

/// Every `.md` file under [root] (skipping hidden directories and `build/`),
/// in a stable order.
List<String> markdownFiles(String root) => Directory(root)
    .listSync(recursive: true, followLinks: false)
    .whereType<File>()
    .map((file) => file.path)
    .where((path) =>
        path.toLowerCase().endsWith('.md') &&
        !_inIgnoredDirectory(p.relative(path, from: root)))
    .sorted();

bool _inIgnoredDirectory(String relativePath) {
  final parts = p.split(relativePath);
  return parts
      .take(parts.length - 1)
      .any((dir) => dir.startsWith('.') || dir == 'build');
}

/// The nearest enclosing directory of [path] containing a `pubspec.yaml`, or
/// `null` if none exists.
String? packageRootOf(String path) {
  var dir = Directory(p.normalize(p.absolute(p.dirname(path))));
  while (true) {
    if (File(p.join(dir.path, 'pubspec.yaml')).existsSync()) {
      return dir.path;
    }
    final parent = dir.parent;
    if (parent.path == dir.path) return null;
    dir = parent;
  }
}
