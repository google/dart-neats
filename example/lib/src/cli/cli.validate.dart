// Copyright 2026 Google LLC
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

part of 'cli.dart';

final class _ValidateCommand extends _Base {
  _ValidateCommand({required super.out, required super.err});

  @override
  String get name => 'validate';

  @override
  String get description =>
      'Check that the code samples in markdown files are up to date, without '
      'changing anything.';

  @override
  Future<int> run() async {
    final outcome = await updateDirectory(directory: directory, write: false);
    final failed = report(outcome.diagnostics);

    for (final MapEntry(key: file, value: count) in outcome.stale.entries) {
      err.writeln('$file: error: $count code '
          '${count == 1 ? 'block is' : 'blocks are'} out of date; run '
          '`dart run example update`');
    }
    if (outcome.stale.isEmpty && !failed) {
      out.writeln('${outcome.scanned} markdown files are up to date');
    }
    return failed || outcome.stale.isNotEmpty ? 1 : 0;
  }
}
