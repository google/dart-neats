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

import 'package:tar/src/format.dart';

/// Magic values to help us identify the TAR header type.
const magicGNU = 'ustar ';
const versionGNU = ' \x00';
const magicUSTAR = 'ustar\x00';
const versionUSTAR = '00';
const trailerSTAR = 'tar\x00';

/// Type flags for [TarHeader].
///
/// The type flag of a header indicates the kind of file associated with the
/// entry. This enum contains the various type flags over the different TAR
/// formats, and users should be careful that the type flag corresponds to the
/// TAR format they are working with.
enum TypeFlag {
  /// [reg] and [regA] indicate regular files.
  reg,
  regA,

  /// Hard link - header-only, may not have a data body
  link,

  /// Symbolic link - header-only, may not have a data body
  symlink,

  /// Character device node - header-only, may not have a data body
  char,

  /// Block device node - header-only, may not have a data body
  block,

  /// Directory - header-only, may not have a data body
  dir,

  /// FIFO node - header-only, may not have a data body
  fifo,

  /// Currently does not have any meaning, but is reserved for the future.
  reserved,

  /// Used by the PAX format to store key-value records that are only relevant
  /// to the next file.
  ///
  /// This package transparently handles these types.
  xHeader,

  /// Used by the PAX format to store key-value records that are relevant to all
  /// subsequent files.
  ///
  /// This package only supports parsing and composing such headers,
  /// but does not currently support persisting the global state across files.
  xGlobalHeader,

  /// Indiates a sparse file in the GNU format
  gnuSparse,

  /// Used by the GNU format for a meta file to store the path or link name for
  /// the next file.
  /// This package transparently handles these types.
  gnuLongName,
  gnuLongLink,

  /// Vendor specific typeflag, as defined in POSIX.1-1998. Seen as outdated but
  /// may still exist on old files.
  ///
  /// This library uses a single enum to catch them all.
  vendor
}

/// Generates the corresponding [TypeFlag] associated with [byte].
///
/// Users should the result check with [validateTypeFlag] once
TypeFlag typeflagFromByte(int byte) {
  switch (byte) {
    case 48:
      return TypeFlag.reg;
    case 0:
      return TypeFlag.regA;
    case 49:
      return TypeFlag.link;
    case 50:
      return TypeFlag.symlink;
    case 51:
      return TypeFlag.char;
    case 52:
      return TypeFlag.block;
    case 53:
      return TypeFlag.dir;
    case 54:
      return TypeFlag.fifo;
    case 55:
      return TypeFlag.reserved;
    case 120:
      return TypeFlag.xHeader;
    case 103:
      return TypeFlag.xGlobalHeader;
    case 83:
      return TypeFlag.gnuSparse;
    case 76:
      return TypeFlag.gnuLongName;
    case 75:
      return TypeFlag.gnuLongLink;
    default:
      if (64 < byte && byte < 91) {
        return TypeFlag.vendor;
      }
      throw ArgumentError('Invalid typeflag value $byte');
  }
}

/// Checks if [typeFlag] is allowed in [format].
bool validateTypeFlag(TypeFlag typeFlag, TarFormat format) {
  ArgumentError.checkNotNull(typeFlag, 'typeFlag');
  ArgumentError.checkNotNull(format, 'format');

  switch (typeFlag) {
    case TypeFlag.symlink:
    case TypeFlag.char:
    case TypeFlag.block:
    case TypeFlag.dir:
    case TypeFlag.fifo:
    case TypeFlag.reserved:
    case TypeFlag.vendor:
      return format.has(TarFormat.USTAR) ||
          format.has(TarFormat.PAX) ||
          format.has(TarFormat.GNU) ||
          format.has(TarFormat.STAR);
    case TypeFlag.link:
    case TypeFlag.regA:
    case TypeFlag.reg:
      return true;
    case TypeFlag.xHeader:
    case TypeFlag.xGlobalHeader:
      return format.has(TarFormat.PAX);
    case TypeFlag.gnuSparse:
    case TypeFlag.gnuLongName:
    case TypeFlag.gnuLongLink:
      return format.has(TarFormat.GNU);

    /// TODO(walnut): remove when https://github.com/dart-lang/sdk/issues/37498
    /// is resolved.
    default:
      return false;
  }
}

/// Keywords for PAX extended header records.
const paxPath = 'path';
const paxLinkpath = 'linkpath';
const paxSize = 'size';
const paxUid = 'uid';
const paxGid = 'gid';
const paxUname = 'uname';
const paxGname = 'gname';
const paxMtime = 'mtime';
const paxAtime = 'atime';
const paxCtime =
    'ctime'; // Removed from later revision of PAX spec, but was valid
const paxCharset = 'charset'; // Currently unused
const paxComment = 'comment'; // Currently unused
const paxSchilyXattr = 'SCHILY.xattr.';

/// Keywords for GNU sparse files in a PAX extended header.
const paxGNUSparse = 'GNU.sparse.';
const paxGNUSparseNumBlocks = 'GNU.sparse.numblocks';
const paxGNUSparseOffset = 'GNU.sparse.offset';
const paxGNUSparseNumBytes = 'GNU.sparse.numbytes';
const paxGNUSparseMap = 'GNU.sparse.map';
const paxGNUSparseName = 'GNU.sparse.name';
const paxGNUSparseMajor = 'GNU.sparse.major';
const paxGNUSparseMinor = 'GNU.sparse.minor';
const paxGNUSparseSize = 'GNU.sparse.size';
const paxGNUSparseRealSize = 'GNU.sparse.realsize';

/// User ID bit
const c_ISUID = 2048;

/// Group ID bit
const c_ISGID = 1024;

/// Sticky bit
const c_ISVTX = 512;

/// **********************
///  Convenience constants
/// **********************

/// 64-bit integer max and min values
const int64MaxValue = 9223372036854775807;
const int64MinValue = -9223372036854775808;

/// Constants to determine file modes.
const modeType = 2401763328;
const modeSymLink = 134217728;
const modeDevice = 67108864;
const modeCharDevice = 2097152;
const modeNamedPipe = 33554432;
const modeSocket = 1677216;
const modeSetUid = 8388608;
const modeSetGid = 4194304;
const modeSticky = 1048576;
const modeDirectory = 2147483648;

/// Size constants from various TAR specifications.

/// Size of each block in a TAR stream.
const blockSize = 512;

/// Max length of the name field in USTAR format.
const nameSize = 100;

/// Max length of the prefix field in USTAR format.
const prefixSize = 155;

/// Character constants for ease of matching.
const SPACE = 32;
const NEWLINE = 10;
const EQUALS = 61;
const NUL = 0;

/// A full TAR block of zeros.
final zeroBlock = List.filled(blockSize, 0);
