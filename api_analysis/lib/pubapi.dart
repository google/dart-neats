// Copyright 2023 Google LLC
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

import 'dart:async';
import 'dart:convert';
import 'dart:io' show IOException, Platform, gzip;
import 'dart:typed_data';
import 'package:api_analysis/expect_json.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:pub_semver/pub_semver.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:retry/retry.dart';
import 'package:tar/tar.dart';

final _defaultPubHostedUrl = Uri.parse('https://pub.dev');
Uri? _pubHostedUrlCache;
Uri get _pubHostedUrl {
  return _pubHostedUrlCache ??= (() {
    final u = Platform.environment['PUB_HOSTED_URL'] ?? '';
    if (u.isEmpty) {
      return _defaultPubHostedUrl;
    }
    try {
      return Uri.parse(u).withSlash();
    } on FormatException {
      throw StateError('Invalid PUB_HOSTED_URL');
    }
  })();
}

final _headers = {
  'Accept': 'application/vnd.pub.v2+json',
  'User-Agent': 'api_analysis/0.0.0 (+https://github.com/google/dart-neats)'
};

final _jsonUtf8 = json.fuse(utf8);

typedef VersionList = ({
  String name,
  bool isDiscontinued,
  String? replacedBy,
  List<VersionInfo> versions,
});

typedef VersionInfo = ({
  Version version,
  bool retracted,
  Uri archiveUrl,
  String archiveSha256,
  Pubspec pubspec,
});

typedef FileEntry = ({
  String path,
  Uint8List bytes,
});

final class PubApi {
  final Uri _hostedUrl;
  final http.Client _client;
  final bool _closeClient;
  final Duration _timeout;

  PubApi({
    Uri? hostedUrl,
    http.Client? client,
    Duration timeout = const Duration(seconds: 30),
  })  : _hostedUrl = (hostedUrl ?? _pubHostedUrl).withSlash(),
        _client = client ?? http.Client(),
        _closeClient = client == null,
        _timeout = timeout;

  void close() {
    if (_closeClient) {
      _client.close();
    }
  }

  static Future<T> withApi<T>(FutureOr<T> Function(PubApi api) fn) async {
    final api = PubApi();
    try {
      return await fn(api);
    } finally {
      api.close();
    }
  }

  Future<Uint8List> _fetch(Uri u) async {
    return await retry(
      () async {
        final response =
            await _client.get(u, headers: _headers).timeout(_timeout);
        if (400 <= response.statusCode && response.statusCode < 500) {
          throw Exception('Request failed: ${response.statusCode}');
        }
        if (response.statusCode != 200) {
          throw http.ClientException(
            'failed status code: ${response.statusCode}',
          );
        }
        return response.bodyBytes;
      },
      retryIf: (e) =>
          e is IOException ||
          e is TimeoutException ||
          e is http.ClientException,
    );
  }

  Future<List<String>> listPackages() async {
    final bytes = await _fetch(_hostedUrl.resolve('api/package-names'));
    final data = _jsonUtf8.decode(bytes);
    if (data is! Map<String, Object?>) {
      throw FormatException('root must be an map');
    }
    return data.expectListStrings('packages').toList();
  }

  Future<VersionList> listVersions(String package) async {
    final bytes = await _fetch(_hostedUrl.resolve('api/packages/$package'));
    final data = _jsonUtf8.decode(bytes);
    if (data is! Map<String, Object?>) {
      throw FormatException('root must be an map');
    }
    return (
      name: data.expectString('name'),
      isDiscontinued: false,
      replacedBy: data.optionalString('replacedBy'),
      versions: data
          .expectListObjects('versions')
          .map((e) => (
                version: e.expectVersion('version'),
                retracted: e.optionalBool('retracted') ?? false,
                archiveUrl: e.expectUri('archive_url'),
                archiveSha256: e.expectString('archive_sha256'),
                pubspec: Pubspec.fromJson(
                  e.expectMap('pubspec'),
                  lenient: true,
                ),
              ))
          .toList(),
    );
  }

  Future<List<FileEntry>> fetchPackage(Uri archiveUrl) async {
    final files = <FileEntry>[];
    final bytes = gzip.decode(await _fetch(archiveUrl));
    await TarReader.forEach(Stream.value(bytes), (entry) async {
      if (entry.type == TypeFlag.reg || entry.type == TypeFlag.regA) {
        files.add((
          path: entry.name,
          bytes: await collectBytes(entry.contents),
        ));
      }
    });
    return files;
  }
}

extension on Uri {
  Uri withSlash() {
    if (hasEmptyPath || pathSegments.last.isEmpty) {
      return this;
    }
    return replace(
      pathSegments: pathSegments.followedBy(['']),
    );
  }
}
