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

import 'dart:io' show File;

import 'package:http/http.dart' show Client;
import 'package:meta/meta.dart';

abstract class Context {
  /// Path to the root package folder on the current file-system.
  Uri get rootPackageFolder;

  /// Get an HTTP [Client] for making requests.
  Client get client;

  /// Print a warning [message].
  ///
  /// This will highlighted in _bold red_ colors, if supported by the output
  /// terminal.
  void warning(String message);

  /// Print an information [message].
  ///
  /// Messages starting with `#` will be logged as sections in _bold_, if
  /// supported by the output terminal.
  void log(String message);

  /// Default hosted package repository to fetch packages from.
  ///
  /// This should generally be:
  ///  * `$PUB_HOSTED_URL`, if specified, otherwise:
  ///  * `https://pub.dartlang.org/`.
  Uri get defaultHostedUrl;

  /// Get a [File] object for [path] relative to [rootPackageFolder].
  @nonVirtual
  File file(String path) => File.fromUri(rootPackageFolder.resolve(path));
}
