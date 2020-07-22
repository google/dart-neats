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

// This file includes test cases from:
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

import 'package:test/test.dart';
import 'package:ignore/ignore.dart';

void main() {
  test('simple case', () {
    final ig = Ignore([
      'test.dart',
      '*.o',
      '/.git',
      '/.dart_tool/',
    ]);

    // Ignores
    expect(ig.ignores('.dart_tool/'), isTrue);
    expect(ig.ignores('.dart_tool/myfile.txt'), isTrue);
    expect(ig.ignores('.git/'), isTrue);
    expect(ig.ignores('myfile.o'), isTrue);
    expect(ig.ignores('out/myfile.o'), isTrue);

    // Accepts
    expect(ig.ignores('out/myfile.c'), isFalse);
    expect(ig.ignores('cheese.dart'), isFalse);
    expect(ig.ignores('subfolder/.dart_tool/'), isFalse);
    expect(ig.ignores('subfolder/.dart_tool/myfile.dart'), isFalse);
  });

  for (final c in _cases) {
    final patterns = c[1] as List<String>;
    final paths = c[2] as Map<String, bool>;
    for (final path in paths.keys) {
      final result = paths[path];
      test('${c[0]} - ignores("$path") == $result', () {
        final ignore = Ignore(patterns);

        if (result) {
          expect(
            ignore.ignores(path),
            isTrue,
            reason: 'Expected "$path" to be ignored',
          );
        } else {
          expect(
            ignore.ignores(path),
            isFalse,
            reason: 'Expected "$path" to not be ignored',
          );
        }
      });
    }
  }
}

final _cases = [
  // [
  //   '<name>',
  //   [
  //     '<rule>',
  //     ...,
  //   ],
  //   {
  //     '<path>': true | false, // true, if <path> is ignored
  //     ...,
  //   }
  // ],
  [
    'Sanity check',
    [
      '/.git/',
      '.dart_tool/',
    ],
    {
      '.git': false,
      '.git/': true,
      'subfolder/.git': false,
      'subfolder/.git/': false,
      '.dart_tool': false,
      '.dart_tool/': true,
      'subfolder/.dart_tool': false,
      'subfolder/.dart_tool/': true,
    }
  ],
  [
    'negate ignores',
    [
      '*.o',
      '!binary*.o',
      'binary-intermediate-*.o',
    ],
    {
      'test.o': true,
      'binary.o': false,
      'binary-intermediate-.o': true,
      'binary-intermediate-test.o': true,
      'binary-other.o': false,
    }
  ],
  [
    '#59 and more cases about range notation',
    [
      'src/\\[foo\\]', // 1 -> 0

      'src/\\[bar]',

      'src/[e\\\\]',
      's/[f\\\\\\\\]',

      's/[a-z0-9]',

      // The following special cases are not described in gitignore manual
      'src/[q',
      'src/\\[u',
      'src/[x\\]',
    ],
    {
      'src/[foo]': true,
      'src/[bar]': true,
      'src/e': true,
      's/f': true,
      's/a': true,
      's/0': true,
      'src/[q': false,
      'src/[u': true,
      'src/[x': false,
      'src/[x]': false,
      'src/x': false,
    }
  ],
  [
    'gitignore 2.22.1 example',
    [
      'doc/frotz/',
    ],
    {
      'doc/frotz/': true,
      'a/doc/frotz/': false,
    }
  ],
  [
    '#56',
    [
      '/*/',
      '!/foo/',
    ],
    {
      'foo/bar.js': false,
    }
  ],
  [
    'object prototype',
    [
      '*',
      '!hasOwnProperty',
      '!a',
    ],
    {
      'hasOwnProperty': false,
      'a/hasOwnProperty': false,
      'toString': true,
      'a/toString': true,
    }
  ],
  [
    'a and a/',
    [
      'a',
      'a2',
      'b/',
      'b2/',
    ],
    {
      'a': true,
      'a2/': true,
      'b': false,
      'b2/': true,
    }
  ],
  [
    'ending question mark',
    [
      '*.web?',
    ],
    {
      'a.webp': true,
      'a.webm': true,
      // only match one characters
      'a.webam': false,
      'a.png': false,
    }
  ],
  [
    'intermediate question mark',
    [
      'a?c',
    ],
    {
      'abc': true,
      'acc': true,
      'ac': false,
      'abbc': false,
    }
  ],
  [
    'multiple question marks',
    [
      'a?b??',
    ],
    {
      'acbdd': true,
      'acbddd': false,
    }
  ],
  [
    'normal *.[oa]',
    [
      '*.[oa]',
    ],
    {
      'a.js': false,
      'a.a': true,
      // test ending
      'a.aa': false,
      'a.o': true,
      'a.0': false,
    }
  ],
  [
    'multiple brackets',
    [
      '*.[ab][cd][ef]',
    ],
    {
      'a.ace': true,
      'a.bdf': true,
      'a.bce': true,
      'a.abc': false,
      'a.aceg': false,
    }
  ],
  [
    'special case: []',
    [
      '*.[]',
    ],
    {
      'a.[]': false,
      'a.[]a': false,
    }
  ],
  [
    'mixed with numbers, characters and symbols: *.[0a_]',
    [
      '*.[0a_]',
    ],
    {
      'a.0': true,
      'a.1': false,
      'a.a': true,
      'a.b': false,
      'a._': true,
      'a.=': false,
    }
  ],
  [
    'range: [a-z]',
    [
      '*.pn[a-z]',
    ],
    {
      'a.pn1': false,
      'a.pn2': false,
      'a.png': true,
      'a.pna': true,
    }
  ],
  [
    'range: [0-9]',
    [
      '*.pn[0-9]',
    ],
    {
      'a.pn1': true,
      'a.pn2': true,
      'a.png': false,
      'a.pna': false,
    }
  ],
  [
    'multiple ranges: [0-9a-z]',
    [
      '*.pn[0-9a-z]',
    ],
    {
      'a.pn1': true,
      'a.pn2': true,
      'a.png': true,
      'a.pna': true,
      'a.pn-': false,
    }
  ],
  [
    // [0-z] represents 0-0A-Za-z
    'special range: [0-z]',
    [
      '*.[0-z]',
    ],
    {
      'a.0': true,
      'a.9': true,
      'a.00': false,
      'a.a': true,
      'a.z': true,
      'a.zz': false,
    }
  ],
  [
    // If range is out of order, then omitted
    'special case: range out of order: [a-9]',
    [
      '*.[a-9]',
    ],
    {
      'a.0': false,
      'a.-': false,
      'a.9': false,
    }
  ],
  [
    // Just treat it as normal character set
    'special case: range-like character set',
    [
      '*.[a-]',
    ],
    {
      'a.a': true,
      'a.-': true,
      'a.b': false,
    }
  ],
  [
    'special case: the combination of range and set',
    [
      '*.[a-z01]',
    ],
    {
      'a.a': true,
      'a.b': true,
      'a.z': true,
      'a.0': true,
      'a.1': true,
      'a.2': false,
    }
  ],
  [
    'special case: 1 step range',
    [
      '*.[0-0]',
    ],
    {
      'a.0': true,
      'a.1': false,
      'a.-': false,
    }
  ],
  [
    'special case: similar, but not a character set',
    [
      '*.[a-',
    ],
    {
      'a.': false,
      'a.[': false,
      'a.a': false,
      'a.-': false,
    }
  ],
  [
    'related to #38',
    [
      '*',
      '!abc*',
    ],
    {
      'a': true,
      'abc': false,
      'abcd': false,
    }
  ],
  [
    '#38',
    [
      '*',
      '!*/',
      '!foo/bar',
    ],
    {
      'a': true,
      'b/c': true,
      'foo/bar': false,
      'foo/e': true,
    }
  ],
  [
    'intermediate "\\ " should be unescaped to " "',
    [
      'abc\\ d',
      'abc e',
      'a\\ b\\ c',
    ],
    {
      'abc d': true,
      'abc e': true,
      'abc/abc d': true,
      'abc/abc e': true,
      'abc/a b c': true,
    }
  ],
  [
    '#25',
    [
      '.git/*',
      '!.git/config',
      '.ftpconfig',
    ],
    {
      '.ftpconfig': true,
      '.git/config': false,
      '.git/description': true,
    }
  ],
  [
    '#26: .gitignore man page sample',
    [
      '# exclude everything except directory foo/bar',
      '/*',
      '!/foo',
      '/foo/*',
      '!/foo/bar',
    ],
    {
      'no.js': true,
      'foo/no.js': true,
      'foo/bar/yes.js': false,
      'foo/bar/baz/yes.js': false,
      'boo/no.js': true,
    }
  ],
  [
    'wildcard: special case, escaped wildcard',
    [
      '*.html',
      '!a/b/\\*/index.html',
    ],
    {
      'a/b/*/index.html': false,
      'a/b/index.html': true,
    }
  ],
  [
    'wildcard: treated as a shell glob suitable for consumption by fnmatch(3)',
    [
      '*.html',
      '!b/\\*/index.html',
    ],
    {
      'a/b/*/index.html': true,
      'a/b/index.html': true,
    }
  ],
  [
    'wildcard: with no escape',
    [
      '*.html',
      '!a/b/*/index.html',
    ],
    {
      'a/b/*/index.html': false,
      'a/b/index.html': true,
    }
  ],
  [
    '#24: a negative pattern without a trailing wildcard',
    [
      '/node_modules/*',
      '!/node_modules',
      '!/node_modules/package',
    ],
    {
      'node_modules/a/a.js': true,
      'node_modules/package/a.js': false,
    }
  ],
  [
    '#21: unignore with 1 globstar, reversed order',
    [
      '!foo/bar.js',
      'foo/*',
    ],
    {
      'foo/bar.js': true,
      'foo/bar2.js': true,
      'foo/bar/bar.js': true,
    }
  ],

  [
    '#21: unignore with 2 globstars, reversed order',
    [
      '!foo/bar.js',
      'foo/**',
    ],
    {
      'foo/bar.js': true,
      'foo/bar2.js': true,
      'foo/bar/bar.js': true,
    }
  ],

  [
    '#21: unignore with several groups of 2 globstars, reversed order',
    [
      '!foo/bar.js',
      'foo/**/**',
    ],
    {
      'foo/bar.js': true,
      'foo/bar2.js': true,
      'foo/bar/bar.js': true,
    }
  ],

  [
    '#21: unignore with 1 globstar',
    [
      'foo/*',
      '!foo/bar.js',
    ],
    {
      'foo/bar.js': false,
      'foo/bar2.js': true,
      'foo/bar/bar.js': true,
    }
  ],

  [
    '#21: unignore with 2 globstars',
    [
      'foo/**',
      '!foo/bar.js',
    ],
    {
      'foo/bar.js': false,
      'foo/bar2.js': true,
      'foo/bar/bar.js': true,
    }
  ],

  [
    'related to #21: several groups of 2 globstars',
    [
      'foo/**/**',
      '!foo/bar.js',
    ],
    {
      'foo/bar.js': false,
      'foo/bar2.js': true,
      'foo/bar/bar.js': true,
    }
  ],

  // description  patterns  paths/expect  only
  [
    'ignore dot files',
    [
      '.*',
    ],
    {
      '.a': true,
      '.gitignore': true,
    }
  ],

  [
    '#14, README example broken in `3.0.3`',
    [
      '.abc/*',
      '!.abc/d/',
    ],
    {
      '.abc/a.js': true,
      '.abc/d/e.js': false,
    }
  ],

  [
    '#14, README example broken in `3.0.3`, not negate parent folder',
    [
      '.abc/*',
      // .abc/d will be ignored
      '!.abc/d/*'
    ],
    {
      '.abc/a.js': true,
      // so '.abc/d/e.js' will be ignored
      '.abc/d/e.js': true,
    }
  ],

  [
    'A blank line matches no files',
    [
      '',
    ],
    {
      'a': false,
      'a/b/c': false,
    }
  ],
  [
    'A line starting with # serves as a comment.',
    [
      '#abc',
    ],
    {
      '#abc': false,
    }
  ],
  [
    'Put a backslash ("\\") in front of the first hash for patterns that begin with a hash.',
    [
      '\\#abc',
    ],
    {
      '#abc': true,
    }
  ],
  [
    'An optional prefix "!" which negates the pattern; any matching file excluded by a previous pattern will become included again',
    [
      'abc',
      '!abc',
    ],
    {
      // the parent folder is included again
      'abc/a.js': false,
      'abc/': false,
    }
  ],
  [
    'issue #10: It is not possible to re-include a file if a parent directory of that file is excluded',
    [
      '/abc/',
      '!/abc/a.js',
    ],
    {
      'abc/a.js': true,
      'abc/d/e.js': true,
    }
  ],
  [
    'we did not know whether the rule is a dir first',
    [
      'abc',
      '!bcd/abc/a.js',
    ],
    {
      'abc/a.js': true,
      'bcd/abc/a.js': true,
    }
  ],
  [
    'Put a backslash ("\\") in front of the first "!" for patterns that begin with a literal "!"',
    [
      '\\!abc',
      '\\!important!.txt',
    ],
    {
      '!abc': true,
      'abc': false,
      'b/!important!.txt': true,
      '!important!.txt': true,
    }
  ],

  [
    'If the pattern ends with a slash, it is removed for the purpose of the following description, but it would only find a match with a directory',
    [
      'abc/',
    ],
    {
      // actually, node-ignore have no idea about fs.Stat,
      // you should `glob({mark: true})`
      'abc': false,
      'abc/': true,

      // Actually, if there is only a trailing slash, git also treats it as a shell glob pattern
      // 'abc/' should make 'bcd/abc/' ignored.
      'bcd/abc/': true,
    }
  ],

  [
    'If the pattern does not contain a slash /, Git treats it as a shell glob pattern',
    [
      'a.js',
      'f/',
    ],
    {
      'a.js': true,
      'b/a/a.js': true,
      'a/a.js': true,
      'b/a.jsa': false,
      'f/': true,
      'g/f/': true,
    }
  ],
  [
    'Otherwise, Git treats the pattern as a shell glob suitable for consumption by fnmatch(3) with the FNM_PATHNAME flag',
    [
      'a/a.js',
    ],
    {
      'a/a.js': true,
      'a/a.jsa': false,
      'b/a/a.js': false,
      'c/a/a.js': false,
    }
  ],

  [
    'wildcards in the pattern will not match a / in the pathname.',
    [
      'Documentation/*.html',
    ],
    {
      'Documentation/git.html': true,
      'Documentation/ppc/ppc.html': false,
      'tools/perf/Documentation/perf.html': false,
    }
  ],

  [
    'A leading slash matches the beginning of the pathname',
    [
      '/*.c',
    ],
    {
      'cat-file.c': true,
      'mozilla-sha1/sha1.c': false,
    }
  ],

  [
    'A leading "**" followed by a slash means match in all directories',
    [
      '**/foo',
    ],
    {
      'foo': true,
      'a/foo': true,
      'foo/a': true,
      'a/foo/a': true,
      'a/b/c/foo/a': true,
    }
  ],

  [
    '"**/foo/bar" matches file or directory "bar" anywhere that is directly under directory "foo"',
    [
      '**/foo/bar',
    ],
    {
      'foo/bar': true,
      'abc/foo/bar': true,
      'abc/foo/bar/': true,
    }
  ],

  [
    'A trailing "/**" matches everything inside',
    [
      'abc/**',
    ],
    {
      'abc/a/': true,
      'abc/b': true,
      'abc/d/e/f/g': true,
      'bcd/abc/a': false,
      'abc': false,
    }
  ],

  [
    'A slash followed by two consecutive asterisks then a slash matches zero or more directories',
    [
      'a/**/b',
    ],
    {
      'a/b': true,
      'a/x/b': true,
      'a/x/y/b': true,
      'b/a/b': false,
    }
  ],

  [
    'add a file content',
    [
      r'abc',
      r'!abc/b',
      r'#e',
      r'\#f',
    ],
    {
      'abc/a.js': true,
      'abc/b/b.js': true,
      '#e': false,
      '#f': true,
    }
  ],

  // old test cases
  [
    'should excape metacharacters of regular expressions',
    [
      '*.js',
      '!\\*.js',
      '!a#b.js',
      '!?.js',

      // comments
      '#abc',

      '\\#abc',
    ],
    {
      '*.js': false,
      'abc.js': true,
      'a#b.js': false,
      'abc': false,
      '#abc': true,
      '?.js': false,
    }
  ],

  [
    'issue #2: question mark should not break all things',
    [
      '# git-ls-files --others --exclude-from=.git/info/exclude',
      '# Lines that start with \'#\' are comments.',
      '# For a project mostly in C, the following would be a good set of',
      '# exclude patterns (uncomment them if you want to use them):',
      '# *.[oa]',
      '# *~',
      '/.project',
      '# The same type as `\'/.project\'`',
      '# /.settings',
      '/sharedTools/external/*',
      'thumbs.db',
      '/packs',
      '*.pyc',
      '# /.cache',
      '# /bigtxt',
      '.metadata/*',
      '*~',
      '/sharedTools/jsApiLua.lua',
      '._*',
      '.DS_Store',
      '# /DISABLED',
      '# /.pydevproject',
      '# /testbox',
      '*.swp',
      '/packs/packagesTree',
      '/packs/*.ini',
      '# .buildpath',
      '# The same type as `\'/sharedTools/external/*\'`',
      '# /resources/hooks/*',
      '# .idea',
      '.idea/*',
      '# /tags',
      '**.iml',
      '.sonar/*',
      '.*.sw?',
    ],
    {
      '.project': true,
      // remain
      'abc/.project': false,
      '.a.sw': false,
      '.a.sw?': true,
      'thumbs.db': true,
    }
  ],
  [
    'dir ended with "*"',
    [
      'abc/*',
    ],
    {
      'abc': false,
    }
  ],
  [
    'file ended with "*"',
    [
      'abc.js*',
    ],
    {
      'abc.js/': true,
      'abc.js/abc': true,
      'abc.jsa/': true,
      'abc.jsa/abc': true,
    }
  ],
  [
    'wildcard as filename',
    [
      '*.b',
    ],
    {
      'b/a.b': true,
      'b/.b': true,
      'b/.ba': false,
      'b/c/a.b': true,
    }
  ],
  [
    'slash at the beginning and come with a wildcard',
    [
      '/*.c',
    ],
    {
      '.c': true,
      'c.c': true,
      'c/c.c': false,
      'c/d': false,
    }
  ],
  [
    'dot file',
    [
      '.d',
    ],
    {
      '.d': true,
      '.dd': false,
      'd.d': false,
      'd/.d': true,
      'd/d.d': false,
      'd/e': false,
    }
  ],
  [
    'dot dir',
    [
      '.e',
    ],
    {
      '.e/': true,
      '.ee/': false,
      'e.e/': false,
      '.e/e': true,
      'e/.e': true,
      'e/e.e': false,
      'e/f': false,
    }
  ],
  [
    'node modules: once',
    [
      'node_modules/',
    ],
    {
      'node_modules/gulp/node_modules/abc.md': true,
      'node_modules/gulp/node_modules/abc.json': true,
    }
  ],
  [
    'node modules: sub directories',
    [
      'node_modules',
    ],
    {
      'a/b/node_modules/abc.md': true,
    }
  ],
  [
    'node modules: twice',
    [
      'node_modules/',
      'node_modules/',
    ],
    {
      'node_modules/gulp/node_modules/abc.md': true,
      'node_modules/gulp/node_modules/abc.json': true,
    }
  ],
  [
    'escaped #',
    [
      '\\#my-file.txt',
    ],
    {
      '#my-file.txt': true,
      'my-file.txt': false,
    }
  ],
  [
    'escaped !',
    [
      '\\!my-file.txt',
    ],
    {
      '!my-file.txt': true,
      'my-file.txt': false,
    }
  ]
];
