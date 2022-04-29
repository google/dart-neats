// Copyright 2022 Google LLC
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

import 'dart:io' show HttpServer, gzip;
import 'dart:convert' show utf8, json;
import 'dart:typed_data' show Uint8List;

import 'package:async/async.dart';
import 'package:pub_semver/pub_semver.dart' show Version;
import 'package:tar/tar.dart' show TarEntry, TarHeader, TypeFlag, tarWriter;
import 'package:vendor/src/utils/iterable_ext.dart' show IterableExt;
import 'package:pubspec_parse/pubspec_parse.dart' show Pubspec;
import 'package:meta/meta.dart' show sealed;
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:test_descriptor/test_descriptor.dart' as d;
import 'package:chunked_stream/chunked_stream.dart' show readChunkedStream;

@sealed
abstract class PubTestServer {
  Uri get url;

  Future<void> close();

  Future<void> add(d.DirectoryDescriptor packageDescriptor);

  static Future<PubTestServer> listen() async {
    final s = _PubTestServer();
    s._server = await io.serve(s._handle, 'localhost', 0);
    return s;
  }
}

class _PubTestServer extends PubTestServer {
  late HttpServer _server;
  final _packages = <_Package>[];

  @override
  Uri get url => Uri.http('localhost:${_server.port}', '/');

  @override
  Future<void> add(d.DirectoryDescriptor packageDescriptor) async {
    final pubspecBytes = await readChunkedStream(
      packageDescriptor.load('pubspec.yaml'),
    );
    final pubspec = Pubspec.parse(
      utf8.decode(pubspecBytes),
      lenient: true,
      sourceUrl: Uri.parse('pubspec.yaml'),
    );
    final archiveBytes = await _descriptorToTarGz(packageDescriptor.contents);
    _packages.add(_Package(pubspec, archiveBytes));
  }

  Future<shelf.Response> _handle(shelf.Request request) async {
    if (request.method == 'GET' &&
        request.url.pathSegments.startsWith(['api', 'packages']) &&
        request.url.pathSegments.length == 3) {
      final package = request.url.pathSegments[2];
      final versions = _packages.where((p) => p.pubspec.name == package);
      if (versions.isEmpty) {
        return shelf.Response.notFound('Package not found');
      }

      return shelf.Response.ok(json.encode({
        'versions': versions
            .map((p) => {
                  'version': p.pubspec.version.toString(),
                  'archive_url': url
                      .resolve(
                          '/archive/${p.pubspec.name}/${p.pubspec.version}')
                      .toString(),
                })
            .toList(),
      }));
    }
    if (request.method == 'GET' &&
        request.url.pathSegments.startsWith(['archive']) &&
        request.url.pathSegments.length == 3) {
      final package = request.url.pathSegments[1];
      final version = Version.parse(request.url.pathSegments[2]);
      if (!_packages.any(
        (p) => p.pubspec.name == package && p.pubspec.version == version,
      )) {
        return shelf.Response.notFound('Package not found');
      }
      final pkg = _packages.firstWhere(
        (p) => p.pubspec.name == package && p.pubspec.version == version,
      );
      return shelf.Response.ok(pkg.archive);
    }
    return shelf.Response.notFound('404');
  }

  @override
  Future<void> close() => _server.close(force: true);
}

class _Package {
  final Pubspec pubspec;
  final List<int> archive;
  _Package(this.pubspec, this.archive);
}

Future<Uint8List> _descriptorToTarGz(Iterable<d.Descriptor> descriptors) =>
    collectBytes(_descriptorToTarEntries(descriptors)
        .transform(tarWriter)
        .transform(gzip.encoder));

Stream<TarEntry> _descriptorToTarEntries(
  Iterable<d.Descriptor> descriptors, [
  String parent = '',
]) async* {
  for (final descriptor in descriptors) {
    var path = descriptor.name;
    if (parent.isNotEmpty) {
      path = '$parent/$path';
    }

    if (descriptor is d.FileDescriptor) {
      final data = await collectBytes(descriptor.readAsBytes());
      yield TarEntry.data(
        TarHeader(name: path, size: data.length),
        data,
      );
    } else if (descriptor is d.DirectoryDescriptor) {
      yield TarEntry.data(
        TarHeader(
          name: path,
          typeFlag: TypeFlag.dir,
        ),
        [],
      );
      yield* _descriptorToTarEntries(descriptor.contents, path);
    } else {
      throw UnsupportedError(
        'Archives can only be created from files and directories',
      );
    }
  }
}
