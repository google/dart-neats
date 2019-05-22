// Copyright 2019 Google LLC
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

import 'dart:async' show Future;
import 'dart:convert' show utf8;
import 'dart:io' show File, Directory, Platform, Process, ProcessStartMode;
import 'package:pubspec_parse/pubspec_parse.dart' show Pubspec;

Future<int> main(List<String> args) async {
  if (args.length != 1) {
    print('usage: dart tool/publish.dart <package>');
    return 1;
  }
  if (args.first == '--help' || args.first == '-h') {
    print('tool for publishing packages, this will:');
    print(' * Find package version');
    print(' * Extract changelog message');
    print(' * Check that git status is clean for the package');
    print(' * Publish to pub');
    print(' * Tag with changelog message');
    print(' * Push tag to origin');
    return 0;
  }
  // Find package
  final package = args.first;
  final root = File(Platform.script.toFilePath()).parent.parent.path;
  if (!Directory('$root/$package').existsSync()) {
    print('No such directory $root/$package');
    return 1;
  }

  // Read pubspec to get the version
  final pubspec_yaml = await File('$root/$package/pubspec.yaml').readAsString();
  final pubspec = Pubspec.parse(pubspec_yaml);
  print('Publishing: $package version ${pubspec.version}');

  // Read changelog
  final changelog_md = await File('$root/$package/CHANGELOG.md').readAsString();
  String changelog_entry = changelog_md.split('\n## v').first.trim();
  if (!changelog_entry.startsWith('## v${pubspec.version}\n')) {
    print('Changelog should start with "## v${pubspec.version}\\n"');
    return 1;
  }
  changelog_entry =
      changelog_entry.split('\n').sublist(1).join('\n').trimRight();
  print('-------------------');
  print(changelog_entry);
  print('-------------------');

  // Check git dirty state
  print('\$ git status');
  final git_status = await Process.run(
    'git',
    ['status', '-s', 'short', '$package/'],
    includeParentEnvironment: true,
    workingDirectory: '$root',
    stderrEncoding: utf8,
    stdoutEncoding: utf8,
  );
  if (git_status.exitCode != 0 ||
      git_status.stdout != '' ||
      git_status.stderr != '') {
    print(git_status.stdout);
    print(git_status.stderr);
    print('git tree is not clean!');
    return 1;
  }

  // Do a pub publish
  print('\$ pub publish');
  final pub = await Process.start(
    'pub',
    ['publish'],
    includeParentEnvironment: true,
    workingDirectory: '$root/$package',
    mode: ProcessStartMode.inheritStdio,
  );
  if ((await pub.exitCode) != 0) {
    print('pub publish failed!');
    return 1;
  }

  print('\$ git tag $package-v${pubspec.version}');
  final git_tag = await Process.run(
    'git',
    [
      'tag',
      '$package-v${pubspec.version}',
      '-m',
      'Published $package version ${pubspec.version}\n\n$changelog_entry\n'
    ],
    includeParentEnvironment: true,
    workingDirectory: '$root',
    stderrEncoding: utf8,
    stdoutEncoding: utf8,
  );
  if (git_tag.exitCode != 0) {
    print('failed to git tag');
    return 1;
  }

  print('\$ git push origin $package-v${pubspec.version}');
  final git_push = await Process.start(
    'git',
    ['push', 'origin', '$package-v${pubspec.version}'],
    includeParentEnvironment: true,
    workingDirectory: '$root',
    mode: ProcessStartMode.inheritStdio,
  );
  if ((await git_push.exitCode) != 0) {
    print('git push origin $package-v${pubspec.version} failed!');
    return 1;
  }
  return 0;
}
