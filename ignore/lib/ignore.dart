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

// This file is ported to Dart from:
//   https://github.com/kaelzhang/node-ignore
// Which is distributed under the following license:
//
// Copyright (c) 2013 Kael Zhang <i@kael.me>, contributors
// http://kael.me/
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

/// Package `ignore` provides an [Ignore] filter compatible with `.gitignore`.
///
/// An [Ignore] instance holds a set of [`.gitignore` rules][1], and allows
/// testing if a given path is ignored.
///
/// **Example**:
/// ```dart
/// import 'package:ignore/ignore.dart';
///
/// void main() {
///   final ignore = Ignore([
///     '*.o',
///   ]);
///
///   print(ignore.ignores('main.o')); // true
///   print(ignore.ignores('main.c')); // false
/// }
/// ```
///
/// [1]: https://git-scm.com/docs/gitignore
library ignore;

import 'dart:async';

import 'package:meta/meta.dart';

final _rangePattern = RegExp(r'([0-z])-([0-z])');
final _lineBreakPattern = RegExp('\r?\n');
final _emptyLinePattern = RegExp(r'^\s*$');
final _nonRelativePathPattern = RegExp(r'^\.*\/|^\.+$');

String _sanitizeRange(String range) => range.replaceAllMapped(
      _rangePattern,
      (m) => m.group(1).codeUnitAt(0) <= m.group(2).codeUnitAt(0)
          ? m.group(0)
          : '',
    );

String _cleanRangeBackSlash(String slashes) =>
    slashes.substring(0, slashes.length - slashes.length % 2);

class _Replacer {
  final RegExp _pattern;
  final String Function(Match) _replace;
  _Replacer(String pattern, this._replace) : _pattern = RegExp(pattern);

  String apply(String input) => input.replaceAllMapped(_pattern, _replace);
}

final _replacers = <_Replacer>[
  _Replacer(r'^\\!', (m) => '!'),
  _Replacer(r'^\\#', (m) => '#'),

  // > Trailing spaces are ignored unless they are quoted with backslash ("\")
  _Replacer(r'\\?\s+$', (m) => m.group(0).startsWith(r'\') ? ' ' : ''),

  // replace (\ ) with ' '
  _Replacer(r'\\\s', (m) => ' '),

  // Escape metacharacters
  _Replacer(r'[\\$.|*+(){^]', (m) => '\\${m.group(0)}'),

  // > a question mark (?) matches a single character
  _Replacer(r'(?!\\)\?', (m) => '[^/]'),

  // leading slash
  _Replacer(r'^\/', (m) => '^'),

  // replace special metacharacter slash after the leading slash
  _Replacer(r'\/', (m) => '\\/'),

  // > A leading "**" followed by a slash means match in all directories.
  _Replacer(r'^\^*\\\*\\\*\\\/', (m) => r'^(?:.*\/)?'),

  // If not already starting ^, check if it contains slash
  _Replacer(r'^(?=[^^])',
      (m) => RegExp(r'\/(?!$)').hasMatch(m.input) ? '^' : r'(?:^|\/)'),

  // two globstars
  _Replacer(r'\\\/\\\*\\\*(?=\\\/|$)',
      (m) => m.start + 6 < m.input.length ? '(?:\\/[^\\/]+)*' : '\\/.+'),

  // intermediate wildcards
  _Replacer(r'(^|[^\\]+)\\\*(?=.+)', (m) => '${m.group(1)}[^\\/]*'),

  // unescape, revert step 3 except for back slash
  _Replacer(r'\\\\\\(?=[$.|*+(){^])', (m) => r'\'),

  // '\\\\' -> '\\'
  _Replacer(r'\\\\', (m) => r'\'),

  // > The range notation, e.g. [a-zA-Z],
  // > can be used to match one of the characters in a range.
  _Replacer(r'(\\)?\[([^\]/]*?)(\\*)($|\])', (m) {
    final leadEscape = m.group(1);
    final range = m.group(2);
    final endEscape = m.group(3);
    final close = m.group(4);
    return leadEscape == r'\'
        ? '\\[${range}${_cleanRangeBackSlash(endEscape)}${close}'
        : close == ']'
            ? endEscape.length % 2 == 0
                // A normal case, and it is a range notation
                ? '[${_sanitizeRange(range)}${endEscape}]'
                // Invalid range notaton
                : '[]'
            : '[]';
  }),

  // > If there is a separator at the end of the pattern then the pattern
  // > will only match directories, otherwise the pattern can match both
  // > files and directories.
  _Replacer(
    r'(?:[^*])$',
    (m) => RegExp(r'\/$').hasMatch(m.group(0))
        ? '${m.group(0)}\$'
        : '${m.group(0)}(?=\$|\\/\$)',
  ),

  // trailing wildcard
  _Replacer(
    r'(\^|\\\/)?\\\*$',
    (m) => m.group(1) != null
        ? '${m.group(1)}[^/]+(?=\$|\\/\$)'
        : '[^/]*(?=\$|\\/\$)',
  ),
];

class _IgnoreRule {
  final RegExp pattern;
  final bool negative;
  _IgnoreRule(this.pattern, this.negative);
}

/// A set of ignore rules.
///
/// An [Ignore] instance holds a set of [`.gitignore` rules][1], and allows
/// testing if a given path is ignored.
///
/// **Example**:
/// ```dart
/// import 'package:ignore/ignore.dart';
///
/// void main() {
///   final ignore = Ignore([
///     '*.o',
///   ]);
///
///   print(ignore.ignores('main.o')); // true
///   print(ignore.ignores('main.c')); // false
/// }
/// ```
///
/// [1]: https://git-scm.com/docs/gitignore
@sealed
class Ignore {
  final bool _ignoreCase;
  final List<_IgnoreRule> _rules = [];

  /// Create an [Ignore] instance with a set of [`.gitignore` compatible][1]
  /// patterns.
  ///
  /// Each pattern in [patterns] will be interpreted as one or more lines from
  /// a `.gitignore` file, in compliance with the [`.gitignore` manual page][1].
  ///
  /// If [ignoreCase] is `true`, patterns will be case-insensitive. By default
  /// `git` is case-sensitive. But case insensitive can be enabled when a
  /// repository is created, or by configuration option, see
  /// [`core.ignoreCase` documentation][2] for details.
  ///
  /// **Example**:
  /// ```dart
  /// import 'package:ignore/ignore.dart';
  /// void main() {
  ///   final ignore = Ignore([
  ///     // You can pass an entire .gitignore file as a single string.
  ///     // You can also pass it as a list of lines, or both.
  ///     '''
  /// # Comment in a .gitignore file
  /// obj/
  /// *.o
  /// !main.o
  ///   '''
  ///   ]);
  ///
  ///   print(ignore.ignores('obj/README.md')); // true
  ///   print(ignore.ignores('lib.o')); // false
  ///   print(ignore.ignores('main.o')); // false
  /// }
  /// ```
  ///
  /// [1]: https://git-scm.com/docs/gitignore
  /// [2]: https://git-scm.com/docs/git-config#Documentation/git-config.txt-coreignoreCase
  Ignore(Iterable<String> patterns, {bool ignoreCase = false})
      : _ignoreCase = ignoreCase {
    ArgumentError.checkNotNull(patterns, 'patterns');
    ArgumentError.checkNotNull(ignoreCase, 'ignoreCase');

    for (final pattern in patterns) {
      if (pattern == null) {
        throw ArgumentError.value(patterns, 'patterns', 'may not contain null');
      }

      pattern.split(_lineBreakPattern).forEach(_add);
    }
  }

  void _add(String pattern) {
    // Ignore empty lines and comments
    if (_emptyLinePattern.hasMatch(pattern) || pattern.startsWith('#')) {
      return;
    }

    final negative = pattern.startsWith('!');
    if (negative) {
      pattern = pattern.substring(1);
    }

    for (final r in _replacers) {
      pattern = r.apply(pattern);
    }

    _rules.add(_IgnoreRule(
      RegExp(pattern, caseSensitive: _ignoreCase),
      negative,
    ));
  }

  /// Returns `true` if [path] is ignored by the patterns used to create this
  /// [Ignore] instance.
  ///
  /// The [path] must be a relative path, not starting with `./`, `../`, and
  /// must end in slash (`/`) if it is directory.
  ///
  /// **Example**:
  /// ```dart
  /// import 'package:ignore/ignore.dart';
  ///
  /// void main() {
  ///   final ignore = Ignore([
  ///     '*.o',
  ///   ]);
  ///
  ///   print(ignore.ignores('main.o')); // true
  ///   print(ignore.ignores('main.c')); // false
  ///   print(ignore.ignores('lib/')); // false
  ///   print(ignore.ignores('lib/helper.o')); // true
  ///   print(ignore.ignores('lib/helper.c')); // false
  /// }
  /// ```
  bool ignores(String path) => _ignores(path, {});

  /// Removes entries from [paths] that are ignored the patterns used to create
  /// this [Ignore] instance.
  ///
  /// The [path] must be a relative path, not starting with `./`, `../`, and
  /// must end in slash (`/`) if it is directory.
  ///
  /// **Example**:
  /// ```dart
  /// import 'package:ignore/ignore.dart';
  ///
  /// void main() {
  ///   final ignore = Ignore([
  ///     '*.o',
  ///   ]);
  ///
  ///   print(ignore.filter([
  ///     'main.o',
  ///     'main.c',
  ///     'lib/',
  ///     'lib/helper.o',
  ///     'lib/helper.c',
  ///   ])); // main.c lib/ helper.c
  /// }
  /// ```
  ///
  /// This method is semantically equivalent to `paths.where(ignore.ignores)`,
  /// however, intermediate results for paths is reused which may improve
  /// performance.
  Iterable<String> filter(Iterable<String> paths) {
    ArgumentError.checkNotNull(paths, 'paths');

    final cache = <String, bool>{};
    return paths.where((p) => !_ignores(p, cache));
  }

  /// Removes entries from [paths] that are ignored the patterns used to create
  /// this [Ignore] instance.
  ///
  /// The [path] must be a relative path, not starting with `./`, `../`, and
  /// must end in slash (`/`) if it is directory.
  ///
  /// **Example**:
  /// ```dart
  /// import 'dart:io' show File, Directory;
  /// import 'package:ignore/ignore.dart';
  /// import 'package:path/path.dart' as p;
  ///
  /// void main() async {
  ///   final ignore = Ignore([
  ///     // Read the .gitignore file from dir
  ///     await File('.gitignore').readAsString(),
  ///   ]);
  ///
  ///   // For each file/directory in current directory, make the path relative,
  ///   // and, append '/' for directories.
  ///   final Stream<String> filesAsStream =
  ///       Directory.current.list(recursive: true).map((obj) =>
  ///           p.relative(obj.path, from: Directory.current.path) +
  ///           // Append '/' if object is a directory
  ///           (obj is Directory ? '/' : ''));
  ///
  ///   // Print files/directories not ignored
  ///   await for (final path in ignore.filterAsync(filesAsStream)) {
  ///     print('Not ignored: $path');
  ///   }
  /// }
  /// ```
  ///
  /// This method is semantically equivalent to `paths.where(ignore.ignores)`,
  /// however, intermediate results for paths is reused which may improve
  /// performance.
  Stream<String> filterAsync(Stream<String> paths) {
    ArgumentError.checkNotNull(paths, 'paths');

    final cache = <String, bool>{};
    return paths.where((p) => !_ignores(p, cache));
  }

  bool _ignores(String path, Map<String, bool> cache) {
    ArgumentError.checkNotNull(path, 'path');
    if (path.isEmpty) {
      throw ArgumentError.value(path, 'path', 'must be not empty');
    }
    if (_nonRelativePathPattern.hasMatch(path)) {
      throw ArgumentError.value(
          path, 'path', 'must be relative, and not start with "."');
    }

    return _testPath(path, cache, path.split('/'));
  }

  bool _testPath(
    String path,
    Map<String, bool> cache,
    List<String> slices,
  ) {
    return cache.putIfAbsent(path, () {
      slices.removeLast();

      if (slices.isEmpty) {
        return _testPathSlice(path);
      }

      final parent = _testPath(slices.join('/') + '/', cache, slices);
      return parent || _testPathSlice(path);
    });
  }

  bool _testPathSlice(String path) {
    var ignored = false;
    var unignored = false;

    for (final r in _rules) {
      if (unignored == r.negative && ignored != unignored ||
          r.negative && !ignored && !unignored) {
        continue;
      }

      if (r.pattern.hasMatch(path)) {
        ignored = !r.negative;
        unignored = r.negative;
      }
    }

    return ignored;
  }
}
