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

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:tar/src/exceptions.dart';
import 'constants.dart';
import 'utils.dart';

/// Handy map to help us translate [TarFormat] values to their names.
/// Be sure to keep this consistent with the constant initializers in
/// [TarFormat].
const _formatNames = {
  1: 'V7',
  2: 'USTAR',
  4: 'PAX',
  8: 'GNU',
  16: 'STAR',
};

/// Holds the possible TAR formats that a file could take.
///
/// This library only supports the V7, USTAR, PAX, GNU, and STAR formats.
///
/// The TAR formats are encoded in powers of two in [_value], such that we
/// can refine our guess via bit operations as we discover more information
/// about the TAR file.
class TarFormat {
  final int _value;

  const TarFormat._internal(this._value);

  @override
  int get hashCode => _value;

  @override
  bool operator ==(other) {
    if (other is! TarFormat) return false;

    return _value == other._value;
  }

  @override
  String toString() => _formatNames[_value] ?? 'Unknown';

  /// Returns if [other] is a possible resolution of [this].
  ///
  /// For example, a [TarFormat] with a value of 6 means that we do not have
  /// enough information to determine if it is [TarFormat.USTAR] or
  /// [TarFormat.PAX], so either of them could be possible resolutions of
  /// [this].
  bool has(TarFormat other) {
    if (_value == null) return false;
    return _value & other._value != 0;
  }

  /// Returns a new [TarFormat] that signifies that it can be either
  /// [this] or [other]'s format.
  ///
  /// **Example:**
  /// ```dart
  /// TarFormat format = TarFormat.USTAR | TarFormat.PAX;
  /// ```
  ///
  /// The above code would signify that we have limited [format] to either
  /// the USTAR or PAX format, but need further information to refine the guess.
  TarFormat operator |(TarFormat other) {
    return mayBe(other);
  }

  /// Returns a new [TarFormat] that signifies that it can be either
  /// [this] or [other]'s format.
  ///
  /// **Example:**
  /// ```dart
  /// TarFormat format = TarFormat.PAX;
  /// format = format.mayBe(TarFormat.USTAR);
  /// ```
  ///
  /// The above code would signify that we learnt that in addition to being a
  /// PAX format, it could also be of the USTAR format.
  TarFormat mayBe(TarFormat other) {
    if (other == null) return this;
    return TarFormat._internal(_value | other._value);
  }

  /// Returns a new [TarFormat] that signifies that it can only be [other]'s
  /// format.
  ///
  /// **Example:**
  /// ```dart
  /// TarFormat format = TarFormat.PAX | TarFormat.USTAR;
  /// ...
  /// format = format.mayOnlyBe(TarFormat.USTAR);
  /// ```
  ///
  /// In the above example, we found that [format] could either be PAX or USTAR,
  /// but later learnt that it can only be the USTAR format.
  ///
  /// If [has(other) == false], [mayOnlyBe] will result in an unknown
  /// [TarFormat].
  TarFormat mayOnlyBe(TarFormat other) {
    if (other == null) return null;
    return TarFormat._internal(_value & other._value);
  }

  /// Original Unix Version 7 (V7) AT&T tar tool prior to standardization.
  ///
  /// The structure of the V7 Header consists of the following:
  ///
  /// Start | End | Field
  /// =========================================================================
  /// 0     | 100 | Path name, stored as null-terminated string.
  /// 100   | 108 | File mode, stored as an octal number in ASCII.
  /// 108   | 116 | User id of owner, as octal number in ASCII.
  /// 116   | 124 | Group id of owner, as octal number in ASCII.
  /// 124   | 136 | Size of file, as octal number in ASCII.
  /// 136   | 148 | Modification time of file, number of seconds from epoch,
  ///               stored as an octal number in ASCII.
  /// 148   | 156 | Header checksum, stored as an octal number in ASCII. See
  ///               [computeUnsignedChecksum] for more details.
  /// 156   | 157 | Link flag, determines the kind of header.
  /// 157   | 257 | Link name, stored as a string.
  /// 257   | 512 | NUL pad.
  ///
  /// Unused bytes are set to NUL ('\x00')s
  ///
  /// Reference:
  /// https://www.freebsd.org/cgi/man.cgi?query=tar&sektion=5&format=html
  /// https://www.gnu.org/software/tar/manual/html_chapter/tar_15.html#SEC188
  /// http://cdrtools.sourceforge.net/private/man/star/star.4.html
  static const V7 = TarFormat._internal(1);

  /// USTAR (Unix Standard TAR) header format defined in POSIX.1-1988.
  ///
  /// The structure of the USTAR Header consists of the following:
  ///
  /// Start | End | Field
  /// =========================================================================
  /// 0     | 100 | Path name, stored as null-terminated string.
  /// 100   | 108 | File mode, stored as an octal number in ASCII.
  /// 108   | 116 | User id of owner, as octal number in ASCII.
  /// 116   | 124 | Group id of owner, as octal number in ASCII.
  /// 124   | 136 | Size of file, as octal number in ASCII.
  /// 136   | 148 | Modification time of file, number of seconds from epoch,
  ///               stored as an octal number in ASCII.
  /// 148   | 156 | Header checksum, stored as an octal number in ASCII. See
  ///               [computeUnsignedChecksum] for more details.
  /// 156   | 157 | Type flag, determines the kind of header.
  ///               Note that the meaning of the size field depends on the type.
  /// 157   | 257 | Link name, stored as a string.
  /// 257   | 263 | Contains the magic value "ustar\x00" to indicate that this is
  ///               the USTAR format. Full compliance requires user name and
  ///               group name fields to be set.
  /// 263   | 265 | Version. "00" for POSIX standard archives.
  /// 265   | 297 | User name, as null-terminated ASCII string.
  /// 297   | 329 | Group name, as null-terminated ASCII string.
  /// 329   | 337 | Major number for character or block device entry.
  /// 337   | 345 | Minor number for character or block device entry.
  /// 345   | 500 | Prefix. If the pathname is too long to fit in the 100 bytes
  ///               provided at the start, it can be split at any / character
  ///               with the first portion going here.
  /// 500   | 512 | NUL pad.
  ///
  /// Unused bytes are set to NUL ('\x00')s
  ///
  /// User and group names should be used in preference to uid/gid values when
  /// they are set and the corresponding names exist on the system.
  ///
  /// While this format is compatible with most tar readers, the format has
  /// several limitations making it unsuitable for some usages. Most notably, it
  /// cannot support sparse files, files larger than 8GiB, filenames larger than
  /// 256 characters, and non-ASCII filenames.
  ///
  /// Reference:
  /// https://www.freebsd.org/cgi/man.cgi?query=tar&sektion=5&format=html
  /// https://www.gnu.org/software/tar/manual/html_chapter/tar_15.html#SEC188
  ///	http://pubs.opengroup.org/onlinepubs/9699919799/utilities/pax.html#tag_20_92_13_06
  static const USTAR = TarFormat._internal(2);

  /// PAX header format defined in POSIX.1-2001.
  ///
  /// PAX extends USTAR by writing a special file with either the [typeXHeader]
  /// or [typeXGlobalHeader] type flags to allow for attributes that are not
  /// conveniently stored in a POSIX ustar archive to be held.
  ///
  /// For more information on the entires that can be stored, see [parsePAX].
  ///
  /// Some newer formats add their own extensions to PAX by defining their
  /// own keys and assigning certain semantic meaning to the associated values.
  /// For example, sparse file support in PAX is implemented using keys
  /// defined by the GNU manual (e.g., "GNU.sparse.map").
  ///
  /// Reference:
  /// https://www.freebsd.org/cgi/man.cgi?query=tar&sektion=5&format=html
  /// https://www.gnu.org/software/tar/manual/html_chapter/tar_15.html#SEC188
  /// http://cdrtools.sourceforge.net/private/man/star/star.4.html
  ///	http://pubs.opengroup.org/onlinepubs/009695399/utilities/pax.html
  static const PAX = TarFormat._internal(4);

  /// GNU header format.
  ///
  /// The GNU header format is older than the USTAR and PAX standards and
  /// is not compatible with them. The GNU format supports
  /// arbitrary file sizes, filenames of arbitrary encoding and length,
  /// sparse files, and other features.
  ///
  /// Start | End | Field
  /// =========================================================================
  /// 0     | 100 | Path name, stored as null-terminated string.
  /// 100   | 108 | File mode, stored as an octal number in ASCII.
  /// 108   | 116 | User id of owner, as octal number in ASCII.
  /// 116   | 124 | Group id of owner, as octal number in ASCII.
  /// 124   | 136 | Size of file, as octal number in ASCII.
  /// 136   | 148 | Modification time of file, number of seconds from epoch,
  ///               stored as an octal number in ASCII.
  /// 148   | 156 | Header checksum, stored as an octal number in ASCII. See
  ///               [computeUnsignedChecksum] for more details.
  /// 156   | 157 | Type flag, determines the kind of header.
  ///               Note that the meaning of the size field depends on the type.
  /// 157   | 257 | Link name, stored as a string.
  /// 257   | 263 | Contains the magic value "ustar " to indicate that this is
  ///               the GNU format.
  /// 263   | 265 | Version. " \x00" for POSIX standard archives.
  /// 265   | 297 | User name, as null-terminated ASCII string.
  /// 297   | 329 | Group name, as null-terminated ASCII string.
  /// 329   | 337 | Major number for character or block device entry.
  /// 337   | 345 | Minor number for character or block device entry.
  /// 345   | 357 | Last Access time of file, number of seconds from epoch,
  ///               stored as an octal number in ASCII.
  /// 357   | 369 | Last Changed time of file, number of seconds from epoch,
  ///               stored as an octal number in ASCII.
  /// 369   | 381 | Offset - not used.
  /// 381   | 385 | Longnames - deprecated
  /// 385   | 386 | Unused.
  /// 386   | 482 | Sparse data - 4 sets of (offset, numbytes) stored as
  ///               octal numbers in ASCII.
  /// 482   | 483 | isExtended - if this field is non-zero, this header is
  ///               followed by  additional sparse records, which are in the
  ///               same format as above.
  /// 483   | 495 | Binary representation of the file's complete size, inclusive
  ///               of the sparse data.
  /// 495   | 512 | NUL pad.
  ///
  /// It is recommended that PAX be chosen over GNU unless the target
  /// application can only parse GNU formatted archives.
  ///
  /// Reference:
  ///	https://www.gnu.org/software/tar/manual/html_node/Standard.html
  static const GNU = TarFormat._internal(8);

  /// Schily's TAR format, which is incompatible with USTAR.
  /// This does not cover STAR extensions to the PAX format; these fall under
  /// the PAX format.
  ///
  /// Start | End | Field
  /// =========================================================================
  /// 0     | 100 | Path name, stored as null-terminated string.
  /// 100   | 108 | File mode, stored as an octal number in ASCII.
  /// 108   | 116 | User id of owner, as octal number in ASCII.
  /// 116   | 124 | Group id of owner, as octal number in ASCII.
  /// 124   | 136 | Size of file, as octal number in ASCII.
  /// 136   | 148 | Modification time of file, number of seconds from epoch,
  ///               stored as an octal number in ASCII.
  /// 148   | 156 | Header checksum, stored as an octal number in ASCII. See
  ///               [computeUnsignedChecksum] for more details.
  /// 156   | 157 | Type flag, determines the kind of header.
  ///               Note that the meaning of the size field depends on the type.
  /// 157   | 257 | Link name, stored as a string.
  /// 257   | 263 | Contains the magic value "ustar\x00" to indicate that this is
  ///               the GNU format.
  /// 263   | 265 | Version. "00" for STAR archives.
  /// 265   | 297 | User name, as null-terminated ASCII string.
  /// 297   | 329 | Group name, as null-terminated ASCII string.
  /// 329   | 337 | Major number for character or block device entry.
  /// 337   | 345 | Minor number for character or block device entry.
  /// 345   | 476 | Prefix. If the pathname is too long to fit in the 100 bytes
  ///               provided at the start, it can be split at any / character
  ///               with the first portion going here.
  /// 476   | 488 | Last Access time of file, number of seconds from epoch,
  ///               stored as an octal number in ASCII.
  /// 488   | 500 | Last Changed time of file, number of seconds from epoch,
  ///               stored as an octal number in ASCII.
  /// 500   | 508 | NUL pad.
  /// 508   | 512 | Trailer - "tar\x00".
  ///
  /// Reference:
  /// http://cdrtools.sourceforge.net/private/man/star/star.4.html
  static const STAR = TarFormat._internal(16);
}

/// A [TarHeader] represents a single header in a tar archive.
/// Some fields may not be populated.
@sealed
class TarHeader {
  /// Type of header entry.
  TypeFlag typeFlag;

  /// Name of file entry.
  String name;

  /// Target name of link (valid for hard links or symbolic links).
  String linkName;

  /// Permission and mode bits.
  int mode;

  /// User ID of owner.
  int userId;

  /// Group ID of owner.
  int groupId;

  /// User name of owner.
  String userName;

  /// Group name of owner.
  String groupName;

  /// Logical file size in bytes.
  int size;

  /// The time of the last change to the data of the TAR file.
  DateTime modified;

  /// The time of the last access to the data of the TAR file.
  DateTime accessed;

  /// The time of the last change to the data or metadata of the TAR file.
  DateTime changed;

  /// Major device number
  int devMajor;

  /// Minor device number
  int devMinor;

  /// Map of PAX extended records.
  Map<String, String> paxRecords = {};

  /// The TAR format of the header.
  TarFormat format;

  factory TarHeader(List<int> rawHeader) {
    ArgumentError.checkNotNull(rawHeader, 'rawHeader');
    RangeError.checkValueInInterval(rawHeader.length, blockSize, blockSize);

    TarHeader header;
    try {
      var format = _getFormat(rawHeader);

      final name = parseString(rawHeader, 0, 100);
      final mode = parseOctal(rawHeader, 100, 108);
      final userId = parseOctal(rawHeader, 108, 116);
      final groupId = parseOctal(rawHeader, 116, 124);
      final size = parseOctal(rawHeader, 124, 136);
      final modified = secondsSinceEpoch(parseOctal(rawHeader, 136, 148));
      final typeFlag = typeflagFromByte(rawHeader[156]);
      final linkName = parseString(rawHeader, 157, 257);

      header = TarHeader.internal(
          name: name,
          mode: mode,
          userId: userId,
          groupId: groupId,
          size: size,
          modified: modified,
          typeFlag: typeFlag,
          linkName: linkName);

      if (header.hasContent && size < 0) {
        headerException('Header indicates an invalid size of "$size"');
      }

      if (format._value > TarFormat.V7._value) {
        /// If it is a valid header that is not of the V7 format, it will have
        /// the USTAR fields.
        _populateUstarFields(header, rawHeader);

        /// Prefix to the file name
        var prefix = '';

        if (format.has(TarFormat.USTAR | TarFormat.PAX)) {
          header.format = format;
          prefix = parseString(rawHeader, 345, 500);

          /// For Format detection, check if block is properly formatted since
          /// the parser is more liberal than what USTAR actually permits.
          if (rawHeader.where(isNotAscii).isNotEmpty) {
            headerException('Non-ASCII characters detected in block');
          }

          /// Checks size, mode, userId, groupId, lastModifiedTime, devMajor, and
          /// devMinor to ensure they end in NUL
          if (!(isNul(rawHeader[135]) && // size
              isNul(rawHeader[107]) && // mode
              isNul(rawHeader[115]) && // userId
              isNul(rawHeader[123]) && // groupId
              isNul(rawHeader[147]) && // modified
              isNul(rawHeader[336]) && // devMajor && devMinor
              isNul(rawHeader[344]))) {
            headerException('Found a numeric field that does not end in NUL');
          }
        } else if (format.has(TarFormat.STAR)) {
          prefix = parseString(rawHeader, 345, 476);
          header.accessed =
              secondsSinceEpoch(parseNumeric(rawHeader, 476, 488));
          header.changed = secondsSinceEpoch(parseNumeric(rawHeader, 488, 500));
        } else if (format.has(TarFormat.GNU)) {
          header.format = format;

          if (!isNul(rawHeader[345])) {
            header.accessed =
                secondsSinceEpoch(parseNumeric(rawHeader, 345, 357));
          }

          if (!isNul(rawHeader[357])) {
            header.changed =
                secondsSinceEpoch(parseNumeric(rawHeader, 357, 369));
          }
        }

        if (prefix.isNotEmpty) {
          header.name = '$prefix/${header.name}';
        }
      }
    } catch (e) {
      headerException('Invalid Header');
    }
    return header;
  }

  /// This constructor is meant to help us deal with header-only headers (i.e.
  /// meta-headers that only describe the next file instead of being a header
  /// to files themselves)
  TarHeader.internal(
      {this.name,
      this.modified,
      this.linkName = '',
      this.mode = 0,
      this.size = 0,
      this.userName = '',
      this.userId = 0,
      this.groupId = 0,
      this.groupName = '',
      this.accessed,
      this.changed,
      this.devMajor = 0,
      this.devMinor = 0,
      this.paxRecords,
      this.format,
      this.typeFlag}) {
    paxRecords ??= {};
  }

  /// Checks if this header indicates that the file will have content.
  bool get hasContent {
    switch (typeFlag) {
      case TypeFlag.link:
      case TypeFlag.symlink:
      case TypeFlag.block:
      case TypeFlag.dir:
      case TypeFlag.char:
      case TypeFlag.fifo:
        return false;
      default:
        return true;
    }
  }

  /// Merges [paxHeaders] into the relevant fields.
  void mergePAX(Map<String, String> paxHeaders) {
    for (final entry in paxHeaders.entries) {
      if (entry.value == '') {
        continue; // Keep the original USTAR value
      }

      try {
        switch (entry.key) {
          case paxPath:
            name = entry.value;
            break;
          case paxLinkpath:
            linkName = entry.value;
            break;
          case paxUname:
            userName = entry.value;
            break;
          case paxGname:
            groupName = entry.value;
            break;
          case paxUid:
            userId = int.parse(entry.value, radix: 10);
            break;
          case paxGid:
            groupId = int.parse(entry.value, radix: 10);
            break;
          case paxAtime:
            accessed = parsePAXTime(entry.value);
            break;
          case paxMtime:
            modified = parsePAXTime(entry.value);
            break;
          case paxCtime:
            changed = parsePAXTime(entry.value);
            break;
          case paxSize:
            size = int.parse(entry.value, radix: 10);
            break;
          default:
            break;
        }
      } catch (e) {
        headerException('Invalid PAX header entry "${entry.key}: '
            '${entry.value}"!');
      }
    }

    paxRecords = paxHeaders;
  }

  @override
  bool operator ==(other) {
    if (other is! TarHeader) return false;
    final otherHeader = other as TarHeader;

    return name == otherHeader.name &&
        modified == otherHeader.modified &&
        linkName == otherHeader.linkName &&
        mode == otherHeader.mode &&
        size == otherHeader.size &&
        userName == otherHeader.userName &&
        userId == otherHeader.userId &&
        groupId == otherHeader.groupId &&
        groupName == otherHeader.groupName &&
        accessed == otherHeader.accessed &&
        changed == otherHeader.changed &&
        devMajor == otherHeader.devMajor &&
        devMinor == otherHeader.devMinor &&
        MapEquality().equals(paxRecords, otherHeader.paxRecords) &&
        format == otherHeader.format &&
        typeFlag == otherHeader.typeFlag;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        (modified.hashCode ?? 0) ^
        linkName.hashCode ^
        mode ^
        size ^
        userName.hashCode ^
        userId ^
        groupId ^
        groupName.hashCode ^
        (accessed.hashCode ?? 0) ^
        (changed.hashCode ?? 0) ^
        devMajor ^
        devMinor ^
        MapEquality().hash(paxRecords) ^
        (format.hashCode ?? 0) ^
        typeFlag.hashCode;
  }

  @override
  String toString() {
    return 'Name: $name\n'
        'lastModifiedTime: $modified\n'
        'linkName: $linkName\n'
        'Mode: $mode\n'
        'Size: $size\n'
        'Username: $userName\n'
        'UserId: $userId\n'
        'GroupId: $groupId\n'
        'GroupName: $groupName\n'
        'AccessTime: $accessed\n'
        'ChangeTime: $changed\n'
        'DevMajor: $devMajor\n'
        'DevMinor: $devMinor\n'
        'PAXRecords: $paxRecords\n'
        'Format: $format\n'
        'LinkFlag: $typeFlag\n';
  }
}

/// Checks that [rawHeader] represents a valid tar header based on the
/// checksum, and then attempts to guess the specific format based
/// on magic values. If the checksum fails, then an error is thrown.
TarFormat _getFormat(List<int> rawHeader) {
  ArgumentError.checkNotNull(rawHeader, 'rawHeader');

  try {
    final checksum = parseOctal(rawHeader, 148, 156);

    /// Modern TAR archives use the unsigned checksum, but we check the signed
    /// checksum as well for compatibility.
    if (checksum != computeSignedCheckSum(rawHeader) &&
        checksum != computeUnsignedCheckSum(rawHeader)) {
      headerException('Checksum does not match');
    }

    final magic = String.fromCharCodes(rawHeader, 257, 263);
    final version = String.fromCharCodes(rawHeader, 263, 265);
    final trailer = String.fromCharCodes(rawHeader, 508, 512);
    if (magic == magicUSTAR && trailer == trailerSTAR) {
      return TarFormat.STAR;
    }

    if (magic == magicUSTAR) {
      return TarFormat.USTAR | TarFormat.PAX;
    }

    if (magic == magicGNU && version == versionGNU) {
      return TarFormat.GNU;
    }
  } catch (e) {
    headerException('Unable to determine format of Header');
  }
  return TarFormat.V7;
}

/// Populates [header] with USTAR fields.
///
/// These fields are common to all the header formats supported by our library
/// with the exception of the V7 header.
void _populateUstarFields(TarHeader header, List<int> rawHeader) {
  header.userName = parseString(rawHeader, 265, 297);
  header.groupName = parseString(rawHeader, 297, 329);
  header.devMajor = parseNumeric(rawHeader, 329, 337);
  header.devMinor = parseNumeric(rawHeader, 337, 345);
}
