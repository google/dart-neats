// Copyright 2024 Google LLC
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
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'package:args/args.dart';
import 'package:path/path.dart' as path;
import 'package:retry/retry.dart';
import 'package:tar/tar.dart';

Future<void> main(List<String> args) async {
  final client = http.Client();
  ArgParser argParser = ArgParser();
  argParser.addFlag('archive',
      help: 'Download the package as a tar.gz archive', negatable: false);
  argParser.addOption('destination',
      help: 'Download the package in this dir', defaultsTo: '.');
  argParser.addOption('repository',
      help: 'The package repository to download from',
      defaultsTo: 'https://pub.dev');
  argParser.addFlag('help', help: 'Show this help text', negatable: false);
  final usage = 'Usage: fetch_package <package> [<version>] [<options>]\n'
      '${argParser.usage}';

  final ArgResults argResults;
  try {
    argResults = argParser.parse(args);
  } on FormatException catch (e) {
    fail('${e.message}\n\n'
        '$usage');
  }
  if (argResults['help'] ||
      !(argResults.rest.length == 1 || argResults.rest.length == 2)) {
    fail('$usage');
  }
  final package = argResults.rest[0];
  var version = argResults.rest.length == 2 ? args[1] : null;
  final destination = argResults['destination'] as String;
  if (!Directory(destination).existsSync()) {
    fail('Destination directory `$destination` doesn\'t exist');
  }
  final versionListing = await retry(() async {
    final versionListingText = await client.read(
        Uri.parse(argResults['repository']).resolve('api/packages/$package'));
    return jsonDecode(versionListingText) as Map<String, dynamic>;
  }, retryIf: (e) => e is IOException || e is http.ClientException);
  if (version == null) {
    version = versionListing['latest']?['version'];
    if (version == null) {
      fail(
          'Version listing did not give a latest version. Please specify an exact version');
    }
    print('Choosing the latest version: $version');
  }

  final archiveUrl = (versionListing['versions'] as List)
          .firstWhereOrNull((v) => v['version'] == version)?['archive_url']
      as String?;
  if (archiveUrl == null) {
    final versions = versionListing['versions'].map((v) => v['version']);
    fail('Version $version not found.\n\n'
        'Available versions: ${versions.join(', ')}.');
  }
  final bytes = await retry(() async {
    return client.readBytes(Uri.parse(archiveUrl));
  }, retryIf: (e) => e is IOException || e is http.ClientException);
  if (argResults['archive']) {
    final archivePath = path.join(destination, '$package-$version.tar.gz');
    if (File(archivePath).existsSync()) {
      fail('$archivePath already exists');
    }
    File(archivePath).writeAsBytesSync(bytes);
    print('Downloaded package archive to $archivePath.');
  } else {
    final dir = path.join(destination, package);
    if (Directory(dir).existsSync()) {
      fail('$dir already exists.');
    }
    Directory(dir).createSync(recursive: true);
    try {
      extractTarGz(bytes, dir);
      print('Extracted $package-$version to $dir.');
    } on Exception {
      Directory(dir).deleteSync();
    }
  }
  client.close();
}

/// Extracts a `.tar.gz` file from [bytes] to [destination].
Future extractTarGz(List<int> bytes, String destination) async {
  destination = path.absolute(destination);
  final reader = TarReader(Stream.fromIterable([gzip.decode(bytes)]));
  final paths = <String>{};
  while (await reader.moveNext()) {
    final entry = reader.current;

    final filePath = path.joinAll([
      destination,
      // Tar file names always use forward slashes
      ...path.posix.split(entry.name),
    ]);
    if (!paths.add(filePath)) {
      // The tar file contained the same entry twice. Assume it is broken.
      await reader.cancel();
      throw FormatException('Tar file contained duplicate path ${entry.name}');
    }

    if (!path.isWithin(destination, filePath)) {
      // The tar contains entries that would be written outside of the
      // destination. That doesn't happen by accident, assume that the tar file
      // is malicious.
      await reader.cancel();
      throw FormatException('Invalid tar entry: ${entry.name}');
    }

    final parentDirectory = path.dirname(filePath);

    bool checkValidTarget(String linkTarget) {
      final isValid = path.isWithin(destination, linkTarget);
      if (!isValid) {
        print('Skipping ${entry.name}: Invalid link target');
      }

      return isValid;
    }

    switch (entry.type) {
      case TypeFlag.dir:
        Directory(filePath).createSync(recursive: true);
        break;
      case TypeFlag.reg:
      case TypeFlag.regA:
        // Regular file
        Directory(parentDirectory).createSync(recursive: true);
        await createFileFromStream(entry.contents, filePath);

        if (Platform.isLinux || Platform.isMacOS) {
          // Apply executable bits from tar header, but don't change r/w bits
          // from the default
          final mode = _defaultMode | (entry.header.mode & _executableMask);

          if (mode != _defaultMode) {
            _chmod(mode, filePath);
          }
        }
        break;
      case TypeFlag.symlink:
        // Link to another file in this tar, relative from this entry.
        final resolvedTarget = path.joinAll(
          [parentDirectory, ...path.posix.split(entry.header.linkName!)],
        );
        if (!checkValidTarget(resolvedTarget)) {
          // Don't allow links to files outside of this tar.
          break;
        }

        Directory(parentDirectory).createSync(recursive: true);
        Link(filePath)
            .createSync(path.relative(resolvedTarget, from: parentDirectory));
        break;
      case TypeFlag.link:
        // We generate hardlinks as symlinks too, but their linkName is relative
        // to the root of the tar file (unlike symlink entries, whose linkName
        // is relative to the entry itself).
        final fromDestination = path.join(destination, entry.header.linkName);
        if (!checkValidTarget(fromDestination)) {
          break; // Link points outside of the tar file.
        }

        final fromFile = path.relative(fromDestination, from: parentDirectory);
        Directory(parentDirectory).createSync(recursive: true);
        Link(filePath).createSync(fromFile);
        break;
      default:
        // Only extract files
        continue;
    }
  }
}

/// Writes [stream] to a new file at path [file].
///
/// Replaces any file already at that path. Completes when the file is done
/// being written.
Future<void> createFileFromStream(Stream<List<int>> stream, String file) async {
  deleteIfLink(file);
  await stream.pipe(File(file).openWrite());
}

/// Deletes [file] if it's a symlink.
///
/// The [File] class overwrites the symlink targets when writing to a file,
/// which is never what we want, so this delete the symlink first if necessary.
void deleteIfLink(String file) {
  if (File(file).statSync().type != FileSystemEntityType.link) return;
  Link(file).deleteSync();
}

/// The assumed default file mode on Linux and macOS
const _defaultMode = 420; // 644₈

/// Mask for executable bits in file modes.
const _executableMask = 0x49; // 001 001 001

void _chmod(int mode, String file) {
  final result = Process.runSync('chmod', [mode.toRadixString(8), file]);
  if (result.exitCode != 0) {
    fail('Could not change mode of $file ${result.stdout} ${result.stderr}');
  }
}

Never fail(String message) {
  stderr.writeln(message);
  exit(-1);
}
