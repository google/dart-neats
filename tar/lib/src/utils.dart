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
import 'dart:convert';
import 'dart:math';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:tar/src/header.dart';

import 'constants.dart';
import 'exceptions.dart';
import 'sparse_entry.dart';

/// Parses the sublist of [bytes] from [start] to [end] as a String. First it
/// checks if it is utf8-encoded, and if that fails, we revert to reading it
/// byte by byte.
String parseString(List<int> bytes, [int start, int end]) {
  ArgumentError.checkNotNull(bytes, 'bytes');

  start ??= 0;
  end ??= bytes.length;

  RangeError.checkValidIndex(start, bytes);
  RangeError.checkValidIndex(end - 1, bytes);

  final rawCharCodes = bytes.sublist(start, end);

  final stringEnd = rawCharCodes.indexOf(NUL);
  final charCodes = rawCharCodes.sublist(0, stringEnd == -1 ? null : stringEnd);

  try {
    return utf8.decode(charCodes);
  } on FormatException {
    return String.fromCharCodes(charCodes).trim();
  }
}

/// Parses [bytes] as being encoded in either base-256 or octal.
/// This function may return negative numbers.
///
/// Returns 0 if [bytes] is empty.
int parseNumeric(List<int> bytes, [int start, int end]) {
  ArgumentError.checkNotNull(bytes, 'bytes');

  if (bytes.isEmpty) return 0;

  start ??= 0;
  end ??= bytes.length;

  RangeError.checkValidIndex(start, bytes);
  RangeError.checkValidIndex(end - 1, bytes);

  /// Check for base-256 (binary) format first.
  /// If the first bit is set, then all following bits constitute a two's
  /// complement encoded number in big-endian byte order.
  if (bytes[start] & 0x80 != 0) {
    /// Handling negative numbers relies on the following identity:
    /// -a-1 == ~a
    ///
    /// If the number is negative, we use an inversion mask to invert the
    /// date bytes and treat the value as an unsigned number.
    final inverseMask = bytes[start] & 0x40 != 0 ? 0xff : 0x00;

    var x = 0;

    for (var i = start; i < end; i++) {
      var byte = bytes[i];
      byte ^= inverseMask;
      if (i == start) {
        byte &= 0x7f;

        /// Ignore signal bit in first byte
      }

      if (x.bitLength + 1 > 56) {
        throw ArgumentError.value(bytes, 'input', 'Integer overflow');
      }
      x = x << 8 | byte;
    }

    if (x.bitLength > 63 + 1) {
      throw ArgumentError.value(bytes, 'input', 'Integer overflow');
    }

    return inverseMask == 0xff ? ~x : x;
  }

  return parseOctal(bytes, start, end);
}

/// Parse an octal string encoded in the sublist of [bytes] from index [start]
/// to index [end].
///
/// If [start] is not provided, it defaults to 0.
/// If [end] is not provided, it defaults to [bytes.length].
int parseOctal(List<int> bytes, [int start, int end]) {
  ArgumentError.checkNotNull(bytes, 'bytes');

  if (bytes.isEmpty) return 0;

  /// Because unused fields are filled with NULs, we need to skip leading NULs.
  /// Fields may also be padded with spaces or NULs.
  /// So we remove leading and trailing NULs and spaces to be sure.
  var left = start ?? 0;
  var right = end ?? bytes.length;

  RangeError.checkValidIndex(left, bytes);
  RangeError.checkValidIndex(right - 1, bytes);

  while (left < right && (bytes[left] == SPACE || bytes[left] == NUL)) {
    left++;
  }

  while (
      right > left && (bytes[right - 1] == SPACE || bytes[right - 1] == NUL)) {
    right--;
  }

  if (bytes.isEmpty || left == right) return 0;

  final octalString = parseString(bytes, left, right);
  return int.parse(octalString, radix: 8);
}

/// Tries to parse an octal string representing [field] encoded in the sublist
/// of [bytes] from index [start] to index [end], throwing a
/// [TarHeaderException] if the oepration fails.
///
/// If [start] is not provided, it defaults to 0.
/// If [end] is not provided, it defaults to [bytes.length].
int tryParseOctal(List<int> bytes, String field, [int start, int end]) {
  /// Because unused fields are filled with NULs, we need to skip leading NULs.
  /// Fields may also be padded with spaces or NULs.
  /// So we remove leading and trailing NULs and spaces to be sure.
  var left = start ?? 0;
  var right = end ?? bytes.length;
  var result = 0;

  try {
    result = parseOctal(bytes, left, right);
  } on RangeError {
    throw createHeaderException(
        'Failed to parse the "$field" field from the raw header. '
        '[$left, $right] is not in [0, ${bytes.length}]');
  } on FormatException {
    throw createHeaderException(
        'Failed to parse the "$field" field from the raw header. Bytes '
        '${bytes.sublist(left, right)} from indices [$left, $right] do not '
        'produce a parsable radix-8 string.');
  }

  return result;
}

/// Takes a [paxTimeString] of the form %d.%d as described in the PAX
/// specification. Note that this implementation allows for negative timestamps,
/// which is allowed for by the PAX specification, but not always portable.
///
/// Note that Dart's [DateTime] class only allows us to give up to microsecond
/// precision, which implies that we cannot parse all the digits in since PAX
/// allows for nanosecond level encoding.
DateTime parsePAXTime(String paxTimeString) {
  ArgumentError.checkNotNull(paxTimeString, 'paxTimeString');

  const maxMicroSecondDigits = 6;

  /// Split [paxTimeString] into seconds and sub-seconds parts.
  var secondsString = paxTimeString;
  var microSecondsString = '';
  final position = paxTimeString.indexOf('.');
  if (position >= 0) {
    secondsString = paxTimeString.substring(0, position);
    microSecondsString = paxTimeString.substring(position + 1);
  }

  /// Parse the seconds.
  final seconds = int.tryParse(secondsString);
  if (seconds == null) {
    throw createHeaderException('Invalid PAX time $paxTimeString detected!');
  }

  if (microSecondsString.replaceAll(RegExp('[0-9]'), '') != '') {
    throw createHeaderException(
        'Invalid nanoseconds $microSecondsString detected');
  }

  microSecondsString = microSecondsString.padRight(maxMicroSecondDigits, '0');
  microSecondsString = microSecondsString.substring(0, maxMicroSecondDigits);

  var microSeconds =
      microSecondsString.isEmpty ? 0 : int.parse(microSecondsString);
  if (paxTimeString.startsWith('-')) microSeconds = -microSeconds;

  return microsecondsSinceEpoch(microSeconds + seconds * pow(10, 6));
}

/// [_blockPadding] computes the number of bytes needed to pad offset up to the
/// nearest block edge where 0 <= n < [blockSize].
int blockPadding(int offset) {
  ArgumentError.checkNotNull(offset, 'offset');

  return -offset & (blockSize - 1);
}

/// Returns the number of blocks needed to capture [size] bytes.
int numBlocks(int size) {
  ArgumentError.checkNotNull(size, 'size');
  RangeError.checkNotNegative(size);
  return (size / blockSize).ceil();
}

/// Parses PAX extended headers.
///
/// The extended attributes are stored in UTF-8 encoded lines:
///    `'size key=value\n'`
///
/// Numeric values are stored in decimal, rather than octal formats.
///
/// Values stored in extended attributes override the corresponding values in
/// the TAR header.
///
/// If an extended header (type 'x') is invalid, throw [TarHeaderException].
Map<String, String> parsePAX(List<int> paxHeaders) {
  ArgumentError.checkNotNull(paxHeaders, 'paxHeaders');
  var currentIndex = 0;

  /// For GNU PAX sparse format 0.0 support.
  /// This function transforms the sparse format 0.0 headers into format 0.1
  /// headers since 0.0 headers were not PAX compliant.
  final sparseMap = <String>[];

  /// PAX Headers
  final attributes = <String, String>{};

  while (currentIndex < paxHeaders.length - 1) {
    /// The size field ends at the first space.
    final space = paxHeaders.indexOf(SPACE, currentIndex);
    if (space == -1) break;

    // Parse the first token as a decimal integer
    final recordBytes = paxHeaders.sublist(currentIndex, space);
    final recordLength = int.tryParse(String.fromCharCodes(recordBytes));
    if (recordLength == null ||
        recordLength < 5 ||
        paxHeaders.length - currentIndex < recordLength) {
      throw createHeaderException('Invalid PAX Record');
    }

    final record = paxHeaders.sublist(space + 1, currentIndex + recordLength);
    final newLine = paxHeaders[currentIndex + recordLength - 1];
    currentIndex += recordLength;

    if (newLine != NEWLINE) {
      throw createHeaderException('PAX Record contains invalid length');
    }

    final equals = record.indexOf(EQUALS);
    if (equals == -1) {
      throw createHeaderException('Unable to find "=" in PAX Record');
    }

    /// Opting to not use [parseString] here because we want to preserve
    /// final null bytes.

    final key = utf8.decode(record.sublist(0, equals));

    /// The -1 accounts for the equals sign.
    final value = utf8.decode(record.sublist(equals + 1, record.length - 1));

    if (!isValidPAXRecord(key, value)) {
      throw createHeaderException(
          'Invalid key/value combination in PAX Record');
    }

    if (key == paxGNUSparseNumBytes || key == paxGNUSparseOffset) {
      if ((sparseMap.length % 2 == 0 && key != paxGNUSparseOffset) ||
          (sparseMap.length % 2 == 1 && key != paxGNUSparseNumBytes) ||
          value.contains(',')) {
        throw createHeaderException('Invalid PAX Record');
      }

      sparseMap.add(value);
    } else {
      attributes[key] = value;
    }
  }

  if (sparseMap.isNotEmpty) {
    attributes[paxGNUSparseMap] = sparseMap.join(',');
  }

  return attributes;
}

/// Validates that the [key]-[value] pair forms a valid PAX record entry.
bool isValidPAXRecord(String key, String value) {
  ArgumentError.checkNotNull(key, 'key');
  ArgumentError.checkNotNull(value, 'value');

  if (key.isEmpty || key.contains('=')) {
    return false;
  }

  switch (key) {
    case paxPath:
    case paxLinkpath:
    case paxUname:
    case paxGname:
      return !hasNUL(value);
    default:
      return !hasNUL(key);
  }
}

/// Reports if the NUL character exists within [string].
bool hasNUL(String string) => string.contains('\x00');

/// Formats a single PAX record, prefixing it with the appropriate length.
String formatPAXRecord(String key, String value) {
  ArgumentError.checkNotNull(key, 'key');
  ArgumentError.checkNotNull(value, 'value');

  if (!isValidPAXRecord(key, value)) {
    throw createHeaderException('Invalid PAX Record');
  }

  const padding = 3; // Extra padding for ' ', '=', and '\n'
  /// Count the length of key and value in bytes, and add that to padding for
  /// an estimate of size.
  var size = getByteLength('$key$value') + padding;
  size += '$size'.length;

  var record = '$size $key=$value\n';

  /// Final adjustment if adding size field increased the record size
  if (getByteLength(record) != size) {
    size = getByteLength(record);
    record = '$size $key=$value\n';
  }

  return record;
}

/// Returns the length of the utf8 encoding of [string].
int getByteLength(String string) {
  ArgumentError.checkNotNull(string, 'string');
  return utf8.encode(string).length;
}

/// Converts time into a form as described in the PAX specification. This
/// function is capable of negative timestamps.
String formatPAXTime(DateTime dateTime) {
  ArgumentError.checkNotNull(dateTime, 'dateTime');

  final microseconds = dateTime.microsecondsSinceEpoch;
  if (microseconds % 1e6 == 0) {
    return (microseconds / 1e6).round().toString();
  }

  return (microseconds / 1e6).toString();
}

/// Reports whether [x] fits in a field [n]-bytes long using octal encoding
/// with the appropriate NUL terminator.
bool fitsInOctal(int n, int x) {
  ArgumentError.checkNotNull(x, 'x');
  ArgumentError.checkNotNull(n, 'n');

  return x >= 0 && (n >= 22 || x < 1 << (n - 1) * 3);
}

/// Reports whether [x] can be encoded into [n] bytes using base-256 encoding.
/// Unlike octal encoding, base-256 encoding does not require that the string
/// ends with a NUL character. Thus, all n bytes are available for output.
///
/// If operating in binary mode, this assumes strict GNU binary mode; which
/// means that the first byte can only be either 0x80 or 0xff. Thus, the first
/// byte is equivalent to the sign bit in two's complement form.
bool fitsInBase256(int n, int x) {
  ArgumentError.checkNotNull(x, 'x');
  ArgumentError.checkNotNull(n, 'n');

  return (x.bitLength) / 8 + 1 <= n;
}

/// Encodes [x] into a [length]-sized byte array using base-8 (octal) encoding
/// if possible, otherwise it will attempt to use base-256 (binary) encoding.
List<int> formatNumeric(int x, int length) {
  ArgumentError.checkNotNull(x, 'x');
  ArgumentError.checkNotNull(length, 'length');

  if (fitsInOctal(length, x)) return formatOctal(x, length);

  if (fitsInBase256(length, x)) {
    final result = List<int>.filled(length, 0);

    for (var i = length - 1; i >= 0; i--) {
      result[i] = x % 256;
      x >>= 8;
    }

    result[0] |= 0x80;
    return result;
  }

  throw ArgumentError('Unable to fit $x in $length bytes');
}

/// Encodes [x] into a [length]-sized byte array using base-8 (octal) encoding.
List<int> formatOctal(int x, int length) {
  ArgumentError.checkNotNull(x, 'x');
  ArgumentError.checkNotNull(length, 'length');

  final octalString = x.toRadixString(8);
  final charCodes = octalString.codeUnits;

  for (final charCode in charCodes) {
    if (charCode > 255 || charCode < 0) {
      throw AssertionError('Failed to format $x into an octal string');
    }
  }

  final remainingLength = length - 1 - charCodes.length;

  return [...List<int>.filled(remainingLength, 48), ...charCodes, 0];
}

/// Reports whether [sparseEntries] is a valid sparse map.
/// It does not matter whether [sparseEntries] represents data fragments or
/// hole fragments.
bool validateSparseEntries(List<SparseEntry> sparseEntries, int size) {
  ArgumentError.checkNotNull(sparseEntries, 'sparseEntries');
  ArgumentError.checkNotNull(size, 'size');

  /// Validate all sparse entries. These are the same checks as performed by
  /// the BSD tar utility.
  if (size < 0) return false;

  SparseEntry previous;

  for (final current in sparseEntries) {
    /// Negative values are never okay.
    if (current.offset < 0 || current.length < 0) return false;

    /// Integer overflow with large length.
    if (current.offset > int64MaxValue - current.length) return false;

    /// Region extends beyond the actual size.
    if (current.end > size) return false;

    /// Regions cannot overlap and must be in order.
    if (previous != null && previous.end > current.offset) return false;

    previous = current;
  }

  return true;
}

/// Returns a [List<SparseEntry>] where each fragment's starting offset is aligned
/// up to the nearest block edge, and each ending offset is aligned down to the
/// nearest block edge.
///
/// Even though the Dart tar Reader and the BSD tar utility can handle entries
/// with arbitrary offsets and lengths, the GNU tar utility can only handle
/// offsets and lengths that are multiples of [blockSize].
List<SparseEntry> alignSparseEntries(List<SparseEntry> source, int size) {
  ArgumentError.checkNotNull(source, 'source');
  ArgumentError.checkNotNull(size, 'size');

  final result = <SparseEntry>[];

  for (final sparseEntry in source) {
    var position = sparseEntry.offset;
    var end = sparseEntry.end;

    /// Round up to nearest [blockSize]
    position = numBlocks(position) * blockSize;

    if (end != size) {
      /// Round down to nearest [blockSize]
      end = (end / blockSize).floor() * blockSize;
    }

    if (position < end) {
      result.add(SparseEntry(position, end - position));
    }
  }
  return result;
}

/// Converts a sparse map ([source]) from one form to the other.
/// If the input is sparse holes, then it will output sparse datas and
/// vice-versa. The input must have been already validated.
///
/// This function mutates src and returns a normalized map where:
///	* adjacent fragments are coalesced together
///	* only the last fragment may be empty
///	* the endOffset of the last fragment is the total size
List<SparseEntry> invertSparseEntries(List<SparseEntry> source, int size) {
  ArgumentError.checkNotNull(source, 'source');
  ArgumentError.checkNotNull(size, 'size');

  final result = <SparseEntry>[];
  var previous = SparseEntry(0, 0);
  for (final current in source) {
    /// Skip empty fragments
    if (current.length == 0) continue;

    final newLength = current.offset - previous.offset;
    if (newLength > 0) {
      result.add(SparseEntry(previous.offset, newLength));
    }

    previous = SparseEntry(current.end, 0);
  }
  final lastLength = size - previous.offset;
  result.add(SparseEntry(previous.offset, lastLength));
  return result;
}

/// Reports whether [fileMode] describes a regular file.
/// That is, it tests that no modetype bits are set.
bool isRegular(int fileMode) => fileMode & modeType == 0;

/// Reports whether [fileMode] describes a symbolic link.
bool isSymbolicLink(int fileMode) => fileMode & modeSymLink != 0;

/// Reports whether [fileMode] describes a device.
bool isDevice(int fileMode) => fileMode & modeDevice != 0;

/// Reports whether [fileMode] describes a char device.
bool isCharDevice(int fileMode) => fileMode & modeCharDevice != 0;

/// Reports whether [fileMode] describes a named pipe.
bool isNamedPipe(int fileMode) => fileMode & modeNamedPipe != 0;

/// Reports whether [fileMode] describes a socket.
bool isSocket(int fileMode) => fileMode & modeSocket != 0;

/// Reports whether [fileMode] describes being set to set uid.
bool isSetUid(int fileMode) => fileMode & modeSetUid != 0;

/// Reports whether [fileMode] describes being set to set gid.
bool isSetGid(int fileMode) => fileMode & modeSetGid != 0;

/// Reports whether [fileMode] describes being sticky.
bool isSticky(int fileMode) => fileMode & modeSticky != 0;

/// Calculates the total length of data recorded in [sparseData];
int countData(List<SparseEntry> sparseData) {
  ArgumentError.checkNotNull(sparseData, 'sparseData');
  return sparseData.fold(0, (value, element) => value + element.length);
}

int computeUnsignedCheckSum(List<int> rawHeader) {
  ArgumentError.checkNotNull(rawHeader, 'rawHeader');
  RangeError.checkValueInInterval(rawHeader.length, blockSize, blockSize);

  var result = 0;

  for (var i = 0; i < rawHeader.length; i++) {
    result += (i < 148 || i >= 156) ? rawHeader[i] : 32;
  }

  return result;
}

int computeSignedCheckSum(List<int> rawHeader) {
  ArgumentError.checkNotNull(rawHeader, 'rawHeader');
  RangeError.checkValueInInterval(rawHeader.length, blockSize, blockSize);

  var result = 0;

  for (var i = 0; i < rawHeader.length; i++) {
    result += (i < 148 || i >= 156) ? rawHeader[i].toSigned(8) : 32;
  }

  return result;
}

/// Convenience methods to help us get UTC time quickly.
DateTime secondsSinceEpoch(int seconds, {bool isUtc = true}) =>
    microsecondsSinceEpoch(seconds * pow(10, 6), isUtc: isUtc);

DateTime millisecondsSinceEpoch(int milliseconds, {bool isUtc = true}) =>
    microsecondsSinceEpoch(milliseconds * pow(10, 3), isUtc: isUtc);

DateTime microsecondsSinceEpoch(int microseconds, {bool isUtc = true}) {
  ArgumentError.checkNotNull(isUtc, 'isUTC');
  ArgumentError.checkNotNull(microseconds, 'microseconds');

  return DateTime.fromMicrosecondsSinceEpoch(microseconds, isUtc: isUtc);
}

bool isNotAscii(int i) => i > 128;

bool isNul(int byte) => byte == NUL;

bool isNulOrSpace(int byte) => isNul(byte) || byte == SPACE;

/// Creates a partially-populated [TarHeader] from [file].
/// If [file] describes a symbolic link, [fileInfoHeader] records the link
/// as the link target. If [fileStat] describes a directory, a slash is appended
/// to the name.
///
/// Since [FileStat]'s name method only returns the base name of
/// the file it describes, it may be necessary to modify [TarHeader.name]
/// to provide the full path name of the file.
TarHeader fileInfoHeader(File file, String link) {
  ArgumentError.checkNotNull(link, 'link');
  ArgumentError.checkNotNull(file, 'file');

  final fileStat = file.statSync();
  final fileMode = fileStat.mode;

  var header = TarHeader.internal(
      name: p.basename(file.path),
      modified: fileStat.modified,
      mode: fileStat.mode);

  if (isRegular(fileMode)) {
    header.typeFlag = TypeFlag.reg;
    header.size = fileStat.size;
  } else if (fileStat.type == FileSystemEntityType.directory) {
    header.typeFlag = TypeFlag.dir;
    header.name += '/';
  } else if (isSymbolicLink(fileMode)) {
    header.typeFlag = TypeFlag.symlink;
    header.linkName = link;
  } else if (isDevice(fileMode)) {
    header.typeFlag = isCharDevice(fileMode) ? TypeFlag.char : TypeFlag.block;
  } else if (isNamedPipe(fileMode)) {
    header.typeFlag = TypeFlag.fifo;
  } else if (isSocket(fileMode)) {
    throw createHeaderException('Sockets not supported!');
  } else {
    throw createHeaderException('Unknown file mode $fileMode');
  }

  if (isSetUid(fileMode)) header.mode |= c_ISUID;
  if (isSetGid(fileMode)) header.mode |= c_ISGID;
  if (isSticky(fileMode)) header.mode |= c_ISVTX;

  header.accessed = fileStat.accessed;
  header.changed = fileStat.changed;

  return header;
}

/// Process [sparseMaps], which is known to be a GNU v0.1 sparse map.
List<SparseEntry> processOldGNUSparseMap(List<List<int>> sparseMaps) {
  final sparseData = <SparseEntry>[];

  for (final sparseMap in sparseMaps) {
    final maxEntries = (sparseMap.length / 24).floor();
    for (var i = 0; i < maxEntries; i++) {
      // This termination condition is identical to GNU and BSD tar.
      if (sparseMap[i * 24] == 0) {
        // Don't return, need to process extended headers (even if empty)
        break;
      }

      final offset = parseNumeric(sparseMap, i * 24, i * 24 + 12);
      final length = parseNumeric(sparseMap, i * 24 + 12, (i + 1) * 24);

      sparseData.add(SparseEntry(offset, length));
    }
  }
  return sparseData;
}
