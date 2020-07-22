.gitignore filter for dart
==========================

A `.gitignore` compatible file-path filter. Useful for checking if a file or
directory would be ignored by a given `.gitignore` file.

**Disclaimer:** This is not an officially supported Google product.

The ignore patterns used in `.gitignore` files are specified in the
[`.gitignore` manual page][1], and widely understood by the community.
Thus, it is attractive to use the same patterns for other `.XXXignore` files.
This package provides the facilities to parse and check if a file-path is
ignored by a set of patterns.

## Examples

Patterns can be given as a list of lines and paths can be check individually,
as illustrated below.

```dart
void main() {
  final ignore = Ignore([
    '*.o',
    '/.dart_tool/',
    '/.packages',
  ]);

  // Paths given must be relative to the location of the .gitignore file
  print(ignore.ignores('main.o')); // true
  print(ignore.ignores('main.c')); // false
  print(ignore.ignores('.dart_tool/')); // true
  print(ignore.ignores('.packages')); // true
  print(ignore.ignores('lib/app.dart')); // false
}
```

It is also possible to pass an entire multi-line `.gitignore` file with comments
and empty lines. Similarly, the `Ignore.filter` method can be used to easily
remove paths from a list of paths.

```dart
import 'dart:io' show File, Directory;
import 'package:ignore/ignore.dart';
import 'package:path/path.dart' as p;

void main() async {
  final ignore = Ignore([
    // Read the .gitignore file from dir
    await File('.gitignore').readAsString(),
  ]);

  // For each file/directory in current directory, make the path relative, and
  // append '/' for directories.
  final files = await Directory.current
      .list(recursive: true, followLinks: false)
      .map(
        (obj) =>
            p.relative(obj.path, from: Directory.current.path) +
            // Append '/' if object is a directory
            (obj is Directory ? '/' : ''),
      )
      .toList();

  // Print files/directories not ignored
  for (final path in ignore.filter(files)) {
    print('Not ignored: $path');
  }
}
```

## Credits
This package is largely a Dart port of the [node-ignore][2] package for
Javascript.

[1]: https://git-scm.com/docs/gitignore
[2]: https://github.com/kaelzhang/node-ignore
