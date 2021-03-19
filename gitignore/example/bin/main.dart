// Copyright 2021 Google LLC
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

import 'package:path/path.dart' as p;
import 'package:gitignore/gitignore.dart';

void main(List<String> args) async {
  var root = p.current;
  while (!Directory(p.join(root, '.git')).existsSync()) {
    final next = p.dirname(root);
    if (next == root) {
      print('Could not find a .git folder. Are you inside a git repo?');
      exit(-1);
    }
    root = next;
  }

  String beneath = p.relative(p.current, from: root);

  String resolve(String path) {
    if (Platform.isWindows) {
      return p.joinAll([root, ...p.posix.split(path)]);
    }
    return p.absolute(root, path);
  }

  for (final file in Ignore.listFiles(
    beneath: beneath,
    listDir: (dir) {
      var contents = Directory(resolve(dir)).listSync();
      return contents.map((entity) {
        final relative = p.relative(entity.path, from: root);
        if (Platform.isWindows) {
          return p.posix.joinAll(p.split(relative));
        }
        return relative;
      });
    },
    ignoreForDir: (dir) {
      final gitIgnore = resolve('$dir/.gitignore');
      if (!File(gitIgnore).existsSync()) return null;
      return Ignore(
        [File(gitIgnore).readAsStringSync()],
        onInvalidPattern: (pattern, exception) {
          print(
              '$gitIgnore had invalid pattern $pattern. ${exception.message}');
        },
      );
    },
    isDir: (dir) => Directory(resolve(dir)).existsSync(),
  ).map(resolve).toList()) {
    print(file);
  }
}
