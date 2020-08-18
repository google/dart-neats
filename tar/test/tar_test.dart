// Copyright 2020
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
import 'dart:isolate';

import 'package:tar/src/constants.dart';
import 'package:tar/src/sparse_entry.dart';
import 'package:tar/src/utils.dart';
import 'package:test/test.dart';

void main() {
  group('sparse entries', () {
    final tests = [
      {
        'input': <SparseEntry>[],
        'size': 0,
        'wantValid': true,
        'wantAligned': <SparseEntry>[],
        'wantInverted': [SparseEntry(0, 0)],
      },
      {
        'input': <SparseEntry>[],
        'size': 5000,
        'wantValid': true,
        'wantAligned': <SparseEntry>[],
        'wantInverted': [SparseEntry(0, 5000)],
      },
      {
        'input': [SparseEntry(0, 5000)],
        'size': 5000,
        'wantValid': true,
        'wantAligned': [SparseEntry(0, 5000)],
        'wantInverted': [SparseEntry(5000, 0)],
      },
      {
        'input': [SparseEntry(1000, 4000)],
        'size': 5000,
        'wantValid': true,
        'wantAligned': [SparseEntry(1024, 3976)],
        'wantInverted': [SparseEntry(0, 1000), SparseEntry(5000, 0)],
      },
      {
        'input': [SparseEntry(0, 3000)],
        'size': 5000,
        'wantValid': true,
        'wantAligned': [SparseEntry(0, 2560)],
        'wantInverted': [SparseEntry(3000, 2000)],
      },
      {
        'input': [SparseEntry(3000, 2000)],
        'size': 5000,
        'wantValid': true,
        'wantAligned': [SparseEntry(3072, 1928)],
        'wantInverted': [SparseEntry(0, 3000), SparseEntry(5000, 0)],
      },
      {
        'input': [SparseEntry(2000, 2000)],
        'size': 5000,
        'wantValid': true,
        'wantAligned': [SparseEntry(2048, 1536)],
        'wantInverted': [SparseEntry(0, 2000), SparseEntry(4000, 1000)],
      },
      {
        'input': [SparseEntry(0, 2000), SparseEntry(8000, 2000)],
        'size': 10000,
        'wantValid': true,
        'wantAligned': [SparseEntry(0, 1536), SparseEntry(8192, 1808)],
        'wantInverted': [SparseEntry(2000, 6000), SparseEntry(10000, 0)],
      },
      {
        'input': [
          SparseEntry(0, 2000),
          SparseEntry(2000, 2000),
          SparseEntry(4000, 0),
          SparseEntry(4000, 3000),
          SparseEntry(7000, 1000),
          SparseEntry(8000, 0),
          SparseEntry(8000, 2000)
        ],
        'size': 10000,
        'wantValid': true,
        'wantAligned': [
          SparseEntry(0, 1536),
          SparseEntry(2048, 1536),
          SparseEntry(4096, 2560),
          SparseEntry(7168, 512),
          SparseEntry(8192, 1808)
        ],
        'wantInverted': [SparseEntry(10000, 0)],
      },
      {
        'input': [
          SparseEntry(0, 0),
          SparseEntry(1000, 0),
          SparseEntry(2000, 0),
          SparseEntry(3000, 0),
          SparseEntry(4000, 0),
          SparseEntry(5000, 0)
        ],
        'size': 5000,
        'wantValid': true,
        'wantAligned': [],
        'wantInverted': [SparseEntry(0, 5000)],
      },
      {
        'input': [SparseEntry(1, 0)],
        'size': 0,
        'wantValid': false,
      },
      {
        'input': [SparseEntry(-1, 0)],
        'size': 100,
        'wantValid': false,
      },
      {
        'input': [SparseEntry(0, -1)],
        'size': 100,
        'wantValid': false,
      },
      {
        'input': [SparseEntry(0, 0)],
        'size': -100,
        'wantValid': false,
      },
      {
        'input': [SparseEntry(int64MaxValue, 3), SparseEntry(6, -5)],
        'size': 35,
        'wantValid': false,
      },
      {
        'input': [SparseEntry(1, 3), SparseEntry(6, -5)],
        'size': 35,
        'wantValid': false,
      },
      {
        'input': [SparseEntry(int64MaxValue, int64MaxValue)],
        'size': int64MaxValue,
        'wantValid': false,
      },
      {
        'input': [SparseEntry(3, 3)],
        'size': 5,
        'wantValid': false,
      },
      {
        'input': [SparseEntry(2, 0), SparseEntry(1, 0), SparseEntry(0, 0)],
        'size': 3,
        'wantValid': false,
      },
      {
        'input': [SparseEntry(1, 3), SparseEntry(2, 2)],
        'size': 10,
        'wantValid': false,
      }
    ];

    for (var i = 0; i < tests.length; i++) {
      final testParams = tests[i];
      test('validateSparseEntries $i', () {
        expect(validateSparseEntries(testParams['input'], testParams['size']),
            testParams['wantValid'] ?? false);
      });

      if (!testParams['wantValid']) continue;
      test('alignSparseEntries $i', () {
        expect(alignSparseEntries(testParams['input'], testParams['size']),
            testParams['wantAligned']);
      });

      test('invertSparseEntries $i', () {
        expect(invertSparseEntries(testParams['input'], testParams['size']),
            testParams['wantInverted']);
      });
    }
  });

  group('File info header', () {
    test('null input', () {
      expect(() => fileInfoHeader(null, ''), throwsArgumentError);
    });

    test('regular file', () async {
      final packageUri =
          await Isolate.resolvePackageUri(Uri.parse('package:tar/tar.dart'));
      final testFileUri = packageUri.resolve('../test/testdata/small.txt');
      final file = File.fromUri(testFileUri);
      final header = fileInfoHeader(file, '');

      final fileStat = file.statSync();
      expect(header.name, 'small.txt');
      expect(header.mode, fileStat.mode);
      expect(header.size, fileStat.size);
      expect(header.modified, fileStat.modified);
    });

    test('directory', () async {
      final packageUri =
          await Isolate.resolvePackageUri(Uri.parse('package:tar/tar.dart'));
      final testFileUri = packageUri.resolve('../test/testdata/');
      final file = File.fromUri(testFileUri);
      final header = fileInfoHeader(file, '');

      final fileStat = file.statSync();
      expect(header.name, 'testdata');
      expect(header.mode, fileStat.mode);
      expect(header.size, fileStat.size);
      expect(header.modified, fileStat.modified);
    });

    /// TODO(walnut): symlink test
  });
}
