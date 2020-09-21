import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:tar/src/constants.dart';
import 'package:tar/src/reader.dart';
import 'package:tar/src/stream.dart';
import 'package:test/test.dart';

/// Find a tar path, preferring system installed tar.
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

Uri _testDirectoryUri;

Future<Uri> findTestDirectoryUri() async {
  if (_testDirectoryUri != null) return _testDirectoryUri;

  final packageUri =
      await Isolate.resolvePackageUri(Uri.parse('package:tar/tar.dart'));
  _testDirectoryUri = packageUri.resolve('../test/testdata/large_files/');

  return _testDirectoryUri;
}

/// Creates a test file with file name [fileName] and [size] with randomized
/// byte contents.
Future<void> createTestFile(String fileName, int size) async {
  final uri = (await findTestDirectoryUri()).resolve(fileName);
  final testFile = File.fromUri(uri);
  final sink = testFile.openWrite();

  final random = Random();
  while (size-- > 0) {
    sink.add([random.nextInt(256)]);
  }
  await sink.close();
}

/// Creates a clean (no data bytes) sparse test file with file name [fileName]
/// and [size] bytes.
Future<void> createCleanSparseTestFile(String fileName, int size) async {
  final testDirectoryUri = await findTestDirectoryUri();

  await Process.run('truncate', ['--size=$size', fileName],
      workingDirectory: testDirectoryUri.path);
}

/// Creates a sparse test file with file name [fileName] and [size] bytes.
Future<void> createSparseTestFile(String fileName, int size) async {
  final uri = (await findTestDirectoryUri()).resolve(fileName);
  final testFile = File.fromUri(uri);
  final sink = testFile.openWrite();

  final random = Random();

  // Randomly generates blocks of 512 null bytes.
  while (size > 0) {
    var nextBlockSize = min(size, 512);

    if (random.nextBool()) {
      sink.add(List.filled(nextBlockSize, 0));
    } else {
      final block = <int>[];
      for (var i = 0; i < nextBlockSize; i++) {
        block.add(random.nextInt(256));
      }

      sink.add(block);
    }

    size -= nextBlockSize;
  }
  await sink.close();
}

/// Creates a [format] TAR archive with file name [archiveName], consisting of
/// [files], which contain a map from file names to sparse files.
///
/// Valid values for [format] are: `gnu`, `oldgnu`, `posix`, `ustar`, `v7`.
Future<File> createTestArchive(Map<String, Future<void> Function(String)> files,
    [String archiveFormat = 'gnu', String sparseVersion]) async {
  final testDirectoryUri = await findTestDirectoryUri();
  final uri = testDirectoryUri.resolve('test.tar');
  final testArchive = File.fromUri(uri);

  for (final entry in files.entries) {
    await entry.value(entry.key);
  }

  final args = [
    '--format=$archiveFormat',
    '--create',
    '--file',
    'test.tar',
    ...files.keys
  ];

  if (sparseVersion != null) {
    args.add('--sparse');
    args.add('--sparse-version=$sparseVersion');
  }

  final result = await Process.run(findTarPath(), args,
      workingDirectory: testDirectoryUri.path);

  if (result.exitCode != 0) {
    AssertionError('Failed to create tar archive');
  }

  return testArchive;
}

/// Reads the next [size] bytes from [iterator].
Future<List> read(StreamIterator iterator, int size) async {
  final result = [];

  while (size-- > 0 && await iterator.moveNext()) {
    result.add(iterator.current);
  }

  return result;
}

/// Validates the contents of the test archive at the byte level.
Future<void> validateTestArchive(
    File testArchive, Map<String, Future<void> Function(String)> files) async {
  expect(testArchive.existsSync(), isTrue);

  final reader = TarReader(testArchive.openRead());

  for (var i = 0; i < files.length; i++) {
    expect(await reader.next(), isTrue);

    final actualFile =
        File.fromUri(testArchive.uri.resolve((await reader.header).name));
    expect(actualFile.existsSync(), isTrue);

    final actualFileContents = ChunkedStreamIterator(actualFile.openRead());
    final readTarContents = StreamIterator(reader.contents);

    while (true) {
      final actualChunk = await actualFileContents.read(ioBlockSize);
      final readChunk = await read(readTarContents, ioBlockSize);
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

  for (final format in ['gnu', 'v7', 'oldgnu', 'posix', 'ustar']) {
    group('reading large files in $format', () {
      test('reads a large file successfully ($format)', () async {
        final files = {
          'test.txt': (String name) async =>
              await createTestFile(name, 2 * ioBlockSize - 513)
        };
        final testArchive = await createTestArchive(files, format);

        await validateTestArchive(testArchive, files);
      });

      test('reads multiple large files successfully ($format)', () async {
        final files = {
          'test.txt': (String name) async =>
              await createTestFile(name, ioBlockSize + 3),
          'test2.txt': (String name) async =>
              await createTestFile(name, 2 * ioBlockSize + 4),
          'test3.txt': (String name) async =>
              await createTestFile(name, ioBlockSize - 2)
        };

        final testArchive = await createTestArchive(files, format);

        await validateTestArchive(testArchive, files);
      });
    });
  }

  for (final format in ['gnu', 'posix']) {
    for (final sparseVersion in ['0.0', '0.1', '1.0']) {
      test(
          'reads a clean large sparse file successfully ($format $sparseVersion)',
          () async {
        final files = {
          'test.txt': (String name) async =>
              await createCleanSparseTestFile(name, 2 * ioBlockSize - 513)
        };
        final testArchive =
            await createTestArchive(files, format, sparseVersion);

        await validateTestArchive(testArchive, files);
      });

      test('reads a large sparse file successfully ($format $sparseVersion)',
          () async {
        final files = {
          'test.txt': (String name) async =>
              await createSparseTestFile(name, 2 * ioBlockSize - 513)
        };
        final testArchive =
            await createTestArchive(files, format, sparseVersion);

        await validateTestArchive(testArchive, files);
      });

      test(
          'reads multiple clean large sparse files successfully ($format '
          '$sparseVersion)', () async {
        final files = {
          'test.txt': (String name) async =>
              await createTestFile(name, ioBlockSize + 3),
          'test2.txt': (String name) async =>
              await createCleanSparseTestFile(name, 2 * ioBlockSize + 4),
          'test3.txt': (String name) async =>
              await createTestFile(name, ioBlockSize - 2),
          'test4.txt': (String name) async =>
              await createCleanSparseTestFile(name, ioBlockSize - 2)
        };

        final testArchive =
            await createTestArchive(files, format, sparseVersion);

        await validateTestArchive(testArchive, files);
      });

      test(
          'reads multiple  large sparse files successfully ($format '
          '$sparseVersion)', () async {
        final files = {
          'test.txt': (String name) async =>
              await createTestFile(name, ioBlockSize + 3),
          'test2.txt': (String name) async =>
              await createSparseTestFile(name, 2 * ioBlockSize + 4),
          'test3.txt': (String name) async =>
              await createCleanSparseTestFile(name, ioBlockSize - 2),
          'test4.txt': (String name) async =>
              await createSparseTestFile(name, ioBlockSize - 2)
        };

        final testArchive =
            await createTestArchive(files, format, sparseVersion);

        await validateTestArchive(testArchive, files);
      });
    }
  }
}
