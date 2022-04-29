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

import 'dart:io' show IOException;
import 'package:io/io.dart' show ExitCode;

import 'package:pubspec_parse/pubspec_parse.dart' show Pubspec;

import 'package:vendor/src/config.dart' show VendorConfig, VendorState;
import 'package:vendor/src/dependencies.dart';
import 'package:vendor/src/validate.dart' show validateConfig, validateState;
import 'package:vendor/src/plan.dart' show plan;
import 'package:vendor/src/action/action.dart' show Context;
import 'package:vendor/src/exceptions.dart' show VendorFailure;
import 'package:checked_yaml/checked_yaml.dart' show ParsedYamlException;

/// Run vendoring operation in given [ctx].
///
/// Throws [VendorFailure], if not successful.
Future<void> vendor(
  Context ctx, {
  bool dryRun = false,
}) async {
  VendorConfig desiredConfig;
  VendorState currentState;
  Pubspec pubspec;
  try {
    // Read configuration / state files
    final desiredConfigFile = ctx.file('vendor.yaml');
    final currentStateFile = ctx.file('lib/src/third_party/vendor-state.yaml');

    // Check that desiredConfigFile file exists
    if (!await desiredConfigFile.exists()) {
      throw VendorFailure(
        ExitCode.config,
        'Configuration file "vendor.yaml" does not exist!',
      );
    }

    // Read desired configuration
    desiredConfig = VendorConfig.fromYaml(
      await desiredConfigFile.readAsString(),
      sourceUri: desiredConfigFile.uri,
    );
    validateConfig(desiredConfig);

    // Read and validate the `vendor-state.yaml` file.
    currentState = VendorState.empty;
    if (await currentStateFile.exists()) {
      currentState = VendorState.fromYaml(
        await currentStateFile.readAsString(),
        sourceUri: currentStateFile.uri,
      );
    }
    await validateState(currentState, ctx.rootPackageFolder);

    // Read pubspec for the current package
    final pubspecFile = ctx.file('pubspec.yaml');
    if (!await pubspecFile.exists()) {
      throw VendorFailure(
        ExitCode.config,
        'Package must have a "pubspec.yaml"!',
      );
    }
    pubspec = Pubspec.parse(
      await pubspecFile.readAsString(),
      sourceUrl: pubspecFile.uri,
      lenient: true,
    );
  } on FormatException catch (e) {
    throw VendorFailure(
      ExitCode.config,
      e.toString(),
    );
  } on ParsedYamlException catch (e) {
    throw VendorFailure(
      ExitCode.config,
      e.formattedMessage ?? e.toString(),
    );
  } on IOException catch (e) {
    throw VendorFailure(
      ExitCode.ioError,
      'failed to read configuration file, error: $e',
    );
  }

  // Plan actions
  final actions = plan(
    rootPackageName: pubspec.name,
    desiredState: desiredConfig,
    currentState: currentState.config,
    defaultHostedUrl: ctx.defaultHostedUrl,
  );

  if (actions.isEmpty) {
    ctx.log('No changes to be made');
  } else {
    ctx.log('# Changes to be made:');
    for (final action in actions) {
      ctx.log('* ${action.description.replaceAll('\n', '\n  ')}');
    }
    ctx.log('');

    if (!dryRun) {
      ctx.log('# Applying Changes');
      for (final action in actions) {
        await action.apply(ctx);
      }
    }
  }

  // Warn about missing dependencies from vendored pubspec.yaml files
  await checkDependenciesForVendoredPackages(
    ctx,
    rootPubspec: pubspec,
    config: desiredConfig,
  );
}
