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

import 'package:chunked_stream/chunked_stream.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import 'constants.dart';
import 'exceptions.dart';
import 'format.dart';
import 'header.dart';
import 'sparse_entry.dart';
import 'stream.dart';
import 'utils.dart';

/// [TarReader] provides sequential access to the TAR files in a TAR archive.
/// It is designed to read from a stream and to spit out substreams for
/// individual file contents in order to minimize the amount of memory needed
/// to read each archive where possible.
@sealed
class TarReader {
  /// A chunked stream iterator to enable us to get our data 512 bytes at a time.
  final ChunkedStreamIterator<int> _chunkedStream;

  /// The [TarHeader] for the current file.
  TarHeader header;

  /// The current file contents.
  Stream<List<int>> contents;

  TarReader(Stream<List<int>> tarStream)
      : _chunkedStream = ChunkedStreamIterator(tarStream) {
    ArgumentError.checkNotNull(tarStream, 'tarStream');
  }

  /// Iterates through the TAR archive for the next file, returning `true` if
  /// such a file is found, and `false` otherwise.
  Future<bool> next() async {
    var paxHeaders = <String, String>{};
    var gnuLongName = '';
    var gnuLongLink = '';

    var format = TarFormat.USTAR |
        TarFormat.PAX |
        TarFormat.GNU |
        TarFormat.V7 |
        TarFormat.STAR;

    /// Externally, [next] iterates through the tar archive as if it is a series
    /// of files. Internally, the tar format often uses fake "files" to add meta
    /// data that describes the next file. These meta data "files" should not
    /// normally be visible to the outside. As such, this loop iterates through
    /// one or more "header files" until it finds a "normal file".
    while (true) {
      /// The discarding of the remainder of the previous file should
      /// already be handled by [ChunkedStreamIterator].
      var rawHeader = await _chunkedStream.read(blockSize);

      header = await _readHeader(rawHeader);
      if (header == null) return false;

      format = format.mayOnlyBe(header.format);

      /// Check for PAX/GNU special headers and files.
      if (header.typeFlag == TypeFlag.xHeader ||
          header.typeFlag == TypeFlag.xGlobalHeader) {
        format = format.mayOnlyBe(TarFormat.PAX);
        final rawPAXHeaders =
            await _chunkedStream.read(numBlocks(header.size) * blockSize);

        paxHeaders = parsePAX(rawPAXHeaders);
        if (header.typeFlag == TypeFlag.xGlobalHeader) {
          header.mergePAX(paxHeaders);
          header = TarHeader.internal(
            name: header.name,
            typeFlag: header.typeFlag,
            paxRecords: header.paxRecords,
            format: format,
          );

          return true;
        }

        /// This is a meta header affecting the next header.
        continue;
      } else if (header.typeFlag == TypeFlag.gnuLongLink ||
          header.typeFlag == TypeFlag.gnuLongName) {
        format = format.mayOnlyBe(TarFormat.GNU);
        final realName =
            await _chunkedStream.read(numBlocks(header.size) * blockSize);

        if (header.typeFlag == TypeFlag.gnuLongName) {
          gnuLongName = parseString(realName);
        } else {
          gnuLongLink = parseString(realName);
        }

        /// This is a meta header affecting the next header.
        continue;
      } else {
        // The old GNU sparse format is handled here since it is technically
        // just a regular file with additional attributes.
        header.mergePAX(paxHeaders);

        if (gnuLongName.isNotEmpty) header.name = gnuLongName;
        if (gnuLongLink.isNotEmpty) header.linkName = gnuLongLink;

        if (header.typeFlag == TypeFlag.regA) {
          /// Legacy archives use trailing slash for directories
          if (header.name.endsWith('/')) {
            header.typeFlag = TypeFlag.dir;
          } else {
            header.typeFlag = TypeFlag.reg;
          }
        }

        await _handleFile(header, rawHeader);

        /// Set the final guess at the format
        if (format != null &&
            format.has(TarFormat.USTAR) &&
            format.has(TarFormat.PAX)) {
          format = format.mayOnlyBe(TarFormat.USTAR);
        }
        header.format = format;

        return true;
      }
    }
  }

  /// Reads the next block header and assumes that the underlying reader
  /// is already aligned to a block boundary. It returns the raw block of the
  /// header in case further processing is required.
  ///
  /// EOF is hit when one of the following occurs:
  ///	* Exactly 0 bytes are read and EOF is hit.
  ///	* Exactly 1 block of zeros is read and EOF is hit.
  ///	* At least 2 blocks of zeros are read.
  Future<TarHeader> _readHeader(List<int> rawHeader) async {
    ArgumentError.checkNotNull(rawHeader, 'rawHeader');

    // Exactly 0 bytes are read and EOF is hit.
    if (rawHeader.isEmpty) return null;

    if (ListEquality().equals(rawHeader, zeroBlock)) {
      rawHeader = await _chunkedStream.read(blockSize);
      // Exactly 1 block of zeroes is read and EOF is hit.
      if (rawHeader.isEmpty) return null;

      if (ListEquality().equals(rawHeader, zeroBlock)) {
        /// Two blocks of zeros are read - Normal EOF.
        return null;
      }

      throw TarFileException('Encountered a non-zero block after a zero block');
    }

    return TarHeader(rawHeader);
  }

  /// Generates [_contents] according to the type of file.
  Future<void> _handleFile(TarHeader header, List<int> rawHeader) async {
    ArgumentError.checkNotNull(header, 'header');
    ArgumentError.checkNotNull(rawHeader, 'rawHeader');

    List<SparseEntry> sparseData;
    if (header.typeFlag == TypeFlag.gnuSparse) {
      sparseData = await _readOldGNUSparseMap(header, rawHeader);
    } else {
      sparseData = await _readGNUSparsePAXHeaders(header);
    }

    if (sparseData != null) {
      if (header.hasContent &&
          !validateSparseEntries(sparseData, header.size)) {
        headerException('Invalid sparse file header.');
      }

      final sparseHoles = invertSparseEntries(sparseData, header.size);
      final sparseDataCount = countData(sparseData);

      if (sparseDataCount > 0) {
        contents =
            _chunkedStream.substream(numBlocks(sparseDataCount) * blockSize);
        contents = sparseStream(contents, sparseHoles, header.size);
      }
    } else {
      var size = header.size;
      if (!header.hasContent) size = 0;

      if (size < 0) {
        headerException('Invalid size ($size) detected!');
      }

      if (size == 0) {
        contents = Stream<List<int>>.empty();
      } else {
        contents = ChunkedStreamIterator(
                _chunkedStream.substream(numBlocks(header.size) * blockSize))
            .substream(header.size);
      }
    }
  }

  /// Checks the PAX headers for GNU sparse headers.
  /// If they are found, then this function reads the sparse map and returns it.
  /// This assumes that 0.0 headers have already been converted to 0.1 headers
  /// by the PAX header parsing logic.
  Future<List<SparseEntry>> _readGNUSparsePAXHeaders(TarHeader header) async {
    ArgumentError.checkNotNull(header, 'header');

    /// Identify the version of GNU headers.
    var isVersion1 = false;
    final major = header.paxRecords[paxGNUSparseMajor];
    final minor = header.paxRecords[paxGNUSparseMinor];

    if (major == '0' && (minor == '0' || minor == '1') ||
        header.paxRecords[paxGNUSparseMap] != null &&
            header.paxRecords[paxGNUSparseMap].isNotEmpty) {
      isVersion1 = false;
    } else if (major == '1' && minor == '0') {
      isVersion1 = true;
    } else {
      return null;
    }

    header.format |= TarFormat.PAX;

    /// Update [header] from GNU sparse PAX headers.
    final possibleName = header.paxRecords[paxGNUSparseName] ?? '';
    if (possibleName.isNotEmpty) {
      header.name = possibleName;
    }

    var possibleSize = header.paxRecords[paxGNUSparseSize];
    possibleSize ??= header.paxRecords[paxGNUSparseRealSize];

    if (possibleSize.isNotEmpty) {
      final size = int.tryParse(possibleSize, radix: 10);
      if (size == null) {
        headerException('Invalid PAX size ($possibleSize) detected');
      }

      header.size = size;
    }

    /// Read the sparse map according to the appropriate format.
    if (isVersion1) {
      return await _readGNUSparseMap1x0();
    }

    return _readGNUSparseMap0x1();
  }

  /// Reads the sparse map as stored in GNU's PAX sparse format version 1.0.
  /// The format of the sparse map consists of a series of newline-terminated
  /// numeric fields. The first field is the number of entries and is always
  /// present. Following this are the entries, consisting of two fields
  /// (offset, length). This function must stop reading at the end boundary of
  /// the block containing the last newline.
  ///
  /// Note that the GNU manual says that numeric values should be encoded in
  /// octal format. However, the GNU tar utility itself outputs these values in
  /// decimal. As such, this library treats values as being encoded in decimal.
  Future<List<SparseEntry>> _readGNUSparseMap1x0() async {
    var newLineCount = 0;
    var block = <int>[];

    /// Ensures that [block] h as at least [n] tokens.
    void feedTokens(int n) async {
      while (newLineCount < n) {
        final newBlock = await _chunkedStream.read(blockSize);
        if (newBlock.isEmpty) {
          headerException('GNU Sparse Map does not have enough lines!');
        }

        block += newBlock;

        newLineCount += newBlock.where((byte) => byte == NEWLINE).length;
      }
    }

    /// Get the next token delimited by a newline. This assumes that
    /// at least one newline exists in the buffer.
    String nextToken() {
      newLineCount--;
      final nextNewLineIndex = block.indexOf(NEWLINE);
      final result = block.sublist(0, nextNewLineIndex);
      block.removeRange(0, nextNewLineIndex + 1);
      return parseString(result, 0, nextNewLineIndex);
    }

    /// Parse for the number of entries.
    /// Use integer overflow resistant math to check this.
    await feedTokens(1);

    final numEntriesString = nextToken();
    final numEntries = int.tryParse(numEntriesString);
    if (numEntries == null || numEntries < 0 || 2 * numEntries < numEntries) {
      headerException(
          'Invalid sparse map number of entries: $numEntriesString!');
    }

    /// Parse for all member entries.
    /// [numEntries] is trusted after this since a potential attacker must have
    /// committed resources proportional to what this library used.
    await feedTokens(2 * numEntries);

    final sparseData = <SparseEntry>[];

    for (var i = 0; i < numEntries; i++) {
      final offset = int.tryParse(nextToken());
      final length = int.tryParse(nextToken());

      if (offset == null || length == null) {
        headerException('Failed to read a GNU sparse map entry. Encountered '
            'offset: $offset, length: $length');
      }

      sparseData.add(SparseEntry(offset, length));
    }
    return sparseData;
  }

  /// Reads the sparse map as stored in GNU's PAX sparse format version 0.1.
  /// The sparse map is stored in the PAX headers.
  List<SparseEntry> _readGNUSparseMap0x1() {
    final paxRecords = header.paxRecords;

    /// Get number of entries.
    /// Use integer overflow resistant math to check this.
    final numEntriesString = paxRecords[paxGNUSparseNumBlocks];
    final numEntries = int.tryParse(numEntriesString);

    if (numEntries == null || numEntries < 0 || 2 * numEntries < numEntries) {
      headerException('Invalid GNU version 0.1 map');
    }

    /// There should be two numbers in [sparseMap] for each entry.
    var sparseMap = paxRecords[paxGNUSparseMap].split(',');
    if (sparseMap.length == 1 || sparseMap[0].isEmpty) {
      sparseMap = [sparseMap[0]];
    }
    if (sparseMap.length != 2 * numEntries) {
      headerException('Detected sparse map length ${sparseMap.length} '
          'that is not twice the number of entries $numEntries');
    }

    /// Loop through sparse map entries.
    /// [numEntries] is now trusted.
    final sparseData = <SparseEntry>[];
    for (var i = 0; i < sparseMap.length; i += 2) {
      final offset = int.tryParse(sparseMap[i]);
      final length = int.tryParse(sparseMap[i + 1]);

      if (offset == null || length == null) {
        headerException('Failed to read a GNU sparse map entry. Encountered '
            'offset: $offset, length: $length');
      }

      sparseData.add(SparseEntry(offset, length));
    }

    return sparseData;
  }

  /// Reads the sparse map from the old GNU sparse format.
  /// The sparse map is stored in the tar header if it's small enough.
  /// If it's larger than four entries, then one or more extension headers are
  /// used to store the rest of the sparse map.
  ///
  /// [header.size] does not reflect the size of any extended headers used.
  /// Thus, this function will read from the chunked stream iterator to fetch
  /// extra headers.
  Future<List<SparseEntry>> _readOldGNUSparseMap(
      TarHeader header, List<int> rawHeader) async {
    ArgumentError.checkNotNull(header, 'header');
    ArgumentError.checkNotNull(rawHeader, 'rawHeader');

    /// Make sure that the input format is GNU.
    /// Unfortunately, the STAR format also has a sparse header format that uses
    /// the same type flag but has a completely different layout.
    if (header.format != TarFormat.GNU) {
      headerException('Tried to read sparse map of non-GNU header');
    }

    try {
      header.size = parseNumeric(rawHeader, 483, 495);
    } on FormatException {
      headerException('Invalid real header size');
    }
    final sparseMaps = <List<int>>[];

    var sparse = rawHeader.sublist(386, 483);
    sparseMaps.add(sparse);

    while (true) {
      final maxEntries = (sparse.length / 24).floor();
      if (sparse[24 * maxEntries] > 0) {
        /// If there are more entries, read an extension header and parse its
        /// entries.
        sparse = await _chunkedStream.read(blockSize);
        sparseMaps.add(sparse);
        continue;
      }

      break;
    }

    var result = <SparseEntry>[];

    try {
      result = processOldGNUSparseMap(sparseMaps);
    } on FormatException {
      fileException('Invalid old GNU Sparse Map');
    }

    return result;
  }
}
