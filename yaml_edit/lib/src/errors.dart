// Copyright 2020 Garett Tok Ern Liang
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

import 'package:meta/meta.dart';
import 'package:yaml/yaml.dart';

/// Error thrown when a function is passed an invalid path.
@sealed
class PathError extends ArgumentError {
  /// The full path that caused the error
  final Iterable<Object> path;

  /// The subpath that caused the error
  final Iterable<Object> subPath;

  /// The last element of [path] that could be traversed.
  YamlNode parent;

  PathError(this.path, this.subPath, this.parent, [String message])
      : super.value(subPath, 'path', message);

  PathError.unexpected(this.path, String message)
      : subPath = path,
        super(message);

  @override
  String toString() {
    if (message == null) {
      var errorMessage = 'Failed to traverse to subpath $subPath!';

      if (subPath.isNotEmpty) {
        errorMessage +=
            ' Parent $parent does not contain key or index ${subPath.last}';
      }

      return 'Invalid path: $path. $errorMessage.';
    }

    return 'Invalid path: $path. $message';
  }
}

/// Error thrown when the path contains an alias along the way.
///
/// When a path contains an aliased node, the behavior becomes less well-defined
/// because we cannot be certain if the user wishes for the change to
/// propagate throughout all the other aliased nodes, or if the user wishes
/// for only that particular node to be modified. As such, [AliasError] reflects
/// the detection that our change will impact an alias, and we do not intend
/// on supporting such changes for the foreseeable future.
@sealed
class AliasError extends UnsupportedError {
  /// The path that caused the error
  final Iterable<Object> path;

  /// The anchor node of the alias
  final YamlNode anchor;

  AliasError(this.path, this.anchor)
      : super('Encountered an alias node along $path! '
            'Alias nodes are nodes that refer to a previously serialized nodes, '
            'and are denoted by either the "*" or the "&" indicators in the '
            'original YAML. As the resulting behavior of mutations on these '
            'nodes is not well-defined, the operation will not be supported '
            'by this library.\n\n'
            '${anchor.span.message('The alias was first defined here.')}');
}

/// Error thrown when an assertion about the YAML fails. Extends
/// [AssertionError] to override the [toString] method for pretty printing.
class YamlAssertionError extends AssertionError {
  YamlAssertionError(message) : super(message);

  @override
  String toString() {
    if (message != null) {
      return 'Assertion failed: ${message}';
    }
    return 'Assertion failed';
  }
}

/// Throws an [AssertionError] with the given [message], and format
/// [oldYaml] and [newYaml] for information.
@alwaysThrows
void createAssertionError(String message, String oldYaml, String newYaml) {
  throw YamlAssertionError('''
Internal error in package:yaml_edit -- $message.

# Initial Yaml:
> ${oldYaml.replaceAll('\n', '\n> ')}

# Final Yaml:
> ${newYaml.replaceAll('\n', '\n> ')}

Please file an issue at:\n
'''
      'https://github.com/google/dart-neats/issues/new?labels=pkg%3Ayaml_edit'
      '%2C+pending-triage&template=yaml_edit.md');
}
