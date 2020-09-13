import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:chunked_stream/chunked_stream.dart';
import 'package:tar/src/constants.dart';
import 'package:tar/src/reader.dart';
import 'package:test/test.dart';

/// Find a tar. Prefering system installed tar.
///
/// On linux tar should always be /bin/tar [See FHS 2.3][1]
/// On MacOS it seems to always be /usr/bin/tar.
///
/// [1]: https://refspecs.linuxfoundation.org/FHS_2.3/fhs-2.3.pdf
String findTarPath() {
  for (final file in ['/bin/tar', '/usr/bin/tar']) {
    if (File(file).existsSync()) {
      return file;
    }
  }

  return 'tar';
}

/// Writes [size] characters into [sink].
void writeRandomToSink(IOSink sink, int size) {
  final random = Random();
  while (size-- > 0) {
    sink.add([random.nextInt(256)]);
  }
}

Future<Uri> findTestDirectoryUri() async {
  if (_testDirectoryUri != null) return _testDirectoryUri;

  final packageUri =
      await Isolate.resolvePackageUri(Uri.parse('package:tar/tar.dart'));
  _testDirectoryUri = packageUri.resolve('../test/testdata/large_files/');

  return _testDirectoryUri;
}

Uri _testDirectoryUri;

Future<File> createTestFile(String fileName, int size) async {
  final uri = (await findTestDirectoryUri()).resolve(fileName);
  final testFile = File.fromUri(uri);
  final sink = testFile.openWrite();

  writeRandomToSink(sink, size);
  await sink.close();

  return testFile;
}

/// Creates a TAR archive with file name [archiveName], consisting of [files],
/// which contain a map from file names to sparse files.
Future<File> createTestArchive(Map<String, int> files) async {
  final testDirectoryUri = await findTestDirectoryUri();
  final uri = testDirectoryUri.resolve('test.tar');
  final testArchive = File.fromUri(uri);

  for (final entry in files.entries) {
    await createTestFile(entry.key, entry.value);
  }

  final args = [
    // ustar is the most recent tar format that's compatible across all
    // OSes.
    '--format=ustar',
    '--create',
    '--file',
    'test.tar',
    ...files.keys
  ];

  await Process.run(findTarPath(), args,
      workingDirectory: testDirectoryUri.path);

  return testArchive;
}

Future<void> validateTestArchive(
    File testArchive, Map<String, int> files) async {
  expect(testArchive.existsSync(), isTrue);

  final reader = TarReader(testArchive.openRead());

  for (var i = 0; i < files.length; i++) {
    expect(await reader.next(), isTrue);

    final actualFile =
        File.fromUri(testArchive.uri.resolve('${reader.header.name}'));
    expect(actualFile.existsSync(), isTrue);

    final actualFileContents = ChunkedStreamIterator(actualFile.openRead());
    final readTarContents = ChunkedStreamIterator(reader.contents);

    while (true) {
      final actualChunk = await actualFileContents.read(ioBlockSize);
      final readChunk = await readTarContents.read(ioBlockSize);
      expect(readChunk, actualChunk);

      if (actualChunk.isEmpty) break;
    }
  }

  expect(await reader.next(), isFalse);
}

void main() async {
  final testDirectoryUri = await findTestDirectoryUri();
  final largeDirectory = Directory.fromUri(testDirectoryUri);

  setUp(() {
    largeDirectory.createSync(recursive: true);
  });

  tearDown(() {
    largeDirectory.deleteSync(recursive: true);
  });

  test('reads a large file successfully', () async {
    final files = {'test.txt': ioBlockSize * 5};
    final testArchive = await createTestArchive(files);

    await validateTestArchive(testArchive, files);
  });

  /// TODO (walnut): investigate how the file size and archive size makes this
  /// work.
  /// The cases below fail:
  /// 'test.txt': 2 * ioBlockSize - 1535, and every + ioBlockSize above this.
  /// 'test.txt': 2 * ioBlockSize - 512, and every + ioBlockSize above this.
  /// header takes 512, and there can be anywhere from 0 to 2 zero blocks, so
  /// the above cases imply a total size of

  test('reads multiple large files successfully', () async {
    final files = {'test.txt': 2 * ioBlockSize - 511};

    final testArchive = await createTestArchive(files);

    await validateTestArchive(testArchive, files);
  });
}
