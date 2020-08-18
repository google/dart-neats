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

/// Magic values to help us identify the TAR header type.
const magicGNU = 'ustar ';
const versionGNU = ' \x00';
const magicUSTAR = 'ustar\x00';
const versionUSTAR = '00';
const trailerSTAR = 'tar\x00';

/// *********************************
/// Type flags for TarHeader.linkFlag
/// *********************************

/// Type '0' or '\x00' indicates a regular file.
const typeReg = 48;
const typeRegA = 0;

/// Type '1' to '6' are header-only flags and may not have a data body.

/// Hard link
const typeLink = 49;

/// Symbolic link
const typeSymlink = 50;

/// Character device node
const typeChar = 51;

/// Block device node
const typeBlock = 52;

/// Directory
const typeDir = 53;

/// FIFO node
const typeFifo = 54;

/// Type '7' is reserved.
const typeCont = 55;

/// Type 'x' is used by the PAX format to store key-value records that
/// are only relevant to the next file.
///
/// This package transparently handles these types.
const typeXHeader = 120;

/// Type 'g' is used by the PAX format to store key-value records that
/// are relevant to all subsequent files.
///
/// This package only supports parsing and composing such headers,
/// but does not currently support persisting the global state across files.
const typeXGlobalHeader = 103;

/// Type 'S' indicates a sparse file in the GNU format.
const typeGNUSparse = 83;

/// Types 'L' and 'K' are used by the GNU format for a meta file
/// used to store the path or link name for the next file.
/// This package transparently handles these types.
const typeGNULongName = 76;
const typeGNULongLink = 75;

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

/// *****************
///  Convenience constants
/// ******************

/// Integer max and min values
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
