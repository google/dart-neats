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

import 'constants.dart';
import 'exceptions.dart';
import 'format.dart';
import 'header.dart';
import 'utils.dart';

/// This class represents the internal representation of [TarHeader],
/// purposely split for convenience because the process of reading a tar header
/// requires us to update our guess multiple times, but we prefer the user
/// to receive an immutable version of a [TarHeader].
class TarHeaderImpl extends TarHeader {
  /// Type of header entry. In the V7 TAR format, this field was known as the
  /// link flag.
  @override
  TypeFlag typeFlag;

  /// Name of file or directory entry.
  @override
  String name;

  /// Target name of link (valid for hard links or symbolic links).
  @override
  String linkName;

  /// Permission and mode bits.
  @override
  int mode;

  /// User ID of owner.
  @override
  int userId;

  /// Group ID of owner.
  @override
  int groupId;

  /// User name of owner.
  @override
  String userName;

  /// Group name of owner.
  @override
  String groupName;

  /// Logical file size in bytes.
  @override
  int size;

  /// The time of the last change to the data of the TAR file.
  @override
  DateTime modified;

  /// The time of the last access to the data of the TAR file.
  @override
  DateTime accessed;

  /// The time of the last change to the data or metadata of the TAR file.
  @override
  DateTime changed;

  /// Major device number
  @override
  int devMajor;

  /// Minor device number
  @override
  int devMinor;

  /// Map of PAX extended records.
  @override
  Map<String, String> paxRecords = {};

  /// The TAR format of the header.
  @override
  TarFormat format;

  /// This constructor is meant to help us deal with header-only headers (i.e.
  /// meta-headers that only describe the next file instead of being a header
  /// to files themselves)
  TarHeaderImpl.internal(
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

  factory TarHeaderImpl(List<int> rawHeader) {
    ArgumentError.checkNotNull(rawHeader, 'rawHeader');
    RangeError.checkValueInInterval(rawHeader.length, blockSize, blockSize);

    TarHeaderImpl header;
    var format = _getFormat(rawHeader);

    final name = parseString(rawHeader, 0, 100);
    final mode = tryParseOctal(rawHeader, 'Mode', 100, 108);
    final userId = tryParseOctal(rawHeader, 'User ID', 108, 116);
    final groupId = tryParseOctal(rawHeader, 'Group ID', 116, 124);
    final size = tryParseOctal(rawHeader, 'Size', 124, 136);
    final modified = secondsSinceEpoch(
        tryParseOctal(rawHeader, 'Last Modified Time', 136, 148));
    final typeFlag = typeflagFromByte(rawHeader[156]);
    final linkName = parseString(rawHeader, 157, 257);

    header = TarHeaderImpl.internal(
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
      throw TarHeaderException('Header indicates an invalid size of "$size"');
    }

    if (format.isValid() && format != TarFormat.V7) {
      /// If it is a valid header that is not of the V7 format, it will have
      /// the USTAR fields.
      header.userName = parseString(rawHeader, 265, 297);
      header.groupName = parseString(rawHeader, 297, 329);
      header.devMajor = parseNumeric(rawHeader, 329, 337);
      header.devMinor = parseNumeric(rawHeader, 337, 345);

      /// Prefix to the file name
      var prefix = '';

      if (format.has(TarFormat.USTAR | TarFormat.PAX)) {
        header.format = format;
        prefix = parseString(rawHeader, 345, 500);

        /// Check if block is properly formatted since the parser is more
        /// liberal than what USTAR actually permits.
        if (rawHeader.where(isNotAscii).isNotEmpty) {
          format.mayOnlyBe(TarFormat.PAX);
        }

        /// Checks size, mode, userId, groupId, lastModifiedTime, devMajor, and
        /// devMinor to ensure they end in NUL
        if (!(isNulOrSpace(rawHeader[135]) && // size
            isNulOrSpace(rawHeader[107]) && // mode
            isNulOrSpace(rawHeader[115]) && // userId
            isNulOrSpace(rawHeader[123]) && // groupId
            isNulOrSpace(rawHeader[147]) && // modified
            isNulOrSpace(rawHeader[336]) && // devMajor && devMinor
            isNulOrSpace(rawHeader[344]))) {
          throw TarHeaderException(
              'Found a numeric field that does not end in NUL');
        }
      } else if (format.has(TarFormat.STAR)) {
        prefix = parseString(rawHeader, 345, 476);
        header.accessed = secondsSinceEpoch(parseNumeric(rawHeader, 476, 488));
        header.changed = secondsSinceEpoch(parseNumeric(rawHeader, 488, 500));
      } else if (format.has(TarFormat.GNU)) {
        header.format = format;

        if (!isNul(rawHeader[345])) {
          header.accessed =
              secondsSinceEpoch(parseNumeric(rawHeader, 345, 357));
        }

        if (!isNul(rawHeader[357])) {
          header.changed = secondsSinceEpoch(parseNumeric(rawHeader, 357, 369));
        }
      }

      if (prefix.isNotEmpty) {
        header.name = '$prefix/${header.name}';
      }
    }

    if (!validateTypeFlag(header.typeFlag, header.format)) {
      throw TarHeaderException('Invalid Header');
    }

    return header;
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
        throw TarHeaderException('Invalid PAX header entry "${entry.key}: '
            '${entry.value}"!');
      }
    }

    paxRecords = paxHeaders;
  }
}

/// Checks that [rawHeader] represents a valid tar header based on the
/// checksum, and then attempts to guess the specific format based
/// on magic values. If the checksum fails, then an error is thrown.
TarFormat _getFormat(List<int> rawHeader) {
  ArgumentError.checkNotNull(rawHeader, 'rawHeader');

  final checksum = tryParseOctal(rawHeader, 'Checksum', 148, 156);

  /// Modern TAR archives use the unsigned checksum, but we check the signed
  /// checksum as well for compatibility.
  if (checksum != computeSignedCheckSum(rawHeader) &&
      checksum != computeUnsignedCheckSum(rawHeader)) {
    throw TarHeaderException('Checksum does not match');
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

  return TarFormat.V7;
}
