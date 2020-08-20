import 'dart:io';
import 'dart:isolate';

import 'package:crypto/crypto.dart';
import 'package:tar/src/constants.dart';
import 'package:tar/src/exceptions.dart';
import 'package:tar/src/header.dart';
import 'package:tar/src/reader.dart';
import 'package:tar/src/sparse_entry.dart';
import 'package:tar/src/utils.dart';
import 'package:test/test.dart';

import 'test_utils.dart';

void main() async {
  final packageUri =
      await Isolate.resolvePackageUri(Uri.parse('package:tar/tar.dart'));
  final testDirectoryUri = packageUri.resolve('../test/testdata/');

  test('', () async {
    final testFileUri = testDirectoryUri.resolve('pax-bad-hdr-file.tar');
    final testFile = File.fromUri(testFileUri);

    if (!testFile.existsSync()) {
      throw ArgumentError('File not found at ${testFile.path}');
    }

    final tarReader = TarReader(testFile.openRead());

    await tarReader.next();
    print(tarReader.header);

    await tarReader.next();
    print(tarReader.header);
  });
}
