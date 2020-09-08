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
import 'format.dart';
import 'utils.dart';

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
          format: format,
          linkName: linkName);

      if (header.hasContent && size < 0) {
        headerException('Header indicates an invalid size of "$size"');
      }

      if (format.isValid() && format != TarFormat.V7) {
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

    if (!validateTypeFlag(header.typeFlag, header.format)) {
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
