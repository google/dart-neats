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

import 'dart:convert' show json;
import 'package:pub_semver/pub_semver.dart' show Version;
import 'package:meta/meta.dart' show sealed;
import 'package:json_annotation/json_annotation.dart';
import 'package:checked_yaml/checked_yaml.dart';
import 'package:yaml_edit/yaml_edit.dart' show YamlEditor, wrapAsYamlNode;
import 'package:yaml/yaml.dart' show CollectionStyle;
import 'package:vendor/src/version.dart' show packageVersion;

part 'config.g.dart';

const _defaultIncludePatterns = {
  'pubspec.yaml',
  'README.md',
  'LICENSE',
  'CHANGELOG.md',
  'lib/**',
  'analysis_options.yaml',
};

/// State of the `lib/src/third_party/` folder, stored in
/// `lib/src/third_party/vendor-state.yaml`.
///
/// This maintainly contains the [VendorConfig] from last time `dart run vendor`
/// was executed, along with the version of `package:vendor` that was used.
/// The purpose of this information is to allow `dart run vendor` to vendor
/// additional packages without unnecessarily stripping changes to vendored
/// files.
@sealed
abstract class VendorState {
  Version get version;
  VendorConfig get config;

  static VendorState fromYaml(
    String yaml, {
    Uri? sourceUri,
  }) =>
      checkedYamlDecode(
        yaml,
        (m) => _VendorState.fromJson(m!),
        sourceUrl: sourceUri,
        allowNull: false,
      );

  /// Load [VendorState] from YAML, usually read from
  /// `lib/src/third_party/vendor-state.yaml`.
  static VendorState fromConfig(VendorConfig config) => _VendorState(
        Version.parse(packageVersion),
        config as _VendorConfig,
      );

  String toYaml();

  /// Initial vendoring state for a project without a `vendor-state.yaml`.
  static VendorState get empty => fromConfig(_VendorConfig({}, {}));
}

/// Configuration of the desired state for vendored packages.
///
/// This is stored in `vendor.yaml`.
@sealed
abstract class VendorConfig {
  /// A map from _package name_ to _vendored package name_, to be rewritten in
  /// the root package.
  ///
  /// **Example:** The following example will rewrite `package:foo/...` into
  /// `lib/src/third_party/bar/...`.
  /// ```
  /// rewrites:
  ///   foo: bar
  /// ```
  Map<String, String> get rewrites;

  /// A map from _vendored package name_ to [VendoredSource] which specifies
  /// package, version and rewrites for the package to be vendored.
  ///
  /// A _vendored package name_ is the name of the folder in:
  /// `lib/src/third_party/` which contains the vendored package.
  Map<String, VendoredSource> get dependencies;

  /// Load [VendorConfig] from YAML, usually stored in `vendor.yaml`.
  static VendorConfig fromYaml(
    String yaml, {
    Uri? sourceUri,
  }) =>
      checkedYamlDecode(
        yaml,
        (m) => _VendorConfig.fromJson(m!),
        sourceUrl: sourceUri,
        allowNull: false,
      );

  @override
  bool operator ==(Object other) {
    if (other is! VendorConfig) {
      return false;
    }
    if (rewrites.length != other.rewrites.length) {
      return false;
    }
    for (final entry in rewrites.entries) {
      if (other.rewrites[entry.key] != entry.value) {
        return false;
      }
    }
    if (dependencies.length != other.dependencies.length) {
      return false;
    }
    for (final entry in dependencies.entries) {
      if (other.dependencies[entry.key] != entry.value) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(
        Object.hashAllUnordered(rewrites.entries.map((e) => Object.hash(
              e.key,
              e.value,
            ))),
        Object.hashAllUnordered(dependencies.entries.map((e) => Object.hash(
              e.key,
              e.value,
            ))),
      );
}

/// Configuration of the contents for a vendored package.
///
/// The [VendoredSource] object contains the information necessary to create the
/// contents of a vendored package folder.
@sealed
abstract class VendoredSource {
  /// Name of package to vendored from `pub.dev`.
  String get package;

  /// Version of [package] to be vendored from `pub.dev`.
  Version get version;

  /// A map from _package name_ to _vendored package name_, to be rewritten in
  /// this _vendored package_.
  ///
  /// **Example:** The following example will rewrite `package:foo/...` into
  /// `lib/src/third_party/bar/...`.
  /// ```
  /// rewrites:
  ///   foo: bar
  /// ```
  Map<String, String> get rewrites;

  /// List of patterns for files/folders to include when vendoring.
  ///
  /// File patterns syntax hews closely to Bash glob-syntax, for details see:
  /// https://pub.dev/packages/glob
  ///
  /// Filenames are relative to the root of the vendored package.
  ///
  /// If not specified this defaults to:
  ///  * `pubspec.yaml`,
  ///  * `README.md`,
  ///  * `LICENSE`,
  ///  * `CHANGELOG.md`,
  ///  * `lib/**`, and,
  ///  * `analysis_options.yaml`.
  ///
  /// See [_defaultIncludePatterns].
  Set<String> get include;

  @override
  bool operator ==(Object other) {
    if (other is! VendoredSource) {
      return false;
    }
    if (rewrites.length != other.rewrites.length) {
      return false;
    }
    for (final entry in rewrites.entries) {
      if (other.rewrites[entry.key] != entry.value) {
        return false;
      }
    }
    if (!include.containsAll(other.include) ||
        !other.include.containsAll(include)) {
      return false;
    }
    return package == other.package && version == other.version;
  }

  @override
  int get hashCode => Object.hash(
        package,
        version,
        Object.hashAllUnordered(rewrites.entries.map((e) => Object.hash(
              e.key,
              e.value,
            ))),
        Object.hashAllUnordered(include),
      );
}

@JsonSerializable(
  anyMap: true,
  checked: true,
  disallowUnrecognizedKeys: true,
  includeIfNull: false,
)
class _VendorState extends VendorState {
  @override
  @JsonKey(
    required: true,
    fromJson: _versionFromJson,
    toJson: _versionToJson,
  )
  final Version version;

  @override
  @JsonKey(required: true)
  final _VendorConfig config;

  _VendorState(this.version, this.config);

  static _VendorState fromJson(Map json) => _$VendorStateFromJson(json);

  @override
  String toYaml() {
    // Encode / decode JSON to ensure that _VendorConfig.toJson() is called
    final raw = json.decode(json.encode(_$VendorStateToJson(this)));
    final e = YamlEditor('');
    e.update([], wrapAsYamlNode(raw, collectionStyle: CollectionStyle.BLOCK));
    return [
      '# DO NOT EDIT: This file is generated by package:vendor version $packageVersion',
      e.toString(),
      '', // Always end with a newline
    ].join('\n');
  }
}

@JsonSerializable(
  anyMap: true,
  checked: true,
  disallowUnrecognizedKeys: true,
  includeIfNull: false,
)
class _VendorConfig extends VendorConfig {
  @override
  @JsonKey(
    required: false,
    defaultValue: <String, String>{},
    name: 'import_rewrites',
  )
  final Map<String, String> rewrites;

  @override
  @JsonKey(
    required: false,
    name: 'vendored_dependencies',
    defaultValue: <String, _VendoredSource>{},
    toJson: _dependenciesToJson,
  )
  Map<String, _VendoredSource> dependencies;

  _VendorConfig(
    Map<String, String> rewrites,
    Map<String, _VendoredSource> dependencies,
  )   : rewrites = Map.unmodifiable(rewrites),
        dependencies = Map.unmodifiable(dependencies) {
    ArgumentError.checkNotNull(rewrites, 'rewrites');
    ArgumentError.checkNotNull(dependencies, 'dependencies');
  }

  static _VendorConfig fromJson(Map json) => _$VendorConfigFromJson(json);

  Map<String, dynamic> toJson() => _$VendorConfigToJson(this);
}

Map<String, Object> _dependenciesToJson(Map<String, _VendoredSource> deps) =>
    deps.map((name, source) => MapEntry(name, _$VendoredSourceToJson(source)));

@JsonSerializable(
  anyMap: true,
  checked: true,
  disallowUnrecognizedKeys: true,
  includeIfNull: false,
)
class _VendoredSource extends VendoredSource {
  @override
  @JsonKey(required: true)
  final String package;

  @override
  @JsonKey(
    required: true,
    fromJson: _versionFromJson,
    toJson: _versionToJson,
  )
  final Version version;

  @override
  @JsonKey(
    required: false,
    defaultValue: <String, String>{},
    name: 'import_rewrites',
  )
  final Map<String, String> rewrites;

  @override
  @JsonKey(
    required: false,
    defaultValue: <String>{
      ..._defaultIncludePatterns,
    },
    name: 'include',
  )
  final Set<String> include;

  _VendoredSource({
    required this.package,
    required this.version,
    required Map<String, String> rewrites,
    required Set<String> include,
  })  : rewrites = Map.unmodifiable(rewrites),
        include = Set.unmodifiable(include);

  static _VendoredSource fromJson(Map json) => _$VendoredSourceFromJson(json);
}

String _versionToJson(Version v) => v.toString();
Version _versionFromJson(Object s) {
  if (s is String) {
    return Version.parse(s);
  }
  throw FormatException('version must be a string');
}
