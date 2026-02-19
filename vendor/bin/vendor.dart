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

import 'dart:io' show exit, Platform, stderr, stdout;
import 'package:io/io.dart' show ExitCode;
import 'package:vendor/src/context.dart' show Context;
import 'package:vendor/src/exceptions.dart' show VendorFailure;
import 'package:vendor/src/vendor.dart' show vendor;
import 'package:args/args.dart' show ArgParser, ArgResults;
import 'package:path/path.dart' as p;
import 'package:io/ansi.dart' as ansi;
import 'package:http/http.dart' as http;

final _parser = ArgParser(usageLineLength: 80)
  ..addFlag(
    'dry-run',
    abbr: 'n',
    negatable: false,
    help: 'Show changes to be made without making any.',
  )
  ..addFlag(
    'help',
    abbr: 'h',
    negatable: false,
    help: 'Display this help message',
  );

final _usage = '''
Utility for vendoring pub packages.

Usage: dart pub run vendor

Options:
${_parser.usage}
''';

/// Get `PUB_HOSTED_URL`, defaulting to `https://pub.dartlang.org/`.
Uri get _pubHostedUrl {
  final hostedUrl = Platform.environment['PUB_HOSTED_URL'];
  if (hostedUrl != null && hostedUrl.isNotEmpty) {
    try {
      final u = Uri.parse(hostedUrl);
      if (!u.isScheme('http') && !u.isScheme('https')) {
        throw VendorFailure(
          ExitCode.config,
          'PUB_HOSTED_URL must be a http:// or https:// URL',
        );
      }
      return u;
    } on FormatException catch (e) {
      throw VendorFailure(
        ExitCode.config,
        'Failed to parse PUB_HOSTED_URL: $e',
      );
    }
  }
  return Uri.https('pub.dartlang.org', '/');
}

class _Context extends Context {
  @override
  final http.Client client;

  @override
  final Uri rootPackageFolder;

  @override
  final Uri defaultHostedUrl;

  _Context({
    required this.rootPackageFolder,
    required this.client,
    required this.defaultHostedUrl,
  });

  @override
  void log(String message) => stdout.writeln(
        message.startsWith('#')
            ? ansi.wrapWith(message, [ansi.styleBold])
            : message,
      );

  @override
  void warning(String message) => stderr.writeln(ansi.wrapWith(
        message,
        [ansi.red, ansi.styleBold],
      ));
}

Future<ExitCode> _main(List<String> arguments) async {
  try {
    ArgResults args;
    try {
      args = _parser.parse(arguments);
    } on FormatException catch (e) {
      print(e.message);
      print(_usage);
      return ExitCode.usage;
    }

    if (args['help']) {
      print(_usage);
      return ExitCode.success;
    }

    final ctx = _Context(
      rootPackageFolder: Uri.directory(p.current),
      defaultHostedUrl: _pubHostedUrl,
      client: http.Client(),
    );
    try {
      await vendor(
        ctx,
        dryRun: args['dry-run'] ?? false,
      );
    } on VendorFailure catch (e) {
      ctx.warning(e.message);
      return e.exitCode;
    } finally {
      ctx.client.close();
    }
  } catch (e, st) {
    print('Internal Error in package:vendor:');
    print(e);
    print(st);
    print('');
    print('Consider reporting:');
    print(Uri.parse('https://github.com/google/dart-neats/issues/new')
        .replace(queryParameters: {
      'labels': 'pkg:yaml_edit+pending-triage',
      'title': '$e',
      'body': '''Internal error occured:
```
$e
$st
```

Running on `vendor.yaml` as follows:
```yaml
TODO: Include `vendor.yaml`.
```
''',
    }));
    return ExitCode.software;
  }
  return ExitCode.success;
}

void main(List<String> arguments) async => exit((await _main(arguments)).code);
