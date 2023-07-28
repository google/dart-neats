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

import 'package:pub_semver/pub_semver.dart';

class PackageShape {
  final String name;
  final Version version;
  final List<String> topLevelNames = [];

  PackageShape({
    required this.name,
    required this.version,
  });

  factory PackageShape.fromJson(Object? json) {
    if (json is! Map<String, Object?>) {
      throw FormatException('root must be a map');
    }
    final name = json['name'];
    if (name is! String) {
      throw FormatException('name must be a string');
    }
    final version = json['version'];
    if (version is! String) {
      throw FormatException('version must be a string');
    }
    final topLevelNames = json['topLevelNames'];
    if (topLevelNames is! List<Object?>) {
      throw FormatException('topLevelNames must be a list');
    }
    final shape = PackageShape(name: name, version: Version.parse(version));
    for (final n in topLevelNames) {
      if (n is! String) {
        throw FormatException('names must be String');
      }
      shape.topLevelNames.add(n);
    }
    return shape;
  }

  Map<String, Object?> toJson() => {
        'name': name,
        'version': version.toString(),
        'topLevelNames': topLevelNames,
      };
}
