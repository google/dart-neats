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

/// Outline of a package that can be serialized to JSON and used on-the-fly when
/// aiming to check if an older version of a package contains an identifier that
/// is being used.
/// In this scenario you'd have a [PackageOutline] of the older version, and
/// an analysis session with resolved dependencies for the current version.
library;

import 'package:pub_semver/pub_semver.dart';

// TODO: Don't call these object Outline or Summary these words are already used!

final class PackageOutline {
  String get name => throw UnimplementedError();
  Version get version => throw UnimplementedError();

  /// List of public libraries in this package.
  ///
  /// This does not include libraries from `lib/src/`.
  Iterable<LibraryOutline> get libraries => throw UnimplementedError();
}

final class LibraryOutline {
  /// Uri for this library, on the form `package:<package>/path/to/file.dart`.
  Uri get uri => throw UnimplementedError();

  /// List of exported elements.
  ///
  /// This includes all public top-level elements defined in this library, and
  /// elements exported from other libraries in this package.
  Iterable<LibraryElementOutline> get elements => throw UnimplementedError();
}

sealed class LibraryElementOutline {
  final String name;

  /// List of libraries that that this element is exported from.
  ///
  /// TODO: Unclear if we need this? it might be the best/only way to find out
  ///       which Foo is the same between two package versions.
  Iterable<LibraryOutline> get exportedFrom => throw UnimplementedError();

  LibraryElementOutline({required this.name});
}

final class FunctionOutline extends LibraryElementOutline {
  // TODO: Add outline of position and named parameters.

  FunctionOutline({
    required super.name,
  });
}

final class EnumOutline extends LibraryElementOutline {
  EnumOutline({required super.name});
}

final class ClassOutline extends LibraryElementOutline {
  ClassOutline({required super.name});
}

final class MixinOutline extends LibraryElementOutline {
  MixinOutline({required super.name});
}

final class ExtensionOutline extends LibraryElementOutline {
  ExtensionOutline({required super.name});
}

final class FunctionTypeAliasOutline extends LibraryElementOutline {
  FunctionTypeAliasOutline({required super.name});
}

final class ClassTypeAliasOutline extends LibraryElementOutline {
  ClassTypeAliasOutline({required super.name});
}

final class VariableOutline extends LibraryElementOutline {
  final bool hasGetter;
  final bool hasSetter;

  VariableOutline({
    required super.name,
    required this.hasGetter,
    required this.hasSetter,
  });
}
