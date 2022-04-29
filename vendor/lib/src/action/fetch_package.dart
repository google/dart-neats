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

import 'dart:io' show Directory, gzip, File;
import 'dart:convert' show jsonDecode;

import 'package:glob/glob.dart';
import 'package:meta/meta.dart' show sealed;
import 'package:pub_semver/pub_semver.dart' show Version;
import 'package:retry/retry.dart' show retry;
import 'package:tar/tar.dart';
import 'package:vendor/src/exceptions.dart' show VendorFailure, ExitCode;
import 'package:vendor/src/action/action.dart' show Action, Context;
import 'package:vendor/src/version.dart' show packageVersion;
import 'package:path/path.dart' as p;

final _website = 'https://github.com/google/dart-neats/tree/master/vendor';

final _headers = {
  'User-Agent': 'package:vendor/$packageVersion (+$_website)',
};

@sealed
class FetchPackageAction extends Action {
  final Uri folder;
  final String package;
  final Version version;
  final Uri hostedUrl;
  final Set<String> include;

  FetchPackageAction({
    required this.folder,
    required this.package,
    required this.version,
    required this.hostedUrl,
    required this.include,
  });

  @override
  String get summary => 'fetch $package:$version -> $folder (from $hostedUrl)';

  @override
  String get description => [
        summary,
        if (include.isNotEmpty) ...[
          'include:',
          ...(include.map((e) => ' - $e').toList()..sort()),
        ] else
          'include: NOTHING!',
      ].join('\n');

  @override
  Future<void> apply(Context ctx) async {
    ctx.log('# Apply: fetch $package:$version -> $folder');
    // List versions of package
    Map? versions;
    try {
      versions = await retry(() async {
        final u = hostedUrl.resolve('api/packages/$package');
        ctx.log('- Listing versions from $u');
        final response = await ctx.client.get(u, headers: _headers);
        if (response.statusCode == 404) {
          return null;
        } else if (response.statusCode != 200) {
          throw Exception('response code: ${response.statusCode}');
        }
        return jsonDecode(response.body) as Map;
      });
    } on Exception catch (e) {
      throw VendorFailure(
        ExitCode.tempFail,
        'Unable to list versions of package:$package, $e',
      );
    }
    if (versions == null) {
      throw VendorFailure(ExitCode.data, 'package:$package does not exist');
    }

    // Find the archive_url for given version
    final url = (versions['versions'] as List).firstWhere(
      (v) => Version.parse(v['version']) == version,
      orElse: () => {'archive_url': null},
    )['archive_url'] as String?;
    if (url == null) {
      throw VendorFailure(
        ExitCode.data,
        'package:$package does not a version $version',
      );
    }
    final u = Uri.parse(url);

    // Download tar archive
    List<int>? data;
    try {
      data = await retry(() async {
        ctx.log('- Fetching archive from $url');
        final response = await ctx.client.get(u, headers: _headers);
        if (response.statusCode == 404) {
          return null;
        } else if (response.statusCode != 200) {
          throw Exception('response code: ${response.statusCode}');
        }
        return gzip.decode(response.bodyBytes);
      });
    } on Exception catch (e) {
      throw VendorFailure(
        ExitCode.tempFail,
        'Unable download package:$package version $version, $e',
      );
    }
    if (data == null) {
      throw VendorFailure(
        ExitCode.data,
        'package:$package version $version does not exist',
      );
    }

    // Determine the include patterns
    final includePatterns = include
        .map((pattern) => Glob(pattern, context: p.posix, caseSensitive: true))
        .toList();

    // Extract tar archive
    ctx.log('- extracting archive into $folder:');
    final rootFolder = ctx.rootPackageFolder.resolveUri(folder);
    final tar = TarReader(Stream.value(data));
    while (await tar.moveNext()) {
      var entryPath = rootFolder.resolve(tar.current.name);
      if (!p.isWithin(rootFolder.toFilePath(), entryPath.toFilePath())) {
        continue;
      }
      var relPath = p.relative(entryPath.path, from: rootFolder.path);
      if (!includePatterns.any((g) => g.matches(relPath))) {
        continue;
      }
      if (tar.current.type == TypeFlag.dir) {
        ctx.log('    * $relPath/');
        await Directory.fromUri(entryPath).create(recursive: true);
      }
      if (tar.current.type == TypeFlag.reg) {
        if (_filenameRenames.containsKey(relPath)) {
          final origRelPath = relPath;
          entryPath = rootFolder.resolve(_filenameRenames[relPath]!);
          relPath = p.relative(entryPath.path, from: rootFolder.path);
          ctx.log('    * $origRelPath -> $relPath (renamed)');
        } else {
          ctx.log('    * $relPath');
        }
        final file = File.fromUri(entryPath);
        await file.parent.create(recursive: true);
        await tar.current.contents.pipe(file.openWrite());
      }
    }
  }
}

final _filenameRenames = {
  // Rewrite pubspec.yaml to avoid editors resolving nested pubspecs.
  'pubspec.yaml': 'vendored-pubspec.yaml',
};
