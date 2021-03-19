Gitignore rule parser and validator
===================================

Implements an [Ignore] filter compatible with `.gitignore`.
An [Ignore] instance holds a set of [`.gitignore` rules][1], and allows
testing if a given path is ignored.
**Example**:
```dart
import 'package:ignore/ignore.dart';
void main() {
  final ignore = Ignore([
    '*.o',
  ]);
  print(ignore.ignores('main.o')); // true
  print(ignore.ignores('main.c')); // false
}
```
For a generic walk of a file-hierarchy with ignore files at all levels see the
example.

[1]: https://git-scm.com/docs/gitignore
