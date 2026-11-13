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

final class _UpdateCommand extends _Base {
  _UpdateCommand({required super.out, required super.err}) {
    argParser.addFlag(
      'dry-run',
      abbr: 'n',
      negatable: false,
      help: 'Show which markdown files would be updated without writing them.',
    );
  }

  @override
  String get name => 'update';

  @override
  String get description =>
      'Update the code samples in markdown files from the files they '
      'reference.';

  @override
  Future<int> run() async {
    final dryRun = argResults!.flag('dry-run');
    final outcome = await updateDirectory(directory: directory, write: !dryRun);
    final failed = report(outcome.diagnostics);

    final prefix = dryRun ? 'would update' : 'updated';
    for (final file in outcome.stale.keys) {
      out.writeln('$prefix $file');
    }
    if (outcome.stale.isEmpty && !failed) {
      out.writeln('${outcome.scanned} markdown files are up to date');
    }
    // Staleness is what this command is for, so only errors are failures.
    return failed ? 1 : 0;
  }
}
