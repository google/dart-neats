// Copyright 2020
//
// Licensed under the Apache License, Version 2.0 (the 'License');
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an 'AS IS' BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:io';
import 'dart:isolate';

import 'package:crypto/crypto.dart';
import 'package:tar/src/constants.dart';
import 'package:tar/src/exceptions.dart';
import 'package:tar/src/format.dart';
import 'package:tar/src/header.dart';
import 'package:tar/src/reader.dart';
import 'package:tar/src/sparse_entry.dart';
import 'package:tar/src/utils.dart';
import 'package:test/test.dart';

void main() async {
  final packageUri =
      await Isolate.resolvePackageUri(Uri.parse('package:tar/tar.dart'));
  final testDirectoryUri = packageUri.resolve('../test/testdata/');

  group('reader', () {
    final tests = [
      {
        'file': 'gnu.tar',
        'headers': [
          TarHeader.internal(
            name: 'small.txt',
            mode: 436,
            userId: 1000,
            groupId: 1000,
            size: 3,
            modified: millisecondsSinceEpoch(1597755680000),
            typeFlag: TypeFlag.reg,
            userName: 'garett',
            groupName: 'garett',
            format: TarFormat.GNU,
          ),
          TarHeader.internal(
            name: 'small2.txt',
            mode: 436,
            userId: 1000,
            groupId: 1000,
            size: 8,
            modified: millisecondsSinceEpoch(1597755958000),
            typeFlag: TypeFlag.reg,
            userName: 'garett',
            groupName: 'garett',
            format: TarFormat.GNU,
          )
        ],
        'checksums': [
          'a29bdd003ef6c0c34279807341f450f2',
          '7d4f8e1ca1dd8a7ab42dea2fed1a97a1',
        ],
      },
      {
        'file': 'sparse-formats.tar',
        'headers': [
          TarHeader.internal(
            name: 'sparse-gnu',
            mode: 420,
            userId: 1000,
            groupId: 1000,
            size: 200,
            modified: millisecondsSinceEpoch(1597756151000),
            typeFlag: TypeFlag.gnuSparse,
            linkName: '',
            userName: 'jonas',
            groupName: 'jonas',
            devMajor: 0,
            devMinor: 0,
            format: TarFormat.GNU,
          ),
          TarHeader.internal(
            name: 'sparse-posix-v-0-0',
            mode: 420,
            userId: 1000,
            groupId: 1000,
            size: 200,
            modified: millisecondsSinceEpoch(1597756151000),
            typeFlag: TypeFlag.reg,
            linkName: '',
            userName: 'jonas',
            groupName: 'jonas',
            devMajor: 0,
            devMinor: 0,
            paxRecords: {
              'GNU.sparse.size': '200',
              'GNU.sparse.numblocks': '95',
              'GNU.sparse.map':
                  '1,1,3,1,5,1,7,1,9,1,11,1,13,1,15,1,17,1,19,1,21,1,23,1,25,1,27,1,29,1,31,1,33,1,35,1,37,1,39,1,41,1,43,1,45,1,47,1,49,1,51,1,53,1,55,1,57,1,59,1,61,1,63,1,65,1,67,1,69,1,71,1,73,1,75,1,77,1,79,1,81,1,83,1,85,1,87,1,89,1,91,1,93,1,95,1,97,1,99,1,101,1,103,1,105,1,107,1,109,1,111,1,113,1,115,1,117,1,119,1,121,1,123,1,125,1,127,1,129,1,131,1,133,1,135,1,137,1,139,1,141,1,143,1,145,1,147,1,149,1,151,1,153,1,155,1,157,1,159,1,161,1,163,1,165,1,167,1,169,1,171,1,173,1,175,1,177,1,179,1,181,1,183,1,185,1,187,1,189,1',
            },
            format: TarFormat.PAX,
          ),
          TarHeader.internal(
            name: 'sparse-posix-0-1',
            mode: 420,
            userId: 1000,
            groupId: 1000,
            size: 200,
            modified: millisecondsSinceEpoch(1597756151000),
            typeFlag: TypeFlag.reg,
            linkName: '',
            userName: 'jonas',
            groupName: 'jonas',
            devMajor: 0,
            devMinor: 0,
            paxRecords: {
              'GNU.sparse.size': '200',
              'GNU.sparse.numblocks': '95',
              'GNU.sparse.map':
                  '1,1,3,1,5,1,7,1,9,1,11,1,13,1,15,1,17,1,19,1,21,1,23,1,25,1,27,1,29,1,31,1,33,1,35,1,37,1,39,1,41,1,43,1,45,1,47,1,49,1,51,1,53,1,55,1,57,1,59,1,61,1,63,1,65,1,67,1,69,1,71,1,73,1,75,1,77,1,79,1,81,1,83,1,85,1,87,1,89,1,91,1,93,1,95,1,97,1,99,1,101,1,103,1,105,1,107,1,109,1,111,1,113,1,115,1,117,1,119,1,121,1,123,1,125,1,127,1,129,1,131,1,133,1,135,1,137,1,139,1,141,1,143,1,145,1,147,1,149,1,151,1,153,1,155,1,157,1,159,1,161,1,163,1,165,1,167,1,169,1,171,1,173,1,175,1,177,1,179,1,181,1,183,1,185,1,187,1,189,1',
              'GNU.sparse.name': 'sparse-posix-0-1',
            },
            format: TarFormat.PAX,
          ),
          TarHeader.internal(
            name: 'sparse-posix-1-0',
            mode: 420,
            userId: 1000,
            groupId: 1000,
            size: 200,
            modified: millisecondsSinceEpoch(1597756151000),
            typeFlag: TypeFlag.reg,
            linkName: '',
            userName: 'jonas',
            groupName: 'jonas',
            devMajor: 0,
            devMinor: 0,
            paxRecords: {
              'GNU.sparse.major': '1',
              'GNU.sparse.minor': '0',
              'GNU.sparse.realsize': '200',
              'GNU.sparse.name': 'sparse-posix-1-0',
            },
            format: TarFormat.PAX,
          ),
          TarHeader.internal(
            name: 'end',
            mode: 420,
            userId: 1000,
            groupId: 1000,
            size: 4,
            modified: millisecondsSinceEpoch(1597756151000),
            typeFlag: TypeFlag.reg,
            linkName: '',
            userName: 'jonas',
            groupName: 'jonas',
            devMajor: 0,
            devMinor: 0,
            format: TarFormat.GNU,
          )
        ],
        'checksums': [
          '6641dd43d9f1b3a839162775eccb25a0',
          '6641dd43d9f1b3a839162775eccb25a0',
          '6641dd43d9f1b3a839162775eccb25a0',
          '6641dd43d9f1b3a839162775eccb25a0',
          'b0061974914468de549a2af8ced10316',
        ],
      },
      {
        'file': 'star.tar',
        'headers': [
          TarHeader.internal(
              name: 'small.txt',
              mode: 416,
              userId: 1000,
              groupId: 1000,
              size: 3,
              modified: millisecondsSinceEpoch(1597755680000),
              typeFlag: TypeFlag.reg,
              userName: 'garett',
              groupName: 'garett',
              accessed: millisecondsSinceEpoch(1597755680000),
              changed: millisecondsSinceEpoch(1597755680000),
              format: TarFormat.STAR),
          TarHeader.internal(
              name: 'small2.txt',
              mode: 416,
              userId: 1000,
              groupId: 1000,
              size: 7,
              modified: millisecondsSinceEpoch(1597755958000),
              typeFlag: TypeFlag.reg,
              userName: 'garett',
              groupName: 'garett',
              accessed: millisecondsSinceEpoch(1597755958000),
              changed: millisecondsSinceEpoch(1597755958000),
              format: TarFormat.STAR)
        ]
      },
      {
        'file': 'v7.tar',
        'headers': [
          TarHeader.internal(
              name: 'small.txt',
              mode: 436,
              userId: 1000,
              groupId: 1000,
              size: 3,
              modified: millisecondsSinceEpoch(1597755680000),
              typeFlag: TypeFlag.reg,
              format: TarFormat.V7),
          TarHeader.internal(
              name: 'small2.txt',
              mode: 436,
              userId: 1000,
              groupId: 1000,
              size: 8,
              modified: millisecondsSinceEpoch(1597755958000),
              typeFlag: TypeFlag.reg,
              format: TarFormat.V7)
        ],
      },
      {
        'file': 'ustar.tar',
        'headers': [
          TarHeader.internal(
              name: 'small.txt',
              mode: 436,
              userId: 1000,
              groupId: 1000,
              size: 3,
              modified: millisecondsSinceEpoch(1597755680000),
              typeFlag: TypeFlag.reg,
              userName: 'garett',
              groupName: 'garett',
              format: TarFormat.USTAR),
          TarHeader.internal(
              name: 'small2.txt',
              mode: 436,
              userId: 1000,
              groupId: 1000,
              size: 8,
              modified: millisecondsSinceEpoch(1597755958000),
              typeFlag: TypeFlag.reg,
              userName: 'garett',
              groupName: 'garett',
              format: TarFormat.USTAR)
        ],
      },
      {
        'file': 'pax.tar',
        'headers': [
          TarHeader.internal(
            name:
                'a/123456789101112131415161718192021222324252627282930313233343536373839404142434445464748495051525354555657585960616263646566676869707172737475767778798081828384858687888990919293949596979899100',
            mode: 436,
            userId: 1000,
            groupId: 1000,
            userName: 'jonas',
            groupName: 'fj',
            size: 7,
            modified: microsecondsSinceEpoch(1597823492427388),
            changed: microsecondsSinceEpoch(1597823492427388),
            accessed: microsecondsSinceEpoch(1597823492427388),
            typeFlag: TypeFlag.reg,
            paxRecords: {
              'path':
                  'a/123456789101112131415161718192021222324252627282930313233343536373839404142434445464748495051525354555657585960616263646566676869707172737475767778798081828384858687888990919293949596979899100',
              'mtime': '1597823492.427388865',
              'atime': '1597823492.427388865',
              'ctime': '1597823492.427388865',
            },
            format: TarFormat.PAX,
          ),
          TarHeader.internal(
            name: 'a/b',
            mode: 511,
            userId: 1000,
            groupId: 1000,
            userName: 'garett',
            groupName: 'tok',
            size: 0,
            modified: microsecondsSinceEpoch(1597823492427388),
            changed: microsecondsSinceEpoch(1597823492427388),
            accessed: microsecondsSinceEpoch(1597823492427388),
            typeFlag: TypeFlag.symlink,
            linkName:
                '123456789101112131415161718192021222324252627282930313233343536373839404142434445464748495051525354555657585960616263646566676869707172737475767778798081828384858687888990919293949596979899100',
            paxRecords: {
              'linkpath':
                  '123456789101112131415161718192021222324252627282930313233343536373839404142434445464748495051525354555657585960616263646566676869707172737475767778798081828384858687888990919293949596979899100',
              'mtime': '1597823492.427388865',
              'atime': '1597823492.427388865',
              'ctime': '1597823492.427388865',
            },
            format: TarFormat.PAX,
          ),
        ]
      },
      {
        /// PAX record with bad record length.
        'file': 'pax-bad-record-length.tar',
        'error': true,
      },
      {
        /// PAX record with non-numeric mtime
        'file': 'pax-bad-mtime.tar',
        'error': true,
      },
      {
        'file': 'pax-pos-size-file.tar',
        'headers': [
          TarHeader.internal(
              name: 'bar',
              mode: 416,
              userId: 143077,
              groupId: 1000,
              size: 999,
              modified: millisecondsSinceEpoch(1597755680000),
              typeFlag: TypeFlag.reg,
              userName: 'jonasfj',
              groupName: 'jfj',
              paxRecords: {
                'size': '000000000000000000000999',
              },
              format: TarFormat.PAX)
        ],
        'checksums': [
          'ae66e6e26ca20bd0ee002cc178af7293',
        ],
      },
      {
        'file': 'pax-records.tar',
        'headers': [
          TarHeader.internal(
              typeFlag: TypeFlag.reg,
              name: 'pax-records',
              mode: 416,
              userName: 'walnut',
              modified: millisecondsSinceEpoch(0),
              paxRecords: {
                'pub.dev': 'package:tar',
                'comment': 'Hello, 世界',
              },
              format: TarFormat.PAX)
        ],
      },
      {
        'file': 'pax-global-records.tar',
        'headers': [
          TarHeader.internal(
            typeFlag: TypeFlag.xGlobalHeader,
            name: 'global1',
            paxRecords: {'path': 'global1', 'mtime': '1597756656.2'},
            format: TarFormat.PAX,
          ),
          TarHeader.internal(
            typeFlag: TypeFlag.reg,
            name: 'file-1',
            modified: millisecondsSinceEpoch(0),
            format: TarFormat.USTAR,
          ),
          TarHeader.internal(
            typeFlag: TypeFlag.reg,
            name: 'file-2',
            paxRecords: {'path': 'file-2'},
            modified: millisecondsSinceEpoch(0),
            format: TarFormat.PAX,
          ),
          TarHeader.internal(
            typeFlag: TypeFlag.xGlobalHeader,
            name: 'global-header',
            paxRecords: {'path': ''},
            format: TarFormat.PAX,
          ),
          TarHeader.internal(
            typeFlag: TypeFlag.reg,
            name: 'file-3',
            modified: millisecondsSinceEpoch(0),
            format: TarFormat.USTAR,
          ),
          TarHeader.internal(
            typeFlag: TypeFlag.reg,
            name: 'file-4',
            modified: millisecondsSinceEpoch(1597756750000),
            paxRecords: {'mtime': '1597756750'},
            format: TarFormat.PAX,
          )
        ]
      },
      {
        'file': 'nil-gid-uid.tar',
        'headers': [
          TarHeader.internal(
            name: 'nil-gid.txt',
            mode: 436,
            userId: 1000,
            groupId: 0,
            size: 3,
            modified: millisecondsSinceEpoch(1597755680000),
            typeFlag: TypeFlag.reg,
            linkName: '',
            userName: 'garett',
            groupName: 'garett',
            devMajor: 0,
            devMinor: 0,
            format: TarFormat.GNU,
          ),
          TarHeader.internal(
            name: 'nil-uid.txt',
            mode: 436,
            userId: 0,
            groupId: 1000,
            size: 7,
            modified: millisecondsSinceEpoch(1597755958000),
            typeFlag: TypeFlag.reg,
            linkName: '',
            userName: 'garett',
            groupName: 'garett',
            devMajor: 0,
            devMinor: 0,
            format: TarFormat.GNU,
          )
        ]
      },
      {
        'file': 'xattrs.tar',
        'headers': [
          TarHeader.internal(
              name: 'small.txt',
              mode: 420,
              userId: 1000,
              groupId: 10,
              size: 5,
              modified: microsecondsSinceEpoch(1597823492427388),
              typeFlag: TypeFlag.reg,
              userName: 'garett',
              groupName: 'tok',
              accessed: microsecondsSinceEpoch(1597823492427388),
              changed: microsecondsSinceEpoch(1597823492427388),
              format: TarFormat.PAX,
              paxRecords: {
                'mtime': '1597823492.42738865',
                'atime': '1597823492.42738865',
                'ctime': '1597823492.427388924',
                'SCHILY.xattr.user.key': 'value',
                'SCHILY.xattr.user.key2': 'value2',
                'SCHILY.xattr.security.selinux':
                    'unconfined_u:object_r:default_t:s0\x00',
              }),
          TarHeader.internal(
            name: 'small2.txt',
            mode: 420,
            userId: 1000,
            groupId: 10,
            size: 11,
            modified: microsecondsSinceEpoch(1597823492427388),
            typeFlag: TypeFlag.reg,
            userName: 'garett',
            groupName: 'tok',
            accessed: microsecondsSinceEpoch(1597823492427388),
            changed: microsecondsSinceEpoch(1597823492427388),
            format: TarFormat.PAX,
            paxRecords: {
              'mtime': '1597823492.427388865',
              'atime': '1597823492.42738865',
              'ctime': '1597823492.427388865',
              'SCHILY.xattr.security.selinux':
                  'unconfined_u:object_r:default_t:s0\x00',
            },
          )
        ]
      },
      {
        /// Matches the behavior of GNU, BSD, and STAR tar utilities.
        'file': 'gnu-multi-hdrs.tar',
        'headers': [
          TarHeader.internal(
            name: 'long-path-name',
            linkName: 'long-linkpath-name',
            userId: 1000,
            groupId: 1000,
            modified: millisecondsSinceEpoch(1597756829000),
            typeFlag: TypeFlag.symlink,
            format: TarFormat.GNU,
          )
        ],
      },
      {
        /// GNU tar 'file' with atime and ctime fields set.
        /// Old GNU incremental backup.
        ///
        /// Created with the GNU tar v1.27.1.
        ///	tar --incremental -S -cvf gnu-incremental.tar test2
        'file': 'gnu-incremental.tar',
        'headers': [
          TarHeader.internal(
            name: 'incremental/',
            mode: 16877,
            userId: 1000,
            groupId: 1000,
            size: 14,
            modified: millisecondsSinceEpoch(1597755680000),
            typeFlag: TypeFlag.vendor,
            userName: 'fizz',
            groupName: 'foobar',
            accessed: millisecondsSinceEpoch(1597755680000),
            changed: millisecondsSinceEpoch(1597755033000),
            format: TarFormat.GNU,
          ),
          TarHeader.internal(
            name: 'incremental/foo',
            mode: 33188,
            userId: 1000,
            groupId: 1000,
            size: 64,
            modified: millisecondsSinceEpoch(1597755688000),
            typeFlag: TypeFlag.reg,
            userName: 'fizz',
            groupName: 'foobar',
            accessed: millisecondsSinceEpoch(1597759641000),
            changed: millisecondsSinceEpoch(1597755793000),
            format: TarFormat.GNU,
          ),
          TarHeader.internal(
            name: 'incremental/sparse',
            mode: 33188,
            userId: 1000,
            groupId: 1000,
            size: 536870912,
            modified: millisecondsSinceEpoch(1597755776000),
            typeFlag: TypeFlag.gnuSparse,
            userName: 'fizz',
            groupName: 'foobar',
            accessed: millisecondsSinceEpoch(1597755703000),
            changed: millisecondsSinceEpoch(1597755602000),
            format: TarFormat.GNU,
          )
        ]
      },
      {
        /// Matches the behavior of GNU and BSD tar utilities.
        'file': 'pax-multi-hdrs.tar',
        'headers': [
          TarHeader.internal(
            name: 'baz',
            linkName: 'bzzt/bzzt/bzzt/bzzt/bzzt/baz',
            modified: millisecondsSinceEpoch(0),
            typeFlag: TypeFlag.symlink,
            format: TarFormat.PAX,
            paxRecords: {
              'linkpath': 'bzzt/bzzt/bzzt/bzzt/bzzt/baz',
            },
          )
        ]
      },
      {
        /// Both BSD and GNU tar truncate long names at first NUL even
        /// if there is data following that NUL character.
        /// This is reasonable as GNU long names are C-strings.
        'file': 'gnu-long-nul.tar',
        'headers': [
          TarHeader.internal(
            name: '9876543210',
            mode: 420,
            userId: 1000,
            groupId: 1000,
            modified: millisecondsSinceEpoch(1597755682000),
            typeFlag: TypeFlag.reg,
            format: TarFormat.GNU,
            userName: 'jensen',
            groupName: 'jensen',
          )
        ]
      },
      {
        /// This archive was generated by Writer but is readable by both
        /// GNU and BSD tar utilities.
        /// The archive generated by GNU is nearly byte-for-byte identical
        /// to the Go version except the Go version sets a negative devMinor
        /// just to force the GNU format.
        'file': 'gnu-utf8.tar',
        'headers': [
          TarHeader.internal(
            name: '🧸',
            mode: 420,
            userId: 525,
            groupId: 600,
            modified: millisecondsSinceEpoch(0),
            typeFlag: TypeFlag.reg,
            userName: '🐻',
            groupName: '🥭',
            format: TarFormat.GNU,
          )
        ]
      },
      {
        'file': 'gnu-non-utf8-name.tar',
        'headers': [
          TarHeader.internal(
            name: 'pub\x80\x81\x82\x83dev',
            mode: 422,
            userId: 1234,
            groupId: 5678,
            modified: millisecondsSinceEpoch(0),
            typeFlag: TypeFlag.reg,
            userName: 'walnut',
            groupName: 'dust',
            format: TarFormat.GNU,
          )
        ]
      },
      {
        /// BSD tar v3.1.2 and GNU tar v1.27.1 both rejects PAX records
        /// with NULs in the key.
        'file': 'pax-nul-xattrs.tar',
        'error': true,
      },
      {
        /// BSD tar v3.1.2 rejects a PAX path with NUL in the value, while
        /// GNU tar v1.27.1 simply truncates at first NUL.
        /// We emulate the behavior of BSD since it is strange doing NUL
        /// truncations since PAX records are length-prefix strings instead
        /// of NUL-terminated C-strings.
        'file': 'pax-nul-path.tar',
        'error': true,
      },
      {
        'file': 'neg-size.tar',
        'error': true,
      },
      {
        /// Malformed sparse file
        'file': 'malformed-sparse-file.tar',
        'error': true,
      },
      {
        /// PAX records that do not have a new line at the end.
        'file': 'invalid-pax-headers.tar',
        'error': true,
      },
      {
        /// Invalid user id
        'file': 'invalid-uid.tar',
        'error': true,
      },
      {
        /// USTAR archive with a regular entry with non-zero device numbers.
        'file': 'ustar-nonzero-device-numbers.tar',
        'headers': [
          TarHeader.internal(
            name: 'file',
            mode: 420,
            typeFlag: TypeFlag.reg,
            modified: millisecondsSinceEpoch(0),
            userName: 'Jonas',
            groupName: 'Google',
            devMajor: 1,
            devMinor: 1,
            format: TarFormat.USTAR,
          )
        ]
      },
      {
        // Works on BSD tar v3.1.2 and GNU tar v.1.27.1.
        'file': 'gnu-nil-sparse-data.tar',
        'headers': [
          TarHeader.internal(
              name: 'nil-sparse-data',
              typeFlag: TypeFlag.gnuSparse,
              userId: 1000,
              groupId: 1000,
              size: 1000,
              modified: millisecondsSinceEpoch(1597756076000),
              format: TarFormat.GNU)
        ],
      },
      {
        // Works on BSD tar v3.1.2 and GNU tar v.1.27.1.
        'file': 'gnu-nil-sparse-hole.tar',
        'headers': [
          TarHeader.internal(
              name: 'nil-sparse-hole',
              typeFlag: TypeFlag.gnuSparse,
              size: 1000,
              userId: 1000,
              groupId: 1000,
              modified: millisecondsSinceEpoch(1597756079000),
              format: TarFormat.GNU)
        ]
      },
      {
        // Works on BSD tar v3.1.2 and GNU tar v.1.27.1.
        'file': 'pax-nil-sparse-data.tar',
        'headers': [
          TarHeader.internal(
              name: 'sparse',
              typeFlag: TypeFlag.reg,
              size: 1000,
              userId: 1000,
              groupId: 1000,
              modified: millisecondsSinceEpoch(1597756076000),
              paxRecords: {
                'size': '1512',
                'GNU.sparse.major': '1',
                'GNU.sparse.minor': '0',
                'GNU.sparse.realsize': '1000',
                'GNU.sparse.name': 'sparse',
              },
              format: TarFormat.PAX)
        ]
      },
      {
        // Works on BSD tar v3.1.2 and GNU tar v.1.27.1.
        'file': 'pax-nil-sparse-hole.tar',
        'headers': [
          TarHeader.internal(
              name: 'sparse.txt',
              typeFlag: TypeFlag.reg,
              size: 1000,
              userId: 1000,
              groupId: 1000,
              modified: millisecondsSinceEpoch(1597756077000),
              paxRecords: {
                'size': '512',
                'GNU.sparse.major': '1',
                'GNU.sparse.minor': '0',
                'GNU.sparse.realsize': '1000',
                'GNU.sparse.name': 'sparse.txt',
              },
              format: TarFormat.PAX)
        ]
      },
      {
        'file': 'trailing-slash.tar',
        'headers': [
          TarHeader.internal(
              typeFlag: TypeFlag.dir,
              name: '987654321/' * 30,
              modified: millisecondsSinceEpoch(0),
              paxRecords: {
                'path': '987654321/' * 30,
              },
              format: TarFormat.PAX)
        ]
      }
    ];

    for (var i = 0; i < tests.length; i++) {
      final testInputs = tests[i];
      test('${testInputs['file']}', () async {
        final expectedHeaders = testInputs['headers'] as List<TarHeader>;

        final testFileUri = testDirectoryUri.resolve(testInputs['file']);
        final testFile = File.fromUri(testFileUri);

        if (!testFile.existsSync()) {
          throw ArgumentError('File not found at ${testFile.path}');
        }

        final tarReader = TarReader(testFile.openRead());

        if (testInputs['error'] == true) {
          expect(() async {
            await tarReader.next();
          }, throwsFormatException);
        } else {
          final checksums = testInputs['checksums'] as List<String>;

          for (var i = 0; i < expectedHeaders.length; i++) {
            expect(await tarReader.next(), true);
            expect(tarReader.header, expectedHeaders[i]);

            if (checksums != null) {
              final contents = await tarReader.contents.toList();
              final hash = md5.convert(contents).toString();

              expect(hash, checksums[i]);
            }
          }
          expect(await tarReader.next(), false);
        }
      });
    }
  });

  group('partial read', () {
    final tests = [
      {
        'file': 'gnu.tar',
        'cases': [
          'Pub',
          'Pub.dev\n',
        ]
      },
      {
        'file': 'sparse-formats.tar',
        'cases': [
          '\x00D\x00a\x00r\x00t\x00D\x00a\x00r\x00t\x00D\x00a\x00r\x00t\x00D'
              '\x00a\x00r\x00t\x00D\x00a\x00r\x00t\x00D\x00a\x00r\x00t\x00D\x00a'
              '\x00r\x00t\x00D\x00a\x00r\x00t\x00D\x00a\x00r\x00t\x00D\x00a\x00r'
              '\x00t\x00D\x00a\x00r\x00t\x00D\x00a\x00r\x00t\x00D\x00a\x00r\x00t'
              '\x00D\x00a\x00r\x00t\x00D\x00a\x00r\x00t\x00D\x00a\x00r\x00t\x00D'
              '\x00a\x00r\x00t\x00D\x00a\x00r\x00t\x00D\x00a\x00r\x00t\x00D\x00a'
              '\x00r\x00t\x00D\x00a\x00r\x00t\x00D\x00a\x00r\x00t\x00F\x00l\x00u'
              '\x00t\x00t\x00e\x00r\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00',
          '\x00D\x00a\x00r\x00t\x00D\x00a\x00r\x00t\x00D\x00a\x00r\x00t\x00D'
              '\x00a\x00r\x00t\x00D\x00a\x00r\x00t\x00D\x00a\x00r\x00t\x00D\x00a'
              '\x00r\x00t\x00D\x00a\x00r\x00t\x00D\x00a\x00r\x00t\x00D\x00a\x00r'
              '\x00t\x00D\x00a\x00r\x00t\x00D\x00a\x00r\x00t\x00D\x00a\x00r\x00t'
              '\x00D\x00a\x00r\x00t\x00D\x00a\x00r\x00t\x00D\x00a\x00r\x00t\x00D'
              '\x00a\x00r\x00t\x00D\x00a\x00r\x00t\x00D\x00a\x00r\x00t\x00D\x00a'
              '\x00r\x00t\x00D\x00a\x00r\x00t\x00D\x00a\x00r\x00t\x00F\x00l\x00u'
              '\x00t\x00t\x00e\x00r\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00',
          '\x00D\x00a\x00r\x00t\x00D\x00a\x00r\x00t\x00D\x00a\x00r\x00t\x00D'
              '\x00a\x00r\x00t\x00D\x00a\x00r\x00t\x00D\x00a\x00r\x00t\x00D\x00a'
              '\x00r\x00t\x00D\x00a\x00r\x00t\x00D\x00a\x00r\x00t\x00D\x00a\x00r'
              '\x00t\x00D\x00a\x00r\x00t\x00D\x00a\x00r\x00t\x00D\x00a\x00r\x00t'
              '\x00D\x00a\x00r\x00t\x00D\x00a\x00r\x00t\x00D\x00a\x00r\x00t\x00D'
              '\x00a\x00r\x00t\x00D\x00a\x00r\x00t\x00D\x00a\x00r\x00t\x00D\x00a'
              '\x00r\x00t\x00D\x00a\x00r\x00t\x00D\x00a\x00r\x00t\x00F\x00l\x00u'
              '\x00t\x00t\x00e\x00r\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00',
          '\x00D\x00a\x00r\x00t\x00D\x00a\x00r\x00t\x00D\x00a\x00r\x00t\x00D'
              '\x00a\x00r\x00t\x00D\x00a\x00r\x00t\x00D\x00a\x00r\x00t\x00D\x00a'
              '\x00r\x00t\x00D\x00a\x00r\x00t\x00D\x00a\x00r\x00t\x00D\x00a\x00r'
              '\x00t\x00D\x00a\x00r\x00t\x00D\x00a\x00r\x00t\x00D\x00a\x00r\x00t'
              '\x00D\x00a\x00r\x00t\x00D\x00a\x00r\x00t\x00D\x00a\x00r\x00t\x00D'
              '\x00a\x00r\x00t\x00D\x00a\x00r\x00t\x00D\x00a\x00r\x00t\x00D\x00a'
              '\x00r\x00t\x00D\x00a\x00r\x00t\x00D\x00a\x00r\x00t\x00F\x00l\x00u'
              '\x00t\x00t\x00e\x00r\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00',
          'end\n'
        ]
      }
    ];

    for (var i = 0; i < tests.length; i++) {
      test('file $i', () async {
        final testInputs = tests[i];

        final testFileUri = testDirectoryUri.resolve(testInputs['file']);
        final testFile = File.fromUri(testFileUri);

        if (!testFile.existsSync()) {
          throw ArgumentError('File not found at ${testFile.path}');
        }

        final tarReader = TarReader(testFile.openRead());
        final testCases = testInputs['cases'] as List<String>;

        for (var j = 0; j < testCases.length; j++) {
          expect(await tarReader.next(), true);
          final contents = await tarReader.contents.toList();
          expect(String.fromCharCodes(contents), testCases[j]);
        }
        expect(await tarReader.next(), false);
      });
    }
  });

  /// Skipping TestUninitializedRead and TestRestTruncation from the Go
  /// implementation because the way we do read is different.

  test('reader does not read header-only files', () async {
    final testFileUri = testDirectoryUri.resolve('hdr-only.tar');
    final testFile = File.fromUri(testFileUri);

    if (!testFile.existsSync()) {
      throw ArgumentError('File not found at ${testFile.path}');
    }

    final tarReader = TarReader(testFile.openRead());
    final headers = <TarHeader>[];

    while (await tarReader.next()) {
      headers.add(tarReader.header);
    }

    /// File is crafted with 16 entries. The later 8 are identical to the first
    /// 8 except that the size is set.
    expect(headers.length, 16);

    for (var i = 0; i < 8; i++) {
      headers[i].size = 0;
      headers[i + 8].size = 0;
      expect(headers[i], headers[i + 8]);
    }
  });

  group('mergePAX', () {
    final tests = [
      {
        'in': {
          'path': 'a/b/c',
          'uid': '1000',
          'mtime': '1350244992.023960108',
        },
        'want': TarHeader.internal(
            name: 'a/b/c',
            userId: 1000,
            modified: microsecondsSinceEpoch(1350244992023960),
            paxRecords: {
              'path': 'a/b/c',
              'uid': '1000',
              'mtime': '1350244992.023960108'
            }),
        'ok': true
      },
      {
        'in': {
          'gid': 'gtgergergersagersgers',
        },
        'ok': false
      },
      {
        'in': {
          'missing': 'missing',
          'SCHILY.xattr.key': 'value',
        },
        'want': TarHeader.internal(
            paxRecords: {'missing': 'missing', 'SCHILY.xattr.key': 'value'}),
        'ok': true
      }
    ];

    for (var i = 0; i < tests.length; i++) {
      test('$i', () {
        final testInputs = tests[i];
        final actual = TarHeader.internal();
        if (testInputs['ok']) {
          actual.mergePAX(testInputs['in']);
          expect(actual, testInputs['want']);
        } else {
          expect(
              () => actual.mergePAX(testInputs['in']), throwsFormatException);
        }
      });
    }
  });

  group('parsePAX', () {
    final tests = [
      {'in': '', 'want': {}, 'ok': true},
      {
        'in': '6 k=1\n',
        'want': {'k': '1'},
        'ok': true
      },
      {
        'in': '10 a=name\n',
        'want': {'a': 'name'},
        'ok': true
      },
      {
        'in': '9 a=name\n',
        'want': {'a': 'name'},
        'ok': true
      },
      {
        'in': '30 mtime=1350244992.023960108\n',
        'want': {'mtime': '1350244992.023960108'},
        'ok': true
      },
      {'in': '3 somelongkey=\n', 'want': null, 'ok': false},
      {'in': '50 tooshort=\n', 'want': null, 'ok': false},
      {
        'in': '13 key1=haha\n13 key2=nana\n13 key3=kaka\n',
        'want': {'key1': 'haha', 'key2': 'nana', 'key3': 'kaka'},
        'ok': true
      },
      {
        'in': '13 key1=val1\n13 key2=val2\n8 key1=\n',
        'want': {'key1': '', 'key2': 'val2'},
        'ok': true
      },
      {
        'in': '22 GNU.sparse.size=10\n26 GNU.sparse.numblocks=2\n'
            '23 GNU.sparse.offset=1\n25 GNU.sparse.numbytes=2\n'
            '23 GNU.sparse.offset=3\n25 GNU.sparse.numbytes=4\n',
        'want': {
          paxGNUSparseSize: '10',
          paxGNUSparseNumBlocks: '2',
          paxGNUSparseMap: '1,2,3,4'
        },
        'ok': true
      },
      {
        'in': '22 GNU.sparse.size=10\n26 GNU.sparse.numblocks=1\n'
            '25 GNU.sparse.numbytes=2\n23 GNU.sparse.offset=1\n',
        'want': null,
        'ok': false
      },
      {
        'in': '22 GNU.sparse.size=10\n26 GNU.sparse.numblocks=1\n'
            '25 GNU.sparse.offset=1,2\n25 GNU.sparse.numbytes=2\n',
        'want': null,
        'ok': false
      },
    ];

    for (var i = 0; i < tests.length; i++) {
      test('$i', () {
        final testInputs = tests[i];
        final inputString = testInputs['in'] as String;

        if (testInputs['ok']) {
          final actual = parsePAX(inputString.codeUnits);
          expect(actual, testInputs['want']);
        } else {
          expect(() => parsePAX(inputString.codeUnits), throwsFormatException);
        }
      });
    }
  });

  group('read old GNU headers', () {
    /// Sets the magic values of [format] in [rawHeader].
    void setFormat(List<int> rawHeader, TarFormat format) {
      if (format.has(TarFormat.V7)) {
        // do nothing
      } else if (format.has(TarFormat.GNU)) {
        rawHeader.setRange(257, 265, (magicGNU + versionGNU).codeUnits);
      } else if (format.has(TarFormat.STAR)) {
        rawHeader.setRange(257, 265, (magicUSTAR + versionUSTAR).codeUnits);
        rawHeader.setRange(508, 512, trailerSTAR.codeUnits);
      } else if (format.has(TarFormat.USTAR | TarFormat.PAX)) {
        rawHeader.setRange(257, 265, (magicUSTAR + versionUSTAR).codeUnits);
      } else {
        throw createHeaderException('Invalid format');
      }
    }

    /// Updates the checksum of [rawHeader].
    void updateChecksum(List<int> rawHeader) {
      // This field is special in that it is terminated by a NULL then space.
      // Possible values are 256..128776
      final checksum = computeSignedCheckSum(rawHeader);
      // Never fails since 128776 < 262143
      final newChecksum = formatOctal(checksum, 7);
      newChecksum.add(SPACE);

      rawHeader.setRange(148, 156, newChecksum);
    }

    /// Creates a list of bytes which can be processed by [TarReader], filled
    /// with the sparse data in [sparseEntries] in GNU format.
    List<int> makeInput(TarFormat format, String size,
        [List<String> sparseEntries]) {
      final result = <int>[];

      /// Write the initial GNU header.
      final rawHeader = List<int>.filled(blockSize, 0);
      final sizeBytes = size.codeUnits;
      rawHeader.setRange(483, 483 + sizeBytes.length, sizeBytes);

      var sparseEntriesIndex = 0;
      sparseEntries ??= [];

      while (
          sparseEntriesIndex < 4 && sparseEntriesIndex < sparseEntries.length) {
        final replacement = sparseEntries[sparseEntriesIndex].codeUnits;
        rawHeader.setRange(386 + sparseEntriesIndex * 24,
            386 + sparseEntriesIndex * 24 + replacement.length, replacement);

        sparseEntriesIndex++;
      }

      /// Set isExtended if necessary.
      if (sparseEntries.length > sparseEntriesIndex) rawHeader[482] = 80;

      /// Set the type flag to recognize that this is a header with sparse data.
      rawHeader[156] = 83;

      setFormat(rawHeader, format);
      updateChecksum(rawHeader);
      result.addAll(rawHeader);

      /// Write extended sparse blocks.
      while (sparseEntriesIndex < sparseEntries?.length ?? 0) {
        final rawHeader = List<int>.filled(blockSize, 0);
        for (var i = 0;
            i < (blockSize / 24) && sparseEntriesIndex < sparseEntries.length;
            i++) {
          final replacement = sparseEntries[sparseEntriesIndex++].codeUnits;
          rawHeader.setRange(i * 24, (i + 1) * 24, replacement);
        }

        /// Set isExtended if necessary.
        if (sparseEntries.length > sparseEntriesIndex) rawHeader[505] = 80;

        result.addAll(rawHeader);
      }

      return result;
    }

    /// Converts [SparseEntry]s into [String]s representing the byte entries
    /// in a GNU header.
    List<String> makeSparseStrings(List<SparseEntry> sparseEntries) {
      final result = <String>[];
      for (final sparseEntry in sparseEntries) {
        result.add(String.fromCharCodes([
          ...formatNumeric(sparseEntry.offset, 12),
          ...formatNumeric(sparseEntry.length, 12)
        ]));
      }

      return result;
    }

    final tests = [
      {
        'input': makeInput(TarFormat.GNU, '1234', ['fewa']),
        'wantSize': 668,
        'throws': throwsFormatException,
      },
      {
        'input': makeInput(TarFormat.GNU, '0031'),
        'wantSize': 25,
      },
      {
        'input': makeInput(TarFormat.GNU, '80'),
        'throws': throwsFormatException,
      },
      {
        'input': makeInput(TarFormat.GNU, '1234',
            makeSparseStrings([SparseEntry(0, 0), SparseEntry(1, 1)])),
        'wantMap': [SparseEntry(0, 0), SparseEntry(1, 1)],
        'wantSize': 668,
      },
      {
        'input': makeInput(TarFormat.GNU, '1234', [
          ...makeSparseStrings([SparseEntry(0, 0), SparseEntry(1, 1)]),
          '',
          'blah'
        ]),
        'wantMap': [SparseEntry(0, 0), SparseEntry(1, 1)],
        'wantSize': 668,
      },
      {
        'input': makeInput(
            TarFormat.GNU,
            '3333',
            makeSparseStrings([
              SparseEntry(0, 1),
              SparseEntry(2, 1),
              SparseEntry(4, 1),
              SparseEntry(6, 1)
            ])),
        'wantMap': [
          SparseEntry(0, 1),
          SparseEntry(2, 1),
          SparseEntry(4, 1),
          SparseEntry(6, 1)
        ],
        'wantSize': 1755,
      },
      {
        'input': makeInput(TarFormat.GNU, '1234', [
          ...makeSparseStrings([SparseEntry(0, 1), SparseEntry(2, 1)]),
          '',
          '',
          ...makeSparseStrings([SparseEntry(4, 1), SparseEntry(6, 1)])
        ]),
        'wantMap': [
          SparseEntry(0, 1),
          SparseEntry(2, 1),
          SparseEntry(4, 1),
          SparseEntry(6, 1)
        ],
      },
      {
        'input': makeInput(
            TarFormat.GNU,
            '',
            makeSparseStrings([
              SparseEntry(0, 1),
              SparseEntry(2, 1),
              SparseEntry(4, 1),
              SparseEntry(6, 1),
              SparseEntry(8, 1),
              SparseEntry(10, 1)
            ])).take(blockSize).toList(),
        'throws': throwsRangeError,
      },
      {
        'input': makeInput(
            TarFormat.GNU,
            '',
            makeSparseStrings([
              SparseEntry(0, 1),
              SparseEntry(2, 1),
              SparseEntry(4, 1),
              SparseEntry(6, 1),
              SparseEntry(8, 1),
              SparseEntry(10, 1)
            ])).take((3 * blockSize / 2).floor()).toList(),
        'throws': throwsRangeError,
      },
      {
        'input': makeInput(
            TarFormat.GNU,
            '3333',
            makeSparseStrings([
              SparseEntry(0, 1),
              SparseEntry(2, 1),
              SparseEntry(4, 1),
              SparseEntry(6, 1),
              SparseEntry(8, 1),
              SparseEntry(10, 1)
            ])),
        'wantMap': [
          SparseEntry(0, 1),
          SparseEntry(2, 1),
          SparseEntry(4, 1),
          SparseEntry(6, 1),
          SparseEntry(8, 1),
          SparseEntry(10, 1)
        ],
      },
      {
        'input': makeInput(
            TarFormat.GNU,
            String.fromCharCodes(formatNumeric(20 << 31, 12)),
            makeSparseStrings(
                [SparseEntry(10 << 30, 512), SparseEntry(20 << 30, 512)])),
        'wantMap': [SparseEntry(10 << 30, 512), SparseEntry(20 << 30, 512)],
      }
    ];

    /// Create the sparse maps which would normally have been created in
    /// [_readOldGNUSparseMap].
    List<List<int>> createSparseMaps(List<int> input) {
      final inputChunks = <List<int>>[];
      for (var i = 0; i * 512 < input.length; i++) {
        inputChunks.add(input.sublist(i * 512, (i + 1) * 512));
      }

      inputChunks[0] = inputChunks[0].sublist(386, 482);

      return inputChunks;
    }

    /// Converts the input into an input stream.
    Stream<List<int>> inputStream(List<int> input) {
      final inputChunks = <List<int>>[];
      for (var i = 0; i < input.length; i += 512) {
        inputChunks.add(input.sublist(i, i + 512));
      }
      return Stream.fromIterable(inputChunks);
    }

    for (var i = 0; i < tests.length; i++) {
      final testInputs = tests[i];

      test('$i', () async {
        /// Check that the number of bytes allow it to be a TAR header.
        final inputBytes = testInputs['input'] as List<int>;

        if (testInputs['throws'] != null) {
          expect(() async {
            final reader = TarReader(inputStream(inputBytes));
            await reader.next();
          }, testInputs['throws']);
        } else {
          final reader = TarReader(inputStream(inputBytes));
          expect(await reader.next(), true);

          if (testInputs['wantSize'] != null) {
            expect(reader.header.size, testInputs['wantSize']);
          }

          if (testInputs['wantMap'] != null) {
            final sparseMaps = createSparseMaps(inputBytes);
            expect(processOldGNUSparseMap(sparseMaps), testInputs['wantMap']);
          }
        }
      });
    }
  });

  /// TODO(walnut): figure out how to test this
  group('read GNU sparse PAX headers', () {
    // final tests = [
    //   {
    //     'inputHeaders': null,
    //     'ok': true,
    //   },
    //   {
    //     'inputHeaders': {
    //       paxGNUSparseNumBlocks: '$int64MaxValue',
    //       paxGNUSparseMap: '0,1,2,3',
    //     },
    //     'ok': false,
    //   },
    //   {
    //     'inputHeaders': {
    //       paxGNUSparseNumBlocks: '4\x00',
    //       paxGNUSparseMap: '0,1,2,3',
    //     },
    //     'ok': false,
    //   },
    //   {
    //     'inputHeaders': {
    //       paxGNUSparseNumBlocks: '4',
    //       paxGNUSparseMap: '0,1,2,3',
    //     },
    //     'ok': false,
    //   },
    //   {
    //     'inputHeaders': {
    //       paxGNUSparseNumBlocks: '2',
    //       paxGNUSparseMap: '0,1,2,3',
    //     },
    //     'wantMap': [SparseEntry(0, 1), SparseEntry(2, 3)],
    //   },
    //   {
    //     'inputHeaders': {
    //       paxGNUSparseNumBlocks: '2',
    //       paxGNUSparseMap: '0, 1,2,3',
    //     },
    //     'ok': false,
    //   },
    //   {
    //     'inputHeaders': {
    //       paxGNUSparseNumBlocks: '2',
    //       paxGNUSparseMap: '0,1,02,3',
    //       paxGNUSparseRealSize: '4321',
    //     },
    //     'wantMap': [SparseEntry(0, 1), SparseEntry(2, 3)],
    //     'size': 4321,
    //   },
    //   {
    //     'inputHeaders': {
    //       paxGNUSparseNumBlocks: '2',
    //       paxGNUSparseMap: '0,one1,2,3',
    //     },
    //     'ok': false,
    //   },
    //   {
    //     'inputHeaders': {
    //       paxGNUSparseMajor: '0',
    //       paxGNUSparseMinor: '0',
    //       paxGNUSparseNumBlocks: '2',
    //       paxGNUSparseMap: '0,1,2,3',
    //       paxGNUSparseSize: '1234',
    //       paxGNUSparseRealSize: '4321',
    //       paxGNUSparseName: 'realname',
    //     },
    //     'wantMap': [SparseEntry(0, 1), SparseEntry(2, 3)],
    //     'size': 1234,
    //     'wantName': 'realname',
    //   },
    //   {
    //     'inputHeaders': {
    //       paxGNUSparseMajor: '0',
    //       paxGNUSparseMinor: '0',
    //       paxGNUSparseNumBlocks: '1',
    //       paxGNUSparseMap: '10737418240,512',
    //       paxGNUSparseSize: '10737418240',
    //       paxGNUSparseName: 'realname',
    //     },
    //     'wantMap': [SparseEntry(10737418240, 512)],
    //     'size': 10737418240,
    //     'wantName': 'realname',
    //   },
    //   {
    //     'inputHeaders': {
    //       paxGNUSparseMajor: '0',
    //       paxGNUSparseMinor: '0',
    //       paxGNUSparseNumBlocks: '0',
    //       paxGNUSparseMap: '',
    //     },
    //     'wantMap': <SparseEntry>[],
    //   },
    //   {
    //     'inputHeaders': {
    //       paxGNUSparseMajor: '0',
    //       paxGNUSparseMinor: '1',
    //       paxGNUSparseNumBlocks: '4',
    //       paxGNUSparseMap: '0,5,10,5,20,5,30,5',
    //     },
    //     'wantMap': [
    //       SparseEntry(0, 5),
    //       SparseEntry(10, 5),
    //       SparseEntry(20, 5),
    //       SparseEntry(30, 5)
    //     ],
    //   },
    //   {
    //     'inputHeaders': {
    //       paxGNUSparseMajor: '1',
    //       paxGNUSparseMinor: '0',
    //       paxGNUSparseNumBlocks: '4',
    //       paxGNUSparseMap: '0,5,10,5,20,5,30,5',
    //     },
    //     'ok': false,
    //   },
    //   {
    //     'inputData': padInput('0\n'),
    //     'inputHeaders': {paxGNUSparseMajor: '1', paxGNUSparseMinor: '0'},
    //     'wantMap': <SparseEntry>[],
    //   },
    //   {
    //     'inputData': padInput('0\n').substring(blockSize - 1) + '#',
    //     'inputHeaders': {paxGNUSparseMajor: '1', paxGNUSparseMinor: '0'},
    //     'wantMap': <SparseEntry>[],
    //   },
    //   {
    //     'inputData': padInput('0'),
    //     'inputHeaders': {paxGNUSparseMajor: '1', paxGNUSparseMinor: '0'},
    //     'ok': false,
    //   },
    //   {
    //     'inputData': padInput('ab\n'),
    //     'inputHeaders': {paxGNUSparseMajor: '1', paxGNUSparseMinor: '0'},
    //     'ok': false,
    //   },
    //   {
    //     'inputData': padInput('1\n2\n3\n'),
    //     'inputHeaders': {paxGNUSparseMajor: '1', paxGNUSparseMinor: '0'},
    //     'wantMap': [SparseEntry(2, 3)],
    //   },
    //   {
    //     'inputData': padInput('1\n2\n'),
    //     'inputHeaders': {paxGNUSparseMajor: '1', paxGNUSparseMinor: '0'},
    //     'ok': false,
    //   },
    //   {
    //     'inputData': padInput('1\n2\n\n'),
    //     'inputHeaders': {paxGNUSparseMajor: '1', paxGNUSparseMinor: '0'},
    //     'ok': false,
    //   },
    //   {
    //     'inputData': '\x00' * blockSize + padInput('0\n'),
    //     'inputHeaders': {paxGNUSparseMajor: '1', paxGNUSparseMinor: '0'},
    //     'ok': false,
    //   },
    //   {
    //     'inputData': '0' * blockSize + padInput('1\n5\n1\n'),
    //     'inputHeaders': {paxGNUSparseMajor: '1', paxGNUSparseMinor: '0'},
    //     'wantMap': [SparseEntry(5, 1)],
    //   },
    //   {
    //     'inputData': padInput('$int64MaxValue\n'),
    //     'inputHeaders': {paxGNUSparseMajor: '1', paxGNUSparseMinor: '0'},
    //     'ok': false,
    //   },
    //   {
    //     'inputData': padInput(
    //         '0' * 300 + '1\n' + '0' * 1000 + '5\n' + '0' * 800 + '2\n'),
    //     'inputHeaders': {paxGNUSparseMajor: '1', paxGNUSparseMinor: '0'},
    //     'wantMap': [SparseEntry(5, 2)],
    //   },
    //   {
    //     'inputData': padInput('2\n10737418240\n512\n21474836480\n512\n'),
    //     'inputHeaders': {paxGNUSparseMajor: '1', paxGNUSparseMinor: '0'},
    //     'wantMap': [
    //       SparseEntry(10737418240, 512),
    //       SparseEntry(21474836480, 512)
    //     ],
    //   },
    //   {
    //     'inputData': padInput('100\n' +
    //         () {
    //           final strings = <String>[];
    //           for (var i = 0; i < 100; i++) {
    //             strings.add('${i << 30}\n512\n');
    //           }
    //           return strings.join();
    //         }()),
    //     'inputHeaders': {paxGNUSparseMajor: '1', paxGNUSparseMinor: '0'},
    //     'wantMap': () {
    //       final sparseData = <SparseEntry>[];
    //       for (var i = 0; i < 100; i++) {
    //         sparseData.add(SparseEntry(i << 30, 512));
    //       }
    //       return sparseData;
    //     }(),
    //   }
    // ];

    // for (var i = 0; i < tests.length; i++) {
    //   final testInputs = tests[i];
    //   final header = TarHeader.internal();
    //   header.paxRecords = testInputs['intputHeaders'];

    //   /// Add canary byte.
    //   final inputString = ((testInputs['inputData'] as String) ?? '') + '#';
    //   final inputData = inputString.codeUnits;

    //
    // }
  });
}
