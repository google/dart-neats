// Copyright 2025 Google LLC
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

/// @docImport 'dart:typed_data';
/// @docImport 'package:meta/meta.dart';
/// @docImport '../typed_sql.dart';
library;

/// Interface to be implemented by custom types that can be stored in a [Row]
/// for automatic (de)-serialization.
///
/// Subclasses must:
///  * specify a concrete `T` that will be the serialized representation type. As one of:
///    - [String],
///    - [Uint8List],
///    - [bool],
///    - [int],
///    - [double], or,
///    - [DateTime].
///  * have a `fromDatabase(T value)` constructor.
///
/// If a subclass implements [Comparable] then the encoded values returned by
/// [toDatabase] **must** also be comparable and have the same ordering!
///
/// > [!TIP]
/// > Custom types are not required to be _immutable_ but using an immutable
/// > type is recommended. The analyzer can help with you this if you use the
/// > [immutable] annotation from [`package:meta`][1].
///
/// [1]: https://pub.dev/packages/meta
///
/// {@category schema}
/// {@category custom_data_types}
abstract interface class CustomDataType<T extends Object?> {
  T toDatabase();
}
